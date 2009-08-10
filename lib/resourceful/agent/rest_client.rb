require 'rest_client'
require File.join(File.dirname(__FILE__), 'base.rb')

module Resourceful
  module Agent
    class RestClient < Resourceful::Agent::Base
      
     def initialize(args={})
        super(args)
        self.log = ::RestClient.log = yield if block_given?
        @rest_client = ::RestClient::Resource.new(@host, :user => @user, :password => @password)
      end

      def get(path, opts={}, &block)
        call_resource(:get, path, opts, block)
      end
      
      protected
      
      def call_resource(verb, path, opts, block)
        super(verb, path, opts) do |path|
          result = case verb.to_sym 
          when :get
            @rest_client[path].get
          when :post, :put, :delete
            @rest_client[path].send(verb, opts[:body])
          end
          block ? block.call(result) : result
        end
      end
      
      def agent
        @rest_client
      end
      
    end
  end
end
