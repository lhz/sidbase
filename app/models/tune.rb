class Tune < ActiveRecord::Base
  attr_accessible :author, :name, :path, :released, :size,
    :year, :load, :init, :play, :songs, :model, :sort_name

  has_and_belongs_to_many :authors
  has_and_belongs_to_many :groups

  validates :author,   :presence => true
  validates :name,     :presence => true
  validates :path,     :presence => true, :uniqueness => true
  validates :released, :presence => true
  validates :size,     :presence => true

  before_save :update_sort_name

  def update_sort_name
    self.sort_name = name.sub(/^(A|An|The) (.+)$/i) { "#{$2}, #{$1}"}
  end
end
