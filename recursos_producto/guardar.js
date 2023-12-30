var reset = false;

function save() {
    var ff = "#form-field-"

    var aromas = $('#body-aromas tr').map(function () {
        return $(this).find('td:first').attr('id');
    }).get(); //obtenemos tdos los ids de los aromas

    var ingredientes = $('#body-ingredientes tr').map(function () {
        return $(this).find('td:first').attr('id');
    }).get(); //obtenemos tdos los ids de los ingredientes

    var servidos = $('#body-servidos tr').map(function () {
        return $(this).find('td:first').attr('id');
    }).get(); //obtenemos tdos los ids de los servidos

    var sabores = $('#body-sabores tr').map(function () {
        return $(this).find('td:first').attr('id');
    }).get(); //obtenemos tdos los ids de los sabores

    if (Object.keys(aromas).length === 0 || Object.keys(ingredientes).length === 0 || Object.keys(sabores).length === 0 || Object.keys(servidos).length === 0) {
        alert("Por favor, asegúrate de que todas las tablas están llenas antes de guardar.");
        return;
    }

    var data = {
        nombre: $(ff+"nombre").val(),
        grado: $(ff+"grado").val(),
        proveedor: $(ff+"proveedor option:selected").attr('id'),
        parroquia: $(ff+"parroquia option:selected").attr('value'),
        fermentacion: $(ff+"fermentacion option:selected").attr('id'),
        destilacion: $(ff+"destilacion option:selected").attr('id'),
        clasificacion: $(ff+"sclasificacion option:selected").attr('value'),
        categoria: $(ff+"categoria option:selected").attr('id'),
        color: $(ff+"color option:selected").attr('id'),
        detallescolor: $(ff+"detallescolor").val(),
        descripcion: $(ff+"descripcion").val(),
        panejamiento: $(ff+"panejamiento option:selected").attr('value'),
        sanejamiento: $(ff+"sanejamiento option:selected").attr('value'),
        aromas: aromas,
        ingredientes: ingredientes,
        sabores: sabores,
        servidos: servidos,

        //cuerpo
        cuerpopeso: $(ff+"cuerpopeso").val(),
        cuerpotextura: $(ff+"cuerpotextura").val(),
        cuerpodensidad: $(ff+"cuerpodensidad").val(),
        cuerpodescripcion: $(ff+"cuerpodescripcion").val(),

        //regusto
        regustoentrada: $(ff+"regustoentrada").val(),
        regustoevolucion: $(ff+"regustoevolucion").val(),
        regustopersistencia: $(ff+"regustopersistencia").val(),
        regustoacabado: $(ff+"regustoacabado").val(),
        regustodescripcion: $(ff+"regustodescripcion").val(),

    };
    console.log(data);

    $.ajax({
        type: "POST",
        url: "http://localhost:5000/api/producto/registrar",
        headers: {
            'Content-Type': 'application/json'
        },
        data: JSON.stringify(data),
        success: function (data) {
            alert("Producto registrado exitosamente");
            reset = true;
            //hay que resetear tablas
            $('.elementor-form').reset();
        },
        error: function (data) {
            reset = false;
            alert(data.responseJSON.message);
        }
    });
}

$(document).ready(function() {
    $('#crearProducto').submit(function(event) {
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