var urlParams = new URLSearchParams(window.location.search);
var idEditar = urlParams.get('id');
var EMP = null;

function llenarPresentaciones(presentaciones) {
    presentaciones.forEach(presentacion => {
        $('#body-presentaciones').append("<tr><td idmaterial="+ presentacion.c1 +" idbotella="+ presentacion.c2 +" idproducto="+ presentacion.c3 +">"+presentacion.nombre+"</td><td>"+presentacion.cantidad+"</td><td>"+presentacion.precio+"</td><td><button type='button' class='btn btn-danger' onclick='deletePresentacion(this)'>Eliminar</button></td><td><button type='button' class='btn btn-primary' onclick='editPresentacion(this)'>Editar</button></td></tr>");
    });
}

function llenarEMP(estado, municipio, parroquia) { 
    // llenar los cb de estado, municipio y parroquia
    $("#form-field-estado").val(estado);
    $("#form-field-municipio").empty();
    $("#form-field-parroquia").empty();

    $.each(EMP.municipios[estado], function(i, municipio) {
        $("#form-field-municipio").append('<option value="'+municipio.id+'">'+municipio.nombre+'</option>');
    });
    $("#form-field-municipio").val(municipio);

    $.each(EMP.parroquias[municipio], function(i, parroquia) {
        $("#form-field-parroquia").append('<option value="'+parroquia.id+'">'+parroquia.nombre+'</option>');
    });
    $("#form-field-parroquia").val(parroquia);    
}

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
        url: 'http://localhost:5000/api/usuario/ubicaciones/all',
        type: 'GET',
        dataType: 'json',
        success: function(d) {
            data = d;
            EMP = data;
            console.log(data);
            // Llena el campo estado con los datos del JSON
            data.estados.forEach(estado => {
                $("#form-field-estado").append('<option value="'+estado.id+'">'+estado.nombre+'</option>');
            });

            // Cuando el estado cambia, llena el campo municipio con los municipios correspondientes
            $("#form-field-estado").change(function() {
                var estadoId = $(this).val();
                $("#form-field-municipio").empty();
                $("#form-field-parroquia").empty();
                $.each(data.municipios[estadoId], function(i, municipio) {
                    $("#form-field-municipio").append('<option value="'+municipio.id+'">'+municipio.nombre+'</option>');
                });
                // Trigger the change event if there's only one municipality
                if (data.municipios[estadoId].length === 1) {
                    $("#form-field-municipio").trigger('change');
                }
            });

            // Cuando el municipio cambia, llena el campo parroquia con las parroquias correspondientes
            $("#form-field-municipio").change(function() {
                var municipioId = $(this).val();
                $("#form-field-parroquia").empty();
                $.each(data.parroquias[municipioId], function(i, parroquia) {
                    $("#form-field-parroquia").append('<option value="'+parroquia.id+'">'+parroquia.nombre+'</option>');
                });
            });
        },
        error: function() {
            alert('Error obteniendo ubicaciones');
        }
    });

    $.ajax({
        url: 'http://localhost:5000/api/evento/'+idEditar,
        type: 'GET',
        dataType: 'json',
        success: function(d) {
            console.log(d);
            $("#form-field-nombre").val(data.evento.evento_nombre);
            $("#form-field-cupos").val(data.evento.evento_num_cupos);
            $("#form-field-entradas").val(data.evento.evento_num_entradas);
            $("#form-field-fechainicio").val(formatDate(data.evento.evento_fecha_inicio));
            $("#form-field-fechacierre").val(formatDate(data.evento.evento_fecha_fin));
            $("#form-field-direccion").val(data.evento.evento_direccion);
            $("#form-field-descripcion").val(data.evento.evento_descripcion);

            llenarPresentaciones(data.presentaciones);
            llenarEMP(data.lugar.estado, data.lugar.municipio, data.lugar.parroquia);
        },
        error: function() {
            alert('Error obteniendo evento');
        }
    });
});