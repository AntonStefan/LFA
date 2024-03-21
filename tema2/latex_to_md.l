/* Anton Stefan, 331CC */

%{
#include <iostream>
#include <sstream>
#include <vector>
#include <stack>
#include <string>
using namespace std;

stack<int> stateStack; // Stivă pentru a ține evidența stărilor


void printQuotationLine(const vector<string>& words) {
    cout << "> ";
    for (const auto& word : words) {
        cout << word << " ";
    }
    cout << "\n";   
}


void pushState(int newState) {
    stateStack.push(YY_START); // Salvează starea curentă în stivă
    BEGIN(newState); // Schimbă la noua stare
}

void popState() {
    if (!stateStack.empty()) {
        BEGIN(stateStack.top()); // Revenire la starea anterioară
        stateStack.pop();
    }
}



// Variabilă pentru a reține fiecare linie din blocul verbatim
string verbatimLine;

int braceCount;
string href_url;
string href_text;



string normalTextBuffer = ""; // Buffer pentru textul normal


%}


%option noyywrap

/* Stari x exclusive state (numai regulile definite pentru acea stare sunt active) / s inclusive(start) state*/
%s TITLE
%s SECTION
%s QUOTATION
%s CLEARTEXT
%x SUBSECTION
%s VERBATIM
%x ENUMERATE
%x ENUMITEM
%s ITEMIZE
%s ITEM
%s TEXTITALIC
%s TEXTTYPEDTEXT
%s TEXTBOLD
%x HREF_URL
%x HREF_TEXT
%x BRACE_IGNORE
%s HREF_TEXT_CONTENT
%s BRACE_IGNORE_CLEARTEXT


/* Expresii regulate - regex */
NAME [a-zA-Zț! -:]+
CLEAR [^\n\\%]+

%%
 /* Ignoră comenzi specifice LaTeX */
"\\documentclass{article}" {}
"\\begin{document}" {
}
"\\end{document}" {}


 /* TITLE */

"\\title{" {
    BEGIN(TITLE);
}

<TITLE>"{" { /* Ignore opening brace */ }

<TITLE>{NAME}"}" {
    yytext[yyleng -1] = '\0';
    cout << yytext  << "\n===========" << endl;
    BEGIN(INITIAL);
}


 /* SECTION */
"\\sub" { BEGIN(SUBSECTION); } // Când întâlnim "\\sub", schimbăm starea

"\\subsub" { BEGIN(SUBSECTION); }

"\\sub+section{" {
    BEGIN(SECTION);
} 

"\\section{" {
    BEGIN(SECTION);
} 

<SUBSECTION>"section{" {
    BEGIN(SECTION);
} 

<SECTION>"{" { /* Ignore opening brace */ }

<SECTION>{NAME}"}" { 
    yytext[yyleng -1] = '\0';
    cout <<"\n"<< yytext << "\n-----------" << endl; 
    BEGIN(INITIAL); }



 /* TYPES OF TEXTS */

 /*
"\\textit{" {
    cout << "_";
    BEGIN(TEXTITALIC);
}

<TEXTITALIC>"}" {
    cout << "_";
    BEGIN(INITIAL);
}

<TEXTITALIC>.|\n {
    cout << yytext;
}


"\\texttt{" {
    cout << "`";
    BEGIN(TEXTTYPEDTEXT);
}

<TEXTTYPEDTEXT>"}" {
    cout << "`";
    BEGIN(INITIAL);     // ITEMIZE?
}

<TEXTTYPEDTEXT>.|\n {
    //yytext[yyleng] = '\0';
    cout << yytext;
}


"\\textbf{" {
    cout << "**";
    BEGIN(TEXTBOLD);
}

<TEXTBOLD>"}" {
    cout << "**";
    BEGIN(INITIAL);
}

<TEXTBOLD>.|\n {
    cout << yytext;
}
 */


 /* QUTATIONS */

"\\begin{quotation}" {
    //cout<<"ENTERED";  // nu intra in quatation la ex2
    //cout << "\n"; // Start a new line before starting the quotation
    BEGIN(QUOTATION);
    cout << "\n"; 
}

<QUOTATION>"\\end{quotation}" {
    //cout << "\n"; // Add a new line after ending the quotation
    BEGIN(INITIAL);
    cout << "\n"; 
}

