class AddSizeToTunes < ActiveRecord::Migration
  def change
    add_column :tunes, :size, :integer
  end
end
