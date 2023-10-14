window.clear_form = function(){
    $('#find').val('')
    $('#local').prop('checked', false)
    $('#ext').prop('checked', false)
    $('#filters').trigger('submit')
}