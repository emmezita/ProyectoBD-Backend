var reset = false;

function save() {
    var ff = "#form-field-"

    var fileInput = $(ff+'excel')[0];
    var file = fileInput.files[0];

    var formData = new FormData();
    formData.append('file', file);

    $.ajax({
        type: "POST",
        url: "http://localhost:5000/api/upload", 
        data: formData,
        processData: false, // Impedir que jQuery procese los datos
        contentType: false, // Impedir que jQuery establezca el tipo de contenido
        success: function (data) {
            alert("Archivo subido con éxito");
        },
        error: function (error) {
            alert("Error al subir el archivo: " + error.responseJSON.message);
        }
    });
}

$(document).ready(function() {
    $('#cargarExcel').submit(function(event) {
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