require 'rest_client'
require 'log4r'
require File.join(File.dirname(__FILE__), 'cache.rb')
require File.join(File.dirname(__FILE__), 'format.rb')
require File.join(File.dirname(__FILE__), '..', 'exceptions.rb')

module Resourceful
  module Resource
    class Base
      
      @@host = nil
      @@logger = nil
      
      def self.configure(opts={})
        Resourceful::Resource::Cache.clear
        @@logger = Log4r::Logger.new('Resourceful Base')
        @@logger.add(Log4r::StdoutOutputter.new('console'))
        if block_given?
          log_file = yield
          @@logger.add(Log4r::FileOutputter.new('fileOutputter', :filename => log_file, :trunc => false, :formatter => Log4r::PatternFormatter.new(:pattern => "[%l] %d :: %m"))) rescue nil
          RestClient.log = log_file
        end
        @@host = opts[:host]
      end
      
      def self.host
        @@host
      end
      
      def self.logger
        @@logger
      end

      # KDR: returns the resource specified in hash form
      def self.get(path, opts={}, force=false)
        path, opts = check_config(path, opts)
        @@rest_client ||= ::RestClient::Resource.new("http://#{@@host}")
        format = Resourceful::Resource::Format.get(opts[:format])
        request_summary = summary('get', path, format, opts[:params])
        cache = Resourceful::Resource::Cache.new(@@host, 'get', path, format, opts[:params])

        if force || (resp = cache.read).nil?
          log "Resource call: #{request_summary}"
          resp = cache.write(@@rest_client[rest_path(path, format, opts[:params])].get)
        else
          log "Resource call: [CACHE] #{request_summary}"
        end
        format.build(resp)
      end

      private

      def self.summary(verb, path, format, params) # :nodoc:
        "#{verb.upcase} #{@@rest_client.url}#{rest_path(path, format, params)}"
      end
      
      def self.rest_path(path, format, params) # :nodoc:
        "#{path}.#{format}#{params.to_http_query_str unless params.empty?}"
      end

      def self.check_config(path, opts)
        raise Resourceful::Exceptions::ConfigurationError, "please configure a host for Resourceful resources" unless @@host
        if path =~ /^(.+)\.(.+)$/
          path = $1
          opts[:format] ||= $2
        end
        opts[:format] ||= Resourceful::Resource::Json.to_s
        opts[:params] ||= {}
        [path, opts]
      end
      
      def self.log(msg, level = :info) # :nodoc:
        if(msg)
          if @@logger && @@logger.respond_to?(level)
            @@logger.send(level.to_s, msg) 
          else
            puts "** [#{level.to_s.upcase}]: #{msg}"
          end
        end
      end 

    end
  end
end