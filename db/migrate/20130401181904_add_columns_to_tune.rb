class AddColumnsToTune < ActiveRecord::Migration
  def change
    add_column :tunes, :year,  :string
    add_column :tunes, :load,  :integer
    add_column :tunes, :init,  :integer
    add_column :tunes, :play,  :integer
    add_column :tunes, :songs, :integer
    add_column :tunes, :model, :string
  end
end
