allClinics = -> window.Application.clinics
insuranceTypeKey = "Types of Insurance Accepted (Private, Medicaid, Uninsured)"

getClinic = (idx) =>
	clinic = {}
	_.each allClinics(), (values, prop) -> clinic[prop] = values[idx]
	clinic

states = ( ->
	currentlyFound = []
	currentlySelected = null

	setCurrentlyFound: (found)-> 
		if(!(found&&found.length))
			return false
		currentlyFound = found
		currentlySelected = found[Math.floor(currentlyFound.length*Math.random())]
		true		
	getCurrentlyFound: (found) -> currentlyFound
	getCurrentlySelected: () -> currentlySelected
)()
	 
$('#start-page').live 'pageinit', ->
	$('button[type=submit]').click (e) ->
		e.preventDefault()
		searchFor = _.pluck(
			$(".insurance-type input[type=checkbox]")
				.filter(-> $(this).prop('checked'))
				.toArray(), 
			'name')
		anyMatches = _.bind _.any, _, searchFor
		foundMatrix = _.map allClinics()[insuranceTypeKey], (insurance) -> 
			anyMatches (term)->  new RegExp(term, "i").test(insurance)
		foundIndicies = _.compact(_.map foundMatrix, (v, i) -> v && i || null)
		currentlyFound = _.map foundIndicies, getClinic

		if(!states.setCurrentlyFound(currentlyFound))
			return alert "No results found"
		$.mobile.changePage '#details-page'

$('#details-page').live 'pageshow', ->
	$page = $(this)
	clinic = states.getCurrentlySelected()||{}
	strippedPhone = (clinic.Phone||"").replace(/[^\d]/g,'')

	_.each clinic, (v, k) -> 
		$page.find("[data-bindTo='#{k}']").text( ((v||"")+"") )
	$page.find('.provider-Phone-link')
		.val "tel:#{strippedPhone}"