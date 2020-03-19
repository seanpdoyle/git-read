require "middleman/rack"

module MiddlemanHelpers
  def application
    @application ||= Middleman::Application.new
  end

  def config
    application.config
  end
end
