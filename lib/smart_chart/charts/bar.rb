module SmartChart
  class Bar < MultipleDataSetChart
  
    # bar width (in pixels)
    attr_accessor :bar_width
    
    # space between bars (in pixels)
    attr_accessor :bar_space
    
    # space between bar groups (in pixels)
    attr_accessor :bar_group_space
    
    
    private # ---------------------------------------------------------------
    
    ##
    # Specify the Google Chart type.
    #
    def type
      "b" +
        (orientation == :horizontal ? "h" : "v") +
        (style       == :stacked    ? "s" : "g")
    end
    
    ##
    # Default bar width.
    #
    def default_bar_width
      "a" # Google's default width is 23
    end
    
    ##
    # Default bar spacing.
    #
    def default_bar_space
      8
    end
    
    ##
    # Default bar group spacing.
    #
    def default_bar_group_space
      8
    end
    
    ##
    # Array of all possible query string parameters.
    #
    def query_string_params
      super + [:chbh]
    end

    # bar width and spacing
    def chbh
      
      # use bar_space default for group default if only one data set
      group_default = data_values.size == 1 ?
        bar_space : default_bar_group_space
      [
        bar_width       || default_bar_width,
        bar_space       || default_bar_space,
        bar_group_space || group_default
      ].map{ |i| i.to_s }.join(',')
    end
    
    # zero line
    def chp
    end
  end
end
