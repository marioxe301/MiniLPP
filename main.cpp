#include <iostream>
#include "tokens.h"

#define CASE_DEF(t,a)\
    case t : return a;

extern Expr::Parser::token_type yylex(Expr::Parser::semantic_type *yylval);
extern char *yytext;
 
void ExecuteLexer();
void ExecuteParser();
std::string TokenToString(Expr::Parser::token::yytokentype tk);

using TOKEN = Expr::Parser::token;

int main(int argc, char *argv[]){
    if( argc >= 2 && std::string(argv[1]) == "-l"){
        std::cout<< "Ejecutando Lexer"<<std::endl<<std::endl;
        ExecuteLexer();
        
    }else{
        std::cout<< "Ejecutando Parser"<<std::endl<<std::endl;
        ExecuteParser();
    }
    return 0;
}

void ExecuteLexer(){
    Expr::Parser::semantic_type yylval;
    Expr::Parser::token_type tk;
    tk = yylex(&yylval);
    while (tk != Expr::Parser::token::EoF)
    {   
        if(tk != TOKEN::EoL){
            std::cout<< "Lexema: "<< yytext << "    Tipo: "<< TokenToString(tk) << std::endl;
        }else{
            std::cout<< "Lexema: "<< "/n" << "    Tipo: "<< TokenToString(tk) << std::endl;
        }
        tk = yylex(&yylval);
    }
}

void ExecuteParser(){
     Expr::Parser parser;
     try
     {
        parser();
     }
     catch(const std::string& e)
     {
         std::cerr << e << '\n';
     }
     
}

std::string TokenToString(Expr::Parser::token::yytokentype tk){
    switch (tk)
    {
    CASE_DEF(TOKEN::AbrirKw,"Abrir Keyword")
    CASE_DEF(TOKEN::ArchivoKw,"Archivo Keyword")
    CASE_DEF(TOKEN::ArregloKw,"Arreglo Keyword")
    CASE_DEF(TOKEN::Binary,"Binary Constant")
    CASE_DEF(TOKEN::BooleanoKw,"Booleano Keyword")
    CASE_DEF(TOKEN::CadenaKw, "Cadena Keyword")
    CASE_DEF(TOKEN::CaracterKw,"Caracter Keyword")
    CASE_DEF(TOKEN::CasoKw,"Caso Keyword")
    CASE_DEF(TOKEN::CerrarKw,"Cerrar Keyword")
    CASE_DEF(TOKEN::CharConst,"Char Constant")
    CASE_DEF(TOKEN::ComoKw,"Como Keyword")
    CASE_DEF(TOKEN::Decimal,"Decimal Constant")
    CASE_DEF(TOKEN::DeKw,"De Keyword")
    CASE_DEF(TOKEN::DivKw,"Divison Keyword")
    CASE_DEF(TOKEN::EnteroKw,"Entero Keyword")
    CASE_DEF(TOKEN::EntoncesKw,"Entonces Keyword")
    CASE_DEF(TOKEN::EoL,"Salto de Linea")
    CASE_DEF(TOKEN::Error, "Error")
    CASE_DEF(TOKEN::EscribaKw,"Escriba Keyword")
    CASE_DEF(TOKEN::EscribirKw,"Escribir Keyword")
    CASE_DEF(TOKEN::EscrituraKw,"Escritura Keyword")
    CASE_DEF(TOKEN::EsKw,"Es Keyword")
    CASE_DEF(TOKEN::FalsoKw,"Falso Keyword")
    CASE_DEF(TOKEN::FinalKw,"Final Keyword")
    CASE_DEF(TOKEN::FinKw,"Fin Keyword")
    CASE_DEF(TOKEN::FuncionKw,"Funcion Keyword")
    CASE_DEF(TOKEN::HagaKw,"Haga Keyword")
    CASE_DEF(TOKEN::HastaKw,"Hasta Keyword")
    CASE_DEF(TOKEN::Hexa,"Hexadecimal Constant")
    CASE_DEF(TOKEN::InicioKw,"Inicio Keyword")
    CASE_DEF(TOKEN::LeaKw,"Lea Keyword")
    CASE_DEF(TOKEN::LecturaKw,"Lectura Keyword")
    CASE_DEF(TOKEN::LeerKw,"Leer Keyword")
    CASE_DEF(TOKEN::LlamarKw,"Llama Keyword")
    CASE_DEF(TOKEN::MientrasKw,"Mientras Keyword")
    CASE_DEF(TOKEN::ModKw,"Modulo Keyword")
    CASE_DEF(TOKEN::NoKw,"No Keyword")
    CASE_DEF(TOKEN::OKw,"O Keyword")
    CASE_DEF(TOKEN::ParaKw,"Para Keyword")
    CASE_DEF(TOKEN::ProcedimientoKw,"Procedimiento Keyword")
    CASE_DEF(TOKEN::RealKw,"Real Keyword")
    CASE_DEF(TOKEN::RegistroKw,"Registro Keyword")
    CASE_DEF(TOKEN::RepitaKw,"Repita Keyword")
    CASE_DEF(TOKEN::RetorneKw,"Retorne Keyword")
    CASE_DEF(TOKEN::SecuencialKw,"Secuencial Keyword")
    CASE_DEF(TOKEN::SiKw,"Si Keyword")
    CASE_DEF(TOKEN::SinoKw,"Sino Keyword")
    CASE_DEF(TOKEN::StringConst,"String Constant")
    CASE_DEF(TOKEN::TipoKw,"Tipo Keyword")
    CASE_DEF(TOKEN::VarKw,"Var Keyword")
    CASE_DEF(TOKEN::VerdaderoKw,"Verdadero Keyword")
    CASE_DEF(TOKEN::YKw,"Y Keyword")
    CASE_DEF(TOKEN::Identifier,"Identifier")
    CASE_DEF(TOKEN::LessThan,"Less Than Operator")
    CASE_DEF(TOKEN::LessThanEq,"Less Than Eq Operator")
    CASE_DEF(TOKEN::GreaterThan,"Greater Than Operator")
    CASE_DEF(TOKEN::GreaterThanEq,"Greater Than Eq Operator")
    CASE_DEF(TOKEN::Diff,"Different Operator")
    CASE_DEF(TOKEN::Equal,"Equal Operator")
    CASE_DEF(TOKEN::Assign,"Assign Operator")
    CASE_DEF(TOKEN::OpenPar,"Open Parenthesis Operator")
    CASE_DEF(TOKEN::ClosePar,"Close Parenthesis Operator")
    CASE_DEF(TOKEN::OpenBrack,"Open Bracket Operator")
    CASE_DEF(TOKEN::CloseBrack,"Close Bracket Operator")
    CASE_DEF(TOKEN::Plus,"Plus Operator")
    CASE_DEF(TOKEN::Minus,"Minus Operator")
    CASE_DEF(TOKEN::Coma,"Coma")
    CASE_DEF(TOKEN::Colon,"Colon")
    CASE_DEF(TOKEN::Mult,"Multiply Operator")
    CASE_DEF(TOKEN::Pow,"Power Operator")
    default: return "unknown";
    }
}