<QUOTATION>{CLEAR} {
    stringstream ss(yytext);
    vector<string> words;
    string word;
    while (ss >> word) {
        words.push_back(word);
        if (words.size() == 10) {
            printQuotationLine(words);
            words.clear();
        }
    }
    // Print remaining words if any
    if (!words.empty()) {
        printQuotationLine(words);
    }
}

 /*
<QUOTATION>{CLEAR} {
    cout << "> " << yytext << "\n"; // Prefix each line of quotation with '>'
}
 */

 /* VERBATIM */

"\\begin{verbatim}" {
    BEGIN(VERBATIM); // Schimbăm starea la VERBATIM
    verbatimLine = ""; // Resetăm linia
    cout << endl;     // Începem un nou bloc de cod Markdown
}

<VERBATIM>"\\end{verbatim}" {
    // Afisează ultima linie dacă există
    if (!verbatimLine.empty()) {
        cout << "    " << verbatimLine << endl;
    }
    BEGIN(INITIAL);  // Revenim la starea inițială
    cout << endl;    // Terminăm blocul de cod Markdown
}

<VERBATIM>.|\n {
    if (yytext[0] == '\n') { // Dacă e sfârșit de linie
        cout << "    " << verbatimLine << endl; // Indentează și afișează linia
        verbatimLine = ""; // Resetăm linia
    } else {
        verbatimLine += yytext; // Adăugăm textul la linia curentă
    }
}



 /* ITEMIZE */

"\\begin{itemize}" {
    pushState(ITEMIZE);
    cout << "\n"; 
}

<ITEMIZE>"\\item" {
    pushState(ITEM);
    cout << "   -";
}

<ITEMIZE>"\\begin{itemize}" {
}

<ITEMIZE>"\\end{itemize}" {
}

<ITEM>"\\end{itemize}" {
    popState(); // Revenire la starea ENUMERATE sau INITIAL
    if (YY_START == ITEMIZE) {
        popState(); // Dacă suntem încă în ENUMERATE, revenim la INITIAL
        cout << "\n";
    }
}

<ITEM>"\\textit{" {
    cout << "_"; // Adaugă simbolul pentru italic
    pushState(TEXTITALIC); // Intră în starea TEXTITALIC
}

<ITEM>"\\emph{" {
    cout << "_"; // Adaugă simbolul pentru emph
    pushState(TEXTITALIC); // Intră în starea TEXTITALIC
}


<ITEM>"\\textbf{" {
    cout << "**"; // Adaugă simbolul pentru bold
    pushState(TEXTBOLD); // Intră în starea TEXTBOLD
}

<ITEM>"\\texttt{" {
    cout << "`"; // Adaugă simbolul pentru typed text
    pushState(TEXTTYPEDTEXT); // Intră în starea TEXTTYPEDTEXT
}

<ITEM>"\\item" {
    cout << "\n   - "; // Începe următorul item
    // Nu apelez popState() aici pentru că starea ITEM trebuie să rămână activă
}

<ITEM>. {
    cout << yytext; // Afișează conținutul itemului
}

 /* TEXTITALIC State Rules */
<TEXTITALIC>"}" {
    cout << "_";
    popState(); // Revenire la starea ITEM sau starea anterioară
}

<TEXTITALIC>. {
    cout << yytext;
}

 /* TEXTBOLD State Rules */
<TEXTBOLD>"}" {
    cout << "**";
    popState(); // Revenire la starea ITEM sau starea anterioară
}

<TEXTBOLD>. {
    cout << yytext;
}

 /* TEXTTYPEDTEXT State Rules */
<TEXTTYPEDTEXT>"}" {
    cout << "`";
    popState(); // Revenire la starea ITEM sau starea anterioară
}

