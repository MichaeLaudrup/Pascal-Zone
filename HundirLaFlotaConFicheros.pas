program hundirLaFlotaConFicheros; 
const 
	Num_max_barcos = 100; {numero maximo de barcos (100 submarinos)}
	LongStr = 12; {palabra mas larga es portaaviones, por ende, logintud maxima 12}
	ultimaColumna = 'J'; {El tablero tiene como maxima columna la J}
	numFilas = 10; 
	Tab: char = ' '; 
	type 
	tipoClaseBarco = (Submarino, Fragata, Dragaminas, PortaAviones ); 
	tipoCoordenada = record
		num_fila:integer; 
		letra_colum: char; 
		end;
	tipoOrientacion = (Horizontal, Vertical);  
	tipoBarco = record
		claseBarco:tipoClaseBarco; 
	    coordenada:tipoCoordenada; 
	    orientacion:tipoOrientacion; 
		end;
 
        tipoListaBarcos = ^tipoNodoListaBarco; 
        tipoNodoListaBarco = record 
            indice:integer; {El indice del elemento}
            barco:tipoBarco; {El elemento en si mismo}
            siguienteBarco: tipoListaBarcos; {siguiente elemento de la lista}
        end; 
        
    
    
   tipoFilaLetras = array['A'..'J'] of char; 
   tipoMatrizLetras = array[1..10] of tipoFilaLetras;     
        
   TipoStr = record
		cars: string[LongStr];
		ncars: integer;
	end; 
	
	tipoResultadoDisparo = (Hundido, Tocado, Agua, Disparo_Repetido);
	
	tipoDisparo = record
		jugador:integer; 
		coordenada: tipoCoordenada; 
		resultado:tipoResultadoDisparo; 
	end; 
	tipoRegistroDisparos = array[0..1000] of tipoDisparo;
        
     
function vaciarLista(ListaBarcos:tipoListaBarcos):tipoListaBarcos;
begin
    ListaBarcos := nil; 
	vaciarLista := ListaBarcos; 
end;


procedure agregarBarcoALista(barcoNuevo:tipoBarco; var listaBarcos:tipoListaBarcos );
var
	 nuevoNodo,p:^tipoNodoListaBarco; 
begin
     new(nuevoNodo); 
     nuevoNodo^.barco := barcoNuevo; 
     if (listaBarcos = nil ) then begin {Si la lista de barco es vacia le insertamos un unico nodo}

         nuevoNodo^.indice := 1;
         nuevoNodo^.siguienteBarco := nil;         
         listaBarcos := nuevoNodo;
     end
     else begin {Si la lista de barcos no esta vacia habra que recorrer todo el lista de barcos hasta el ultimo nodo e insertar el barco}
        p := listaBarcos; {en este punto "p" es el primer barco de la lista de barcos}
        while(p^.siguienteBarco <> nil) do begin {Se van recorreciendo todos los nodos}
			p := p^.siguienteBarco; 
        end;
        nuevoNodo^.indice := (p^.indice  +1); 
        p^.siguienteBarco := nuevoNodo; 
     end; 
end; 


procedure vaciarstr(var str: TipoStr);
	begin
		str.ncars := 0;
		str.cars := '            '; 	
	end;
	


procedure appcar(var str: TipoStr; c: char);
	begin
		if str.ncars = LongStr then begin
			write('Exceso de limite')
		end;
		str.ncars := str.ncars + 1;
		str.cars[str.ncars] := c;
	end;
function esblanco(c: char): boolean;
begin
    esblanco := (c = ' ') or (c = Tab);
end;

procedure ignorarEspaciosEnBlanco(var entrada: text;  var caracterActual: char; var existePalabra:boolean); 
begin
    if(eoln(entrada)) then begin
        readln(entrada); 
        existePalabra := False; 
    end
    else begin
	    read(entrada,caracterActual);
	    existePalabra := not esblanco(caracterActual);
	end; 
end; 


function sonIgualesLasPalabras(palabraEscaneada:tipoStr ; palabraAComparar:string ): boolean; 
var
	i:integer; 
	resultado:boolean; 
begin
    resultado := True; {Se parte de la premisa de que las palabras son iguales}
    for i:= 1 to palabraEscaneada.ncars do begin
        if palabraAComparar[i] <> palabraEscaneada.cars[i] then begin
            resultado := False; {Desde que se encuentre una no coincidencia de caracteres se devolvera un false}
        end; 
    end; 
    sonIgualesLasPalabras := resultado; 


