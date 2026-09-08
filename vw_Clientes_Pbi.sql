CREATE VIEW [dbo].[vw_Clientes_Pbi]
AS
SELECT
    -- ==========================================
    -- IDENTIFICACAO
    -- ==========================================
    cli.codigo AS Codigo_Cliente,                       -- chave primaria
    cli.nome AS Nome_Cliente,
    cli.cnpj AS Cnpj_Cliente,

    -- ==========================================
    -- CLASSIFICACAO COMERCIAL
    -- ==========================================
    ccli.nome AS Classificacao_Cliente,                 -- ex: Orgao Publico, Orgao Privado

    -- ==========================================
    -- LOCALIZACAO
    -- ==========================================
    cli.cep AS Cep_Cliente,
    cidade.nome AS Cidade,
    cli.uf_sigla AS UF,
    regiao.nome AS Regiao,                              -- agrupamento comercial (Sul, Sudeste, etc.)

    -- ==========================================
    -- DATAS
    -- ==========================================
    cli.data_cadastro AS Data_Cadastro_Cliente

FROM cliente_fornecedor AS cli
LEFT JOIN classificacao_cliente AS ccli
    ON ccli.codigo = cli.clascli_codigo_1
LEFT JOIN cidade
    ON cidade.codigo = cli.cid_codigo
LEFT JOIN regiao
    ON regiao.codigo = cli.regi_codigo
WHERE
    cli.ind_cliente = 1;
GO


