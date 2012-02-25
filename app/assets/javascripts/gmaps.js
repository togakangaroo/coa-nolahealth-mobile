function get_distance(origin_address, dest_address)
{
	/* Geocode each address */
	var geocoder = new google.maps.Geocoder();
	var origin = null;
	var destination = null;

	geocoder.geocode( {'address': origin_address}, function(results, status){
		if (status == google.maps.GeocoderStatus.OK) {
			origin = results[0].geometry.location;
			geocoder.geocode( {'address': dest_address}, function(results, status){
				if (status == google.maps.GeocoderStatus.OK) {
					destination = results[0].geometry.location;
					if (origin != null && destination != null) {
						var service = new google.maps.DistanceMatrixService();
						service.getDistanceMatrix({
							origins: [origin],
							destinations: [destination],
							travelMode: google.maps.TravelMode.WALKING,
							avoidHighways: false,
							unitSystem: google.maps.UnitSystem.IMPERIAL
						}, function(response, status){
							if (status == google.maps.DistanceMatrixStatus.OK)
							{
								for (var i = 0; i < response.originAddresses.length; i++) {
									var results = response.rows[i].elements;
									for (var j = 0; j < results.length; j++) {
										alert("Distance: " + results[j].distance.text)
									}
								}
							}
						});
					}
				} else {
					alert("Geocode failed: " + status);
				}
			});
		} else {
			alert("Geocode failed: " + status);
		}
	});

	return 0.0;
}