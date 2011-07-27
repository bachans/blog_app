module SessionsHelper

	# desc : sign in the user and set the cookie
	# params: user.id and user.salt
	def sign_in(user)
		#after sign in the cookie store the remember token as user.id and user.salt
		cookies.permanent.signed[:remember_token] = [user.id, user.salt]	
		#Now the current user is that user who has signed in
		current_user = user
	end
	
	def current_user
		#
		@current_user ||= user_from_remember_token
	end
	
	def signed_in?
		!current_user.nil?
	end
	
	def sign_out
		reset_session
		cookies.delete(:remember_token)
		current_user = nil
	end
	
	#def current_user?(user)
	#	user == current_user
	#end
	
	def deny_access
		store_location
		redirect_to signin_path, :notice => "Please sign in to access this page."
	end
	
	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		clear_return_to
	end
	
	private
		def user_from_remember_token
			#remember_token returns an array
			# * -> makes the elements of that array as argument
			User.authenticate_with_salt(*remember_token)
		end
		
		def remember_token
			cookies.signed[:remember_token] || [nil, nil]
		end
		
		def store_location
			session[:return_to] = request.fullpath
		end
		
		def clear_return_to
			session[:return_to] = nil
		end
	
end