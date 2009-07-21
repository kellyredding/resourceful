Dir[File.join(File.dirname(__FILE__), "resource" ,"*.rb")].each do |file|
  require file
end

module Resourceful
  module Resource
    
    def self.configure(opts={}, &block)
      Resourceful::Resource::Base.configure(opts, &block)
    end

    def self.get(resource, opts={}, force=false)
      Resourceful::Resource::Base.get(resource, opts, force)
    end

    def self.host
      Resourceful::Resource::Base.host
    end

    def self.logger
      Resourceful::Resource::Base.logger
    end

  end
end