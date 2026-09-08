CREATE   VIEW [dbo].[vw_Comissoes_BI]
AS
SELECT
    nf.numero_nota                        AS Numero_Nota,
    CAST(nf.datahora_emissao_nfe AS DATE) AS Data_Emissao_NF,
    com_nf.vend_codigo                    AS Codigo_Vendedor,
    ven.nome                              AS Nome_Vendedor,
    com_ctrl.valor                        AS Valor_Comissao,
    com_ctrl.data_liberacao               AS Data_Liberacao_Comissao,
    'EmpresaEx'                             AS Empresa

FROM comissao_venda_nota_fiscal AS com_nf
INNER JOIN nota_fiscal_venda AS nf
        ON nf.codigo = com_nf.nf_codigo
LEFT JOIN Comissao_Controle AS com_ctrl
        ON TRY_CAST(
               SUBSTRING(
                   com_ctrl.Historico,
                   CHARINDEX('N.Fiscal ', com_ctrl.Historico) + LEN('N.Fiscal '),
                   15
               ) AS INT
           ) = nf.numero_nota
       AND com_ctrl.vend_codigo = com_nf.vend_codigo
LEFT JOIN vendedor AS ven
        ON ven.codigo = com_nf.vend_codigo;
GO


