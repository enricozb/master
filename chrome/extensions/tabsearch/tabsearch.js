chrome.runtime.onMessage.addListener(
	function(request, sender, sendResponse) {
		switch(request.request) {
			case 'tabsearch:request:get_tabs':
				chrome.windows.getCurrent({populate: true}, function(window){
					sendResponse(window.tabs)
				})
				break;
			case 'tabsearch:request:tab_highlight':
				chrome.tabs.highlight({tabs: request.id}, function() {})
				break;
			case 'tabsearch:request:new_command_tab':
				chrome.tabs.create({ url: request.url })
				break;
		}
		return true
})

// chrome.tabs.onRemoved.addListener(function() {
// 	//send some fucking messagee
// })

// chrome.runtime.sendMessage({greeting: e.keyCode}, function(response) {
// 	console.log(response.farewell);
// });