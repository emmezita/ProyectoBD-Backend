var idUsuario = localStorage.getItem("idUsuario");

$('#btnAfiliar').click(function() {
    console.log("click");
    var idUsuario = localStorage.getItem("idUsuario");
    if (idUsuario == null) {
        alert("Debe iniciar sesión para afiliarse");
    } else {
        $.ajax({
            type: "PUT",
            url: "http://localhost:5000/api/afiliacion/registrar/" + idUsuario,
            success: function(data) {
                alert("Afiliación exitosa");
            },
            error: function(data) {
                alert(data.responseText);
            }
        });
    }
});