module SmartChart
  class MultipleDataSetChart < BaseChart
    include GridLines
    include Axes
    
    ##
    # Hash mapping line style names to two-element arrays. This is a class
    # method so exceptions can access it to print a list of valid style names.
    #
    def self.line_styles(thickness = 1)
      {
        :solid  => [thickness * 1, thickness * 0],
        :dotted => [thickness * 1, thickness * 2],
        :short  => [thickness * 2, thickness * 4],
        :dashed => [thickness * 4, thickness * 4],
        :long   => [thickness * 6, thickness * 4]
      }
    end
    

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
    # Default line style provided by Google if no chls parameter is given.
    #
    def default_line_style
      [1.5, 1, 0]
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
          default_line_style
        end
      end
      # only return non-nil if styles other than default are given
      if lines.map{ |l| l == default_line_style ? nil : 1 }.compact.size > 0
        lines.map{ |s| s.join(",") }.join("|")
      end
    end
    
    ##
    # Build a three-element array describing a line style:
    # 
    #   [thickness, solid_segment_length, blank_segment_length]
    # 
    # Takes a data set hash or a symbol (shortcut for a pre-defined look).
    #
    def line_style_to_array(data)
      return default_line_style if data.nil?
      thickness = data[:thickness] || default_line_style.first
      style     = data[:style]
      style_arr = style.is_a?(Hash) ? [style[:solid], style[:blank]] :
                  line_style_definition(style, thickness)
      [thickness] + style_arr
    end
    
    ##
    # Translate a line style name (symbol) into a line style array
    # (two integers: solid segment length, blank segment length).
    # Takes a style name and line thickness.
    #
    def line_style_definition(symbol, thickness = 1)
      self.class.line_styles(thickness)[symbol] || default_line_style[1..2]
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
    
    ##
    # Make sure line style names are real.
    #
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
