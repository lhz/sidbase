# -*- coding: utf-8 -*-

class ApiException < Exception

  attr_reader :status, :errors

  def initialize(error = nil)
    @errors = []
    if error.nil?
      @status = :bad_request # Default HTTP response code
    elsif error.is_a?(Exception)
      internal_server_error(error)
    elsif error.is_a?(Hash)
      @status = error[:status] || :bad_request
      add_error(error)
    else
      @status = :internal_server_error
      add_error(:code => 'UNKNOWN', :message => 'Systemfeil.')
    end
  end

  def self.access_denied(client, model_name, mode)
    if client.nil?
      new(:code   => 'NOT_AUTHENTICATED',
        :status   => :forbidden,
        :message  => 'This service requires client authentication.' )
    else
      new(:code   => 'ACCESS_DENIED',
        :details  => {
          :client_app => client,
          :model => model_name.to_s,
          :mode => mode.to_s,
          :accesses => ClientAccess.instance.accesses_for_client(client)
        },
        :status   => :forbidden,
        :message  => 'Access to the requested resource is forbidden.' )
    end
  end

  def self.invalid_model(model_name)
    new(:code     => 'INVALID_MODEL',
        :status   => :bad_request,
        :details  => {:model => model_name.to_s},
        :message  => "Invalid model '#{model_name}'." )
  end

  def self.validation_failed(object)
    err_string = object.errors.to_a.join(", ")
    ex = new(:code   => 'VALIDATION_FAILED',
             :message => "#{object.class.name}: #{err_string}.",
             :status => :unprocessable_entity,
             :details => { :model => object.class.name,
                           :errors => object.errors.to_a })
  end

  def self.active_record_error(model_name, ex)
    new(:code      => 'DATABASE_ERROR',
        :message   => "Error during database operation: #{ex.message}",
        :details   => {:model => model_name.to_s},
        :status    => :bad_request,
        :exception => ex)
  end

  def self.record_not_found(model, id, ex)
    new(:code      => 'NOT_FOUND',
        :message   => 'The requested object does not exist.',
        :details   => {:model => model.name, :id => id},
        :status    => :not_found,
        :exception => ex)
  end

  def self.parse_error(msg)
    new(:code    => 'PARSE_ERROR',
        :message => 'The posted data could not be parsed.',
        :status  => :unprocessable_entity,
        :details => msg)
  end

  def self.unsupported_format(format)
    new(:code    => 'UNSUPPORTED_FORMAT',
        :message => 'Det forespurte formatet støttes ikke.',
        :details => {:format => format},
        :status  => :unsupported_media_type)
  end

  def self.invalid_event(event)
    new(:code    => 'INVALID_EVENT',
        :message => "Ugylding event: #{event}",
        :details => {:event => event},
        :status  => :forbidden)
  end

  def internal_server_error(error)
    @status = :internal_server_error
    add_error(:code      => 'UNKNOWN',
              :message   => 'En ukjent feil har oppstått.',
              :details   => error.message,
              :exception => error)
  end

  def add_error(params)
    @errors << Error.new(params)
  end

  def add_errors(errors)
    errors.each { |err| add_error(err) }
  end

  def to_s(options = {})
    @errors.reduce("ApiException\n\n") { |text, error| text << error.to_s }
  end

  def to_hash
    arr = @errors.reduce([]) { |arr, error| arr << error.to_hash }
    {:exception => {:errors => arr}}
  end

  class Error
    attr_accessor :code, :message, :details, :exception

    def attributes
      [:code, :message, :details, :exception]
    end

    def initialize(params = {})
      attributes.each do |att|
        self.send("#{att}=", params[att]) if params[att]
      end
    end

    def to_hash
      hash = {}
      attributes.each do |att|
        val = self.send("#{att}")
        hash[att] = val if val
      end
      hash
    end

    def to_s
      to_hash.reduce("Error\n") do |text, (key, value)|
        text << "  #{key.capitalize}: #{value}\n"
      end
    end
  end
end
