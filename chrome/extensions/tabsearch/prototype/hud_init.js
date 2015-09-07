function init_hud(params) {
    var frame = init_frame(params)
    var div   = init_div(params)
    var input = init_input(params)
    var ul    = init_ul(params)

    //Combines the elements.
    frame.appendTo('body').hide()
    frame.contents().find('body').append(div)
    div.append(input)
    div.append(ul)

    return {frame: frame, div: div, input: input, ul: ul}
}

function init_frame(params) {
	var frame = $('<iframe/>')
	frame.id = 'tabsearch:iframe'
	frame.css(css_frame())
	return frame
}

function init_div(params) {
	var div = $('<div></div>')
	div.id = 'tabsearch:maindiv'
	div.css(css_div())
	return div
}

function init_input(params) {
	var input = $('<input>')
	input.id = 'tabsearch:input'
	input.css(css_input())
	input.on('blur', params.hide)
	input.keydown(function(e) {
		if(e.keyCode == 27) {
			input.blur()
		}
	})
	input.keypress(params.key_handler)
	input.on('propertychange change paste keyup', params.on_change)
	return input
}

function init_ul(params) {
	var ul = $('<ul></ul>')
	ul.id = 'tabsearch:ul'
	ul.css(css_ul())
	return ul
}