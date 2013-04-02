object @object

attributes :id, :name, :author, :released, :year
attributes :path, :size, :model, :songs
attributes :load, :init, :play

child :authors do
  attributes :name, :handle
end

child :groups do
  attributes :name
end
