module SmartChart
  class Pie < SingleDataSetChart
  
    private # ---------------------------------------------------------------
    
    ##
    # Specify the Google Chart type.
    #
    def type
      case style
        when :concentric: "pc"
        when "3d":        "p3"
        else              "p"
      end
    end
    
    # rotation (in radians)
    def chp
    end
  end
end
