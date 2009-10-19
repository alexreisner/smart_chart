module SmartChart
  class DataSet
  
    attr_accessor :values, :style
    
    def initialize(values, style)
      self.values = values
      self.style = style
    end
    
    def to_s
      Encoder::Simple.new(values).to_s
    end
  end
end
