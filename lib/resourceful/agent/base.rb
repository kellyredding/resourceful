require 'log4r'
require File.join(File.dirname(__FILE__), '..', 'resource', 'cache.rb')

module Resourceful
  module Agent
    class Base
      
      attr_reader :logger, :cache

      ATTRS = [:host, :user, :password]
      ATTRS.each { |a| attr_reader a }
      
      def initialize(args={})
        ATTRS.each { |a| instance_variable_set("@#{a.to_s}", args.delete(a)) }
        @cache = Resourceful::Resource::Cache.new
        @logger = Log4r::Logger.new('Resourceful Base')
        @logger.add(Log4r::StdoutOutputter.new('console'))
      end
      
      def get(path, opts={}, &block)
        path, opts = check_config(path, opts)
        format = Resourceful::Resource::Format.get(opts[:format])
        
        full_resource_path = self.class.resource_path(path, format, opts[:params])
        resource_summary = summary('get', full_resource_path)
        cache_key = Resourceful::Resource::Cache.key(@host, 'get', full_resource_path)
        
        if opts[:force] || (resp = cache.read(cache_key)).nil?
          log "Resource call: #{resource_summary}"
          resp = cache.write(cache_key, block.call(full_resource_path))
        else
          log "Resource call: [CACHE] #{resource_summary}"
        end
        format.build(resp)
      end
    
      protected

      def check_config(path, opts) # :nodoc:
        raise Resourceful::Exceptions::ConfigurationError, "invalid Mechanize agent" unless agent && agent_url && !agent_url.empty?
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
        "#{verb.upcase} #{agent_url}#{full_resource_path}"
      end
        
      def agent_url
        @host
      end
      
      def log(msg, level = :info) # :nodoc:
        if(msg)
          if @logger && @logger.respond_to?(level)
            @logger.send(level.to_s, msg) 
          else
            puts "** [#{level.to_s.upcase}]: #{msg}"
          end
        end
      end
      
      def log=(file)
        @logger.add(Log4r::FileOutputter.new('fileOutputter', :filename => file, :trunc => false, :formatter => Log4r::PatternFormatter.new(:pattern => "[%l] %d :: %m"))) rescue nil
      end

    end
  end
end