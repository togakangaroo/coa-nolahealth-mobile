module ContentHelper
	def providers_to_json(providers)
		# Build a hash of arrays in the format expected by the client-side JS
		# Key names are expected by health-app.coffee.
		data = {
			"Organization" => [],
			"Agency" => [],
			"Address" => [],
			"City" => [],
			"State" => [],
			"Zip Code" => [],
			"Neighborhood" => [],
			"Parish" => [],
			"Phone" => [],
			"Website" => [],
			"Hours" => [],
			"Medical Services - Expanded" => [],
			"Additional Health Services" => [],
			"Social Services" => [],
			"Type of Services" => [],
			"Dental" => [],
			"Optometry" => [],
			"Specialties" => [],
			"Pharmacy Services" => [],
			"Population/Age" => [],
			"Languages" => [],
			"Types of Insurance Accepted (Private, Medicaid, Uninsured)" => [],
			"Medicaid Enrollment?" => [],
			"Payment" => [],
			"504HealthNet Member" => [],
			"lat" => [],
			"lng" => [],
		}

		# Populate the individual arrays from the Provider objects
		providers.each do |p|
			data["Organization"] << p.organization
			data["Agency"] << p.agency
			data["Address"] << p.address
			data["City"] << p.city
			data["State"] << p.state
			data["Zip Code"] << p.zipcode
			data["Neighborhood"] << p.neighborhood
			data["Parish"] << p.parish
			data["Phone"] << p.phone
			data["Website"] << p.website
			data["Hours"] << p.hours
			data["Medical Services - Expanded"] << p.medical_services
			data["Additional Health Services"] << p.additional_services
			data["Social Services"] << p.social_services
			data["Type of Services"] << p.service_types
			data["Dental"] << bool_to_s(p.dental)
			data["Optometry"] << bool_to_s(p.optometry)
			data["Specialties"] << p.specialties
			data["Pharmacy Services"] << p.pharmacy_services
			data["Population/Age"] << p.population_types
			data["Languages"] << p.languages
			data["Types of Insurance Accepted (Private, Medicaid, Uninsured)"] << p.insurance_types
			data["Medicaid Enrollment?"] << bool_to_s(p.medicaid)
			data["Payment"] << p.payment
			data["504HealthNet Member"] << bool_to_s(p.healthnet_member)
			data["lat"] << p.lat
			data["lng"] << p.lng

		end

		# Emit the data as JSON.
		# NOTE: the lat/lng numerics are emitted as strings, not doubles/floats. This is a decision made by
		#       the Rails krewe; see http://stackoverflow.com/questions/6128794/rails-json-serialization-of-decimal-adds-quotes
		#       and http://api.rubyonrails.org/classes/BigDecimal.html#method-i-as_json.
		#       Essentially they're trying to avoid rounding errors. - rcs
		data.to_json
	end
	
	def bool_to_s(b)
		b ? "Yes" : "No"  # TODO: Localized string literals
	end

end