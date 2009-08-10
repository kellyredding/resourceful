require 'mechanize'
require File.join(File.dirname(__FILE__), 'base.rb')

module Resourceful
  module Agent
    class Mechanize < Resourceful::Agent::Base
      
      ATTRS = [:agent_alias]
      ATTRS.each { |a| attr_reader a }
      
      def initialize(args={})
        ATTRS.each { |a| instance_variable_set("@#{a.to_s}", args.delete(a)) }
        super(args)
        self.log = yield if block_given?
        @mechanize = ::WWW::Mechanize.new do |obj|
          obj.log = @logger
          obj.user_agent_alias = @agent_alias unless @agent_alias.nil?
        end
      end

      def get(path, opts={}, &block)
        call_resource(:get, path, opts, block)
      end
    
      protected
      
      def call_resource(verb, path, opts, block)
        super(verb, path, opts) do |path|
          resp = ""
          @mechanize.send(verb.to_s, "#{@host}#{path}") do |page|
            resp = block ? block.call(page) : page
          end
          resp.body
        end
      end
      
      def agent
        @mechanize
      end
      
    end
  end
end
