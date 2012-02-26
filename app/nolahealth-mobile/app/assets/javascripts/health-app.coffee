allClinics = -> window.Application.clinics
insuranceTypeKey = "Types of Insurance Accepted (Private, Medicaid, Uninsured)"

getClinic = (idx) =>
	clinic = {}
	_.each allClinics(), (values, prop) -> clinic[prop] = values[idx]
	clinic
bindClinic = (clinic, $el) -> 
	_.each clinic, (v, k) -> 
		$el.find("[data-bindTo='#{k}']").text( ((v||"")+"") )
	$el

states = ( ->
	currentlyFound = []
	currentlySelected = null

	setCurrentlyFound: (found)-> 
		if(!(found&&found.length))
			return false
		currentlyFound = found
		true	
	setCurrentlySelected: (c) => currentlySelected = c	
	getCurrentlyFound: (found) -> _.first(currentlyFound, 5)
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
		$.mobile.changePage '#results-page'

$('#results-page').live 'pageshow', ->
	template = $('#item-template', this)
	results = $('ul.results-list', this);
	_(states.getCurrentlyFound()).chain()
		.map((c) -> 
			bindClinic c, template.clone().show().click ->
				states.setCurrentlySelected c
				$.mobile.changePage '#details-page'
			)
		.each(($c) -> results.append($c))
	results.listview 'refresh'

$('#details-page').live 'pageshow', ->
	$page = $(this)
	clinic = states.getCurrentlySelected()||{}
	strippedPhone = (clinic.Phone||"").replace(/[^\d]/g,'')

	bindClinic clinic, $page

	$page.find('.provider-Phone-link')
		.val "tel:#{strippedPhone}"