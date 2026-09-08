CREATE VIEW [dbo].[vw_Visitas_Pbi] AS
SELECT
	vis.clifor_codigo AS CODIGO_CLIENTE,
	vis.codigo AS CODIGO,
	CASE vis.id_situacao
		WHEN 1 THEN 'Agendamento'
		WHEN 2 THEN 'Visita'
	END AS ID_SITUACAO,
	mot_vis.nome AS MOTIVO_VISITA,
	vis.data_marcacao AS DATA_MARCACAO,
	vis.data AS DATA_AGENDADA,
	vis.duracao AS DURACAO,
	vis.contato AS CONTATO,
	vis.obs_visitante AS OBS_VISITANTE,
	vis.obs_visitado AS OBS_CLIENTE,
	vis.vend_codigo AS COD_VENDEDOR,
	vis.hora AS HORA_VISITA,
	'EmpresaEx' AS Empresa
FROM crm_visita vis
LEFT JOIN crm_visita_motivo AS vis_mot ON vis.codigo = vis_mot.crmvis_codigo
LEFT JOIN crm_motivo_visita AS mot_vis ON vis_mot.crmmot_codigo = mot_vis.codigo
GO
