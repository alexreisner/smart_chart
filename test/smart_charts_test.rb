require 'test_helper'

class SmartChartTest < Test::Unit::TestCase

  # --- line graph ----------------------------------------------------------
  
  def test_line_graph
    assert_equal "cht=lc&chs=400x200&chd=s:HAPWe9,AmW1te&chco=552255,225522",
      line_graph(
        :data   => [{
          :values => [2,1,3,4,5,9],
          :style  => {
            :color     => '552255'
          }
        },{
          :values => [1,6,4,8,7,5],
          :style  => {
            :color     => '225522'
          }
        }]
      ).to_query_string(false)
  end
  
  
  # --- map -----------------------------------------------------------------
  
  def test_map
    c = map_chart(:data => [1, 2, 3, 4, 5])
    assert_equal "cht=t&chs=400x200&chd=s:APet9", c.to_query_string(false)
  end
  
  def test_data_point_colors
    c = map_chart(:data => [{
      :values => [1,2,3],
      :style => {:color => ["111111", "222222", "333333"]}
    }])
    assert_equal "111111|222222|333333", c.send(:chco)
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
    g = SmartChart::LineGraph.new(
      :width  => 400,
      :height => 200,
      :data   => [ [2,1,3,4,5,9], {:values => [1,6,4,8,7,5]} ]
    )
    assert_equal "cht=lc&chs=400x200&chd=s:HAPWe9,AmW1te",
      g.to_query_string(false)
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
    valids = %w[fcfcfc FCFCFC 123456 a1b2c3]
    invalids = %w[fcf 012 12345q 1234567]
    invalids.each do |color|
      assert_raise SmartChart::ColorFormatError do
        line_graph(:data => [{
            :values => [1,2,3],
            :style => {:color => color}
          }]
        ).validate!
      end
    end
    valids.each do |color|
      assert_nothing_raised SmartChart::ColorFormatError do
        line_graph(:data => [{
            :values => [1,2,3],
            :style => {:color => color}
          }]
        ).validate!
      end
    end
  end
  
  
  # --- exceptions ----------------------------------------------------------
  
  def test_chart_attribute_error
    assert_raise SmartChart::NoAttributeError do
      line_graph(:asdf => "hi")
    end
  end
end
