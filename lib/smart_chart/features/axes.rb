module SmartChart
  module Axes

    def self.included(base)
      base.class_eval do
      
        # grid axis style
        attr_accessor :axis
        
        # grid axis labels
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
      return nil unless show_axes?
      values = {
        :left   => "y",
        :right  => "r",
        :top    => "t",
        :bottom => "x"
      }
      axis.keys.map{ |i| values[i] }.join(',')
    end

    ##
    # Axis style parameter.
    #
    def chxs
      return nil unless show_axes?
      data = []
      axis.values.each_with_index do |side,i|
        data << [
          i + 1,                        # index
          side[:color],                 # color
          side[:font_size],             # font size
          alignment(side[:text_align]), # alignment
          (side[:color] ? "l" : "") +
            (side[:ticks] ? "t" : ""),  # drawing control
          side[:ticks]                  # tick mark color
        ].map{ |i| i.to_s }
      end
      out = data.map{ |i| i.join(',') }.join("|")
      out == "" ? nil : out
    end
    
    ##
    # Translate an alignment name into a URL parameter value.
    #
    def alignment(name)
      {
        "left"   => -1,
        "center" => 0,
        "right"  => 1
      }[name.to_s]
    end
    
    ##
    # Should axes be omitted?
    #
    def show_axes?
      axis.is_a?(Hash) and axis.keys.size > 0 and
        axis.values.reject{ |i| i.nil? or i == {} }.size > 0
    end
  end  
end
