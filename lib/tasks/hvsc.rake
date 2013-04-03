require 'hvsc'

namespace :hvsc do

  desc "Import all SIDs from local HVSC installation"
  task :import_all_sids => :environment do
    hvsc = HVSC.new(File.expand_path $app_config[:hvsc_path])
    hvsc.import_all_sids
  end

  desc "Import song info from Songlengths.txt in local HVSC installation"
  task :import_song_info => :environment do
    hvsc = HVSC.new(File.expand_path $app_config[:hvsc_path])
    hvsc.import_song_info
  end

end
