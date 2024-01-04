var urlParams = new URLSearchParams(window.location.search);
var idEditar = urlParams.get('id');

// como lo formatea al huso horario de venezuela y orginialmente es GMT 0, resta 4 horas
//le sumamos 5 horas por para pasar de dia al correcto
function formatDate(dateString) {
    var oldDate = new Date(dateString);
    var date = new Date(oldDate.getTime() + 5 * 60 * 60 * 1000);

    var day = '' + date.getDate(),
        month = '' + (date.getMonth() + 1), 
        year = date.getFullYear();

    if (day.length < 2) 
        day = '0' + day;
    if (month.length < 2) 
        month = '0' + month;

    return [year, month, day].join('-');
}

$(document).ready(function() {
    var data = null;
    $.ajax({
        url: 'http://localhost:5000/api/orden/compra/' + idEditar,
        type: 'GET',
        dataType: 'json',

        success: function(data) {
            console.log(data);
            var estatus_codigo = data.datos_orden[0][12];
            document.getElementById('procesar').disabled = true;
            document.getElementById('cancelar').disabled = true;
            document.getElementById('completar').disabled = true;
            if (estatus_codigo == 1) {
                document.getElementById('procesar').disabled = false;
                document.getElementById('cancelar').disabled = false;
            }
            if (estatus_codigo == 2) {
                document.getElementById('completar').disabled = false;
                document.getElementById('cancelar').disabled = false;
            }
            $('#orden-estatus').text(data.datos_orden[0][13]);
            $('#orden-codigo').text(data.datos_orden[0][0]);
            $('#orden-fecha').text(formatDate(data.datos_orden[0][1]));
            $('#subtotal').text("$" + data.datos_orden[0][2]);
            const p = document.getElementById("total");
            p.innerHTML = "<strong>$" + data.datos_orden[0][3] + "</strong>";
            $('#proveedor-codigo').text(data.datos_orden[0][4]);
            const q = document.getElementById("datos-proveedor");
            q.innerHTML = "<strong>Nombre de la empresa: </strong> " + data.datos_orden[0][5] + " <br> <strong>RIF:</strong> " + data.datos_orden[0][6] + "<br> <strong>Dirección:</strong> " + data.datos_orden[0][7] + "<br> <strong>Teléfono:</strong> " + data.datos_orden[0][8]
            if (data.datos_orden[0][9]) {
                const r = document.getElementById("datos-empleado");
                r.innerHTML = "<strong>Nombre:</strong> " + data.datos_orden[0][9] + " <br><strong>Dpto:</strong>"  + data.datos_orden[0][10] + " <br><strong>Cédula:</strong> 24-09-2023"  + data.datos_orden[0][11] + "</p>";
            }
        },
        error: function() {
            alert('Error obteniendo los datos de la orden de compra');
        }
    });
});