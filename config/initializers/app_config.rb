app_config = YAML.load_file("#{Rails.root}/config/app_config.yml")
env_config = app_config[Rails.env]

APP_CONFIG = HashWithIndifferentAccess.new
APP_CONFIG.merge!(env_config) if env_config
