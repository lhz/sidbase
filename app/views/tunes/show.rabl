object @object
cache  @object

extends "tunes/base"

child :authors do
  attributes :name, :handle
end

child :groups do
  attributes :name
end
