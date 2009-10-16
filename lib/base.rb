module SmartChart

  class Base
    
    # dimensions of chart image, in pixels
    attr_accessor :width, :height

    # chart data
    attr_accessor :data
    
    ##
    # Accept parameters and attempt to assign each to an attribute.
    #
    def initialize(options = {})
      options.each do |k,v|
        begin
          send("#{k}=", v)
        rescue NoMethodError
          raise NoParameterError.new(self, k)
        end
      end
    end
    
    ##
    # Get the chart URL.
    #
    def to_url
      validate
      encoded_url
    end
    
    ##
    # Chart as an HTML tag.
    #
    def to_html
      '<img src="%s" />' % to_url
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
    # Array of validations to be run on the chart.
    #
    def validations
      [
        :required_parameters,
        :dimensions
      ]
    end
    
    ##
    # Array of names of required parameters.
    #
    def required_parameters
      [
        :width,
        :height,
        :data
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
    # Run all validations on the chart parameters.
    #
    def validate
      validations.each{ |v| send "validate_#{v}" }
    end
    
    ##
    # The bare (unencoded) URL for the chart.
    #
    def bare_url
      parameters.map{ |p| p.to_s }.join("&")
    end
    
    ##
    # The encoded URL for the chart. Use this when validating URL length.
    #
    def encoded_url
      CGI.urlencode(bare_url)
    end
    
    ##
    # Make sure all required chart parameters are specified.
    #
    def validate_required_parameters
      required_parameters.each do |param|
        if send(param).nil?
          raise MissingRequiredParameterError.new(self, param)
        end
      end
    end
  end
end
