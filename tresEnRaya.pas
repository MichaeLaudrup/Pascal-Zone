program tresEnRaya2; 
const 
	LongStr = 10; {Movimiento es una palabra de 10 caracteres y ninguna palabra puede exceder esa longitud}
	Tab: char = ' '; 
	simboloJugador1 = 'x'; 
	simboloJugador2 = 'o'; 
	NumMaxPartidas = 9; 
type
	TipoStr = record
		cars: string[LongStr];
		ncars: integer;
	end;
	tipoColumna = array['A'..'C'] of char; 
	tipoTablero = array[1..3] of tipoColumna; 

procedure vaciarstr(var str: TipoStr);
begin
	str.ncars := 0;
	str.cars := '          '; 	
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
	read(entrada,caracterActual);
	existePalabra := not esblanco(caracterActual);
end; 

procedure procesarPalabra(var palabraActual: tipoStr; numJugador: integer; var seEsperaPalabraMovimiento:boolean; var tableroPartida:tipoTablero ); 
var
	caracterAsociadoJugador: char; 
	segundaCoordenada: char; 
	coordenadaNumero: integer; 
begin 
	if(palabraActual.cars = 'Movimiento') then begin
		seEsperaPalabraMovimiento := False; 
	end
	else begin
		if(palabraActual.ncars = 2) then begin 
		    seEsperaPalabraMovimiento := True;
		    if numJugador = 1 then begin
				caracterAsociadoJugador := 'x';
			end
			else begin
				caracterAsociadoJugador := 'o'; 
			end; 
			segundaCoordenada := palabraActual.cars[2]; 	
			if segundaCoordenada = '1' then begin
				coordenadaNumero := 1; 
			end
			else if segundaCoordenada = '2' then begin
				coordenadaNumero := 2; 
			end
			else begin
				coordenadaNumero := 3; 
			end;   
		    tableroPartida[coordenadaNumero][palabraActual.cars[1]] := caracterAsociadoJugador; 
		end; 
	end; 
end; 
procedure procesarPartida(var entrada:text; var tablero: tipoTablero); 
	var 
		numMovimientos: integer;
		existePalabra: boolean;  
		caracterActual: char;
		palabraActual: tipoStr; 
		numJugador: integer; 
		seEsperaPalabraMovimiento: boolean; 
	begin
		numMovimientos:= 0; 
		numJugador := 1; 
		existePalabra := False; 
		seEsperaPalabraMovimiento := True; {Inicialmente se espera la palabra movimiento}
		while(not eoln(entrada)) and (numMovimientos < 9) do begin
		    vaciarstr(palabraActual); 
			while(not existePalabra) do begin {Estara dando vueltas hasta que encuentre un caracter diferente a un espacio en blanco}
				ignorarEspaciosEnBlanco(entrada, caracterActual, existePalabra); 
			end; 
			while(existePalabra) do begin
			    appcar(palabraActual, caracterActual); 
				if eoln(entrada) then begin
					existePalabra := False; 
				end
				else begin
					read(entrada, caracterActual);
				    existePalabra := not esblanco(caracterActual); 
				end;
				if (not existePalabra) then begin 
					procesarPalabra(palabraActual, numJugador, seEsperaPalabraMovimiento, tablero ); 
					if(seEsperaPalabraMovimiento) then begin {Si se espera la palabra movimiento es que ya el jugador anterior introdujo la coordenada de su movimiento }
						numJugador := ((numJugador mod 2) + 1);
						numMovimientos:= numMovimientos + 1; 
					end;  
				end;  
			end; 
            
		end;
	end; 

procedure limpiarTablero(var tablero: tipoTablero); 
var
	colum: char; 
	fila: integer; 
begin
	for fila := 1 to 3 do begin
		for colum := 'A' to 'C' do begin
			tablero[fila][colum] := '.'; 
		end; 
	end; 
end; 


procedure imprimirTablero(var tablero: tipoTablero); 
var
	colum: char; 
	fila: integer; 
begin
    writeln('A   B   C');
	for fila := 1 to 3 do begin
		for colum := 'A' to 'C' do begin
			write(tablero[fila][colum], ' | ' );
		end; 
		writeln(fila); 
	end; 
	writeln(); 
end; 




