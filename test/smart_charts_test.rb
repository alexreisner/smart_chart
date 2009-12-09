require 'test_helper'

class SmartChartTest < Test::Unit::TestCase

  # --- labels --------------------------------------------------------------
  
  def test_line_graph_labels
    c = line_graph(:data => [{
      :values => [1,2,3],
      :label  => "One"
    },{
      :values => [4,5,6],
      :label  => "Two"
    }])
    assert_equal "One|Two", c.send(:chdl)
  end
  
  
  # --- background color ----------------------------------------------------
  
  def test_line_graph_background_color
    c = line_graph(:background => "000000")
    assert_equal "bg,s,000000", c.send(:chf)
  end
  

  # --- margins -------------------------------------------------------------
  
  def test_margins
    c = line_graph(
      :margins => {
        :top    => 10,
        :bottom => 15,
        :left   => 5,
        :right  => 25
      }
    )
    assert_equal "5,25,10,15", c.send(:chma).to_s
  end
  

  # --- legend --------------------------------------------------------------
  
  def test_legend_dimensions
    c = line_graph(
      :legend => {
        :width  => 50,
        :height => 20
      }
    )
    assert_equal "0,0,0,0|50,20", c.send(:chma).to_s
  end
  

  # --- line styles ---------------------------------------------------------
  
  def test_line_styles
    c = line_graph(
      :data => [{
        :values    => [1,2,3],
        :thickness => 4,
        :style     => {:solid => 3, :blank => 2}
      },{
        :values    => [3,1,2],
        :thickness => 2,
        :style     => {:solid => 1, :blank => 3}
      }]
    )
    # handle multiple data sets correctly
    assert_equal "4,3,2|2,1,3", c.send(:chls).to_s
    
    # apply default line style automatically
    c.data[1][:thickness] = nil
    c.data[1][:style] = nil
    assert_equal "4,3,2|1,1,0", c.send(:chls).to_s
    
    # apply line style by name
    c.data[0][:style] = :dotted
    assert_equal "4,4,4|1,1,0", c.send(:chls).to_s
    
    # raise exception on invalid style name
    assert_raise(SmartChart::LineStyleNameError) do
      c.data[0][:style] = :asdf
      c.validate!
    end

    # omit chls parameter if no styles specified
    c.data[0][:thickness] = nil
    assert_equal "", c.send(:chls).to_s
  end
  

  # --- grid lines ----------------------------------------------------------
  
  def test_grid_lines
    c = line_graph(
      :data => [0, 2, 3, 4, 5, 6, 7, 8],
      :grid => {
        :x     => {:every => 2, :offset => 1},
        :y     => {:every => 4, :offset => 2},
        :color => "AABBCC",
        :style => :dotted
      }
    )
    assert_equal "25,50,1,1,12.5,25", c.send(:chg).to_s
    
    # test x/y-step decimal points
    c.data = [0, 2, 3, 4, 5, 6]
    assert_equal "33.333,66.667,1,1,16.667,33.333", c.send(:chg).to_s
  end
  
  
  # --- axis lines ----------------------------------------------------------
  
  def test_axis_lines
    c = line_graph(
      :data => [0, 2, 3, 4, 5, 6, 7, 8],
      :axis => {}
    )
    assert_equal "ls", c.send(:cht).to_s
    assert_nil c.send(:chxt)
    assert_equal "", c.send(:chxs).to_s
    
    # test axis side specification
    c.axis[:bottom] = {
      :color => "aabbcc"
    }
    assert_equal "lc", c.send(:cht).to_s
    assert_equal "x", c.send(:chxt).to_s
    assert_equal "1,aabbcc,,|", c.send(:chxs)
  end
  
  
  # --- pie -----------------------------------------------------------------
  
  def test_pie_chart_rotation
    c = pie_chart(:rotate => 45)
    assert_equal "5.498", c.send(:chp)

    # 90-degree rotation is Google default
    c.rotate = -90
    assert_equal "3.142", c.send(:chp)

    # 90-degree rotation is Google default
    c.rotate = 90
    assert_nil c.send(:chp)
  end
  
  
  # --- qr code ------------------------------------------------------------
  
  def test_qr_code
    c = SmartChart::QRCode.new(
      :width    => 200, :height => 200,
      :data     => "some data",
      :encoding => :iso88591)
    assert_equal "some data", c.send(:chl)
    assert_equal "ISO-8859-1", c.send(:choe)
    assert_nil c.send(:chld)
    
    # omit default margin
    c.margin = 4
    assert_nil c.send(:chld)
    
    # print non-default margin
    c.margin = 6
    assert_equal "L|6", c.send(:chld)
    
    # print non-default margin
    c.ec_level = :m
    assert_equal "M|6", c.send(:chld)
    
    # don't print default margin
    c.margin = 4
    assert_equal "M", c.send(:chld)
  end
  
  
  # --- line graph ----------------------------------------------------------
  
  def test_line_graph
    c = line_graph(
      :data   => [{
        :values => [2,1,3,4,5,9],
        :color  => '552255'
      },{
        :values => [1,6,4,8,7,5],
        :color  => '225522'
      }]
    )
    assert_equal "s:HAPWe9,AmW1te", c.send(:chd).to_s
    assert_equal "552255,225522", c.send(:chco)
  end
  

  # --- map -----------------------------------------------------------------
  
  def test_map_data_point_colors
    c = map_chart(:colors => %w[111111 222222 333333])
    assert_equal "FFFFFF,111111,222222,333333", c.send(:chco)
  end
  
  def test_map_data_and_labels
    c = map_chart(:data => [
      [:CA, 81],
      [:US, 49],
      [:AU, 96],
      [:RU, 45],
      [:MX, 14]
    ])
    assert_equal "s:xa9XA", c.send(:chd).to_s
    assert_equal "CAUSAURUMX", c.send(:chld).to_s
  end
  
  def test_map_with_one_data_point
    c = map_chart(:data => {:US => 7})
    assert_nothing_raised {c.validate!}
  end
  
  def test_map_foreground_color
    c = map_chart(:colors => %w[111111 222222 333333], :foreground => "BBBBBB")
    assert_equal "BBBBBB,111111,222222,333333", c.send(:chco)
  end
  
  def test_map_background_color
    c = map_chart(:background => "000000")
    assert_equal "bg,s,000000", c.send(:chf)
  end
  
  def test_region_validation
    invalids = ['middle east', 'china', 'USA']
    valids   = ['africa', 'europe']
    code     = lambda{ |region|
      map_chart(:region => region).validate!
    }
    invalids.each do |i|
      assert_raise(SmartChart::DataFormatError) { code.call(i) }
    end
    valids.each do |v|
      assert_nothing_raised { code.call(v) }
    end
  end
  
  def test_country_code_validation
    invalids = ['USA', 'SW']
    valids   = ['US', 'CN', :CA]
    code     = lambda{ |c|
      map_chart(:data => {:MX => 1,  c => 2}).validate!
    }
    invalids.each do |i|
      assert_raise(SmartChart::DataFormatError) { code.call(i) }
    end
    valids.each do |v|
      assert_nothing_raised { code.call(v) }
    end
  end
  
  def test_state_code_validation
    invalids = ['JJ', 'DC']
    valids   = ['AL', 'MS', :GA]
    code     = lambda{ |s|
      map_chart(:region => :usa, :data => {:NY => 1, s => 2}).validate!
    }
    invalids.each do |i|
      assert_raise(SmartChart::DataFormatError) { code.call(i) }
    end
    valids.each do |v|
      assert_nothing_raised { code.call(v) }
    end
  end
  
  
  # --- encoding ------------------------------------------------------------
  
  def test_simple_encoding
    [
      [[0, 10],          nil, nil, 's:A9'],
      [[0, 10],            0,  61, 's:AK'],
      [[0, 11],            0,  61, 's:AL'],
      [[0, 10,  26, 27], nil, nil, 's:AW69'],
      [[0, 10, nil, 27], nil, nil, 's:AW_9']
      
    ].each do |data,min,max,encoding|
      assert_equal encoding,
        SmartChart::Encoder::Simple.new([data], min, max).to_s
    end
  end

  def test_text_encoding
    [
      [[0, 10],          nil, nil, 't:0,100'],
      [[0, 10],            0, 100, 't:0,10'],
      [[0, 11],            0, 100, 't:0,11'],
      [[0, 10,  26, 27], nil, nil, 't:0,37,96,100'],
      [[0, 10, nil, 27], nil, nil, 't:0,37,-1,100']
      
    ].each do |data,min,max,encoding|
      assert_equal encoding,
        SmartChart::Encoder::Text.new([data], min, max).to_s
    end
  end

  def test_extended_encoding
    [
      [[0, 10],          nil,  nil, 'e:AA..'],
      [[0, 10],            0, 4095, 'e:AAAK'],
      [[0, 11],            0, 4095, 'e:AAAL'],
      [[0, 10,  26, 27], nil,  nil, 'e:AAXs9n..'],
      [[0, 10, nil, 27], nil,  nil, 'e:AAXs__..']
      
    ].each do |data,min,max,encoding|
      assert_equal encoding,
        SmartChart::Encoder::Extended.new([data], min, max).to_s
    end
  end
  
  def test_encoding_multiple_data_sets
    assert_equal "s:ANbo,GUhv",
      SmartChart::Encoder::Simple.new([[1,3,5,7], [2,4,6,8]], 1, 10).to_s
  end
  
  def test_mixed_data_set_formats
    c = SmartChart::Line.new(
      :width  => 400,
      :height => 200,
      :data   => [ [2,1,3,4,5,9], {:values => [1,6,4,8,7,5]} ]
    )
    assert_equal "s:HAPWe9,AmW1te", c.send(:chd).to_s
  end
  
  def test_encoding_with_y_min_and_max
    c = line_graph(
      :y_min  => -20,
      :y_max  => 10,
      :data   => [2,1,3,4,5,9]
    )
    assert_equal "s:squwy6", c.send(:chd).to_s
  end
  

  # --- validation ----------------------------------------------------------
  
  def test_required_attributes_validation
    assert_raise SmartChart::MissingRequiredAttributeError do
      SmartChart::Map.new(:width => 500, :height => 50).validate!
    end
    assert_raise SmartChart::MissingRequiredAttributeError do
      SmartChart::Map.new(:data => []).validate!
    end
  end

  def test_map_width_validation
    assert_raise SmartChart::DimensionsError do
      map_chart(:width => 500).validate!
    end
  end

  def test_map_height_validation
    assert_raise SmartChart::DimensionsError do
      map_chart(:height => 300).validate!
    end
  end
  
  def test_dimensions_validation
    assert_raise SmartChart::DimensionsError do
      line_graph(:width => 800, :height => 600).validate!
    end
  end
  
  def test_color_validation
    valids   = %w[fcfcfc FCFCFC 123456 a1b2c3]
    invalids = %w[fcf 012 12345q 1234567]
    code     = lambda{ |color|
      line_graph(:data => [{
          :values => [1,2,3],
          :color => color
        }]
      ).validate!
    }
    invalids.each do |color|
      assert_raise(SmartChart::ColorFormatError) { code.call(color) }
    end
    valids.each do |color|
      assert_nothing_raised { code.call(color) }
    end
  end
  
  
  # --- exceptions ----------------------------------------------------------
  
  def test_chart_attribute_error
    assert_raise SmartChart::NoAttributeError do
      line_graph(:asdf => "hi")
    end
  end
end
