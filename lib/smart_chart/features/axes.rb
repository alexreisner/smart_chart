module SmartChart
  module Axes

    def self.included(base)
      base.class_eval do
        attr_accessor :axis
        attr_accessor :labels
      end
    end


    private # ---------------------------------------------------------------
  
    ##
    # Labels parameter.
    #
    def chdl
      unless bare_data_set?
        labels = data.map{ |d| d.is_a?(Hash) ? d[:label] : nil }
        labels.compact.size > 0 ? labels.join("|") : nil
      end
    end
  
    ##
    # Axis type parameter.
    #
    def chxt
      return nil unless (
        axis.is_a?(Hash) and
        axis[:sides].is_a?(Array) and
        axis[:sides].size > 0
      )
      values = {
        :left   => "y",
        :right  => "r",
        :top    => "t",
        :bottom => "x"
      }
      axis[:sides].map{ |i| values[i] }.join(',')
    end

    ##
    # Axis style parameter.
    #
    def chxs
      #return nil unless (axis.is_a?(Hash) and axis[:color] or axis[:style]))
      "TODO"
    end
    
    ##
    # Should axes be omitted?
    #
    def hide_axes?
      axis.is_a?(Hash) and
        axis[:sides].is_a?(Array) and
        axis[:sides].size == 0
    end
  end  
end
