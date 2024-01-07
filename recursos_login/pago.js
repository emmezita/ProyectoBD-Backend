var idUsuario = localStorage.getItem("idUsuario");
var monto = 0;
var codigo = '';

function formatDate(dateString) {
    var meses = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
    var oldDate = new Date(dateString);
    var fecha = new Date(oldDate.getTime() + 5 * 60 * 60 * 1000);

    var mesAnio = meses[fecha.getMonth()] + '/' + fecha.getFullYear();

    return mesAnio;
}

function mostrarMes(codigo) {
    $.ajax({
        type: "GET",
        url: "http://localhost:5000/api/pago/afiliacion/" + codigo,
        dataType: 'json',
        success: function(data) {
            var fecha = formatDate(data.proximomespago);
            $('#mes-pagado').text(fecha);
        },
        error: function(data) {
            alert(data.responseText);
        }
    });    
}

function mostratMontoyTDC() {
    $.ajax({
        type: "GET",
        url: "http://localhost:5000/api/pago/afiliacion/monto/" + idUsuario,
        dataType: 'json',
        success: function(data) {
            $('#monto-pagado').text("$" + data.monto);
            monto = data.monto;
            var tdc = data.tdcs;
            tdc.forEach(tarjeta => {
                $("#form-field-tdc").append("<option id="+ tarjeta.split(':')[0] +">"+ tarjeta.split(':')[1] +"</option>");
            });
        },
        error: function(data) {
            alert(data.responseText);
        }
    });    
}

function save() {
    var data = {
        tdc: $("#form-field-tdc option:selected").attr('id'),
        montopagado: monto,
    };
    console.log(data);

    $.ajax({
        type: "POST",
        url: "http://localhost:5000/api/pago/afiliacion/procesar/" + codigo,
        headers: {
            'Content-Type': 'application/json'
        },
        data: JSON.stringify(data),
        success: function (data) {
            alert("Pago registrado exitosamente");
            reset = true;
            //hay que resetear tablas
            $('.elementor-form').reset();
            location.reload();
        },
        error: function (data) {
            reset = false;
            alert(data.responseJSON.message);
        }
    });
}

$(document).ready(function() {
    var data = null;
    $.ajax({
        type: "GET",
        url: "http://localhost:5000/api/carnet/" + idUsuario,
        dataType: 'json',
        success: function(data) {
            if (data.afiliacion_numero) {
                codigo = data.afiliacion_numero;
                mostrarMes(data.afiliacion_numero);
                mostratMontoyTDC();
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
    $('#pagoAfiliacion').submit(function(event) {
        save(); // Call the save function
    });
});

$(document).on('reset', (e) => { 
    if (reset) {
        reset = false;
        return;
    }
    e.preventDefault() 
})