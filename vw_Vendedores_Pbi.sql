CREATE VIEW [dbo].[vw_Vendedores_Pbi] AS
SELECT
    -- ==========================================
    -- DADOS DO VENDEDOR
    -- ==========================================
    codigo AS Codigo_Vendedor,
    nome AS Nome_Vendedor
FROM 
    vendedor;
GO
