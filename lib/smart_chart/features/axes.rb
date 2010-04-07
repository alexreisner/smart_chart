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
    
    ##
    # Determine a nice interval between labels based on the range of
    # axis values.
    #
    def self.auto_label_interval(range)
      return nil if range == 0
      # position of decimal point
      exp = Math.log10(range).floor
      # first two non-zero digits
      digits = (range.to_s + "00").sub(/^[\.0]*/, "")[0,2].to_i
      # the digits are in either 10..55 or 56..99
      # divide the base in half if they're in the lower half
      10**exp * (digits > 55 ? 1 : 0.5)
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
    # Axis label text parameter.
    #
    def chxl
      return nil unless show_axes?
      labels = []
      axis.values.each_with_index do |a,i|
        a[:labels].each do |pos,text|
          labels[i] ||= "#{i}:"
          labels[i] << "|" + text.to_s
        end
      end
      labels.join('|')
    end
    
    ##
    # Axis label positions parameter.
    #
    def chxp
      return nil unless show_axes?
      labels = []
      axis.values.each_with_index do |a,i|
        a[:labels].each do |pos,text|
          # figure out whether are we on a vertical or horizontal axis
          dir = [:left, :right].include?(axis.keys[i]) ? "y" : "x"
          p = eval("#{dir}_axis_position(pos)")
          labels[i] ||= i.to_s
          labels[i] << "," + SmartChart.decimal_string(p)
        end
      end
      labels.join('|')
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
