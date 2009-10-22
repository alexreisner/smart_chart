module SmartChart
  module Encoder
  
    ##
    # Choose the best encoder, instantiate, and return.
    #
    def self.encode(data)
      Simple.new(data)
    end
    
    ##
    # The Base encoder defines a public interface for all Encoders. To create
    # an actual Encoder, your subclass should implement _only_ these private
    # methods:
    # 
    #   token       # the single character encoding name
    #   digits      # the "alphabet" of the encoding (array)
    #   missing     # digit used for missing data
    #   delimiter   # between data points
    #   separator   # between data series
    #
    class Base
      
      attr_accessor :data_sets, :min, :max
      
      def initialize(data_sets, min = nil, max = nil)
        self.data_sets = data_sets
        self.min       = min || data_sets.flatten.compact.min
        self.max       = max || data_sets.flatten.compact.max
      end
      
      ##
      # The data, encoded as a string (eg: "s:e5Gf4").
      #
      def to_s
        token + ":" + encode
      end
      
      
      private # -------------------------------------------------------------
      
      ##
      # The business end: map arrays of numbers onto a range of characters.
      # See http://code.google.com/apis/chart/formats.html for specs.
      #
      def encode
        encoded = []
        data_sets.each_with_index do |set,i|
          encoded[i] = []
          set.each do |d|
            if d.nil?
              char = missing
            else
              if min == max # don't die when only one data point given
                char = digits.last
              else
                n = (d - min).to_f / (max - min).to_f
                n = (n * (digits.size - 1)).floor
                char = digits[n]
              end
            end
            encoded[i] << char
          end
        end
        encoded.map{ |set| set.join(delimiter) }.join(separator)
      end
      
      ##
      # The single-character name of the encoding, as specified in URLs.
      # All encoders must implement this method.
      #
      def token
        fail
      end
      
      ##
      # An array of "digits": the encoding's alphabet, in order.
      # All encoders must implement this method.
      #
      def digits
        fail
      end
      
      ##
      # String used for missing data point.
      # All encoders must implement this method.
      #
      def missing
        fail
      end
      
      ##
      # Data series separator.
      #
      def separator
        fail
      end
      
      ##
      # Data point delimiter.
      #
      def delimiter
        ""
      end
      
      ##
      # Array of uppercase letters.
      #
      def uppers
        chars = ["A"]
        chars << chars.last.succ while chars.size < 26
        chars
      end
      
      ##
      # Array of lowercase letters.
      #
      def lowers
        chars = ["a"]
        chars << chars.last.succ while chars.size < 26
        chars
      end
      
      ##
      # Array of numerals.
      #
      def numerals
        chars = ["0"]
        chars << chars.last.succ while chars.size < 10
        chars
      end
    end
    
    
    ##
    # Simple encoding (http://code.google.com/apis/chart/formats.html#simple).
    #
    class Simple < Base
      private
      
      def token
        "s"
      end
      
      ##
      # ABC...XYZabc...xyz0123456789
      #
      def digits
        uppers + lowers + numerals
      end
      
      def missing
        "_"
      end

      def separator
        ","
      end
    end
    
    
    ##
    # Text encoding (http://code.google.com/apis/chart/formats.html#text).
    #
    class Text < Base
      private
      
      def token
        "t"
      end
      
      ##
      # ABC...XYZabc...xyz0123456789
      #
      def digits
        (0..100).to_a.map{ |i| i.to_s }
      end
      
      def missing
        "-1"
      end
      
      def separator
        "|"
      end

      def delimiter
        ","
      end
    end


    ##
    # Extended encoding (http://code.google.com/apis/chart/formats.html#extended).
    #
    class Extended < Base
      private
      
      def token
        "e"
      end
      
      ##
      # AA, AB, AC, ..., .8, .9, .-, ..
      #
      def digits
        chars = uppers + lowers + numerals + %w[- .]
        arr = []
        chars.each do |c1|
          chars.each do |c2|
            arr << c1 + c2
          end
        end
        arr
      end
      
      def missing
        "__"
      end

      def separator
        ","
      end
    end
  end
end
