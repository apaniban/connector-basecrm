require 'spec_helper'

RSpec.describe BasecrmClient do
  let(:access_token) { 'ACCESS_TOKEN' }
  let(:client) { BasecrmClient.new access_token: access_token }
  let(:entity_name) { 'contacts' }
  let(:id) { 1 }

  describe '#initialize' do
    it 'sets httparty headers' do
      expect(client.class.headers['Accept']).to eq 'application/json'
      expect(client.class.headers['User-Agent']).to eq 'HTTParty BaseCRM connector'
      expect(client.class.headers['Content-Type']).to eq 'application/json'
      expect(client.class.headers['Authorization']).to eq "Bearer #{access_token}"
    end
  end

  describe '#find' do
    let(:expected_output) { {id: id, first_name: 'first name',
                             last_name: 'last name'}.with_indifferent_access }

    it 'retrieves entity' do
      allow(BasecrmClient).to receive(:get).and_return({'data' => expected_output})
      expect(client.find(entity_name, id)).to eq expected_output
    end
  end

  describe '#find_all' do
    let(:expected_output) { [{id: 1, first_name: 'first 1', last_name: 'last 1'},
                             {id: 1, first_name: 'first 2', last_name: 'last 2'},
                             {id: 1, first_name: 'first 3', last_name: 'last 3'}] }

    it 'retreives entities' do
      allow(BasecrmClient).to receive(:get).and_return({'items' => expected_output.map{|o| {'data' => o}}})

      expect(client.find_all(entity_name)).to eq expected_output
    end
  end

  describe '#get_updated_entities' do
    let(:last_sync_date) { Time.now }
    let(:old_entity) { {id: 1, first_name: 'old', last_name: 'name', updated_at: last_sync_date - 1.day }.with_indifferent_access }
    let(:new_entity) { {id: 2, first_name: 'new', last_name: 'name', updated_at: last_sync_date + 1.day }.with_indifferent_access }

    it 'retrieves new entities after last sync date' do
      allow(client).to receive(:find_all).and_return([old_entity, new_entity])

      expect(client.get_updated_entities(entity_name, last_sync_date)).to eq [new_entity]
    end
  end

  describe '#create' do
    let(:output_hash) { {'data' => {'id' => id, first_name: 'first', last_name: 'last'}} }

    it 'creates and returns entity id' do
      allow(BasecrmClient).to receive(:post).and_return output_hash

      expect(client.create(entity_name, {first_name: 'first', last_name: 'last'})).to eq id

    end
  end

  describe '#update' do
    let(:output_hash) { {'id' => id, first_name: 'new name', last_name: 'name'} }

    it 'updates and returns entity' do
      allow(BasecrmClient).to receive(:put).and_return({'data' => output_hash})

      expect(client.update(entity_name, {id: 'id', first_name: 'new name', last_name: 'name'})).to eq output_hash
    end
  end

  describe '#get_own_account' do
    let(:output_hash) { {id: 1, name: 'account name'} }

    it 'retrieves own account details' do
      allow(BasecrmClient).to receive(:get).and_return({'data' => output_hash})

      expect(client.get_own_account).to eq output_hash
    end
  end
end
