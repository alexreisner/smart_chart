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
      [ grid_x_step || 0,
        grid_y_step || 0,
        style[1],
        style[2],
        (grid[:x] ? (grid[:x][:offset] || 0) : 0),
        (grid[:y] ? (grid[:y][:offset] || 0) : 0)
      ].join(",")
    end
    
    ##
    # Compute efficient grid x_step string.
    #
    def grid_x_step
      return nil unless grid.is_a?(Hash)
      return nil unless (grid[:x].is_a?(Hash) and s = grid[:x][:every])
      SmartChart.decimal_string(s.to_f * 100 / data_values_count.to_f)
    end
    
    ##
    # Compute efficient grid y_step string.
    #
    def grid_y_step
      return nil unless grid.is_a?(Hash)
      return nil unless (grid[:y].is_a?(Hash) and s = grid[:y][:every])
      range = y_max - y_min
      SmartChart.decimal_string(s.to_f * 100 / range.to_f)
    end
  end
end
