var urlParams = new URLSearchParams(window.location.search);
var idEditar = urlParams.get('id');
var EMP = null;
var CLA = null;
var ANE = null;

function llenarAromas(aromas) {
    aromas.forEach(aroma => {
        $('#body-aromas').append("<tr><td id="+ aroma.aroma_codigo +">"+aroma.aroma_descripcion+"</td><td><button type='button' class='btn btn-danger' onclick='deleteAroma(this)'>Eliminar</button></td></tr>");
    });
}

function llenarIngredientes (ingredientes) {
    ingredientes.forEach(ingrediente => {
        $('#body-ingredientes').append("<tr><td id="+ ingrediente.ingrediente_codigo +">"+ingrediente.ingrediente_nombre+"</td><td><button type='button' class='btn btn-danger' onclick='deleteIngrediente(this)'>Eliminar</button></td></tr>");
    });
}

function llenarSabores (sabores) {
    sabores.forEach(sabor => {
        $('#body-sabores').append("<tr><td id="+ sabor.sabor_codigo +">"+sabor.sabor_descripcion+"</td><td><button type='button' class='btn btn-danger' onclick='deleteSabor(this)'>Eliminar</button></td></tr>");
    });
}

function llenarServidos (servidos) {
    servidos.forEach(servido => {
        $('#body-servidos').append("<tr><td id="+ servido.servido_codigo +">"+servido.servido_nombre+"</td><td><button type='button' class='btn btn-danger' onclick='deleteServido(this)'>Eliminar</button></td></tr>");
    });
}

function llenarEMP(estado, municipio, parroquia) { 
    // llenar los cb de estado, municipio y parroquia
    $("#form-field-estado").val(estado);
    $("#form-field-municipio").empty();
    $("#form-field-parroquia").empty();

    $.each(EMP.municipios[estado], function(i, municipio) {
        $("#form-field-municipio").append('<option value="'+municipio.id+'">'+municipio.nombre+'</option>');
    });
    $("#form-field-municipio").val(municipio);

    $.each(EMP.parroquias[municipio], function(i, parroquia) {
        $("#form-field-parroquia").append('<option value="'+parroquia.id+'">'+parroquia.nombre+'</option>');
    });
    $("#form-field-parroquia").val(parroquia);    
}

function llenarCLA (pclasificacion, sclasificacion) {
    $("#form-field-pclasificacion").val(pclasificacion);
    $("#form-field-sclasificacion").empty();

    $.each(CLA.secundario[pclasificacion], function(i, sclasificacion) {
        $("#form-field-sclasificacion").append('<option value="'+sclasificacion.id+'">'+sclasificacion.nombre+'</option>');
    });
    $("#form-field-sclasificacion").val(sclasificacion);
}

function llenarANE (panejamiento, sanejamiento) {
    $("#form-field-panejamiento").val(panejamiento);
    $("#form-field-sanejamiento").empty();

    if (ANE.secundario[panejamiento]) {
        $.each(ANE.secundario[panejamiento], function(i, sanejamiento) {
            $("#form-field-sanejamiento").append('<option value="'+sanejamiento.id+'">'+sanejamiento.nombre+'</option>');
        });
    }

    if (sanejamiento) {
        $("#form-field-sanejamiento").val(sanejamiento);
    }
}

