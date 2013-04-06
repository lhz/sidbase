class TuneSerializer < ActiveModel::Serializer
  attributes :id, :name, :author, :released, :path, :size, :year
  attributes :load_address, :init_address, :play_address
  attributes :song_count, :model, :start_song, :speed, :sid2
  attributes :created_at, :updated_at

  has_many :authors
  has_many :groups
  has_many :songs
end
