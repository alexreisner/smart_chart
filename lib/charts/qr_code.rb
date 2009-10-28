module SmartChart
  class QRCode < SingleDataSetChart
  
    # output encoding
    # :utf8 (default), :shift_jis, :iso88591
    attr_accessor :encoding
    
    # error correction level
    # :l (default), :m, :q, or :h
    attr_accessor :ec_level
    
    # chart margin, in rows/columns
    attr_accessor :margin
    
  
    private # ---------------------------------------------------------------
    
    ##
    # Specify the Google Chart type.
    #
    def type
      "qr"
    end
    
    ##
    # Array of all possible query string parameters.
    #
    def query_string_params
      [:cht, :chs, :chl, :chld, :choe]
    end
    
    ##
    # Raise an exception unless the provided data is given as a string and
    # not too long.
    #
    def validate_data_format
      unless data.is_a?(String)
        raise DataFormatError, "Barcode data should be given as a string"
      end
      unless ec_level.nil? or ec_level.to_s.match(/l|m|q|h/i)
        raise DataFormatError, "Error correction level must be L, M, Q, or H"
      end
      #unless data.size <= 4296
      #  raise DataFormatError, "Barcode data can be at most 4296 characters"
      #end
    end
    
    ##
    # Label query string parameter (text to be encoded).
    #
    def chl
      data
    end
    
    ##
    # Error correction and margins.
    #
    def chld
      # only return non-nil if non-default value given
      return nil unless (
        (ec_level and ![:l, "l", "L"].include?(ec_level)) or
        (margin and margin != 4)
      )
      ec = ec_level || "L"
      m  = margin || 4
      ec.to_s.upcase + (m != 4 ? "|#{m}" : "")
    end
    
    ##
    # Output encoding query string parameter.
    #
    def choe
      case encoding
      when :shift_jis: "Shift_JIS"
      when :iso88591:  "ISO-8859-1"
      else             "UTF-8"
      end
    end
  end
end
