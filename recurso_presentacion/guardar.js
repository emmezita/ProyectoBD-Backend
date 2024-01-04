var reset = false;

function save() {
    var ff = "#form-field-"

    var data = {
        producto : $(ff+"producto option:selected ").attr('id'),
        empaque : $(ff+"sempaque option:selected ").attr('value'),
        precioventatienda : $(ff+"precioventatienda").val(),
        precioventaalmacen : $(ff+"precioventaalmacen").val(),
        preciocompra : $(ff+"preciocompra").val(),
        botella : $(ff+"botella option:selected").attr('idbotella'),
        material : $(ff+"botella option:selected").attr('idmaterial'),
        tapa : $(ff+"tapa option:selected").attr('id'),
        presentacionpeso : $(ff+"presentacionpeso").val(),
        imagen : $(ff+"imagen").val(),
    };
    console.log(data);

    $.ajax({
        type: "POST",
        url: "http://localhost:5000/api/presentacion/registrar",
        headers: {
            'Content-Type': 'application/json'
        },
        data: JSON.stringify(data),
        success: function (data) {
            alert("Presentacion registrada exitosamente");
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
    $('#crearPresentacion').submit(function(event) {
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