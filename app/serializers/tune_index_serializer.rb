class TuneIndexSerializer < ActiveModel::Serializer
  attributes :id, :name, :released, :model, :path
end
