require 'test_helper'

class SmartChartTest < Test::Unit::TestCase

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
end
