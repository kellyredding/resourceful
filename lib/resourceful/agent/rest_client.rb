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

      def get(path, opts={})
        super(path, opts) do |path|
          @rest_client[path].get
        end
      end
      
      protected
      
      def agent
        @rest_client
      end
      
    end
  end
end
