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

end
