allClinics = -> window.Application.clinics
insuranceTypeKey = "Types of Insurance Accepted (Private, Medicaid, Uninsured)"

window.knownDistances = []

onEvent = (eventType, id, callback) -> 
	$(document).on eventType, id, -> callback.call(this, $(this).data('page-data'))
onCreate = _.bind onEvent, window, 'pageinit'
onShow = _.bind onEvent, window, 'pageshow'

changePage = (id, data) ->
	$(id).data 'page-data', data
	$.mobile.changePage id

getFullAddress = (c)-> s = " ";c.Address+s+c.City+s+c.State+s+c['Zip Code']
getClinic = (idx) ->
	clinic = {}
	_.each allClinics(), (values, prop) -> clinic[prop] = values[idx]
	clinic
bindClinic = (clinic, $el) -> 
	_.each clinic, (v, k) -> 
		$el.find("[data-bindTo='#{k}']").text( ((v||"")+"") )
	$el

onCreate '#start-page', ->
	page = this
	$('button[type=submit]').click (e) ->
		e.preventDefault()

		street = $('[name=street] ', page).val()
		origin = street+" "+$('[name=city]', page).val()

		searchFor = _.pluck(
			$(".insurance-type input[type=checkbox]")
				.filter(-> $(this).prop('checked'))
				.toArray(), 
			'name')
		anyMatches = _.bind _.any, _, searchFor
		foundMatrix = _.map allClinics()[insuranceTypeKey], (insurance) -> 
			anyMatches (term)->  new RegExp(term, "i").test(insurance)
		foundIndicies = _.compact(_.map foundMatrix, (v, i) -> v && i || null)
		currentlyFound = _.map _.first(foundIndicies, 5), getClinic

		locationEntered = -> !!street.replace(' ', '')
		if locationEntered()
			lookUpAddresses = _.difference(_.map(currentlyFound, getFullAddress), knownDistances[origin])

			Application.Mapping.getDistances(origin, lookUpAddresses).done (foundAddresses)->
				knownDistances[origin] = knownDistances[origin]||{}
				$.extend knownDistances[origin], _.zipHash(lookUpAddresses, foundAddresses)

		if(!currentlyFound.length)
			return alert "No results found"
		changePage '#results-page', currentlyFound

onShow '#results-page', (currentlyFound)->
	template = $('#item-template', this)
	results = $('ul.results-list', this).empty();
	_.chain(currentlyFound).map((c) -> 
			bindClinic c, template.clone().show().click ->
				changePage '#details-page', c
			)
		.each(($c) -> results.append($c))
	results.listview 'refresh'

onShow '#details-page', (clinic) ->
	$page = $(this)
	strippedPhone = (clinic.Phone||"").replace(/[^\d]/g,'')

	bindClinic clinic, $page

	$page.find('.provider-Phone-link')
		.val "tel:#{strippedPhone}"