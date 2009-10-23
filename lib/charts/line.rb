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

      style  = line_style_to_array(grid[:line])

      parts  = []
      parts << grid_x_step || 0
      parts << (grid[:y] ? (grid[:y][:every] || 0) : 0)
      parts << style[1]
      parts << style[2]
      parts << (grid[:x] ? (grid[:x][:offset] || 0) : 0)
      parts << (grid[:y] ? (grid[:y][:offset] || 0) : 0)
      parts.join(",")
    end
    
    ##
    # Compute efficient grid x_step string (up to 3 decimal places).
    #
    def grid_x_step
      return nil unless grid.is_a?(Hash)
      return nil unless (grid[:x].is_a?(Hash) and step = grid[:x][:every])
      step = "%.3f" % (step.to_f * 100 / data_values_count.to_f)
      step = step[0...-1] while step[-1,1] == "0"
      step = step[0...-1] if step[-1,1] == "." # leave zeros left of .
      step
    end
  end
end
