# Simple widget that will say if it's friday or not and the day.
# https://github.com/DidrikLindqvist/Dashing.io-widgets

SCHEDULER.every '1m', :first_in => 0 do |job|
	weekdays = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
	time = Time.now   
	isFriday = time.wday == 5 ? true : false
	day = weekdays[time.wday]
	if isFriday
		isItFridayText = "Yes! :)"
		extraText = ""
	else
		isItFridayText = "No! :("
		extraText = "It's " + day + "..." 
	end
	send_event("friday", { isItFriday: isFriday, ansText: isItFridayText,extraText: extraText})
	
end