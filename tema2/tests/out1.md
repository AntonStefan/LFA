Conversie
===========


Descrierea problemei
-----------
 Se dă un fișier  LaTeX care trebuie transformat în fișier Markdown [https://en.wikipedia.org/wiki/Markdown](Markdown) , după regulile prezentate mai jos. Code test `here`.
    
    for i:=maxint to 0 do
    begin
    { do nothing }
    end;
    Write('Case insensitive ');
    Write('Pascal keywords.');

**Atenție!** Există numeroase arome (_flavors_) de markdown. Vom utiliza în mod **exclusiv** specificațiile din specificația originală de markdown, chiar dacă nu vom utiliza _toate_ aceste specificații.Se vor transforma următoarele elemente: 												
   - titlul documentului -- argument al comenzii `title` -- se convertește în titlu Markdown cu subliniere dublă (se vor folosi 10 simboluri `=` indiferent de lungimea titlului)	
   -  orice titlu de secțiune -- argument al unei comenzi de forma `*section` -- se convertește în titlu Markdown cu subliniere simplă (se vor folosi 10 simboluri `-` indiferent de lungimea titlului)	
   -  comanda `quotation` se onvertește la un _blockquote_. În formatul `.md` se vor pune maxim 10 cuvinte pe linie.	
   -  comenzile 
   - `textbf`,		
   -  `textit`,		
   -  `emph`,		
   -  `texttt`		
		se vor converti, respectiv, la formatări de tip 		
   - _bold_, 		
   -  _emphasis_, 		
   -  _emphasis_ 		
   -  și cod.		
		
   -  conținutul dintr-un mediu `verbatim` se convertește într-un bloc de cod. 	
   -  comentariile \LaTeX nu vor apărea la ieșire.	
   -  pentru orice alt mediu, la fel ca și pentru orice bloc, directivele de început și de sfârșit vor fi ignorate și conținutul lor se va afișa, prelucrat conform regulilor enunșate.	


	1.  One
		
		1.  Two
		1.  Three
		1.  Stay with me
	
	1.  Four
	1.  Five Six Seven Ate Nine


> This is a blockquote with two paragraphs. Lorem ipsum dolor 
> sit amet, consectetuer adipiscing elit. Aliquam hendrerit mi posuere lectus. 
> Vestibulum enim wisi, viverra nec, fringilla in, laoreet vitae, risus. 
> Donec sit amet nisl. Aliquam semper ipsum sit amet velit. 
> Suspendisse id sem consectetuer libero luctus adipiscing. 

 Cam atât.