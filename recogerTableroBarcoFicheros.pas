program hundirLaFlotaConFicheros; 
const 
	Num_max_barcos = 100; {numero maximo de barcos (100 submarinos)}
	LongStr = 12; {palabra mas larga es portaaviones, por ende, logintud maxima 12}
	ultimaColumna = 'J'; 
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
        
   TipoStr = record
		cars: string[LongStr];
		ncars: integer;
	end;   
        
     
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
procedure fatal(msg: string);
	begin
	   writeln('error fatal: ', msg);
	   halt(1);
	end;

procedure appcar(var str: TipoStr; c: char);
	begin
		if str.ncars = LongStr then begin
			fatal('appcar: demasiados');
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
	if (barco.coordenada.letra_colum > 'J') or (barco.coordenada.num_fila > 10) then begin 
		resultado := True; 
	end 
	else begin
		resultado := False; 
		{aqui se puede optar por comprobar dependiendo del tipo de barco si se sale del tablero por la izquierda o por abajo cuando se inserta el barco e incluso comprobar si no se ha puesto otro barco previamente}
		{Por cuestiones de tiempo se ha decidido no implementar esta parte tan compleja}
	end; 
	coordenadaErronea := resultado;
	
	 
end;  

function procesarEntrada(var listaBarcos: tipoListaBarcos; var entrada:text; var error:boolean): tipoListaBarcos; 
var
    existePalabra: boolean;  
	caracterActual: char;
	palabraActual: tipoStr; 
    finEncontrado:boolean; 
    nuevoBarco: tipoBarco; 
    seEsperaNombreBarco, seEsperaColumna, seEsperaFila,seEsperaOrientacion:boolean; {variables para controlar que es lo que se espera encontrar}
    descartarBarco, barcoCorrecto:boolean; 
begin
     finEncontrado := false; 
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
         if(descartarBarco) then begin 
             seEsperaNombreBarco := True; 
             seEsperaColumna := False; 
             seEsperaFila := False; 
             seEsperaOrientacion := False; 
             write('Se descarta el barco de tipo ', nuevoBarco.claseBarco, ' por no estar bien posicionado con la coordenada', nuevoBarco.coordenada.letra_colum,nuevoBarco.coordenada.num_fila); 
         end;   
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
				writeln('Se analiza la palabra: ', palabraActual.cars);
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
				    else begin
						write('Error en la lectura de la coordenada, se ha leido una palabra de mas de 2 caracteres, cuando una coordenada puede tener maximo 2 caracteres.');
						error := True; 
				    end;  
				end 
				else if(seEsperaFila) then begin
					nuevoBarco.coordenada.num_fila := ord(palabraActual.cars[1])-48; 
					seEsperaFila := False;
				    seEsperaOrientacion := True;  
				end
				else if(seEsperaOrientacion) then begin
				    {Cuando se espera la orientacion es que ya se ha procesado la coordenada independientemente de si se intercepto como separada o unida (A    3) o (A3)}
				    if(coordenadaErronea(nuevoBarco))then begin
						descartarBarco := True; 
				    end; 
					if(sonIgualesLasPalabras(palabraActual, 'Horizontal')) then begin  nuevoBarco.orientacion := Horizontal ; barcoCorrecto := True;  end
					else if (sonIgualesLasPalabras(palabraActual, 'Vertical'))then begin  nuevoBarco.orientacion := Vertical ; barcoCorrecto := True;  end
					else begin writeln('Error al leer la orientacion del barco' ); error := True; end; 
				end; 
				if(barcoCorrecto) then begin
					writeln('BARCO LEIDO CORRECTO ----'); 
					agregarBarcoALista( nuevoBarco, listaBarcos);
					seEsperaNombreBarco := True;
					barcoCorrecto := False; 
					descartarBarco := False;  
				end;
			end;  
		 end;
     end;   
     procesarEntrada := listaBarcos; 
end; 

procedure imprimirBarcos(listaBarcos: tipoListaBarcos);
begin
    if(listaBarcos = nil) then begin
		write('No se ha insertado ningun barco');
	end 
	else begin
		while(listaBarcos <> nil) do begin
		    writeln('Barco numero: ', listaBarcos^.indice, ' Tipo barco: ' ,listaBarcos^.barco.claseBarco, ' Coordenada: ',listaBarcos^.barco.coordenada.letra_colum,listaBarcos^.barco.coordenada.num_fila, ' Orientacion: ', listaBarcos^.barco.orientacion);
		    listaBarcos := listaBarcos^.siguienteBarco; 
		end;  
	end; 
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

procedure pintaBarquitoEnCoordenada(fila:integer;columna:char; listaBarcos:tipoListaBarcos);
var 
	barcoActual: tipoBarco; 
	impresion:char; 
begin
     if(listaBarcos = nil) then begin
         write('.'); 
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
	     write(impresion,' '); 
	    
     end;  
end; 



procedure imprimirTabla(var listaBarcos: tipoListaBarcos);
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
				pintaBarquitoEnCoordenada(fila,columna,listaBarcos);
			end;
			writeln(fila);  
		end;
	end; 
var
   listaBarcos: tipoListaBarcos; 
   entrada: text; {Declaracion de variable entrada de tipo texto}
   error: boolean; 
   contadorJugadores: integer; 
begin
   contadorJugadores := 1; 
   assign(entrada, 'datos.txt');
   reset(entrada);
   listaBarcos := nil; 
   error := False; 
   while( not eof(entrada)) and(not error) do begin
       listaBarcos := vaciarLista(listaBarcos); 
       procesarEntrada(listaBarcos, entrada, error);
       writeln('============= LISTADO DE BARCOS DEL JUGADOR NUMERO ',contadorJugadores ,' =============');
       imprimirBarcos(listaBarcos);
       writeln('============= TABLA DEL JUGADOR ===================');
       imprimirTabla(listaBarcos); 
       writeln('=============FIN DE PROCESAMIENTO DE JUGADOR NUMERO ',contadorJugadores ,' =============');  
       contadorJugadores := contadorJugadores +1 ; 
          
   end; 
end.
