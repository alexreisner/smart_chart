module SmartChart
  class Radar < SingleDataSetChart
  
    private # ---------------------------------------------------------------
    
    ##
    # Specify the Google Chart type.
    #
    def type
      "r" + (style == :filled ? "s" : "")
    end
  end
end
