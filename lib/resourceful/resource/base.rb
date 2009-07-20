require 'rest_client'
require 'log4r'
require File.join(File.dirname(__FILE__), 'cache.rb')
require File.join(File.dirname(__FILE__), 'format.rb')
require File.join(File.dirname(__FILE__), '..', 'exceptions.rb')

module Resourceful
  module Resource
    class Base
      
      @@server = nil
      @@format = nil
      
      def self.configure(opts={})
        Resourceful::Resource::Cache.clear
        @@logger = Log4r::Logger.new('Resourceful Base')
        @@logger.add(Log4r::StdoutOutputter.new('console'))
        if block_given?
          log_file = yield
          @@logger.add(Log4r::FileOutputter.new('fileOutputter', :filename => log_file, :trunc => false, :formatter => Log4r::PatternFormatter.new(:pattern => "[%l] %d :: %m"))) rescue nil
          RestClient.log = log_file
        end
        @@server = opts[:server]
        @@format = begin
          raise "format nil" unless opts[:format]
          opts[:format].kind_of?(Resourceful::Resource::Format) ? opts[:format] : Resourceful::Resource::Format.send(opts[:format].to_s)
        rescue Exception => err
          Resourceful::Resource::Format.json
        end
      end

      # KDR: returns the resource specified in hash form
      def self.get(resource, args={}, force=false)
        check_config
        @@rest_client ||= ::RestClient::Resource.new("http://#{@@server}")
        request_summary = summary('get', resource, args)
        cache = Resourceful::Resource::Cache.new(@@server, 'get', resource, args)

        if force || (resp = cache.read).nil?
          log "Resource call: #{request_summary}"
          resp = cache.write(@@rest_client[path(resource, args)].get)
        else
          log "Resource call: [CACHE] #{request_summary}"
        end
        @@format.build(resp)
      end

      private

      def self.path(resource, args) # :nodoc:
        "#{resource}.#{@@format}#{args.to_http_query_str unless args.empty?}"
      end

      def self.summary(verb, resource, args) # :nodoc:
        "#{verb.upcase} #{@@rest_client.url}#{path(resource, args)}"
      end
      
      def self.check_config
        raise Resourceful::Exceptions::ConfigurationError, "please configure a server for Resourceful resources" unless @@server
        raise Resourceful::Exceptions::ConfigurationError, "please configure a valid Resourceful format" unless @@format
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