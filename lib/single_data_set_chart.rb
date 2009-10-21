module SmartChart
  class SingleDataSetChart < BaseChart

    # colors to be used
    attr_accessor :colors
    
    
    private # -----------------------------------------------------------------
    
    ##
    # Data to be encoded.
    #
    def data_values
      [data.values]
    end
    
    ##
    # Text of labels (array).
    #
    def labels
      data.keys
    end

    ##
    # Raise an exception unless the provided data is given as an array.
    #
    def validate_data_format
      unless data.is_a?(Hash)
        raise DataFormatError, "Data should be given as a hash"
      end
    end
    
    ##
    # Make sure colors are valid hex codes.
    #
    def validate_colors
      super
      return if colors.nil?
      colors.each{ |c| validate_color(c) }
    end

    # chco
    def chco
      colors.join(',') unless colors.nil?
    end
  end
end
