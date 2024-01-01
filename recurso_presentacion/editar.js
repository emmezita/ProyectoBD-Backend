var urlParams = new URLSearchParams(window.location.search);
var idEditar1 = urlParams.get('id1');
var idEditar2 = urlParams.get('id2');
var idEditar3 = urlParams.get('id3');

var EMP = null;

function llenarEMP(pempaque, sempaque) { 
    $("#form-field-pempaque").val(pempaque);
    $("#form-field-sempaque").empty();

    $.each(EMP.secundario[pempaque], function(i, sempaque) {
        $("#form-field-sempaque").append('<option value="'+sempaque.id+'">'+sempaque.nombre+'</option>');
    });
    $("#form-field-sempaque").val(sempaque);
    }

    $(document).ready(function() {
        var data = null;

        cargarTapas();
        cargarProductos();
        cargarBotellas();

        $.ajax({
            url: 'http://localhost:5000/api/presentacion/empaque/all',
            type: 'GET',
            dataType: 'json',
            success: function(d) {
                data = d;
                EMP = data;
                // Llena el campo empaque principal con los datos del JSON
                data.principal.forEach(empaque => {
                    $("#form-field-pempaque").append('<option value="'+empaque.id+'">'+empaque.nombre+'</option>');
                });

                // Cuando la empaque principal cambia, llena el campo empaque secundaria con las empaques secundarias correspondientes
                $("#form-field-pempaque").change(function() {
                    var id = $(this).val();
                    $("#form-field-sempaque").empty();
                    $.each(data.secundario[id], function(_, empaque) {
                    $("#form-field-sempaque").append('<option value="'+empaque.id+'">'+empaque.nombre+'</option>');
                });
                // Trigger the change event if there's only one secondary classification
                if (data.secundario[id].length === 1) {
                    $("#form-field-sempaque").trigger('change');
                }
            });

            getPresentacion();

        },
        error: function() {
            alert('Error obteniendo las cajas de los productos');
        }
    });
});

function getPresentacion(){
    $.ajax({
        url: 'http://localhost:5000/api/presentacion/' + idEditar1 + '/' + idEditar2 + '/' + idEditar3,
        type: 'GET',
        dataType: 'json',
        success: function(d) {
            data = d;
            var ff = "#form-field-"
            $(ff + "producto").val(data.producto.producto_nombre);
            $(ff + "precioventatienda").val(data.venta_tienda.precio_venta_valor);
            $(ff + "precioventaalmacen").val(data.venta_almacen.precio_venta_valor);
            $(ff + "preciocompra").val(data.compra.precio_compra_valor);
            $(ff + "botella").val(data.botella.botella_descripcion + ' de ' + data.material.material_nombre);
            $(ff + "tapa").val(data.tapa.tapa_descripcion);
            $(ff + "presentacionpeso").val(data.presentacion.presentacion_peso);
            $(ff + "imagen").val(data.imagen.imagen_nombre);
            llenarEMP(data.empaque.primario, data.empaque.secundario);
        },
        error: function() {
            alert('Error obteniendo la presentación');
        }
    });
}