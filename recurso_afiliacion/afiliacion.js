var idUsuario = localStorage.getItem("idUsuario");

$('#btnAfiliar').on('click', function() {
    var idUsuario = localStorage.getItem("idUsuario");
    if (idUsuario == null) {
        alert("Debe iniciar sesión para afiliarse");
    } else {
        var data = {
            idUsuario: idUsuario
        };
        $.ajax({
            type: "POST",
            url: "http://localhost:5000/api/afiliacion/afiliar",
            headers: {
                'Content-Type': 'application/json'
            },
            data: JSON.stringify(data),
            success: function(data) {
                alert("Afiliación exitosa");
            },
            error: function(data) {
                alert(data.responseText);
            }
        });
    }
});