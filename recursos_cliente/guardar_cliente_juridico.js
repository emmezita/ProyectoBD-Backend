var reset = false;

function save() {
    var ff = "#form-field-"

    var data = {
        cjnacionalidad: $(ff+"cjnacionalidad").val(),
        cjrif: $(ff+"cjrif").val(),
        cjcapital: $(ff+"cjcapital").val(),
        cjdenom: $(ff+"cjdenom").val(),
        cjrazon: $(ff+"cjrazon").val(),
        cjcorreo: $(ff+"cjcorreo").val(),
        cjcorreoalt: $(ff+"cjcorreoalt").val(),
        cjtelefono: $(ff+"cjcodarea").val() + $(ff+"cjtelefono").val(),
        cjtelefonoalt: $(ff+"cjcodareaalt").val() + $(ff+"cjtelefonoalt").val(),
        cjparroquiafisica: $(ff+"cjparroquiafisica option:selected").attr('value'),
        cjdireccionfisica: $(ff+"cjdireccionfisica").val(),
        cjparroquiafiscal: $(ff+"cjparroquiafiscal option:selected").attr('value'),
        cjdireccionfiscal: $(ff+"cjdireccionfiscal").val(),
        cjpaginaweb: $(ff+"cjpaginaweb").val(),
        cjtdc: getTDCs(),
        cjcontactos: getContactos(),
    };
    console.log(data);

    $.ajax({
        type: "POST",
        url: "http://localhost:5000/api/cliente/juridico/registrar",
        headers: {
            'Content-Type': 'application/json'
        },
        data: JSON.stringify(data),
        success: function (data) {
            alert("Cliente juridico registrado exitosamente");
            reset = true;
        },
        error: function (data) {
            reset = false;
            alert(data.responseText);
        }
    });
}

$(document).ready(function() {
    $('#crearClienteJuridico').submit(function(event) {
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