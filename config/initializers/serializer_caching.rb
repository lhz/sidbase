# http://www.broadcastingadam.com/2012/07/advanced_caching_part_6-fast_json_apis/
# module ActiveRecord
#   class Base
#     def self.cache_key
#       Digest::MD5.hexdigest "#{scoped.maximum(:updated_at).try(:to_i)}-#{scoped.count}"
#     end
#   end
# end

class ApplicationSerializer < ActiveModel::Serializer
  delegate :cache_key, :to => :object

  # Cache entire JSON string
  def to_json(*args)
    Rails.cache.fetch expand_cache_key(self.class.to_s.underscore, cache_key, 'to-json') do
      super
    end
  end

  # Cache individual Hash objects before serialization
  # This also makes them available to associated serializers
  def serializable_hash
    Rails.cache.fetch expand_cache_key(self.class.to_s.underscore, cache_key, 'serializable-hash') do
      super
    end
  end

  private

  def expand_cache_key(*args)
    ActiveSupport::Cache.expand_cache_key args
  end
end
