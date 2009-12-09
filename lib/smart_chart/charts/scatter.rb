module SmartChart
  class Scatter < MultipleDataSetChart
  
    private # ---------------------------------------------------------------
    
    ##
    # Specify the Google Chart type.
    #
    def type
      "s"
    end

    ##
    # Array of all possible query string parameters.
    #
    def query_string_params
      super + [:chg]
    end
  end
end
