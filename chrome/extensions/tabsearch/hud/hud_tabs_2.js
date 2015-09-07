command_tabs = [
                {title: 'New Tab',    url: 'chrome://newtab/',     favIconUrl: chrome.extension.getURL('images/newtab.png'),     type: 'command'},
                {title: 'Extensions', url: 'chrome://extensions/', favIconUrl: chrome.extension.getURL('images/extensions.png'), type: 'command'},
                {title: 'Settings',   url: 'chrome://settings/',   favIconUrl: chrome.extension.getURL('images/settings.png'),   type: 'command'},
                {title: 'Downloads',  url: 'chrome://downloads/',  favIconUrl: chrome.extension.getURL('images/downloads.png'),  type: 'command'},
            ]

function refresh_tabs(on_complete) {
    chrome.runtime.sendMessage({request: 'tabsearch:request:get_tabs'}, function(response) {
        on_complete(response.concat(command_tabs)
    })
}

var selected_tab = 0

function tabs_select_up() {
    if(selected_tab <= 0) {
        return
    }
    filtered_tabs[selected_tab].css({background: 'none'})
    selected_tab -= 1
    filtered_tabs[selected_tab].css({background: '#EEE'})
}

function tabs_select_down() {
    if(selected_tab + 1 == filtered_tabs.length) {
        return
    }
    filtered_tabs[selected_tab].css({background: 'none'})
    selected_tab += 1
    filtered_tabs[selected_tab].css({background: '#EEE'})
}

function tab_click(tab) {
    if(tab === undefined) {
        var tab = filtered_tabs[selected_tab].data('tab')
    }
    if(tab.type == 'command') {
        chrome.runtime.sendMessage({request: 'tabsearch:request:new_command_tab', url: tab.url})
    }
    else {
        chrome.runtime.sendMessage({request: 'tabsearch:request:tab_highlight', id: tab.id})
    }
}

function make_rich_title(title, groups) {
    title = title.replace(/&/g,'&amp;').replace(/</g, '&lt;')
    var group_length = groups.length
    var rich_title = ''
    for(var i = 1; i < group_length; i++) {
        var group = groups[i]
        group = group.replace(/&/g,'&amp;').replace(/</g, '&lt;')
        var index_of_group = title.indexOf(group)
        rich_title += title.substring(0, index_of_group) + '<strong>' + group + '</strong>'
        title = title.substring(index_of_group + group.length)
    }

    while(rich_title.indexOf('</strong><strong>') > -1) {
        rich_title = rich_title.replace('</strong><strong>', '')
    }

    rich_title += title
    return rich_title
}

function get_input_regex(str) {
    if(str.length == 0) {
        return undefined
    }
    str = str.replace(/\s/g, '')          //Remove spaces
    var regex_str = '.*?'
    var length = str.length
    for (var i = 0; i < length; i++) {
        regex_str += '(' + str.charAt(i) + ')' + '.*?' 
    }
    return new RegExp(regex_str, 'i') 
}

var max_filter = 6

function filter(tab, input, regex, num_filtered) {
    input = input.replace(/\s/g, '')
    if(num_filtered > max_filter || regex == undefined) {
        return {keep: false}
    }
    
    var match_result = tab.title.match(regex)

    if(match_result != null) {
        tab.rich_title = make_rich_title(tab.title, match_result)

        var priority = tab.title.toLowerCase().indexOf(input.toLowerCase())

        if(priority > -1) {
            return {keep: true, priority: priority}
        }
        else {
            return {keep: true, priority: 999999} 
        }

        return {keep: true, priority: 999999}
    }

    return {keep: false}
}

var filtered_tabs = []

function reset_tabs() {
    selected_tab = 0
    ul.empty()
    filtered_tabs = []
}

function fill_ul(ul, tabs, str) {
    reset_tabs()
    var length = tabs.length
    var ommited = 0
    var regex = get_input_regex(str)

    for (var i = 0; i < length; i++) {
        var tab = tabs[i]
        var filter_result = filter(tab, str, regex, filtered_tabs.length)
        if(!filter_result.keep) {
            ommited++
            continue
        }
        var tab_obj = { 
                        title: tab.title, 
                        rich_title: constrain_text(tab.rich_title, 750), 
                        url: tab.url, 
                        favicon_url: tab.favIconUrl, 
                        id: i, 
                        type: tab.type,
                        priority: filter_result.priority
                    }
        var div = make_div(tab_obj)
        filtered_tabs.push(div)
    }

    filtered_tabs.sort(function(a, b) {return a.priority - b.priority})
    var ul_length = filtered_tabs.length

    for(var i = 0; i < ul_length; i++) {
        ul.append(filtered_tabs[i])
    }
    if(filtered_tabs.length > 0) {
        var selected_div = filtered_tabs[selected_tab]
        selected_div.css({background: '#EEE'})
    }
    return length - ommited
}