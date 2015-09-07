// ------ TODO -------
// - option to close tabs
// - paging, or max show.
// - 'best match' order
// - newline fix
// - extension settings
// - chrome://*/ favicon fix.
// - efficienty

function Hud() {
    var tabs = []
    var hud = {}
    this.show = function() {
        refresh_tabs(function(tabs_response) {
            tabs = tabs_response
            hud.input.focus()
            hud.frame.fadeIn(150)
        })
    }
    this.hide = function() {
        hud.frame.fadeOut(150, function() {
            hud.frame.blur()
            hud.ul.empty()
            hud.div.css(css_div_default_height())
            hud.input.val('')
        })
    }
    this.handle_key = function(key) {
        switch(key.keyCode) {
            case 13:    //ENTER
                tab_click()
            case 27:    //ESCAPE (hide after enter also)
                hud.hide()
                break;
            case 38:    //UP
                tabs_select_up()
                break;
            case 40:    //DOWN
                tabs_select_down()
                break;
        }
    }
    this.input_changed = function (event) {
        if(event.keyCode != 40 && event.keyCode != 38 && event.keyCode != 27)
            update_div(hud, tabs)
    }
    hud = init_hud({show: this.show, hide: this.hide, key_handler: this.handle_key, on_change: this.input_changed})
}

var hud = new Hud()

Mousetrap.prototype.stopCallback = function () {
     return false;
}

Mousetrap.bind('ctrl+i', hud.show)