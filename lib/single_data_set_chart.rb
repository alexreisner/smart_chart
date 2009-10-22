module SmartChart
  class SingleDataSetChart < BaseChart

    # colors to be used
    attr_accessor :colors
    
    
    private # ---------------------------------------------------------------
    
    ##
    # Data to be encoded.
    #
    def data_values
      d = data.is_a?(Hash) ? data.to_a : data
      [d.inject([]){ |values,i| values << i[1] }]
    end
    
    ##
    # Texts of labels.
    #
    def labels
      d = data.is_a?(Hash) ? data.to_a : data
      d.inject([]){ |values,i| values << i[0] }
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