$(document).ready(function() {
    var data = null;

    // Llena los campos de los selects antes de hacer el GET del producto
    cargarCategorias();
    cargarColores();
    cargarDestilaciones();
    cargarFermentaciones();
    cargarProveedores();

    // cargarCuerpos();
    // cargarRegustos();
    // cargarAromas();
    // cargarIngredientes();
    // cargarSabores();
    // cargarServidos();

    $.ajax({
        url: 'http://localhost:5000/api/usuario/ubicaciones/all',
        type: 'GET',
        dataType: 'json',
        success: function(d) {
            data = d;
            EMP = data;
            console.log(data);
            // Llena el campo estado con los datos del JSON
            data.estados.forEach(estado => {
                $("#form-field-estado").append('<option value="'+estado.id+'">'+estado.nombre+'</option>');
            });

            // Cuando el estado cambia, llena el campo municipio con los municipios correspondientes
            $("#form-field-estado").change(function() {
                var estadoId = $(this).val();
                $("#form-field-municipio").empty();
                $("#form-field-parroquia").empty();
                $.each(data.municipios[estadoId], function(i, municipio) {
                    $("#form-field-municipio").append('<option value="'+municipio.id+'">'+municipio.nombre+'</option>');
                });
                // Trigger the change event if there's only one municipality
                if (data.municipios[estadoId].length === 1) {
                    $("#form-field-municipio").trigger('change');
                }
            });

            // Cuando el municipio cambia, llena el campo parroquia con las parroquias correspondientes
            $("#form-field-municipio").change(function() {
                var municipioId = $(this).val();
                $("#form-field-parroquia").empty();
                $.each(data.parroquias[municipioId], function(i, parroquia) {
                    $("#form-field-parroquia").append('<option value="'+parroquia.id+'">'+parroquia.nombre+'</option>');
                });
            });
        },
        error: function(err) {
            console.log(err);
        }
    });

    $.ajax({
        url: 'http://localhost:5000/api/producto/clasificacion/all',
        type: 'GET',
        dataType: 'json',
        success: function(d) {
            CLA = d;
            console.log(d);
            // Llena el campo estado con los datos del JSON
            d.principal.forEach(clasificacion => {
                $("#form-field-pclasificacion").append('<option value="'+clasificacion.id+'">'+clasificacion.nombre+'</option>');
            });

            // Cuando el estado cambia, llena el campo municipio con los municipios correspondientes
            $("#form-field-pclasificacion").change(function() {
                var id = $(this).val();
                $("#form-field-sclasificacion").empty();
                $.each(d.secundario[id], function(i, clasificacion) {
                    $("#form-field-sclasificacion").append('<option value="'+clasificacion.id+'">'+clasificacion.nombre+'</option>');
                });
                // Trigger the change event if there's only one secondary classification
                if (d.secundario[id].length === 1) {
                    $("#form-field-sclasificacion").trigger('change');
                }
            });

        },
        error: function(err) {
            console.log(err);
        }
    });

    $.ajax({
        url: 'http://localhost:5000/api/producto/anejamiento/all',
        type: 'GET',
        dataType: 'json',
        success: function(d) {
            ANE = d;
            console.log(d);
            // Llena el campo estado con los datos del JSON
            d.principal.forEach(anejamiento => {
                $("#form-field-panejamiento").append('<option value="'+anejamiento.id+'">'+anejamiento.nombre+'</option>');
            });

            // Cuando el estado cambia, llena el campo municipio con los municipios correspondientes
            $("#form-field-panejamiento").change(function() {
                var id = $(this).val();
                $("#form-field-sanejamiento").empty();
                $.each(d.secundario[id], function(i, anejamiento) {
                    $("#form-field-sanejamiento").append('<option value="'+anejamiento.id+'">'+anejamiento.nombre+'</option>');
                });
                // Trigger the change event if there's only one secondary classification
                if (d.secundario[id] && d.secundario[id].length === 1) {
                    $("#form-field-sanejamiento").trigger('change');
                }
            });

            getProducto(); // ponemos este get dentro del success de este ajax para que se ejecute despues de que se llenen los campos de los selects

        }, 
        error: function(err) {
            console.log(err);
        }
    });
});

function getProducto() {
    $.ajax({
        url: 'http://localhost:5000/api/producto/' + idEditar,
        type: 'GET',
        dataType: 'json',
        success: function(d) {
            ff = '#form-field-';
            $(ff+'nombre').val(d.producto.producto_nombre);
            $(ff+"grado").val(d.producto.producto_grado_alcoholico);
            $(ff+"proveedor").val(d.proveedor.proveedor);    
            $(ff+"fermentacion").val(d.fermentacion.fermentacion_metodo);
            $(ff+"destilacion").val(d.destilacion.destilacion_metodo);
            $(ff+"categoria").val(d.categoria.categoria_nombre);
            $(ff+"color").val(d.color.color_descripcion);
            $(ff+"detallescolor").val(d.producto.producto_color_detalles);
            $(ff+"descripcion").val(d.producto.producto_descripcion);
            $(ff+"cuerpopeso").val(d.cuerpo.cuerpo_peso);
            $(ff+"cuerpotextura").val(d.cuerpo.cuerpo_textura);
            $(ff+"cuerpodensidad").val(d.cuerpo.cuerpo_densidad);
            $(ff+"cuerpodescripcion").val(d.cuerpo.cuerpo_descripcion);
            $(ff+"regustoentrada").val(d.regusto.regusto_entrada);
            $(ff+"regustoevolucion").val(d.regusto.regusto_evolucion);
            $(ff+"regustopersistencia").val(d.regusto.regusto_persistencia);
            $(ff+"regustoacabado").val(d.regusto.regusto_acabado);
            $(ff+"regustodescripcion").val(d.regusto.regusto_descripcion);
            llenarEMP(d.lugar.estado, d.lugar.municipio, d.lugar.parroquia);
            llenarCLA(d.clasificacion.primario, d.clasificacion.secundario);
            llenarANE(d.anejamiento.primario, d.anejamiento.secundario);
            llenarAromas(d.aromas);
            llenarIngredientes(d.ingredientes);
            llenarSabores(d.sabores);
            llenarServidos(d.servidos);
        },
        error: function(err) {
            console.log(err);
            alert('Error obteniendo producto');
        }
    });
}