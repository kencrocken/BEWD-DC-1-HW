require_relative 'metro_line'

class Metro
  attr_accessor :response_metro_lines, :metro_incidents, :line_color, :check
  

  def initialize
    @response_metro_lines = JSON.parse(RestClient.get "http://api.wmata.com/Rail.svc/json/JLines?api_key=n2z9aq3redes6k7jekjfzk8q")
    @metro_incidents = JSON.parse(RestClient.get "http://api.wmata.com/Incidents.svc/json/Incidents?api_key=n2z9aq3redes6k7jekjfzk8q")
    @line_color = line_color # nice use of colors in your app!!
    @check = []
  end

  def get_metro_incidents
    if !@metro_incidents['Incidents'].empty?
      puts
      puts "\033[0;31m*** Alert! Alert! ***\033[0m"
      @metro_incidents['Incidents'].each do |incident|
        puts
        puts "#{incident['Description']}"
      end
      puts
      puts "\033[0;31m*** End Alerts ***\033[0m"
    else
      puts "No incidents to report."
      puts
    end
  end

  def get_metro_lines
    get_metro_incidents
    x = 0
    puts
    puts "Here are the train lines:"
    puts
    @response_metro_lines['Lines'].each do |metro_line|
      x += 1
      @check << x
      print "#{x} : "
      colorize_lines(metro_line['DisplayName'])
      #puts "#{x} : #{metro_line['DisplayName']}"
    end
    puts
    puts "Please enter the number of the line you need."
    @line_color = gets.chomp.to_i
    check(@line_color)
  end
  
  def colorize_lines(lines_color)
    puts "\033[0;31m#{lines_color}\033[0m" if lines_color.include? "Red"
    puts "\033[38;5;208m#{lines_color}\033[0m" if lines_color.include? "Orange"
    puts "\033[0;32m#{lines_color}\033[0m" if lines_color.include? "Green"
    puts "\033[0;93m#{lines_color}\033[0m" if lines_color.include? "Yellow"
    puts "\033[0;94m#{lines_color}\033[0m" if lines_color.include? "Blue"
  end

  def check(line_color)
    if !@check.include?(line_color)
      puts "Sorry, I don't understand." # nice validation
      get_metro_lines
    else
      get_metro_line(line_color)
    end
  end

  def get_metro_line(line_color)
    puts `clear`
    if line_color == 1
      line = "RD"
      puts "\033[0;31mRed Line Stations:\033[0m"
    elsif line_color == 2
      line = "OR"
      puts "\033[38;5;208mOrange Line Stations:\033[0m"
    elsif line_color == 3
      line = "GR"
      puts "\033[0;32mGreen Line Stations:\033[0m"
    elsif line_color == 4
      line = "YL"
      puts "\033[0;93mYellow Line Stations:\033[0m"
    else
      line = "BL"
      puts "\033[0;94mBlue Line Stations:\033[0m"
    end
    color = MetroLine.new(line)

    puts color.get_metro_stations(line)
  end
  # Maybe you could create variables or functions to handle the color
  # coding so the strings don't look so cryptic above.

end
