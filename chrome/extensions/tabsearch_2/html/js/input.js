var input = $('#input')

input.on('keydown keyup', function(event) {
    if(event.which == 38 || event.which == 40){
        event.preventDefault()
    }
})