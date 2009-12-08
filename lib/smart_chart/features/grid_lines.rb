module SmartChart
  module GridLines

    def self.included(base)
      base.class_eval do
        attr_accessor :grid
      end
    end


    private # ---------------------------------------------------------------
  
    ##
    # Grid lines parameter.
    #
    def chg
      return nil unless (grid.is_a?(Hash) and (grid[:x] or grid[:y]))
      style = line_style_to_array(grid)
      [ x_grid_property(:every) || 0,
        y_grid_property(:every) || 0,
        style[1],
        style[2],
        x_grid_property(:offset) || 0,
        y_grid_property(:offset) || 0
      ].join(",")
    end
  
    ##
    # Compute x-grid :every or :offset (as a string).
    #
    def x_grid_property(property)
      return nil unless grid.is_a?(Hash)
      return nil unless (grid[:x].is_a?(Hash) and s = grid[:x][property])
      SmartChart.decimal_string(s.to_f * 100 / data_values_count.to_f)
    end
  
    ##
    # Compute y-grid :every or :offset (as a string).
    #
    def y_grid_property(property)
      return nil unless grid.is_a?(Hash)
      return nil unless (grid[:y].is_a?(Hash) and s = grid[:y][property])
      range = y_max - y_min
      SmartChart.decimal_string(s.to_f * 100 / range.to_f)
    end
  end
end