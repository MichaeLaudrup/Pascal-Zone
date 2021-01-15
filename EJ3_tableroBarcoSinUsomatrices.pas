program matrices; 
	{Declaracion de tipos de estructuras de datos}
	const 
	Num_max_barcos = 100; {numero maximo de barcos (100 submarinos)}
	ultimaColumna = 'J'; 
	numFilas = 10; 
	var {variables globales de todo el programa}
		conteo_barcos: integer; {variable para controlar el numero de barcos}
		conteo_numero_casillas: integer; 
		
	type tipoClaseBarco = (Submarino, Fragata, Dragaminas ); 
	type tipoCoordenada = record
		num_fila:integer; 
		letra_colum: char; 
		end;
	type tipoOrientacion = (Horizontal, Vertical);  
	type tipoBarco = record
		claseBarco:tipoClaseBarco; 
	    coordenada:tipoCoordenada; 
	    orientacion:tipoOrientacion; 
		end; 
    type rangobarcos = 1..Num_max_barcos; 
	type vectorBarcos = array[rangobarcos] of tipoBarco; 


	function dameLetraBarco(claseBarco: tipoClaseBarco): char; 
	begin
		case claseBarco of
		Submarino:
			dameLetraBarco := 'S'; 
		Fragata:
			dameLetraBarco := 'F'; 
		Dragaminas:
			dameLetraBarco := 'D'; 
		otherwise
			dameLetraBarco := '.'; 
		end;
	end; 

	procedure pintaBarquitoEnCoordenada( fila:integer; columna:char; vBarcos:vectorBarcos);
	var indice:integer;
	var impresion: char; 
	begin
		impresion := '.'; 
		for indice:=1 to conteo_barcos do
		begin		
		    {caso generico tanto para fragata, submarino y dragaminas es que la coordenada que se desea pintar actualmente coincida con la proa de algun barco}
			if(vBarcos[indice].coordenada.num_fila = fila) and (vBarcos[indice].coordenada.letra_colum = columna )then
			begin
				impresion := dameLetraBarco(vBarcos[indice].claseBarco);  
				conteo_numero_casillas:= conteo_numero_casillas + 1; 
			end
			{tanto para la fragata como para un dragaminas si la orientacion es horizontal deberia buscar su proa en la primera celda a la izquierda}
			else if(vBarcos[indice].claseBarco <> Submarino) and (vBarcos[indice].orientacion = Horizontal) and (Succ(vBarcos[indice].coordenada.letra_colum) = columna) and (vBarcos[indice].coordenada.num_fila = fila) then
			begin
				impresion := dameLetraBarco(vBarcos[indice].claseBarco); 
				conteo_numero_casillas:= conteo_numero_casillas + 1;
			end
			{tanto para la fragata como para un dragaminas si la orientacion es vertical deberia buscar su proa una celda hacia arriba}
			else if(vBarcos[indice].claseBarco <> Submarino) and (vBarcos[indice].orientacion = Vertical) and (vBarcos[indice].coordenada.num_fila+1 = fila) and (vBarcos[indice].coordenada.letra_colum = columna) then
			begin
				impresion := dameLetraBarco(vBarcos[indice].claseBarco); 
				conteo_numero_casillas:= conteo_numero_casillas + 1;
			end
			{Solo en el caso de que sea un dragaminas es necesario comprobar 2 celdas mas a la izquierda si existe la proa}
			else if (vBarcos[indice].claseBarco = Dragaminas) and (vBarcos[indice].orientacion = Horizontal) and (Succ(Succ(vBarcos[indice].coordenada.letra_colum)) = columna) and (vBarcos[indice].coordenada.num_fila = fila) then
			begin
				impresion := 'D';
				conteo_numero_casillas:= conteo_numero_casillas + 1; 
			end
			{Solo en el caso de que sea un dragaminas es necesario comprobar 2 celdas mas arriba existe la proa}
			else if(vBarcos[indice].claseBarco = Dragaminas) and (vBarcos[indice].orientacion = Vertical) and (vBarcos[indice].coordenada.num_fila+2 = fila) and (vBarcos[indice].coordenada.letra_colum = columna) then
			begin
				impresion := 'D'; 
				conteo_numero_casillas:= conteo_numero_casillas + 1;
			end;  			
		end;
		
		write(impresion,' '); 
	end;
	procedure dibujarTablero(vBarcos:vectorBarcos); 
		var
		fila:integer; 
		columna: char; 
	begin
		writeln('A B C D E F G H I J');
		for fila := 1 to numFilas do
		begin
			for columna := 'A' to ultimaColumna do
			begin
			    {con objeto de no hacer muy denso este metodo se delega en una funcion ir buscando si la casilla actual de la matriz tiene algun barco enviandoles los indices con los que se esta iterando}
				pintaBarquitoEnCoordenada(fila,columna,vBarcos);
			end;
			writeln(fila);  
		end;
	end; 
	
	procedure leer_Partida(var vBarcos: vectorBarcos);
	var
		entrada_leida: string[15];
		barcoMasGrande: string[15];  
	begin
	    readln(entrada_leida); 
	    while entrada_leida <> 'Fin' do
	    begin
			if(entrada_leida = 'Jugador') then
			begin
			    conteo_numero_casillas:= 0; {Se utilizan como variables globales para descargar el numero de argumentos en las llamadas a funciones}
			    conteo_barcos := 0; 
			    barcoMasGrande := 'Ninguno'; 
				readln(entrada_leida);
				repeat
					case entrada_leida of
						'Fragata':
						vBarcos[conteo_barcos+1].claseBarco := Fragata; 
						'Submarino':
						vBarcos[conteo_barcos+1].claseBarco := Submarino; 
						'Dragaminas': 
						vBarcos[conteo_barcos+1].claseBarco := Dragaminas;
					end; 
					
					{Se mantiene actualizada la variable que contiene el barco mas grande}
					if(entrada_leida = 'Submarino') and  ((barcoMasGrande <> 'Fragata') and (barcoMasGrande <> 'Dragaminas')) then
					begin
						barcoMasGrande := 'Submarino'; 
					end
					else if(entrada_leida = 'Fragata') and (barcoMasGrande <> 'Dragaminas') then
					begin
						barcoMasGrande := 'Fragata'; 
					end
					else if(entrada_leida = 'Dragaminas') then
					begin
						barcoMasGrande := 'Dragaminas'; 
					end; 
					readln(vBarcos[conteo_barcos+1].coordenada.letra_colum);
					readln(vBarcos[conteo_barcos+1].coordenada.num_fila);
					readln(vBarcos[conteo_barcos+1].orientacion);
					conteo_barcos := conteo_barcos +1; 
					readln(entrada_leida); 
				until (entrada_leida = 'Fin') or (entrada_leida = 'Jugador');
				dibujarTablero(vBarcos); 
				writeln('casillas: ', conteo_numero_casillas); 
				writeln('mayor: ', barcoMasGrande); 
			end; 
		end; 
	end; 

var
	vBarcos: vectorBarcos;
begin 
	leer_Partida(vBarcos); 
end.
