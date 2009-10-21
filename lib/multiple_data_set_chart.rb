module SmartChart
  class MultipleDataSetChart < BaseChart

    # chart labels
    attr_accessor :labels
    
    
    private # -----------------------------------------------------------------
    
    ##
    # Extract an array of arrays (data sets) from the +data+ attribute.
    #
    def data_values
      if [Array, Hash].include?(data.first.class)
        data.map{ |set| set.is_a?(Hash) ? set[:values] : set }
      else
        [data]
      end
    end

    ##
    # Raise an exception unless the provided data is given as an array.
    #
    def validate_data_format
      unless data.is_a?(Array)
        raise DataFormatError, "Data set(s) should be given as an array"
      end
    end

    ##
    # Make sure colors are valid hex codes.
    #
    def validate_colors
      super
      data.each do |d|
        if d.is_a?(Hash) and d.has_key?(:style) and c = d[:style][:color]
          validate_color(c)
        end
      end
    end
  end
end
