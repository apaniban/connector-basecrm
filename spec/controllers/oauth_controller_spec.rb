require 'spec_helper'

describe OauthController, type: :controller do
  describe 'request_omniauth' do
    let!(:organization) { create(:organization, uid: 'uid-123') }

    before {
      allow_any_instance_of(Maestrano::Connector::Rails::SessionHelper).to receive(:current_organization).and_return(organization)
    }

    subject { get :request_omniauth, provider: 'base' }

    context 'when not admin' do
      before {
        allow_any_instance_of(ApplicationHelper).to receive(:is_admin).and_return(false)
      }

      it { expect(subject).to redirect_to(root_url) }
    end

    context 'when admin' do
      before {
        allow_any_instance_of(ApplicationHelper).to receive(:is_admin).and_return(true)
      }

      it { expect(subject).to redirect_to('http://test.host/auth/base?state=uid-123') }
    end
  end

  describe 'create_omniauth' do
    let(:user) { Maestrano::Connector::Rails::User.new(email: 'testing@mail.com', tenant: 'default') }
    let(:uid) { 'uid-123' }

    before {
      allow_any_instance_of(Maestrano::Connector::Rails::SessionHelper).to receive(:current_user).and_return(user)
      request.env['omniauth.params'] = { state: uid }.with_indifferent_access
    }

    subject { get :create_omniauth, provider: 'base' }

    context 'when org does not exist' do
      it 'does nothing' do
        expect(Maestrano::Connector::Rails::External).to_not receive(:fetch_company)
        subject
      end
    end

    context 'when org does not exist given the tenant' do
      let!(:organization) { create(:organization, tenant: 'default', uid: uid) }

      it 'does nothing' do
        expect(Maestrano::Connector::Rails::External).to_not receive(:fetch_company)
        subject
      end
    end

    context 'when org exists' do
      let!(:organization) { create(:organization, tenant: 'default', uid: uid) }

      context 'when not admin' do
        before {
          allow_any_instance_of(Maestrano::Connector::Rails::SessionHelper).to receive(:is_admin?).and_return(false)
        }

        it 'does nothing' do
          expect(Maestrano::Connector::Rails::External).to_not receive(:fetch_company)
          subject
        end
      end

      context 'when admin' do
        before {
          allow_any_instance_of(Maestrano::Connector::Rails::Organization).to receive(:find_by_uid_and_tenant).and_return(organization)
          allow_any_instance_of(Maestrano::Connector::Rails::SessionHelper).to receive(:is_admin?).and_return(true)
          allow_any_instance_of(Maestrano::Connector::Rails::Organization).to receive(:from_omniauth)
          allow(Maestrano::Connector::Rails::External).to receive(:fetch_company).and_return({'name' => 'testing' })
        }

        it 'updates the org with the data from oauth and api calls' do
          expect_any_instance_of(Maestrano::Connector::Rails::Organization).to receive(:from_omniauth)
          expect(Maestrano::Connector::Rails::External).to receive(:fetch_company)
          subject
        end
      end
    end
  end

  describe 'destroy_omniauth' do
    let(:organization) { create(:organization, oauth_uid: 'uid-123') }
    subject { get :destroy_omniauth, organization_id: id }

    context 'when no organization is found' do
      let(:id) { 'random-id' }

      it { expect {subject}.to_not change{ organization.oauth_uid } }
    end

    context 'when org is found' do
      let(:id) { organization.id }
      let(:user) { Maestrano::Connector::Rails::User.new(email: 'testing@mail.com', tenant: 'default') }

      before {
        allow_any_instance_of(Maestrano::Connector::Rails::SessionHelper).to receive(:current_user).and_return(user)
      }

      context 'when not admin' do
        before {
          allow_any_instance_of(Maestrano::Connector::Rails::SessionHelper).to receive(:is_admin?).and_return(false)
        }

        it { expect{subject}.to_not change { organization.oauth_uid }}
      end

      context 'when admn' do
        before {
          allow_any_instance_of(Maestrano::Connector::Rails::SessionHelper).to receive(:is_admin?).and_return(true)
        }

        it "deletes org's oauth_uid" do
          subject
          organization.reload
          expect(organization.oauth_uid).to be_nil
        end
      end
    end
  end
end
