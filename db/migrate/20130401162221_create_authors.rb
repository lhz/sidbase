class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :name
      t.string :handle

      t.timestamps
    end
    add_index :authors, :name
    add_index :authors, :handle
  end
end
