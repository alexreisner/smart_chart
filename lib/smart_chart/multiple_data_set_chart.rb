module SmartChart
  class MultipleDataSetChart < BaseChart
    include GridLines
    include Labels
    include AxisLines
    
    private # ---------------------------------------------------------------
    
    ##
    # Extract an array of arrays (data sets) from the +data+ attribute.
    #
    def data_values
      if bare_data_set?
        [data]
      else
        data.map{ |set| set.is_a?(Hash) ? set[:values] : set }
      end
    end

    ##
    # Array of all possible query string parameters.
    #
    def query_string_params
      super + [:chls]
    end
    
    ##
    # Line style parameter.
    #
    def chls
      validate_data_format
      return nil if bare_data_set?
      lines = data.map do |set|
        if set.is_a?(Hash)
          line_style_to_array(set)
        else
          [1, 1, 0]
        end
      end
      # only return non-nil if styles other than default are given
      if lines.map{ |l| l == [1,1,0] ? nil : 1 }.compact.size > 0
        lines.map{ |s| s.join(",") }.join("|")
      end
    end
    
    ##
    # Translate a line style to a three-element array:
    #
    #   [thickness, solid, blank]
    #
    # Takes a hash or a symbol (shortcut for a pre-defined look).
    #
    def line_style_to_array(data)
      return [1, 1, 0] if data.nil?
      thickness = data[:thickness] || 1
      style     = data[:style]
      style_arr = style.is_a?(Hash) ? [style[:solid], style[:blank]] :
        line_style_definition(style, thickness)
      [thickness] + style_arr
    end
    
    ##
    # Translate a symbol into a line style: a two-element array (solid line
    # length, blank line length). Takes a style name and line thickness.
    #
    def line_style_definition(symbol, thickness = 1)
      self.class.line_styles(thickness)[symbol] || [1, 0]
    end
    
    ##
    # Get a hash of line style definitions.
    #
    def self.line_styles(thickness = 1)
      {
        :solid  => [thickness * 1, thickness * 0],
        :dotted => [thickness * 1, thickness * 1],
        :short  => [thickness * 2, thickness * 4],
        :dashed => [thickness * 4, thickness * 4],
        :long   => [thickness * 6, thickness * 4]
      }
    end
    
    ##
    # Array of validations to be run on the chart.
    #
    def validations
      [:line_style_names] + super
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
        if d.is_a?(Hash) and c = d[:color]
          validate_color(c)
        end
      end
    end
    
    def validate_line_style_names
      data.each do |d|
        if d.is_a?(Hash) and d.is_a?(Hash)
          if (style = d[:style]).is_a?(Symbol)
            unless self.class.line_styles.keys.include?(style)
              raise LineStyleNameError,
                "Line style name '#{style}' is not valid. " +
                "Try one of: #{self.class.line_styles.keys.join(', ')}"
            end
          end
        end
      end
    end
  end

  
  class LineStyleNameError < ValidationError #:nodoc:
  end
end
