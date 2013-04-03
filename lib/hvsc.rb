require 'find'
require 'rsid'

class HVSC

  def initialize(base_path)
    base_path or raise "No base path supplied."
    File.directory?(base_path) or raise "Not a directory: #{base_path}"
    @base_path = base_path
    @base_path << '/' unless @base_path[-1] == '/'
  end

  def import_all_sids
    Find.find(@base_path) do |path|
      if File.directory?(path) && File.basename(path)[/^\./]
        Find.prune
      elsif File.file?(path) && File.extname(path) == '.sid'
        import_sid path
      end
    end
  end

  def import_sid(path)
    rel_path = path.sub(@base_path, '')
    puts "Importing SID: #{rel_path}"

    rsid = RSID.load(path)
    tune = Tune.find_or_create_by_path(rel_path)
    tune.name     = sortable_name(rsid.name)
    tune.author   = rsid.author
    tune.released = rsid.released
    tune.size     = File.size(path)
    tune.year     = rsid.year
    tune.load     = rsid.load
    tune.init     = rsid.init_address
    tune.play     = rsid.play_address
    tune.songs    = rsid.songs
    tune.model    = rsid.model_label
    tune.save!

    tune.authors = rsid.authors.map do |name|
      handle = nil
      if name =~ /^(.+)\s+\((.+)\)$/
        name, handle = $1, $2
      end
      Author.find_or_create_by_name_and_handle!(name, handle)
    end

    tune.groups = rsid.groups.map do |name|
      Group.find_or_create_by_name!(name)
    end
  end

  def import_song_info
    File.foreach("#{@base_path}/DOCUMENTS/Songlengths.txt") do |line|
      if line[/^; \/(.+\/.+)$/]
        path = $1
        tune = Tune.find_by_path(path) or
          raise "No tune found with path '#{path}'."
      elsif line[/^([0-9a-f]{16})=(.*)$/]
        md5, timespec = $1, $2
        times = timespec.split(/\s+/)
        tune.songs = times.map.with_index do |time, index|
          if time[/(\d+):(\d+)(\(\w+\))?/]
            mins, secs, flag = $1, $2, $3
            song = Song.find_or_create_by_tune_id_and_index(tune.id, index)
            song.length = mins * 60 + secs
            song.length_flag = flag if flag
          else
            puts "Strange time format: '#{time}' for path '#{path}'."
          end
        end
        # tune.update_attribute :md5, md5
      end
    end
  end

  def sortable_name(name)
    if name && name[/^(A|An|The) (.+)$/]
      "#{$2}, #{$1}"
    else
      name
    end
  end

end
