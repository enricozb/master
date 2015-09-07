function update_div(hud, tabs) {
    var inserted = fill_ul(hud.ul, tabs, hud.input.val())
    var height = 50 * (1 + Math.min(inserted, 6))
    hud.div.css({height: height + 'px'})
    hud.ul.css({height: (height - 50) + 'px'})
}

function make_img_td(tab) {
    var img_td = $('<td></td>')
    var img = $('<img>')
    img.attr('src', tab.favicon_url)
    img.css(css_favicon())
    img_td.append(img)
    return img_td
}

function make_info_table(tab) {
    var info_table = $('<table></table>')
    info_table.css(css_tab_info_table())
    var tab_title_tr = $('<tr></tr>')
    var tab_title_td = $('<td></td>')
    tab_title_td.css(css_tab_title_td())

    tab_title_td.append(tab.rich_title)
    tab_title_tr.append(tab_title_td)

    var tab_url_tr = $('<tr></tr>')
    var tab_url_td = $('<td></td>')
    tab_url_td.css(css_tab_url_td())

    tab_url_td.append(tab.url)
    tab_url_tr.append(tab_url_td)

    info_table.append(tab_title_tr)
    info_table.append(tab_url_tr)
    return info_table
}

function make_title_td(tab) {
    var title_td = $('<td></td>')
    title_td.append(make_info_table(tab))
    return title_td
}

function make_main_div_table_tr(tab) {
    var tr = $('<tr></tr>')
    tr.append(make_img_td(tab))
    tr.append(make_title_td(tab))
    return tr
}

function make_div_table(tab) {
    var table = $('<table><col style="width:20px"><col style="width:660px"></table>')
    table.css(css_tab_table())
    table.append(make_main_div_table_tr(tab))
    return table
}

function make_div(tab) {
    var div = $('<div></div>')
    div.priority = tab.priority
    div.data('tab', tab)
    div.css(css_tab_div())
    div.append(make_div_table(tab))
    div.hover(function() {
        div.css({background: '#EEE'})
    }, function() {
        div.css({background: 'none'})
    })

    div.mouseup(function() {
        tab_click(div.data('tab'))
    })
    return div
}