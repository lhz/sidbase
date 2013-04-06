class TuneIndexSerializer < ActiveModel::Serializer
  attributes :id, :name, :author, :released, :model, :path
end