<TEXTTYPEDTEXT>. {
    cout << yytext;
}

 /*
"\\begin{itemize}" {
    BEGIN(ITEMIZE);
    // nu fac nimic
    //cout<< "intauntru"<<endl;
}

"\\item" {
    cout<<'\n';
    cout << "   -";
    BEGIN(PRINTITEM);
}

<PRINTITEM>{NAME} {
    cout<<yytext;
    BEGIN(ITEMIZE);
}

"\\end{itemize}" {
    cout <<endl;
}
 */



 /* ENUMERATE */

 /*
"\\begin{enumerate}" {
    enumerateCounter++; // crește contorul pentru fiecare \begin{enumerate} întâlnit
    pushState(ENUMERATE);
    cout << "\n"; 
}

<ENUMERATE>"\\item" {
    pushState(ENUMITEM);
    cout << "1. ";
}

<ENUMERATE>"\\begin{enumerate}" {
}

<ENUMERATE>"\\end{enumerate}" {
}

<ENUMITEM>"\\end{enumerate}" {
    popState(); // Revenire la starea ENUMERATE sau INITIAL
    if (YY_START == ENUMERATE) {
        popState(); // Dacă suntem încă în ENUMERATE, revenim la INITIAL
        cout << "\n";
    }
}

<ENUMITEM>"\n" {
    cout << yytext; // Afișează conținutul itemului
    popState(); // Revenire la starea ENUMERATE
}
 */



"\\begin{enumerate}" {
    pushState(ENUMERATE);
    cout << "\n"; 
}

<ENUMERATE>"\\end{enumerate}" {
    popState(); // Revenire la starea anterioară
    if (stateStack.empty()) {
        BEGIN(INITIAL); // Dacă stiva de stări este goală, revenim la starea INITIAL
        cout << "\n";
    }
}

<ENUMERATE>"\\item" {
    cout << "1. ";
}

<ENUMERATE>"\\begin{enumerate}" {
    pushState(ENUMERATE); // Gestionăm imbricarea listelor
}

<ENUMERATE>.|\n {
    cout << yytext; // Afișează conținutul listei
}



 /* HREF BRACE IGNORE*/
 
"\\href{" { 
    BEGIN(HREF_URL); 
}

<HREF_URL>[^}]+ { 
    href_url = yytext; 
    BEGIN(HREF_TEXT); 
}

<HREF_TEXT>"}" { 
    /* Ignoră închiderea primei acolade și așteaptă deschiderea celei de-a doua acolade */
    BEGIN(BRACE_IGNORE); 
}


<BRACE_IGNORE>"{" { 
    // Ignoră deschiderea celei de-a doua acolade și trece la starea HREF_TEXT_CONTENT
    BEGIN(HREF_TEXT_CONTENT); 
}


<HREF_TEXT_CONTENT>[^}]+ { 
    href_text = yytext; 
    cout << "[" << href_url << "](" << href_text << ")"; 
    BEGIN(BRACE_IGNORE);  // Revenire la starea BRACE_IGNORE pentru a ignora acolada închisă
}

<BRACE_IGNORE>"}" { 
    // Ignoră închiderea celei de-a doua acolade și revine la starea inițială
    BEGIN(INITIAL); 
}

<BRACE_IGNORE>.|\n { /* Ignoră orice alt caracter în această stare */ }
 

 /*
 "\\" { // Ignoră orice comandă LaTeX necunoscută
}
 */




 /* Handle clear text, regula de CLEAR pare ca ia prea multe */

 /*
<INITIAL,CLEARTEXT>{CLEAR} {
    cout <<" "<< yytext;
    BEGIN(CLEARTEXT);
}


<CLEARTEXT>\\ {
    BEGIN(INITIAL);
} 
 */

 /*
<CLEARTEXT>\n {
    cout << endl;
    BEGIN(INITIAL);
}
 */




 /* Reguli pentru Formatări Specifice */
"\\textbf{" {
    cout << normalTextBuffer; // Afisează textul normal acumulat
    normalTextBuffer = ""; // Resetarea buffer-ului
    cout << "**";
    BEGIN(TEXTBOLD);
}


"\\textit{" {
    cout << normalTextBuffer; // Afisează textul normal acumulat
    normalTextBuffer = ""; // Resetarea buffer-ului
    cout << "_";
    BEGIN(TEXTITALIC);
}

"\\texttt{" {
    cout << normalTextBuffer; // Afisează textul normal acumulat
    normalTextBuffer = ""; // Resetarea buffer-ului
    cout << "`";
    BEGIN(TEXTTYPEDTEXT);
}

"\\emph{" {
    cout << normalTextBuffer; // Afisează textul normal acumulat
    normalTextBuffer = ""; // Resetarea buffer-ului
    cout << "_";
    BEGIN(TEXTITALIC);
}

