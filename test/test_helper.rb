require 'rubygems'
require 'test/unit'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'smart_chart'

class Test::Unit::TestCase

  ##
  # Create a valid line graph with default values.
  #
  def line_graph(values)
    SmartChart::LineGraph.new(default_values.merge(values))
  end
  
  ##
  # Create a valid line graph with default values.
  #
  def map_chart(values)
    SmartChart::Map.new(default_values.merge(values))
  end
  
  ##
  # Default hash for creating a new chart. This method should not be called
  # directly--call <tt>line_graph</tt> or <tt>map_chart</tt> instead.
  #
  def default_values
    {
      :width  => 300,
      :height => 300,
      :data   => [
        {
          :values => [1,2,3],
          :style  => {:color => 'ffccff'}
        }
      ]
    }
  end
end
