module ResourcefulFeature
  module Helpers
    
    def self.safe_run_get
      begin
        yield
      rescue Exception => err
        err
      end
    end

  end
end
