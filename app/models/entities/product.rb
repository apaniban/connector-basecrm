class Entities::Product < Maestrano::Connector::Rails::Entity
  def self.connec_entity_name
    'Item'
  end

  def self.external_entity_name
    'products'
  end

  def self.mapper_class
    ProductEntityMapper
  end

  def self.object_name_from_connec_entity_hash(entity)
    entity['name']
  end

  def self.object_name_from_external_entity_hash(entity)
    entity['name']
  end
end

class ProductEntityMapper
  extend HashMapper

  map from('name'), to('name')
  map from('code'), to('sku')
  map from('description'), to('description')
end
