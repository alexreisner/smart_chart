#!/usr/bin/env ruby
#
# Print a tiny bar chart and hide the axes using a div which is slightly
# smaller than the chart image.
#

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'smart_chart'

width  = 40
height = 20

chart = SmartChart::Bar.new(
  :width  => width,
  :height => height,
  :data   => [4,60,80,50,10]
)

puts "<div style=\"width:#{width-2}px; height:#{height-1}px; overflow:hidden;\">"
puts chart.to_html(true, true, :style => "margin:0 0 -1px -2px")
puts "</div>"
