module SmartChart
  class Line < MultipleDataSetChart
  
    private # ---------------------------------------------------------------
    
    ##
    # Specify the Google Chart type. Should be "lc" unless axes are
    # explicitly hidden, then "ls".
    #
    def type
      hide_axes?? "ls" : "lc"
    end

    ##
    # Array of all possible query string parameters.
    #
    def query_string_params
      super + [:chg]
    end
  end
end
