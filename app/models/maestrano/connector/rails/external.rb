class Maestrano::Connector::Rails::External
  include Maestrano::Connector::Rails::Concerns::External

  def self.external_name
    'BaseCRM'
  end

  def self.get_client(organization)
    BasecrmClient.new access_token: organization.oauth_token
  end

  # Return an array of all the entities that the connector can synchronize
  # If you add new entities, you need to generate
  # a migration to add them to existing organizations
  def self.entities_list
    %w(organization person product)
  end

  def self.fetch_company(organization)
    client = self.get_client(organization)
    client.get_own_account
  end
end
