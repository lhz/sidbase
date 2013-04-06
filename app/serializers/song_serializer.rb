class SongSerializer < ActiveModel::Serializer
  attributes :id, :position, :duration, :end_type
end
