CREATE VIEW [dbo].[vw_Pedidos_Pbi]
AS
SELECT
    -- ==========================================
    -- IDENTIFICAÇÃO DO PEDIDO
    -- ==========================================
    pedido.codigo AS Numero_Pedido,
    pedido.data AS Data_Emissao,
    pedido.data_entrega AS Data_Entrega,

    -- ==========================================
    -- CLASSIFICAÇÃO DO PEDIDO
    -- ==========================================
    CASE pedido.id_situacao
        WHEN 1 THEN 'CADASTRADO'
        WHEN 2 THEN 'PEND FINANCEIRO'
        WHEN 3 THEN 'CONFIRMADO'
        WHEN 4 THEN 'CONCRETIZADO'
        WHEN 6 THEN 'DEVOLVIDO'
        WHEN 7 THEN 'DOCUM PENDENTE'
    END AS Situacao,

    tipo_pedido.nome AS Tipo_de_Pedido,                  -- mantido como texto: pequena cardinalidade, nao vale criar dimensao

    CASE pedido.id_pedido_empenho
        WHEN 1 THEN 'PEDIDO'
        WHEN 2 THEN 'EMPENHO'
    END AS Pedido_Empenho,

    -- ==========================================
    -- FKs (chaves para dimensoes)
    -- ==========================================
    pedido.clifor_codigo AS Codigo_Cliente,              -- relaciona com vw_Clientes_Pbi
    pedido.vend_codigo AS Codigo_Vendedor,               -- relaciona com vw_Vendedores_Pbi
    pedido_item.prod_codigo AS Codigo_Produto,           -- relaciona com vw_Produtos_Pbi

    -- ==========================================
    -- ITEM DO PEDIDO
    -- ==========================================
    pedido_item.unid_unidade_comercializacao AS Unidade,
    pedido_item.quantidade_comercializacao AS Quantidade,
    CONVERT(DECIMAL(10,2), pedido_item.valor_unitario_comercializacao) AS Valor_Unitario,
    pedido_item.valor_custo AS Valor_Custo_Unitario,
    pedido_item.quantidade_comercializacao
        * CONVERT(DECIMAL(10,2), pedido_item.valor_unitario_comercializacao)
        AS Valor_Total_Item,

    -- Valor liquido considerando desconto/acrescimo proporcional do pedido
    (
        pedido_item.quantidade_comercializacao
        * CONVERT(DECIMAL(10,2), pedido_item.valor_unitario_comercializacao)
    )
    + (
        CONVERT(DECIMAL(10,2),
            pedido_item.quantidade_comercializacao
            * CONVERT(DECIMAL(10,2), pedido_item.valor_unitario_comercializacao)
            / ISNULL(NULLIF(
                (SELECT SUM(pitem.quantidade_comercializacao
                            * CONVERT(DECIMAL(10,2), pitem.valor_unitario_comercializacao))
                 FROM pedido_item pitem
                 WHERE pitem.ped_codigo = pedido_item.ped_codigo), 0), 1)
            * pedido.valor_desconto_acrescimo
            * CASE pedido.id_desconto_acrescimo WHEN 1 THEN -1 ELSE 1 END
        )
    ) AS Valor_Total_Item_Liquido,

    -- ==========================================
    -- CONDIÇÕES COMERCIAIS
    -- ==========================================
    condicao_pagamento.nome AS Condicao_de_Pagamento,    -- mantida como texto: usada como filtro direto
    cobranca.nome AS Forma_de_Cobranca,                  -- mantida como texto: usada como filtro direto

    -- ==========================================
    -- EMPRESA (hardcoded - ajustar conforme banco)
    -- ==========================================
    'EmpresaEx' AS Empresa

FROM pedido
    INNER JOIN pedido_item
        ON pedido_item.ped_codigo = pedido.codigo
    LEFT JOIN tipo_pedido
        ON tipo_pedido.codigo = pedido.tipoped_codigo
    LEFT JOIN condicao_pagamento
        ON condicao_pagamento.codigo = pedido.condpg_codigo
    LEFT JOIN cobranca
        ON cobranca.codigo = pedido.cob_codigo

WHERE
    pedido.id_situacao <> 5;   -- exclui cancelados (mesmo filtro da view original)
GO
