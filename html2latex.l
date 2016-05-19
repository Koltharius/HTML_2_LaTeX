/*
   Conversor de HTML a Latex para la Practica 5 de la
   asignatura de Modelos de Computacion de la UGR
   Esta basado en un Ejercicio propuesto por la
   Universidad de Kansas.
   La dirección de dicho ejercicio es la siguiente:
   http://www.ittc.ku.edu/~belluru/labs/lab003/index.html

   David Sánchez Jiménez

   Uso del programa:
      $ flex -l html2latex.l
      $ gcc -o html2latex lex.yy.c
      $ ./html2latex archivo.html
*/

/*-----Sección de Declaraciones-----*/

%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int list_type;
%}

/* noyywrap --> Solo un fichero de entrada */
/* yylineno --> Numero de linea */
%option noyywrap yylineno
/* Condiciones de Arranque Exclusivas */
/* Describen al analizador como tratar cada una de las secciones del html */
%x COMMENT PARA PRE OL UL LI

/*Sección de Reglas */
%%

"<h1>"[^<]*"</h1>" {
yytext[yyleng-5] = 0;
fprintf(yyout, "\\section{%s}", yytext+4);
}

"<h2>"[^<]*"</h2>" {
yytext[yyleng-5] = 0;
fprintf(yyout, "\\subsection{%s}", yytext+4);
}

"<h3>"[^<]*"</h3>" {
yytext[yyleng-5] = 0;
fprintf(yyout, "\\subsubsection{%s}", yytext+4);
}

"<!--" {
fprintf(yyout, "%% ", yytext);
BEGIN COMMENT;
}

[ \t\n\r]+ {
fprintf(yyout,"%s",yytext);
}

. {
fprintf(stderr, "Unexpected input at line %d: '%s'\n", yylineno, yytext);
exit(1);
}

<COMMENT>"-->" {
fprintf(yyout, "\n",yytext);
BEGIN 0;
}

<COMMENT>[\n](\r)? {
fprintf(yyout, "\n%% ",yytext);
}

<COMMENT>[ \t] {
fprintf(yyout, "%s", yytext);
}

<COMMENT>. {
fprintf(yyout, "%s", yytext);
}

"<p>"  {
BEGIN PARA;
}

<PARA>. {
fprintf(yyout, "%s", yytext);
}

<PARA>"</p>" {
fprintf(yyout, "\n", yytext);
BEGIN 0;
}

<PARA>[^<]* {
fprintf(yyout, "%s", yytext);
}

<PARA>"<small>".*"</small>" {
yytext[yyleng-8] = 0;
fprintf(yyout, "\\scriptsize{%s}", yytext+7);
}

<PARA>"<big>".*"</big>" {
yytext[yyleng-6] = 0;
fprintf(yyout, "\\Large{%s}", yytext+5);
}

<PARA>"<i>".*"</i>" {
yytext[yyleng-4] = 0;
fprintf(yyout, "\\textit{%s}", yytext+3);
}

<PARA>"<b>"[^<]*"</b>" {
yytext[yyleng-4] = 0;
fprintf(yyout, "\\textbf{%s}", yytext+3);
}

<PARA>"<strong>".*"</strong>" {
yytext[yyleng-9] = 0;
fprintf(yyout, "\\textmd{%s}", yytext+8);
}

<PARA>"<em>".*"</em>" {
yytext[yyleng-5] = 0;
fprintf(yyout, "\\empth{%s}", yytext+4);
}

<PARA>"<sup>"[^<]*"</sup>" {
yytext[yyleng-6] = 0;
fprintf(yyout, "\\textsuperscript{%s}", yytext+5);
}

<PARA>"<sub>".*"</sub>" {
yytext[yyleng-6] = 0;
fprintf(yyout, "\\textsubscript{%s}", yytext+5);
}

"<pre>"(.|[\r\n])*"</pre>" {
yytext[yyleng-6] = 0;
fprintf(yyout, "\\begin{verbatim}%s\\end{verbatim}\n", yytext+5);
}

"<ol>" {
fprintf(yyout, "\\begin{enumerate}\n");
BEGIN LI;
}

"<ul>" {
fprintf(yyout, "\\begin{itemize}\n");
BEGIN LI;
}

<LI>"<li>" {
fprintf(yyout, "\\item %s", yytext+4);
BEGIN PARA;
}

<PARA>"</li>" {
fprintf(yyout, "\n", yytext);
BEGIN LI;
}

<LI>"</ul>" {
fprintf(yyout, "\\end{itemize}", yytext);
BEGIN 0;
}

<LI>"</ol>" {
fprintf(yyout, "\\end{enumerate}", yytext);
BEGIN 0;
}

%%

/*----- Seccion de Procedimientos ----- */

/* Leemos el archivo que le pasemos por parametro,
crea el archivo de salida e imprimimos la cabezera
y el correspondiente texto en latex */

int main( int argc, const char *argv[] ) {
if(argc > 1) {
   yyin = fopen(argv[1], "r");

   if(!yyin) {
      fprintf ("El fichero %s no se puede abrir.", argv[1]);
      exit(-1);
   }

   yyout = fopen("salida.tex", "w");
}

fprintf(yyout, "\\documentclass[12pt]{article}\n" );
fprintf(yyout, "\\usepackage{fixltx2e}\n" );
fprintf(yyout, "\n" );
fprintf(yyout, "\\setlength{\\parindent}{0.0in}\n" );
fprintf(yyout, "\\setlength{\\parskip}{0.125in}\n" );
fprintf(yyout, "\n\n" );
fprintf(yyout, "\\begin{document}\n");
yylex();
fprintf(yyout, "\\end{document}\n");
fclose(yyin);
fclose(yyout);

return 0;
}
