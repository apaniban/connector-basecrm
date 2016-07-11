class Entities::Person < Maestrano::Connector::Rails::Entity
  def self.connec_entity_name
    'Person'
  end

  def self.external_entity_name
    'contacts'
  end

  def self.mapper_class
    PersonEntityMapper
  end

  def self.object_name_from_connec_entity_hash(entity)
    "#{entity['first_name']} #{entity['last_name']}"
  end

  def self.object_name_from_external_entity_hash(entity)
    "#{entity['first_name']} #{entity['last_name']}"
  end
end

class PersonEntityMapper
  extend HashMapper

  after_normalize do |input, output|
    output['is_organization'] = false

    output
  end

  map from('first_name'), to('first_name')
  map from('last_name'), to('last_name')

  map from('email/address'), to('email')
  map from('phone_home/landline'), to('phone')
  map from('phone_home/mobile'), to('mobile')
  map from('phone_home/fax'), to('fax')

  map from('contact_channel/skype'), to('skype')

  map from('address_home/billing/line1'), to('address/line1')
  map from('address_home/billing/city'), to('address/city')
  map from('address_home/billing/postal_code'), to('address/postal_code')
  map from('address_home/billing/region'), to('address/state')
  map from('address_home/billing/country'), to('address/country')
end
