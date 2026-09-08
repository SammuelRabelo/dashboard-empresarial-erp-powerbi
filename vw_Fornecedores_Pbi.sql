CREATE VIEW [dbo].[vw_Fornecedores_Pbi]
AS
SELECT
    -- ==========================================
    -- IDENTIFICACAO
    -- ==========================================
    forn.codigo AS Codigo_Fornecedor,
    forn.nome AS Nome_Fornecedor,
    forn.cnpj AS Cnpj_Fornecedor,

    -- ==========================================
    -- LOCALIZACAO
    -- ==========================================
    cidade.nome AS Cidade,
    forn.uf_sigla AS UF,
    regiao.nome AS Regiao

FROM cliente_fornecedor AS forn
LEFT JOIN cidade
    ON cidade.codigo = forn.cid_codigo
LEFT JOIN regiao
    ON regiao.codigo = forn.regi_codigo
WHERE
    forn.ind_fornecedor = 1;
GO
