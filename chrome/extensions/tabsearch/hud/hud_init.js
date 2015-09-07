function init_hud(params) {
    var frame = init_frame(params)
    var div   = init_div(params)
    var input = init_input(params)
    var ul    = init_ul(params)

    //'Packs' the elements.
    frame.appendTo('body').hide()
    frame.contents().find('body').append(div)
    div.append(input)
    div.append(ul)

    return {frame: frame, div: div, input: input, ul: ul, hide: params.hide}
}

function init_frame(params) {
	var frame = $('<iframe/>')
	frame.id = 'tabsearch:iframe'
	frame.css(css_frame())
	frame.contents().find('head').append('<link rel="stylesheet" type="text/css" href="swank.css">')
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
	input.on('keydown keyup', function(event) {
		if(event.which == 38 || event.which == 40){
			event.preventDefault()
    	}
	})
	input.on('blur', params.hide)
	input.on('propertychange paste keyup', params.on_change)
	input.keydown(params.key_handler)
	return input
}

function init_ul(params) {
	var ul = $('<ul></ul>')
	ul.id = 'tabsearch:ul'
	ul.css(css_ul())
	return ul
}