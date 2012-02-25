getClinic = (idx) =>
	clinic = {}
	_.each window.Application.clinics, (values, prop) -> clinic[prop] = values[idx]
	clinic
		 
$('#start-page').live 'pageinit', ->
	$('button[type=submit]').click (e) ->
		e.preventDefault()
		searchFor = _.pluck(
			$(".insurance-type input[type=checkbox]")
				.filter(-> $(this).prop('checked'))
				.toArray(), 
			'name')
		$.mobile.changePage '#details-page'

$('#details-page').live 'pageinit', ->
	$page = $(this)
	clinic = getClinic 4
	strippedPhone = (clinic.Phone||"").replace(/[^\d]/g,'')

	_.each clinic, (v, k) -> 
		$page.find("[data-bindTo='#{k}']").text( ((v||"")+"").replace('\n', '<br />') )
	$page.find('.provider-Phone-link')
		.val "tel:#{strippedPhone}"