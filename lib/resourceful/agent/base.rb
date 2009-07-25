require 'log4r'
require File.join(File.dirname(__FILE__), '..', 'resource', 'cache.rb')

module Resourceful
  module Agent
    class Base
      
      attr_reader :logger, :cache
      
      def initialize(args={})
        @cache = Resourceful::Resource::Cache.new
        @logger = Log4r::Logger.new('Resourceful Base')
        @logger.add(Log4r::StdoutOutputter.new('console'))
      end
      
      protected

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