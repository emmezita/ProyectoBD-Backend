var idUsuario = localStorage.getItem("idUsuario");

function mostrarDatosPersonaNatural(datos) {
    // Aquí construyes el texto para mostrar los datos de la persona natural
    // Por ejemplo:
    const texto = document.getElementById("datosPerfil");
    texto.innerHTML = "<strong>Nombres: </strong>" + datos.persona_nat_p_nombre + " " + datos.persona_nat_s_nombre
             + "<br><strong>Apellidos: </strong>" + datos.persona_nat_p_apellido + " " + datos.persona_nat_s_apellido 
             + "<br><strong>Fecha de Nacimiento: </strong>" + datos.persona_nat_fecha_nac 
             + "<br><strong>RIF: </strong>" + datos.persona_nat_rif 
             + "<br><strong>Cédula: </strong>" + datos.persona_nat_cedula
             + "<br><strong>Dirección: </strong>" + datos.persona_nat_direccion_fiscal;
}

function mostrarDatosPersonaJuridica(datos) {
    // Similar a mostrarDatosPersonaNatural, pero para persona jurídica
    const texto = document.getElementById("datosPerfil");
    texto.innerHTML = "<strong>Denominación: </strong>" + datos.persona_jur_denom_comercial
             + "<br><strong>Razón Social: </strong>" + datos.persona_jur_razon_social
             + "<br><strong>RIF: </strong>" + datos.persona_jur_rif
             + "<br><strong>Capital: </strong>" + datos.persona_jur_capital
             + "<br><strong>Página Web: </strong>" + datos.persona_jur_pagina_web
             + "<br><strong>Dirección fiscal: </strong>" + datos.persona_jur_direccion_fiscal
             + "<br><strong>Dirección física: </strong>" + datos.persona_jur_direccion_fisica;
}

$(document).ready(function() {
    var data = null;
    $.ajax({
        type: "GET",
        url: "http://localhost:5000/api/perfil/" + idUsuario,
        dataType: 'json',
        success: function(data) {
            if (data.persona_nat_codigo) {
                // Es una persona natural
                mostrarDatosPersonaNatural(data);
            } else {
                // Es una persona jurídica
                mostrarDatosPersonaJuridica(data);
            }
        },
        error: function(data) {
            alert(data.responseText);
        }
    });
});