module SmartChart
  class ChartType
    
    def initialize(name)
      @name = name
    end
  
    def to_s
      "cht=#{@name}"
    end
  end
end
