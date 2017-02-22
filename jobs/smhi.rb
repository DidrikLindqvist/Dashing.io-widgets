require 'rest-client'
require 'date'

# Simple widget that will parse and display task weather info from smhi.
# Setup, change longitude, latitude, city and temp_format. 
# https://github.com/DidrikLindqvist/Dashing.io-widgets

class WhetherHandler

  def initialize()

    # Sets the longitude and latitude for where to fetch the wheather info from.
    # Lat and long can be found here http://www.latlong.net/
    @longitude = "20.290890"  #Change this
    @latitude = "63.821342"   #Change this
    @city = "Umeå"            #Change this
    @temp_format = " °C"

    @whether_info = []
    @whether_info.push(whether_station: @city)
    @curr_day = 0
  end

  def parseWhether()

    @whetherInfo = parseWhetherInfo()
    raw_whetherData = @whetherInfo['timeSeries']

    raw_whetherData.map do |whetherData|
    
      succ = addWheterDataOnTime(whetherData, "07:00")
      succ = addWheterDataOnTime(whetherData, "13:00")
      succ = addWheterDataOnTime(whetherData, "19:00")
      succ = addWheterDataOnTime(whetherData, "23:00")
      if(succ)
        @curr_day += 1
      end      
    end

  end
 
  def addWheterDataOnTime(whetherData, time)
    
    if whetherData['validTime'].to_s.include? time and whetherData['validTime'].to_s.include? (Date.today + @curr_day).to_s
      temp = retriveTempatures(whetherData)
      @whether_info.push(date: (Date.today + @curr_day), time: time, temp: temp[0].to_s + @temp_format, icon: temp[1].to_s )
      return true
    end
    return false

  end

  def parseWhetherInfo()

    url = "http://opendata-download-metfcst.smhi.se/api/category/pmp2g/version/2/geotype/point/lon/" + @longitude + "/lat/" + @latitude + "/data.json"
    @whetherInfo = JSON.parse(RestClient.get(url))

  end

  def retriveTempatures(whetherData)
    
    whetherData['parameters'].each do |k|
      next if k['name'].to_s != "t"

      return [k['values'][0], k['level'] ]
    end
  end

  def getWheterInfo()
    return @whether_info
  end

end


SCHEDULER.every '10m', :first_in => 0 do |job|

  wHandler = WhetherHandler.new
  wHandler.parseWhether()
  whether_info = wHandler.getWheterInfo()
  send_event('smhi', days: whether_info)

end
