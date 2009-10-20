module SmartChart
  class Map < SingleDataSetChart
  
    ##
    # Array of valid ISO 3166-1-alpha-2 country codes.
    # Source: http://code.google.com/apis/chart/isocodes.html
    #
    def self.country_codes
      %w[
        AF AX AL DZ AS AD AO AI AQ AG AR AM AW AU AT AZ BS BH BD BB BY BE
        BZ BJ BM BT BO BA BW BV BR IO BN BG BF BI KH CM CA CV KY CF TD CL
        CN CX CC CO KM CG CD CK CR CI HR CU CY CZ DK DJ DM DO EC EG SV GQ
        ER EE ET FK FO FJ FI FR GF PF TF GA GM GE DE GH GI GR GL GD GP GU
        GT GG GN GW GY HT HM VA HN HK HU IS IN ID IR IQ IE IM IL IT JM JP
        JE JO KZ KE KI KP KR KW KG LA LV LB LS LR LY LI LT LU MO MK MG MW
        MY MV ML MT MH MQ MR MU YT MX FM MD MC MN ME MS MA MZ MM NA NR NP 
        NL AN NC NZ NI NE NG NU NF MP NO OM PK PW PS PA PG PY PE PH PN PL
        PT PR QA RE RO RU RW BL SH KN LC MF PM VC WS SM ST SA SN RS SC SL
        SG SK SI SB SO ZA GS ES LK SD SR SJ SZ SE CH SY TW TJ TZ TH TL TG
        TK TO TT TN TR TM TC TV UG UA AE GB US UM UY UZ VU VE VN VG VI WF
        EH YE ZM ZW
      ]
    end
    
    ##
    # Array of valid US state codes.
    # Source: http://code.google.com/apis/chart/statecodes.html
    #
    def self.us_state_codes
      %w[
        AK AL AR AZ CA CO CT DE FL GA HI IA ID IL IN KS KY LA MA MD ME MI
        MN MO MS MT NC ND NE NH NJ NM NV NY OH OK OR PA RI SC SD TN TX UT
        VA VT WA WI WV WY
      ]
    end
    
    ##
    # Array of valid map regions.
    #
    def self.regions
      %w[
        africa
        asia
        europe
        middle_east
        south_america
        usa
        world
      ]
    end
    
    # region to be depicted
    attr_accessor :region
    
     
    private # ---------------------------------------------------------------
    
    ##
    # Specify the Google Chart type.
    #
    def type
      "t"
    end
    
    ##
    # Map region query string parameter.
    #
    def chtm
      region || "world"
    end
    
    ##
    # Countries or states to be indicated on the map.
    #
    def chld
      labels.join
    end
    
    ##
    # Get the labels (auto-upcase).
    #
    def labels
      super.map{ |i| i.to_s.upcase } unless super.nil?
    end
    
    ##
    # Array of validations to be run on the chart.
    #
    def validations
      super + [:map_region]
    end

    ##
    # Validate the given map region against Google's available options.
    #
    def validate_map_region
      unless region.nil? or Map.regions.include?(region.to_s)
        raise DataFormatError,
          "Map region must be one of: #{Map.regions.join(', ')}"
      end
    end
    
    ##
    # Make sure the given country codes are specified by ISO 3316.
    #
    def validate_labels
      return if labels.nil?
      # validate states
      if region.to_s == "usa"
        invalids = labels - Map.us_state_codes
        unless invalids.size == 0
          raise DataFormatError,
            "Invalid state code(s): #{invalids.join(', ')}"
        end
      # validate countries
      else
        invalids = labels - Map.country_codes
        unless invalids.size == 0
          raise DataFormatError,
            "Invalid country code(s): #{invalids.join(', ')}"
        end
      end
    end

    ##
    # Make sure chart dimensions are within Google's 440x220 limit.
    #
    def validate_dimensions
      if width > 440 or height > 220
        raise DimensionsError,
          "Map dimensions may not exceed 440x220 pixels"
      end
    end
  end
end
