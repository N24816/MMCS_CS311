%{
// Эти объявления добавляются в класс GPPGParser, представляющий собой парсер, генерируемый системой gppg
    public BlockNode root; // Корневой узел синтаксического дерева 
    public Parser(AbstractScanner<ValueType, LexLocation> scanner) : base(scanner) { }
%}

%output = SimpleYacc.cs

%union { 
			public double dVal; 
			public int iVal; 
			public string sVal; 
			public Node nVal;
			public ExprNode eVal;
			public StatementNode stVal;
			public BlockNode blVal;
       }

%using ProgramTree;

%namespace SimpleParser

%token BEGIN END CYCLE ASSIGN SEMICOLON REPEAT UNTIL WHILE DO IF THEN ELSE FOR TO OPENP CLOSEP WRITE VAR COMMA MINUS PLUS MULT DELIM
%token <iVal> INUM 
%token <dVal> RNUM 
%token <sVal> ID

%type <eVal> expr ident e1 e2 e3
%type <stVal> assign statement cycle repeat
%type <blVal> stlist block

%%

progr   : block { root = $1; }
		;

block	: BEGIN stlist END { $$ = $2; }
		;

statement: assign { $$ = $1; }
		| block   { $$ = $1; }
		| cycle   { $$ = $1; }
		| repeat  { $$ = $1; }
//		| while   { $$ = $1; }
//		| for     { $$ = $1; }
//		| if      { $$ = $1; }
//		| write   { $$ = $1; }
//		| var     { $$ = $1; }
	;


stlist	: statement 
			{ 
				$$ = new BlockNode($1); 
			}
		| stlist SEMICOLON statement 
			{ 
				$1.Add($3); 
				$$ = $1; 
			}
		;

repeat  : REPEAT stlist UNTIL expr
			{
				$$ = new RepeatNode($2 as BlockNode, $4 as ExprNode);
			}
		;

ident 	: ID { $$ = new IdNode($1); }	
		;
	
assign 	: ident ASSIGN expr { $$ = new AssignNode($1 as IdNode, $3); }
		;


expr	: e1 { $$ = $1 as ExprNode; }
		;

e1		: e2 { $$ = $1 as ExprNode; }
		| e1 MINUS e2 { $$ = new BinaryOperation($1 as ExprNode,$3 as ExprNode, OpType.MINUS);}
		| e1 PLUS e2 { $$ = new BinaryOperation($1 as ExprNode,$3 as ExprNode, OpType.PLUS);}
		;

e2		: e3 { $$ = $1 as ExprNode; }
		| e2 MULT e3 { $$ = new BinaryOperation($1 as ExprNode,$3 as ExprNode, OpType.MULT);}
		| e2 DELIM e3 { $$ = new BinaryOperation($1 as ExprNode,$3 as ExprNode, OpType.DELIM);}
		; 

e3		: ident { $$ = $1 as IdNode; }
		| INUM  { $$ = new IntNumNode($1); } 
		| RNUM  { $$ = new DoubleNumNode($1); }
		| OPENP expr CLOSEP { $$ = $2 as ExprNode; }
		;

cycle	: CYCLE expr statement { $$ = new CycleNode($2, $3); }
		;
	
%%

