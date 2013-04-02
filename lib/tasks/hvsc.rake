require 'hvsc'

namespace :hvsc do

  desc "Import all SIDs from local HVSC installation"
  task :import_all_sids => :environment do
    hvsc = HVSC.new(File.expand_path $app_config[:hvsc_path])
    hvsc.import_all_sids
  end

end
