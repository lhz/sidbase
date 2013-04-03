class AddSortNameToTunes < ActiveRecord::Migration
  def change
    add_column :tunes, :sort_name, :string
  end
end
