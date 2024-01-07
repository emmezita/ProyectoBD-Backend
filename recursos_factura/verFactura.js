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
        url: 'http://localhost:5000/api/factura/detalle/' + idEditar,
        type: 'GET',
        dataType: 'json',

        success: function(data) {
            console.log(data);
            const p1 = document.getElementById("datos-cliente");
            p1.innerHTML = data.datos_factura[0][2] + "<br>" + data.datos_factura[0][3];

            $('#factura-codigo').text(data.datos_factura[0][0])
            $('#factura-fecha').text(formatDate(data.datos_factura[0][1]))
            $('#factura-empleado').text(data.datos_factura[0][6] + " - " + data.datos_factura[0][7])
            
            var metodos = '';
            $.each(data.metodos_pago, function(i, metodos_pago) {
                metodos = metodos + metodos_pago[0] + ", "
            });
            $('#metodos-pago').text(metodos)

            $('#puntos-obtenidos').text(data.datos_factura[0][8])
            $('#puntos-utilizados').text(data.datos_factura[0][9])

            var descuento = parseFloat(data.datos_factura[0][4]) - parseFloat(data.datos_factura[0][5]);
            $('#factura-subtotal').text(data.datos_factura[0][4]);
            $('#factura-total').text(data.datos_factura[0][5]);
            $('#factura-descuento').text(descuento);


        },
        error: function() {
            alert('Error obteniendo los datos de la factura');
        }
    });
});