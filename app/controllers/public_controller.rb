=begin
	Public controller
	it is for the users who are not logged into the application.
=end
class PublicController < ApplicationController
  
	# check the session before any action
	before_filter :check_session
  
	def home
		@title = 'Welcome to Blog App'
	end
	
	def register
		@title = 'Register Here'
		@user = User.new
	end
	
	def registration
		
		@user = User.new(params[:user])
		if verify_recaptcha(request.remote_ip, params)[:status] == 'false'
			@title = 'Registration Failed...'
			render 'register'
		else
			if @user.save
				flash[:success] = 'You can login to the application'
				redirect_to root_path
			else
				@title = 'Registration Failed...'
				render 'register'
			end
		end
		
	end

	private
	
	def check_session
		if signed_in?
			redirect_to userhome_path
		end
	end
  
end
