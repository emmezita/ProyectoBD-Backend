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

    var data = {
        nombre: $(ff+"nombre").val(),
        grado: $(ff+"grado").val(),
        proveedor: $(ff+"proveedor option:selected").attr('value'),
        parroquia: $(ff+"parroquia option:selected").attr('value'),
        fermentacion: $(ff+"fermentacion option:selected").attr('value'),
        destilacion: $(ff+"destilacion option:selected").attr('value'),
        clasificacion: $(ff+"sclasificacion option:selected").attr('value'),
        categoria: $(ff+"categoria option:selected").attr('value'),
        precio_compra: $(ff+"preciocompra").val(),
        precio_venta: $(ff+"precioventa").val(),
        color: $(ff+"color option:selected").attr('value'),
        detalle_color: $(ff+"detallecolor").val(),
        direccion: $(ff+"direccion").val(),
        aromas: aromas,
        anejamiento: $(ff+"sanejamiento option:selected").attr('value'),
        ingredientes: ingredientes,
        sabores: sabores,
        empaque: $(ff+"sempaque option:selected").attr('value'),
        botella: $(ff+"botella option:selected").attr('value'),
        tapa: $(ff+"tapa option:selected").attr('value'),
        presentacionpeso: $(ff+"presentacionpeso").val(),
        servidos: servidos,
        imagen: $(ff+"imagen").val(),

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
        event.preventDefault(); // Prevent form submission
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