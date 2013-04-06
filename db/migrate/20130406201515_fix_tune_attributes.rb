class FixTuneAttributes < ActiveRecord::Migration
  def change
    rename_column :tunes, :load, :load_address
    rename_column :tunes, :init, :init_address
    rename_column :tunes, :play, :play_address
  end
end
