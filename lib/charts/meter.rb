module SmartChart
  class Meter < SingleDataSetChart
  
    private # ---------------------------------------------------------------
    
    ##
    # Specify the Google Chart type.
    #
    def type
      "gom"
    end
  end
end
