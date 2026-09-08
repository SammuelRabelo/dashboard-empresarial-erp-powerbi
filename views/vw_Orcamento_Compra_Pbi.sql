CREATE VIEW [dbo].[vw_Orcamento_Compra_Pbi]
AS
SELECT
    -- ==========================================
    -- IDENTIFICACAO
    -- ==========================================
    oc.codigo AS Numero_OC,
    oc.data AS Data_OC,

    -- ==========================================
    -- STATUS - detalhado e agrupado
    -- ==========================================
    CASE oc.id_situacao
        WHEN 1 THEN 'CADASTRADA'
        WHEN 2 THEN 'APROVADA'
        WHEN 3 THEN 'LIBERADA'
        WHEN 4 THEN 'CONFIRMADA'
        WHEN 5 THEN 'CONCRETIZADA'
        WHEN 6 THEN 'CANCELADA'
    END AS Status_OC,

    CASE oc.id_situacao
        WHEN 1 THEN 'Rascunho'                     -- Cadastrada: nao indica intencao firme
        WHEN 2 THEN 'Pendente'                     -- Aprovada internamente
        WHEN 3 THEN 'Pendente'                     -- Liberada financeiramente
        WHEN 4 THEN 'Pendente'                     -- Confirmada com fornecedor
        WHEN 5 THEN 'Concretizada'                 -- Recebida e faturada
        WHEN 6 THEN 'Cancelada'
    END AS Grupo_Status,

    -- ==========================================
    -- FKs (chaves para dimensoes)
    -- ==========================================
    oc.clifor_codigo AS Codigo_Fornecedor,         -- relaciona com vw_Fornecedores_Pbi
    oci.prod_codigo AS Codigo_Produto,             -- relaciona com vw_Produtos_Pbi

    -- ==========================================
    -- ITEM DA OC
    -- ==========================================
    oci.quantidade AS Quantidade,
    oci.valor_unitario AS Valor_Unitario,
    oci.quantidade * oci.valor_unitario AS Valor_Total_Item,

    -- ==========================================
    -- VALOR TOTAL DO CABECALHO (auditoria)
    -- ==========================================
    oc.valor_total AS Valor_Total_OC,              -- redundante com SUM(Valor_Total_Item) mas util para validar consistencia

    -- ==========================================
    -- EMPRESA
    -- ==========================================
    'EmpresaEx' AS Empresa

FROM orcamento_compra AS oc
LEFT JOIN orcamento_compra_item AS oci
    ON oc.codigo = oci.oritc_codigo

WHERE
    oc.tpcomp_codigo = 1;   -- Filtra apenas ORDENS DE COMPRA (descarta orcamentos/cotacoes)
GO
