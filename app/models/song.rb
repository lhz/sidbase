class Song < ActiveRecord::Base
  attr_accessible :tune_id, :position, :duration, :end_type

  belongs_to :tune

  validates :position, :numericality => { :only_integer => true }, :presence => true
  validates :duration, :numericality => { :only_integer => true }
  validates :end_type, :inclusion => { :in => %w[L G B M Z] }

  def length
    mins, secs = duration.divmod(60)
    "%d:%02d" % [mins, secs]
  end

end
