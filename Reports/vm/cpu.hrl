%%%-------------------------------------------------------------------
%%% @author steveedmans
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%% This header file contains all of the definitions used by the cpu
%%% module
%%% @end
%%% Created : 18. Aug 2015 12:08
%%%-------------------------------------------------------------------
-author("steveedmans").

-define(TRAP,   0).
-define(FCMP,   16#01).
-define(FUN,    16#02).
-define(FEQL,   16#03).
-define(FADD,   16#04).
-define(FIX,    16#05).
-define(FSUB,   16#06).
-define(FIXU,   16#07).
-define(FLOT,   16#08).
-define(FLOTU,  16#0A).
-define(FLOTUI, 16#0B).
-define(SFLOT,  16#0C).
-define(SFLOTI, 16#0D).
-define(SFLOTU, 16#0E).
-define(SFLOTUI,16#0F).
-define(FMUL,   16#10).
-define(FCMPE,  16#11).
-define(FUNE,   16#12).
-define(FEQLE,  16#13).
-define(FDIV,   16#14).
-define(FSQRT,  16#15).
-define(FREM,   16#16).
-define(FINT,   16#17).
-define(MUL,    16#18).
-define(MULI,   16#19).
-define(MULU,   16#1A).
-define(MULUI,  16#1B).
-define(DIV,    16#1C).
-define(DIVI,   16#1D).
-define(DIVU,   16#1E).
-define(DIVUI,  16#1F).
-define(ADD,    16#20).
-define(ADDI,   16#21).
-define(ADDU,   16#22).
-define(ADDUI,  16#23).
-define(SUB,    16#24).
-define(SUBI,   16#25).
-define(SUBU,   16#26).
-define(SUBUI,  16#27).
-define(ADDU2,  16#28).
-define(ADDU2I, 16#29).
-define(ADDU4,  16#2A).
-define(ADDU4I, 16#2B).
-define(ADDU8,  16#2C).
-define(ADDU8I, 16#2D).
-define(ADDU16, 16#2E).
-define(ADDU16I,16#2F).
-define(CMP,    16#30).
-define(CMPI,   16#31).
-define(CMPU,   16#32).
-define(CMPUI,  16#33).
-define(NEG,    16#34).
-define(NEGI,   16#35).
-define(NEGU,   16#36).
-define(NEGUI,  16#37).
-define(SL,     16#38).
-define(SLI,    16#39).
-define(SLU,    16#3A).
-define(SLUI,   16#3B).
-define(SR,     16#3C).
-define(SRI,    16#3D).
-define(SRU,    16#3E).
-define(SRUI,   16#3F).
-define(BN,     16#40).
-define(BNB,    16#41).
-define(BZ,     16#42).
-define(BZB,    16#43).
-define(BP,     16#44).
-define(BPB,    16#45).
-define(BOD,    16#46).
-define(BODB,   16#47).
-define(BNN,    16#48).
-define(BNNB,   16#49).
-define(BNZ,    16#4A).
-define(BNZB,   16#4B).
-define(BNP,    16#4C).
-define(BNPB,   16#4D).
-define(BEV,    16#4E).
-define(BEVB,   16#4F).
-define(PBN,    16#50).
-define(PBNB,   16#51).
-define(PBZ,    16#52).
-define(PBZB,   16#53).
-define(PBP,    16#54).
-define(PBPB,   16#55).
-define(PBOD,   16#56).
-define(PBODB,  16#57).
-define(PBNN,   16#58).
-define(PBNNB,  16#59).
-define(PBNZ,   16#5A).
-define(PBNZB,  16#5B).
-define(PBNP,   16#5C).
-define(PBNPB,  16#5D).
-define(PBEV,   16#5E).
-define(PBEVB,  16#5F).
-define(CSN,    16#60).
-define(CSNI,   16#61).
-define(CSZ,    16#62).
-define(CSZI,   16#63).
-define(CSP,    16#64).
-define(CSPI,   16#65).
-define(CSOD,   16#66).
-define(CSODI,  16#67).
-define(CSNN,   16#68).
-define(CSNNI,  16#69).
-define(CSNZ,   16#6A).
-define(CSNZI,  16#6B).
-define(CSNP,   16#6C).
-define(CSNPI,  16#6D).
-define(CSEV,   16#6E).
-define(CSEVI,  16#6F).
-define(ZSN,    16#70).
-define(ZSNI,   16#71).
-define(ZSZ,    16#72).
-define(ZSZI,   16#73).
-define(ZSP,    16#74).
-define(ZSPI,   16#75).
-define(ZSOD,   16#76).
-define(ZSODI,  16#77).
-define(ZSNN,   16#78).
-define(ZSNNI,  16#79).
-define(ZSNZ,   16#7A).
-define(ZSNZI,  16#7B).
-define(ZSNP,   16#7C).
-define(ZSNPI,  16#7D).
-define(ZSEV,   16#7E).
-define(ZSEVI,  16#7F).
-define(LDB,    16#80).
-define(LDBI,   16#81).
-define(LDBU,   16#82).
-define(LDBUI,  16#83).
-define(LDW,    16#84).
-define(LDWI,   16#85).
-define(LDWU,   16#86).
-define(LDWUI,  16#87).
-define(LDT,    16#88).
-define(LDTI,   16#89).
-define(LDTU,   16#8A).
-define(LDTUI,  16#8B).
-define(LDO,    16#8C).
-define(LDOI,   16#8D).
-define(LDOU,   16#8E).
-define(LDOUI,  16#8F).
-define(LDSF,   16#90).
-define(LDSFI,  16#91).
-define(LDHT,   16#92).
-define(LDHTI,  16#93).
-define(CSWAP,  16#94).
-define(CSWAPI, 16#95).
-define(LDUNC,  16#96).
-define(LDUNCI, 16#97).
-define(LDVTS,  16#98).
-define(LDVTSI, 16#99).
-define(PRELD,  16#9A).
-define(PRELDI, 16#9B).
-define(PREGO,  16#9C).
-define(PREGOI, 16#9D).
-define(GO,     16#9E).
-define(GOI,    16#9F).
-define(STB,    16#A0).
-define(STBI,   16#A1).
-define(STBU,   16#A2).
-define(STBUI,  16#A3).
-define(STW,    16#A4).
-define(STWI,   16#A5).
-define(STWU,   16#A6).
-define(STWUI,  16#A7).
-define(STT,    16#A8).
-define(STTI,   16#A9).
-define(STTU,   16#AA).
-define(STTUI,  16#AB).
-define(STO,    16#AC).
-define(STOI,   16#AD).
-define(STOU,   16#AE).
-define(STOUI,  16#AF).
-define(STSF,   16#B0).
-define(STSFI,  16#B1).
-define(STHT,   16#B2).
-define(STHTI,  16#B3).
-define(STCO,   16#B4).
-define(STCOI,  16#B5).
-define(STUNC,  16#B6).
-define(STUNCI, 16#B7).
-define(SYNCD,  16#B8).
-define(SYNCDI, 16#B9).
-define(PREST,  16#BA).
-define(PRESTI, 16#BB).
-define(SYNCID, 16#BC).
-define(SYNCIDI,16#BD).
-define(PUSHGO, 16#BE).
-define(PUSHGOI,16#BF).
-define(OR,     16#C0).
-define(ORI,    16#C1).
-define(ORN,    16#C2).
-define(ORNI,   16#C3).
-define(NOR,    16#C4).
-define(NORI,   16#C5).
-define(XOR,    16#C6).
-define(XORI,   16#C7).
-define(AND,    16#C8).
-define(ANDI,   16#C9).
-define(ANDN,   16#CA).
-define(ANDNI,  16#CB).
-define(NAND,   16#CC).
-define(NANDI,  16#CD).
-define(NXOR,   16#CE).
-define(NXORI,  16#CF).
-define(BDIF,   16#D0).
-define(BDIFI,  16#D1).
-define(WDIF,   16#D2).
-define(WDIFI,  16#D3).
-define(TDIF,   16#D4).
-define(TDIFI,  16#D5).
-define(ODIF,   16#D6).
-define(ODIFI,  16#D7).
-define(MUX,    16#D8).
-define(MUXI,   16#D9).
-define(SADD,   16#DA).
-define(SADDI,  16#DB).
-define(MOR,    16#DC).
-define(MORI,   16#DD).
-define(MXOR,   16#DE).
-define(MXORI,  16#DF).
-define(SETH,   16#E0).
-define(SETMH,  16#E1).
-define(SETML,  16#E2).
-define(SETL,   16#E3).
-define(INCH,   16#E4).
-define(INCMH,  16#E5).
-define(INCML,  16#E6).
-define(INCL,   16#E7).
-define(ORH,    16#E8).
-define(ORMH,   16#E9).
-define(ORML,   16#EA).
-define(ORL,    16#EB).
-define(ANDNH,  16#EC).
-define(ANDNMH, 16#ED).
-define(ANDNML, 16#EE).
-define(ANDNL,  16#EF).
-define(JMP,    16#F0).
-define(JMPB,   16#F1).
-define(PUSHJ,  16#F2).
-define(PUSHJB, 16#F3).
-define(GETA,   16#F4).
-define(GETAB,  16#F5).
-define(PUT,    16#F6).
-define(PUTI,   16#F7).
-define(POP,    16#F8).
-define(RESUME, 16#F9).
-define(SAVE,   16#FA).
-define(UNSAVE, 16#FB).
-define(SYNC,   16#FC).
-define(SWYM,   16#FD).
-define(GET,    16#FE).
-define(TRIP,   16#FF).
