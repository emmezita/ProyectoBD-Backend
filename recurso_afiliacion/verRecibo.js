var urlParams = new URLSearchParams(window.location.search);
var idEditar = urlParams.get('id');

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

function formatMes(dateString) {
    var meses = ['ENERO', 'FEBRERO', 'MARZO', 'ABRIL', 'MAYO', 'JUNIO', 'JULIO', 'AGOSTO', 'SEPTIEMBRE', 'OCTUBRE', 'NOVIEMBRE', 'DICIEMBRE'];
    var oldDate = new Date(dateString);
    var fecha = new Date(oldDate.getTime() + 5 * 60 * 60 * 1000);

    var mesAnio = meses[fecha.getMonth()];

    return mesAnio;
}

$(document).ready(function() {
    $.ajax({
        url: 'http://localhost:5000/api/pago/afiliacion/detalle/' + idEditar,
        type: 'GET',
        dataType: 'json',

        success: function(data) {
            const p = document.getElementById("datos-afiliado");
            p.innerHTML = data[0].nombre_cliente + "<br>" + data[0].identificacion_cliente;
            $('#orden-codigo').text(idEditar);
            var fechaPago = formatDate(data[0].pago_fecha);
            $('#orden-fecha').text(fechaPago);
            var fechaMes = formatMes(data[0].pago_mes);
            $('#recibo-mes').text("MES DE " + fechaMes);
            $('#recibo-monto').text("$" + data[0].monto_pago);
            $('#recibo-subtotal').text("$" + data[0].monto_pago);
            $('#recibo-total').text("$" + data[0].monto_pago);
        },
        error: function() {
            alert('Error obteniendo los datos del pago');
        }
    });
});