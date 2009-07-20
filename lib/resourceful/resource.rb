Dir[File.join(File.dirname(__FILE__), "resource" ,"*.rb")].each do |file|
  require file
end

module Resourceful
  module Resource
    
    def self.configure(opts={}, &block)
      Resourceful::Resource::Base.configure(opts, &block)
    end

    def self.get(resource, args={}, force=false)
      Resourceful::Resource::Base.get(resource, args, force)
    end

  end
end