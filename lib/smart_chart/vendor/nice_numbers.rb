module SmartChart
  module NiceNumbers
    extend self

    ##
    # Generate nice axis labels for a graph.
    # Takes graph min, max, and an options hash:
    #
    # <tt>:ticks</tt> - number of ticks (target, won't be hit exactly)
    # <tt>:scale</tt> - number of digits to the right of the decimal point in
    #   labels; omit to have the algorithm choose the best value
    # <tt>:style</tt> - :tight (default) or :loose; tight means min and max
    #   labels are min and max data values, loose means min label is less than
    #   min data value and max label is greater than max data value
    #
    # This is an implementation of Paul Heckbert's "Nice Numbers for Graph Labels"
    # algorithm, as described in the Graphics Gems book:
    # http://books.google.com/books?id=fvA7zLEFWZgC&pg=PA61&lpg=PA61#v=onepage
    #
    def labels(min, max, options = {})
      options[:style] = :tight unless options[:style] == :loose

      # ntick in Heckbert's original algorithm description
      options[:ticks] ||= 5

      # find min, max, and interval
      range = nice_number(max - min, false)
      d = nice_number(range.to_f / (options[:ticks] - 1), true)
      graph_min = (min.to_f / d).floor * d
      graph_max = (max.to_f / d).ceil * d

      # number of fractional digits
      nfrac = options[:scale] || [-Math.log10(d).floor, 0].max

      # generate label positions
      marks = []; x = graph_min
      (marks << x; x += d) until x > graph_max + 0.5 * d

      # tighten up ends if necessary
      if options[:style] == :tight
        marks[0]  = min
        marks[-1] = max
      end

      # generate nice looking labels
      marks.map{ |m| [m, "%.#{nfrac}f" % m] }
    end

    ##
    # Find a "nice" number (1, 2, 5, or power-or-ten multiple thereof)
    # approximately equal to x. Round the number if round = true,
    # take ceiling if round = false.
    #
    def nice_number(x, round = true)
      exp = Math.log10(x).floor
      f = x / 10 ** exp
      if round
        if    f < 1.5; nf = 1
        elsif f < 3;   nf = 2
        elsif f < 7;   nf = 5
        else           nf = 10
        end
      else
        if    f <= 1; nf = 1
        elsif f <= 2; nf = 2
        elsif f <= 5; nf = 5
        else          nf = 10
        end
      end
      nf * 10 ** exp
    end
  end
end
