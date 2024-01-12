var reset = false;

function save() {
    var ff = "#form-field-"

    var presentaciones = $('#body-presentaciones tr').map(function () {
        return {
            material: $(this).find('td:first').attr('idmaterial'),
            botella: $(this).find('td:first').attr('idbotella'),
            producto: $(this).find('td:first').attr('idproducto'),
            cantidad: $(this).find('td:nth-child(2)').text(),
            precio: $(this).find('td:nth-child(3)').text(),
        }
    }).get(); //obtenemos tdos los ids de las presentaciones

    var data = {
        nombre : $(ff+"nombre").val(),
        cupos : $(ff+"cupos").val(),
        entradas : $(ff+"entradas").val(),
        costoentrada : $(ff+"costoentrada").val(),
        fechainicio : $(ff+"fechainicio").val(),
        fechacierre : $(ff+"fechacierre").val(),
        parroquia : $(ff+"parroquia option:selected ").attr('value'),
        direccion : $(ff+"direccion").val(),
        descripcion : $(ff+"descripcion").val(),
        presentaciones : presentaciones,
    };
    console.log(data);

    $.ajax({
        type: "POST",
        url: "http://localhost:5000/api/evento/registrar",
        headers: {
            'Content-Type': 'application/json'
        },
        data: JSON.stringify(data),
        success: function (data) {
            alert("Evento registrado exitosamente");
            reset = true;

            $('.elementor-form').reset();
        },
        error: function (data) {
            reset = false;
            alert(data.responseJSON.message);
        }
    });
}

$(document).ready(function() {
    $('#crearEvento').submit(function(event) {
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