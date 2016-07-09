class OauthController < ApplicationController
  def request_omniauth
    if is_admin
      auth_params = {
        state: current_organization.uid
      }

      auth_params = URI.escape(auth_params.collect{|k,v| "#{k}=#{v}"}.join('&'))
      redirect_to "/auth/#{params[:provider]}?#{auth_params}", id: "sign_in"
    else
      redirect_to root_url
    end
  end

  def create_omniauth
    omniauth_params = request.env['omniauth.params']
    org_uid = omniauth_params['state']

    organization = Maestrano::Connector::Rails::Organization.find_by_uid_and_tenant(org_uid, current_user.tenant)

    if organization && is_admin?(current_user, organization)
      organization.from_omniauth(env["omniauth.auth"])

      begin
        company = Maestrano::Connector::Rails::External.fetch_company(organization)
        organization.update(oauth_name: company['name'])
      rescue =>e
        empty_organization_fields(organization)
        Rails.logger.info "Error in create_omniauth: #{e.backtrace}"
        flash[:danger] = "API access is not enabled for your BaseCRM edition"
      end
    end

    redirect_to root_url
  end

  def destroy_omniauth
    organization = Maestrano::Connector::Rails::Organization.find_by_id(params[:organization_id])

    if organization && is_admin?(current_user, organization)
      empty_organization_fields(organization)
    end

    redirect_to root_url
  end

  private
    def empty_organization_fields(organization)
      organization.oauth_uid = nil
      organization.oauth_token = nil
      organization.refresh_token = nil
      organization.sync_enabled = false
      organization.save
    end
end
