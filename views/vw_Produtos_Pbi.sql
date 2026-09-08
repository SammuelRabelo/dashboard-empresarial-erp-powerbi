CREATE VIEW [dbo].[vw_Produtos_Pbi]
AS
SELECT
    -- ==========================================
    -- CHAVE PRIMÁRIA
    -- ==========================================
    produto.codigo AS Codigo_Produto,

    -- ==========================================
    -- IDENTIFICAÇÃO
    -- ==========================================
    produto.nome AS Nome_Produto,
    produto.codigo_fabricante AS Codigo_Fabricante_Produto,

    -- ==========================================
    -- CLASSIFICAÇÃO
    -- ==========================================
    produto.claspro_codigo_1 AS Codigo_Classificacao_Produto,
    claspro.nome AS Nome_Classificacao_Produto,
    produto.classificacao_fiscal AS NCM,

    -- ==========================================
    -- FABRICANTE
    -- ==========================================
    produto.fabr_codigo AS Codigo_Fabricante,
    fabricante.nome AS Nome_Fabricante,

    -- ==========================================
    -- UNIDADE BASE (referencia para conversao)
    -- Os precos abaixo (custo e venda) estao nesta unidade
    -- ==========================================
    produto.unid_unidade AS Unidade_Original,

    -- ==========================================
    -- PREÇOS NA UNIDADE ORIGINAL
    -- ==========================================
    produto.preco_venda AS Preco_Venda,
    produto.preco_custo AS Preco_Custo,
    produto.preco_custo_real AS Preco_Custo_Real,
    'EmpresaEx' AS Empresa

FROM produto
LEFT JOIN fabricante
    ON fabricante.codigo = produto.fabr_codigo
LEFT JOIN classificacao_produto AS claspro
    ON claspro.codigo = produto.claspro_codigo_1;
GO
