module SmartChart
  class ChartData
  
    def initialize(data)
      @data = data
    end
    
    def to_s
      "chd=" + Encoder::Simple.new(@data).to_s
    end
  end
end
