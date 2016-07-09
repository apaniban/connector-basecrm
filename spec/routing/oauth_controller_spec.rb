require 'spec_helper'

RSpec.describe OauthController, type: :routing do
  it { expect(get('/auth/base/request')).to route_to('oauth#request_omniauth', provider: 'base') }
  it { expect(post('/auth/base/request')).to route_to('oauth#request_omniauth', provider: 'base') }

  it { expect(get('/auth/base/callback')).to route_to('oauth#create_omniauth', provider: 'base') }
  it { expect(post('/auth/base/callback')).to route_to('oauth#create_omniauth', provider: 'base') }

  it { expect(get('signout_omniauth')).to route_to('oauth#destroy_omniauth') }
  it { expect(post('signout_omniauth')).to route_to('oauth#destroy_omniauth') }
end
