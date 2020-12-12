program tresEnRaya;
uses sysutils;
const 
	LongStr = 10; {Movimiento es una palabra de 10 caracteres y ninguna palabra puede exceder esa longitud}
	Tab: char = ' '; 
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

function esblanco(c: char): boolean;
begin
    esblanco := (c = ' ') or (c = Tab);
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

procedure procesarNuevaPalabra(var palabraActual:TipoStr;  var tablero: tipoTablero; var numJugadas:integer ; var siguienteEsCoordenada:boolean); 
 var
 indice: integer; 
begin
	write('Palabra nueva: ');
	for indice := 1 to palabraActual.ncars do begin
		write(palabraActual.cars[indice]);
	end; 
	if(palabraActual.cars = 'Movimiento') and (not siguienteEsCoordenada) then
	begin
		siguienteEsCoordenada := True; 
	end
	else begin
		numJugadas := numJugadas +1; 
		siguienteEsCoordenada := False; 
	end; 
	writeln();
	writeln('Numero de jugadas: ', numJugadas);
	writeln(palabraActual.cars);
end; 

procedure leerPalabras(var entrada:text; var numJugadas: integer; var tablero:TipoTablero);
	var
	caracterActual: char; 
	hayPalabra: boolean; 
	palabraActual : TipoStr;   
	seEsperaCoordenada: boolean; 
	nPartidas: integer; 
begin
	haypalabra := false;
	seEsperaCoordenada := false;  
	while(not eof(entrada)) and (numJugadas < 9) do begin {Mientras no se encuentre un final de archivo  o se hayan realizado 9 jugadas estara buscado espacios en blancos o caracteres propios de una palabra}
		vaciarstr(palabraActual);
		
		while(not eof(entrada)) and (not hayPalabra) do begin {Mientras no se dejen de encontrar espacios en blanco este bucle ira dando vueltas hasta encontrar un caracter o un fin de archivo}
			if eoln(entrada) then begin {Si se encuentra un salto de linea se pasa a la siguiente linea}
				nPartidas := nPartidas + 1; 
				readln(entrada);
			end
			else begin 
				read(entrada,caracterActual);
				haypalabra := not esblanco(caracterActual);
			end;
		end;
		while haypalabra do begin
			appcar(palabraActual, caracterActual); {Se inserta el nuevo caracter a la palabra y se incrementa en una unidad el numero de caracteres}
			if eof(entrada) or eoln(entrada) then begin
				haypalabra := false;
			end
			else begin
				read(entrada, caracterActual);
				haypalabra := not esblanco(caracterActual); 
			end;
			if(haypalabra = False) then begin {Solo se puede entrar a este punto si no hay mas caracteres y se acaba la palabra}
				procesarNuevaPalabra(palabraActual, tablero, numJugadas, seEsperaCoordenada); 
			end;  
		end;
	end; 
end; 


var 
	entrada: text; {Declaracion de variable entrada de tipo texto}
	tablero: TipoTablero; 
	numJugadas : integer;  
begin
	numJugadas := 0; 
	assign(entrada, 'datos.txt');
	reset(entrada);
	leerPalabras(entrada,numJugadas, tablero); 
	 
end. 
