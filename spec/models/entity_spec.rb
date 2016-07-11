require 'spec_helper'

RSpec.describe Maestrano::Connector::Rails::Entity do
  describe 'class methods' do
    subject { Maestrano::Connector::Rails::Entity }

    describe '.id_from_external_entity_hash' do
      it { expect(subject.id_from_external_entity_hash({'id' => 'random_id'})).to eq 'random_id' }
    end

    describe '.last_update_date_from_external_entity_hash' do
      it {
        Timecop.freeze(Time.now) do
          expect(subject.last_update_date_from_external_entity_hash({'updated_at' => Time.now})).to eq Time.now
        end
      }
    end

    describe '.creation_date_from_external_entity_hash' do
      it {
        Timecop.freeze(Time.now) do
          expect(subject.creation_date_from_external_entity_hash({'created_at' => Time.now})).to eq Time.now
        end
      }
    end
  end

  describe 'instance methods' do
    let(:organization) { create(:organization) }
    let(:external_client) { BasecrmClient.new access_token: 'ACCESS_TOKEN' }
    let(:opts) { {} }
    let(:external_name) { 'contacts' }

    subject { Maestrano::Connector::Rails::Entity.new(organization, nil, external_client, opts) }

    before {
      allow(subject.class).to receive(:external_entity_name).and_return(external_name)
    }

    describe '#get_external_entities' do
      context 'when full sync' do
        let(:opts) {{full_sync: true} }

        it 'uses full query' do
          expect(external_client).to receive(:find_all).with(external_name)

          subject.get_external_entities
        end
      end

      context 'with last sync' do
        let(:last_sync_time) { Time.now }

        it 'uses updated_entities' do
          expect(external_client).to receive(:get_updated_entities).with(external_name, last_sync_time)

          subject.get_external_entities(last_sync_time)
        end
      end
    end

    describe '#create_external_entity' do
      it 'calls create' do
        expect(external_client).to receive(:create).with(external_name, {})

        subject.create_external_entity({}, external_name)
      end
    end

    describe '#update_external_entity' do
      let(:id) { 1 }

      it 'calls update' do
        expect(external_client).to receive(:update).with(external_name, {'id' => id})

        subject.update_external_entity({}, id, external_name)
      end
    end
  end
end
