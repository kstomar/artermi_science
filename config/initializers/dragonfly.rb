require 'dragonfly'
require 'dragonfly/s3_data_store'
# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret "aa9a85281ac187ae33ed9a68d5f925622ab600f208784809aa6e6c49552788e0"

  url_format "/media/:job/:name"

    if Rails.env.production?
	  datastore :file,
	    root_path: Rails.root.join('public/system/dragonfly', Rails.env),
	    server_root: Rails.root.join('public')
	else
	  datastore :s3,
		bucket_name: 'artermi',
		access_key_id: 'AKIAIMJ4O7FVDJWPVG2Q',
		secret_access_key: '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',
		url_scheme: 'https'
	end
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
ActiveSupport.on_load(:active_record) do
  extend Dragonfly::Model
  extend Dragonfly::Model::Validations
end
