module SmartChart
  module AxisLines

    def self.included(base)
      base.class_eval do
        attr_accessor :axis
      end
    end


    private # ---------------------------------------------------------------
  
    ##
    # Axis type parameter.
    #
    def chxt
      #return nil unless (axis.is_a?(Hash) and (axis[:sides].is_a?(Array))
      "TODO"
    end

    ##
    # Axis style parameter.
    #
    def chxs
      #return nil unless (axis.is_a?(Hash) and (axis[:color] or axis[:style]))
      "TODO"
    end
  end  
end