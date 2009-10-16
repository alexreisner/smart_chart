require 'test_helper'

class SmartChartTest < Test::Unit::TestCase

  def test_simple_encoding
    [
      [[0, 10],          nil, nil, 'A9'],
      [[0, 10],            0,  61, 'AK'],
      [[0, 11],            0,  61, 'AL'],
      [[0, 10, 26,  27], nil, nil, 'AW69'],
      [[0, 10, nil, 27], nil, nil, 'AW_9']
      
    ].each do |data,min,max,encoding|
      assert_equal encoding,
        SmartChart::Encoder::Simple.new(data, min, max).to_s
    end
  end

  def test_text_encoding
    [
      [[0, 10],          nil, nil, '0,100'],
      [[0, 10],            0, 100, '0,10'],
      [[0, 11],            0, 100, '0,11'],
      [[0, 10,  26, 27], nil, nil, '0,37,96,100'],
      [[0, 10, nil, 27], nil, nil, '0,37,-1,100']
      
    ].each do |data,min,max,encoding|
      assert_equal encoding,
        SmartChart::Encoder::Text.new(data, min, max).to_s
    end
  end

  def test_extended_encoding
    [
      [[0, 10],          nil,  nil, 'AA..'],
      [[0, 10],            0, 4095, 'AAAK'],
      [[0, 11],            0, 4095, 'AAAL'],
      [[0, 10, 26,  27], nil,  nil, 'AAXs9n..'],
      [[0, 10, nil, 27], nil,  nil, 'AAXs__..']
      
    ].each do |data,min,max,encoding|
      assert_equal encoding,
        SmartChart::Encoder::Extended.new(data, min, max).to_s
    end
  end
end
