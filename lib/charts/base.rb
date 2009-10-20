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
    
    # chart data
    attr_accessor :data
    
    # chart labels
    attr_accessor :labels
    
    # chart background
    attr_accessor :background

    # bar chart orientation -- :vertical (default) or :horizontal
    # pie chart orientation -- degrees of rotation
    attr_accessor :orientation
    
    # bar   -- :grouped (default) or :stacked
    # pie   -- nil (2D, default), "3d", or :concentric
    # radar -- nil (default) or :filled
    attr_accessor :style
    
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
      "http://chart.apis.google.com/chart?" +
        to_query_string(encode, validation)
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
        :data_format,
        :labels,
        :colors,
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
    
    ##
    # Raise an exception unless the provided data is given as an array.
    #
    def validate_data_format
      unless data.is_a?(Array)
        raise DataFormatError, "Data set(s) should be given as an array"
      end
    end
    
    
    # --- subclasses should not overwrite anything below this line ----------
    
    ##
    # The query string for the chart.
    #
    def query_string(encode = true)
      values = query_string_params.map{ |p| format_param(p, encode) }
      values.compact.join("&")
    end
    
    ##
    # Format a query string parameter for a URL (string: name=value). Uses
    # %-encoding unless second argument is false.
    #
    def format_param(name, encode = true)
      unless (value = send(name).to_s) == ""
        value = CGI.escape(value) if encode
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
    
    ##
    # Make sure colors are valid hex codes.
    #
    def validate_colors
      data.each do |d|
        if d.is_a?(Hash) and d.has_key?(:style) and c = d[:style][:color]
          raise ColorFormatError unless c.match(/^[0-9A-Fa-f]{6}$/)
        end
      end
    end
    
    ##
    # Make sure labels are specified in proper format
    #
    def validate_labels
    end
    
    ##
    # Extract an array of arrays (data sets) from the +data+ attribute.
    #
    def data_set_values
      if [Array, Hash].include?(data.first.class)
        data.map{ |set| set.is_a?(Hash) ? set[:values] : set }
      else
        [data]
      end
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
        :chp,   # bar_chart_zero_line, pie chart rotation

        :chm,   # markers
        :chls,  # line_styles
        :chg,   # grid_lines

        :chtt,  # title
        :chdl,  # legend
        :chdlp, # legend_position
        
        :chtm,  # map region
        :choe,  # QR encoding
        
        :chds   # data_scaling -- never used
      ]
    end

    #
    # All parameter methods should return a string, or an object that 
    # renders itself as a string via the to_s method.
    #

    # cht
    def cht
      type
    end
    
    # chs
    def chs
      "#{width}x#{height}"
    end
    
    # chd
    def chd
      Encoder.encode(data_set_values)
    end
    
    # chco
    def chco
      data.map{ |d|
        if (d.is_a?(Hash) and d.has_key?(:style)) and c = d[:style][:color]
          c = [c] unless c.is_a?(Array)
          c.join('|') # data point delimiter
        end
      }.compact.join(',') # data set delimiter
    end
    
    # chf
    def chf
      nil
    end

    # chl
    def chl
      nil
    end
    
    # chxt
    def chxt
      nil
    end

    # chxl
    def chxl
      nil
    end

    # chxp
    def chxp
      nil
    end

    # chxr
    def chxr
      nil
    end

    # chxs
    def chxs
      nil
    end

    # chma
    def chma
      nil
    end

    # chbh
    def chbh
      nil
    end

    # chp
    def chp
      nil
    end

    # chm
    def chm
      nil
    end

    # chls
    def chls
      nil
    end

    # chg
    def chg
      nil
    end

    # chtt
    def chtt
      nil
    end

    # chdl
    def chdl
      nil
    end

    # chdlp
    def chdlp
      nil
    end

    # chtm -- only for map
    def chtm
      nil
    end

    # choe -- only for barcode
    def choe
      nil
    end

    # chds -- never used
    def chds          
      nil
    end
  end
end
