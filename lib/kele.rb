require 'httparty'
require 'json'
require './lib/roadmap'

class Kele
  include HTTParty
  include Roadmap

  def initialize(email, password)
    @email, password = email, password
    @base_url = "https://www.bloc.io/api/v1"
    response = self.class.post("#{@base_url}/sessions", body: {email: email, password: password})
    @auth_token = response["auth_token"]
  end

  def get_me
    url = "#{@base_url}/users/me"
    response = self.class.get(url, headers: {authorization: @auth_token})
    user_data_hash = JSON.parse(response.body)
  end

  def get_mentor_availability
    user_data_hash = get_me
    mentor_id = user_data_hash["current_enrollment"]["mentor_id"]
    url = "#{@base_url}/mentors/#{mentor_id}/student_availability"
    response = self.class.get(url, headers: {authorization: @auth_token})
    mentor_availability = JSON.parse(response.body)
  end

  def get_messages(page = nil)
    url = "#{@base_url}/message_threads"
    if page
      response = self.class.get(url, body: { page: page }, headers: { authorization: @auth_token })
      return messages_from_page = JSON.parse(response.body)
    end
    total_messages = get_messages(1)["count"]
    messages_per_page = 10
    number_of_pages = (total_messages / messages_per_page.to_f).ceil
    all_messages = []
    page = 1
    number_of_pages.times do
      response = self.class.get(url, body: { page: page }, headers: { authorization: @auth_token })
      messages_from_page = JSON.parse(response.body)
      all_messages << messages_from_page
      page +=1
    end
    all_messages
  end

  def create_message(recipient_id, stripped_text, subject, token=nil)
    url = "#{@base_url}/messages"
    if token == nil
      response = self.class.post(url,body: { sender: @email, recipient_id: recipient_id, subject: subject,"stripped-text" => stripped_text}, headers: { authorization: @auth_token })
    else
      response = self.class.post(url,body: { sender: @email, recipient_id: recipient_id, token: token, subject: subject,"stripped-text" => stripped_text}, headers: { authorization: @auth_token })
    end
  end

  def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment)
    url = "#{@base_url}/checkpoint_submissions"
    enrollment_id = get_me["current_enrollment"]["id"]
    response = self.class.post(url, body: { assignment_branch: assignment_branch, assignment_commit_link: assignment_commit_link, checkpoint_id: checkpoint_id, comment: comment, enrollment_id: enrollment_id }, headers: { authorization: @auth_token })
  end

end
