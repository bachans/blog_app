class ApplicationController < ActionController::Base
	protect_from_forgery
	include SessionsHelper
	
	# before going to any action perform these tasks
	before_filter :set_cache_buster, :set_session_check
	
	# remove cache
	def set_cache_buster
		response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
		response.headers["Pragma"] = "no-cache"
		response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    #cookies.delete(:_inventory_management_session)
	end
	
	# checking and setting the session until logout
	def set_session_check
		
		# check the session
		if session[:id]
			# if exists no thing to do
		else
			# check whether user is logged in or not
			if not current_user.nil?
				# if there is some value in current_user
				# then set them to session
				session[:id] = current_user.id
				session[:user_type] = current_user.user_type
				session[:login_id] = current_user.login_id
				session[:first_name] = current_user.first_name
				session[:last_name] = current_user.last_name
			end
			
		end
		
	end
	#------------------------------------------------------------------------------------------------
	#----------------protected-------------------------------------------------------------------------
	#--------------------------------------------------------------------------------------------------
	protected
	
	# please check the site http://thekindofme.wordpress.com/2010/09/25/recaptcha-with-rails-3-without-plugins/
	# assigning the recaptcha private key
	RECAPTCHA_PRIVATE_KEY = '6LfPFMYSAAAAAM5FdbrRCro40Qnbvn9UmzpwvH0w'

	#try and verify the captcha response. Then give out a message to flash
	def verify_recaptcha(remote_ip, params)

		require 'net/http'
		responce = Net::HTTP.post_form(URI.parse('http://www.google.com/recaptcha/api/verify'),
		{'privatekey'=>RECAPTCHA_PRIVATE_KEY, 'remoteip'=>remote_ip, 'challenge'=>params[:recaptcha_challenge_field], 'response'=> params[:recaptcha_response_field]})
		result = {:status => responce.body.split("\n")[0], :error_code => responce.body.split("\n")[1]}

		if result[:error_code] == "incorrect-captcha-sol"
			flash[:alert] = "The CAPTCHA solution was incorrect. Please re-try"
		elsif not result[:error_code] == "success"
			flash[:alert] = "There has been a unexpected error with the application. Please contact the administrator. error code: #{result[:error_code]}"
		end

		result

	end 
end
