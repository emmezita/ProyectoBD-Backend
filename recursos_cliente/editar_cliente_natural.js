var urlParams = new URLSearchParams(window.location.search);
var idEditar = urlParams.get('id');
var EMP = null;

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

function llenarTDCs(tarjetas) {
    if (tarjetas == null) return;

    if (!Array.isArray(tarjetas)) 
        tarjetas = [tarjetas];
    
    tarjetas.forEach(TDC => {
        $("#body-TDC").append("<tr><td id="+ TDC.fk_banco +">"+TDC.banco_nombre+"</td><td>"+TDC.tdc_numero_tarjeta+"</td><td>"+TDC.tdc_fecha_vencimiento+"</td><td>"+TDC.tdc_cvv+"</td><td><button class='btn btn-danger-ben' onclick='deleteTDC(this)'>Eliminar</button></td></tr>");
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
        url: 'http://localhost:5000/api/cliente/natural/' + idEditar,
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
            let fecha = new Date(data.persona.persona_nat_fecha_nac);
            let formattedFecha = fecha.getFullYear() + '-' + ('0' + (fecha.getMonth() + 1)).slice(-2) + '-' + ('0' + fecha.getDate()).slice(-2);
            $(ff+"fechanac").val(formattedFecha);
            $(ff+"direccion").val(data.persona.persona_nat_direccion_fiscal)

            llenarEMP(data.lugar.estado, data.lugar.municipio, data.lugar.parroquia); 
            llenarTDCs(data.tdc);
        },
        error: function() {
            alert('Error obteniendo cliente');
        }
    });
});