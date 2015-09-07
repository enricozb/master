function Hud() {

    var tabs = []

    this.show = function() {
        refresh_tabs(function () {
            hud.input.focus()
            hud.frame.fadeIn(150)
        })
    }

    this.hide = function() {
        hud.frame.fadeOut(150, function() {
            hud.frame.blur()
            hud.input.val('')
            hud.ul.empty()
            hud.div.css(css_div_default_height())
        })
    }

    this.handle_key = function(key) {
        if(key.keyCode == 27) {
            this.hide()
        }
    }

    this.input_changed = function () {
        update_div(hud, tabs)
    }

    var hud = init_hud({show: this.show, hide: this.hide, key_handler: this.handle_key, on_change: this.input_changed})

    function refresh_tabs(on_complete) {
        tabs = tabs_query(on_complete)
        on_complete()
    }

}