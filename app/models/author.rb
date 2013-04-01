class Author < ActiveRecord::Base
  attr_accessible :name, :handle

  validates :name, :presence => true

  has_and_belongs_to_many :tunes
end