end; 


function coordenadaErronea(barco:TipoBarco):boolean; 
var
	resultado: boolean; 

begin
    resultado := false; 
    {CASO BASE: se ha especificado la coordenada de la proa fuera del tablero}
	if(((barco.coordenada.num_fila < 1) or (barco.coordenada.num_fila > 9)) or ((barco.coordenada.letra_colum < 'A' ) or (barco.coordenada.letra_colum > 'J' ) )) then
	begin
		resultado := True; 
	end;
	if (barco.claseBarco <> Submarino) then begin
		if(barco.orientacion = Vertical) then 
		begin 
			if(barco.coordenada.num_fila > 9) then begin {Sea fragata, dragaminas o portaaviones si su orientacion es vertical y se pone la proa en una fila numero 9 entonces mala coordenada}
			    resultado := True; 
			end; 
		end 
		else begin {Si el barco esta horizontal y es fragata, dragaminas o portaviones, su proa no puede estar en la columna 'J'} 
		    if(barco.coordenada.letra_colum > 'I') then begin 
			    resultado := True; 
			end; 
		end; 
	end;
	if((barco.claseBarco <> Submarino ) and (barco.claseBarco <> Fragata) ) then begin {Solo se entra aqui en caso de que el barco sea dragaminas o portaviones}
		if(barco.orientacion = Vertical) then 
		begin 
			if(barco.coordenada.num_fila > 8) then begin {en un dragaminas o portaaviones si su orientacion es vertical y se pone la proa en una fila mayor que la 7 entonces mala coordenada}
			    resultado := True; 
			end; 
		end 
		else begin {Si el barco esta horizontal y es dragaminas o portaviones, su proa no puede estar en una columna mayor que 'H'}
		    if(barco.coordenada.letra_colum > 'H') then begin 
			    resultado := True; 
			end; 
		end; 
	end;
	if (barco.claseBarco = PortaAviones) then begin {Caso portaviones: que no este por debajo de la linea 6 ni mas a la derecha de la columna G}
		if(barco.orientacion = Vertical) then begin 
			if(barco.coordenada.num_fila > 7) then begin {si la proa de un portaviones vertical esta en una fila mayor que 6 mala coordenada}
			    resultado := True; 
			end; 
		end 
		else begin {si la proa de un portaviones horizontal esta en una columna mayor que la 'G' mala cordenada}
		    if(barco.coordenada.letra_colum > 'G') then begin 
			    resultado := True; 
			end; 
		end; 
	end;   
	coordenadaErronea := resultado; 
	 
end;  


function procesarEntrada(var listaBarcos: tipoListaBarcos; var entrada:text; var error:boolean; var finEncontrado:boolean): tipoListaBarcos; 
var
    existePalabra: boolean;  
	caracterActual: char;
	palabraActual: tipoStr; 
    nuevoBarco: tipoBarco; 
    seEsperaNombreBarco, seEsperaColumna, seEsperaFila,seEsperaOrientacion:boolean; {variables para controlar que es lo que se espera encontrar}
    descartarBarco, barcoCorrecto:boolean; 

