module SmartChart

  class SmartChartError < StandardError #:nodoc:
  end
  
  class DataFormatError < SmartChartError #:nodoc:
  end
  
  class NoAttributeError < SmartChartError #:nodoc:
    def initialize(chart, param)
      chart_type = chart.class.to_s.sub(/^SmartChart::/, "")
      super("The #{chart_type} chart type does not accept the '#{param}' parameter")
    end
  end

  
  # --- validations ---------------------------------------------------------

  class ValidationError < SmartChartError #:nodoc:
  end
  
  class MissingRequiredAttributeError < ValidationError #:nodoc:
    def initialize(chart, param)
      chart_type = chart.class.to_s.sub(/^SmartChart::/, "")
      super("The #{chart_type} chart type requires the '#{param}' parameter")
    end
  end
  
  class DimensionsError < ValidationError #:nodoc:
    def initialize(message = nil)
      super(message || "Chart dimensions must result in at most 300,000 pixels")
    end
  end
  
  class UrlLengthError < ValidationError #:nodoc:
    def initialize(message = nil)
      super("URL too long (must not exceed #{SmartChart::URL_MAX_LENGTH} characters)")
    end
  end
end