function ganaJugadorConSimbolo(simbolo_jugador:char;  tablero: tipoTablero): boolean;
var
	fila: integer; 
	columna: char; 
	cuenta: integer; 
	resultado : boolean; 
begin
    cuenta := 0; 
    resultado := False; 
	{Comprobacion tres en raya en filas horizontales}
	for fila := 1 to 3 do begin
	    for columna := 'A' to 'C' do begin
           
			if(tablero[fila][columna] = simbolo_jugador) then begin
				cuenta := cuenta +1; 		
				if(cuenta = 3) then begin
					resultado := True; 
				end; 
			end;
	    end; 
	    cuenta := 0; 
	end;
	{Comprobacion 3 en raya en columnas verticales}
	for columna := 'A' to 'C' do begin
	    for fila := 1 to 3 do begin
			if(tablero[fila][columna] = simbolo_jugador) then begin
				cuenta := cuenta +1; 
				if(cuenta = 3) then begin
					resultado := True; 
				end; 
			end; 
	    end; 
	    cuenta := 0; 
	end;
	{Comprobacion 3 en raya en diagonales}
	
	if ((tablero[1]['A'] = simbolo_jugador) and (tablero[2]['B'] = simbolo_jugador) and (tablero[3]['C'] = simbolo_jugador)) then begin
		resultado := True; 
	end 
	else if ((tablero[1]['C'] = simbolo_jugador) and (tablero[2]['B'] = simbolo_jugador) and (tablero[3]['A'] = simbolo_jugador)) then begin
		resultado := True; 
	end 
	else begin
		resultado := False or resultado; {Se tiene en cuenta el resultado previo} 
	end; 
	ganaJugadorConSimbolo := resultado; 
end; 

procedure determinaGanador(var tablero: tipoTablero; var nVictoriasJ1: integer; var nVictoriasJ2:integer; var numPartida:integer); 
var
	ganaJugador1, ganaJugador2: boolean; 
begin
	ganaJugador1 := ganaJugadorConSimbolo('x', tablero); 
	ganaJugador2 := ganaJugadorConSimbolo('o', tablero);
    if(ganaJugador1) then begin
		nVictoriasJ1 := nVictoriasJ1 +1; 
		writeln('Partida ', numPartida, ': Gana jugador 1' );
    end
    else if(ganaJugador2) then begin
		nVictoriasJ2 := nVictoriasJ2 +1; 
		writeln('Partida ', numPartida, ': Gana jugador 2' );
    end
    else begin
		writeln('Partida ', numPartida, ': Empate' );
    end;  
end;

procedure imprimeMovimientosJugadorConSimbolo(simbolo_jugador:char; tablero:tipoTablero); 
var
    fila: integer; 
    columna: char; 
begin
	for fila := 0 to 3 do begin
		for columna := 'A' to 'C' do begin
			if(tablero[fila][columna] = simbolo_jugador) then begin
				write(columna,fila, ' ' ); 
			end; 
		end; 
	end; 
end; 
procedure mostrarMovimientosPartida(tablero: tipoTablero; numPartida:integer);
begin
	write('Partida ', numPartida, ': Jugador 1: '); 
	imprimeMovimientosJugadorConSimbolo('x', tablero); 
	write('- Jugador 2: '); 
	imprimeMovimientosJugadorConSimbolo('o', tablero);
	writeln();  
	
end;  
var 
	entrada: text; {Declaracion de variable entrada de tipo texto}
	tablero: tipoTablero; 
	numPartida: integer; 
	nVictoriasJ1, nVictoriasJ2: integer; 
begin
	numPartida:= 1; 
	assign(entrada, 'datos.txt');
	reset(entrada);
	while( not eof(entrada)) do begin
	    limpiarTablero(tablero); 
		procesarPartida(entrada, tablero); 
		determinaGanador(tablero, nVictoriasJ1, nVictoriasJ2, numPartida); 
	    imprimirTablero(tablero);
		mostrarMovimientosPartida(tablero, numPartida); 
		writeln('Jugador 1: ', nVictoriasJ1, ' victorias.');
		writeln('Jugador 2: ', nVictoriasJ2, ' victorias.'); 
		writeln('============ FIN PARTIDA ============='); 
		numPartida := numPartida+1;
		readln(entrada); 
	end; 
	 
end. 
