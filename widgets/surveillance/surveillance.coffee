# https://github.com/DidrikLindqvist/Dashing.io-widgets
class Dashing.Surveillance extends Dashing.Widget
  onData: (data) ->
	  d = new Date();
	  $(@node).find("img").attr("src", data.imgUrl + "?"+d.getTime());