begin
     existePalabra := false; 
     seEsperaNombreBarco := True;
     seEsperaColumna := False; 
     seEsperaFila := False; 
     seEsperaOrientacion := False; 
     descartarBarco := False; 
     barcoCorrecto := False; 
     error := False; 
     while((not finEncontrado) and (not eof(entrada)) and (not error)) do begin {Mientras no se encuentre la palabra fin, no acaban los barcos del jugador} 
         vaciarstr(palabraActual);
         while(not existePalabra) do begin {Estara dando vueltas hasta que encuentre un caracter diferente a un espacio en blanco}
			 ignorarEspaciosEnBlanco(entrada, caracterActual, existePalabra); 
		 end;   
		 while(existePalabra) do begin
			appcar(palabraActual, caracterActual); 
            if eoln(entrada) then begin
				existePalabra := False;
				readln(entrada);  
			end
			else begin
				read(entrada, caracterActual);
				existePalabra := not esblanco(caracterActual); 
			end;
			
			if (not existePalabra) then begin {En este punto se ha procesado una palabra}
				if(sonIgualesLasPalabras(palabraActual,'FIN')) then begin
				   finEncontrado:=True; 
				end
				else if(seEsperaNombreBarco) then begin
					if(sonIgualesLasPalabras(palabraActual, 'Fragata')) then begin nuevoBarco.claseBarco := Fragata; end
					else if(sonIgualesLasPalabras(palabraActual, 'Submarino'))then begin nuevoBarco.claseBarco := Submarino; end
					else if(sonIgualesLasPalabras(palabraActual, 'Dragaminas'))then begin nuevoBarco.claseBarco := Dragaminas; end
					else if(sonIgualesLasPalabras(palabraActual, 'PortaAviones'))then begin nuevoBarco.claseBarco := PortaAviones; end
					else begin error := True; writeln('Error: Se esperaba nombre de barco y no se ha leido ningun tipo de barco')end; 
					seEsperaNombreBarco := False; 
					seEsperaColumna := True; 
				end
				else if(seEsperaColumna) then begin {Si se espera una palabra de tipo columna puede suceder que recibamos una letra independiente o una coordenada completa}
				    if(palabraActual.ncars = 1) then begin {Si se encuentra solo la primera componente de un coordenada se indica que aun se espera la fila}
				        nuevoBarco.coordenada.letra_colum := palabraActual.cars[1];
				        seEsperaColumna:=False; 
				        seEsperaFila := True; 
				    end
				    else if(palabraActual.ncars = 2) then begin {Si se encuentra una palabra de longitud 2 esto indica que se ha recibido tanto fila como culumna}
				        nuevoBarco.coordenada.letra_colum := palabraActual.cars[1];
				        
				        nuevoBarco.coordenada.num_fila := ord(palabraActual.cars[2])-48;
				        seEsperaColumna:=False; 
				        seEsperaFila := False;
				        seEsperaOrientacion := True;  
				    end
				    else if(palabraActual.ncars = 3) then begin
						nuevoBarco.coordenada.letra_colum := palabraActual.cars[1];
				        nuevoBarco.coordenada.num_fila := 10; {IMPORTANTE: Una coordenada con 3 posiciones solo puede ser 10, si el usuario inserta un numero mayor que 10, se guardara 10}
				        seEsperaColumna:=False; 
				        seEsperaFila := False;
				        seEsperaOrientacion := True; 
				    end
				    else begin
				        writeln('Error: una coordenada no puede constituir mas de 4 caracteres'); 
						error := True; 
				    end;  
				end 
				else if(seEsperaFila) then begin
				    if(palabraActual.ncars = 1) then begin
						nuevoBarco.coordenada.num_fila := ord(palabraActual.cars[1])-48; 
						seEsperaFila := False;
						seEsperaOrientacion := True;
					end 
					else begin
						nuevoBarco.coordenada.num_fila := 10; {Si hay dos caracteres para representar una fila tiene que ser 10 si o si}
						seEsperaFila := False;
						seEsperaOrientacion := True;
					end;   
				end
				else if(seEsperaOrientacion) then begin
				    
					if(sonIgualesLasPalabras(palabraActual, 'Horizontal')) then begin  nuevoBarco.orientacion := Horizontal ;   end
					else if (sonIgualesLasPalabras(palabraActual, 'Vertical'))then begin  nuevoBarco.orientacion := Vertical ;  end
					else begin writeln('Error al leer la orientacion del barco' ); error := True; end; 
					seEsperaOrientacion := False; 
					{Cuando se espera la orientacion es que ya se ha procesado la coordenada independientemente de si se intercepto como separada o unida (A    3) o (A3)}
				    if(coordenadaErronea(nuevoBarco))then begin
						descartarBarco := True; 
				    end
				    else begin
						barcoCorrecto := True; 
				    end; 
				end; 
				if(barcoCorrecto and (not descartarBarco)) then begin
					agregarBarcoALista( nuevoBarco, listaBarcos);
					seEsperaNombreBarco := True;
					barcoCorrecto := False;  
				end;
				if(descartarBarco) then begin 
					seEsperaNombreBarco := True; 
					seEsperaColumna := False; 
					seEsperaFila := False; 
					seEsperaOrientacion := False; 
				    writeln('Se descarta el barco de tipo ', nuevoBarco.claseBarco, ' por no estar bien posicionado con la coordenada ', nuevoBarco.coordenada.letra_colum,nuevoBarco.coordenada.num_fila);
				    descartarBarco := False;  
				end;   
			end;  
		 end;
     end;   
     procesarEntrada := listaBarcos; 
end; 


