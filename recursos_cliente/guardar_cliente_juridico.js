var reset = false;

function save() {
    var ff = "#form-field-"

    var pnfechanac = $(ff+"pnfechanac").val() // 2023-12-07
    // validar que sea mayor de edad
    var hoy = new Date();
    var cumpleanos = new Date(fechanac);
    var edad = hoy.getFullYear() - cumpleanos.getFullYear();
    var m = hoy.getMonth() - cumpleanos.getMonth();
    if (m < 0 || (m === 0 && hoy.getDate() < cumpleanos.getDate())) {
        edad--;
    }
    if (edad < 18) {
        alert("La persona de contacto debe ser mayor de edad");
        return;
    }

    var data = {
        cjnacionalidad: $(ff+"cjnacionalidad").val(),
        cjrif: $(ff+"cjrif").val(),
        cjcapital: $(ff+"cjcapital").val(),
        cjdenom: $(ff+"cjdenom").val(),
        cjrazon: $(ff+"cjrazon").val(),
        cjcorreo: $(ff+"cjcorreo").val(),
        cjcorreoalt: $(ff+"cjcorreoalt").val(),
        cjtelefono: $(ff+"cjcodarea") + $(ff+"cjtelefono").val(),
        cjtelefonoalt: $(ff+"cjcodareaalt") + $(ff+"cjtelefonoalt").val(),
        cjparroquiafisica: $(ff+"cjparroquiafisica option:selected").attr('value'),
        cjdireccionfisica: $(ff+"cjdireccionfisica").val(),
        cjparroquiafiscal: $(ff+"cjparroquiafiscal option:selected").attr('value'),
        cjdireccionfiscal: $(ff+"cjdireccionfiscal").val(),
        cjpaginaweb: $(ff+"cjpaginaweb").val(),
        cjtdc: getTDCs(),
        pnpnombre: $(ff+"pnpnombre").val(),
        pnsnombre: $(ff+"pnsnombre").val(),
        pnpapellido: $(ff+"pnpapellido").val(),
        pnsapellido: $(ff+"pnsapellido").val(),
        pncedula: $(ff+"pncedula").val(),
        pnnacionalidad: $(ff+"pnnacionalidad").val(),
        pnrif: $(ff+"pnrif").val(),
        pncorreo: $(ff+"pncorreo").val(),
        pncorreoalt: $(ff+"pncorreoalt").val(),
        pntelefono: $(ff+"pncodarea") + $(ff+"pntelefono").val(),
        pntelefonoalt: $(ff+"pncodareaalt") + $(ff+"pntelefonoalt").val(),
        pnparroquia: $(ff+"pnparroquia option:selected").attr('value'),
        pnfechanac: pnfechanac,
        pndireccion: $(ff+"pndireccion").val(),
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