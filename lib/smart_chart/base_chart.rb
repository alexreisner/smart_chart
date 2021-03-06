module SmartChart
  
  ##
  # Maximum length of URL accepted by Google.
  #
  URL_MAX_LENGTH = 2074

  ##
  # Takes a decimal number and returns a string with up to +frac+
  # digits to the right of the '.'.
  #
  def self.decimal_string(num, frac = 3)
    str = "%.#{frac}f" % num
    str = str[0...-1] while str[-1,1] == "0"
    str = str[0...-1] if str[-1,1] == "." # leave zeros left of .
    str
  end
  
  ##
  # Method names are called attributes, data for URL are called parameters.
  # Use attr_writers for all attributes, and wrte readers so
  # they instantiate the correct object type.
  #
  class BaseChart
    
    # dimensions of chart image, in pixels
    attr_accessor :width, :height
    
    # chart data
    attr_accessor :data
    
    # chart range
    attr_accessor :y_min, :y_max
    
    # chart background
    attr_accessor :background
    
    # chart margins
    attr_accessor :margins

    # legend properties
    attr_accessor :legend

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
    def to_query_string(options = {})
      options[:encode] = true unless options.include?(:encode)
      options[:validation] = true unless options.include?(:validation)
      validate(options[:skip_validation]) if options[:validation]
      query_string(options[:encode])
    end

    ##
    # Get the chart as raw image data (fetch from Google).
    #
    def to_image_data(options = {})
      options[:validation] = true unless options.include?(:validation)
      options[:skip_validation] = [:url_length] unless options[:skip_validation]
      validate(options[:skip_validation]) if options[:validation]
      fetch_raw_image_data.to_s
    end
    
    ##
    # Get the full chart URL.
    #
    def to_url(options = {})
      options[:encode] = true unless options.include?(:encode)
      options[:validation] = true unless options.include?(:validation)
      google_charts_base_url + "?" + to_query_string(options)
    end

    ##
    # Chart as an HTML tag.
    #
    def to_html(options = {})
      options[:encode] = true unless options.include?(:encode)
      options[:validation] = true unless options.include?(:validation)
      attributes = {:width => width, :height => height}
      attributes.merge! options.reject{ |k,v|
        [:post, :encode, :validation].include?(k)
      }
      if options[:post]
        require 'base64'
        src = 'data:image/png;base64,' + Base64.encode64(to_image_data)
      else
        src = to_url(options)
      end
      '<img src="%s"%s />' % [src, tag_attributes(attributes)]
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
    # Get an array of values to be graphed.
    # Subclasses *must* implement this method.
    #
    def data_values
      fail 
    end
    
    ##
    # The number of data points represented along the x-axis.
    #
    def data_values_count
      data_values.map{ |set| set.size }.max.to_i
    end
    
    ##
    # Get the minimum Y-value for the chart (from data or explicitly set).
    #
    def y_min
      @y_min || data_values.flatten.compact.min
    end
    
    ##
    # Get the maximum Y-value for the chart (from data or explicitly set).
    #
    def y_max
      @y_max || data_values.flatten.compact.max
    end
    
    ##
    # Translate a number to a position on the x-axis (percentage). Numbers
    # start at 0 so the maximum allowed number is sample size minus one.
    #
    def x_axis_position(num)
      100.0 * num / (data_values_count - 1)
    end
    
    ##
    # Translate a number to a position on the y-axis (percentage). Range
    # of the axis is y_min to y_max.
    #
    def y_axis_position(num)
      100.0 * (num - y_min) / (y_max - y_min).to_f
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
      raise DimensionsError unless width * height <= 300000
    end
    
    ##
    # Validate data format.
    # Subclasses *must* implement this method.
    #
    def validate_data_format
      fail
    end
    
    ##
    # Make sure labels are specified in proper format
    # Subclasses *must* implement this method.
    #
    def validate_labels
    end
    
    ##
    # Make sure colors are valid hex codes.
    # Subclasses should probably implement this method.
    #
    def validate_colors
      validate_color(background) 
    end
    
    
    # --- subclasses should not overwrite anything below this line ----------

    ##
    # Send a POST request to Google to get chart raw PNG data.
    #
    def fetch_raw_image_data
      require 'uri'
      require 'net/http'
      uri = URI.parse(google_charts_base_url)
      res = Net::HTTP.post_form(uri,
        Hash[*query_string_values(false).flatten])
      res.code == "200" ? res.body : nil
    end

    ##
    # The query string for the chart.
    #
    def query_string(encode = true)
      query_string_values(encode).map{ |i| i.map{ |j| j.to_s } * "=" } * "&"
    end

    ##
    # Array of URL-encoded chart parameters and values
    # (two-element [key, val] arrays).
    #
    def query_string_values(encode = true)
      query_string_params.map{ |p|
        [p, param_value(p, encode)]
      }.reject{ |p,v| v.nil? }
    end

    ##
    # Parameter's current value, URL-encoded unless second argument is false.
    #
    def param_value(name, encode = true)
      value = send(name).to_s
      if value == ""
        value = nil
      else
        value = CGI.escape(value) if encode
      end
      value
    end

    ##
    # Is the data given as a single bare array of values?
    #
    def bare_data_set?
      data.is_a?(Array) and ![Array, Hash].include?(data.first.class)
    end

    ##
    # Run all validations on the chart attributes.
    # Takes an array of validations to skip.
    #
    def validate(skip = [])
      skip = [skip] unless skip.is_a?(Array)
      validations.reject{ |v| skip.include?(v) }.each do |v|
        send "validate_#{v}"
      end
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
      raise UrlLengthError unless to_url(:validation => false).size <= URL_MAX_LENGTH
    end
    
    ##
    # Validate a single color (this is not a normal validator).
    #
    def validate_color(c)
      raise ColorFormatError unless (c.nil? or c.match(/^[0-9A-Fa-f]{6}$/))
    end
    
    ##
    # Render attributes of an HTML tag.
    #
    def tag_attributes(attributes)
      attrs = []
      attributes.each_pair do |key, value|
        attrs << %(#{key}="#{value.to_s.gsub('"', '\"')}") unless value.nil?
      end
      " #{attrs.sort * ' '}" unless attrs.empty?
    end
    
    def google_charts_base_url
      'http://chart.apis.google.com/chart'
    end
    
    
    # --- URL parameter list and methods ------------------------------------
    
    ##
    # Array of universal query string parameters in the order
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
        :chxs,  # axis_style
        :chxl,  # axis_labels
        :chxp,  # axis_label_positions
        :chxr,  # axis_range
        :chma,  # margins
        
        :chp,   # bar_chart_zero_line, pie chart rotation

        :chm,   # markers

        :chtt,  # title
        :chdl,  # legend
        :chdlp  # legend_position
        
        #:chds   # data_scaling -- never used
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
      Encoder.encode(data_values, y_min, y_max)
    end
    
    # chco
    def chco
      data.map{ |d|
        if d.is_a?(Hash) and c = d[:color]
          c = [c] unless c.is_a?(Array)
          c.join('|') # data point delimiter
        end
      }.compact.join(',') # data set delimiter
    end
    
    # chf
    def chf
      "bg,s,#{background}" if background
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

    ##
    # Are legend dimensions specified?
    #
    def legend_dimensions_given?
      legend.is_a?(Hash) and (legend[:width] or legend[:height])
    end

    # chma
    def chma
      return nil unless (margins or legend_dimensions_given?)
      value = ""
      if margins.is_a?(Hash)
        pixels = [:left, :right, :top, :bottom].map{ |i| margins[i] || 0 }
        value << pixels.join(',')
      end
      if legend_dimensions_given?
        value << "0,0,0,0" if value == ""
        value << "|#{legend[:width] || 0},#{legend[:height] || 0}"
      end
      value
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
  end
end
