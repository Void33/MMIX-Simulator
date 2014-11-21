/*
 *  The scanner definition for COOL.
 */

import java_cup.runtime.Symbol;

%%

Digit=[0-9]
WhiteSpace=[ \t]
Alpha=[A-Za-z]
UAlpha=[A-Z]
LAlpha=[a-z]
AlphaNumeric=[A-Za-z_]

%{

/*  Stuff enclosed in %{ %} is copied verbatim to the lexer class
 *  definition, all the extra variables/functions you want to use in the
 *  lexer actions should go here.  Don't remove or modify anything that
 *  was there initially.  */

    // Max size of string constants
    static int MAX_STR_CONST = 1025;

    // For assembling string constants
    StringBuffer string_buf = new StringBuffer();

    private int curr_lineno = 1;
    int get_curr_lineno() {
	return curr_lineno;
    }

    private int comment_level = 0;

    private AbstractSymbol filename;

    void set_filename(String fname) {
	filename = AbstractTable.stringtable.addString(fname);
    }

    void printascii(String chr) {
      int a = (int)chr.charAt(0);
      System.out.println(chr + "  --  " + a);
    }

    AbstractSymbol curr_filename() {
	return filename;
    }
%}

%init{

/*  Stuff enclosed in %init{ %init} is copied verbatim to the lexer
 *  class constructor, all the extra initialization you want to do should
 *  go here.  Don't remove or modify anything that was there initially. */

    // empty for now
%init}

%eofval{

/*  Stuff enclosed in %eofval{ %eofval} specifies java code that is
 *  executed when end-of-file is reached.  If you use multiple lexical
 *  states and want to do something special if an EOF is encountered in
 *  one of those states, place your code in the switch statement.
 *  Ultimately, you should return the EOF symbol, or your lexer won't
 *  work.  */

    switch(yy_lexical_state) {
    case YYINITIAL:
	/* nothing special to do in the initial state */
	break;
    case MCOMMENT:
        yybegin(YYINITIAL);
        return new Symbol(TokenConstants.ERROR, "EOF in string constant");
    case STRING:
        yybegin(YYINITIAL);
        return new Symbol(TokenConstants.ERROR, "EOF in comment");
    }
    return new Symbol(TokenConstants.EOF);
%eofval}

%class CoolLexer
%cup

%state MCOMMENT
%state STRING
%state LCOMMENT

%%

<YYINITIAL>"=>"                                   { return new Symbol(TokenConstants.DARROW); }

<YYINITIAL>{WhiteSpace}+                          { /* This is white space which we ignore */ }
<YYINITIAL>[\n\r\f\v\x0B]                         { curr_lineno++; }

<YYINITIAL>[Cc][Ll][Aa][Ss][Ss]                   { return new Symbol(TokenConstants.CLASS); }
<YYINITIAL>[Ee][Ll][Ss][Ee]                       { return new Symbol(TokenConstants.ELSE); }
<YYINITIAL>[Ff][Ii]                               { return new Symbol(TokenConstants.FI); }
<YYINITIAL>[Ii][Ff]                               { return new Symbol(TokenConstants.IF); }
<YYINITIAL>[Ii][Nn]                               { return new Symbol(TokenConstants.IN); }
<YYINITIAL>[Ii][Nn][Hh][Ee][Rr][Ii][Tt][Ss]       { return new Symbol(TokenConstants.INHERITS); }
<YYINITIAL>[Ii][Ss][Vv][Oo][Ii][Dd]               { return new Symbol(TokenConstants.ISVOID); }
<YYINITIAL>[Ll][Ee][Tt]                           { return new Symbol(TokenConstants.LET); }
<YYINITIAL>[Ll][Oo][Oo][Pp]                       { return new Symbol(TokenConstants.LOOP); }
<YYINITIAL>[Pp][Oo][Oo][Ll]                       { return new Symbol(TokenConstants.POOL); }
<YYINITIAL>[Tt][Hh][Ee][Nn]                       { return new Symbol(TokenConstants.THEN); }
<YYINITIAL>[Ww][Hh][Ii][Ll][Ee]                   { return new Symbol(TokenConstants.WHILE); }
<YYINITIAL>[Cc][Aa][Ss][Ee]                       { return new Symbol(TokenConstants.CASE); }
<YYINITIAL>[Ee][Ss][Aa][Cc]                       { return new Symbol(TokenConstants.ESAC); }
<YYINITIAL>[Nn][Ee][Ww]                           { return new Symbol(TokenConstants.NEW); }
<YYINITIAL>[Oo][Ff]                               { return new Symbol(TokenConstants.OF); }
<YYINITIAL>[Nn][Oo][Tt]                           { return new Symbol(TokenConstants.NOT); }
<YYINITIAL>t[Rr][Uu][Ee]                          { return new Symbol(TokenConstants.BOOL_CONST, true); }
<YYINITIAL>f[Aa][Ll][Ss][Ee]                      { return new Symbol(TokenConstants.BOOL_CONST, false); }
    
<YYINITIAL>_                                      { return new Symbol(TokenConstants.ERROR, "_"); }
<YYINITIAL>{UAlpha}[A-Za-z0-9_]*                  { return new Symbol(TokenConstants.TYPEID, AbstractTable.idtable.addString(yytext())); }
<YYINITIAL>[a-z][A-Za-z0-9_]*                     { return new Symbol(TokenConstants.OBJECTID, AbstractTable.idtable.addString(yytext())); }

