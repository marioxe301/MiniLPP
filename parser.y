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

vars_decl vars;
string_l ids;
Ast::Expr* arr_size;



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

%start input 

%type<Ast::Expr*> expr rel term pow neg factor numeric_type
%type<Ast::Expr*> program opt_var_decl opt_subprogram_decl stmt_list stmt print_arg_list
%type<Ast::Expr*> if_stmt else_if_stmt else_if_stmt_cont
%type<Ast::Expr*> subprogram_decl opt_func_args func_arg_list subprogram_call opt_expr_list expr_list

%type<int> type

%%
input: program { root = $1; }

program: opt_var_decl opt_subprogram_decl InicioKw opt_EoL stmt_list FinKw opt_EoL { $$ = new Ast::ProgramDeclStmt($1,$2,$5); }

opt_var_decl: var_decl EoL { $$ = new Ast::VarDeclStmt(vars,arr_size); }
            | %empty { $$= nullptr; }

var_decl: var_decl EoL type var_id_list { vars[$3] = ids; ids.clear(); }
        | type var_id_list { vars[$1] = ids; ids.clear(); }

var_id_list: var_id_list Coma Identifier { ids.push_back($3); }
            | Identifier { ids.push_back($1); }
type: EnteroKw { $$ = 2;}
    | BooleanoKw { $$ = 1;}
    | CaracterKw  { $$ = 0; }
    | ArregloKw OpenBrack numeric_type CloseBrack DeKw EnteroKw { $$ = 3; arr_size = $3;}

opt_subprogram_decl: subprogram_decl EoL { $$ = $1;}
                | %empty { $$ = nullptr;}

// solo voy a soportar funciones que retornen enteros
subprogram_decl: FuncionKw Identifier opt_func_args Colon EnteroKw EoL
                opt_var_decl
                InicioKw opt_EoL
                stmt_list
                FinKw { $$= new Ast::FunctionDecl($2,$3,$10); }
                | ProcedimientoKw Identifier opt_func_args EoL
                opt_var_decl
                InicioKw opt_EoL
                stmt_list
                FinKw { $$ = new Ast::ProcedureDecl($2,$3,$8); }

opt_func_args: OpenPar func_arg_list ClosePar { $$ = $2;}
            | %empty { $$ = nullptr;}

func_arg_list: func_arg_list Coma type Identifier   {
                                                        $$ = $1;
                                                        reinterpret_cast<Ast::FuncArgsDeclList*>($$)->args_list.push_back(std::make_tuple($4,"",$3,false));
                                                    }
            | func_arg_list Coma VarKw type Identifier  {
                                                            $$ = $1;
                                                            reinterpret_cast<Ast::FuncArgsDeclList*>($$)->args_list.push_back(std::make_tuple($5,"",$4,true));
                                                        }
            | type Identifier   {
                                    func_arg arg;
                                    arg.push_back(std::make_tuple($2,"",$1,false));
                                    $$ = new Ast::FuncArgsDeclList(arg);
                                }
            | VarKw type Identifier     {
                                            func_arg arg;
                                            arg.push_back(std::make_tuple($3,"", $2,true));
                                            $$ = new Ast::FuncArgsDeclList(arg);
                                        }

stmt_list: stmt_list stmt EoL { $$=$1; 
                                reinterpret_cast<Ast::SeqStmt*>($$)->seq.push_back($2); 
                              }
        | stmt EoL {
                     list stmts;
                     stmts.push_back($1);
                     $$ = new Ast::SeqStmt(stmts);
                   }

stmt: LlamarKw Identifier { $$ = new Ast::CallProcStmt($2,nullptr);}
    | LlamarKw subprogram_call { $$ = $2;}
    | EscribaKw print_arg_list { $$ = new Ast::PrintStmt($2);}
    | Identifier Assign expr { $$ = new Ast::AssignStmt($1,$3); }
    | Identifier OpenBrack numeric_type CloseBrack Assign expr { $$ = new Ast::ArrAssignStmt($1,$3,$6);}
    | if_stmt { $$ = $1; }
    | MientrasKw expr opt_EoL HagaKw EoL stmt_list FinKw MientrasKw { $$ = new Ast::WhileStmt($2,$6);}
    | ParaKw Identifier Assign expr HastaKw expr HagaKw EoL stmt_list FinKw ParaKw { $$ = new Ast::ForStmt($2,$4,$6,$9); }
    | RepitaKw EoL stmt_list HastaKw expr { $$ = new Ast::DoWhileStmt($3,$5);}
    | RetorneKw expr { $$ = new Ast::ReturnStmt($2);}

subprogram_call: Identifier OpenPar opt_expr_list ClosePar { $$ = new Ast::CallProcStmt($1,$3);}

opt_expr_list: expr_list  { $$ = $1;}
            | %empty { $$ = nullptr;}

expr_list: expr_list Coma expr  {
                                    $$=$1;
                                    reinterpret_cast<Ast::ArgsExprList*>($$)->args.push_back($3);
                                }
        | expr  {    
                    list args;
                    args.push_back($1);
                    $$ = new Ast::ArgsExprList(args);
                }


print_arg_list: print_arg_list Coma expr {
                                                $$ = $1;
                                                reinterpret_cast<Ast::PrintArgList*>($$)->args.push_back($3);  
                                              }
            | print_arg_list Coma StringConst {
                                                $$ = $1;
                                                reinterpret_cast<Ast::PrintArgList*>($$)->args.push_back(new Ast::StringLiteral($3));
                                              }
            | expr    {
                                list args;
                                args.push_back($1);
                                $$ = new Ast::PrintArgList(args);
                            }
            | StringConst   { 
                                list args;
                                args.push_back(new Ast::StringLiteral($1));
                                $$ = new Ast::PrintArgList(args);
                            }

if_stmt: SiKw expr opt_EoL EntoncesKw opt_EoL stmt_list else_if_stmt FinKw SiKw { $$ = new Ast::IfStmt($2,$6,$7);}

else_if_stmt: SinoKw else_if_stmt_cont { $$ = $2;} 
            | %empty { $$ = nullptr;}

else_if_stmt_cont: SiKw expr opt_EoL EntoncesKw opt_EoL stmt_list else_if_stmt { $$ = new Ast::IfStmt($2,$6,$7);}

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
    | Identifier OpenBrack numeric_type CloseBrack { $$ = new Ast::VarArrayExpr($1,$3);} 
    | Identifier OpenPar opt_expr_list ClosePar { $$ = new Ast::CallFuncStmt($1,$3); }
    ; 

numeric_type: Decimal { $$ = new Ast::NumberExpr($1);}
            | Identifier { $$ = new Ast::VarExpr($1); }
            | Hexa {$$ = new Ast::NumberExpr($1);}
            | Binary{$$ = new Ast::NumberExpr($1);}
            ;

opt_EoL: EoL
        | %empty

%%