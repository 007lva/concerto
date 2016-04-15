Rails.logger.debug "Starting #{File.basename(__FILE__)} at #{Time.now.to_s}"

require 'yaml'
concerto_base_config = YAML.load_file('./config/concerto.yml')

if ActiveRecord::Base.connection.table_exists? 'concerto_configs'
  ConcertoConfig.make_concerto_config(
    'send_errors', "#{concerto_base_config['airbrake_enabled_initially'].to_s}", value_type: 'boolean', category: 'System'
  )

  if defined?(Airbrake) && Rails.env.production?
    Airbrake.configure do |config|
      config.project_id = ENV['AIRBRAKE_PROJECT_ID']
      config.project_key = ENV['AIRBRAKE_API_KEY']
      config.root_directory = Rails.root
      config.logger = Rails.logger
      config.environment = Rails.env
      config.ignore_environments = %w(development test)
    end
  end
end

Rails.logger.debug "Completed #{File.basename(__FILE__)} at #{Time.now.to_s}"
