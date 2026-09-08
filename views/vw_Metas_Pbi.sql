CREATE   VIEW [dbo].[vw_Metas_Pbi] AS

WITH Cfg AS (
    SELECT 'EmpresaEx' AS Empresa
),
Cab AS (
    SELECT
        mv.codigo,
        mv.nome,
        mv.ind_vigente,
        mv.fabr_codigo,
        mv.data_inicio AS Periodo_Inicio_Texto,
        mv.data_fim    AS Periodo_Fim_Texto,
        DATEFROMPARTS(
            TRY_CAST(RIGHT(mv.data_inicio, 4) AS INT),
            TRY_CAST(LEFT (mv.data_inicio, 2) AS INT), 1) AS Data_Inicio_Meta,
        EOMONTH(DATEFROMPARTS(
            TRY_CAST(RIGHT(mv.data_fim, 4) AS INT),
            TRY_CAST(LEFT (mv.data_fim, 2) AS INT), 1))    AS Data_Fim_Meta,
        mv.valor      AS Meta_Valor_Periodo,
        mv.quantidade AS Meta_Quantidade_Periodo
    FROM dbo.meta_venda mv
)

/* Nivel 1: total do periodo (cabecalho da meta) */
SELECT
    g.Empresa,
    g.Empresa + '-' + CAST(c.codigo AS VARCHAR(20)) AS Chave_Meta,
    c.codigo                  AS Codigo_Meta,
    c.nome                    AS Nome_Meta,
    c.ind_vigente             AS Vigente,
    c.fabr_codigo             AS Codigo_Fabricante,
    c.Data_Inicio_Meta,
    c.Data_Fim_Meta,
    'Empresa'                 AS Nivel_Meta,
    CAST(NULL AS INT)         AS Codigo_Vendedor,
    CAST(NULL AS VARCHAR(20)) AS Codigo_Produto,
    CAST(NULL AS INT)         AS Codigo_Classificacao,
    CAST(NULL AS INT)         AS Ano,
    CAST(NULL AS INT)         AS Mes,
    CAST(NULL AS DATE)        AS Data_Meta,
    c.Meta_Valor_Periodo      AS Meta_Valor,
    c.Meta_Quantidade_Periodo AS Meta_Quantidade
FROM Cab c CROSS JOIN Cfg g

UNION ALL

/* Nivel 2: mensal por classificacao de produto */
SELECT
    g.Empresa,
    g.Empresa + '-' + CAST(c.codigo AS VARCHAR(20)),
    c.codigo, c.nome, c.ind_vigente, c.fabr_codigo,
    c.Data_Inicio_Meta, c.Data_Fim_Meta,
    'Classificacao',
    NULL, NULL, x.claspro_codigo,
    x.ano, x.mes, DATEFROMPARTS(x.ano, x.mes, 1),
    x.valor, x.quantidade
FROM dbo.meta_venda_classificacao_produto x
INNER JOIN Cab c ON c.codigo = x.mven_codigo
CROSS JOIN Cfg g

UNION ALL

/* Nivel 3: mensal por produto */
SELECT
    g.Empresa,
    g.Empresa + '-' + CAST(c.codigo AS VARCHAR(20)),
    c.codigo, c.nome, c.ind_vigente, c.fabr_codigo,
    c.Data_Inicio_Meta, c.Data_Fim_Meta,
    'Produto',
    NULL, x.prod_codigo, NULL,
    x.ano, x.mes, DATEFROMPARTS(x.ano, x.mes, 1),
    x.valor, x.quantidade
FROM dbo.meta_venda_produto x
INNER JOIN Cab c ON c.codigo = x.mven_codigo
CROSS JOIN Cfg g

UNION ALL

/* Nivel 4: mensal por vendedor */
SELECT
    g.Empresa,
    g.Empresa + '-' + CAST(c.codigo AS VARCHAR(20)),
    c.codigo, c.nome, c.ind_vigente, c.fabr_codigo,
    c.Data_Inicio_Meta, c.Data_Fim_Meta,
    'Vendedor',
    x.vend_codigo, NULL, NULL,
    x.ano, x.mes, DATEFROMPARTS(x.ano, x.mes, 1),
    x.valor, x.quantidade
FROM dbo.meta_venda_vendedor x
INNER JOIN Cab c ON c.codigo = x.mven_codigo
CROSS JOIN Cfg g

UNION ALL

/* Nivel 5: mensal por vendedor e produto */
SELECT
    g.Empresa,
    g.Empresa + '-' + CAST(c.codigo AS VARCHAR(20)),
    c.codigo, c.nome, c.ind_vigente, c.fabr_codigo,
    c.Data_Inicio_Meta, c.Data_Fim_Meta,
    'Vendedor x Produto',
    x.mvve_vend_codigo, x.prod_codigo, NULL,
    x.ano, x.mes, DATEFROMPARTS(x.ano, x.mes, 1),
    x.valor, x.quantidade
FROM dbo.meta_venda_vendedor_produto x
INNER JOIN Cab c ON c.codigo = x.mvve_mven_codigo
CROSS JOIN Cfg g

UNION ALL

/* Nivel 6: mensal por vendedor e classificacao */
SELECT
    g.Empresa,
    g.Empresa + '-' + CAST(c.codigo AS VARCHAR(20)),
    c.codigo, c.nome, c.ind_vigente, c.fabr_codigo,
    c.Data_Inicio_Meta, c.Data_Fim_Meta,
    'Vendedor x Classificacao',
    x.mvve_vend_codigo, NULL, x.claspro_codigo,
    x.ano, x.mes, DATEFROMPARTS(x.ano, x.mes, 1),
    x.valor, x.quantidade
FROM dbo.meta_venda_vendedor_classificacao_produto x
INNER JOIN Cab c ON c.codigo = x.mvve_mven_codigo
CROSS JOIN Cfg g
GO
