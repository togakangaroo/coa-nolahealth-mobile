maxDestinations = 24
deferred = (init) -> $.Deferred(init).promise()
distanceFinderOptions =  (origin, destinations) ->
	origins: [origin] 
	destinations: destinations
	travelMode: google.maps.TravelMode.WALKING,
	avoidHighways: true,
	unitSystem: google.maps.UnitSystem.IMPERIAL

geocoder = new google.maps.Geocoder()
distances = new google.maps.DistanceMatrixService()
getAllDistances = (origin, destinations) ->
	deferred (d) ->
			distances.getDistanceMatrix distanceFinderOptions(origin, destinations), (response, status) ->
				if(status != google.maps.DistanceMatrixStatus.OK)
					return console.error "Distance matrix failed", origin, destinations, response, status
				d.resolve _.pluck(response.rows[0].elements, 'distance')

mapping = 
	geocodeLocation: (address) -> #returns a jquery deferred so this doesn't turn into callback soup		
		deferred (d) -> 
			geocoder.geocode address: address, (results, status) ->
				if(status != google.maps.GeocoderStatus.OK)
					return console.error "Geocode failed", address, results, status
				d.resolve results[0].geometry.location
	getDistances: (origin, destinations) ->
		deferred (d) ->
			requests = _.map _.sliceChunks(destinations, maxDestinations), _.bind(getAllDistances, null, origin)
			$.when.apply($, requests).done -> d.resolve _.flatten(arguments)

window.Application = window.Application || {}
$.extend window.Application, Mapping: mapping		