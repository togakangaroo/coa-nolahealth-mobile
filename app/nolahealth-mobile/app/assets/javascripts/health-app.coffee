getClinic = (idx) =>
	clinic = {}
	_.each window.Application.clinics, (values, prop) -> clinic[prop] = values[idx]
	clinic
		 
$('#details-page').live 'pageinit', ->
	$page = $(this)
	clinic = getClinic 4
	strippedPhone = (clinic.Phone||"").replace(/[^\d]/g,'')

	_.each clinic, (v, k) -> 
		$page.find("[data-bindTo='#{k}']").text( ((v||"")+"").replace('\n', '<br />') )
	$page.find('.provider-Phone-link')
		.val "tel:#{strippedPhone}"