function dameLetraBarco(claseBarco: tipoClaseBarco): char; 
	begin
		case claseBarco of
		Submarino:
			dameLetraBarco := 'S'; 
		Fragata:
			dameLetraBarco := 'F'; 
		Dragaminas:
			dameLetraBarco := 'D'; 
		PortaAviones: 
			dameLetraBarco := 'P'; 
		otherwise
			dameLetraBarco := '.'; 
		end;
	end; 

procedure pintaBarquitoEnCoordenada(fila:integer;columna:char; listaBarcos:tipoListaBarcos; var matrizBarcos: tipoMatrizLetras; var matrizCopiaBarcos:tipoMatrizLetras);
var 
	barcoActual: tipoBarco; 
	impresion:char; 
begin
     
     if(listaBarcos = nil) then begin
         write('. '); 
     end
     else begin
         impresion := '.'; 
		 while(listaBarcos <> nil) do begin
		    barcoActual := listaBarcos^.barco; 

		    if(barcoActual.coordenada.letra_colum = columna) and (barcoActual.coordenada.num_fila = fila) then begin {Caso base: coincidencia de proa de barco con coordenada buscada}
				impresion := dameLetraBarco(barcoActual.claseBarco); 
		    end
		    else begin
				if (not (barcoActual.claseBarco = Submarino)) then begin
					if(barcoActual.orientacion = Horizontal) and (Succ(barcoActual.coordenada.letra_colum) = columna) and (barcoActual.coordenada.num_fila = fila) then begin
						impresion := dameLetraBarco(barcoActual.claseBarco);  
					end
					else if(barcoActual.orientacion = Vertical) and (barcoActual.coordenada.letra_colum = columna) and (barcoActual.coordenada.num_fila+1 = fila) then begin
						impresion := dameLetraBarco(barcoActual.claseBarco); 
					end;
				end; 
				if (not (barcoActual.claseBarco = Submarino)) and (not (barcoActual.claseBarco = Fragata)) then begin
					if(barcoActual.orientacion = Horizontal) and (Succ(Succ(barcoActual.coordenada.letra_colum)) = columna) and (barcoActual.coordenada.num_fila = fila) then begin
						impresion := dameLetraBarco(barcoActual.claseBarco);  
					end
					else if(barcoActual.orientacion = Vertical) and (barcoActual.coordenada.letra_colum = columna) and (barcoActual.coordenada.num_fila+2 = fila) then begin
						impresion := dameLetraBarco(barcoActual.claseBarco); 
					end;
				end;
				
				if(barcoActual.claseBarco = PortaAviones) then begin
					if(barcoActual.orientacion = Horizontal) and (Succ(Succ(Succ(barcoActual.coordenada.letra_colum))) = columna) and (barcoActual.coordenada.num_fila = fila) then begin
						impresion := dameLetraBarco(barcoActual.claseBarco);  
					end
					else if(barcoActual.orientacion = Vertical) and (barcoActual.coordenada.letra_colum = columna) and (barcoActual.coordenada.num_fila+3 = fila) then begin
						impresion := dameLetraBarco(barcoActual.claseBarco); 
					end;
				end;  	
		    end; 
		    listaBarcos := listaBarcos^.siguienteBarco; 
		 end; 
		 matrizBarcos[fila][columna] := impresion; 
		 matrizCopiaBarcos[fila][columna] := impresion; 
	     write(impresion,' '); 
	    
     end;  
end; 

procedure procesarLanzamiento( var entrada: text; var coordenada:tipoCoordenada);
var 
	seEsperaColumna, coordenadaLeida, existePalabra: boolean; 
	palabraActual: tipoStr; 
	caracterActual: char;
	columna: char; 
	fila: integer; 
