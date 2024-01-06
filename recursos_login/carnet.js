var idUsuario = localStorage.getItem("idUsuario");

$(document).ready(function() {
    var data = null;
    $.ajax({
        type: "GET",
        url: "http://localhost:5000/api/carnet/" + idUsuario,
        dataType: 'json',
        success: function(data) {
            console.log(data);
            if (data.afiliacion_numero) {
                // Es afiliado
                const q = document.getElementById("numero");
                q.innerHTML = "N° " + data.afiliacion_numero;
                const p = document.getElementById("datosCarnet");
                p.innerHTML = "TITULAR:<br><strong>" + data.nombre_completo + "<br></strong>DOCUMENTO DE IDENTIDAD:<br><b>CI: " + data.identificacion + "</b>";
                var qrcode = new QRCode(document.getElementById("qrcode"), {
                    text: data.identificacion,
                    width: 120,
                    height: 120,
                    colorDark : "#000000",
                    colorLight : "#ffffff",
                    correctLevel : QRCode.CorrectLevel.H
                });
            } else {
                // Es una persona jurídica
                alert("No es afiliado");
                window.location.href = 'https://dilodev.co/usuario-perfil/?id=' + idUsuario;
            }
        },
        error: function(data) {
            alert(data.responseText);
        }
    });
});