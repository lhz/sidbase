class Tune < ActiveRecord::Base
  attr_accessible :author, :name, :path, :released, :size,
    :year, :load, :init, :play, :song_count, :model, :sort_name

  has_and_belongs_to_many :authors
  has_and_belongs_to_many :groups
  has_many :songs

  validates :author,   :presence => true
  validates :name,     :presence => true
  validates :path,     :presence => true, :uniqueness => true
  validates :released, :presence => true
  validates :size,     :presence => true

end
