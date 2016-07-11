require 'spec_helper'

RSpec.describe Entities::Product do
  describe 'class methods' do
    subject { Entities::Product }

    it { expect(subject.connec_entity_name).to eq 'Item' }
    it { expect(subject.external_entity_name).to eq 'products' }
    it { expect(subject.mapper_class).to eq ProductEntityMapper }
    it { expect(subject.object_name_from_connec_entity_hash({'name' => 'CONNEC NAME'})).to eq 'CONNEC NAME' }
    it { expect(subject.object_name_from_external_entity_hash({'name' => 'EXTERNAL NAME'})).to eq 'EXTERNAL NAME' }
  end

  describe 'instance methods' do
    let(:organization) { create(:organization) }
    subject { Entities::Product.new(organization, nil, nil, {}) }

    describe 'BaseCRM to connec!' do
      let(:base) {
        {
          'id' => '123456789',
          'name' => 'PRODUCT NAME',
          'sku' => 'SKU CODE',
          'description' => 'DESCRIPTION HERE'
        }
      }

      let(:mapped_base) {
        {
          'id' => ['id' => '123456789', 'provider' => 'this_app', 'realm' => 'sfuiy765'],
          'name' => 'PRODUCT NAME',
          'code' => 'SKU CODE',
          'description' => 'DESCRIPTION HERE'

        }
      }

      it { expect(subject.map_to_connec(base)).to eq mapped_base }
    end

    describe 'connec! to BaseCRM' do
      let(:connec) {
        {
          'id' => '123456789',
          'name' => 'PRODUCT NAME',
          'code' => 'SKU CODE',
          'description' => 'DESCRIPTION HERE'
        }
      }

      let(:mapped_connec) {
        {
          'name' => 'PRODUCT NAME',
          'sku' => 'SKU CODE',
          'description' => 'DESCRIPTION HERE'
        }
      }

      it { expect(subject.map_to_external(connec)).to eq mapped_connec }
    end
  end
end
