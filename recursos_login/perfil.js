var idUsuario = localStorage.getItem("idUsuario");

$(document).ready(function() {
    var data = null;
    $.ajax({
        type: "GET",
        url: "http://localhost:5000/api/perfil/" + idUsuario,
        success: function(data) {
            data = d;
            console.log(data);
        },
        error: function(data) {
            alert(data.responseText);
        }
    });
    if (data.)
}