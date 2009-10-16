module SmartChart
  module Encoder
    
    ##
    # The Base encoder defines a public interface for all Encoders. To create
    # an actual Encoder, your subclass should implement _only_ these private
    # methods:
    # 
    #   token       # the single character encoding name
    #   digits      # the "alphabet" of the encoding (array)
    #   missing     # digit used for missing data
    #   delimiter   # only if there is a delimiter
    #
    class Base
      
      attr_accessor :data, :min, :max
      
      def initialize(data, min = nil, max = nil)
        self.data = data
        self.min  = min || data.compact.min
        self.max  = max || data.compact.max
      end
      
      ##
      # The data, encoded as a string (eg: "s:e5Gf4").
      #
      def to_s
        token + ":" + encode
      end
      
      
      private # -------------------------------------------------------------
      
      ##
      # The business end: map an array of numbers onto a range of characters.
      # See http://code.google.com/apis/chart/formats.html for specs.
      #
      def encode
        encoded = []
        data.each do |d|
          if d.nil?
            encoded << missing
          else
            i = (d - min).to_f / (max - min).to_f
            i = (i * (digits.size - 1)).floor
            encoded << digits[i]
          end
        end
        encoded.join(delimiter)
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
    end
  end
end
