distanceFinderOptions =  (origin, destinations) ->
	origins: [origin] 
	destinations: destinations
	travelMode: google.maps.TravelMode.WALKING,
	avoidHighways: true,
	unitSystem: google.maps.UnitSystem.IMPERIAL

geocoder = new google.maps.Geocoder()
distances = new google.maps.DistanceMatrixService()
mapping = 
	geocodeLocation: (address) -> #returns a jquery deferred so this doesn't turn into callback soup		
		$.Deferred (d) -> 
			geocoder.geocode address: address, (results, status) ->
				if(status != google.maps.GeocoderStatus.OK)
					return console.error "Geocode failed", address, results, status
				d.resolve results[0].geometry.location
	getDistance: (origin, destinations) ->
		$.Deferred (d) ->
			geocodeAddresses = _.map [origin].concat(destinations), mapping.geocodeLocation
			$.when.apply($, geocodeAddresses).done (origin, destinations...) ->
				distances.getDistanceMatrix distanceFinderOptions(origin, destinations), (response, status) ->
					if(status != google.maps.DistanceMatrixStatus.OK)
						return console.error "Distance matrix failed", origin, destinations, response, status
					d.resolve _.pluck(response.rows[0].elements, 'distance')

window.Application = window.Application || {}
$.extend window.Application, Mapping: mapping		