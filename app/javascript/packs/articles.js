window.clear_form = function(){
    $('#find').val('')
    $('#local').prop('checked', false)
    $('#ext').prop('checked', false)
    $('#filters').trigger('submit')
}

window.delete_action = (e) => {
    return (window.confirm('Stai per cancellare questo articolo'))? true : e.preventDefault()
}
