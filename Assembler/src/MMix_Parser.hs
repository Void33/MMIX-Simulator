{-# OPTIONS_GHC -w #-}
{-# OPTIONS -fglasgow-exts -cpp #-}
module MMix_Parser where

import Data.Char
import MMix_Lexer
import qualified GHC.Exts as Happy_GHC_Exts

-- parser produced by Happy Version 1.19.0

data HappyAbsSyn t4 t5 t7 t8 t9 t10 t11 t12 t13 t14 t15
	= HappyTerminal (Token)
	| HappyErrorToken Int
	| HappyAbsSyn4 t4
	| HappyAbsSyn5 t5
	| HappyAbsSyn6 (Line)
	| HappyAbsSyn7 t7
	| HappyAbsSyn8 t8
	| HappyAbsSyn9 t9
	| HappyAbsSyn10 t10
	| HappyAbsSyn11 t11
	| HappyAbsSyn12 t12
	| HappyAbsSyn13 t13
	| HappyAbsSyn14 t14
	| HappyAbsSyn15 t15

action_0 (4#) = happyGoto action_3
action_0 (5#) = happyGoto action_2
action_0 x = happyTcHack x happyReduce_2

action_1 (5#) = happyGoto action_2
action_1 x = happyTcHack x happyFail

action_2 (16#) = happyShift action_7
action_2 (17#) = happyShift action_8
action_2 (23#) = happyShift action_9
action_2 (26#) = happyShift action_10
action_2 (29#) = happyShift action_11
action_2 (30#) = happyShift action_12
action_2 (31#) = happyShift action_13
action_2 (32#) = happyShift action_14
action_2 (33#) = happyShift action_15
action_2 (34#) = happyShift action_16
action_2 (41#) = happyShift action_17
action_2 (6#) = happyGoto action_4
action_2 (9#) = happyGoto action_5
action_2 (10#) = happyGoto action_6
action_2 x = happyTcHack x happyReduce_1

action_3 (46#) = happyAccept
action_3 x = happyTcHack x happyFail

action_4 x = happyTcHack x happyReduce_3

action_5 (16#) = happyShift action_50
action_5 (17#) = happyShift action_8
action_5 (29#) = happyShift action_11
action_5 (30#) = happyShift action_12
action_5 (31#) = happyShift action_13
action_5 (32#) = happyShift action_14
action_5 (33#) = happyShift action_15
action_5 (34#) = happyShift action_16
action_5 (41#) = happyShift action_17
action_5 (10#) = happyGoto action_49
action_5 x = happyTcHack x happyFail

action_6 x = happyTcHack x happyReduce_7

action_7 (19#) = happyShift action_41
action_7 (20#) = happyShift action_42
action_7 (21#) = happyShift action_43
action_7 (22#) = happyShift action_27
action_7 (23#) = happyShift action_9
action_7 (24#) = happyShift action_44
action_7 (25#) = happyShift action_28
action_7 (26#) = happyShift action_10
action_7 (27#) = happyShift action_45
action_7 (28#) = happyShift action_46
action_7 (39#) = happyShift action_29
action_7 (40#) = happyShift action_30
action_7 (43#) = happyShift action_31
action_7 (7#) = happyGoto action_47
action_7 (8#) = happyGoto action_48
action_7 (9#) = happyGoto action_22
action_7 (12#) = happyGoto action_23
action_7 (13#) = happyGoto action_40
action_7 (14#) = happyGoto action_25
action_7 (15#) = happyGoto action_26
action_7 x = happyTcHack x happyFail

action_8 (19#) = happyShift action_41
action_8 (20#) = happyShift action_42
action_8 (21#) = happyShift action_43
action_8 (22#) = happyShift action_27
action_8 (23#) = happyShift action_9
action_8 (24#) = happyShift action_44
action_8 (25#) = happyShift action_28
action_8 (26#) = happyShift action_10
action_8 (27#) = happyShift action_45
action_8 (28#) = happyShift action_46
action_8 (39#) = happyShift action_29
action_8 (40#) = happyShift action_30
action_8 (43#) = happyShift action_31
action_8 (8#) = happyGoto action_39
action_8 (9#) = happyGoto action_22
action_8 (12#) = happyGoto action_23
action_8 (13#) = happyGoto action_40
action_8 (14#) = happyGoto action_25
action_8 (15#) = happyGoto action_26
action_8 x = happyTcHack x happyFail

action_9 x = happyTcHack x happyReduce_17

action_10 x = happyTcHack x happyReduce_18

action_11 (22#) = happyShift action_27
action_11 (23#) = happyShift action_9
action_11 (25#) = happyShift action_28
action_11 (26#) = happyShift action_10
action_11 (39#) = happyShift action_29
action_11 (40#) = happyShift action_30
action_11 (43#) = happyShift action_31
action_11 (9#) = happyGoto action_22
action_11 (12#) = happyGoto action_23
action_11 (13#) = happyGoto action_38
action_11 (14#) = happyGoto action_25
action_11 (15#) = happyGoto action_26
action_11 x = happyTcHack x happyFail

action_12 (23#) = happyShift action_9
action_12 (24#) = happyShift action_36
action_12 (25#) = happyShift action_37
action_12 (26#) = happyShift action_10
action_12 (9#) = happyGoto action_35
action_12 x = happyTcHack x happyFail

action_13 (22#) = happyShift action_19
action_13 (42#) = happyShift action_20
action_13 (43#) = happyShift action_21
action_13 (11#) = happyGoto action_34
action_13 x = happyTcHack x happyFail

action_14 (22#) = happyShift action_19
action_14 (42#) = happyShift action_20
action_14 (43#) = happyShift action_21
action_14 (11#) = happyGoto action_33
action_14 x = happyTcHack x happyFail

action_15 (22#) = happyShift action_19
action_15 (42#) = happyShift action_20
action_15 (43#) = happyShift action_21
action_15 (11#) = happyGoto action_32
action_15 x = happyTcHack x happyFail

action_16 (22#) = happyShift action_27
action_16 (23#) = happyShift action_9
action_16 (25#) = happyShift action_28
action_16 (26#) = happyShift action_10
action_16 (39#) = happyShift action_29
action_16 (40#) = happyShift action_30
action_16 (43#) = happyShift action_31
action_16 (9#) = happyGoto action_22
action_16 (12#) = happyGoto action_23
action_16 (13#) = happyGoto action_24
action_16 (14#) = happyGoto action_25
action_16 (15#) = happyGoto action_26
action_16 x = happyTcHack x happyFail

action_17 (22#) = happyShift action_19
action_17 (42#) = happyShift action_20
action_17 (43#) = happyShift action_21
action_17 (11#) = happyGoto action_18
action_17 x = happyTcHack x happyFail

action_18 (18#) = happyShift action_56
action_18 x = happyTcHack x happyReduce_22

action_19 x = happyTcHack x happyReduce_31

action_20 x = happyTcHack x happyReduce_29

action_21 x = happyTcHack x happyReduce_30

action_22 x = happyTcHack x happyReduce_43

action_23 x = happyTcHack x happyReduce_47

action_24 (35#) = happyShift action_53
action_24 (36#) = happyShift action_54
action_24 x = happyTcHack x happyReduce_20

action_25 (37#) = happyShift action_57
action_25 (38#) = happyShift action_58
action_25 x = happyTcHack x happyReduce_36

action_26 x = happyTcHack x happyReduce_39

action_27 x = happyTcHack x happyReduce_44

action_28 x = happyTcHack x happyReduce_42

action_29 x = happyTcHack x happyReduce_45

action_30 x = happyTcHack x happyReduce_35

action_31 x = happyTcHack x happyReduce_46

action_32 (18#) = happyShift action_56
action_32 x = happyTcHack x happyReduce_25

action_33 (18#) = happyShift action_56
action_33 x = happyTcHack x happyReduce_24

action_34 (18#) = happyShift action_56
action_34 x = happyTcHack x happyReduce_23

action_35 x = happyTcHack x happyReduce_28

action_36 x = happyTcHack x happyReduce_27

action_37 x = happyTcHack x happyReduce_26

action_38 (35#) = happyShift action_53
action_38 (36#) = happyShift action_54
action_38 x = happyTcHack x happyReduce_19

action_39 (18#) = happyShift action_55
action_39 x = happyTcHack x happyFail

action_40 (35#) = happyShift action_53
action_40 (36#) = happyShift action_54
action_40 x = happyTcHack x happyReduce_16

action_41 x = happyTcHack x happyReduce_10

action_42 x = happyTcHack x happyReduce_11

action_43 x = happyTcHack x happyReduce_12

action_44 x = happyTcHack x happyReduce_13

action_45 x = happyTcHack x happyReduce_14

action_46 x = happyTcHack x happyReduce_15

action_47 (18#) = happyShift action_52
action_47 x = happyTcHack x happyReduce_4

action_48 x = happyTcHack x happyReduce_8

action_49 x = happyTcHack x happyReduce_5

action_50 (19#) = happyShift action_41
action_50 (20#) = happyShift action_42
action_50 (21#) = happyShift action_43
action_50 (22#) = happyShift action_27
action_50 (23#) = happyShift action_9
action_50 (24#) = happyShift action_44
action_50 (25#) = happyShift action_28
action_50 (26#) = happyShift action_10
action_50 (27#) = happyShift action_45
action_50 (28#) = happyShift action_46
action_50 (39#) = happyShift action_29
action_50 (40#) = happyShift action_30
action_50 (43#) = happyShift action_31
action_50 (7#) = happyGoto action_51
action_50 (8#) = happyGoto action_48
action_50 (9#) = happyGoto action_22
action_50 (12#) = happyGoto action_23
action_50 (13#) = happyGoto action_40
action_50 (14#) = happyGoto action_25
action_50 (15#) = happyGoto action_26
action_50 x = happyTcHack x happyFail

action_51 (18#) = happyShift action_52
action_51 x = happyTcHack x happyReduce_6

action_52 (19#) = happyShift action_41
action_52 (20#) = happyShift action_42
action_52 (21#) = happyShift action_43
action_52 (22#) = happyShift action_27
action_52 (23#) = happyShift action_9
action_52 (24#) = happyShift action_44
action_52 (25#) = happyShift action_28
action_52 (26#) = happyShift action_10
action_52 (27#) = happyShift action_45
action_52 (28#) = happyShift action_46
action_52 (39#) = happyShift action_29
action_52 (40#) = happyShift action_30
action_52 (43#) = happyShift action_31
action_52 (8#) = happyGoto action_67
action_52 (9#) = happyGoto action_22
action_52 (12#) = happyGoto action_23
action_52 (13#) = happyGoto action_40
action_52 (14#) = happyGoto action_25
action_52 (15#) = happyGoto action_26
action_52 x = happyTcHack x happyFail

action_53 (22#) = happyShift action_27
action_53 (23#) = happyShift action_9
action_53 (25#) = happyShift action_28
action_53 (26#) = happyShift action_10
action_53 (39#) = happyShift action_29
action_53 (40#) = happyShift action_30
action_53 (43#) = happyShift action_31
action_53 (9#) = happyGoto action_22
action_53 (12#) = happyGoto action_23
action_53 (14#) = happyGoto action_66
action_53 (15#) = happyGoto action_26
action_53 x = happyTcHack x happyFail

action_54 (22#) = happyShift action_27
action_54 (23#) = happyShift action_9
action_54 (25#) = happyShift action_28
action_54 (26#) = happyShift action_10
action_54 (39#) = happyShift action_29
action_54 (40#) = happyShift action_30
action_54 (43#) = happyShift action_31
action_54 (9#) = happyGoto action_22
action_54 (12#) = happyGoto action_23
action_54 (14#) = happyGoto action_65
action_54 (15#) = happyGoto action_26
action_54 x = happyTcHack x happyFail

action_55 (19#) = happyShift action_41
action_55 (20#) = happyShift action_42
action_55 (21#) = happyShift action_43
action_55 (22#) = happyShift action_27
action_55 (23#) = happyShift action_9
action_55 (24#) = happyShift action_44
action_55 (25#) = happyShift action_28
action_55 (26#) = happyShift action_10
action_55 (27#) = happyShift action_45
action_55 (28#) = happyShift action_46
action_55 (39#) = happyShift action_29
action_55 (40#) = happyShift action_30
action_55 (43#) = happyShift action_31
action_55 (8#) = happyGoto action_64
action_55 (9#) = happyGoto action_22
action_55 (12#) = happyGoto action_23
action_55 (13#) = happyGoto action_40
action_55 (14#) = happyGoto action_25
action_55 (15#) = happyGoto action_26
action_55 x = happyTcHack x happyFail

action_56 (22#) = happyShift action_61
action_56 (42#) = happyShift action_62
action_56 (43#) = happyShift action_63
action_56 x = happyTcHack x happyFail

action_57 (22#) = happyShift action_27
action_57 (23#) = happyShift action_9
action_57 (25#) = happyShift action_28
action_57 (26#) = happyShift action_10
action_57 (39#) = happyShift action_29
action_57 (40#) = happyShift action_30
action_57 (43#) = happyShift action_31
action_57 (9#) = happyGoto action_22
action_57 (12#) = happyGoto action_23
action_57 (15#) = happyGoto action_60
action_57 x = happyTcHack x happyFail

action_58 (22#) = happyShift action_27
action_58 (23#) = happyShift action_9
action_58 (25#) = happyShift action_28
action_58 (26#) = happyShift action_10
action_58 (39#) = happyShift action_29
action_58 (40#) = happyShift action_30
action_58 (43#) = happyShift action_31
action_58 (9#) = happyGoto action_22
action_58 (12#) = happyGoto action_23
action_58 (15#) = happyGoto action_59
action_58 x = happyTcHack x happyFail

action_59 x = happyTcHack x happyReduce_41

action_60 x = happyTcHack x happyReduce_40

action_61 x = happyTcHack x happyReduce_33

action_62 x = happyTcHack x happyReduce_32

action_63 x = happyTcHack x happyReduce_34

action_64 x = happyTcHack x happyReduce_21

action_65 (37#) = happyShift action_57
action_65 (38#) = happyShift action_58
action_65 x = happyTcHack x happyReduce_38

action_66 (37#) = happyShift action_57
action_66 (38#) = happyShift action_58
action_66 x = happyTcHack x happyReduce_37

action_67 x = happyTcHack x happyReduce_9

happyReduce_1 = happySpecReduce_1  4# happyReduction_1
happyReduction_1 (HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn4
		 (reverse happy_var_1
	)
happyReduction_1 _  = notHappyAtAll 

happyReduce_2 = happySpecReduce_0  5# happyReduction_2
happyReduction_2  =  HappyAbsSyn5
		 ([]
	)

happyReduce_3 = happySpecReduce_2  5# happyReduction_3
happyReduction_3 (HappyAbsSyn6  happy_var_2)
	(HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn5
		 (happy_var_2 : happy_var_1
	)
happyReduction_3 _ _  = notHappyAtAll 

happyReduce_4 = happySpecReduce_2  6# happyReduction_4
happyReduction_4 (HappyAbsSyn7  happy_var_2)
	(HappyTerminal (TOpCode happy_var_1))
	 =  HappyAbsSyn6
		 (defaultPlainOpCodeLine { pocl_code = happy_var_1, pocl_ops = (reverse happy_var_2) }
	)
happyReduction_4 _ _  = notHappyAtAll 

happyReduce_5 = happySpecReduce_2  6# happyReduction_5
happyReduction_5 (HappyAbsSyn10  happy_var_2)
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn6
		 (defaultLabelledPILine { lppl_id = happy_var_2, lppl_ident = happy_var_1 }
	)
happyReduction_5 _ _  = notHappyAtAll 

happyReduce_6 = happySpecReduce_3  6# happyReduction_6
happyReduction_6 (HappyAbsSyn7  happy_var_3)
	(HappyTerminal (TOpCode happy_var_2))
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn6
		 (defaultLabelledOpCodeLine { lpocl_code = happy_var_2, lpocl_ops = (reverse happy_var_3), lpocl_ident = happy_var_1 }
	)
happyReduction_6 _ _ _  = notHappyAtAll 

happyReduce_7 = happySpecReduce_1  6# happyReduction_7
happyReduction_7 (HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn6
		 (defaultPlainPILine { ppl_id = happy_var_1 }
	)
happyReduction_7 _  = notHappyAtAll 

happyReduce_8 = happySpecReduce_1  7# happyReduction_8
happyReduction_8 (HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn7
		 (happy_var_1 : []
	)
happyReduction_8 _  = notHappyAtAll 

happyReduce_9 = happySpecReduce_3  7# happyReduction_9
happyReduction_9 (HappyAbsSyn8  happy_var_3)
	_
	(HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn7
		 (happy_var_3 : happy_var_1
	)
happyReduction_9 _ _ _  = notHappyAtAll 

happyReduce_10 = happySpecReduce_1  8# happyReduction_10
happyReduction_10 _
	 =  HappyAbsSyn8
		 (PseudoCode 0
	)

happyReduce_11 = happySpecReduce_1  8# happyReduction_11
happyReduction_11 _
	 =  HappyAbsSyn8
		 (fputs
	)

happyReduce_12 = happySpecReduce_1  8# happyReduction_12
happyReduction_12 _
	 =  HappyAbsSyn8
		 (PseudoCode 1
	)

happyReduce_13 = happySpecReduce_1  8# happyReduction_13
happyReduction_13 (HappyTerminal (TRegister happy_var_1))
	 =  HappyAbsSyn8
		 (Register (chr happy_var_1)
	)
happyReduction_13 _  = notHappyAtAll 

happyReduce_14 = happySpecReduce_1  8# happyReduction_14
happyReduction_14 (HappyTerminal (TLocalForwardOperand happy_var_1))
	 =  HappyAbsSyn8
		 (LocalForward happy_var_1
	)
happyReduction_14 _  = notHappyAtAll 

happyReduce_15 = happySpecReduce_1  8# happyReduction_15
happyReduction_15 (HappyTerminal (TLocalBackwardOperand happy_var_1))
	 =  HappyAbsSyn8
		 (LocalBackward happy_var_1
	)
happyReduction_15 _  = notHappyAtAll 

happyReduce_16 = happySpecReduce_1  8# happyReduction_16
happyReduction_16 (HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn8
		 (Expr happy_var_1
	)
happyReduction_16 _  = notHappyAtAll 

happyReduce_17 = happySpecReduce_1  9# happyReduction_17
happyReduction_17 (HappyTerminal (TIdentifier happy_var_1))
	 =  HappyAbsSyn9
		 (Id happy_var_1
	)
happyReduction_17 _  = notHappyAtAll 

happyReduce_18 = happySpecReduce_1  9# happyReduction_18
happyReduction_18 (HappyTerminal (TLocalLabel happy_var_1))
	 =  HappyAbsSyn9
		 (LocalLabel happy_var_1
	)
happyReduction_18 _  = notHappyAtAll 

happyReduce_19 = happySpecReduce_2  10# happyReduction_19
happyReduction_19 (HappyAbsSyn13  happy_var_2)
	_
	 =  HappyAbsSyn10
		 (LocEx happy_var_2
	)
happyReduction_19 _ _  = notHappyAtAll 

happyReduce_20 = happySpecReduce_2  10# happyReduction_20
happyReduction_20 (HappyAbsSyn13  happy_var_2)
	_
	 =  HappyAbsSyn10
		 (GregEx happy_var_2
	)
happyReduction_20 _ _  = notHappyAtAll 

happyReduce_21 = happyReduce 4# 10# happyReduction_21
happyReduction_21 ((HappyAbsSyn8  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn8  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (Set (happy_var_2, happy_var_4)
	) `HappyStk` happyRest

happyReduce_22 = happySpecReduce_2  10# happyReduction_22
happyReduction_22 (HappyAbsSyn11  happy_var_2)
	_
	 =  HappyAbsSyn10
		 (ByteArray (reverse happy_var_2)
	)
happyReduction_22 _ _  = notHappyAtAll 

happyReduce_23 = happySpecReduce_2  10# happyReduction_23
happyReduction_23 (HappyAbsSyn11  happy_var_2)
	_
	 =  HappyAbsSyn10
		 (WydeArray (reverse happy_var_2)
	)
happyReduction_23 _ _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_2  10# happyReduction_24
happyReduction_24 (HappyAbsSyn11  happy_var_2)
	_
	 =  HappyAbsSyn10
		 (TetraArray (reverse happy_var_2)
	)
happyReduction_24 _ _  = notHappyAtAll 

happyReduce_25 = happySpecReduce_2  10# happyReduction_25
happyReduction_25 (HappyAbsSyn11  happy_var_2)
	_
	 =  HappyAbsSyn10
		 (OctaArray (reverse happy_var_2)
	)
happyReduction_25 _ _  = notHappyAtAll 

happyReduce_26 = happySpecReduce_2  10# happyReduction_26
happyReduction_26 (HappyTerminal (TInteger happy_var_2))
	_
	 =  HappyAbsSyn10
		 (IsNumber happy_var_2
	)
happyReduction_26 _ _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_2  10# happyReduction_27
happyReduction_27 (HappyTerminal (TRegister happy_var_2))
	_
	 =  HappyAbsSyn10
		 (IsRegister happy_var_2
	)
happyReduction_27 _ _  = notHappyAtAll 

happyReduce_28 = happySpecReduce_2  10# happyReduction_28
happyReduction_28 (HappyAbsSyn9  happy_var_2)
	_
	 =  HappyAbsSyn10
		 (IsIdentifier happy_var_2
	)
happyReduction_28 _ _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_1  11# happyReduction_29
happyReduction_29 (HappyTerminal (TStringLiteral happy_var_1))
	 =  HappyAbsSyn11
		 (reverse happy_var_1
	)
happyReduction_29 _  = notHappyAtAll 

happyReduce_30 = happySpecReduce_1  11# happyReduction_30
happyReduction_30 (HappyTerminal (THexLiteral happy_var_1))
	 =  HappyAbsSyn11
		 ((chr happy_var_1) : []
	)
happyReduction_30 _  = notHappyAtAll 

happyReduce_31 = happySpecReduce_1  11# happyReduction_31
happyReduction_31 (HappyTerminal (TByteLiteral happy_var_1))
	 =  HappyAbsSyn11
		 (happy_var_1 : []
	)
happyReduction_31 _  = notHappyAtAll 

happyReduce_32 = happySpecReduce_3  11# happyReduction_32
happyReduction_32 (HappyTerminal (TStringLiteral happy_var_3))
	_
	(HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn11
		 ((reverse happy_var_3) ++ happy_var_1
	)
happyReduction_32 _ _ _  = notHappyAtAll 

happyReduce_33 = happySpecReduce_3  11# happyReduction_33
happyReduction_33 (HappyTerminal (TByteLiteral happy_var_3))
	_
	(HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn11
		 (happy_var_3 : happy_var_1
	)
happyReduction_33 _ _ _  = notHappyAtAll 

happyReduce_34 = happySpecReduce_3  11# happyReduction_34
happyReduction_34 (HappyTerminal (THexLiteral happy_var_3))
	_
	(HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn11
		 ((chr happy_var_3) : happy_var_1
	)
happyReduction_34 _ _ _  = notHappyAtAll 

happyReduce_35 = happySpecReduce_1  12# happyReduction_35
happyReduction_35 _
	 =  HappyAbsSyn12
		 (0x20000000
	)

happyReduce_36 = happySpecReduce_1  13# happyReduction_36
happyReduction_36 (HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn13
		 (happy_var_1
	)
happyReduction_36 _  = notHappyAtAll 

happyReduce_37 = happySpecReduce_3  13# happyReduction_37
happyReduction_37 (HappyAbsSyn14  happy_var_3)
	_
	(HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn13
		 (ExpressionPlus happy_var_1 happy_var_3
	)
happyReduction_37 _ _ _  = notHappyAtAll 

happyReduce_38 = happySpecReduce_3  13# happyReduction_38
happyReduction_38 (HappyAbsSyn14  happy_var_3)
	_
	(HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn13
		 (ExpressionMinus happy_var_1 happy_var_3
	)
happyReduction_38 _ _ _  = notHappyAtAll 

happyReduce_39 = happySpecReduce_1  14# happyReduction_39
happyReduction_39 (HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn14
		 (happy_var_1
	)
happyReduction_39 _  = notHappyAtAll 

happyReduce_40 = happySpecReduce_3  14# happyReduction_40
happyReduction_40 (HappyAbsSyn15  happy_var_3)
	_
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn14
		 (ExpressionMultiply happy_var_1 happy_var_3
	)
happyReduction_40 _ _ _  = notHappyAtAll 

happyReduce_41 = happySpecReduce_3  14# happyReduction_41
happyReduction_41 (HappyAbsSyn15  happy_var_3)
	_
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn14
		 (ExpressionDivide happy_var_1 happy_var_3
	)
happyReduction_41 _ _ _  = notHappyAtAll 

happyReduce_42 = happySpecReduce_1  15# happyReduction_42
happyReduction_42 (HappyTerminal (TInteger happy_var_1))
	 =  HappyAbsSyn15
		 (ExpressionNumber happy_var_1
	)
happyReduction_42 _  = notHappyAtAll 

happyReduce_43 = happySpecReduce_1  15# happyReduction_43
happyReduction_43 (HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn15
		 (ExpressionIdentifier happy_var_1
	)
happyReduction_43 _  = notHappyAtAll 

happyReduce_44 = happySpecReduce_1  15# happyReduction_44
happyReduction_44 (HappyTerminal (TByteLiteral happy_var_1))
	 =  HappyAbsSyn15
		 (ExpressionNumber (ord happy_var_1)
	)
happyReduction_44 _  = notHappyAtAll 

happyReduce_45 = happySpecReduce_1  15# happyReduction_45
happyReduction_45 _
	 =  HappyAbsSyn15
		 (ExpressionAT
	)

happyReduce_46 = happySpecReduce_1  15# happyReduction_46
happyReduction_46 (HappyTerminal (THexLiteral happy_var_1))
	 =  HappyAbsSyn15
		 (ExpressionNumber happy_var_1
	)
happyReduction_46 _  = notHappyAtAll 

happyReduce_47 = happySpecReduce_1  15# happyReduction_47
happyReduction_47 (HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn15
		 (ExpressionNumber happy_var_1
	)
happyReduction_47 _  = notHappyAtAll 

happyNewToken action sts stk
	= lexwrap(\tk -> 
	let cont i = action i i tk (HappyState action) sts stk in
	case tk of {
	LEOF -> action 46# 46# tk (HappyState action) sts stk;
	TOpCode happy_dollar_dollar -> cont 16#;
	TSet -> cont 17#;
	TComma -> cont 18#;
	THalt -> cont 19#;
	TFputS -> cont 20#;
	TStdOut -> cont 21#;
	TByteLiteral happy_dollar_dollar -> cont 22#;
	TIdentifier happy_dollar_dollar -> cont 23#;
	TRegister happy_dollar_dollar -> cont 24#;
	TInteger happy_dollar_dollar -> cont 25#;
	TLocalLabel happy_dollar_dollar -> cont 26#;
	TLocalForwardOperand happy_dollar_dollar -> cont 27#;
	TLocalBackwardOperand happy_dollar_dollar -> cont 28#;
	TLOC -> cont 29#;
	TIS -> cont 30#;
	TWyde -> cont 31#;
	TTetra -> cont 32#;
	TOcta -> cont 33#;
	TGREG -> cont 34#;
	TPlus -> cont 35#;
	TMinus -> cont 36#;
	TMult -> cont 37#;
	TDivide -> cont 38#;
	TAtSign -> cont 39#;
	TDataSegment -> cont 40#;
	TByte -> cont 41#;
	TStringLiteral happy_dollar_dollar -> cont 42#;
	THexLiteral happy_dollar_dollar -> cont 43#;
	TOpenParen -> cont 44#;
	TCloseParen -> cont 45#;
	_ -> happyError' tk
	})

happyError_ 46# tk = happyError' tk
happyError_ _ tk = happyError' tk

happyThen :: () => Alex a -> (a -> Alex b) -> Alex b
happyThen = (>>=)
happyReturn :: () => a -> Alex a
happyReturn = (return)
happyThen1 = happyThen
happyReturn1 :: () => a -> Alex a
happyReturn1 = happyReturn
happyError' :: () => (Token) -> Alex a
happyError' tk = parseError tk

parseFile = happySomeParser where
  happySomeParser = happyThen (happyParse action_0) (\x -> case x of {HappyAbsSyn4 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


data Line = PlainOpCodeLine { pocl_code :: Int, pocl_ops :: [OperatorElement], pocl_loc :: Int }
          | LabelledOpCodeLine { lpocl_code :: Int, lpocl_ops :: [OperatorElement], lpocl_ident :: Identifier, lpocl_loc :: Int }
          | PlainPILine { ppl_id :: PseudoInstruction, ppl_loc :: Int }
          | LabelledPILine { lppl_id :: PseudoInstruction, lppl_ident :: Identifier, lppl_loc :: Int }
          deriving (Eq, Show)

--                   | OPEN Expression CLOSE { [ExpressionClose] ++ $2 ++ [ExpressionOpen] }

data Identifier = Id String
                | LocalLabel Int
                deriving (Eq, Show, Ord)

data OperatorElement = ByteLiteral Char
               | PseudoCode Int
               | Register Char
               | Ident Identifier
               | LocalForward Int
               | LocalBackward Int
               | Expr ExpressionEntry
               deriving (Eq, Show)

data ExpressionEntry = ExpressionNumber Int
                        | ExpressionRegister Char Int
                        | ExpressionIdentifier Identifier
                        | ExpressionGV Int
                        | Expression
                        | ExpressionAT
                        | ExpressionPlus ExpressionEntry ExpressionEntry
                        | ExpressionMinus ExpressionEntry ExpressionEntry
                        | ExpressionMultiply ExpressionEntry ExpressionEntry
                        | ExpressionDivide ExpressionEntry ExpressionEntry
                        | ExpressionOpen
                        | ExpressionClose
                        deriving (Eq, Show)

data PseudoInstruction = LOC Int
                       | LocEx ExpressionEntry
                       | GregAuto
                       | GregSpecific Char
                       | GregEx ExpressionEntry
                       | ByteArray [Char]
                       | WydeArray [Char]
                       | TetraArray [Char]
                       | OctaArray [Char]
                       | IsRegister Int
                       | IsNumber Int
                       | IsIdentifier Identifier
                       | Set (OperatorElement, OperatorElement)
                       deriving (Eq, Show)

-- fullParse "/home/steveedmans/test.mms"
-- fullParse "/home/steveedmans/hail.mms"

defaultPlainOpCodeLine = PlainOpCodeLine { pocl_loc = -1 }
defaultLabelledOpCodeLine = LabelledOpCodeLine { lpocl_loc = -1 }
defaultPlainPILine = PlainPILine { ppl_loc = -1 }
defaultLabelledPILine = LabelledPILine { lppl_loc = -1 }

parseError m = alexError $ "WHY! " ++ show m

lexwrap :: (Token -> Alex a) -> Alex a
lexwrap cont = do
    token <- alexMonadScan
    cont token

fputs = PseudoCode 7

fullParse path = do
    contents <- readFile path
    print $ parseStr contents

parseStr str = runAlex str parseFile
{-# LINE 1 "templates/GenericTemplate.hs" #-}
{-# LINE 1 "templates/GenericTemplate.hs" #-}
{-# LINE 1 "<command-line>" #-}






# 1 "/usr/include/stdc-predef.h" 1 3 4

# 17 "/usr/include/stdc-predef.h" 3 4














# 1 "/usr/include/x86_64-linux-gnu/bits/predefs.h" 1 3 4

# 18 "/usr/include/x86_64-linux-gnu/bits/predefs.h" 3 4












# 31 "/usr/include/stdc-predef.h" 2 3 4








# 6 "<command-line>" 2
{-# LINE 1 "templates/GenericTemplate.hs" #-}
-- Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp 

{-# LINE 13 "templates/GenericTemplate.hs" #-}





#if __GLASGOW_HASKELL__ > 706
#define LT(n,m) ((Happy_GHC_Exts.tagToEnum# (n Happy_GHC_Exts.<# m)) :: Bool)
#define GTE(n,m) ((Happy_GHC_Exts.tagToEnum# (n Happy_GHC_Exts.>=# m)) :: Bool)
#define EQ(n,m) ((Happy_GHC_Exts.tagToEnum# (n Happy_GHC_Exts.==# m)) :: Bool)
#else
#define LT(n,m) (n Happy_GHC_Exts.<# m)
#define GTE(n,m) (n Happy_GHC_Exts.>=# m)
#define EQ(n,m) (n Happy_GHC_Exts.==# m)
#endif
{-# LINE 45 "templates/GenericTemplate.hs" #-}








{-# LINE 66 "templates/GenericTemplate.hs" #-}

{-# LINE 76 "templates/GenericTemplate.hs" #-}

{-# LINE 85 "templates/GenericTemplate.hs" #-}

infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is 1#, it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept 1# tk st sts (_ `HappyStk` ans `HappyStk` _) =
	happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
	(happyTcHack j ) (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action

{-# LINE 154 "templates/GenericTemplate.hs" #-}

-----------------------------------------------------------------------------
-- HappyState data type (not arrays)



newtype HappyState b c = HappyState
        (Happy_GHC_Exts.Int# ->                    -- token number
         Happy_GHC_Exts.Int# ->                    -- token number (yes, again)
         b ->                           -- token semantic value
         HappyState b c ->              -- current state
         [HappyState b c] ->            -- state stack
         c)



-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state 1# tk st sts stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (Happy_GHC_Exts.I# (i)) -> i }) in
--     trace "shifting the error token" $
     new_state i i tk (HappyState (new_state)) ((st):(sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state ((st):(sts)) ((HappyTerminal (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn 1# tk st sts stk
     = happyFail 1# tk st sts stk
happySpecReduce_0 nt fn j tk st@((HappyState (action))) sts stk
     = action nt j tk st ((st):(sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn 1# tk st sts stk
     = happyFail 1# tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@(((st@(HappyState (action))):(_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn 1# tk st sts stk
     = happyFail 1# tk st sts stk
happySpecReduce_2 nt fn j tk _ ((_):(sts@(((st@(HappyState (action))):(_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn 1# tk st sts stk
     = happyFail 1# tk st sts stk
happySpecReduce_3 nt fn j tk _ ((_):(((_):(sts@(((st@(HappyState (action))):(_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn 1# tk st sts stk
     = happyFail 1# tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k Happy_GHC_Exts.-# (1# :: Happy_GHC_Exts.Int#)) sts of
	 sts1@(((st1@(HappyState (action))):(_))) ->
        	let r = fn stk in  -- it doesn't hurt to always seq here...
       		happyDoSeq r (action nt j tk st1 sts1 r)

happyMonadReduce k nt fn 1# tk st sts stk
     = happyFail 1# tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> action nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn 1# tk st sts stk
     = happyFail 1# tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
         let drop_stk = happyDropStk k stk





             new_state = action

          in
          happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))

happyDrop 0# l = l
happyDrop n ((_):(t)) = happyDrop (n Happy_GHC_Exts.-# (1# :: Happy_GHC_Exts.Int#)) t

happyDropStk 0# l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n Happy_GHC_Exts.-# (1#::Happy_GHC_Exts.Int#)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction

{-# LINE 255 "templates/GenericTemplate.hs" #-}
happyGoto action j tk st = action j j tk (HappyState action)


-----------------------------------------------------------------------------
-- Error recovery (1# is the error token)

-- parse error if we are in recovery and we fail again
happyFail 1# tk old_st _ stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (Happy_GHC_Exts.I# (i)) -> i }) in
--	trace "failing" $ 
        happyError_ i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  1# tk old_st (((HappyState (action))):(sts)) 
						(saved_tok `HappyStk` _ `HappyStk` stk) =
--	trace ("discarding state, depth " ++ show (length stk))  $
	action 1# 1# tk (HappyState (action)) sts ((saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail  i tk (HappyState (action)) sts stk =
--      trace "entering error recovery" $
	action 1# 1# tk (HappyState (action)) sts ( (HappyErrorToken (Happy_GHC_Exts.I# (i))) `HappyStk` stk)

-- Internal happy errors:

notHappyAtAll :: a
notHappyAtAll = error "Internal Happy error\n"

-----------------------------------------------------------------------------
-- Hack to get the typechecker to accept our action functions


happyTcHack :: Happy_GHC_Exts.Int# -> a -> a
happyTcHack x y = y
{-# INLINE happyTcHack #-}


-----------------------------------------------------------------------------
-- Seq-ing.  If the --strict flag is given, then Happy emits 
--	happySeq = happyDoSeq
-- otherwise it emits
-- 	happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.

{-# LINE 321 "templates/GenericTemplate.hs" #-}
{-# NOINLINE happyShift #-}
{-# NOINLINE happySpecReduce_0 #-}
{-# NOINLINE happySpecReduce_1 #-}
{-# NOINLINE happySpecReduce_2 #-}
{-# NOINLINE happySpecReduce_3 #-}
{-# NOINLINE happyReduce #-}
{-# NOINLINE happyMonadReduce #-}
{-# NOINLINE happyGoto #-}
{-# NOINLINE happyFail #-}

-- end of Happy Template.
