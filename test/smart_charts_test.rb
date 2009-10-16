require 'test_helper'

class SmartChartTest < Test::Unit::TestCase

  # --- encoding ------------------------------------------------------------
  
  def test_simple_encoding
    [
      [[0, 10],          nil, nil, 's:A9'],
      [[0, 10],            0,  61, 's:AK'],
      [[0, 11],            0,  61, 's:AL'],
      [[0, 10, 26,  27], nil, nil, 's:AW69'],
      [[0, 10, nil, 27], nil, nil, 's:AW_9']
      
    ].each do |data,min,max,encoding|
      assert_equal encoding,
        SmartChart::Encoder::Simple.new(data, min, max).to_s
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
        SmartChart::Encoder::Text.new(data, min, max).to_s
    end
  end

  def test_extended_encoding
    [
      [[0, 10],          nil,  nil, 'e:AA..'],
      [[0, 10],            0, 4095, 'e:AAAK'],
      [[0, 11],            0, 4095, 'e:AAAL'],
      [[0, 10, 26,  27], nil,  nil, 'e:AAXs9n..'],
      [[0, 10, nil, 27], nil,  nil, 'e:AAXs__..']
      
    ].each do |data,min,max,encoding|
      assert_equal encoding,
        SmartChart::Encoder::Extended.new(data, min, max).to_s
    end
  end
  

  # --- validation ----------------------------------------------------------
  
  def test_required_parameters_validation
    assert_raise SmartChart::MissingRequiredParameterError do
      SmartChart::Map.new(:width => 500, :height => 50).validate!
    end
    assert_raise SmartChart::MissingRequiredParameterError do
      SmartChart::Map.new(:data => []).validate!
    end
    assert_nothing_raised do
      SmartChart::Map.new(:data => [], :width => 50, :height => 50).validate!
    end
  end

  def test_map_width_validation
    assert_raise SmartChart::DimensionsError do
      SmartChart::Map.new(:data => [], :width => 500, :height => 50).validate!
    end
    assert_nothing_raised do
      SmartChart::Map.new(:data => [], :width => 400, :height => 50).validate!
    end
  end

  def test_map_height_validation
    assert_raise SmartChart::DimensionsError do
      SmartChart::Map.new(:data => [], :width => 50, :height => 300).validate!
    end
    assert_nothing_raised do
      SmartChart::Map.new(:data => [], :width => 50, :height => 200).validate!
    end
  end
  
  def test_dimensions_validation
    assert_raise SmartChart::DimensionsError do
      SmartChart::LineGraph.new(:data => [], :width => 800, :height => 600).validate!
    end
    assert_nothing_raised do
      SmartChart::LineGraph.new(:data => [], :width => 400, :height => 600).validate!
    end
  end
  
  
  # --- exceptions ----------------------------------------------------------
  
  def test_chart_parameter_error
    assert_raise SmartChart::NoParameterError do
      SmartChart::LineGraph.new(:asdf => "hi")
    end
  end
end
