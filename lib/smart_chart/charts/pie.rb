module SmartChart
  class Pie < SingleDataSetChart
  
    # number of degrees to rotate start of first slice from 12 o'clock
    attr_accessor :rotate
    
    
    private # ---------------------------------------------------------------
    
    ##
    # Specify the Google Chart type.
    #
    def type
      case style.to_s
        when "concentric": "pc"
        when "3d":         "p3"
        else               "p"
      end
    end
    
    ##
    # Rotation. Google expects radians from 3 o'clock.
    #
    def chp
      r = rotate || 0
      s = SmartChart.decimal_string(
        ((r - 90) % 360) * Math::PI / 180.0
      )
      s == "0" ? nil : s # omit parameter if zero
    end
  end
end
