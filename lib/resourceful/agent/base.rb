require 'log4r'
require "resourceful/resource/cache"

module Resourceful; end

module Resourceful::Agent
  class Base
    
    attr_reader :logger, :cache, :expiration, :log_prefix

    ATTRS = [:host, :user, :password, :expiration, :log_prefix]
    ATTRS.each { |a| attr_reader a }
    
    def initialize(args={})
      ATTRS.each { |a| instance_variable_set("@#{a.to_s}", args.delete(a)) }
      @cache = Resourceful::Resource::Cache.new @expiration
      @logger = Log4r::Logger.new('[Resourceful]')
      @logger.add(Log4r::StdoutOutputter.new('console'))
    end
    
    protected

    def call_resource(verb, path, opts={}, &block)
      path, opts = check_config(path, opts)
      format = Resourceful::Resource::Format.get(opts[:format])
      
      full_resource_path = self.class.resource_path(path, format, opts[:params])
      resource_summary = summary(verb.to_s, full_resource_path)
      cache_key = Resourceful::Resource::Cache.key(@host, verb.to_s, full_resource_path)
      
      if opts[:force] || (resp = cache.read(cache_key)).nil?
        log "#{resource_summary}"
        resp = cache.write(cache_key, block.call(full_resource_path))
      else
        log "[CACHE] #{resource_summary}"
      end
      format.build(resp)
    end
  
    def check_config(path, opts) # :nodoc:
      raise Resourceful::Exceptions::ConfigurationError, "invalid agent" unless agent && agent_url && !agent_url.empty?
      opts ||= {}
      opts[:force] ||= false
      if path =~ /^(.+)\.(.+)$/
        opts[:format] ||= $2
      end
      opts[:format] ||= Resourceful::Resource::Json.to_s
      opts[:params] ||= {}
      [path, opts]
    end
    
    def self.resource_path(path, format, params) # :nodoc:
      "#{path}#{params.to_http_query_str unless params.empty?}"
    end
    
    def summary(verb, full_resource_path) # :nodoc:
      "#{verb.upcase} #{agent_url}#{full_resource_path}"
    end
      
    def agent_url
      @host
    end
    
    def log(msg, level = :info) # :nodoc:
      @logger.send(level.to_s, "#{"[#{@log_prefix.to_s}]" if @log_prefix} #{msg}") if msg
    end
    
    def log=(file)
      @logger.add(Log4r::FileOutputter.new('fileOutputter', :filename => file, :trunc => false, :formatter => Log4r::PatternFormatter.new(:pattern => "[%l] %d :: %m"))) rescue nil
    end

  end
end