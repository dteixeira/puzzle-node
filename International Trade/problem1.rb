require 'rexml/document'
require 'csv'

RATES_FILE = 'RATES.xml'
TRANS_FILE = 'TRANS.csv'
PRODUCT = 'DM1182'
CURRENCY = 'USD'
OUTPUT_FILE = 'OUTPUT.txt'

class ConversionGraph

  attr_accessor :conv_graph

  def initialize filename
    @conv_graph = Hash.new
    file = File.new(filename)
    @doc = REXML::Document.new file
    build_graph
  end

  def build_graph
    # Builds conversion graph
    REXML::XPath.each(@doc, '//rate') { |rate|
      from = REXML::XPath.match(rate, 'from/text()')[0].to_s
      to = REXML::XPath.match(rate, 'to/text()')[0].to_s
      conversion = REXML::XPath.match(rate, 'conversion/text()')[0].to_s.to_f
      @conv_graph[from] = Hash.new if ! conv_graph[from]
      @conv_graph[from][to] = conversion
    }
  end

  def get_rate from, to
    rate = 1.0
    if ! @conv_graph[from][to]
      return get_aux from, to, [from]
    else
      return @conv_graph[from][to]
    end
  end

  def get_aux from, to, visited
    if @conv_graph[from][to]
      rate = 1.0
      visited.push to
      for i in 1...visited.length do
        rate *= @conv_graph[visited[i - 1]][visited[i]]
      end
      return rate
    else
      @conv_graph[from].each do |key, value|
        if ! visited.index key
          visited.push key
          return get_aux key, to, visited
        end
      end
    end
  end

end

# Obtains rates
graph = ConversionGraph.new RATES_FILE

# Obtain and process product info
total = 0.0;
CSV.foreach(TRANS_FILE, {:headers => true}) do |row|
  if row.field('sku') == PRODUCT
    val = row.field('amount').split(' ')
    amount = val[0].to_f
    currency = val[1]
    total += (amount * graph.get_rate(currency, CURRENCY))
    
    # Rounds the result (two decimal places, with
    # banker's rounding)
    total = sprintf("%.02f" , total).to_f
  end
end

# Prints result
File.open(OUTPUT_FILE, 'w') do |file|
  file.puts total
end
