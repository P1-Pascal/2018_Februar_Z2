program Z2(kursnaLista, ponude);

type
 Kurs = record
 valuta : string[3];
 vrednost : real;
 end;
 PElement = ^Element;
 Element = record
 podaci : Kurs;
 sledeci : PElement;
 end;
 Ponuda = record
 imeProdavnice : string;
 cena : real;
 valuta : string[3];
 end;
 
var
 kursnaLista : file of Kurs;
 ponude : text;
 lista, novi, stari, tekuci : PElement;
 tekucaPonuda, maxPonuda, minPonuda : Ponuda;
 prvi : boolean;
 c : char;
 
begin
 assign(kursnaLista, 'kursnalista.dat');
 reset(kursnaLista);
 lista := nil;
 while (not eof(kursnaLista)) do begin
 new(novi);
 read(kursnaLista, novi^.podaci);
 novi^.sledeci := lista;
 lista := novi;
 end;
 close(kursnaLista);
 assign(ponude, 'prodavnice.txt');
 reset(ponude);
 prvi := true;
 while (not eof(ponude)) do begin
 tekucaPonuda.imeProdavnice := '';
 read(ponude, c);
 while(c <> ' ') do begin
 tekucaPonuda.imeProdavnice := tekucaPonuda.imeProdavnice + c;
 read(ponude, c);
 end;
 readln(ponude, tekucaPonuda.cena, c, tekucaPonuda.valuta);
 tekuci := lista;
 while (tekuci^.podaci.valuta <> tekucaPonuda.valuta) do begin
 tekuci := tekuci^.sledeci;
 end;
 tekucaPonuda.cena := tekucaPonuda.cena *
tekuci^.podaci.vrednost;
 if (prvi) then begin
 prvi := false;
 maxPonuda := tekucaPonuda;
 minPonuda := tekucaPonuda;
 end else begin
 if (tekucaPonuda.cena > maxPonuda.cena) then begin
 maxPonuda := tekucaPonuda;
 end else if (tekucaPonuda.cena < minPonuda.cena) then begin
 minPonuda := tekucaPonuda;
 end;
 end;
 end;
 close(ponude);
 writeln('Najjeftinija: ', minPonuda.imeProdavnice,
minPonuda.cena);
 writeln('Najskuplja: ', maxPonuda.imeProdavnice, maxPonuda.cena);
 writeln('Raspon: ', maxPonuda.cena - minPonuda.cena);
 while (lista <> nil) do begin
 stari := lista;
 lista := lista^.sledeci;
 dispose(stari);
 end;
end.