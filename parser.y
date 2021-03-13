%language "c++"
%define parse.error verbose
%define api.value.type variant
%define api.parser.class{ Parser }
%define api.namespace{ Expr }
%parse-param{ Ast::Expr*& root }

%code requires {
    #include "ast.h"
}


%{
#include <string>
#include <iostream>
#include "tokens.h"

Expr::Parser::token_type yylex(Expr::Parser::semantic_type *yylval);
extern int yylineno;
namespace Expr{
    void Parser::error(const std::string&msj){
        throw msj+ std::string("  Line -> ") + std::to_string(yylineno);
    }
}

%}

%token<std::string> Identifier
%token<int> Decimal
%token<int> Hexa
%token<int> Binary
%token EnteroKw
%token RealKw
%token CadenaKw
%token BooleanoKw
%token CaracterKw
%token ArregloKw
%token DeKw
%token FuncionKw
%token ProcedimientoKw
%token VarKw
%token InicioKw
%token FinKw
%token FinalKw
%token SiKw
%token EntoncesKw
%token SinoKw
%token ParaKw
%token MientrasKw
%token HagaKw
%token LlamarKw
%token RepitaKw
%token HastaKw
%token CasoKw
%token OKw
%token YKw
%token NoKw
%token DivKw
%token ModKw
%token LeaKw
%token EscribaKw
%token RetorneKw
%token TipoKw
%token EsKw
%token RegistroKw
%token ArchivoKw
%token SecuencialKw
%token AbrirKw
%token ComoKw
%token LecturaKw
%token EscrituraKw
%token CerrarKw
%token LeerKw
%token EscribirKw
%token VerdaderoKw
%token FalsoKw
%token<std::string> StringConst
%token<char> CharConst
%token Error
%token EoL
%token EoF 0
%token LessThan LessThanEq GreaterThan GreaterThanEq Diff Equal
%token OpenPar ClosePar
%token OpenBrack CloseBrack
%token Coma Colon
%token Pow Mult Plus Minus Assign

%start expr_input // solo para probar el codigo de las expresiones

%type<Ast::Expr*> expr_input expr rel term pow neg factor numeric_type 

%%
input: program { }

program: opt_var_decl opt_subprogram_decl InicioKw opt_EoL stmt_list FinKw opt_EoL { std::cout<<"Grammatica Correcta"<<std::endl;}

opt_var_decl: var_decl EoL 
            | %empty

var_decl: var_decl EoL type var_id_list
        | type var_id_list

var_id_list: var_id_list Coma Identifier
            | Identifier

type: EnteroKw
    | BooleanoKw
    | CaracterKw
    | array_type

array_type: ArregloKw OpenBrack numeric_type CloseBrack DeKw type


opt_subprogram_decl: subprograms_decl
                | %empty

subprograms_decl: subprograms_decl subprogram_decl EoL
                | subprogram_decl EoL

subprogram_decl: FuncionKw Identifier opt_func_args Colon type EoL
                opt_var_decl
                InicioKw opt_EoL
                stmt_list
                FinKw
                | ProcedimientoKw Identifier opt_func_args EoL
                opt_var_decl
                InicioKw opt_EoL
                stmt_list
                FinKw

opt_func_args: OpenPar func_arg_list ClosePar
            | %empty

func_arg_list: func_arg_list Coma type Identifier
            | func_arg_list Coma VarKw type Identifier
            | type Identifier
            | VarKw type Identifier

stmt_list: stmt_list stmt EoL
        | stmt EoL

stmt: LlamarKw Identifier
    | LlamarKw subprogram_call
    | EscribaKw print_arg_list
    | LeaKw lvalue_list
    | lvalue Assign expr_input
    | if_stmt
    | MientrasKw expr_input opt_EoL HagaKw EoL stmt_list FinKw MientrasKw
    | ParaKw lvalue Assign expr_input HastaKw expr_input HagaKw EoL stmt_list FinKw ParaKw
    | RepitaKw EoL stmt_list HastaKw expr_input
    | RetorneKw opt_expr

lvalue_list: lvalue_list Coma lvalue
            | lvalue

lvalue: Identifier
        | Identifier OpenBrack expr_input CloseBrack

subprogram_call: Identifier OpenPar opt_expr_list ClosePar

opt_expr: expr_input
        | %empty

opt_expr_list: expr_list 
            | %empty

expr_list: expr_list Coma expr_input
        | expr_input


print_arg_list: print_arg_list Coma expr
            | print_arg_list Coma StringConst
            | expr_input
            | StringConst

if_stmt: SiKw expr_input opt_EoL EntoncesKw opt_EoL stmt_list else_if_stmt FinKw SiKw

else_if_stmt: SinoKw else_if_stmt_cont
            | %empty

else_if_stmt_cont: SiKw expr_input opt_EoL EntoncesKw opt_EoL stmt_list else_if_stmt

expr_input: expr { $$ = new Ast::ExprDecl($1); root = $$; }
        ;

expr: expr Equal rel { $$ = new Ast::EqualExpr($1,$3); }
    | expr Diff rel {$$ = new Ast::DiffExpr($1,$3);}
    | expr LessThan rel {$$ = new Ast::LessThanExpr($1,$3);}
    | expr LessThanEq rel {$$ = new Ast::LessThanEqExpr($1,$3);}
    | expr GreaterThan rel {$$ = new Ast::GreaterThanExpr($1,$3);}
    | expr GreaterThanEq rel {$$ = new Ast::GreaterThanEqExpr($1,$3);}
    | rel {$$ = $1;}
    ;

rel: rel Plus term { $$ = new Ast::AddExpr($1,$3);}
    | rel Minus term {$$ = new Ast::SubExpr($1,$3);}
    | rel OKw term { $$ = new Ast::OrExpr($1,$3);}
    | term {$$ = $1;}
    ;

term: term Mult pow { $$ = new Ast::MultExpr($1,$3);}
    | term DivKw pow { $$ = new Ast::DivExpr($1,$3);}
    | term ModKw pow { $$ = new Ast::ModExpr($1,$3);}
    | term YKw pow { $$ = new Ast::AndExpr($1,$3);}
    | pow { $$ = $1;}
    ;
pow: pow Pow neg { $$ = new Ast::PowExpr($1,$3);}
    | neg {$$ = $1;}

neg: NoKw factor { $$ = new Ast::NotExpr($2);}
    | factor { $$ = $1;}
    ;

factor: numeric_type { $$ = $1;}
    | CharConst { $$ = new Ast::CharExpr($1);}
    | VerdaderoKw { $$ = new Ast::BoolExpr(true);}
    | FalsoKw { $$ = new Ast::BoolExpr(false);}
    | OpenPar expr ClosePar { $$ = $2;}
    | Identifier OpenBrack expr CloseBrack { } //falta la de las funciones
    | Identifier OpenPar args_opt_list ClosePar { }
    ; 

args_opt_list: args_opt_list Coma numeric_type
            | numeric_type
            | %empty
            ;

numeric_type: Decimal { $$ = new Ast::NumberExpr($1);}
            | Identifier { $$ = new Ast::VarExpr($1); }
            | Hexa {$$ = new Ast::NumberExpr($1);}
            | Binary{$$ = new Ast::NumberExpr($1);}
            ;

opt_EoL: EoL
        | %empty

%%