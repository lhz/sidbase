class ApiController < ApplicationController

  # Capture exceptions while parsing incoming JSON and so on
  rescue_from(StandardError) { |ex| handle_exception(ex) }

  around_filter :log_request
  around_filter :read_request_wrapper,  :only   => [:index, :show]
  around_filter :write_request_wrapper, :except => [:index, :show]
  after_filter  :response_headers

  respond_to :json

  # OPTIONS /api/v1/:model
  def options
    headers['Allow'] = 'HEAD,GET'
    render :nothing => true, :status => 200, :content_type => 'text/plain'
  end

  # GET /api/v1/:model.:format
  def index
    query = QueryBuilder.new(model, params)
    result  = query.search
    objects = result[:objects]
    if stale?(:etag => objects, :last_modified => objects.map(&:updated_at).max, :public => true)
      header :count, result[:count]
      header :total, result[:total] if result[:total]
      render :json => objects, :each_serializer => index_serializer
    end
  end

  # GET /api/v1/:model/:id.:format
  def show
    object = model.find(params[:id])
    if stale?(object, :public => true)
      render :json => object, :serializer => show_serializer
    end
  end

  def default_serializer_options
    { :root => false }
  end


  private


  def logger
    API_LOGGER
  end

  def format
    params[:format].to_sym
  end

  def model
    @model ||= Inflector.modelize(params[:model].to_s)
  rescue
    raise ApiException.invalid_model(params[:model].to_s)
  end

  def index_serializer
    "#{model}IndexSerializer".constantize
  end

  def show_serializer
    "#{model}Serializer".constantize
  end

  def read_request_wrapper(&block)
    request_wrapper :read, &block
  end

  def write_request_wrapper(&block)
    request_wrapper :write, &block
  end

  def request_wrapper(operation, &block)
    begin
      yield
    rescue Exception => ex
      handle_exception(ex)
    end
  end

  def response_headers
    if request.get?
      headers['Cache-Control'] = 'must-revalidate'
    end
    if request.query_string.size > 0
      header :query, request.query_string
    end
  end

  # Handle exception that occured during action processing
  def handle_exception(ex)
    logger.error "EXCEPTION: #{ex}\n#{ex.backtrace.join("\n")}"
    case ex
    when ActiveRecord::RecordNotFound
      id  = params[:id]
      ax = ApiException.record_not_found(model, id, ex)
    when ActiveRecord::RecordInvalid
      ax = ApiException.validation_failed(ex.record)
    when ActiveRecord::ActiveRecordError
      ax = ApiException.active_record_error(model.name, ex)
    when ApiException
      ax = ex
    else
      raise ex
    end

    log_exception(ax)

    render params[:format].to_sym => ax,
      :status => (wex.try(:status) rescue :unprocessable_entity)
  end

  # Set HTTP header for response metadata
  def header(name, value)
    name = name.to_s.split('_').map(&:capitalize).join('-')
    headers["X-Api-#{name}"] = value.to_s
  end

  # Generate options hash from params
  def options_hash
    @options ||= {
      :request => request,
      :format  => check_format(params[:format]),
      :include => param_list_to_symbols(:include),
      :exclude => param_list_to_symbols(:exclude),
      :delete  => param_list_to_symbols(:delete),
      :pretty  => params[:pretty],
    }
  end

  def param_list_to_symbols(key)
    (params[key] || "").split(',').map(&:to_sym)
  end

  # Ensure format is supported
  def check_format(format)
    format && [:json].include?(format.to_sym) or
      raise ApiException.unsupported_format(format)
    format
  end

  def log_request
    started_at = Time.now
    logger.prefix = "[#{request.uuid}]"
    logger.info "#{request.method} REQUEST TO #{request.path} #{params.inspect}"
    yield
    millisecs = "%.3f" % [(Time.now - started_at) * 1000]
    logger.info { "#{request.method} REQUEST COMPLETED IN #{millisecs} ms." }
    logger.prefix = nil
  end

  def log_exception(exception)
    logger.error "API_EXCEPTION: #{exception}"
  end

end