begin
   
    seEsperaColumna := True; 
    coordenadaLeida := False; 
    existePalabra := False;
    while((not coordenadaLeida) and (not eof(entrada)))do begin
         vaciarstr(palabraActual);
         while(not existePalabra) do begin {Estara dando vueltas hasta que encuentre un caracter diferente a un espacio en blanco o un salto de linea}
			 ignorarEspaciosEnBlanco(entrada, caracterActual, existePalabra); 
		 end; 
		 while(existePalabra) do begin
			appcar(palabraActual, caracterActual); 
            if eoln(entrada) then begin
				existePalabra := False;
				readln(entrada);
				  
			end 
			else begin
				read(entrada, caracterActual);
				existePalabra := not esblanco(caracterActual); 
		    end; 
		    
		    if(not existePalabra) then begin {En este punto se ha procesado una palabra}
				if(seEsperaColumna) then begin {Si se espera una palabra de tipo columna puede suceder que recibamos una letra independiente o una coordenada completa}
				    if(palabraActual.ncars = 1) then begin {Si se encuentra solo la primera componente de un coordenada se indica que aun se espera la fila}
				        columna := palabraActual.cars[1]; 
				        seEsperaColumna:=False; 
				    end
				    else if palabraActual.ncars = 2 then begin {la longitud de la cadena es 2, vienen juntas letra y numero}
				        columna := palabraActual.cars[1];
				        fila := ord(palabraActual.cars[2])-48; 
				        coordenadaLeida := True; 
				    end
				    else begin {coordenada de 3 posiciones}
						columna := palabraActual.cars[1];
				        fila := 10; {Se fuerza a que la coordenada sea 10 porque mayor que 10 no puede ser}
				        coordenadaLeida := True; 
				    end
				end 
				else begin {Si no se espera columna, se espera fila}
					if(palabraActual.ncars = 1) then begin
						fila := ord(palabraActual.cars[1])-48; 
						coordenadaLeida := True;
					end
					else begin
						fila := 10; {Se fuerza a que la coordenada sea 10 porque mayor que 10 no puede ser}
						coordenadaLeida := True;
					end;  
				end;  
		    end; 
        end; 
   end; 
   
   if coordenadaLeida then begin
       coordenada.letra_colum := columna; 
       coordenada.num_fila := fila; 
   end
   else begin
	   write('ha habido un error'); 
   end; 
   
end;
{Esta funcion dada una coordenada y un tipo de barco, empieza a buscar alrededor de la coordenada 'X' para determinar si el barco esta hundido o no} 
function entornoCoordenadaHundido( letrabarco:char; coordenada:tipoCoordenada; matrizJugador:tipoMatrizLetras; matrizOriginal:tipoMatrizLetras ):boolean;
var 
	coord_lim_super, coord_lim_infer, coord_lim_izq, coord_lim_der: boolean; {Variables indicativas de si la coordenada recibida esta en algunos de los limites del tablero }
	esPosibleHundido, hundido : boolean; 
	contadorX: integer;  {Esta variable mantiene una cuenta de cuantas X se ha encontrado alrededor de una coordenada  para arreglar casos especiales de orden de ataques a un dragaminas
	* o aun portaviones, este algoritmo inicialmente estaba programado para funcionar de forma optica con ataques que acaban hundiendo el barco atacando a la proa o a la popa,
	* en el caso del submarino o la fragata esto no supuso problema, pero en el caso del dragaminas o el portaviones, un ataque que provoque que el barco se hunda podria ser en
	* medio del barco, no en la proa ni en la popa, por ello, se utiliza este contador auxiliar, controlando el numero de X se arregla el problema}
	fil:integer;
	col:char; 
