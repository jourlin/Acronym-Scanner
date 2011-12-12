/* AcroDefScanner.flex : Extract the definitions of acronyms that occurs in a html or ascii text file

    Copyright (C) 2009  Pierre Jourlin

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
 
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
***********************************************************************************
  AcroDefScanner.flex : Extrait les définitions d'acronymes présents dans un fichier
			texte au format html ou ascii.

  Copyright (C) 2009 Pierre Jourlin — Tous droits réservés.
 
  Ce programme est un logiciel libre ; vous pouvez le redistribuer ou le
  modifier suivant les termes de la “GNU General Public License” telle que
  publiée par la Free Software Foundation : soit la version 3 de cette
  licence, soit (à votre gré) toute version ultérieure.
  
  Ce programme est distribué dans l’espoir qu’il vous sera utile, mais SANS
  AUCUNE GARANTIE : sans même la garantie implicite de COMMERCIALISABILITÉ
  ni d’ADÉQUATION À UN OBJECTIF PARTICULIER. Consultez la Licence Générale
  Publique GNU pour plus de détails.
  
  Vous devriez avoir reçu une copie de la Licence Générale Publique GNU avec
  ce programme ; si ce n’est pas le cas, consultez :
  <http://www.gnu.org/licenses/>.

    Pierre Jourlin
    L.I.A. / C.E.R.I.
    339, chemin des Meinajariès
    BP 1228 Agroparc
    84911 AVIGNON CEDEX 9
    France 
    pierre.jourlin@univ-avignon.fr
    Tel : +33 4 90 84 35 32
    Fax : +33 4 90 84 35 01

*/
   
%{

/* If needed, places all #include <> here */
char Acro[500];
int i;
FILE *facro;
char fnacro[500];

void GetDefinition(char *def, char *text)
{
	int posinitial, i, j, searchstart, nbiter;
	char initial;
	
	i=0;
	while(text[i]!='\0')
	{
		text[i]=tolower(text[i]);
		i++;
	}
	posinitial=0;
	//printf("processing %s\n", text);
	while(text[posinitial]!='\0' && text[posinitial]!=')' && text[posinitial]!='<')
		posinitial++;
	initial=text[--posinitial];
	for(i=posinitial; text[i]!=' ' && text[i]!='-';i--); // Go to the definition
	while(initial!='('&& initial != '>')
	{
		searchstart=i;
		nbiter=0;
		while(i>=0 && nbiter<=2 && text[i]!=initial) /* Find a word of the acronym in def */
		{
			/* Previous Word */
			if(text[i]==' '||text[i]=='-')
				i--;
			else 
				i-=2;
			while(i>=0 && text[i]!=' ' && text[i]!='-')
				i--; 
			if(i<0 || text[i]==' '||text[i]=='-')
				i++;
			nbiter++;
		};
	if(text[i]!=initial)
		i=searchstart;
	else
		i--;	
	//printf("%c : %s\n", initial, text+i);
	initial=text[--posinitial];
	}
	j=0;
	if(i<0)
		i=0;
	
	if(text[i]==' '||text[i]=='-')
		i++;
	if(initial=='('||initial=='<')
		posinitial++;
	while(text[posinitial]!=')' && text[posinitial]!='<')
		def[j++]=toupper(text[posinitial++]);
	def[j++]=':';
	while(text[i]!='\0'&& text[i]!='(')
		def[j++]=text[i++];
	def[--j]='\0';

	//printf("Processed %s\n",def);
}

%}
/* Identifier	Regular Expression */
/*SUBSCRIPT	\<sub\>[a-z]+\<\/sub\>*/
/* Prends en compte langues accentués JMT 2011.12.9 */
SUBSCRIPT	\<sub\>[a-zâáàäêéèëïíîöóôöúùûñç']+\<\/sub\>
/*TAG	\<\/?[A-Za-z]+\>*/
TAG	\<\/?[A-Za-zâáàäêéèëïíîöóôöúùûñç']+\>
/*ACRO	([A-Za-z]+[\-\ ]){2,10}\({TAG}?[A-Z][A-Z]+{TAG}?{SUBSCRIPT}?\)*/
ACRO	([A-Za-zâáàäêéèëïíîöóôöúùûñç']+[\-\ ]){2,10}\({TAG}?[A-Z][A-Z]+{TAG}?{SUBSCRIPT}?\)
%%
		/* RegularExpression	Code	*/
{ACRO}	{	
			GetDefinition(Acro, yytext);
			/* fprintf(facro, "%s\n",Acro);*/
			printf("%s\n",Acro);	/* Sortie standard JMT 10.12.11 */
		}

[ \n\t]		/* skip blanks */   
.		;
     
%%
     
main( argc, argv )
         int argc;
         char **argv;
             {
             ++argv, --argc;  /* skip over program name */
             if ( argc > 0 )
                     yyin = fopen( argv[0], "r" );
             else
                     yyin = stdin;
/*	     strcpy(fnacro, argv[0]);
	     strcat(fnacro, ".def");
	     facro=fopen(fnacro, "w+");	 Sortie standard JMT 10.12.11 */
             yylex();
/*	     fclose(facro);*/
             }

