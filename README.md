# HTML2LaTeX

Conversor de HTML a Latex usando Lex para la Practica 5 de la asignatura de Modelos de Computacion impartida en la UGR.
Esta basado en un Ejercicio propuesto por la
Universidad de Kansas.

La dirección de dicho ejercicio es la siguiente: [http://www.ittc.ku.edu/~belluru/labs/lab003/index.html](http://www.ittc.ku.edu/~belluru/labs/lab003/index.html)

## Necesitas:
* flex
* gcc

## Uso del programa:
```
$ flex -l html2latex.l
$ gcc -o html2latex lex.yy.c
$ ./html2latex archivo.html
```
