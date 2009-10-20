module SmartChart
  class Map < Base
    
    
    private # ---------------------------------------------------------------
    
    ##
    # Specify the Google Chart type.
    #
    def type
      "t"
    end
    
    ##
    # Make sure chart dimensions are within Google's 440x220 limit.
    #
    def validate_dimensions
      if @width > 440 or @height > 220
        raise DimensionsError, "Map dimensions may not exceed 440x220 pixels"
      end
    end
  end
end
