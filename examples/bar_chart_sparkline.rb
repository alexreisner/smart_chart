#!/usr/bin/env ruby
#
# Print a tiny bar chart and hide the axes using a div which is slightly
# smaller than the chart image.
#

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'smart_chart'

width  = 240
height = 20

chart = SmartChart::Bar.new(
  :width      => width,
  :height     => height,
  :y_min      => 0,
  :y_max      => 100,
  :bar_width  => 3,
  :bar_space  => 1,
  :data       => [38,60,68,78,52,50,19,23,33,49,38,39,12,18]
)

puts "<div style=\"width:#{width-2}px; height:#{height-1}px; overflow:hidden;\">"
puts chart.to_html(true, true, :style => "margin:0 0 -1px -2px")
puts "</div>"