<INITIAL,CLEARTEXT>"\\documentclass"[^\n]*  { /* Ignoră linii care încep cu \documentclass */ }
<INITIAL,CLEARTEXT>"\\newcommand"[^\n]*     { /* Ignoră linii care încep cu \newcommand */ }
<INITIAL,CLEARTEXT>"\\usepackage"[^\n]*     { /* Ignoră linii care încep cu \usepackage */ }
<INITIAL,CLEARTEXT>"\\label{"[^}]*"}"   { /* Ignoră liniile cu comanda \label{...} */ }
<INITIAL,CLEARTEXT>"\\date{"[^}]*"}"   { /* Ignoră liniile cu comanda \label{...} */ }
<INITIAL,CLEARTEXT>"\\begin{document}\\maketitle"   {     cout<<endl;
}
<INITIAL,CLEARTEXT>"\\maketitle"            { /* Ignoră comanda \maketitle */ }
<INITIAL,CLEARTEXT>"\\begin{abstract}"      { /* Ignoră comanda \begin{abstract} */ }
<INITIAL,CLEARTEXT>"\\end{abstract}"        { /* Ignoră comanda \end{abstract} */ }
<INITIAL,CLEARTEXT>"\\begin{center}" { /* Ignoră comanda \begin{center} */ }
<INITIAL,CLEARTEXT>"\\begin{tabular}"[^\n]* { /* Ignoră comanda \begin{tabular} și argumentele sale */ }
<INITIAL,CLEARTEXT>"\\hline"[^\n]* { /* Ignoră comanda \hline și argumentele sale */ }
<INITIAL,CLEARTEXT>"\\end{tabular}" { /* Ignoră comanda \end{tabular} */ }
<INITIAL,CLEARTEXT>"\\end{center}" { /* Ignoră comanda \end{center} */ }



<INITIAL,CLEARTEXT>"{" { /* Ignoră acolada deschisă */ }

<INITIAL,CLEARTEXT>"}" { /* Ignoră acolada închisă */ }

<INITIAL,CLEARTEXT>{CLEAR} {
    cout <<" "<< yytext;
    BEGIN(CLEARTEXT);
}

<CLEARTEXT>\\ {
    BEGIN(INITIAL);
}

 /*
<CLEARTEXT>"\\textit{" {
    cout << "_"; // Adaugă simbolul pentru italic
    pushState(TEXTITALIC); // Intră în starea TEXTITALIC
}

<CLEARTEXT>"\\emph{" {
    cout << "_"; // Adaugă simbolul pentru emph
    pushState(TEXTITALIC); // Intră în starea TEXTITALIC
}

<CLEARTEXT>"\\textbf{" {
    cout << "**"; // Adaugă simbolul pentru bold
    pushState(TEXTBOLD); // Intră în starea TEXTBOLD
}

<CLEARTEXT>"\\texttt{" {
    cout << "`"; // Adaugă simbolul pentru typed text
    pushState(TEXTTYPEDTEXT); // Intră în starea TEXTTYPEDTEXT
}
 */



 /* NU STIU DACA BINE, trebuie la clear sa bag tipurile de texte */



"%"[^\n]*   { // Ignoră comentariile LaTeX  
}


 
"{" { 
    braceCount = 1; // Inițializăm contorul de acolade 
    BEGIN(BRACE_IGNORE); // Schimbăm starea pentru a ignora textul între acolade 
}


<INITIAL,CLEARTEXT>"\\author{"              { 
braceCount = 1; 
BEGIN(BRACE_IGNORE_CLEARTEXT); 
}
 
<BRACE_IGNORE_CLEARTEXT>"{" { 
    ++braceCount; // Incrementăm contorul pentru fiecare acoladă deschisă 
}

<BRACE_IGNORE_CLEARTEXT>"}" { 
    --braceCount; // Decrementăm contorul pentru fiecare acoladă închisă 
    if (braceCount == 0) 
    BEGIN(INITIAL); // Revenim la starea inițială dacă toate acoladele au fost închise 
}

<BRACE_IGNORE_CLEARTEXT>.|\n { // Ignoră orice alt caracter în această stare 
}
 


 
 .|\n {};    // papa tot ce nu e in reguli

 
%%

int main(int argc, char* argv[]) {
    /* Parsez fisierul */
    yyin = fopen(argv[1], "r");
    yylex();
    fclose(yyin);
}
