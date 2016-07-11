class BasecrmClient
  include HTTParty
  base_uri 'https://api.getbase.com/v2'

  def initialize(opts={})
    self.class.headers 'Accept' => 'application/json',
                       'User-Agent' => 'HTTParty BaseCRM connector',
                       'Content-Type' => 'application/json',
                       'Authorization' => "Bearer #{opts[:access_token]}"
  end

  def find(entity_name, id, opts={})
    response = self.class.get "/#{entity_name}/#{id}"

    response['data']
  end

  def find_all(entity_name, opts={})
    response = self.class.get "/#{entity_name}"

    response['items'].map{|item| item['data']}
  end

  def get_updated_entities(entity_name, last_synchronization_date)
    # get new or entities
    entities = find_all(entity_name)

    entities = entities.select{|e| e['updated_at'].to_time > last_synchronization_date}

    entities
  end

  def create(entity_name, params)
    response = self.class.post "/#{entity_name}", body: { data: params }.to_json

    response['data']['id']
  end

  def update(entity_name, params)
    id = params.delete(:id)

    response = self.class.put "/#{entity_name}/#{id}", body: { data: params }.to_json

    response['data']
  end

  def get_own_account
    response = self.class.get "/accounts/self"

    response['data']
  end
end
