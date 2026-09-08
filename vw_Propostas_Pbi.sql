CREATE VIEW [dbo].[vw_Propostas_Pbi]
AS

WITH HistoricoOrcamento AS (
    SELECT
        orc_codigo,
        historico
    FROM orcamento_follow_up
    WHERE historico LIKE '%Gerado pedido n%'
)
SELECT
    -- ==========================================
    -- DADOS DA PROPOSTA
    -- ==========================================
    pro.codigo AS Codigo_Proposta,
    pro.data AS Data_Emissao_Proposta,
    pro.clifor_codigo AS Codigo_Cliente,
    pro.valor_total AS Valor_Total_Proposta,
    pro.Vend_codigo AS Codigo_Vendedor,

    -- Status e categorização
    CASE
        WHEN pro.id_situacao = 1 THEN 'Fechado'
        WHEN pro.id_situacao = 2 THEN 'Em Andamento'
        WHEN pro.id_situacao = 4 THEN 'Perdido'
    END AS Status_Situacao,
    tpro.nome AS Tipo_Proposta,
    mperda.motivo AS Motivo_Perda,

    -- ==========================================
    -- DADOS DO PEDIDO (gerado a partir da proposta)
    -- ==========================================
    TRY_CAST(
        SUBSTRING(
            hist_orc.historico,
            CHARINDEX('Gerado pedido nº', hist_orc.historico) + LEN('Gerado pedido nº'),
            15
        ) AS INT
    ) AS Numero_Pedido,
    ped.data AS Data_Emissao_Pedido,

    -- ==========================================
    -- DATA DA NOTA (única coluna de nota que é usada — para tempo do ciclo)
    -- ==========================================
    CAST(nfv.datahora_emissao_nfe AS DATE) AS Data_Emissao_Nota_Fiscal,

    -- ==========================================
    -- EMPRESA
    -- ==========================================
    'EmpresaEx' AS Empresa

FROM orcamento AS pro
LEFT JOIN tipo_proposta AS tpro              ON pro.tipopro_codigo = tpro.codigo
LEFT JOIN orcamento_perda AS perda           ON perda.orc_codigo = pro.codigo
LEFT JOIN crm_motivo_perda AS mperda         ON perda.crmmotper_codigo = mperda.codigo
LEFT JOIN HistoricoOrcamento AS hist_orc     ON pro.codigo = hist_orc.orc_codigo
LEFT JOIN pedido AS ped
    ON TRY_CAST(
        SUBSTRING(
            hist_orc.historico,
            CHARINDEX('Gerado pedido nº', hist_orc.historico) + LEN('Gerado pedido nº'),
            15
        ) AS INT
    ) = ped.codigo
LEFT JOIN pedido_nota_fiscal AS pnf          ON ped.codigo = pnf.ped_codigo
LEFT JOIN nota_fiscal_venda AS nfv           ON pnf.nf_codigo = nfv.codigo
GO
