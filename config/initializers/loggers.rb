# coding: UTF-8

log_file  = File.join(Rails.root, 'log', "/api-#{Rails.env}.log")
API_LOGGER = ApiLogger.new(log_file).tap do |logger|
  logger.level = Rails.env.production? ? Logger::INFO : Logger::DEBUG
end
