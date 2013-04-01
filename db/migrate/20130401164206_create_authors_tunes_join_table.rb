class CreateAuthorsTunesJoinTable < ActiveRecord::Migration
  def up
    create_table :authors_tunes, :id => false do |t|
      t.integer :author_id
      t.integer :tune_id
    end
    add_index :authors_tunes, [:author_id, :tune_id]
  end

  def down
    drop_table :authors_tunes
  end
end
