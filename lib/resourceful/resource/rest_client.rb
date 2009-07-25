require 'rest_client'
require File.join(File.dirname(__FILE__), 'format.rb')
require File.join(File.dirname(__FILE__), 'base.rb')

module Resourceful
  module Resource
    class RestClient < Resourceful::Resource::Base
      
      ATTRS = [:host, :user, :password]
      ATTRS.each { |a| attr_reader a }
      
      def initialize(args={})
        ATTRS.each { |a| instance_variable_set("@#{a.to_s}", args.delete(a)) }
        super(args)
        self.log = ::RestClient.log = yield if block_given?
        @agent = ::RestClient::Resource.new(@host, :user => @user, :password => @password)
      end

      def get(path, opts={})
        path, opts = check_config(path, opts)
        format = Resourceful::Resource::Format.get(opts[:format])
        
        full_resource_path = self.class.resource_path(path, format, opts[:params])
        resource_summary = summary('get', full_resource_path)
        cache_key = Resourceful::Resource::Cache.key(@host, 'get', full_resource_path)
        
        if opts[:force] || (resp = cache.read(cache_key)).nil?
          log "Resource call: #{resource_summary}"
          resp = cache.write(cache_key, @agent[full_resource_path].get)
        else
          log "Resource call: [CACHE] #{resource_summary}"
        end
        format.build(resp)
      end
    
      protected
    
      def check_config(path, opts)
        raise Resourceful::Exceptions::ConfigurationError, "invalid RestClient agent" unless @agent && @agent.url
        opts ||= {}
        opts[:force] ||= false
        if path =~ /^(.+)\.(.+)$/
          path = $1
          opts[:format] ||= $2
        end
        opts[:format] ||= Resourceful::Resource::Json.to_s
        opts[:params] ||= {}
        [path, opts]
      end
      
      def self.resource_path(path, format, params) # :nodoc:
        "#{path}.#{format}#{params.to_http_query_str unless params.empty?}"
      end
      
      def summary(verb, full_resource_path) # :nodoc:
        "#{verb.upcase} #{@agent.url}#{full_resource_path}"
      end
        
    end
  end
end
