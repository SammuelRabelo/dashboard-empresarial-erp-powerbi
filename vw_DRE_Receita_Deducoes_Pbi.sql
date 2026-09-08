CREATE   VIEW [dbo].[vw_DRE_Receita_Deducoes_Pbi]
AS

/* ================================================================
   BLOCO 1 — RECEITA E DEDUÇÕES, DIRETO DA NOTA FISCAL DE MERCADORIA
   ================================================================ */
SELECT
    'EmpresaEx'                              AS Empresa,
    CAST(nf.data AS DATE)                  AS Data_DRE,
    'Receita Bruta - Mercadoria'           AS Grupo_DRE,
    nf.valor_total                         AS Valor_Lancamento
FROM nota_fiscal_venda AS nf
INNER JOIN tipo_nota_fiscal AS tnf ON tnf.codigo = nf.tiponf_codigo
WHERE nf.id_situacao_nfe = 4
  AND tnf.ind_faturamento = 1
  AND nf.ind_venda IN (1, 4)

UNION ALL

SELECT
    'EmpresaEx',
    CAST(nf.data AS DATE),
    'Deducao - PIS',
    -nfi.pis_valor
FROM nota_fiscal_venda_item AS nfi
INNER JOIN nota_fiscal_venda AS nf ON nf.codigo = nfi.nf_numero
INNER JOIN tipo_nota_fiscal AS tnf ON tnf.codigo = nf.tiponf_codigo
WHERE nf.id_situacao_nfe = 4
  AND nf.id_entrada_saida = 2

UNION ALL

SELECT
    'EmpresaEx',
    CAST(nf.data AS DATE),
    'Deducao - COFINS',
    -nfi.cofins_valor
FROM nota_fiscal_venda_item AS nfi
INNER JOIN nota_fiscal_venda AS nf ON nf.codigo = nfi.nf_numero
INNER JOIN tipo_nota_fiscal AS tnf ON tnf.codigo = nf.tiponf_codigo
WHERE nf.id_situacao_nfe = 4
  AND nf.id_entrada_saida = 2

UNION ALL

SELECT
    'EmpresaEx',
    CAST(nf.data AS DATE),
    'Deducao - ICMS',
    -nf.valor_icms
FROM nota_fiscal_venda AS nf
INNER JOIN tipo_nota_fiscal AS tnf ON tnf.codigo = nf.tiponf_codigo
WHERE nf.id_situacao_nfe = 4
  AND nf.id_entrada_saida = 2

UNION ALL

SELECT
    'EmpresaEx',
    CAST(nf.data AS DATE),
    'Deducao - ST',
    -nf.valor_icms_substituicao
FROM nota_fiscal_venda AS nf
INNER JOIN tipo_nota_fiscal AS tnf ON tnf.codigo = nf.tiponf_codigo
WHERE nf.id_situacao_nfe = 4
  AND nf.id_entrada_saida = 2

/* ================================================================
   BLOCO 2 — RECEITA E DEDUÇÕES, DIRETO DA NOTA DE SERVIÇO (NFS-e)
   ================================================================ */
UNION ALL

SELECT
    'EmpresaEx',
    CAST(ns.data_emissao AS DATE),
    'Receita Bruta - Servico',
    ns.valor_servico
FROM nfse_nota AS ns
INNER JOIN nfse_tipo AS nt ON nt.codigo = ns.nfse_tipo_codigo
WHERE ns.id_situacao = 4
  AND nt.ind_faturamento = 1

UNION ALL

SELECT
    'EmpresaEx',
    CAST(ns.data_emissao AS DATE),
    'Deducao - ISS',
    -ns.valor_iss
FROM nfse_nota AS ns
INNER JOIN nfse_tipo AS nt ON nt.codigo = ns.nfse_tipo_codigo
WHERE ns.id_situacao = 4
  AND nt.ind_faturamento = 1

UNION ALL

SELECT
    'EmpresaEx',
    CAST(ns.data_emissao AS DATE),
    'Deducao - Retencoes Federais Servico',
    -(ISNULL(ns.valor_cofins, 0) + ISNULL(ns.valor_csll, 0)
      + ISNULL(ns.valor_inss, 0) + ISNULL(ns.valor_ir, 0)
      + ISNULL(ns.valor_pis, 0))
FROM nfse_nota AS ns
INNER JOIN nfse_tipo AS nt ON nt.codigo = ns.nfse_tipo_codigo
WHERE ns.id_situacao = 4

GO
