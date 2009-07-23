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
          DateTime.strptime(self) rescue nil
        end
      end
      unless "".respond_to?(:to_datetime) 
        def to_date
          Date.strptime(self) rescue nil
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
      
    end
  end
end

class String
  include Resourceful::Extensions::String
end

class Hash
  include Resourceful::Extensions::Hash
end
