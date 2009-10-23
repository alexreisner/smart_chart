module SmartChart
  class Line < MultipleDataSetChart
    
    # grid lines
    attr_accessor :grid
  
  
    private # ---------------------------------------------------------------
    
    ##
    # Specify the Google Chart type.
    #
    def type
      "lc"
    end

    ##
    # Array of all possible query string parameters.
    #
    def query_string_params
      super + [:chg]
    end
    
    ##
    # Grid lines parameter.
    #
    def chg
      return nil unless (grid.is_a?(Hash) and (grid[:x] or grid[:y]))
      style = line_style_to_array(grid[:line])
      parts = []
      parts << (grid[:x] ? (grid[:x][:every] || 0) : 0)
      parts << (grid[:y] ? (grid[:y][:every] || 0) : 0)
      parts << style[1]
      parts << style[2]
      parts << (grid[:x] ? (grid[:x][:offset] || 0) : 0)
      parts << (grid[:y] ? (grid[:y][:offset] || 0) : 0)
      parts.join(",")
    end
  end
end
