allClinics = -> window.Application.clinics
insuranceTypeKey = "Types of Insurance Accepted (Private, Medicaid, Uninsured)"

knownDistances = []
findKnownDistance = (origin, c) ->
	knownDistances[origin] && knownDistances[origin][getFullAddress(c)]

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

		return alert("No results found") if(!currentlyFound.length)
		
		street = $('[name=street] ', page).val()
		changePage '#results-page', 
			clinics: currentlyFound
			origin: street.replace(/\W/g, '') && (street+" "+$('[name=city]', page).val())

onShow '#results-page', (model)->
	template = $('#item-template', this)
	cloneTemplate = -> template.clone().removeAttr('id')
	origin = model.origin

	if origin
		lookUpAddresses = _.difference(_.map(model.clinics, getFullAddress), knownDistances[origin])

		Application.Mapping.getDistances(origin, lookUpAddresses).done (foundAddresses)->
			knownDistances[origin] = knownDistances[origin]||{}
			$.extend knownDistances[origin], _.zipHash(lookUpAddresses, _.pluck(foundAddresses, 'text'))


	results = $('ul.results-list', this).empty();
	_.each model.clinics, (c) ->
		$el = cloneTemplate()
		showDistance = (distance)-> $('.distance-display', $el).slideDown().find('.distance').text(distance)
		showDistance(findKnownDistance(origin, c)) if findKnownDistance(origin, c)

		bindClinic(c, $el.show()
			.data(showDistance: showDistance)
			.click( -> changePage '#details-page', c)
		).appendTo(results)
	results.listview 'refresh'

onShow '#details-page', (clinic) ->
	$page = $(this)
	strippedPhone = (clinic.Phone||"").replace(/[^\d]/g,'')

	bindClinic clinic, $page

	$page.find('.provider-Phone-link')
		.val "tel:#{strippedPhone}"