var tabs = new Array()

function update_tabs_with_window(window) {
	update_tabs(window.tabs)
}

function update_tabs(arr) {
	tabs = arr
	update_status("Tabs Received")
}

function update_status(str, append) {
	return
	if(!append) {
		document.getElementById("status").innerHTML = ""
	}
	document.getElementById("status").innerHTML += str 
}

function input() {
	return document.getElementById('textbox_id').value
}

function keypressed(e) {
	var s = input() + String.fromCharCode(e.keyCode)
	//update_status(s)s

	s = s.toLowerCase()
	var index = -1
	var count = 0
	for (var i = 0; i < tabs.length; i++) {
		var tab = tabs[i].title.toLowerCase()
		if(tab.indexOf(s) != -1) {
			index = i
			count++
		}
	}
	if (count == 1)
		chrome.tabs.highlight({tabs: index}, function() {})
}
document.getElementById('textbox_id').addEventListener('keypress', keypressed)
document.getElementById('textbox_id').focus()
chrome.windows.getCurrent({populate: true}, update_tabs_with_window)
//chrome.tabs.query({}, update_tabs)