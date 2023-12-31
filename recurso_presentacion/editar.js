var urlParams = new URLSearchParams(window.location.search);
var idEditar1 = urlParams.get('id1');
var idEditar2 = urlParams.get('id2');
var idEditar3 = urlParams.get('id3');

var EMP = null;

function llenarEMP(pempaque, sempaque) { 
    $("#form-field-pempaque").val(pempaque);
    $("#form-field-sempaque").empty();

    $.each(CLA.secundario[pempaque], function(i, sempaque) {
        $("#form-field-sempaque").append('<option value="'+sempaque.id+'">'+sempaque.nombre+'</option>');
    });
    $("#form-field-sempaque").val(sempaque);
}

$(document).ready(function() {
    var data = null;
    $.ajax({
        url: 'http://localhost:5000/api/presentacion/empaque/all',
        type: 'GET',
        dataType: 'json',
        success: function(d) {
            data = d;
            console.log(data);
            // Llena el campo empaque principal con los datos del JSON
            data.principal.forEach(empaque => {
                $("#form-field-pempaque").append('<option value="'+empaque.id+'">'+empaque.nombre+'</option>');
            });

            // Cuando la empaque principal cambia, llena el campo empaque secundaria con las empaques secundarias correspondientes
            $("#form-field-pempaque").change(function() {
                var id = $(this).val();
                $("#form-field-sempaque").empty();
                $.each(data.secundario[id], function(i, empaque) {
                    $("#form-field-sempaque").append('<option value="'+empaque.id+'">'+empaque.nombre+'</option>');
                });
                // Trigger the change event if there's only one secondary classification
                if (data.secundario[id].length === 1) {
                    $("#form-field-sempaque").trigger('change');
                }
            });

        },
        error: function() {
            alert('Error obteniendo las cajas de los productos');
        }
    });

    $.ajax({
        url: 'http://localhost:5000/api/presentacion/' + idEditar1 + '/' + idEditar2 + '/' + idEditar3,
        type: 'GET',
        dataType: 'json',
        success: function(d) {
            data = d;
            console.log(data);
            llenarEMP(data.empaque_principal, data.empaque_secundario);
        },
        error: function() {
            alert('Error obteniendo la presentación');
        }
    });