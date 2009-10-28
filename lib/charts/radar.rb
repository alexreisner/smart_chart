module SmartChart
  class Radar < SingleDataSetChart
    include GridLines
  
    private # ---------------------------------------------------------------
    
    ##
    # Specify the Google Chart type.
    #
    def type
      "r" + (style == :filled ? "s" : "")
    end
  end
end