begin
	coord_lim_infer:= false;
	coord_lim_super := false; 
	coord_lim_izq := false;
	coord_lim_der := false;
	hundido := false; 
	contadorX := 0;
	fil := coordenada.num_fila; 
	col := coordenada.letra_colum; 
	esPosibleHundido := false; {El true en esta variable determina que el barco puede estar hundido pero que se tienen que seguir haciendo comprobaciones para determinar si esta hundido}

	{Se comprueba si la coordenada esta en un limite superior o en un limite inferior}
    if(fil = 10) then begin
      
		coord_lim_infer:= true;
    end
    else if(fil = 1) then begin
		coord_lim_super := true;	
	end; 	
	{Se comrpueba si las coordenadas estan en el limite derecho o izquierdo}
	if(col ='A') then begin
		coord_lim_izq := true; 
	end
	else if (col ='J') then begin
		coord_lim_der := true; 
	end; 
  
     {CASO BASE: Sea fragata, dragaminas o portaviones hay que comprobar las posiciones inmediatamente colindantes de la coordenada, es decir, investigar 1 posicion arriba, abajo, izq y der}	
	if((not coord_lim_super ) and (matrizJugador[fil-1][col] = 'X' ) and (matrizOriginal[fil-1][col] = letrabarco) )then begin {Si la coordenada no esta en el limite superior y la posicion de encima del barco esta con X existen posibilidades de el barco este hundido}
		esPosibleHundido := true;
		contadorX := contadorX +1;  
	end; 
	if((not coord_lim_infer) and (matrizJugador[fil+1][col] = 'X' )and (matrizOriginal[fil+1][col] = letrabarco)) then begin {Si la coordenada no esta en el limite inferior y la posicion de debajo del barco esta con X existen posibilidades de el barco este hundido}
		esPosibleHundido := true;
		contadorX := contadorX +1; 			 
	end; 
	
	if((not coord_lim_izq) and (matrizJugador[fil][pred(col)] = 'X' )and (matrizOriginal[fil][pred(col)] = letrabarco)) then begin {Si la coordenada no esta en el limite izquierdo y la posicion a la izquierda del barco es X entonces es posible que este hundido}
		esPosibleHundido := true;
		contadorX := contadorX +1; 
	end; 
	
	if((not coord_lim_der) and (matrizJugador[fil][succ(col)] = 'X' )and (matrizOriginal[fil][succ(col)] = letrabarco)) then begin {Si la coordenada no esta en el limite derecho y la posicion a la derecha del barco es X entonces es posible que este hundido}
		esPosibleHundido := true;
		contadorX := contadorX +1; 		 
	end; 
	
	{En este punto si el barco es fragata y la variable "esposibleHundido" es true, entonces afirmamos que fragata esta hundida}
    if(letraBarco = 'F') and (esPosibleHundido) or ((letraBarco = 'D') and esPosibleHundido and (contadorX = 2))then begin 
		hundido := true; 
    end  
    else if ((letraBarco <> 'F') and (esPosibleHundido)) then {En caso de que el barco no sea una fragata debemos comprobar dos posiciones mas a la derecha, mas arriba, mas abajo, y mas a la izquierda SOLO EN CASO DE QUE EXISTE POSIBILIDAD DE ESTAR HUNDIDO}
    begin
        esPosibleHundido := false; {Se parte de la premisa de que a dos niveles por encima, debajo, izq o derecha, no hay ningun 'x'}
		if((fil < 9) and (matrizJugador[fil+2][col] = 'X' ) and (matrizOriginal[fil+2][col] = letrabarco) ) then begin
			esPosibleHundido := true; 
			contadorX := contadorX +1;  
		end;
		if((fil > 2) and (matrizJugador[fil-2][col] = 'X' )and (matrizOriginal[fil-2][col] = letrabarco) ) then begin
			esPosibleHundido := true; 
			contadorX := contadorX +1;  
		end;
		if((col < 'I') and (matrizJugador[fil][succ(succ(col))] = 'X' ) and  (matrizOriginal[fil][succ(succ(col))] = letrabarco)) then begin
			esPosibleHundido := true; 
			contadorX := contadorX +1;  
		end;
		if((col > 'B') and (matrizJugador[fil][pred(pred(col))] = 'X' )and (matrizOriginal[fil][pred(pred(col))] = letrabarco) ) then begin
			esPosibleHundido := true; 
			contadorX := contadorX +1;  
		end;
		{En este punto sabemos que si dos posiciones consecutivas a la izq, der, arriba, abajo tienen X que contrastada con matriz original hacen alusion a un mismo tipo de barco, entonces:
		*  se puede afirmar que en caso de que ese tipo de barco sea dragaminas, lo damos por hundido}
		if((letraBarco = 'D') and (esPosibleHundido)) or((letraBarco = 'P') and esPosibleHundido and (contadorX = 3)) then begin
			hundido := true; 
		end
		else if (letraBarco ='P') and esPosibleHundido then begin {En este punto el barco es un poortaviones si y en caso de que exista posibilidad significa que sus dos posiciones colindantes estan con X por lo que hace falta buscar en las 3 posiciones mas atras}
			if((fil < 8) and (matrizJugador[fil+3][col] = 'X' ) and (matrizOriginal[fil+3][col] = letrabarco) ) then begin
				hundido := true; 
				contadorX := contadorX +1;  
			end;
			if((fil > 3) and (matrizJugador[fil-3][col] = 'X' )and (matrizOriginal[fil-3][col] = letrabarco) ) then begin
				hundido := true;  
				contadorX := contadorX +1;  
			end;
			if((col < 'H') and (matrizJugador[fil][succ(succ(succ(col)))] = 'X' ) and  (matrizOriginal[fil][succ(succ(succ(col)))] = letrabarco)) then begin
				hundido := true; 
				contadorX := contadorX +1;  
			end;
			if((col > 'C') and (matrizJugador[fil][pred(pred(pred(col)))] = 'X' )and (matrizOriginal[fil][pred(pred(pred(col)))] = letrabarco) ) then begin
				hundido := true; 
				contadorX := contadorX +1;  
			end;	
		end; 
    end; 
    
    
	entornoCoordenadaHundido := hundido; 
