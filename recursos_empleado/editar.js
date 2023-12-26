
var urlParams = new URLSearchParams(window.location.search);
var cedulaEditar = urlParams.get('cedula');

function llenarHorarios(horarios) {
    horarios.forEach(horario => {
        $('#body-horarios').append("<tr><td id="+ horario.id +">"+horario.nombre+"</td><td><button type='button' class='btn btn-danger-hor' onclick='deleteHorario(this)'>Eliminar</button></td></tr>");
    });
}

function llenarBeneficios(beneficios) {
    beneficios.forEach(beneficio => {
        $('#body-beneficios').append("<tr><td id="+ beneficio.id +">"+beneficio.id+"</td><td>"+beneficio.monto+"</td><td><button type='button' class='btn btn-danger-ben' onclick='deleteBenefit(this)'>Eliminar</button></td><td><button type='button' class='btn btn-warning-ben' onclick='editBenefit(this)'>Editar</button></td></tr>");
    });
}

$(document).ready(function() {
    var data = null;
    $.ajax({
        url: 'http://localhost:5000/api/usuario/ubicaciones/all',
        type: 'GET',
        dataType: 'json',
        success: function(d) {
            data = d;
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
        url: 'http://localhost:5000/api/empleado/' + cedulaEditar,
        type: 'GET',
        dataType: 'json',
        success: function(data) {
            ff = 'form-field-';
            $(ff+"pnombre").val(data.pnombre)
            $(ff+"snombre").val(data.snombre)
            $(ff+"papellido").val(data.papellido)
            $(ff+"sapellido").val(data.sapellido)
            $(ff+"cedula").val(data.cedula)
            $(ff+"nacionalidad").val(data.nacionalidad)
            $(ff+"rif").val(data.rif)
            $(ff+"correo").val(data.correo)
            $(ff+"correoalt").val(data.correoalt)
            $(ff+"codarea").val(data.telefono.substring(0, 4))
            $(ff+"telefono").val(data.telefono.substring(4)),
            $(ff+"codareaalt").val(data.telefonoalt.substring(0, 4))
            $(ff+"telefonoalt").val(data.telefonoalt.substring(4))
            $(ff+"fechanac").val(data.fechanac) // 2023-12-07
            $(ff+"direccion").val(data.direccion)
            $(ff+"cbcargo").val(data.cargo)
            $(ff+"cbdepa").val(data.departamento)
            $(ff+"sueldo").val(data.sueldo)

            llenarHorarios(data.horarios);
            llenarBeneficios(data.beneficios);
        },
        error: function() {
            alert('Error obteniendo empleado');
        }
    });
});