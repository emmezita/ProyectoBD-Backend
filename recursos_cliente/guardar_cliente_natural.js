var reset = false;

function save() {
    var ff = "#form-field-"
    var fechanac = $(ff+"fechanac").val() // 2023-12-07
    // validar que sea mayor de edad
    var hoy = new Date();
    var cumpleanos = new Date(fechanac);
    var edad = hoy.getFullYear() - cumpleanos.getFullYear();
    var m = hoy.getMonth() - cumpleanos.getMonth();
    if (m < 0 || (m === 0 && hoy.getDate() < cumpleanos.getDate())) {
        edad--;
    }
    if (edad < 18) {
        alert("El cliente debe ser mayor de edad");
        return;
    }

    var data = {
        pnombre: $(ff+"pnombre").val(),
        snombre: $(ff+"snombre").val(),
        papellido: $(ff+"papellido").val(),
        sapellido: $(ff+"sapellido").val(),
        cedula: $(ff+"cedula").val(),
        nacionalidad: $(ff+"nacionalidad").val(),
        rif: $(ff+"rif").val(),
        correo: $(ff+"correo").val(),
        correoalt: $(ff+"correoalt").val(),
        telefono: $(ff+"codarea").val() + $(ff+"telefono").val(), 
        telefonoalt: $(ff+"codareaalt").val() + $(ff+"telefonoalt").val(),
        fechanac: fechanac,
        direccion: $(ff+"direccion").val(),
        tarjetas: getTDCs(),
    };
    console.log(data);

    $.ajax({
        type: "POST",
        url: "http://localhost:5000/api/cliente/natural/registrar",
        headers: {
            'Content-Type': 'application/json'
        },
        data: JSON.stringify(data),
        success: function (data) {
            alert("Cliente natural registrado exitosamente");
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