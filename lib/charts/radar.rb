module SmartChart
  class Radar < MultipleDataSetChart
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
