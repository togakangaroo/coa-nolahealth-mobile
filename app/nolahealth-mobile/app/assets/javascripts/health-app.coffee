allClinics = -> window.Application.clinics
insuranceTypes = -> allClinics()["Types of Insurance Accepted (Private, Medicaid, Uninsured)"]

getClinic = (idx) =>
	clinic = {}
	_.each allClinics(), (values, prop) -> clinic[prop] = values[idx]
	clinic
		 
$('#start-page').live 'pageinit', ->
	$('button[type=submit]').click (e) ->
		e.preventDefault()
		searchFor = _.pluck(
			$(".insurance-type input[type=checkbox]")
				.filter(-> $(this).prop('checked'))
				.toArray(), 
			'name')
		anyMatches = _.bind _.any, _, searchFor
		foundMatrix = _.map insuranceTypes(), (insurance) -> anyMatches((term)-> new RegExp(term, "i").test(insurance))
		foundIndicies = _.compact(_.map foundMatrix, (v, i) -> v && i || null)
		found = _.map foundIndicies, getClinic
		console.log('found', foundMatrix, foundIndicies, found)
		$.mobile.changePage '#details-page'

$('#details-page').live 'pageinit', ->
	$page = $(this)
	clinic = getClinic 4
	strippedPhone = (clinic.Phone||"").replace(/[^\d]/g,'')

	_.each clinic, (v, k) -> 
		$page.find("[data-bindTo='#{k}']").text( ((v||"")+"").replace('\n', '<br />') )
	$page.find('.provider-Phone-link')
		.val "tel:#{strippedPhone}"