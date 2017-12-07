require 'httparty'
require 'json'
require './lib/roadmap'

class Kele
  include HTTParty
  include Roadmap

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

  def get_mentor_availability
    user_data_hash = get_me

    mentor_id = user_data_hash["current_enrollment"]["mentor_id"]

    url = "#{@base_url}/mentors/#{mentor_id}/student_availability"

    response = self.class.get(url, headers: { "authorization" => @auth_token })

    mentor_availability = JSON.parse(response.body)
  end

end
