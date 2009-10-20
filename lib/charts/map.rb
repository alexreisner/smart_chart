module SmartChart
  class Map < Base
    
    # region depicted
    attr_accessor :region
    
     
    private # ---------------------------------------------------------------
    
    ##
    # Specify the Google Chart type.
    #
    def type
      "t"
    end
    
    ##
    # Map region query string parameter.
    #
    def chtm
      region || "world"
    end
    
    ##
    # Array of validations to be run on the chart.
    #
    def validations
      super + [:map_region]
    end

    ##
    # Validate the given map region against Google's available options.
    #
    def validate_map_region
      regions = %w[africa asia europe middle_east south_america usa world]
      unless region.nil? or regions.include?(region.to_s)
        raise DataFormatError, "Map region must be one of: #{regions.join(', ')}"
      end
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
