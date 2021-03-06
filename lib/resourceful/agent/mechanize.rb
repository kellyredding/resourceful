require 'mechanize'
require "resourceful/agent/base"

module Resourceful; end

module Resourceful::Agent
  class Mechanize < Resourceful::Agent::Base
    
    ATTRS = [:agent_alias, :verbose]
    ATTRS.each { |a| attr_reader a }
    
    def initialize(args={})
      @verbose ||= false
      ATTRS.each { |a| instance_variable_set("@#{a.to_s}", args.delete(a)) if args[a] }
      super(args)
      self.log = yield if block_given?
      @mechanize = ::WWW::Mechanize.new do |obj|
        obj.log = @logger && @verbose ? @logger : nil
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
