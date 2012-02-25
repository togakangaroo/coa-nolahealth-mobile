getClinic = (idx) =>
	clinic = {}
	_.each window.Application.clinics, (values, prop) -> clinic[prop] = values[idx]
	clinic
		 
#_.templateSettings = interpolate : /\{\{(.+?)\}\}/g

$('#details-page').live 'pageinit', ->
	clinic = getClinic 4
	#compileTemplate = _.template $('#clinic-details-template', this).html()
	console.log 'page', this, arguments, clinic
	#$('.details-area', this).empty().append compileTemplate(clinic)
