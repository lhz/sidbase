class AddSortNameToTunes < ActiveRecord::Migration
  def up
    add_column :tunes, :sort_name, :string

    Tune.all.each do |tune|
      tune.update_column :sort_name, tune.generate_sort_name
    end
  end

  def down
    remove_column :tunes, :sort_name
  end
end
