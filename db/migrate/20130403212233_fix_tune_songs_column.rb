class FixTuneSongsColumn < ActiveRecord::Migration
  def change
    rename_column :tunes, :songs, :song_count
  end
end
