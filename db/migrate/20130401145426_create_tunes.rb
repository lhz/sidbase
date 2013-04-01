class CreateTunes < ActiveRecord::Migration
  def change
    create_table :tunes do |t|
      t.string :name
      t.string :author
      t.string :released
      t.string :path

      t.timestamps
    end
    add_index :tunes, :name
    add_index :tunes, :author
    add_index :tunes, :released
  end
end
