require 'httparty'

class Kele

	include HTTParty

	def initialize(email, password)

		email, password = email, password

		@base_url = "https://www.bloc.io/api/v1"

		options = {
			body: {email: email, password: password}
		}

		response = self.class.post("#{@base_url}/sessions", options)

		@user_authentication_token = response["auth_token"]

	end

end
