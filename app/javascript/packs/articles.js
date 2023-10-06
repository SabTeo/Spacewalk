console.log('ready')

window.clear_form = function(){
    $('#find').val('')
    $('#local').prop('checked', false)
    $('#ext').prop('checked', false)
    $('#filters').trigger('submit');
    console.log('clear!')
}