function tabs_query(on_complete) {
    return [{title: "Messenger", 
                url: "https://www.messenger.com/t/scoleciter"}, 
            {title: "test search - Google Search", 
                url: "https://www.google.com.br/?gfe_rd=cr&ei=1j-dVfeQNPOp8weauIGACg&gws_rd=ssl#q=test+search"},
            {title: "Extensions",
                url: "chrome://extensions/"},
            {title: "multithreading - Stack Overflow",
                url: "http://stackoverflow.com/questions/3310049/proper-use-of-mutexes-in-python"},
            {title: "Ceephax Acid Crew - Mediterranean Acid - YouTube",
                url: "https://www.youtube.com/watch?v=OPyZGCKu2wg"}
            ]
}

function update_div(hud, tabs) {
    var inserted = fill_ul(hud.ul, tabs, hud.input.val())
    var height = 50 * (1 + inserted)
    hud.div.css({height: height + 'px'})
}

function filter(tab, str) {
    str = str.replace(' ', '')          //Remove spaces
    var regex_str = '.*'
    var length = str.length
    for (var i = 0; i < length; i++) {
        regex_str += '(' + str.charAt(i) + ')' + '.*' 
    }
    var regex = new RegExp(regex_str, 'i')
    var match = tab.title.match(regex)
    return match != null
}

function fill_ul(ul, tabs, str) {
    ul.empty()
    var length = tabs.length
    var ommited = 0
    for (var i = 0; i < length; i++) {
        var tab = tabs[i]
        if(!filter(tab, str)) {
            ommited++
            continue
        }
        var div = make_div({title: tab.title, url: tab.url, favicon_url: 'favicon.jpg'})
        ul.append(div)
    }
    return length - ommited
}

function make_div(tab) {
    var div = $('<div></div>')
    div.css(css_tab_div())

    div.hover(function() {
        div.css({background: '#EEE'})
    }, function() {
        div.css({background: 'none'})
    })

    div.click(function() {
        alert('clicked me!')
    })

    var table = $('<table><col style="width:20px"><col style="width:660px"></table>')
    table.css(css_tab_table())

    var tr = $('<tr></tr>')
    var img_td = $('<td></td>')
    var img = $('<img>')
    img.attr('src', tab.favicon_url)
    img.css(css_favicon())
    img_td.append(img)

    var title_td = $('<td></td>')

    var info_table = $('<table></table>')
    info_table.css(css_tab_info_table())
    var tab_title_tr = $('<tr></tr>')
    var tab_title_td = $('<td></td>')
    tab_title_td.css(css_tab_title_td())
    tab_title_td.append(tab.title)
    tab_title_tr.append(tab_title_td)

    var tab_url_tr = $('<tr></tr>')
    var tab_url_td = $('<td></td>')
    tab_url_td.css(css_tab_url_td())
    tab_url_td.append(tab.url)
    tab_url_tr.append(tab_url_td)

    info_table.append(tab_title_tr)
    info_table.append(tab_url_tr)
    title_td.append(info_table)

    tr.append(img_td)
    tr.append(title_td)

    table.append(tr)

    div.append(table)
    return div
}