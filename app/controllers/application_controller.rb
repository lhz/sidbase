class ApplicationController < ActionController::Base

  layout false

  protected

  def request_id
    request.uuid
  end

end
