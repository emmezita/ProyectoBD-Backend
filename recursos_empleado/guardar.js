    function save() {
    var ff = "#form-field-"

    var horarios = $('#body-horarios tr').map(function () {
        return $(this).find('td:first').attr('id');
    }).get(); //obtenemos tdos los ids de los horarios

    var beneficios = $('#body-beneficios tr').map(function () {
        return {
            id: $(this).find('td:first').attr('id'),
            monto: $(this).find('td:nth-child(2)').text(),
        }
    }).get(); //obtenemos tdos los ids de los beneficios

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
        alert("El empleado debe ser mayor de edad");
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
        cargo: $(ff + "cbcargo option:selected").attr('id'),
        departamento: $(ff + "cbdepa option:selected").attr('id'),
        sueldo: $(ff+"sueldo").val(),
        horarios: horarios,
        beneficios: beneficios,
    };
    console.log(data);



    $.ajax({
        type: "POST",
        url: "http://localhost:5000/api/empleado/registrar",
        headers: {
            'Content-Type': 'application/json'
        },
        data: JSON.stringify(data),
        success: function (data) {
            alert("Empleado registrado exitosamente");
            // window.location.href = "index.php";
        },
        error: function (data) {
            alert("Error al registrar empleado");
        }
    });
}

$(document).ready(function() {
    $('#crearEmpleado').submit(function(event) {
        event.preventDefault(); // Prevent form submission
        save(); // Call the save function
        event.preventDefault(); // Prevent form submission
    });
});