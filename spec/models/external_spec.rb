require 'spec_helper'

describe Maestrano::Connector::Rails::External do
  describe 'class methods' do
    subject { Maestrano::Connector::Rails::External }

    describe 'external_name' do
      it { expect(subject.external_name).to eq 'BaseCRM' }
    end

    describe 'get_client' do
      let(:organization) { create(:organization) }

      it 'creates a BaseCRM client' do
        expect(BaseCRM::Client).to receive(:new)
        subject.get_client(organization)
      end
    end

    describe 'fetch_company' do
      let(:organization) { create(:organization) }
      let(:client) { BaseCRM::Client.new access_token: '1111111111111111111111111111111111111111111111111111111111111111'}

      before {
        allow(Maestrano::Connector::Rails::External).to receive(:get_client).and_return(client)
      }

      it 'fetches company' do
        allow(client).to receive_message_chain(:accounts, :self) { {name: 'company name'} }
        expect(client).to receive_message_chain(:accounts, :self)
        subject.fetch_company(organization)
      end
    end
  end
end
