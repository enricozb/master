function constrain_text(str, max_length) {
	var original_length = str.length
	var p = $('<p></p>')
	p.append(str)

	var contents = []

	var c = p.contents()

	for(var i = 0; i < c.length; i++) {
		var temp_c = c[i]
		if(temp_c.outerHTML == undefined) {
			contents.push(temp_c.data)
		}
		else {
			contents.push(temp_c.outerHTML)
		}
	}

	var span = $('<span></span>')
	span.css({
		fontFamily: '"HelveticaNeue-Light", "Helvetica Neue Light", "Helvetica Neue", Helvetica, Arial, "Lucida Grande", sans-serif',
		fontSize:'20px'
	})
    span.append(str)
    $(document.body).append(span)

	while(span.width() > max_length) {
		var last_str = contents[contents.length - 1].toString()
		var contains_strong = last_str.indexOf('<strong>') > -1
		last_str = last_str.replace(/<strong>/g, '').replace(/<\/strong>/g, '')
		last_str = last_str.slice(0, -1)
		if(last_str.length == 0) {
			contents.pop()
			str = contents.join('')
			continue
		}
		else if(contains_strong) {
			last_str = '<strong>' + last_str + '</strong>'
		}
		contents[contents.length - 1] = last_str
		str = contents.join('')
		span.html(str)
	}

	span.remove()

	if(original_length != str.length) {
		str = str.trim() + '...'
	}
	return str
}