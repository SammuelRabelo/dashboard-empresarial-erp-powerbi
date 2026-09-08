CREATE   VIEW [dbo].[vw_NotaServico_BI]
AS
SELECT
    ns.numero_nota                          AS Numero_Nota,
    ns.numero_rps                           AS Numero_RPS,
    CAST(ns.data_emissao AS DATE)           AS Data_Emissao_NFS,
    CAST(ns.data_competencia AS DATE)       AS Data_Competencia,

    CASE ns.id_situacao
        WHEN 1 THEN 'Emitida'
        WHEN 2 THEN 'Transmitida'
        WHEN 3 THEN 'Cancelada'
        WHEN 4 THEN 'Autorizada'
        WHEN 5 THEN 'Denegada'
        WHEN 6 THEN 'Cancelada'
    END                                     AS Situacao_Nota,

    nt.nome                                 AS Tipo_Nota_Servico,
    CASE WHEN ISNULL(ns.ind_nota_locacao, 0) = 1
         THEN 'Locacao' ELSE 'Servico' END  AS Natureza_Receita,

    ns.clifor_codigo_tomador                AS Codigo_Cliente,
    ns.vend_codigo                          AS Codigo_Vendedor,
    ns.prod_codigo                          AS Codigo_Produto,
    ns.quantidade                           AS Quantidade_Item,

    ns.valor_servico                        AS Valor_Servico,
    ns.valor_liquido                        AS Valor_Liquido,
    ns.valor_deducao                        AS Valor_Deducao,
    ns.valor_iss                            AS Valor_ISS,
    ns.valor_pis                            AS Valor_PIS,
    ns.valor_cofins                         AS Valor_COFINS,
    ns.valor_inss                           AS Valor_INSS,
    ns.valor_ir                             AS Valor_IR,
    ns.valor_csll                           AS Valor_CSLL,
    ns.discriminacao                        AS Descricao_Servico,

    'EmpresaEx'                               AS Empresa

FROM nfse_nota AS ns
INNER JOIN nfse_tipo AS nt
        ON nt.codigo = ns.nfse_tipo_codigo
WHERE nt.ind_faturamento = 1
GO


