module SmartChart
  class Radar < MultipleDataSetChart
  
    private # ---------------------------------------------------------------
    
    ##
    # Specify the Google Chart type.
    #
    def type
      "r" + (style == :filled ? "s" : "")
    end
  end
end
