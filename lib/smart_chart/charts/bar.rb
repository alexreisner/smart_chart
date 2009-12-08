module SmartChart
  class Bar < MultipleDataSetChart
    include GridLines
  
    private # ---------------------------------------------------------------
    
    ##
    # Specify the Google Chart type.
    #
    def type
      "b" +
        (orientation == :horizontal ? "h" : "v") +
        (style       == :stacked    ? "s" : "g")
    end
    
    # zero line
    def chp
    end
  end
end
