class ProvidersController < ApplicationController
	def index
		@providers = Provider.all
	end

	def new
		@provider = Provider.new
	end
	
	def create
		@provider = Provider.new(params[:provider])
		@provider.save!
		redirect_to providers_url
	end

end
