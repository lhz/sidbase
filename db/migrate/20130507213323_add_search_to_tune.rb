class AddSearchToTune < ActiveRecord::Migration
  def change
    add_column :tunes, :search, :tsvector
    Tune.update_all "search = to_tsvector(author || ', ' || name || ', ' || released)"
    execute "CREATE INDEX index_tunes_on_search ON tunes USING GIN(search)"
  end
end
