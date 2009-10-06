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

      unless "".respond_to?(:to_date) 
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
      
      unless "".respond_to?(:resourceful_constantize) 
        if Module.method(:const_get).arity == 1
          def resourceful_constantize #:nodoc:
            names = self.split('::')
            names.shift if names.empty? || names.first.empty?

            constant = ::Object
            names.each do |name|
              constant = constant.const_defined?(name) ? constant.const_get(name) : raise(NameError.new("uninitialized constant #{self}"))
            end
            constant
          end
        else # Ruby 1.9 version
          def resourceful_constantize #:nodoc:
            names = self.split('::')
            names.shift if names.empty? || names.first.empty?

            constant = ::Object
            names.each do |name|
              constant = constant.const_get(name, false) || raise(NameError.new("uninitialized constant #{self}"))
            end
            constant
          end
        end
      end

      unless "".respond_to?(:camelize)
        #   "active_record/errors".camelize         # => "ActiveRecord::Errors"
        def camelize(first_letter_in_uppercase = true)
          if first_letter_in_uppercase
            self.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
          else
            self[0..0].downcase + camelize(self)[1..-1]
          end
        end
        
      end
      
      unless "".respond_to?(:underscore)
        #   "ActiveRecord::Errors".underscore # => active_record/errors
        def underscore
          self.to_s.gsub(/::/, '/').
            gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
            gsub(/([a-z\d])([A-Z])/,'\1_\2').
            tr("-", "_").
            downcase
        end
      end
      
      unless "".respond_to?(:demodulize)
        #   "ActiveRecord::CoreExtensions::String::Inflections".demodulize # => "Inflections"
        def demodulize
          self.to_s.gsub(/^.*::/, '')
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
      #  {:id => [1,2]}.to_http_query_str
      #  # => "?id[]=1&id[]=2"
      #  {:poo => {:foo => 1, :bar => 2}}.to_http_query_str
      #  # => "?poo[bar]=2&poo[foo]=1"
      #  {:poo => {:foo => 1, :bar => {:bar1 => 1, :bar2 => "nasty"}}}.to_http_query_str
      #  "?poo[bar][bar1]=1&poo[bar][bar2]=nasty&poo[foo]=1"
      unless {}.respond_to?(:to_http_query_str) 
        def to_http_query_str(opts = {})
          require 'cgi' unless defined?(::CGI) && defined?(::CGI::escape)
          opts[:prepend] ||= '?'
          opts[:append] ||= ''
          opts[:key_ns] ||= nil
          opt_strings = self.collect do |key, val|
            key_s = opts[:key_ns] ? "#{opts[:key_ns]}[#{key.to_s}]" : key.to_s
            if val.kind_of?(::Array)
              val.collect{|i| "#{key_s}[]=#{::CGI.escape(i.to_s)}"}.join('&')
            elsif val.kind_of?(::Hash)
              val.to_http_query_str({
                :prepend => '',
                :key_ns => key_s,
                :append => ''
              })
            else
              "#{key_s}=#{::CGI.escape(val.to_s)}"
            end
          end 
          self.empty? ? '' : "#{opts[:prepend]}#{opt_strings.join('&')}#{opts[:append]}"
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
