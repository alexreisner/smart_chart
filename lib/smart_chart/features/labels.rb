module SmartChart
  module Labels

    def self.included(base)
      base.class_eval do
        attr_accessor :labels
      end
    end


    private # ---------------------------------------------------------------
  
    ##
    # Labels parameter.
    #
    def chdl
      unless bare_data_set?
        labels = data.map{ |d| d.is_a?(Hash) ? d[:label] : nil }
        labels.compact.size > 0 ? labels.join("|") : nil
      end
    end
  end
end