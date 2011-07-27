class PrivateController < ApplicationController
	# check the session before any action
	before_filter :check_session
	
	def home
		@title = 'Welcome to home'
	end
	
	def settings
		@title = 'Change your profile...'
		@user = current_user
	end
	
	def update
		@user = current_user
		if params[:user][:password].strip == ''	
		
			if @user.update_attributes(params[:user])
				flash[:success] = "Profile updated."
				redirect_to userhome_path
			else
				@title = "Error on updating..."
				render 'settings'
			end
		else
			if params[:user][:password].length > 5
				if params[:user][:password] == params[:user][:password_confirmation]
					if @user.update_attributes(params[:user])
						flash[:success] = "Profile updated."
						redirect_to userhome_path
					else
						@title = "Error on updating..."
						render 'settings'
					end
					
				else
					@title = "Error on updating..."
					@user.errors.add(:please, "retype the password again")
					render 'settings'
				end
			else
				@title = "Error on updating..."
				@user.errors.add(:password, "is too sort. It should at least contails 6 characters")
				render 'settings'
			end
		end
	end
	
	private
	
	def check_session
		if not signed_in?
			redirect_to root_path
		end
	end
	
end
