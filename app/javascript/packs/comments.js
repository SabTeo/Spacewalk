window.delete_action = (e) => {
    return (window.confirm('Vuoi cancellare il commento'))? true : e.preventDefault()
}

var active = 0;

window.edit = (id) => {
    if(active!=0){
        window.cancel(active)
    }
    active = id
    $('#text'+id).val( $('#p'+id).text() )
    $('#p'+id).addClass('hidden')
    $('#form'+id).removeClass('hidden')
    $('#edit'+id).addClass('hidden')
    $('#cancel'+id).removeClass('hidden')
    $("textarea").each(function () {
        this.setAttribute("style", "resize: none; height:0.9rem;overflow-y:hidden;");
      }).on("focus", function () {
        this.style.height = 0;
        this.style.height = (this.scrollHeight) + "px";
      });
      $('#text'+id).focus()
}

window.cancel = (id) => {
    $('#p'+id).removeClass('hidden')
    $('#form'+id).addClass('hidden')
    $('#edit'+id).removeClass('hidden')
    $('#cancel'+id).addClass('hidden')
}