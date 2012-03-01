class ContentController < ApplicationController
	caches_page :index

	def index
		@providers = Provider.all
	end

end
