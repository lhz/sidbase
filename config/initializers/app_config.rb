config = YAML.load_file("#{Rails.root}/config/app_config.yml")

$app_config = HashWithIndifferentAccess.new(config[Rails.env] || {})