end; 


procedure analizarAtaque(var coordenada:tipoCoordenada; var matrizJugador:tipoMatrizLetras; matrizOriginal:tipoMatrizLetras; var registroDisparos: tipoRegistroDisparos; contadorDisparos:integer ); 
begin
    if (matrizJugador[coordenada.num_fila][coordenada.letra_colum] = '.') then begin
		matrizJugador[coordenada.num_fila][coordenada.letra_colum] := ',';
		registroDisparos[contadorDisparos].resultado := Agua; 
	end
	else if(matrizJugador[coordenada.num_fila][coordenada.letra_colum] = 'S') then begin {CASO ATAQUE SOBRE SUBMARINO}
	    matrizJugador[coordenada.num_fila][coordenada.letra_colum] := 'X';
		registroDisparos[contadorDisparos].resultado := Hundido; 
    end
    else if(matrizJugador[coordenada.num_fila][coordenada.letra_colum] = 'F') then begin {CASO ES QUE SE HAYA ATACADO SOBRE UNA FRAGATA}
        matrizJugador[coordenada.num_fila][coordenada.letra_colum] := 'X';
        if(entornoCoordenadaHundido('F', coordenada,matrizJugador,matrizOriginal)) then begin
           registroDisparos[contadorDisparos].resultado := Hundido; 
        end 
        else begin
           registroDisparos[contadorDisparos].resultado := Tocado; 
        end; 
		
    end
    else if(matrizJugador[coordenada.num_fila][coordenada.letra_colum] = 'D') then begin
		matrizJugador[coordenada.num_fila][coordenada.letra_colum] := 'X';
        if(entornoCoordenadaHundido('D', coordenada,matrizJugador,matrizOriginal)) then begin
           registroDisparos[contadorDisparos].resultado := Hundido; 
        end 
        else begin
           registroDisparos[contadorDisparos].resultado := Tocado; 
        end; 
    end 
    else if(matrizJugador[coordenada.num_fila][coordenada.letra_colum] = 'P') then begin
		matrizJugador[coordenada.num_fila][coordenada.letra_colum] := 'X';
        if(entornoCoordenadaHundido('P', coordenada,matrizJugador,matrizOriginal)) then begin
           registroDisparos[contadorDisparos].resultado := Hundido; 
        end 
        else begin
           registroDisparos[contadorDisparos].resultado := Tocado; 
        end; 
    end 
    else begin
		registroDisparos[contadorDisparos].resultado := Disparo_Repetido; 
    end; 
end; 

procedure imprimirEstadoTablero(var matrizBase:tipoMatrizLetras);
var
	fila : integer; 
	columna: char; 
begin
    writeln('A B C D E F G H I J');
	for fila := 1 to numFilas do begin
		for columna := 'A' to ultimaColumna do begin
		    write(matrizBase[fila][columna], ' '); 
			if(columna = 'J') then begin
				writeln(fila);
			end; 
		end; 

	end; 
end;  

function jugadorGana(matrizCopia:tipoMatrizLetras): boolean; 
var
	f: integer; 
	c: char; 
	ganador: boolean; 
begin
    ganador := true; 
	for f := 1 to numFilas do begin
		for c := 'A' to ultimaColumna do
		begin
			if(matrizCopia[f][c] <> ',') and (matrizCopia[f][c] <> 'X') and (matrizCopia[f][c] <> '.') then begin
				ganador := false; 
			end; 
		end; 
	end; 
	jugadorGana := ganador; 
end; 


procedure imprimirTabla(var listaBarcos: tipoListaBarcos; var matrizBarcos: tipoMatrizLetras; var matrizCopiaBarcos:tipoMatrizLetras);
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
				pintaBarquitoEnCoordenada(fila,columna,listaBarcos,matrizBarcos ,matrizCopiaBarcos);
			end;
			writeln(fila);  
		end;
	end; 
