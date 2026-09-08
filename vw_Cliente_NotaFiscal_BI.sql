CREATE VIEW [dbo].[vw_Cliente_NotaFiscal_BI]
AS
SELECT
    cli.codigo                            AS Codigo_Cliente,

    nf.numero_nota                        AS Numero_Nota,
    nf.valor_total_produtos               AS Valor_Total_Produtos_Nota,
    nf.valor_total                        AS Valor_Total_Nota,
    CAST(nf.datahora_emissao_nfe AS DATE) AS Data_Emissao_NF,

    CASE nf.situacao
        WHEN 1 THEN 'Emitida'
        WHEN 2 THEN 'Transmitida'
        WHEN 3 THEN 'Cancelada'
        WHEN 4 THEN 'Inutilizada'
        WHEN 5 THEN 'Denegada'
    END                                   AS Situacao_Nota,

    tnf.nome                              AS Tipo_de_Nota_Fiscal,
    nf.vend_codigo                        AS Codigo_Vendedor,
    ven.nome                              AS Nome_Vendedor,

    nf_item.prod_codigo                   AS Codigo_Produto,
    nf_item.unidade                       AS Unidade_Venda,
    nf_item.quantidade                    AS Quantidade_Item,
    nf_item.valor_total                   AS Valor_Total_Produto,

    (SELECT MIN(pfq.clifor_codigo)
       FROM produto_fornecedor_qualificado AS pfq
      WHERE pfq.prod_codigo = nf_item.prod_codigo)
                                          AS Codigo_Fornecedor,

    fab.codigo                            AS Codigo_Fabricante_Item,

    'EmpresaEx'                             AS Empresa

FROM nota_fiscal_venda AS nf
INNER JOIN cliente_fornecedor AS cli
        ON cli.codigo = nf.clifor_codigo
       AND cli.ind_cliente = 1
INNER JOIN nota_fiscal_venda_item AS nf_item
        ON nf_item.nf_numero = nf.codigo
LEFT JOIN tipo_nota_fiscal AS tnf
        ON tnf.codigo = nf.tiponf_codigo
LEFT JOIN vendedor AS ven
        ON ven.codigo = nf.vend_codigo
LEFT JOIN fabricante AS fab
        ON fab.codigo = nf_item.fabr_codigo_adicao_di;
GO


