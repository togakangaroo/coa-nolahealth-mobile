showAtATime = 5
allClinics = -> window.Application.clinics
insuranceTypeKey = "Types of Insurance Accepted (Private, Medicaid, Uninsured)"

knownDistances = []

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
	geolocated = null

	$('button[name=geolocate]').click ->
		navigator && navigator.geolocation && navigator.geolocation.getCurrentPosition (
			(position) -> 
				geolocated = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
				$('.origin', page)					
					.find('[name=street]').val("<Current Location>").end()
					.find('input').prop('disabled', true)
				), ((err) -> console.error 'error geolocating', err)
	$('button[type=submit]').click (e) ->
		e.preventDefault()

		pageInteraction = $.Deferred().done (res) ->
			changePage '#results-page', res

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

		return alert("No results found") if(!currentlyFound.length)
		
		street = $('[name=street] ', page).val()
		origin = geolocated || street.replace(/\W/g, '') && (street+" "+$('[name=city]', page).val())
		if origin
			lookUpAddresses = _.difference(_.map(currentlyFound, getFullAddress), knownDistances[origin])
			lookUpAddresses.length && Application.Mapping.getDistances(origin, lookUpAddresses).done (foundAddresses)->
				knownDistances[origin] = knownDistances[origin]||{}
				$.extend knownDistances[origin], _.zipHash(lookUpAddresses, _.map(foundAddresses, (a)-> a&&a.text))
				pageInteraction.resolve 
					clinics: currentlyFound
					distances: knownDistances[origin]
		else
			pageInteraction.resolve clinics:currentlyFound
			

onShow '#results-page', (model)->
	template = $('#item-template', this)
	cloneTemplate = -> template.clone().removeAttr('id')
	results = $('ul.results-list', this)
	distances = model.distances || {}
	clinicDistances = _.chain(model.clinics)
		.map((c) -> [c, distances[getFullAddress(c)]])
		.sortBy((cd) -> parseFloat(cd[1], 10))
		.first(showAtATime)
		.value()

	results.empty();
	_.each clinicDistances, (cd) ->
		$el = cloneTemplate()
		
		bindClinic(cd[0], $el).appendTo(results)
		cd[1] && $('.distance-display', $el).show().find('.distance').text(cd[1])

		$el.show().click -> changePage '#details-page', cd[0]

	results.listview 'refresh'

onShow '#details-page', (clinic) ->
	$page = $(this)
	strippedPhone = (clinic.Phone||"").replace(/[^\d]/g,'')

	bindClinic clinic, $page

	$page.find('.provider-Phone-link')
		.attr 'href', "tel:#{strippedPhone}"
	clinic.Website && $page.find('.agency').wrap "<a href='http://#{clinic.Website}' target='_blank'>"
	
	$('a.link-to-loc').click (e) ->
		e.preventDefault()
		window.open('http://maps.google.com?q=' + clinic.lat + ',' + clinic.lng + '+(' + clinic.Agency + ')')
