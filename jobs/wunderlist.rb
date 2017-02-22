require 'rest-client'
# Simple widget that will parse and display task info of a given list from wunderlist.
# Setup, change wunderlist_token, wunderlist_client and list_id. 
# https://github.com/DidrikLindqvist/Dashing.io-widgets

class WunderListHandl
  def initialize()
    # Change to ur token key and client key
    @wunderlist_token = ""  # TOKEN HERE
    @wunderlist_client = "" # CLIENT ID HERE
    # The specific list id on the list you want to show.
    @list_id = ""           # LIST ID HERE

    @wunderlist_lists_url = "https://a.wunderlist.com/api/v1/lists"
    @wunderlist_tasks_url = "https://a.wunderlist.com/api/v1/tasks?list_id=" + @list_id 

      if(@list_id.size == 0 || @wunderlist_client.size == 0 || @wunderlist_token.size == 0)
        print "Token/Client/list need to be configured in wunderlist.rb!"
    end
  end

  def parseURL(url)
      return JSON.parse(RestClient.get(url, {:'X-Access-Token' => @wunderlist_token , :'X-Client-ID' => @wunderlist_client }))
  end

  def isTaskCompleted(task)
    return task['complteded'].to_s == "true"
  end

  def retriveListTitle(list_id)
    title_url = "https://a.wunderlist.com/api/v1/lists/" + list_id.to_s
    res = parseURL(title_url)
    return res['title']
  end

  def parseWunderList()
    # Retrives all the wunderlist lists.
    raw_Lists = parseURL(@wunderlist_lists_url)

    raw_Lists.map do |list|

      #Skips the lists were not intrested in.
      next if list['id'].to_s != @list_id.to_s

      list_info = []
      list_title = retriveListTitle(list['id'])

      raw_tasks = parseURL(@wunderlist_tasks_url)

      raw_tasks.map do |task|

        next if isTaskCompleted(task)

        taskTitle = task['title']
        list_info.push(task_title: taskTitle)
      end

      return list_info , list_title
    end 
  end

end

SCHEDULER.every '1m', :first_in => 0 do |job|
    
    wunderHandler = WunderListHandl.new

    list_info, list_title = wunderHandler.parseWunderList()

    send_event('wunderlist', tasks: list_info, taskTitle: list_title)

end
