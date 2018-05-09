require 'httparty'
require 'json'

class Kele
	include HTTParty

	def initialize(email, password)
		email, password = email, password

		@base_url = "https://www.bloc.io/api/v1"

		options = {
			body: { email: email, password: password }
		}

		response = self.class.post("#{@base_url}/sessions", options)

		@auth_token = response["auth_token"]
	end


	def get_me
		url = "#{@base_url}/users/me"

		response = self.class.get(url, headers: { "authorization" => @auth_token })

		user_data_hash = JSON.parse(response.body)
	end

end