var
   listaBarcosJ1, listaBarcosJ2: tipoListaBarcos; 
   entrada: text; {Declaracion de variable entrada de tipo texto}
   error: boolean; 
   finEncontrado: boolean; 
   jugadorActual: integer; 
   matrizOriginalJ1, matrizOriginalJ2,matrizCopiaJ1,matrizCopiaJ2: tipoMatrizLetras;   {en el enunciado no se restringue almacenar en formato matriz los barcos, ademas se duplican matrices, una se ira modificando otra preservara datos originales}
   coordenada: tipoCoordenada; 
   contadorDisparos: integer; 
   registroDisparos: tipoRegistroDisparos; 
   indice: integer; 
   ganador:integer; 
begin
   finEncontrado := False;  
   assign(entrada, 'datos.txt');
   reset(entrada);
   listaBarcosJ1 := nil; 
   error := False; 
   ganador:=-1; 
   {Se recogen datos del jugador uno}
   while( not eof(entrada)) and(not error) and (not finEncontrado) do begin
      procesarEntrada(listaBarcosJ1, entrada,error,finEncontrado); 
      writeln('Jugador 1'); 
      imprimirTabla(listaBarcosJ1,matrizOriginalJ1,matrizCopiaJ1);  {SE utilizan dos matrices una con datos originales y otra con una copia (la que se va a editar)
      }
   end;
   finEncontrado := False; 
   {Se recogen datos del jugador dos}
   while( not eof(entrada)) and(not error) and (not finEncontrado) do begin
      procesarEntrada(listaBarcosJ2, entrada,error,finEncontrado);
      writeln('Jugador 2');  
      imprimirTabla(listaBarcosJ2,matrizOriginalJ2,matrizCopiaJ2);  
   end; 

   jugadorActual := 1; 
   {Empieza a leerse la jugada}
   contadorDisparos := 1; 
   while(not eof(entrada) and (contadorDisparos < 1000) and (ganador = -1)) do begin
      registroDisparos[contadorDisparos].jugador := jugadorActual ; 
	  if(jugadorActual = 1) then begin
	      procesarLanzamiento(entrada,coordenada);
	      registroDisparos[contadorDisparos].coordenada.num_fila := coordenada.num_fila; 
	      registroDisparos[contadorDisparos].coordenada.letra_colum := coordenada.letra_colum; 
	      analizarAtaque(coordenada, matrizCopiaJ2,matrizOriginalJ2,registroDisparos,contadorDisparos ); 
	      jugadorActual := 2;  //Se marca como siguiente jugada la del jugador 2
	      write('Disparo al jugador ', (registroDisparos[contadorDisparos].jugador mod 2)+1, ': ',registroDisparos[contadorDisparos].coordenada.letra_colum, registroDisparos[contadorDisparos].coordenada.num_fila); 
	      writeln(' ',registroDisparos[contadorDisparos].resultado); 
	      imprimirEstadoTablero(matrizCopiaJ2); 
	      contadorDisparos:=contadorDisparos+1; 
	  end
	  else begin
	     procesarLanzamiento(entrada,coordenada); 
	     registroDisparos[contadorDisparos].coordenada.num_fila := coordenada.num_fila; 
	     registroDisparos[contadorDisparos].coordenada.letra_colum := coordenada.letra_colum; 
	     analizarAtaque(coordenada, matrizCopiaJ1,matrizOriginalJ1,registroDisparos,contadorDisparos ); 
	     jugadorActual := 1; //Se marca como siguiente jugada la del jugador 1
		 write('Disparo al jugador ', (registroDisparos[contadorDisparos].jugador mod 2)+1, ': ',registroDisparos[contadorDisparos].coordenada.letra_colum, registroDisparos[contadorDisparos].coordenada.num_fila); 
		 writeln(' ',registroDisparos[contadorDisparos].resultado); 
	     imprimirEstadoTablero(matrizCopiaJ1);
	     contadorDisparos:=contadorDisparos+1; 
	  end; 
      if(jugadorGana(matrizCopiaJ1)) then begin
		ganador := 1;  
	  end 
	  else if jugadorGana(matrizCopiaJ2) then begin
	   ganador := 2; 
	  end; 
   end; 
   	  writeln();
	  for indice := 1 to (contadorDisparos-1) do begin
		write('Jugador ',registroDisparos[indice].jugador,': ' ); 
		write(registroDisparos[indice].coordenada.letra_colum,registroDisparos[indice].coordenada.num_fila, ' '); 
		writeln(registroDisparos[indice].resultado); 
	  end;
	  if(ganador = -1) then begin
		write('empate'); 
	  end 
	  else begin
	    write('Gana el jugador ', ganador); 
	  end; 

end.
