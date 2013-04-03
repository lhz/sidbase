object @object
cache  @object

extends "tunes/base"

child :songs do
  attributes :position, :duration, :length, :end_type
end

child :authors do
  attributes :name, :handle
end

child :groups do
  attributes :name
end
