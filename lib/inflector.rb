
module Inflector

  @models = {}

  def self.modelize(name)
    @models[name] ||= name.pluralize.classify.constantize
  end

end
