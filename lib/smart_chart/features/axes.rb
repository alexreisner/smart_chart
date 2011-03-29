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
      labels = NiceNumbers.labels(options[:min], options[:max])

      labels.delete_at(0) if options[:omit_first]
      labels.delete_at(-1) if options[:omit_last]

      range = options[:max] - options[:min]
      options[:format] ||= lambda{ |i| i }

      labels.map!{ |p,l| [
        100.0 * (p.to_f - options[:min]) / range, # convert value to axis pct
        options[:format].call(l)                  # format label if required
      ] }

      # remove second label on each end if it's very close to the edge
      labels.delete_at( 1) if labels[ 1][0] <  5 && !options[:omit_first]
      labels.delete_at(-2) if labels[-2][0] > 95 && !options[:omit_last]

      # convert to hash
      Hash[*labels.flatten]
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
