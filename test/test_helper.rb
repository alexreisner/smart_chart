require 'rubygems'
require 'test/unit'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'smart_chart'

class Test::Unit::TestCase

  ##
  # Create a valid line graph with default values.
  #
  def line_graph(values = {})
    SmartChart::Line.new({
      :width  => 400,
      :height => 200,
      :data   => [
        {
          :values => [1,2,3],
          :style  => {:color => 'ffccff'}
        }
      ]
    }.merge(values))
  end
  
  ##
  # Create a valid map with default values.
  #
  def map_chart(values = {})
    SmartChart::Map.new({
      :width  => 400,
      :height => 200,
      :region => :world,
      :data   => {:US => 1, :MX => 2, :CA => 3},
      :colors => ["CCCCCC", "CC3333"]
    }.merge(values))
  end
  
  def pie_chart(values = {})
    SmartChart::Pie.new({}.merge(values))
  end
end
