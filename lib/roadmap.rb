module Roadmap
  def get_roadmap
    user_data_hash = get_me
    roadmap_id = user_data_hash["current_enrollment"]["roadmap_id"]
    url = "#{@base_url}/roadmaps/#{roadmap_id}"
    response = self.class.get(url, headers: { "authorization" => @auth_token })
    roadmap = JSON.parse(response.body)
  end

  def get_checkpoint(checkpoint_id)
    url = "#{@base_url}/checkpoints/#{checkpoint_id}"
    response = self.class.get(url, headers: { "authorization" => @auth_token })
    checkpoint = JSON.parse(response.body)
  end
end
