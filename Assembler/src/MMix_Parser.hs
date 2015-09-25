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
action_2 (18#) = happyShift action_9
action_2 (24#) = happyShift action_10
action_2 (27#) = happyShift action_11
action_2 (30#) = happyShift action_12
action_2 (31#) = happyShift action_13
action_2 (32#) = happyShift action_14
action_2 (33#) = happyShift action_15
action_2 (34#) = happyShift action_16
action_2 (35#) = happyShift action_17
action_2 (45#) = happyShift action_18
action_2 (6#) = happyGoto action_4
action_2 (9#) = happyGoto action_5
action_2 (10#) = happyGoto action_6
action_2 x = happyTcHack x happyReduce_1

action_3 (50#) = happyAccept
action_3 x = happyTcHack x happyFail

action_4 x = happyTcHack x happyReduce_3

action_5 (16#) = happyShift action_57
action_5 (17#) = happyShift action_58
action_5 (18#) = happyShift action_9
action_5 (30#) = happyShift action_12
action_5 (31#) = happyShift action_13
action_5 (32#) = happyShift action_14
action_5 (33#) = happyShift action_15
action_5 (34#) = happyShift action_16
action_5 (35#) = happyShift action_17
action_5 (45#) = happyShift action_18
action_5 (10#) = happyGoto action_56
action_5 x = happyTcHack x happyFail

action_6 x = happyTcHack x happyReduce_7

action_7 (20#) = happyShift action_47
action_7 (21#) = happyShift action_48
action_7 (22#) = happyShift action_49
action_7 (23#) = happyShift action_28
action_7 (24#) = happyShift action_10
action_7 (25#) = happyShift action_50
action_7 (26#) = happyShift action_29
action_7 (27#) = happyShift action_11
action_7 (28#) = happyShift action_51
action_7 (29#) = happyShift action_52
action_7 (40#) = happyShift action_30
action_7 (41#) = happyShift action_31
action_7 (42#) = happyShift action_32
action_7 (43#) = happyShift action_33
action_7 (44#) = happyShift action_34
action_7 (47#) = happyShift action_35
action_7 (48#) = happyShift action_36
action_7 (7#) = happyGoto action_55
action_7 (8#) = happyGoto action_54
action_7 (9#) = happyGoto action_23
action_7 (12#) = happyGoto action_24
action_7 (13#) = happyGoto action_46
action_7 (14#) = happyGoto action_26
action_7 (15#) = happyGoto action_27
action_7 x = happyTcHack x happyFail

action_8 (20#) = happyShift action_47
action_8 (21#) = happyShift action_48
action_8 (22#) = happyShift action_49
action_8 (23#) = happyShift action_28
action_8 (24#) = happyShift action_10
action_8 (25#) = happyShift action_50
action_8 (26#) = happyShift action_29
action_8 (27#) = happyShift action_11
action_8 (28#) = happyShift action_51
action_8 (29#) = happyShift action_52
action_8 (40#) = happyShift action_30
action_8 (41#) = happyShift action_31
action_8 (42#) = happyShift action_32
action_8 (43#) = happyShift action_33
action_8 (44#) = happyShift action_34
action_8 (47#) = happyShift action_35
action_8 (48#) = happyShift action_36
action_8 (7#) = happyGoto action_53
action_8 (8#) = happyGoto action_54
action_8 (9#) = happyGoto action_23
action_8 (12#) = happyGoto action_24
action_8 (13#) = happyGoto action_46
action_8 (14#) = happyGoto action_26
action_8 (15#) = happyGoto action_27
action_8 x = happyTcHack x happyFail

action_9 (20#) = happyShift action_47
action_9 (21#) = happyShift action_48
action_9 (22#) = happyShift action_49
action_9 (23#) = happyShift action_28
action_9 (24#) = happyShift action_10
action_9 (25#) = happyShift action_50
action_9 (26#) = happyShift action_29
action_9 (27#) = happyShift action_11
action_9 (28#) = happyShift action_51
action_9 (29#) = happyShift action_52
action_9 (40#) = happyShift action_30
action_9 (41#) = happyShift action_31
action_9 (42#) = happyShift action_32
action_9 (43#) = happyShift action_33
action_9 (44#) = happyShift action_34
action_9 (47#) = happyShift action_35
action_9 (48#) = happyShift action_36
action_9 (8#) = happyGoto action_45
action_9 (9#) = happyGoto action_23
action_9 (12#) = happyGoto action_24
action_9 (13#) = happyGoto action_46
action_9 (14#) = happyGoto action_26
action_9 (15#) = happyGoto action_27
action_9 x = happyTcHack x happyFail

action_10 x = happyTcHack x happyReduce_19

action_11 x = happyTcHack x happyReduce_20

action_12 (23#) = happyShift action_28
action_12 (24#) = happyShift action_10
action_12 (26#) = happyShift action_29
action_12 (27#) = happyShift action_11
action_12 (40#) = happyShift action_30
action_12 (41#) = happyShift action_31
action_12 (42#) = happyShift action_32
action_12 (43#) = happyShift action_33
action_12 (44#) = happyShift action_34
action_12 (47#) = happyShift action_35
action_12 (48#) = happyShift action_36
action_12 (9#) = happyGoto action_23
action_12 (12#) = happyGoto action_24
action_12 (13#) = happyGoto action_44
action_12 (14#) = happyGoto action_26
action_12 (15#) = happyGoto action_27
action_12 x = happyTcHack x happyFail

action_13 (23#) = happyShift action_41
action_13 (24#) = happyShift action_10
action_13 (25#) = happyShift action_42
action_13 (26#) = happyShift action_43
action_13 (27#) = happyShift action_11
action_13 (9#) = happyGoto action_40
action_13 x = happyTcHack x happyFail

action_14 (23#) = happyShift action_20
action_14 (46#) = happyShift action_21
action_14 (47#) = happyShift action_22
action_14 (11#) = happyGoto action_39
action_14 x = happyTcHack x happyFail

action_15 (23#) = happyShift action_20
action_15 (46#) = happyShift action_21
action_15 (47#) = happyShift action_22
action_15 (11#) = happyGoto action_38
action_15 x = happyTcHack x happyFail

action_16 (23#) = happyShift action_20
action_16 (46#) = happyShift action_21
action_16 (47#) = happyShift action_22
action_16 (11#) = happyGoto action_37
action_16 x = happyTcHack x happyFail

action_17 (23#) = happyShift action_28
action_17 (24#) = happyShift action_10
action_17 (26#) = happyShift action_29
action_17 (27#) = happyShift action_11
action_17 (40#) = happyShift action_30
action_17 (41#) = happyShift action_31
action_17 (42#) = happyShift action_32
action_17 (43#) = happyShift action_33
action_17 (44#) = happyShift action_34
action_17 (47#) = happyShift action_35
action_17 (48#) = happyShift action_36
action_17 (9#) = happyGoto action_23
action_17 (12#) = happyGoto action_24
action_17 (13#) = happyGoto action_25
action_17 (14#) = happyGoto action_26
action_17 (15#) = happyGoto action_27
action_17 x = happyTcHack x happyFail

action_18 (23#) = happyShift action_20
action_18 (46#) = happyShift action_21
action_18 (47#) = happyShift action_22
action_18 (11#) = happyGoto action_19
action_18 x = happyTcHack x happyFail

action_19 (19#) = happyShift action_65
action_19 x = happyTcHack x happyReduce_24

action_20 x = happyTcHack x happyReduce_34

action_21 x = happyTcHack x happyReduce_32

action_22 x = happyTcHack x happyReduce_33

action_23 x = happyTcHack x happyReduce_49

action_24 x = happyTcHack x happyReduce_53

action_25 (36#) = happyShift action_62
action_25 (37#) = happyShift action_63
action_25 x = happyTcHack x happyReduce_22

action_26 (38#) = happyShift action_67
action_26 (39#) = happyShift action_68
action_26 x = happyTcHack x happyReduce_42

action_27 x = happyTcHack x happyReduce_45

action_28 x = happyTcHack x happyReduce_50

action_29 x = happyTcHack x happyReduce_48

action_30 x = happyTcHack x happyReduce_51

action_31 x = happyTcHack x happyReduce_38

action_32 x = happyTcHack x happyReduce_39

action_33 x = happyTcHack x happyReduce_40

action_34 x = happyTcHack x happyReduce_41

action_35 x = happyTcHack x happyReduce_52

action_36 (23#) = happyShift action_28
action_36 (24#) = happyShift action_10
action_36 (26#) = happyShift action_29
action_36 (27#) = happyShift action_11
action_36 (40#) = happyShift action_30
action_36 (41#) = happyShift action_31
action_36 (42#) = happyShift action_32
action_36 (43#) = happyShift action_33
action_36 (44#) = happyShift action_34
action_36 (47#) = happyShift action_35
action_36 (48#) = happyShift action_36
action_36 (9#) = happyGoto action_23
action_36 (12#) = happyGoto action_24
action_36 (13#) = happyGoto action_66
action_36 (14#) = happyGoto action_26
action_36 (15#) = happyGoto action_27
action_36 x = happyTcHack x happyFail

action_37 (19#) = happyShift action_65
action_37 x = happyTcHack x happyReduce_27

action_38 (19#) = happyShift action_65
action_38 x = happyTcHack x happyReduce_26

action_39 (19#) = happyShift action_65
action_39 x = happyTcHack x happyReduce_25

action_40 x = happyTcHack x happyReduce_31

action_41 x = happyTcHack x happyReduce_29

action_42 x = happyTcHack x happyReduce_30

action_43 x = happyTcHack x happyReduce_28

action_44 (36#) = happyShift action_62
action_44 (37#) = happyShift action_63
action_44 x = happyTcHack x happyReduce_21

action_45 (19#) = happyShift action_64
action_45 x = happyTcHack x happyFail

action_46 (36#) = happyShift action_62
action_46 (37#) = happyShift action_63
action_46 x = happyTcHack x happyReduce_18

action_47 x = happyTcHack x happyReduce_12

action_48 x = happyTcHack x happyReduce_13

action_49 x = happyTcHack x happyReduce_14

action_50 x = happyTcHack x happyReduce_15

action_51 x = happyTcHack x happyReduce_16

action_52 x = happyTcHack x happyReduce_17

action_53 (19#) = happyShift action_61
action_53 x = happyTcHack x happyReduce_8

action_54 x = happyTcHack x happyReduce_10

action_55 (19#) = happyShift action_61
action_55 x = happyTcHack x happyReduce_4

action_56 x = happyTcHack x happyReduce_5

action_57 (20#) = happyShift action_47
action_57 (21#) = happyShift action_48
action_57 (22#) = happyShift action_49
action_57 (23#) = happyShift action_28
action_57 (24#) = happyShift action_10
action_57 (25#) = happyShift action_50
action_57 (26#) = happyShift action_29
action_57 (27#) = happyShift action_11
action_57 (28#) = happyShift action_51
action_57 (29#) = happyShift action_52
action_57 (40#) = happyShift action_30
action_57 (41#) = happyShift action_31
action_57 (42#) = happyShift action_32
action_57 (43#) = happyShift action_33
action_57 (44#) = happyShift action_34
action_57 (47#) = happyShift action_35
action_57 (48#) = happyShift action_36
action_57 (7#) = happyGoto action_60
action_57 (8#) = happyGoto action_54
action_57 (9#) = happyGoto action_23
action_57 (12#) = happyGoto action_24
action_57 (13#) = happyGoto action_46
action_57 (14#) = happyGoto action_26
action_57 (15#) = happyGoto action_27
action_57 x = happyTcHack x happyFail

action_58 (20#) = happyShift action_47
action_58 (21#) = happyShift action_48
action_58 (22#) = happyShift action_49
action_58 (23#) = happyShift action_28
action_58 (24#) = happyShift action_10
action_58 (25#) = happyShift action_50
action_58 (26#) = happyShift action_29
action_58 (27#) = happyShift action_11
action_58 (28#) = happyShift action_51
action_58 (29#) = happyShift action_52
action_58 (40#) = happyShift action_30
action_58 (41#) = happyShift action_31
action_58 (42#) = happyShift action_32
action_58 (43#) = happyShift action_33
action_58 (44#) = happyShift action_34
action_58 (47#) = happyShift action_35
action_58 (48#) = happyShift action_36
action_58 (7#) = happyGoto action_59
action_58 (8#) = happyGoto action_54
action_58 (9#) = happyGoto action_23
action_58 (12#) = happyGoto action_24
action_58 (13#) = happyGoto action_46
action_58 (14#) = happyGoto action_26
action_58 (15#) = happyGoto action_27
action_58 x = happyTcHack x happyFail

action_59 (19#) = happyShift action_61
action_59 x = happyTcHack x happyReduce_9

action_60 (19#) = happyShift action_61
action_60 x = happyTcHack x happyReduce_6

action_61 (20#) = happyShift action_47
action_61 (21#) = happyShift action_48
action_61 (22#) = happyShift action_49
action_61 (23#) = happyShift action_28
action_61 (24#) = happyShift action_10
action_61 (25#) = happyShift action_50
action_61 (26#) = happyShift action_29
action_61 (27#) = happyShift action_11
action_61 (28#) = happyShift action_51
action_61 (29#) = happyShift action_52
action_61 (40#) = happyShift action_30
action_61 (41#) = happyShift action_31
action_61 (42#) = happyShift action_32
action_61 (43#) = happyShift action_33
action_61 (44#) = happyShift action_34
action_61 (47#) = happyShift action_35
action_61 (48#) = happyShift action_36
action_61 (8#) = happyGoto action_78
action_61 (9#) = happyGoto action_23
action_61 (12#) = happyGoto action_24
action_61 (13#) = happyGoto action_46
action_61 (14#) = happyGoto action_26
action_61 (15#) = happyGoto action_27
action_61 x = happyTcHack x happyFail

action_62 (23#) = happyShift action_28
action_62 (24#) = happyShift action_10
action_62 (26#) = happyShift action_29
action_62 (27#) = happyShift action_11
action_62 (40#) = happyShift action_30
action_62 (41#) = happyShift action_31
action_62 (42#) = happyShift action_32
action_62 (43#) = happyShift action_33
action_62 (44#) = happyShift action_34
action_62 (47#) = happyShift action_35
action_62 (48#) = happyShift action_36
action_62 (9#) = happyGoto action_23
action_62 (12#) = happyGoto action_24
action_62 (14#) = happyGoto action_77
action_62 (15#) = happyGoto action_27
action_62 x = happyTcHack x happyFail

action_63 (23#) = happyShift action_28
action_63 (24#) = happyShift action_10
action_63 (26#) = happyShift action_29
action_63 (27#) = happyShift action_11
action_63 (40#) = happyShift action_30
action_63 (41#) = happyShift action_31
action_63 (42#) = happyShift action_32
action_63 (43#) = happyShift action_33
action_63 (44#) = happyShift action_34
action_63 (47#) = happyShift action_35
action_63 (48#) = happyShift action_36
action_63 (9#) = happyGoto action_23
action_63 (12#) = happyGoto action_24
action_63 (14#) = happyGoto action_76
action_63 (15#) = happyGoto action_27
action_63 x = happyTcHack x happyFail

action_64 (20#) = happyShift action_47
action_64 (21#) = happyShift action_48
action_64 (22#) = happyShift action_49
action_64 (23#) = happyShift action_28
action_64 (24#) = happyShift action_10
action_64 (25#) = happyShift action_50
action_64 (26#) = happyShift action_29
action_64 (27#) = happyShift action_11
action_64 (28#) = happyShift action_51
action_64 (29#) = happyShift action_52
action_64 (40#) = happyShift action_30
action_64 (41#) = happyShift action_31
action_64 (42#) = happyShift action_32
action_64 (43#) = happyShift action_33
action_64 (44#) = happyShift action_34
action_64 (47#) = happyShift action_35
action_64 (48#) = happyShift action_36
action_64 (8#) = happyGoto action_75
action_64 (9#) = happyGoto action_23
action_64 (12#) = happyGoto action_24
action_64 (13#) = happyGoto action_46
action_64 (14#) = happyGoto action_26
action_64 (15#) = happyGoto action_27
action_64 x = happyTcHack x happyFail

action_65 (23#) = happyShift action_72
action_65 (46#) = happyShift action_73
action_65 (47#) = happyShift action_74
action_65 x = happyTcHack x happyFail

action_66 (36#) = happyShift action_62
action_66 (37#) = happyShift action_63
action_66 (49#) = happyShift action_71
action_66 x = happyTcHack x happyFail

action_67 (23#) = happyShift action_28
action_67 (24#) = happyShift action_10
action_67 (26#) = happyShift action_29
action_67 (27#) = happyShift action_11
action_67 (40#) = happyShift action_30
action_67 (41#) = happyShift action_31
action_67 (42#) = happyShift action_32
action_67 (43#) = happyShift action_33
action_67 (44#) = happyShift action_34
action_67 (47#) = happyShift action_35
action_67 (48#) = happyShift action_36
action_67 (9#) = happyGoto action_23
action_67 (12#) = happyGoto action_24
action_67 (15#) = happyGoto action_70
action_67 x = happyTcHack x happyFail

action_68 (23#) = happyShift action_28
action_68 (24#) = happyShift action_10
action_68 (26#) = happyShift action_29
action_68 (27#) = happyShift action_11
action_68 (40#) = happyShift action_30
action_68 (41#) = happyShift action_31
action_68 (42#) = happyShift action_32
action_68 (43#) = happyShift action_33
action_68 (44#) = happyShift action_34
action_68 (47#) = happyShift action_35
action_68 (48#) = happyShift action_36
action_68 (9#) = happyGoto action_23
action_68 (12#) = happyGoto action_24
action_68 (15#) = happyGoto action_69
action_68 x = happyTcHack x happyFail

action_69 x = happyTcHack x happyReduce_47

action_70 x = happyTcHack x happyReduce_46

action_71 x = happyTcHack x happyReduce_54

action_72 x = happyTcHack x happyReduce_36

action_73 x = happyTcHack x happyReduce_35

action_74 x = happyTcHack x happyReduce_37

action_75 x = happyTcHack x happyReduce_23

action_76 (38#) = happyShift action_67
action_76 (39#) = happyShift action_68
action_76 x = happyTcHack x happyReduce_44

action_77 (38#) = happyShift action_67
action_77 (39#) = happyShift action_68
action_77 x = happyTcHack x happyReduce_43

action_78 x = happyTcHack x happyReduce_11

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

happyReduce_8 = happySpecReduce_2  6# happyReduction_8
happyReduction_8 (HappyAbsSyn7  happy_var_2)
	(HappyTerminal (TOpCodeSimple happy_var_1))
	 =  HappyAbsSyn6
		 (defaultPlainOpCodeLine { pocl_code = happy_var_1, pocl_ops = (reverse happy_var_2), pocl_sim = True }
	)
happyReduction_8 _ _  = notHappyAtAll 

happyReduce_9 = happySpecReduce_3  6# happyReduction_9
happyReduction_9 (HappyAbsSyn7  happy_var_3)
	(HappyTerminal (TOpCodeSimple happy_var_2))
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn6
		 (defaultLabelledOpCodeLine { lpocl_code = happy_var_2, lpocl_ops = (reverse happy_var_3), lpocl_ident = happy_var_1, lpocl_sim = True }
	)
happyReduction_9 _ _ _  = notHappyAtAll 

happyReduce_10 = happySpecReduce_1  7# happyReduction_10
happyReduction_10 (HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn7
		 (happy_var_1 : []
	)
happyReduction_10 _  = notHappyAtAll 

happyReduce_11 = happySpecReduce_3  7# happyReduction_11
happyReduction_11 (HappyAbsSyn8  happy_var_3)
	_
	(HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn7
		 (happy_var_3 : happy_var_1
	)
happyReduction_11 _ _ _  = notHappyAtAll 

happyReduce_12 = happySpecReduce_1  8# happyReduction_12
happyReduction_12 _
	 =  HappyAbsSyn8
		 (PseudoCode 0
	)

happyReduce_13 = happySpecReduce_1  8# happyReduction_13
happyReduction_13 _
	 =  HappyAbsSyn8
		 (fputs
	)

happyReduce_14 = happySpecReduce_1  8# happyReduction_14
happyReduction_14 _
	 =  HappyAbsSyn8
		 (PseudoCode 1
	)

happyReduce_15 = happySpecReduce_1  8# happyReduction_15
happyReduction_15 (HappyTerminal (TRegister happy_var_1))
	 =  HappyAbsSyn8
		 (Register (chr happy_var_1)
	)
happyReduction_15 _  = notHappyAtAll 

happyReduce_16 = happySpecReduce_1  8# happyReduction_16
happyReduction_16 (HappyTerminal (TLocalForwardOperand happy_var_1))
	 =  HappyAbsSyn8
		 (LocalForward happy_var_1
	)
happyReduction_16 _  = notHappyAtAll 

happyReduce_17 = happySpecReduce_1  8# happyReduction_17
happyReduction_17 (HappyTerminal (TLocalBackwardOperand happy_var_1))
	 =  HappyAbsSyn8
		 (LocalBackward happy_var_1
	)
happyReduction_17 _  = notHappyAtAll 

happyReduce_18 = happySpecReduce_1  8# happyReduction_18
happyReduction_18 (HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn8
		 (Expr happy_var_1
	)
happyReduction_18 _  = notHappyAtAll 

happyReduce_19 = happySpecReduce_1  9# happyReduction_19
happyReduction_19 (HappyTerminal (TIdentifier happy_var_1))
	 =  HappyAbsSyn9
		 (Id happy_var_1
	)
happyReduction_19 _  = notHappyAtAll 

happyReduce_20 = happySpecReduce_1  9# happyReduction_20
happyReduction_20 (HappyTerminal (TLocalLabel happy_var_1))
	 =  HappyAbsSyn9
		 (LocalLabel happy_var_1
	)
happyReduction_20 _  = notHappyAtAll 

happyReduce_21 = happySpecReduce_2  10# happyReduction_21
happyReduction_21 (HappyAbsSyn13  happy_var_2)
	_
	 =  HappyAbsSyn10
		 (LocEx happy_var_2
	)
happyReduction_21 _ _  = notHappyAtAll 

happyReduce_22 = happySpecReduce_2  10# happyReduction_22
happyReduction_22 (HappyAbsSyn13  happy_var_2)
	_
	 =  HappyAbsSyn10
		 (GregEx happy_var_2
	)
happyReduction_22 _ _  = notHappyAtAll 

happyReduce_23 = happyReduce 4# 10# happyReduction_23
happyReduction_23 ((HappyAbsSyn8  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn8  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (Set (happy_var_2, happy_var_4)
	) `HappyStk` happyRest

happyReduce_24 = happySpecReduce_2  10# happyReduction_24
happyReduction_24 (HappyAbsSyn11  happy_var_2)
	_
	 =  HappyAbsSyn10
		 (ByteArray (reverse happy_var_2)
	)
happyReduction_24 _ _  = notHappyAtAll 

happyReduce_25 = happySpecReduce_2  10# happyReduction_25
happyReduction_25 (HappyAbsSyn11  happy_var_2)
	_
	 =  HappyAbsSyn10
		 (WydeArray (reverse happy_var_2)
	)
happyReduction_25 _ _  = notHappyAtAll 

happyReduce_26 = happySpecReduce_2  10# happyReduction_26
happyReduction_26 (HappyAbsSyn11  happy_var_2)
	_
	 =  HappyAbsSyn10
		 (TetraArray (reverse happy_var_2)
	)
happyReduction_26 _ _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_2  10# happyReduction_27
happyReduction_27 (HappyAbsSyn11  happy_var_2)
	_
	 =  HappyAbsSyn10
		 (OctaArray (reverse happy_var_2)
	)
happyReduction_27 _ _  = notHappyAtAll 

happyReduce_28 = happySpecReduce_2  10# happyReduction_28
happyReduction_28 (HappyTerminal (TInteger happy_var_2))
	_
	 =  HappyAbsSyn10
		 (IsNumber happy_var_2
	)
happyReduction_28 _ _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_2  10# happyReduction_29
happyReduction_29 (HappyTerminal (TByteLiteral happy_var_2))
	_
	 =  HappyAbsSyn10
		 (IsNumber (ord happy_var_2)
	)
happyReduction_29 _ _  = notHappyAtAll 

happyReduce_30 = happySpecReduce_2  10# happyReduction_30
happyReduction_30 (HappyTerminal (TRegister happy_var_2))
	_
	 =  HappyAbsSyn10
		 (IsRegister happy_var_2
	)
happyReduction_30 _ _  = notHappyAtAll 

happyReduce_31 = happySpecReduce_2  10# happyReduction_31
happyReduction_31 (HappyAbsSyn9  happy_var_2)
	_
	 =  HappyAbsSyn10
		 (IsIdentifier happy_var_2
	)
happyReduction_31 _ _  = notHappyAtAll 

happyReduce_32 = happySpecReduce_1  11# happyReduction_32
happyReduction_32 (HappyTerminal (TStringLiteral happy_var_1))
	 =  HappyAbsSyn11
		 (reverse happy_var_1
	)
happyReduction_32 _  = notHappyAtAll 

happyReduce_33 = happySpecReduce_1  11# happyReduction_33
happyReduction_33 (HappyTerminal (THexLiteral happy_var_1))
	 =  HappyAbsSyn11
		 ((chr happy_var_1) : []
	)
happyReduction_33 _  = notHappyAtAll 

happyReduce_34 = happySpecReduce_1  11# happyReduction_34
happyReduction_34 (HappyTerminal (TByteLiteral happy_var_1))
	 =  HappyAbsSyn11
		 (happy_var_1 : []
	)
happyReduction_34 _  = notHappyAtAll 

happyReduce_35 = happySpecReduce_3  11# happyReduction_35
happyReduction_35 (HappyTerminal (TStringLiteral happy_var_3))
	_
	(HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn11
		 ((reverse happy_var_3) ++ happy_var_1
	)
happyReduction_35 _ _ _  = notHappyAtAll 

happyReduce_36 = happySpecReduce_3  11# happyReduction_36
happyReduction_36 (HappyTerminal (TByteLiteral happy_var_3))
	_
	(HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn11
		 (happy_var_3 : happy_var_1
	)
happyReduction_36 _ _ _  = notHappyAtAll 

happyReduce_37 = happySpecReduce_3  11# happyReduction_37
happyReduction_37 (HappyTerminal (THexLiteral happy_var_3))
	_
	(HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn11
		 ((chr happy_var_3) : happy_var_1
	)
happyReduction_37 _ _ _  = notHappyAtAll 

happyReduce_38 = happySpecReduce_1  12# happyReduction_38
happyReduction_38 _
	 =  HappyAbsSyn12
		 (0x0000000000000000
	)

happyReduce_39 = happySpecReduce_1  12# happyReduction_39
happyReduction_39 _
	 =  HappyAbsSyn12
		 (0x2000000000000000
	)

happyReduce_40 = happySpecReduce_1  12# happyReduction_40
happyReduction_40 _
	 =  HappyAbsSyn12
		 (0x4000000000000000
	)

happyReduce_41 = happySpecReduce_1  12# happyReduction_41
happyReduction_41 _
	 =  HappyAbsSyn12
		 (0x6000000000000000
	)

happyReduce_42 = happySpecReduce_1  13# happyReduction_42
happyReduction_42 (HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn13
		 (happy_var_1
	)
happyReduction_42 _  = notHappyAtAll 

happyReduce_43 = happySpecReduce_3  13# happyReduction_43
happyReduction_43 (HappyAbsSyn14  happy_var_3)
	_
	(HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn13
		 (ExpressionPlus happy_var_1 happy_var_3
	)
happyReduction_43 _ _ _  = notHappyAtAll 

happyReduce_44 = happySpecReduce_3  13# happyReduction_44
happyReduction_44 (HappyAbsSyn14  happy_var_3)
	_
	(HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn13
		 (ExpressionMinus happy_var_1 happy_var_3
	)
happyReduction_44 _ _ _  = notHappyAtAll 

happyReduce_45 = happySpecReduce_1  14# happyReduction_45
happyReduction_45 (HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn14
		 (happy_var_1
	)
happyReduction_45 _  = notHappyAtAll 

happyReduce_46 = happySpecReduce_3  14# happyReduction_46
happyReduction_46 (HappyAbsSyn15  happy_var_3)
	_
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn14
		 (ExpressionMultiply happy_var_1 happy_var_3
	)
happyReduction_46 _ _ _  = notHappyAtAll 

happyReduce_47 = happySpecReduce_3  14# happyReduction_47
happyReduction_47 (HappyAbsSyn15  happy_var_3)
	_
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn14
		 (ExpressionDivide happy_var_1 happy_var_3
	)
happyReduction_47 _ _ _  = notHappyAtAll 

happyReduce_48 = happySpecReduce_1  15# happyReduction_48
happyReduction_48 (HappyTerminal (TInteger happy_var_1))
	 =  HappyAbsSyn15
		 (ExpressionNumber happy_var_1
	)
happyReduction_48 _  = notHappyAtAll 

happyReduce_49 = happySpecReduce_1  15# happyReduction_49
happyReduction_49 (HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn15
		 (ExpressionIdentifier happy_var_1
	)
happyReduction_49 _  = notHappyAtAll 

happyReduce_50 = happySpecReduce_1  15# happyReduction_50
happyReduction_50 (HappyTerminal (TByteLiteral happy_var_1))
	 =  HappyAbsSyn15
		 (ExpressionNumber (ord happy_var_1)
	)
happyReduction_50 _  = notHappyAtAll 

happyReduce_51 = happySpecReduce_1  15# happyReduction_51
happyReduction_51 _
	 =  HappyAbsSyn15
		 (ExpressionAT
	)

happyReduce_52 = happySpecReduce_1  15# happyReduction_52
happyReduction_52 (HappyTerminal (THexLiteral happy_var_1))
	 =  HappyAbsSyn15
		 (ExpressionNumber happy_var_1
	)
happyReduction_52 _  = notHappyAtAll 

happyReduce_53 = happySpecReduce_1  15# happyReduction_53
happyReduction_53 (HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn15
		 (ExpressionNumber happy_var_1
	)
happyReduction_53 _  = notHappyAtAll 

happyReduce_54 = happySpecReduce_3  15# happyReduction_54
happyReduction_54 _
	(HappyAbsSyn13  happy_var_2)
	_
	 =  HappyAbsSyn15
		 (happy_var_2
	)
happyReduction_54 _ _ _  = notHappyAtAll 

happyNewToken action sts stk
	= lexwrap(\tk -> 
	let cont i = action i i tk (HappyState action) sts stk in
	case tk of {
	LEOF -> action 50# 50# tk (HappyState action) sts stk;
	TOpCode happy_dollar_dollar -> cont 16#;
	TOpCodeSimple happy_dollar_dollar -> cont 17#;
	TSet -> cont 18#;
	TComma -> cont 19#;
	THalt -> cont 20#;
	TFputS -> cont 21#;
	TStdOut -> cont 22#;
	TByteLiteral happy_dollar_dollar -> cont 23#;
	TIdentifier happy_dollar_dollar -> cont 24#;
	TRegister happy_dollar_dollar -> cont 25#;
	TInteger happy_dollar_dollar -> cont 26#;
	TLocalLabel happy_dollar_dollar -> cont 27#;
	TLocalForwardOperand happy_dollar_dollar -> cont 28#;
	TLocalBackwardOperand happy_dollar_dollar -> cont 29#;
	TLOC -> cont 30#;
	TIS -> cont 31#;
	TWyde -> cont 32#;
	TTetra -> cont 33#;
	TOcta -> cont 34#;
	TGREG -> cont 35#;
	TPlus -> cont 36#;
	TMinus -> cont 37#;
	TMult -> cont 38#;
	TDivide -> cont 39#;
	TAtSign -> cont 40#;
	TTextSegment -> cont 41#;
	TDataSegment -> cont 42#;
	TPoolSegment -> cont 43#;
	TStackSegment -> cont 44#;
	TByte -> cont 45#;
	TStringLiteral happy_dollar_dollar -> cont 46#;
	THexLiteral happy_dollar_dollar -> cont 47#;
	TOpenParen -> cont 48#;
	TCloseParen -> cont 49#;
	_ -> happyError' tk
	})

happyError_ 50# tk = happyError' tk
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


data Line = PlainOpCodeLine { pocl_code :: Int, pocl_ops :: [OperatorElement], pocl_loc :: Int, pocl_sim :: Bool }
          | LabelledOpCodeLine { lpocl_code :: Int, lpocl_ops :: [OperatorElement], lpocl_ident :: Identifier, lpocl_loc :: Int, lpocl_sim :: Bool }
          | PlainPILine { ppl_id :: PseudoInstruction, ppl_loc :: Int }
          | LabelledPILine { lppl_id :: PseudoInstruction, lppl_ident :: Identifier, lppl_loc :: Int }
          deriving (Eq, Show)

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
                        | ExpressionRegister Char ExpressionEntry
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

defaultPlainOpCodeLine = PlainOpCodeLine { pocl_loc = -1, pocl_sim = False }
defaultLabelledOpCodeLine = LabelledOpCodeLine { lpocl_loc = -1, lpocl_sim = False }
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
