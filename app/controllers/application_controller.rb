class ApplicationController < ActionController::Base
	# Devise authentication verif
	before_action :authenticate_user!
end
