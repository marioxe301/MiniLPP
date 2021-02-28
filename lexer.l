%option noyywrap
%option caseless
%option yylineno

%{
#include <string>
#include <iostream>
#include "tokens.h"
#define YY_DECL Expr::Parser::token_type yylex(Expr::Parser::semantic_type *yylval)
#define yyterminate() return Expr::Parser::token::EoF

using TOKEN = Expr::Parser::token;

%}

DECIMAL [0-9]+
HEX "0x"[0-9a-f]+
BINARY "0b"[0-1]+

ID [_a-z]?[_a-z0-9]+

LINE_COMMENTS "//".*[^\n]


%x b_comments
%x stringconst
%x charconst

%%
{LINE_COMMENTS} ;
"/*" { BEGIN(b_comments);}
\" { BEGIN(stringconst);}
\' { BEGIN(charconst);}

<stringconst>\" { BEGIN(INITIAL);}
<stringconst>[_a-z0-9 ]+        { 
                                    yylval->emplace<std::string>(yytext,yyleng); 
                                    return TOKEN::StringConst; 
                                }
<charconst>\' { BEGIN(INITIAL);}
<charconst>[a-z]                { 
                                    yylval->emplace<char>(yytext[0]);
                                    return TOKEN::CharConst;
                                }
<b_comments>"*/" { BEGIN(INITIAL);}
<b_comments>.|\n ;

{DECIMAL}                       {
                                    yylval->emplace<int>(atoi(yytext)); 
                                    return TOKEN::Decimal; 
                                }
{HEX}                           {
                                        yylval->emplace<int>(std::stoi(yytext,nullptr,16)); 
                                        return TOKEN::Hexa;
                                }
{BINARY}                        { 
                                    std::string temp(yytext); 
                                    std::string value = temp.substr(2); 
                                    yylval->emplace<int>(std::stoi(value,nullptr,2)); 
                                    return TOKEN::Binary;
                                }
"entero" return TOKEN::EnteroKw;
"real" return TOKEN::RealKw;
"cadena" return TOKEN::CadenaKw;
"booleano" return TOKEN::BooleanoKw;
"caracter" return TOKEN::CaracterKw;
"arreglo" return TOKEN::ArregloKw;
"de" return TOKEN::DeKw;
"funcion" return TOKEN::FuncionKw;
"procedimiento" return TOKEN::ProcedimientoKw;
"var" return TOKEN::VarKw;
"inicio" return TOKEN::InicioKw;
"fin" return TOKEN::FinKw;
"final" return TOKEN::FinalKw;
"si" return TOKEN::SiKw;
"entonces" return TOKEN::EntoncesKw;
"sino" return TOKEN::SinoKw;
"para" return TOKEN::ParaKw;
"mientras" return TOKEN::MientrasKw;
"haga" return TOKEN::HagaKw;
"llamar" return TOKEN::LlamarKw;
"repita" return TOKEN::RepitaKw;
"hasta" return TOKEN::HastaKw;
"caso" return TOKEN::CasoKw;
"o" return TOKEN::OKw;
"y" return TOKEN::YKw;
"no" return TOKEN::NoKw;
"div" return TOKEN::DivKw;
"mod" return TOKEN::ModKw;
"lea" return TOKEN::LeaKw;
"escriba" return TOKEN::EscribaKw;
"retorne" return TOKEN::RetorneKw;
"tipo" return TOKEN::TipoKw;
"es" return TOKEN::EsKw;
"registro" return TOKEN::RegistroKw;
"archivo" return TOKEN::ArchivoKw;
"secuencial" return TOKEN::SecuencialKw;
"abrir" return TOKEN::AbrirKw;
"como" return TOKEN::ComoKw;
"lectura" return TOKEN::LecturaKw;
"escritura" return TOKEN::EscrituraKw;
"cerrar" return TOKEN::CerrarKw;
"leer" return TOKEN::LeerKw;
"escribir" return TOKEN::EscribirKw;
"verdadero" return TOKEN::VerdaderoKw;
"falso" return TOKEN::FalsoKw;
"<" return TOKEN::LessThan;
"<=" return TOKEN::LessThanEq;
">" return TOKEN::GreaterThan;
">=" return TOKEN::GreaterThanEq;
"<>" return TOKEN::Diff;
"=" return TOKEN::Equal;
"<-" return TOKEN::Assign;
"(" return TOKEN::OpenPar;
")" return TOKEN::ClosePar;
"[" return TOKEN::OpenBrack;
"]" return TOKEN::CloseBrack;
"," return TOKEN::Coma;
":" return TOKEN::Colon;
"^" return TOKEN::Pow;
"*" return TOKEN::Mult;
"+" return TOKEN::Plus;
"-" return TOKEN::Minus;
[ \t]+ ;
[\n]+ return TOKEN::EoL;
{ID} yylval->emplace<std::string>(yytext,yyleng); return TOKEN::Identifier;

. { return TOKEN::Error; }
%%
