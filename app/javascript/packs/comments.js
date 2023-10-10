window.delete_action = (e) => {
    return (window.confirm('Vuoi cancellare il commento'))? true : e.preventDefault()
}