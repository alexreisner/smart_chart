module SmartChart
  
  ##
  # Maximum length of URL accepted by Google.
  #
  URL_MAX_LENGTH = 2074

  ##
  # Method names are called attributes, data for URL are called parameters.
  # Use attr_writers for all attributes, and wrte readers so
  # they instantiate the correct object type.
  #
  class Base
    
    # dimensions of chart image, in pixels
    attr_writer :width, :height
    
    # chart background
    attr_writer :background

    # chart data
    attr_writer :data
    
    ##
    # Accept attributes and attempt to assign each to an attribute.
    #
    def initialize(options = {})
      options.each do |k,v|
        begin
          send("#{k}=", v)
        rescue NoMethodError
          raise NoAttributeError.new(self, k)
        end
      end
    end
    
    ##
    # Get the chart URL query string.
    #
    def to_query_string(encode = true, validation = true)
      validate if validation
      query_string(encode)
    end
    
    ##
    # Get the full chart URL.
    #
    def to_url(encode = true, validation = true)
      "http://chart.apis.google.com/chart?" + to_query_string(encode, validation)
    end
    
    ##
    # Chart as an HTML tag.
    #
    def to_html(encode = true, validation = true)
      '<img src="%s" />' % to_url(encode, validation)
    end
    
    ##
    # Run validation (may raise exceptions).
    #
    def validate!
      validate
    end
    
    ##
    # Does the chart pass all validations?
    #
    def valid?
      begin
        validate
        true
      rescue ValidationError
        false
      end
    end
    
    
    private # ---------------------------------------------------------------
    
    ##
    # Chart type URL parameter, for example:
    # 
    #   :bvs  # vertical bar
    #   :p    # pie
    #   :p3   # 3D pie
    # 
    # All subclasses *must* implement this method.
    #
    def type
      fail
    end
    
    ##
    # Array of names of required attributes.
    #
    def required_attrs
      [
        :width,
        :height,
        :data
      ]
    end
    
    ##
    # Array of validations to be run on the chart.
    #
    def validations
      [
        :required_attrs,
        :dimensions,
        :url_length
      ]
    end
    
    ##
    # Make sure chart dimensions are within Google's 300,000 pixel limit.
    #
    def validate_dimensions
      unless @width * @height <= 300000
        raise DimensionsError
      end
    end
    
    
    # --- subclasses should not overwrite anything below this line ----------
    
    ##
    # The encoded query string for the chart. Uses %-encoding unless first
    # argument is false.
    #
    def query_string(encode = true)
      values = query_string_params.map{ |p| send(p).to_s }
      qs = values.reject{ |v| v.nil? or v.size == 0 }.join("&")
      encode ? CGI.escape(qs) : qs
    end
    
    ##
    # Run all validations on the chart attributes.
    #
    def validate
      validations.each{ |v| send "validate_#{v}" }
    end
    
    ##
    # Make sure all required chart attributes are specified.
    #
    def validate_required_attrs
      required_attrs.each do |param|
        if instance_variable_get("@" + param.to_s).nil?
          raise MissingRequiredAttributeError.new(self, param)
        end
      end
    end
    
    ##
    # Make sure encoded URL is no longer than the maximum allowed length.
    #
    def validate_url_length
      raise UrlLengthError unless to_url(true, false).size <= URL_MAX_LENGTH
    end
    
    
    # --- URL parameter list and methods ------------------------------------
    
    ##
    # Array of names of all possible query string parameters in the order
    # in which they are output (for easier testing).
    #
    def query_string_params
      [
        :type,                 # cht
        :size,                 # chs
        :data,                 # chd
        :color,                # chco
        :fill,                 # chf
        
        :labels,               # chl
        :axis_type,            # chxt
        :axis_labels,          # chxl
        :axis_label_positions, # chxp
        :axis_range,           # chxr
        :axis_style,           # chxs
        :margins,              # chma
        
        :bar_spacing,          # chbh
        :bar_chart_zero_line,  # chp

        :markers,              # chm
        :line_styles,          # chls
        :grid_lines,           # chg

        :title,                # chtt
        :legend,               # chdl
        :legend_position,      # chdlp
        
        :data_scaling          # chds -- never used
      ]
    end

    # chs
    def size
      "chs=#{@width}x#{@height}"
    end
    
    # chd
    def data
      ChartData.new(@data)
    end
    
    # chco
    def color
      ""
    end
    
    # chf
    def fill
      ""
    end

    # chl
    def labels
      ""
    end
    
    # chxt
    def axis_type
      ""
    end

    # chxl
    def axis_labels
      ""
    end

    # chxp
    def axis_label_positions
      ""
    end

    # chxr
    def axis_range
      ""
    end

    # chxs
    def axis_style
      ""
    end

    # chma
    def margins
      ""
    end

    # chbh
    def bar_spacing
      ""
    end

    # chp
    def bar_chart_zero_line
      ""
    end

    # chm
    def markers
      ""
    end

    # chls
    def line_styles
      ""
    end

    # chg
    def grid_lines
      ""
    end

    # chtt
    def title
      ""
    end

    # chdl
    def legend
      ""
    end

    # chdlp
    def legend_position
      ""
    end

    # chds -- never used
    def data_scaling          
      ""
    end
  end
end
