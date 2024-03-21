Anton Stefan, 331CC

                    Conversie Latex to MD, TEMA1 LFA

Tema consta in conversia din comenzi latex in formatul mark down,
utilizand lex.

Durata implementare:
~20 ore, a durat mai mult faimiliarizarea cu limbajul 

Sunt in total 5 teste, 0,1,2 corespunzand exemplului si 3 si 4 implementate
de mine

EX RULARE:
make clean && make && make run0


Detalii implementare:
La inceput avem headerele necesare c++ si niste procesari, am folosit 
stari de stiva pentru imbricari la itemize si enumerate, si functia
quatation care afiseaza textul prelucrat cu 10 cuvinte maxim pe linie.

Dupa urmeaza starile, x pentru stari exclusive si s pentru stari inclusive.
Am declarat in mare o stare pentru fiecare comanda in latex.

Am definit doua regexuri, una pentru caracterele de nume, si una pentru textul
in clar pe care il aveam de afisat care nu ii corespunde niciunei 
comenzi.

Dupa apar regulile dupa care se fac match. Incepem cu title, daca se 
gaseste \title{ intra in starea TITLE, adaugam '\0' in locul acoladei
inchise, si dupa afisam conform, trecand in final inapoi in starea INITIAL

Am facut asemanator si pentru starea section, numai ca am verificat 
sa inceapa cu sub si sa se termine cu section, pentru subsectii

Tipurile de texte, sunt implementate direct pe structura de itemize
si cleartext, textele sunt incadrate conform tipului de text, ori inte _text_
ori `text` ...

Quatation, care se converteste la un blockquote cu maxim 10 cuvinte pe 
linie, si sunt precedate de >, am folosit o functie in c++ pentru a respecta
afisarea de maxim 10 cuvinte pe linie

Itemize si enumerate sunt implementate cu stari de stiva pentru a 
asigura functionalitatea de imbricare.
Dam push si pop dupa cum e necesar starii curente, de asemenea e si verificat
la itemize daca are text de un anumit tip(ex:italic) si daca are
da push pe starea data(ex: push(TEXTITALIC)) dupa revenind inapoi prin pop la itemize
pentru a continua itemizul

Href, transforma un link intre {link}{text} in [link](text)

Pentru orice alta comanda nu se va afisa nimic, adica daca avem
doar \\ si nu a matchuit o regula nu va afisa nimic.

Tot ce incepe cu % am pus sa nu fie scris, adica cand gasesc % dau linie noua.

Pentru textul care trebuie afisat normal ca 'CLEAR TEXT' cum il numi eu) care nu
se afla in nicio regula, doar il afisez cand gasesc daca e de tipul CLEAR.


Textul continut intre acolade de exemplu in cadrul author{} verific cand 
incepe author{ intru ma duc in starea BRACE_IGNORE_CLEARTEXT si pana 
gasesc a doua acolada care se inchide } nu afisez nimic.

Si am mai adaugat reguli implicite end start document sau end article ...
care daca gasesc secventa aia pur si simplu le evita cu {}


