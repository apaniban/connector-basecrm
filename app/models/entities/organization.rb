class Entities::Organization < Maestrano::Connector::Rails::Entity
  def self.connec_entity_name
    'Organization'
  end

  def self.external_entity_name
    'contacts'
  end

  def self.mapper_class
    OrganizationEntityMapper
  end

  def self.object_name_from_connec_entity_hash(entity)
    entity['name']
  end

  def self.object_name_from_external_entity_hash(entity)
    entity['name']
  end
end

class OrganizationEntityMapper
  extend HashMapper

  after_normalize do |input, output|
    output['is_organization'] = true

    output
  end

  map from('name'), to('name')
  map from('industry'), to('industry')

  map from('email/address'), to('email')
  map from('phone/landline'), to('phone')
  map from('phone/mobile'), to('mobile')
  map from('phone/fax'), to('fax')

  map from('contact_channel/skype'), to('skype')

  map from('address/billing/line1'), to('address/line1')
  map from('address/billing/city'), to('address/city')
  map from('address/billing/postal_code'), to('address/postal_code')
  map from('address/billing/region'), to('address/state')
  map from('address/billing/country'), to('address/country')
end
