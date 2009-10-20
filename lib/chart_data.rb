module SmartChart
  class ChartData
  
    attr_accessor :data
    
    def initialize(data)
      self.data = data
    end
    
    def to_s
      Encoder::Simple.new(data_sets).to_s
    end
    
    ##
    # Extract an array of arrays (data sets) from the +data+ attribute.
    #
    def data_sets
      if data.is_a?(Array)
        if [Array, Hash].include?(data.first.class)
          data.map{ |set| set.is_a?(Hash) ? set[:values] : set }
        else
          [data]
        end
      else
        raise DataFormatError, "Data set(s) should be given as an array"
      end
    end
  end
end
