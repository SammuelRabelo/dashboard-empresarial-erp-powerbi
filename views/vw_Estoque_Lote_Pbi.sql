CREATE VIEW [dbo].[vw_Estoque_Lote_Pbi] AS
SELECT
    -- ==========================================
    -- CHAVE PARA vw_Produtos_Pbi (dimensão)
    -- ==========================================
    produto.codigo AS Codigo_Produto,

    -- ==========================================
    -- DADOS DO LOTE (exclusivos da fato)
    -- ==========================================
    lote.numero AS Lote,
    lote.data_validade AS Validade,
    ISNULL(lote.quantidade, 0) AS Quantidade_Estoque,

    -- ==========================================
    -- EMPRESA
    -- ==========================================
    'EmpresaEx' AS Empresa

FROM produto
JOIN lote
    ON lote.prod_codigo = produto.codigo
   AND lote.quantidade <> 0       -- somente lotes com saldo
WHERE
    ISNULL(produto.quantidade_estoque, 0) > 0;
GO
