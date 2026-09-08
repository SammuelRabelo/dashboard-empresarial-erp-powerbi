CREATE VIEW [dbo].[vw_telemarketing_Pbi] AS
SELECT
	tele.codigo AS CODIGO_AGENDAMENTO_GERAL,
	tele.clifor_codigo AS CODIGO_CLIENTE,
	tele.crmtel_codigo AS CODIGO_AGENDAMENTO_INTERNO,
	tele.crmtag_codigo_origem AS ADIAMENTO,
	tele.data_contato AS DATA_AGENDAMENTO,
	tele.contato AS CONTATO,
	tele.observacao AS OBSERVACAO,
	CASE tele.id_situacao
		WHEN 1 THEN 'Agendado'
		WHEN 2 THEN 'Finalizado'
		WHEN 3 THEN 'Adiado'
		WHEN 5 THEN 'Excluído'
	END ID_SITUACAO,
	tele.data_ocorrencia AS DATA_REGISTRO,
	'EmpresaEx' AS Empresa
FROM crm_telemarketing_agendamento AS tele
GO
