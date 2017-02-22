# Simple widget that will take a picture and show it in the dashboard.
# Taking picture using python script located in widget folder. 
# https://github.com/DidrikLindqvist/Dashing.io-widgets

$projectFolder = "/home/....." # Only thing needed to be changed, the path to the root dash folder.

$storeImageLocation = "assets/images/"
$imageName = "surveillance.png"
$scriptLocation = "widgets/surveillance/"
$scriptName = "surveillance.py"				

SCHEDULER.every '2s', :first_in => 0 do |job|
	system("python " + $projectFolder +$scriptLocation + $scriptName + " " + $storeImageLocation + $imageName)
	send_event("surveillance", imgUrl: "assets/" + $imageName )
end