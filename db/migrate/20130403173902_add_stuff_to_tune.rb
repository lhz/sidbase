class AddStuffToTune < ActiveRecord::Migration
  def change
    add_column :tunes, :start_song, :integer
    add_column :tunes, :speed, :integer
    add_column :tunes, :sid2, :integer
  end
end
