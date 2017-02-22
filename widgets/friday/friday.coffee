# https://github.com/DidrikLindqvist/Dashing.io-widgets
class Dashing.Friday extends Dashing.Widget
  onData: (data) ->
  	if data.isItFriday
  		$(@node).css('background-color', '#048BA8')
  	else
  		$(@node).css('background-color', '#2E4057')