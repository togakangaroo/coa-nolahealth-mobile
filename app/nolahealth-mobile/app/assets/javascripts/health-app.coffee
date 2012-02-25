_.templateSettings = interpolate : /\{\{(.+?)\}\}/g

$('#details-page').live 'pageinit', ->
	clinic = 
		"Agency": "St. Charles Community Health Ctr."
		"Address": "843 Miling Ave"
		"City": "Luling"
		"State": "LA"
		"Zip Code": "70116"
		"Neighborhood": "Luling"
		"Hours": "Monday-Thursday: 8:00AM-5:00PM Friday: 8:00AM-12:00PM Saturday: 9:00AM-1:00PM"
		"Medical Services - Expanded": "Adult & Pediatric Primary Care, Labs, OB, Gyn, Family Planning, Podiatry, Vision, Dental, Psychiatry, Counseling, Individual, Group & Family Therapy, Substance Abuse"
		"Additional Health Services": "Nutritional counseling, Health education, "
		"Phone": "(985) 785-5800"

	console.log 'loaded page', this, arguments
	console.log _.template($('#clinic-details-template', this).html())(clinic)
