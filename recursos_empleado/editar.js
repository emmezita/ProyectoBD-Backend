var urlParams = new URLSearchParams(window.location.search);
var idEditar = urlParams.get('id');
var EMP = null;

function llenarHorarios(horarios) {
    horarios.forEach(horario => {
        var nombre = horario.horario_dia + " " + horario.horario_hora_entrada + " a " + horario.horario_hora_salida;
        $('#body-horarios').append("<tr><td id="+ horario.horario_codigo +">"+nombre+"</td><td><button type='button' class='btn btn-danger-hor' onclick='deleteHorario(this)'>Eliminar</button></td></tr>");
    });
}

function llenarBeneficios(beneficios) {
    beneficios.forEach(beneficio => {
        $('#body-beneficios').append("<tr><td id="+ beneficio.beneficio_codigo +">"+beneficio.beneficio_nombre+"</td><td>"+beneficio.cont_bene_monto+"</td><td><button type='button' class='btn btn-danger-ben' onclick='deleteBenefit(this)'>Eliminar</button></td><td><button type='button' class='btn btn-warning-ben' onclick='editBenefit(this)'>Editar</button></td></tr>");
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
        url: 'http://localhost:5000/api/empleado/' + idEditar,
        type: 'GET',
        dataType: 'json',
        success: function(data) {
            ff = '#form-field-';
            $(ff+"pnombre").val(data.persona.persona_nat_p_nombre)
            $(ff+"snombre").val(data.persona.persona_nat_s_nombre)
            $(ff+"papellido").val(data.persona.persona_nat_p_apellido)
            $(ff+"sapellido").val(data.persona.persona_nat_s_apellido)
            $(ff+"cedula").val(data.persona.persona_nat_cedula)
            $(ff+"nacionalidad").val(data.persona.persona_nat_rif.substring(0, 1))
            $(ff+"rif").val(data.persona.persona_nat_rif.substring(1))
            $(ff+"correo").val(data.correos[0].correo_direccion)
            if (data.correos.length > 1)
                $(ff+"correoalt").val(data.correos[1].correo_direccion)
            $(ff+"codarea").val(data.telefonos[0].telefono_codigo_area)
            $(ff+"telefono").val(data.telefonos[0].telefono_numero)
            if (data.telefonos.length > 1) {
                $(ff+"codareaalt").val(data.telefonos[1].telefono_codigo_area)
                $(ff+"telefonoalt").val(data.telefonos[1].telefono_numero)
            }
            let formattedFecha = formatDate(data.persona.persona_nat_fecha_nac);
            $(ff+"fechanac").val(formattedFecha);
            $(ff+"direccion").val(data.persona.persona_nat_direccion_fiscal)
            
            if (data.cargo != null) {
                $(ff+"cbcargo").val(data.cargo.cargo_nombre)
                $(ff+"sueldo").val(parseFloat(data.cargo.cont_carg_sueldo_mensual))
            }

            if (data.departamento != null)
                $(ff+"cbdepa").val(data.departamento.departamento_nombre)

            llenarEMP(data.lugar.estado, data.lugar.municipio, data.lugar.parroquia); 
            llenarHorarios(data.horarios);
            llenarBeneficios(data.beneficios);
        },
        error: function() {
            alert('Error obteniendo empleado');
        }
    });
});