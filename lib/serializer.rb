
module Serializer

  def self.serialize(object, options)
    include_spec = inclusion(object, options[:include])
    case options[:format].to_sym
    when :xml
      object.to_xml(:include => include_spec,
        :skip_types => true, :dasherize => false)
    when :json
      if options[:pretty]
        JSON.pretty_generate object.as_json(:include => include_spec)
      else
        object.to_json(:include => include_spec)
      end
    else
      raise ApiException.unsupported_format(options[:format])
    end
  end

  def self.hashify(object)
    object.as_json :include => inclusion(object)
  end

  def self.inclusion(object, spec = nil)
    spec ||= []

    if object.is_a?(Hash) && object.key?(:result)
      object = object[:result].first
    elsif object.is_a?(Array)
      object = object.first
    end

    inc = {}

    if object.respond_to?(:authors) && spec.include?(:authors)
      inc[:authors] = {}
    end

    if object.respond_to?(:groups) && spec.include?(:groups)
      inc[:groups] = {}
    end

    inc
  end

end
