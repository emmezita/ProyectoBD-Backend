var urlParams = new URLSearchParams(window.location.search);
var idEditar = urlParams.get('id');
var EMP = null;

function llenarEMPfisica(estado, municipio, parroquia) { 
    // llenar los cb de estado, municipio y parroquia
    $("#form-field-cjestadofisica").val(estado);
    $("#form-field-cjmunicipiofisica").empty();
    $("#form-field-cjparroquiafisica").empty();

    $.each(EMP.municipios[estado], function(i, municipio) {
        $("#form-field-cjmunicipiofisica").append('<option value="'+municipio.id+'">'+municipio.nombre+'</option>');
    });
    $("#form-field-cjmunicipiofisica").val(municipio);

    $.each(EMP.parroquias[municipio], function(i, parroquia) {
        $("#form-field-cjparroquiafisica").append('<option value="'+parroquia.id+'">'+parroquia.nombre+'</option>');
    });
    $("#form-field-cjparroquiafisica").val(parroquia);    
}

function llenarEPMfiscal(estado, municipio, parroquia) { 
    // llenar los cb de estado, municipio y parroquia
    $("#form-field-cjestadofiscal").val(estado);
    $("#form-field-cjmunicipiofiscal").empty();
    $("#form-field-cjparroquiafiscal").empty();

    $.each(EMP.municipios[estado], function(i, municipio) {
        $("#form-field-cjmunicipiofiscal").append('<option value="'+municipio.id+'">'+municipio.nombre+'</option>');
    });
    $("#form-field-cjmunicipiofiscal").val(municipio);

    $.each(EMP.parroquias[municipio], function(i, parroquia) {
        $("#form-field-cjparroquiafiscal").append('<option value="'+parroquia.id+'">'+parroquia.nombre+'</option>');
    });
    $("#form-field-cjparroquiafiscal").val(parroquia);    
}

function llenarTDCs(tarjetas) {
    TDCs.forEach(TDC => {
        $("#body-TDC").append("<tr><td id="+ TDC.banco.banco_codigo +">"+TDC.banco.banco_nombre+"</td><td>"+TDC.tdc_numero+"</td><td>"+TDC.tdc_vencimiento+"</td><td>"+TDC.tdc_cvv+"</td><td><button class='btn btn-danger-ben' onclick='deleteTDC(this)'>Eliminar</button></td></tr>");
    });
}

function llenarContactos(contactos) {
    contactos.forEach(contacto => {
        ('#body-contactos').append('<tr><td>' + contacto.contacto_nombre + '</td><td>' + contacto.contacto_numero + '</td><td>' + contacto.contacto_correo + '</td><td><button class="btn btn-warning-ben" onclick="editContact(this)">Editar</button></td><td><button class="btn btn-danger-ben" onclick="deleteContact(this)">Eliminar</button></td></tr>');
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
                $("#form-field-cjestadofisica").append('<option value="'+estado.id+'">'+estado.nombre+'</option>');
            });

            // Cuando el estado cambia, llena el campo municipio con los municipios correspondientes
            $("#form-field-cjestadofisica").change(function() {
                var estadoId = $(this).val();
                $("#form-field-cjmunicipiofisica").empty();
                $("#form-field-cjparroquiafisica").empty();
                $.each(data.municipios[estadoId], function(i, municipio) {
                    $("#form-field-cjmunicipiofisica").append('<option value="'+municipio.id+'">'+municipio.nombre+'</option>');
                });
                // Trigger the change event if there's only one municipality
                if (data.municipios[estadoId].length === 1) {
                    $("#form-field-cjmunicipiofisica").trigger('change');
                }
            });

            // Cuando el municipio cambia, llena el campo parroquia con las parroquias correspondientes
            $("#form-field-cjmunicipiofisica").change(function() {
                var municipioId = $(this).val();
                $("#form-field-cjparroquiafisica").empty();
                $.each(data.parroquias[municipioId], function(i, parroquia) {
                    $("#form-field-cjparroquiafisica").append('<option value="'+parroquia.id+'">'+parroquia.nombre+'</option>');
                });
            });
            
            // Llena el campo estado con los datos del JSON
            data.estados.forEach(estado => {
                $("#form-field-cjestadofiscal").append('<option value="'+estado.id+'">'+estado.nombre+'</option>');
            });

            // Cuando el estado cambia, llena el campo municipio con los municipios correspondientes
            $("#form-field-cjestadofiscal").change(function() {
                var estadoId = $(this).val();
                $("#form-field-cjmunicipiofiscal").empty();
                $("#form-field-cjparroquiafiscal").empty();
                $.each(data.municipios[estadoId], function(i, municipio) {
                    $("#form-field-cjmunicipiofiscal").append('<option value="'+municipio.id+'">'+municipio.nombre+'</option>');
                });
                // Trigger the change event if there's only one municipality
                if (data.municipios[estadoId].length === 1) {
                    $("#form-field-cjmunicipiofiscal").trigger('change');
                }
            });
        
            // Cuando el municipio cambia, llena el campo parroquia con las parroquias correspondientes
            $("#form-field-cjmunicipiofiscal").change(function() {
                var municipioId = $(this).val();
                $("#form-field-cjparroquiafiscal").empty();
                $.each(data.parroquias[municipioId], function(i, parroquia) {
                    $("#form-field-cjparroquiafiscal").append('<option value="'+parroquia.id+'">'+parroquia.nombre+'</option>');
                });
            });
        },
        error: function() {
            alert('Error obteniendo ubicaciones');
        }
    });

    $.ajax({
        url: 'http://localhost:5000/api/cliente/juridico/' + idEditar,
        type: 'GET',
        dataType: 'json',
        success: function(data) {
            ff = '#form-field-';
            $(ff+"cjnacionalidad").val(data.persona.persona_jur_rif.substring(0, 1))
            $(ff+"cjrif").val(data.persona.persona_jur_rif.substring(1))
            $(ff+"cjcapital").val(data.persona.persona_jur_capital_disp)
            $(ff+"cjdenom").val(data.persona.persona_jur_denom_comercial)
            $(ff+"cjrazon").val(data.persona.persona_jur_razon_social)
            $(ff+"cjcorreo").val(data.persona.persona_jur_correo)
            if (data.persona.persona_jur_correo_alt != null)
                $(ff+"cjcorreoalt").val(data.persona.persona_jur_correo_alt)
            $(ff+"cjcordarea").val(data.telefonos[0].telefono_cod_area)
            $(ff+"cjtelefono").val(data.telefonos[0].telefono_numero)
            if (data.telefonos.length > 1) {
                $(ff+"cjcodareaalt").val(data.telefonos[1].telefono_cod_area)
                $(ff+"cjtelefonoalt").val(data.telefonos[1].telefono_numero)
            }
            $(ff+"cjpaginaweb").val(data.persona.persona_jur_pag_web)
            $(ff+"cjdireccionfisica").val(data.persona.persona_jur_direccion_fisica)
            $(ff+"cjdireccionfiscal").val(data.persona.persona_jur_direccion_fiscal)
            llenarEMPfisica(data.lugar_fisica.estado, data.lugar_fisica.municipio, data.lugar_fisica.parroquia);
            llenarEPMfiscal(data.lugar_fiscal.estado, data.lugar_fiscal.municipio, data.lugar_fiscal.parroquia);
            llenarTDCs(data.tdc);
            llenarContactos(data.contactos);
        },
        error: function() {
            alert('Error obteniendo cliente');
        }
    });
});