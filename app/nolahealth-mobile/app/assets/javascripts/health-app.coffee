getClinic = (idx) =>
	clinic = {}
	_.each window.Application.clinics, (values, prop) -> clinic[prop] = values[idx]
	clinic
		 
$('#details-page').live 'pageinit', ->
	clinic = getClinic 4
	strippedPhone = (clinic.Phone||"").replace(/[^\d]/g,'')

	providerArea = $('.provider-details', this) 
	_.each clinic, (v, k) -> providerArea.find("[data-bindTo='#{k}']").text(v)
	providerArea.find('.provider-Phone-link')
		.val "tel:#{strippedPhone}"