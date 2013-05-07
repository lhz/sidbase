
class QueryBuilder

  class BadQueryError < StandardError; end

  def initialize(model, params)
    logger.debug "QueryBuilder: params = #{params.inspect}"
    @params  = params
    @model   = model
    @matches = []
    @limit   = default_limit
    @order   = default_order
    process_parameters
  end

  def search
    result = query(:search => true)
    hash = {
      :count   => result.size,
      :objects => result.all,
    }
    hash[:total] = query(:count => true) if @params['total']
    hash
  end

  private

  def logger
    API_LOGGER
  end

  def associations
    @model.reflections.keys
  end

  def query(options)
    rel = @model
    rel = rel.joins(joins)
    @matches.each do |arr|
      rel = rel.where(arr)
    end
    if options[:count]
      logger.debug "QueryBuilder SQL (COUNT): #{rel.to_sql}"
      rel = rel.count
    end
    if options[:search]
      rel = rel.offset(@offset) if @offset
      rel = rel.limit(@limit) if @limit
      rel = rel.order(@order) if @order
      logger.debug "QueryBuilder SQL: #{rel.to_sql}"
    end
    rel
  end

  def process_parameters
    valid_parameters.each do |key, value|
      k1, k2, k3 = key.split('.')
      case k1
      when 'offset'
        offset value
      when 'limit'
        limit value
      when 'order'
        order value
      when /^#{associations_pattern}$/
        match [table_for(k1), k2], k3, value
      else
        match k1, k2, value
      end
    end
  end

  def table_for(association_name)
    Inflector.modelize(association_name).table_name
  end

  def joins
    @joins ||= associations.select do |assoc|
      valid_parameters.any? do |key, value|
        key.starts_with?("#{assoc}.") ||
          (key == 'order' && value.split(',').any? {|v| v.starts_with?("#{assoc}.") })
      end
    end
  end

  def match(column, suffix, value)
    case suffix
    when 'in', 'not_in'
      value = [value.split(',')]
    when 'like', 'not_like'
      value = "%#{value}%" unless value[/%/]
    end
    if column.is_a?(Array)
      if column[0] == 'fields'
        qcol  = %Q("fields"."name" = ? AND "fields"."value")
        value = [column[1], value]
      else
        qcol = column.map {|c| %Q("#{c}") }.join '.'
      end
    else
      qcol = %Q("#{column}")
    end
    where = case suffix
            when 'like'     then ["#{qcol} ILIKE ?",     *value]
            when 'not_like' then ["NOT #{qcol} ILIKE ?", *value]
            when 'min'      then ["#{qcol} >= ?",        *value]
            when 'max'      then ["#{qcol} <= ?",        *value]
            when 'not'      then ["#{qcol} != ?",        *value]
            when 'in'       then ["#{qcol} IN (?)",      *value]
            when 'not_in'   then ["NOT #{qcol} IN (?)",  *value]
            when 'not'      then ["NOT #{qcol} = ?",     *value]
            when nil        then ["#{qcol} = ?",         *value]
            else
              raise BadQueryError.new("Invalid comparator suffix: #{suffix}")
            end
    @matches << where
  end

  def order(value)
    orderings = value.split(',').map do |v|
      descending = false
      if v.ends_with?('.desc')
        v.chomp!('.desc')
        descending = true
      end
      c1, c2 = v.split('.')
      if c2
        order = %Q("#{table_for(c1)}") << '.' << %Q("#{c2}")
      else
        order = %Q("#{@model.table_name}") << '.' << %Q("#{c1}")
      end
      order << " DESC" if descending
      order
    end
    @order = orderings.join(', ')
  end

  def default_order
    @model.primary_key
  end

  def offset(value)
    @offset = value
  end

  def limit(value)
    @limit = value
  end

  def default_limit
    10
  end

  def associations_pattern
    "(#{associations.join '|'})"
  end

  def comparator_pattern
    '(like|not_like|min|max|not|in|not_in)'
  end

  def column_pattern
    '[a-z0-9_]+'
  end

  def name_pattern
    '[a-z0-9_]+'
  end

  def valid_parameters
    @valid_params ||= @params.each_with_object({}) do |(key, value), hash|
      next if skip_parameters.include?(key.to_sym)
      k1, k2, k3, x = key.split('.')
      valid = case key.to_s
              when 'limit', 'offset'
                value.to_s =~ /^\d+$/
              when 'order'
                value.split(',').all? {|v|
                  v[/^\s*(#{associations_pattern}[.])?#{column_pattern}([.]desc)?\s*$/]
                }
              when /^fields[.](#{name_pattern})([.]#{comparator_pattern})?$/
                true
              when /^#{associations_pattern}[.](#{column_pattern})([.]#{comparator_pattern})?$/
                Inflector.modelize($1).column_names.include?($2)
              when /^(#{column_pattern})([.]#{comparator_pattern})?$/
                @model.column_names.include?(k1)
              else
                false
              end
      raise BadQueryError.new("Invalid search parameter: '#{key}' = '#{value}'") unless valid
      hash[key.to_s] = value
    end
  end

  def skip_parameters
    [:controller, :action, :model, :format, :request, :total, :include, :exclude]
  end

end
