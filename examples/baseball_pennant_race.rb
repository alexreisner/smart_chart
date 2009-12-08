#!/usr/bin/env ruby
#
# Generate a URL for a Google line graph depicting the 2008 National League
# pennant race (games +/- .500 vs. time).
#

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'smart_chart'

data = [{
  :label  => "1. Philadelphia (.568)",
  :color  => "2f3fe0",
  :values => [
    0, 0, 0, -1, -1, -2, -1, 0, -1, -2, -1, 0, -1, -2, -1, 0, -1, -1,
    0, -1, 0, -1, -2, -1, 0, 1, 0, 1, 2, 3, 2, 2, 3, 2, 3, 4, 3, 4, 5, 4, 5,
    4, 5, 4, 3, 3, 4, 3, 4, 5, 4, 3, 2, 3, 4, 5, 4, 3, 4, 5, 6, 7, 7, 8, 7,
    8, 9, 10, 9, 10, 11, 12, 13, 13, 12, 11, 12, 13, 12, 11, 12, 11, 10, 10,
    9, 8, 7, 7, 6, 7, 6, 5, 6, 5, 5, 6, 7, 8, 9, 8, 7, 6, 5, 6, 7, 8, 7, 8,
    8, 9, 8, 7, 7, 8, 7, 6, 5, 6, 7, 7, 8, 9, 10, 9, 10, 11, 11, 10, 11, 10,
    9, 10, 11, 10, 9, 8, 7, 8, 7, 8, 8, 9, 10, 9, 10, 11, 12, 13, 14, 13, 12,
    11, 12, 13, 12, 13, 12, 12, 13, 13, 13, 14, 13, 12, 13, 13, 14, 16, 16,
    17, 18, 19, 18, 19, 20, 21, 20, 19, 19, 20, 21, 22, 22, 22
  ]},{

  :label  => "2. New York (.549)",
  :color  => "fae12e",
  :values => [
    0, 0, 0, 1, 0, 1, 1, 1, 0, -1, -1, -2, -1, 0, 1, 0, -1, -1, 0, 1,
    2, 3, 4, 3, 2, 1, 2, 1, 0, 1, 2, 2, 3, 2, 2, 3, 2, 3, 2, 1, 2, 2, 2, 2,
    3, 2, 3, 2, 1, 1, 2, 3, 3, 1, 0, -1, -2, -1, -2, -3, -2, -1, 0, -1, 0,
    1, 0, 1, 2, 1, 0, -1, -2, -2, -3, -2, -3, -2, -2, -2, -1, -2, -1, -1, 0,
    -1, 0, -1, -2, -1, -1, -1, -2, -1, -2, -1, -2, -1, -2, -1, 0, 1, 2, 3, 4,
    5, 6, 7, 8, 7, 6, 7, 7, 6, 7, 8, 9, 8, 9, 8, 9, 8, 8, 7, 6, 5, 5, 6, 5,
    6, 7, 8, 7, 6, 7, 8, 9, 10, 11, 12, 11, 12, 13, 14, 15, 14, 13, 14, 13,
    14, 14, 15, 14, 15, 16, 17, 18, 18, 17, 17, 17, 17, 18, 19, 19, 19, 19,
    18, 17, 16, 17, 18, 19, 18, 17, 16, 17, 16, 17, 16, 17, 16, 16, 16
  ]},{

  :label  => "3. Florida (.522)",
  :color  => "2dad2d",
  :values => [
    0, 0, 0, -1, 0, -1, -1, 0, 1, 0, 1, 1, 2, 3, 4, 3, 2, 2, 3, 4, 3,
    2, 3, 4, 5, 4, 5, 4, 5, 4, 5, 5, 4, 3, 2, 3, 2, 3, 3, 4, 5, 6, 7, 8, 9,
    8, 7, 6, 6, 5, 6, 5, 5, 6, 7, 8, 7, 7, 9, 10, 9, 8, 8, 7, 8, 7, 6, 5, 6,
    5, 4, 5, 6, 5, 6, 7, 6, 5, 4, 5, 6, 5, 6, 6, 5, 6, 5, 5, 4, 3, 2, 3, 2,
    3, 4, 3, 4, 3, 2, 1, 2, 3, 2, 3, 4, 5, 6, 5, 5, 4, 5, 6, 5, 6, 5, 4, 5,
    6, 5, 6, 5, 6, 7, 6, 7, 6, 6, 7, 6, 7, 6, 5, 6, 5, 6, 5, 4, 3, 4, 3, 3,
    4, 3, 2, 3, 2, 3, 3, 2, 3, 2, 1, 2, 1, 2, 1, 2, 2, 3, 2, 1, 0, 1, 2, 2,
    3, 4, 5, 5, 6, 7, 8, 9, 8, 7, 6, 5, 6, 6, 7, 6, 7, 7, 7
  ]},{

  :label  => "4. Atlanta (.444)",
  :color  => "ff0000",
  :values => [
    0, 0, -1, -2, -2, -1, -2, -2, -1, 0, -1, -2, -3, -3, -2, -1, -2,
    -2, -3, -4, -3, -2, -1, 0, 1, 0, -1, 0, 1, 0, -1, -1, -2, -3, -3, -2, -1,
    0, 0, 1, 2, 3, 2, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 3, 4, 5, 4, 5, 4, 5, 4,
    3, 4, 3, 2, 1, 2, 3, 2, 3, 2, 1, 0, 0, -1, -2, -3, -2, -1, -2, -1, -2,
    -1, -2, -3, -2, -1, -2, -3, -2, -2, -1, -2, -3, -3, -4, -5, -6, -5, -6,
    -5, -6, -5, -6, -6, -7, -6, -5, -5, -4, -5, -6, -5, -6, -5, -5, -4, -5,
    -6, -7, -8, -9, -8, -9, -10, -9, -10, -9, -10, -9, -8, -7, -8, -8, -8,
    -10, -11, -12, -11, -12, -13, -14, -15, -16, -17, -16, -17, -17, -16,
    -17, -16, -17, -18, -19, -20, -19, -20, -19, -18, -19, -20, -20, -19,
    -18, -17, -17, -17, -16, -16, -17, -18, -19, -20, -19, -18, -19, -18,
    -17, -17, -18, -17, -18, -18, -18
  ]},{

  :label  => "5. Washington (.366)",
  :color  => "a020f0",
  :values => [
    0, 0, 1, 2, 2, 3, 2, 1, 0, -1, -2, -2, -3, -4, -5, -6, -5, -5,
    -6, -7, -8, -7, -8, -9, -10, -9, -10, -9, -8, -9, -8, -8, -7, -6, -5,
    -6, -5, -4, -4, -5, -6, -5, -6, -7, -8, -7, -8, -7, -6, -7, -8, -7, -6,
    -7, -8, -8, -7, -8, -7, -8, -9, -8, -9, -8, -9, -10, -10, -11, -11, -11,
    -12, -13, -14, -15, -14, -15, -16, -15, -14, -13, -13, -14, -15, -16,
    -15, -16, -17, -18, -19, -18, -18, -17, -18, -17, -18, -17, -18, -19,
    -20, -21, -22, -22, -23, -22, -23, -22, -23, -24, -24, -25, -24, -23,
    -23, -24, -25, -26, -27, -28, -29, -29, -30, -31, -32, -31, -30, -29,
    -28, -29, -29, -27, -28, -29, -30, -31, -32, -33, -34, -35, -36, -37,
    -37, -38, -39, -38, -37, -38, -39, -39, -38, -37, -36, -35, -34, -33,
    -32, -33, -32, -33, -34, -33, -32, -32, -33, -34, -34, -35, -36, -37,
    -36, -35, -36, -37, -38, -39, -40, -40, -39, -40, -40, -41, -42, -43,
    -43, -43
  ]}
]

c = SmartChart::Line.new(
  :width  => 600,
  :height => 230,
  :data   => data,
  :grid   => {:x => {:every => 30}},
  :labels => {:x => {}}
)
puts c.to_url

