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
        url: 'http://localhost:5000/api/orden/reposicion/' + idEditar,
        type: 'GET',
        dataType: 'json',
        success: function(data) {
            $('#orden-codigo').text(data.orden_codigo);
            $('#orden-fecha').text(formatDate(data.orden_fecha));
        },
        error: function() {
            alert('Error obteniendo orden de reposicion');
        }
    });
});