<YYINITIAL>\{                                     { return new Symbol(TokenConstants.LBRACE); }
<YYINITIAL>\}                                     { return new Symbol(TokenConstants.RBRACE); }
<YYINITIAL>\(                                     { return new Symbol(TokenConstants.LPAREN); }
<YYINITIAL>\)                                     { return new Symbol(TokenConstants.RPAREN); }
<YYINITIAL>:                                      { return new Symbol(TokenConstants.COLON); }
<YYINITIAL>@                                      { return new Symbol(TokenConstants.AT); }
<YYINITIAL>;                                      { return new Symbol(TokenConstants.SEMI); }
<YYINITIAL><-                                     { return new Symbol(TokenConstants.ASSIGN); }
<YYINITIAL><=                                     { return new Symbol(TokenConstants.LE); }
<YYINITIAL><                                      { return new Symbol(TokenConstants.LT); }
<YYINITIAL>-                                      { return new Symbol(TokenConstants.MINUS); }
<YYINITIAL>\.                                     { return new Symbol(TokenConstants.DOT); }
<YYINITIAL>\*                                     { return new Symbol(TokenConstants.MULT); }
<YYINITIAL>\/                                     { return new Symbol(TokenConstants.DIV); }
<YYINITIAL>,                                      { return new Symbol(TokenConstants.COMMA); }
<YYINITIAL>=                                      { return new Symbol(TokenConstants.EQ); }
<YYINITIAL>\+                                     { return new Symbol(TokenConstants.PLUS); }
<YYINITIAL>~                                      { return new Symbol(TokenConstants.NEG); }
<YYINITIAL>\'.\'                                  { return new Symbol(TokenConstants.STR_CONST, AbstractTable.stringtable.addString(yytext().substring(1,2))); }
<YYINITIAL>\"                                     { yybegin(STRING); if (string_buf.length()>0) string_buf.delete(0, string_buf.length()); }
<STRING>\\\"                                      { string_buf.append("\""); }
<STRING>\\b                                       { string_buf.append("\b"); }
<STRING>\\n                                       { string_buf.append("\n"); }
<STRING>\\t                                       { string_buf.append("\t"); }
<STRING>\\f                                       { string_buf.append("\f"); }


<STRING>\\.                                       { string_buf.append(yytext().substring(1,2)); }

<STRING>\"                                        { yybegin(YYINITIAL); if (string_buf.length()>1024) return new Symbol(TokenConstants.ERROR, "String constant too long"); else return new Symbol(TokenConstants.STR_CONST, AbstractTable.stringtable.addString(string_buf.toString())); }
<STRING>\\\n                                      { string_buf.append("\n"); }
<STRING>\x00                                    { System.out.println("NULL"); return new Symbol(TokenConstants.ERROR, "Unterminated string constant"); }
<STRING>\x0D                                      { string_buf.append("\015"); }
<STRING>\n                                        { yybegin(YYINITIAL); return new Symbol(TokenConstants.ERROR, "Unterminated string constant"); }

<STRING>.                                         { string_buf.append(yytext());}

<YYINITIAL>{Digit}+                               { return new Symbol(TokenConstants.INT_CONST, AbstractTable.inttable.addString(yytext())); }

<YYINITIAL>"--"                                   { yybegin(LCOMMENT); }
<LCOMMENT>\n                                      { curr_lineno++; yybegin(YYINITIAL); }
<LCOMMENT>.                                       { /* Ignore characters in a single line comment * / int ascii = (int)yytext().charAt(0); /*System.out.println("ASCII VALUE ----------------- " + ascii);*/ }
<YYINITIAL>\(\*                                   { yybegin(MCOMMENT); comment_level++;  }

<YYINITIAL>\*\)                                   { return new Symbol(TokenConstants.ERROR, "Unmatched *)"); }

<MCOMMENT>\*\)                                    { comment_level--; if (comment_level < 1) { comment_level = 0;  yybegin(YYINITIAL); } }
<MCOMMENT>\\\(\*                                  { /* Ignore characters that are in a multi line comment */ }
<MCOMMENT>{WhiteSpace}+                          { /* This is white space which we ignore */ }
<MCOMMENT>\(\*                                    { comment_level++; }
<MCOMMENT>\\\*\)                                  { /* Ignore characters that are in a multi line comment */ }
<MCOMMENT>.                                       { /* Ignore characters that are in a multi line comment */ }
<MCOMMENT>[\n\r\f\v\x0B]                         { curr_lineno++; }


<MCOMMENT>\n                                      { /* Ignore linefeeds that are in a multi line comment */  }

\0  { System.err.println("ERROR"); }
\x00 { System.err.println("ERROR1"); }

.                                                 {  /*int ascii = (int)yytext().charAt(0); System.err.println("ASCII VALUE ----------------- " + ascii);
		                		     System.err.println("LEXER BUG - UNMATCHED: " + yytext() + " on line: " + get_curr_lineno()); */
				                     return new Symbol(TokenConstants.ERROR, yytext()); }
