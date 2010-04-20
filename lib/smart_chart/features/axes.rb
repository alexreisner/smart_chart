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
        unless a.has_key?(:labels)
          raise SmartChartError, "Your axis settings are missing :labels"
        end
        if a[:labels][:positions] == :auto
          labels[i] = "#{i}:|" + auto_labels(a).values.join("|")
        else
          a[:labels].each do |pos,text|
            labels[i] ||= "#{i}:"
            labels[i] << "|" + text.to_s
          end
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
        if a[:labels][:positions] == :auto
          l = auto_labels(a).keys
        elsif [:left, :right].include?(axis.keys[i])
          l = label_positions_by_values(a)
        else
          l = label_positions_by_data_points(a)
        end
        labels << "#{i}," + l.join(',')
      end
      labels.join('|')
    end
    
    ##
    # Automatically generate numeric labels based on the given min and max.
    #
    def auto_labels(axis)
      options = axis[:labels]
      min = options[:min]
      max = options[:max]
      range  = max - min
      int = options[:interval] ||
        SmartChart::Axes.auto_label_interval(range)
      labels = {}
      labels[0]   = min unless options[:omit_first]
      labels[100] = max unless options[:omit_last]

      # advance cursor to first label position (min + int/2)
      l = first_auto_label_position(min, int)
      
      # add labels until within int/2 of max
      until l > (max - int / 2.0)
        pos = 100.0 * (l - min) / range
        labels[pos] = l
        l += int
      end
      
      # format if required
      if options[:format]
        labels.each{ |p,l| labels[p] = options[:format].call(l) }
      end
      
      labels
    end
    
    ##
    # Find the first "round number" above the given minimum.
    #
    def first_auto_label_position(min, int)
      i = int
      i += int while i < min + int / 2.0
      i
    end
    
    ##
    # Generate label position values, interpreting given label positions
    # as data point indices.
    #
    def label_positions_by_data_points(axis)
      axis[:labels].map do |pos,text|
        SmartChart.decimal_string(x_axis_position(pos))
      end
    end
    
    ##
    # Generate label position values, interpreting given label positions
    # as data point values.
    #
    def label_positions_by_values(axis)
      axis[:labels].map do |pos,text|
        SmartChart.decimal_string(y_axis_position(pos))
      end
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
