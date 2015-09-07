Mousetrap.bind('ctrl+i', begin)

var main_div = init_div()

var input_i = init_input()
var frame_i = init_iframe()
var ul = init_ul()

main_div.append(ul)

frame_i.appendTo('body').hide()
$('#iframeid').contents().find('body').append(main_div)
main_div.prepend(input_i)

function begin() {
	input_i.focus()
	frame_i.fadeIn(150)
}

function end() {
	frame_i.fadeOut(150, function() {
		frame_i.blur()
		input_i.val('')
	})
}

function handle_key(e) {
	make_li_array()
	// chrome.runtime.sendMessage({greeting: e.keyCode}, function(response) {
	// 	console.log(response.farewell);
	// });
}

window.onscroll = end

function make_li_array() {
	chrome.runtime.sendMessage('tabsearch:tabrequest', function(response) {
		var array = response
		var length = array.length

		var height = parseInt(main_div.css('height').replace('px', '')) * (1 + length)

		main_div.css({height: height})

		for(var i = 0; i < length; i++) {
			var tab = array[i]
			var div = make_tab_div({title: tab.title, url: tab.url, favicon_url: tab.favIconUrl})
			ul.append(div)
		}
	})
}

function make_tab_div(tab) {
	var div = $('<div></div>')
	div.css({
		height: '50px',
		width: 	'660px',
		margin: '0px',
		padding: '0',
		boxShadow: '0 -0.2px 0 #000',
		position: 'relative',
		left: '50%',
		MozTransform: 'translateX(-50%)',
		webkitTransform: 'translateX(-50%)',
		outline: '0',
		border: '0',
	})

	div.hover(function() {
		div.css({background: '#EEE'})
	}, function() {
		div.css({background: 'none'})
	})

	div.click(function() {
		alert('clicked me!')
	})

	var table = $('<table><col style="width:20px"><col style="width:660px"></table>')
	table.css({
		cellpadding: '0',
		cellspacing: '0',
		height:'100%',
		width:'100%'
	})

	var tr = $('<tr></tr>')
	var tdimg = $('<td></td>')
	var img = $('<img>')
	img.attr('src', tab.favicon_url)
	img.css({
		height: '20px',
		width: '20px'
	})
	tdimg.append(img)

	var tdtitle = $('<td></td>')

	var titletable = $('<table></table>')
	titletable.css({
		width:'100%',
		height: '100%'
	})
	var tab_title_tr = $('<tr></tr>')
	var tab_title_td = $('<td></td>')
	tab_title_td.css({
		height : '25px',
		verticalAlign: 'middle'
	})
	tab_title_td.append(tab.title)
	tab_title_tr.append(tab_title_td)

	var tab_url_tr = $('<tr></tr>')
	var tab_url_td = $('<td></td>')
	tab_url_td.css({
		height : '5px',
		verticalAlign: 'middle',
		color: '#777',
		fontSize: '7pt'
	})
	tab_url_td.append(tab.url)
	tab_url_tr.append(tab_url_td)

	titletable.append(tab_title_tr)
	titletable.append(tab_url_tr)
	tdtitle.append(titletable)

	tr.append(tdimg)
	tr.append(tdtitle)

	table.append(tr)

	div.append(table)
	return div
}

function init_ul() {
	var ul = $('<ul></ul>')
	ul.id = 'tabsearch:ul'
	ul.css({
		listStyleType: 'none',
		fontFamily: '"HelveticaNeue-Light", "Helvetica Neue Light", "Helvetica Neue", Helvetica, Arial, "Lucida Grande", sans-serif',
		padding: '0',
		margin: '0',
	})
	return ul
}

function init_div() {
	var div = $('<div></div>')
	div.id = 'tabsearch:maindiv'
	div.css({
		height: '50px',
		width: 	'680px',
		position: 'fixed',
		top: '20%',
		margin: '0',
		padding: '0',
		left: '50%',
		MozTransform: 'translateX(-50%)',
		webkitTransform: 'translateX(-50%)',
		zIndex: '1000',
		border: '0px',
		borderRadius: '10px',
		boxShadow: '0 0 0 1px rgba(20, 20, 20, .5)',
		outline: '0',
		background: 'white'
	})
	return div
}

function init_input() {
	var jqinput = $('<input>')

	jqinput.css({
		height: '50px',
		width: 	'680px',
		margin: '0',
		//margin: '5px 5px 5px 5px',
		padding: '0',
		paddingLeft: '20px',
		top: '0%',
		left: '0%',
		zIndex: '1001',
		border: '0px',
		borderRadius: '10px',
		//boxShadow: '0 0 0 1px rgba(20, 20, 20, .5)',
		outline: '0',
		fontFamily: '"HelveticaNeue-Light", "Helvetica Neue Light", "Helvetica Neue", Helvetica, Arial, "Lucida Grande", sans-serif',
		fontSize:   '20px',
		color: '#111',
	})
	
	jqinput.on('blur', end)
	
	jqinput.keydown(function(e) {
		if(e.keyCode == 27) {
			jqinput.blur()
		}
	})
	
	jqinput.keypress(handle_key)

	return jqinput
}

function init_iframe() {
	var jqframe = $('<iframe id="iframeid"/>')

	jqframe.css({
		height: '100%',
		width: 	'100%',
		padding:'0',
		position: 'fixed',
		top: 	'0',
		left: 	'0',
		zIndex: '999',
		border: '0'
	})
	return jqframe
}