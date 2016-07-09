OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :base, ENV['basecrm_api_id'], ENV['basecrm_api_secret']
end
