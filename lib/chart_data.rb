module SmartChart
  class ChartData
  
    attr_accessor :data
    
    def initialize(data)
      self.data = data
    end
    
    ##
    # Extract an array of arrays (datasets) from the +data+ attribute.
    #
    def data_sets
      return [data] if (
        data.is_a?(Array) and ![Array, Hash].include?(data.first.class))
      data.map{ |set| set.is_a?(Hash) ? set[:values] : set }
    end
    
    def to_s
      Encoder::Simple.new(data_sets).to_s
    end
  end
end
