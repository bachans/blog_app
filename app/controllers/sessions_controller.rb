class SessionsController < ApplicationController
	def new
		if not signed_in?
			
		else
			redirect_to userhome_path
		end
	end
		
	#create will handle the login
	#post to '/sessions'
	def create
		if not signed_in?
			#check the user authentication using email and password
			user = User.authenticate(params[:session][:login_id],
									params[:session][:password])
			
			# if user is not authenticated
			if user.nil?
				flash[:error_login] = "Invalid email/password combination."
			
				# sign in
				#@title = "Sign in"
				redirect_to root_path
			else
				#if a valid name and password then signin user // defined in session_helper
				sign_in user
				#redirect_back_or user
				redirect_to userhome_path
			end
		else
			redirect_to userhome_path
		end
		
	end
	
	def destroy
		sign_out
		redirect_to root_path
	end
	
end
