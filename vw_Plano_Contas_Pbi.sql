CREATE VIEW [dbo].[vw_Plano_Contas_Pbi]
AS
SELECT
    pc.codigo                    AS Codigo,
    pc.plan_codigo               AS Plan_Codigo,
    pc.nome                      AS Nome,
    pc.id_sintetica_analitica    AS Id_Sintetica_Analitica,
    'EmpresaEx'                    AS Empresa
FROM plano_conta pc;
GO
