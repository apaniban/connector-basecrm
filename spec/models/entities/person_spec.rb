require 'spec_helper'

RSpec.describe Entities::Person do
  describe 'class methods' do
    subject { Entities::Person }

    it { expect(subject.connec_entity_name).to eq 'Person' }
    it { expect(subject.external_entity_name).to eq 'contacts' }
    it { expect(subject.mapper_class).to eq PersonEntityMapper }
    it { expect(subject.object_name_from_connec_entity_hash({'first_name' => 'CONNEC', 'last_name' => 'NAME'})).to eq 'CONNEC NAME' }
    it { expect(subject.object_name_from_external_entity_hash({'first_name' => 'EXTERNAL', 'last_name' => 'NAME' })).to eq 'EXTERNAL NAME' }
  end

  describe 'instance methods' do
    let(:organization) { create(:organization) }
    subject { Entities::Person.new(organization, nil, nil, {}) }

    describe 'BaseCRM to connec!' do
      let(:base) {
        {
          'id' => '123456789',
          'first_name' => 'FIRST',
          'last_name' => 'LAST',
          'email' => 'test@email.com',
          'phone' => '123123123',
          'mobile' => '123123123',
          'fax' => '123123123',
          'skype' => 'skype.name',
          'address' => {
            'line1' => 'line1',
            'city' => 'CITY',
            'postal_code' => '1234',
            'state' => 'NSW',
            'country' => 'AUS'
          }
        }
      }

      let(:mapped_base) {
        {
          'id' => ['id' => '123456789', 'provider' => 'this_app', 'realm' => 'sfuiy765'],
          'first_name' => 'FIRST',
          'last_name' => 'LAST',
          'email' => {
            'address' => 'test@email.com'
          },
          'phone_home' => {
            'landline' => '123123123',
            'mobile' => '123123123',
            'fax' => '123123123'
          },
          'contact_channel' => {
            'skype' => 'skype.name'
          },
          'address_home' => {
            'billing' => {
              'line1' => 'line1',
              'city' => 'CITY',
              'postal_code' => '1234',
              'region' => 'NSW',
              'country' => 'AUS'
            }
          }
        }
      }

      it { expect(subject.map_to_connec(base)).to eq mapped_base }
    end

    describe 'connec! to base' do
      let(:connec) {
        {
          'id' => '123456789',
          'first_name' => 'FIRST',
          'last_name' => 'LAST',
          'email' => {
            'address' => 'test@email.com'
          },
          'phone_home' => {
            'landline' => '123123123',
            'mobile' => '123123123',
            'fax' => '123123123'
          },
          'contact_channel' => {
            'skype' => 'skype.name'
          },
          'address_home' => {
            'billing' => {
              'line1' => 'line1',
              'city' => 'CITY',
              'postal_code' => '1234',
              'region' => 'NSW',
              'country' => 'AUS'
            }
          }
        }
      }

      let(:mapped_connec) {
        {
          'first_name' => 'FIRST',
          'last_name' => 'LAST',
          'is_organization' => false,
          'email' => 'test@email.com',
          'phone' => '123123123',
          'mobile' => '123123123',
          'fax' => '123123123',
          'skype' => 'skype.name',
          'address' => {
            'line1' => 'line1',
            'city' => 'CITY',
            'postal_code' => '1234',
            'state' => 'NSW',
            'country' => 'AUS'
          }
        }
      }

      it { expect(subject.map_to_external(connec)).to eq mapped_connec}
    end
  end
end
