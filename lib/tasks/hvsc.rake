require 'hvsc'

namespace :hvsc do

  desc "Import all SIDs from local HVSC installation"
  task :import_all_sids => :environment do
    hvsc = HVSC.new(APP_CONFIG[:hvsc_path])
    hvsc.import_all_sids
  end

end
