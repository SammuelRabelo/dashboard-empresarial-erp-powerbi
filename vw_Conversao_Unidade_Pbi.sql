CREATE VIEW [dbo].[vw_Conversao_Unidade_Pbi]
AS
SELECT
    prod_codigo AS Codigo_Produto,
    unidade_convertida AS Unidade_Convertida,
    multiplicador AS Multiplicador
FROM produto_unidade_conversao;
GO
