module SmartChart
  class LineGraph < Base
  
    
#  .new(
#    :y_max  => 80,
#    :y_min  => -40,
#    :grids => {
#      :x => {
#        :step   => 10,
#        :offset => 2,
#        :style  => :dashed }
#      },
#    :line => {
#      :width => 2,
#      :color => '552255',
#      :style => SmartChart
#    },
#    :data => [
#      [1,2,3,4],
#      [2,4,6,8],
#      [7,5,3,1]
#    ],
#    :html => {
#      :id => "stock_graph",
#      :class => "graph" }
#  )
  
    private # ---------------------------------------------------------------
    
    ##
    # Specify the Google Chart type.
    #
    def type
      :lc
    end
  end
end
