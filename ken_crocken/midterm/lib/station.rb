class Station
  attr_accessor :station_code, :station_elevators, :response_metro_prediction, :response_station_info

  def initialize(station)
    @station_code = station
    @station_elevators = station_elevators
    @response_metro_prediction = response_metro_prediction
    @response_station_info = response_station_info
  end

  def get_station
    url = "http://api.wmata.com/Rail.svc/json/jStationInfo?StationCode=#{@station_code}&api_key=kfgpmgvfgacx98de9q3xazww"
    @response_station_info = JSON.parse(RestClient.get "#{url}")
    puts `clear`
    #puts "=== #{@response_station_info['Name']} ==="
    colorize_station(@response_station_info['LineCode1'])
    get_elevators
  end

  def colorize_station(lines_color)
    puts "\033[0;31m===\033[0m #{@response_station_info['Name']} \033[0;31m===\033[0m" if lines_color.include? "RD"
    puts "\033[38;5;208m===\033[0m #{@response_station_info['Name']} \033[38;5;208m===\033[0m" if lines_color.include? "OR"
    puts "\033[0;32m===\033[0m #{@response_station_info['Name']} \033[0;32m===\033[0m" if lines_color.include? "GR"
    puts "\033[0;93m===\033[0m #{@response_station_info['Name']} \033[0;93m===\033[0m" if lines_color.include? "YL"
    puts "\033[0;94m===\033[0m #{@response_station_info['Name']} \033[0;94m===\033[0m" if lines_color.include? "BL"
  end

  def get_elevators
    url = "http://api.wmata.com/Incidents.svc/json/ElevatorIncidents?StationCode=#{@station_code}&api_key=kfgpmgvfgacx98de9q3xazww
"
    @station_elevators = JSON.parse(RestClient.get "#{url}")
    if !@station_elevators['ElevatorIncidents'].empty?
      puts
      puts "\033[0;31m*** Warning!  Escalator and Elevator Incidents Reported! ***\033[0m"
      @station_elevators['ElevatorIncidents'].each do |incidents|
        puts "#{incidents['LocationDescription']}, issue: #{incidents['SymptomDescription']}" 
      end
    else
      puts 
      puts "No escalator or elevator issues reported."
    end
    puts
    get_prediction
  end

  def get_prediction
    url = "http://api.wmata.com/StationPrediction.svc/json/GetPrediction/#{@station_code}?api_key=n2z9aq3redes6k7jekjfzk8q"
    @response_metro_prediction = JSON.parse(RestClient.get "#{url}")
    puts "-- Next Train --"
    @response_metro_prediction['Trains'].each do |prediction|
      puts "Towards: #{prediction['DestinationName']} | Arriving: #{prediction['Min']}"
    end
    puts
    get_another
  end

  def get_another
    puts
    puts "Do you want to check another station? (y/n)"
    answer = gets.chomp.downcase
    if answer == "y"
      puts `clear`
      metro = Metro.new
      puts metro.get_metro_lines
    else
      abort ("Thanks for using Metro Command!")
    end
  end

  # Ken, you nailed this assignment! This is so cool. You should create
  # a new repo on github for this app and create a ruby gem so others can use it!
  # - http://guides.rubygems.org/make-your-own-gem/

end