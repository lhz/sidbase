class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.integer :tune_id
      t.integer :position
      t.integer :duration
      t.string  :end_type
    end
    add_index :songs, :tune_id
  end
end
