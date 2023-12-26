//---------------------------------------------------------------------------------------------------
// FUNCION PARA CONFLICTO DE HORARIOS 

// Obtener el ID del horario seleccionado
var horarioNuevo = $(e).parent().parent().find("select :selected").attr("id");
// listaHorarios contiene los ID de todos los horarios ya registrados del empleado

function verificarDisponibilidad(listaHorarios, horarioNuevo) {
    for (var i = 0; i < listaHorarios.length; i++) {
        /* Compara si los dias son iguales, si ambas horas del nuevo Horario son menores a la de inicio
        del escogido de la lista y si ambas son mayores a la de fin */
        if (
            listaHorarios.diaSemana !== horarioNuevo[i].diaSemana ||
            (horarioNuevo.horaInicio < listaHorarios[i].horaInicio && HorarioNuevo.horaFin < listaHorarios[i].horaInicio) ||
            (horarioNuevo.horaInicio > listaHorarios[i].horaFin && HorarioNuevo.horaFin > listaHorarios[i].horaFin)
        ) {
            // Si alguna comparación es verdadera, continúa iterando en la lista
            continue;
        } else {
            // Si ninguna comparación es verdadera, sale de la función
            return;
        }
    }

    // Si se completa el recorrido sin encontrar conflictos, agrega el ID del nuevo horario a la lista
    listaHorarios.push(horarioNuevo);
}

//---------------------------------------------------------------------------------------------------
// FUNCION PARA VERIFICAR TELEFONO POR COD DE AREA

// Esta es la funcion que pude entender para obtener todos los telefonos y cod de area
// Los guarda en una lista
$(document).ready(function() {
    var data = null;
    var listaTelefonos = [];
    $.ajax({
        url: 'http://localhost:5000/api/empleado/all',
        type: 'GET',
        dataType: 'json',
        success: function(d) {
            data = d;
            listaTelefonos.push(data.telefono);
        },
        error: function() {
            alert('Error obteniendo empleado');
        }
    });
});

// Esto pude entender es para obtener el telefono nuevo del empleado 
var ff = "#form-field-"
var telefono = $(ff+"codarea").val() + $(ff+"telefono").val()

function verificarTelefono(listaTelefonos, telefonoNuevo) {
    for (var i = 0; i < listaTelefonos.length; i++) {
        // Comparar el código de área y el resto de caracteres
        if ( (listaTelefonos[i].substring(0, 4) === telefonoNuevo.substring(0, 4)) &&
            (listaTelefonos[i].substring(4) === telefonoNuevo.substring(4)) ) {
            return false;
        }
    }
    // Si no se encontró ninguna coincidencia, retornar true al finalizar el recorrido
    return true;
}