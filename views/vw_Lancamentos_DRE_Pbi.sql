CREATE VIEW [dbo].[vw_Lancamentos_DRE_Pbi]
AS
SELECT
    lf.parc_cont_codigo         AS Conta_Codigo,
    lf.parc_codigo              AS Parcela_Codigo,
    lf.plan_codigo_debito       AS Codigo_Plano_Debito,
    pcd.nome                    AS Plano_Contas_Debito,
    lf.plan_codigo_credito      AS Codigo_Plano_Credito,
    pcc.nome                    AS Plano_Contas_Credito,
    lf.valor                    AS Valor_Lancamento,
    lf.data_competencia         AS Data_Competencia,   -- ← principal pro DRE
    lf.Data                     AS Data_Lancamento,     -- ← data do pagamento (fluxo de caixa)
    'EmpresaEx'                   AS Empresa
FROM lancamento_financeiro lf
LEFT JOIN plano_conta pcd ON pcd.codigo = lf.plan_codigo_debito
LEFT JOIN plano_conta pcc ON pcc.codigo = lf.plan_codigo_credito
GO
