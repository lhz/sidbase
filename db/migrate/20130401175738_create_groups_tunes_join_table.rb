class CreateGroupsTunesJoinTable < ActiveRecord::Migration
  def up
    create_table :groups_tunes, :id => false do |t|
      t.integer :group_id
      t.integer :tune_id
    end
    add_index :groups_tunes, [:group_id, :tune_id]
  end

  def down
    drop_table :groups_tunes
  end
end
