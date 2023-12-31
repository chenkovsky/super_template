require_relative 'base'

module SuperTemplate
  if defined? ::Rails
    class Railtie < ::Rails::Railtie
    end
  end
end
