CREATE VIEW ficha_producto
AS
	SELECT
		pro.producto_descripcion as descripcion, cla.clasificacion_descripcion as elaboracion, 
		(anej.anejamiento_descripcion|| ' con duración de ' || anej.anejamiento_tiempo || ' años'):: TEXT as anejamiento_producto,
		('Minimo ' || anej.anejamiento_tiempo || 'años mezclado con ' || ing.ingrediente_descripcion):: TEXT as mezclado_producto,
		(sab.sabor_descripcion|| ' con ' || reg.regusto_descripcion):: TEXT as notas_de_catado,
		(serv.servido_nombre|| ', ' || serv.servido_descripcion):: TEXT as como_servir,
		bot.botella_capacidad as capacidad_producto, pro.producto_grado_alcoholico as alcohol,
		('Ron '|| cat.categoria_nombre || ' con ' || reg.regusto_descripcion ||' envejecido por '|| anej.anejamiento_tiempo || ' años en ' || bar.barrica_nombre ):: TEXT as descripcion_presentacion,
		cat.categoria_nombre as segmento, caj.caja_capacidad as pallet, bot.botella_descripcion as botella_producto,
		tap.tapa_descripcion as tapa_presentacion, bot.botella_altura as alto, bot.botella_ancho as ancho,
		pre.presentacion_peso as peso, ('caja de '|| mat.material_nombre):: TEXT as empaque
	FROM presentacion pre
	JOIN producto pro ON pro.producto_codigo = pre.fk_producto
	JOIN clasificacion cla ON pro.fk_clasificacion = cla.clasificacion_codigo
	JOIN mezclado mez ON pro.producto_codigo = mez.fk_producto
	JOIN anejamiento anej ON mez.fk_anejamiento = anej.anejamiento_codigo
	JOIN ingrediente ing ON mez.fk_ingrediente = ing.ingrediente_codigo
	JOIN regusto reg ON pro.producto_codigo = reg.fk_producto
	JOIN producto_sabor ps ON pro.producto_codigo = ps.fk_producto
	JOIN sabor sab ON ps.fk_sabor = sab.sabor_codigo
	JOIN producto_servido pserv ON pro.producto_codigo = pserv.fk_producto
	JOIN servido serv ON pserv.fk_servido = serv.servido_codigo
	JOIN material_botella mbot ON pre.fk_material_botella_1 = mbot.fk_material and pre.fk_material_botella_2 = mbot.fk_botella
	JOIN botella bot ON bot.botella_codigo = mbot.fk_botella
	JOIN categoria cat ON pro.fk_categoria = cat.categoria_codigo
	JOIN barrica bar ON bar.barrica_codigo = anej.fk_barrica
	JOIN caja caj ON caj.caja_codigo = pre.fk_caja
	JOIN tapa tap ON tap.tapa_codigo = pre.fk_tapa
	JOIN material mat ON mat.material_codigo = mbot.fk_material
	WHERE pre.fk_producto = 5 and pre.fk_material_botella_1 = 6 and pre.fk_material_botella_2 = 2

