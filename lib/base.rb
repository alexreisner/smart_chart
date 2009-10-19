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
    attr_accessor :width, :height
    
    # chart background
    attr_accessor :background

    # chart data
    attr_accessor :data
    
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
      unless width * height <= 300000
        raise DimensionsError
      end
    end
    
    
    # --- subclasses should not overwrite anything below this line ----------
    
    ##
    # The encoded query string for the chart. Uses %-encoding unless first
    # argument is false.
    #
    def query_string(encode = true)
      values = query_string_params.map{ |p| print_param(p) }
      qs = values.reject{ |v| v.nil? or v.size == 0 }.join("&")
      encode ? CGI.escape(qs) : qs
    end
    
    ##
    # Print a query string parameter (string: name=value).
    #
    def print_param(name)
      unless (value = send(name).to_s) == ""
        name.to_s + '=' + value
      end
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
        if send(param).nil?
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
        :cht,   # type
        :chs,   # size
        :chd,   # data
        :chco,  # color
        :chf,   # fill
        
        :chl,   # labels
        :chxt,  # axis_type
        :chxl,  # axis_labels
        :chxp,  # axis_label_positions
        :chxr,  # axis_range
        :chxs,  # axis_style
        :chma,  # margins
        
        :chbh,  # bar_spacing
        :chp,   # bar_chart_zero_line

        :chm,   # markers
        :chls,  # line_styles
        :chg,   # grid_lines

        :chtt,  # title
        :chdl,  # legend
        :chdlp, # legend_position
        
        :chds   # data_scaling -- never used
      ]
    end

    # cht
    def cht
      type.to_s
    end
    
    # chs
    def chs
      "#{width}x#{height}"
    end
    
    # chd
    def chd
      ChartData.new(data)
    end
    
    # chco
    def chco
      ""
    end
    
    # chf
    def chf
      ""
    end

    # chl
    def chl
      ""
    end
    
    # chxt
    def chxt
      ""
    end

    # chxl
    def chxl
      ""
    end

    # chxp
    def chxp
      ""
    end

    # chxr
    def chxr
      ""
    end

    # chxs
    def chxs
      ""
    end

    # chma
    def chma
      ""
    end

    # chbh
    def chbh
      ""
    end

    # chp
    def chp
      ""
    end

    # chm
    def chm
      ""
    end

    # chls
    def chls
      ""
    end

    # chg
    def chg
      ""
    end

    # chtt
    def chtt
      ""
    end

    # chdl
    def chdl
      ""
    end

    # chdlp
    def chdlp
      ""
    end

    # chds -- never used
    def chds          
      ""
    end
  end
end
