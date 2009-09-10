module Resourceful
  module Extensions   
    module NilClass
      
      module ClassMethods; end
      def self.included(klass)
        klass.extend(ClassMethods) if klass.kind_of?(Class)
      end

      module ClassMethods
      end

      unless nil.respond_to?(:to_resourceful_boolean) 
        def to_resourceful_boolean
          !!self
        end
      end
      
    end
  end
end

module Resourceful
  module Extensions   
    module String
      
      module ClassMethods; end
      def self.included(klass)
        klass.extend(ClassMethods) if klass.kind_of?(Class)
      end

      module ClassMethods
      end

      unless "".respond_to?(:to_datetime) 
        def to_datetime
          ::DateTime.civil(*::Date._parse(self, false).values_at(:year, :mon, :mday, :hour, :min, :sec).map { |arg| arg || 0 }) rescue nil
        end
      end

      unless "".respond_to?(:to_datetime) 
        def to_date
          ::Date.civil(*::Date._parse(self, false).values_at(:year, :mon, :mday).map { |arg| arg || 0 }) rescue nil
        end
      end
      
      unless "".respond_to?(:to_resourceful_boolean) 
        def to_resourceful_boolean
          self.nil? || self.empty? || self =~ /^(false|0)$/i ? false : true
        end
      end
      
      unless "".respond_to?(:from_currency_to_f) 
        def from_currency_to_f
          self.gsub(/[^0-9.-]/,'').to_f
        end
      end
      
      unless "".respond_to?(:constantize) 
        if Module.method(:const_get).arity == 1
          def constantize #:nodoc:
            names = self.split('::')
            names.shift if names.empty? || names.first.empty?

            constant = ::Object
            names.each do |name|
              constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
            end
            constant
          end
        else # Ruby 1.9 version
          def constantize #:nodoc:
            names = self.split('::')
            names.shift if names.empty? || names.first.empty?

            constant = ::Object
            names.each do |name|
              constant = constant.const_get(name, false) || constant.const_missing(name)
            end
            constant
          end
        end
      end
      
    end
  end
end

module Resourceful
  module Extensions
    module Hash

      module ClassMethods; end
      def self.included(klass)
        klass.extend(ClassMethods) if klass.kind_of?(Class)
      end

      module ClassMethods
      end

      # Returns string formatted for HTTP URL encoded name-value pairs.
      # For example,
      #  {:id => 'thomas_hardy'}.to_http_query_str 
      #  # => "?id=thomas_hardy"
      #  {:id => 23423, :since => Time.now}.to_http_query_str
      #  # => "?since=Thu,%2021%20Jun%202007%2012:10:05%20-0500&id=23423"
      unless {}.respond_to?(:to_http_query_str) 
        def to_http_query_str(opts = {})
          require 'cgi' unless defined?(CGI) && defined?(CGI::escape)
          opts[:prepend] ||= '?'
          opts[:append] ||= ''
          self.empty? ? '' : "#{opts[:prepend]}#{self.collect{|key, val| "#{key.to_s}=#{CGI.escape(val.to_s)}"}.join('&')}#{opts[:append]}"
        end
      end
      
      # Returns the value for the provided key(s).  Allows searching in nested hashes
      unless {}.respond_to?(:get_value) 
        def get_value(*keys)
          val = self[keys.first] || self[keys.first.to_s]
          val = self[keys.first.to_s.intern] unless val || keys.first.to_s.empty? || keys.first.kind_of?(Symbol) 
          val.kind_of?(Hash) && keys.length > 1 ? val.get_value?(keys[1..-1]) : val
        end
      end

      # Determines if a value exists for the provided key(s).  Allows searching in nested hashes
      unless {}.respond_to?('check_value?') 
        def check_value?(*keys)
          val = self.get_value(keys)
          val && !val.empty? ? true : false
        end
      end

    end
  end
end

class NilClass
  include Resourceful::Extensions::NilClass
end

class String
  include Resourceful::Extensions::String
end

class Hash
  include Resourceful::Extensions::Hash
end
