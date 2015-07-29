{-# OPTIONS_GHC -w #-}
{-# OPTIONS -fglasgow-exts -cpp #-}
module MMix_Parser where

import Data.Char
import MMix_Lexer
import qualified Data.Array as Happy_Data_Array
import qualified GHC.Exts as Happy_GHC_Exts
import qualified System.IO as Happy_System_IO
import qualified System.IO.Unsafe as Happy_System_IO_Unsafe
import qualified Debug.Trace as Happy_Debug_Trace

-- parser produced by Happy Version 1.19.0

data HappyAbsSyn t4 t5 t7 t8 t9 t10 t11 t12 t13 t14
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

happyActOffsets :: HappyAddr
happyActOffsets = HappyA# "\x00\x00\x00\x00\x21\x00\x63\x00\x00\x00\x00\x00\x4b\x00\x4b\x00\x31\x00\x2d\x00\x65\x00\x0d\x00\xff\xff\xfe\xff\x46\x00\x5f\x00\x79\x00\x00\x00\x00\x00\x58\x00\x11\x00\x00\x00\x01\x00\x79\x00\x00\x00\x79\x00\x00\x00\x79\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x58\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4b\x00\x78\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x77\x00\x4b\x00\x4b\x00\x00\x00\x00\x00\x44\x00\x42\x00\x32\x00\x2f\x00\xfd\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x76\x00\x75\x00\x4b\x00\x00\x00\x00\x00"#

happyGotoOffsets :: HappyAddr
happyGotoOffsets = HappyA# "\x5d\x00\x74\x00\x53\x00\x00\x00\x00\x00\x00\x00\x62\x00\x6d\x00\x6f\x00\x56\x00\x6e\x00\x50\x00\x4e\x00\x3d\x00\x20\x00\x1f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x5e\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x6b\x00\x05\x00\x00\x00\x00\x00\x35\x00\x1e\x00\x14\x00\xfb\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00"#

happyDefActions :: HappyAddr
happyDefActions = HappyA# "\xfd\xff\x00\x00\xfe\xff\x00\x00\xfc\xff\xf6\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe5\xff\xdb\xff\xd7\xff\xe7\xff\xd6\xff\xed\xff\xd5\xff\xe0\xff\xdf\xff\xe2\xff\xe1\xff\xe4\xff\xe3\xff\xdc\xff\xdd\xff\xde\xff\xec\xff\xea\xff\xd6\xff\xd5\xff\xd8\xff\xeb\xff\xf9\xff\x00\x00\x00\x00\xee\xff\xf2\xff\xf1\xff\xf0\xff\xf3\xff\xef\xff\xfa\xff\xfb\xff\x00\x00\x00\x00\x00\x00\xf7\xff\xf8\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xd9\xff\xda\xff\xca\xff\xcb\xff\xc9\xff\xcd\xff\xce\xff\xcc\xff\xd0\xff\xd1\xff\xcf\xff\xd3\xff\xd4\xff\xd2\xff\xe6\xff\x00\x00\xf4\xff\x00\x00\xf5\xff"#

happyCheck :: HappyAddr
happyCheck = HappyA# "\xff\xff\x06\x00\x01\x00\x02\x00\x07\x00\x07\x00\x07\x00\x05\x00\x06\x00\x08\x00\x05\x00\x06\x00\x0b\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x01\x00\x02\x00\x07\x00\x18\x00\x18\x00\x18\x00\x17\x00\x08\x00\x06\x00\x1a\x00\x0b\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x01\x00\x02\x00\x06\x00\x18\x00\x06\x00\x08\x00\x17\x00\x08\x00\x0a\x00\x1a\x00\x0b\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x01\x00\x02\x00\x07\x00\x08\x00\x07\x00\x08\x00\x17\x00\x07\x00\x08\x00\x06\x00\x0b\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x15\x00\x16\x00\x15\x00\x08\x00\x19\x00\x15\x00\x17\x00\x07\x00\x08\x00\x07\x00\x08\x00\x07\x00\x08\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x09\x00\x02\x00\x08\x00\x15\x00\x08\x00\x15\x00\x07\x00\x15\x00\x06\x00\x00\x00\x01\x00\x09\x00\x0a\x00\x03\x00\x04\x00\x05\x00\x06\x00\x03\x00\x04\x00\x05\x00\x06\x00\x11\x00\x12\x00\x13\x00\x14\x00\x08\x00\x09\x00\x0a\x00\x05\x00\x06\x00\x05\x00\x06\x00\x06\x00\x01\x00\x07\x00\x18\x00\x03\x00\x03\x00\x03\x00\x03\x00\x03\x00\x1a\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff"#

happyTable :: HappyAddr
happyTable = HappyA# "\x00\x00\x3d\x00\xd5\xff\xd5\xff\x3c\x00\x19\x00\x1b\x00\x4d\x00\x29\x00\xd5\xff\x49\x00\x29\x00\xd5\xff\xd5\xff\xd5\xff\xd5\xff\xd5\xff\xd5\xff\xd6\xff\xd6\xff\x1d\x00\x3d\x00\x12\x00\x12\x00\xd5\xff\xd6\xff\x40\x00\xd5\xff\xd6\xff\xd6\xff\xd6\xff\xd6\xff\xd6\xff\xd6\xff\x07\x00\x08\x00\x43\x00\x12\x00\x12\x00\x10\x00\xd6\xff\x09\x00\x13\x00\xd6\xff\x0a\x00\x0b\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x28\x00\x08\x00\x23\x00\x16\x00\x3f\x00\x16\x00\x10\x00\x42\x00\x16\x00\x46\x00\x0a\x00\x0b\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x24\x00\x25\x00\x40\x00\x17\x00\x26\x00\x43\x00\x10\x00\x45\x00\x16\x00\x48\x00\x16\x00\x15\x00\x16\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x16\x00\x2f\x00\x04\x00\x19\x00\x46\x00\x1b\x00\x49\x00\x05\x00\x17\x00\x12\x00\x03\x00\x02\x00\x20\x00\x21\x00\x34\x00\x35\x00\x31\x00\x29\x00\x2f\x00\x30\x00\x31\x00\x29\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x16\x00\x1f\x00\x20\x00\x4a\x00\x4b\x00\x28\x00\x29\x00\x1d\x00\x02\x00\x26\x00\x12\x00\xee\xff\x4d\x00\x33\x00\x34\x00\x3b\x00\xff\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"#

happyReduceArr = Happy_Data_Array.array (1, 54) [
	(1 , happyReduce_1),
	(2 , happyReduce_2),
	(3 , happyReduce_3),
	(4 , happyReduce_4),
	(5 , happyReduce_5),
	(6 , happyReduce_6),
	(7 , happyReduce_7),
	(8 , happyReduce_8),
	(9 , happyReduce_9),
	(10 , happyReduce_10),
	(11 , happyReduce_11),
	(12 , happyReduce_12),
	(13 , happyReduce_13),
	(14 , happyReduce_14),
	(15 , happyReduce_15),
	(16 , happyReduce_16),
	(17 , happyReduce_17),
	(18 , happyReduce_18),
	(19 , happyReduce_19),
	(20 , happyReduce_20),
	(21 , happyReduce_21),
	(22 , happyReduce_22),
	(23 , happyReduce_23),
	(24 , happyReduce_24),
	(25 , happyReduce_25),
	(26 , happyReduce_26),
	(27 , happyReduce_27),
	(28 , happyReduce_28),
	(29 , happyReduce_29),
	(30 , happyReduce_30),
	(31 , happyReduce_31),
	(32 , happyReduce_32),
	(33 , happyReduce_33),
	(34 , happyReduce_34),
	(35 , happyReduce_35),
	(36 , happyReduce_36),
	(37 , happyReduce_37),
	(38 , happyReduce_38),
	(39 , happyReduce_39),
	(40 , happyReduce_40),
	(41 , happyReduce_41),
	(42 , happyReduce_42),
	(43 , happyReduce_43),
	(44 , happyReduce_44),
	(45 , happyReduce_45),
	(46 , happyReduce_46),
	(47 , happyReduce_47),
	(48 , happyReduce_48),
	(49 , happyReduce_49),
	(50 , happyReduce_50),
	(51 , happyReduce_51),
	(52 , happyReduce_52),
	(53 , happyReduce_53),
	(54 , happyReduce_54)
	]

happy_n_terms = 27 :: Int
happy_n_nonterms = 11 :: Int

happyReduce_1 = happySpecReduce_1  0# happyReduction_1
happyReduction_1 (HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn4
		 (reverse happy_var_1
	)
happyReduction_1 _  = notHappyAtAll 

happyReduce_2 = happySpecReduce_0  1# happyReduction_2
happyReduction_2  =  HappyAbsSyn5
		 ([]
	)

happyReduce_3 = happySpecReduce_2  1# happyReduction_3
happyReduction_3 (HappyAbsSyn6  happy_var_2)
	(HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn5
		 (happy_var_2 : happy_var_1
	)
happyReduction_3 _ _  = notHappyAtAll 

happyReduce_4 = happySpecReduce_2  2# happyReduction_4
happyReduction_4 (HappyAbsSyn8  happy_var_2)
	(HappyTerminal (TOpCode happy_var_1))
	 =  HappyAbsSyn6
		 (defaultPlainOpCodeLine { pocl_code = (happy_var_1 + 1), pocl_ops = happy_var_2 }
	)
happyReduction_4 _ _  = notHappyAtAll 

happyReduce_5 = happySpecReduce_2  2# happyReduction_5
happyReduction_5 (HappyAbsSyn7  happy_var_2)
	(HappyTerminal (TOpCode happy_var_1))
	 =  HappyAbsSyn6
		 (defaultPlainOpCodeLine { pocl_code = happy_var_1, pocl_ops = happy_var_2 }
	)
happyReduction_5 _ _  = notHappyAtAll 

happyReduce_6 = happySpecReduce_2  2# happyReduction_6
happyReduction_6 (HappyAbsSyn11  happy_var_2)
	(HappyTerminal (TIdentifier happy_var_1))
	 =  HappyAbsSyn6
		 (defaultLabelledPILine { lppl_id = happy_var_2, lppl_ident = happy_var_1 }
	)
happyReduction_6 _ _  = notHappyAtAll 

happyReduce_7 = happySpecReduce_3  2# happyReduction_7
happyReduction_7 (HappyAbsSyn8  happy_var_3)
	(HappyTerminal (TOpCode happy_var_2))
	(HappyTerminal (TIdentifier happy_var_1))
	 =  HappyAbsSyn6
		 (defaultLabelledOpCodeLine { lpocl_code = (happy_var_2 + 1), lpocl_ops = happy_var_3, lpocl_ident = happy_var_1}
	)
happyReduction_7 _ _ _  = notHappyAtAll 

happyReduce_8 = happySpecReduce_3  2# happyReduction_8
happyReduction_8 (HappyAbsSyn7  happy_var_3)
	(HappyTerminal (TOpCode happy_var_2))
	(HappyTerminal (TIdentifier happy_var_1))
	 =  HappyAbsSyn6
		 (defaultLabelledOpCodeLine { lpocl_code = happy_var_2, lpocl_ops = happy_var_3, lpocl_ident = happy_var_1}
	)
happyReduction_8 _ _ _  = notHappyAtAll 

happyReduce_9 = happySpecReduce_1  2# happyReduction_9
happyReduction_9 (HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn6
		 (defaultPlainPILine { ppl_id = happy_var_1 }
	)
happyReduction_9 _  = notHappyAtAll 

happyReduce_10 = happyReduce 5# 3# happyReduction_10
happyReduction_10 ((HappyAbsSyn9  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn9  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn9  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn7
		 (ListElements happy_var_1 happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_11 = happySpecReduce_3  4# happyReduction_11
happyReduction_11 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn8
		 (ListElementId happy_var_1 happy_var_3
	)
happyReduction_11 _ _ _  = notHappyAtAll 

happyReduce_12 = happySpecReduce_1  5# happyReduction_12
happyReduction_12 (HappyTerminal (TByteLiteral happy_var_1))
	 =  HappyAbsSyn9
		 (ByteLiteral happy_var_1
	)
happyReduction_12 _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_1  5# happyReduction_13
happyReduction_13 _
	 =  HappyAbsSyn9
		 (PseudoCode 0
	)

happyReduce_14 = happySpecReduce_1  5# happyReduction_14
happyReduction_14 _
	 =  HappyAbsSyn9
		 (fputs
	)

happyReduce_15 = happySpecReduce_1  5# happyReduction_15
happyReduction_15 _
	 =  HappyAbsSyn9
		 (PseudoCode 1
	)

happyReduce_16 = happySpecReduce_1  5# happyReduction_16
happyReduction_16 (HappyTerminal (TRegister happy_var_1))
	 =  HappyAbsSyn9
		 (Register happy_var_1
	)
happyReduction_16 _  = notHappyAtAll 

happyReduce_17 = happySpecReduce_1  5# happyReduction_17
happyReduction_17 (HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn9
		 (Ident happy_var_1
	)
happyReduction_17 _  = notHappyAtAll 

happyReduce_18 = happySpecReduce_1  6# happyReduction_18
happyReduction_18 (HappyTerminal (TIdentifier happy_var_1))
	 =  HappyAbsSyn10
		 (Id happy_var_1
	)
happyReduction_18 _  = notHappyAtAll 

happyReduce_19 = happySpecReduce_2  7# happyReduction_19
happyReduction_19 (HappyAbsSyn13  happy_var_2)
	_
	 =  HappyAbsSyn11
		 (LOC happy_var_2
	)
happyReduction_19 _ _  = notHappyAtAll 

happyReduce_20 = happySpecReduce_2  7# happyReduction_20
happyReduction_20 (HappyTerminal (THexLiteral happy_var_2))
	_
	 =  HappyAbsSyn11
		 (LOC happy_var_2
	)
happyReduction_20 _ _  = notHappyAtAll 

happyReduce_21 = happySpecReduce_2  7# happyReduction_21
happyReduction_21 (HappyAbsSyn14  happy_var_2)
	_
	 =  HappyAbsSyn11
		 (LocEx happy_var_2
	)
happyReduction_21 _ _  = notHappyAtAll 

happyReduce_22 = happySpecReduce_2  7# happyReduction_22
happyReduction_22 _
	_
	 =  HappyAbsSyn11
		 (GregAuto
	)

happyReduce_23 = happySpecReduce_2  7# happyReduction_23
happyReduction_23 (HappyTerminal (TByteLiteral happy_var_2))
	_
	 =  HappyAbsSyn11
		 (GregSpecific happy_var_2
	)
happyReduction_23 _ _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_2  7# happyReduction_24
happyReduction_24 (HappyAbsSyn14  happy_var_2)
	_
	 =  HappyAbsSyn11
		 (GregEx happy_var_2
	)
happyReduction_24 _ _  = notHappyAtAll 

happyReduce_25 = happyReduce 4# 7# happyReduction_25
happyReduction_25 ((HappyAbsSyn9  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn9  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn11
		 (Set (happy_var_2, happy_var_4)
	) `HappyStk` happyRest

happyReduce_26 = happySpecReduce_2  7# happyReduction_26
happyReduction_26 (HappyAbsSyn12  happy_var_2)
	_
	 =  HappyAbsSyn11
		 (ByteArray (reverse happy_var_2)
	)
happyReduction_26 _ _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_2  7# happyReduction_27
happyReduction_27 (HappyAbsSyn12  happy_var_2)
	_
	 =  HappyAbsSyn11
		 (WydeArray (reverse happy_var_2)
	)
happyReduction_27 _ _  = notHappyAtAll 

happyReduce_28 = happySpecReduce_2  7# happyReduction_28
happyReduction_28 (HappyTerminal (TByteLiteral happy_var_2))
	_
	 =  HappyAbsSyn11
		 (WydeArray [happy_var_2]
	)
happyReduction_28 _ _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_2  7# happyReduction_29
happyReduction_29 (HappyAbsSyn12  happy_var_2)
	_
	 =  HappyAbsSyn11
		 (TetraArray (reverse happy_var_2)
	)
happyReduction_29 _ _  = notHappyAtAll 

happyReduce_30 = happySpecReduce_2  7# happyReduction_30
happyReduction_30 (HappyTerminal (TByteLiteral happy_var_2))
	_
	 =  HappyAbsSyn11
		 (TetraArray [happy_var_2]
	)
happyReduction_30 _ _  = notHappyAtAll 

happyReduce_31 = happySpecReduce_2  7# happyReduction_31
happyReduction_31 (HappyAbsSyn12  happy_var_2)
	_
	 =  HappyAbsSyn11
		 (OctaArray (reverse happy_var_2)
	)
happyReduction_31 _ _  = notHappyAtAll 

happyReduce_32 = happySpecReduce_2  7# happyReduction_32
happyReduction_32 (HappyTerminal (TByteLiteral happy_var_2))
	_
	 =  HappyAbsSyn11
		 (OctaArray [happy_var_2]
	)
happyReduction_32 _ _  = notHappyAtAll 

happyReduce_33 = happySpecReduce_2  7# happyReduction_33
happyReduction_33 (HappyTerminal (TInteger happy_var_2))
	_
	 =  HappyAbsSyn11
		 (IsNumber happy_var_2
	)
happyReduction_33 _ _  = notHappyAtAll 

happyReduce_34 = happySpecReduce_2  7# happyReduction_34
happyReduction_34 (HappyTerminal (TRegister happy_var_2))
	_
	 =  HappyAbsSyn11
		 (IsRegister happy_var_2
	)
happyReduction_34 _ _  = notHappyAtAll 

happyReduce_35 = happySpecReduce_2  7# happyReduction_35
happyReduction_35 (HappyAbsSyn10  happy_var_2)
	_
	 =  HappyAbsSyn11
		 (IsIdentifier happy_var_2
	)
happyReduction_35 _ _  = notHappyAtAll 

happyReduce_36 = happySpecReduce_1  8# happyReduction_36
happyReduction_36 (HappyTerminal (TStringLiteral happy_var_1))
	 =  HappyAbsSyn12
		 (reverse happy_var_1
	)
happyReduction_36 _  = notHappyAtAll 

happyReduce_37 = happySpecReduce_3  8# happyReduction_37
happyReduction_37 (HappyTerminal (TStringLiteral happy_var_3))
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 ((reverse happy_var_3) ++ happy_var_1
	)
happyReduction_37 _ _ _  = notHappyAtAll 

happyReduce_38 = happySpecReduce_3  8# happyReduction_38
happyReduction_38 (HappyTerminal (TByteLiteral happy_var_3))
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (happy_var_3 : happy_var_1
	)
happyReduction_38 _ _ _  = notHappyAtAll 

happyReduce_39 = happySpecReduce_1  9# happyReduction_39
happyReduction_39 _
	 =  HappyAbsSyn13
		 (0x20000000
	)

happyReduce_40 = happySpecReduce_1  10# happyReduction_40
happyReduction_40 (HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn14
		 ((ExpressionIdentifier happy_var_1) : []
	)
happyReduction_40 _  = notHappyAtAll 

happyReduce_41 = happySpecReduce_1  10# happyReduction_41
happyReduction_41 (HappyTerminal (TByteLiteral happy_var_1))
	 =  HappyAbsSyn14
		 ((ExpressionNumber $ digitToInt happy_var_1) : []
	)
happyReduction_41 _  = notHappyAtAll 

happyReduce_42 = happySpecReduce_1  10# happyReduction_42
happyReduction_42 _
	 =  HappyAbsSyn14
		 (ExpressionAT : []
	)

happyReduce_43 = happySpecReduce_3  10# happyReduction_43
happyReduction_43 (HappyTerminal (TByteLiteral happy_var_3))
	_
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn14
		 ((ExpressionNumber (digitToInt happy_var_3)) : ExpressionPlus : happy_var_1
	)
happyReduction_43 _ _ _  = notHappyAtAll 

happyReduce_44 = happySpecReduce_3  10# happyReduction_44
happyReduction_44 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn14
		 ((ExpressionIdentifier happy_var_3) : ExpressionPlus : happy_var_1
	)
happyReduction_44 _ _ _  = notHappyAtAll 

happyReduce_45 = happySpecReduce_3  10# happyReduction_45
happyReduction_45 _
	_
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn14
		 (ExpressionAT : ExpressionPlus : happy_var_1
	)
happyReduction_45 _ _ _  = notHappyAtAll 

happyReduce_46 = happySpecReduce_3  10# happyReduction_46
happyReduction_46 (HappyTerminal (TByteLiteral happy_var_3))
	_
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn14
		 ((ExpressionNumber (digitToInt happy_var_3)) : ExpressionMinus : happy_var_1
	)
happyReduction_46 _ _ _  = notHappyAtAll 

happyReduce_47 = happySpecReduce_3  10# happyReduction_47
happyReduction_47 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn14
		 ((ExpressionIdentifier happy_var_3) : ExpressionMinus : happy_var_1
	)
happyReduction_47 _ _ _  = notHappyAtAll 

happyReduce_48 = happySpecReduce_3  10# happyReduction_48
happyReduction_48 _
	_
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn14
		 (ExpressionAT : ExpressionMinus : happy_var_1
	)
happyReduction_48 _ _ _  = notHappyAtAll 

happyReduce_49 = happySpecReduce_3  10# happyReduction_49
happyReduction_49 (HappyTerminal (TByteLiteral happy_var_3))
	_
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn14
		 ((ExpressionNumber (digitToInt happy_var_3)) : ExpressionMultiply : happy_var_1
	)
happyReduction_49 _ _ _  = notHappyAtAll 

happyReduce_50 = happySpecReduce_3  10# happyReduction_50
happyReduction_50 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn14
		 ((ExpressionIdentifier happy_var_3) : ExpressionMultiply : happy_var_1
	)
happyReduction_50 _ _ _  = notHappyAtAll 

happyReduce_51 = happySpecReduce_3  10# happyReduction_51
happyReduction_51 _
	_
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn14
		 (ExpressionAT : ExpressionMultiply : happy_var_1
	)
happyReduction_51 _ _ _  = notHappyAtAll 

happyReduce_52 = happySpecReduce_3  10# happyReduction_52
happyReduction_52 (HappyTerminal (TByteLiteral happy_var_3))
	_
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn14
		 ((ExpressionNumber (digitToInt happy_var_3)) : ExpressionDivide : happy_var_1
	)
happyReduction_52 _ _ _  = notHappyAtAll 

happyReduce_53 = happySpecReduce_3  10# happyReduction_53
happyReduction_53 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn14
		 ((ExpressionIdentifier happy_var_3) : ExpressionDivide : happy_var_1
	)
happyReduction_53 _ _ _  = notHappyAtAll 

happyReduce_54 = happySpecReduce_3  10# happyReduction_54
happyReduction_54 _
	_
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn14
		 (ExpressionAT : ExpressionDivide : happy_var_1
	)
happyReduction_54 _ _ _  = notHappyAtAll 

happyNewToken action sts stk
	= lexwrap(\tk -> 
	let cont i = happyDoAction i tk action sts stk in
	case tk of {
	LEOF -> happyDoAction 26# tk action sts stk;
	TOpCode happy_dollar_dollar -> cont 1#;
	TSet -> cont 2#;
	TComma -> cont 3#;
	THalt -> cont 4#;
	TFputS -> cont 5#;
	TStdOut -> cont 6#;
	TByteLiteral happy_dollar_dollar -> cont 7#;
	TIdentifier happy_dollar_dollar -> cont 8#;
	TRegister happy_dollar_dollar -> cont 9#;
	TInteger happy_dollar_dollar -> cont 10#;
	TLOC -> cont 11#;
	TIS -> cont 12#;
	TWyde -> cont 13#;
	TTetra -> cont 14#;
	TOcta -> cont 15#;
	TGREG -> cont 16#;
	TPlus -> cont 17#;
	TMinus -> cont 18#;
	TMult -> cont 19#;
	TDivide -> cont 20#;
	TAtSign -> cont 21#;
	TDataSegment -> cont 22#;
	TByte -> cont 23#;
	TStringLiteral happy_dollar_dollar -> cont 24#;
	THexLiteral happy_dollar_dollar -> cont 25#;
	_ -> happyError' tk
	})

happyError_ 26# tk = happyError' tk
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
  happySomeParser = happyThen (happyParse 0#) (\x -> case x of {HappyAbsSyn4 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


data Line = PlainOpCodeLine { pocl_code :: Int, pocl_ops :: OperatorList, pocl_loc :: Int }
          | LabelledOpCodeLine { lpocl_code :: Int, lpocl_ops :: OperatorList, lpocl_ident :: String, lpocl_loc :: Int }
          | PlainPILine { ppl_id :: PseudoInstruction, ppl_loc :: Int }
          | LabelledPILine { lppl_id :: PseudoInstruction, lppl_ident :: String, lppl_loc :: Int }
          deriving (Eq, Show)

data OperatorList = ListElements OpElement OpElement OpElement
                  | ListElementId OpElement Identifier
                  | ListIdElement Identifier OpElement
                  deriving (Eq, Show)

data Identifier = Id String
                deriving (Eq, Show)

data OpElement = ByteLiteral Char
               | PseudoCode Int
               | Register Int
               | Ident Identifier
               deriving (Eq, Show)

data LocExpressionEntry = ExpressionNumber Int
                        | ExpressionRegister Int
                        | ExpressionIdentifier Identifier
                        | ExpressionGV Int
                        | ExpressionAT
                        | ExpressionPlus
                        | ExpressionMinus
                        | ExpressionMultiply
                        | ExpressionDivide
                        deriving (Eq, Show)

data PseudoInstruction = LOC Int
                       | LocEx [LocExpressionEntry]
                       | GregAuto
                       | GregSpecific Char
                       | GregEx [LocExpressionEntry]
                       | ByteArray [Char]
                       | WydeArray [Char]
                       | TetraArray [Char]
                       | OctaArray [Char]
                       | IsRegister Int
                       | IsNumber Int
                       | IsIdentifier Identifier
                       | Set (OpElement, OpElement)
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
{-# LINE 8 "<command-line>" #-}
# 1 "/usr/include/stdc-predef.h" 1 3 4

# 17 "/usr/include/stdc-predef.h" 3 4














# 1 "/usr/include/x86_64-linux-gnu/bits/predefs.h" 1 3 4

# 18 "/usr/include/x86_64-linux-gnu/bits/predefs.h" 3 4












# 31 "/usr/include/stdc-predef.h" 2 3 4








# 8 "<command-line>" 2
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


data Happy_IntList = HappyCons Happy_GHC_Exts.Int# Happy_IntList





{-# LINE 66 "templates/GenericTemplate.hs" #-}

{-# LINE 76 "templates/GenericTemplate.hs" #-}



happyTrace string expr = Happy_System_IO_Unsafe.unsafePerformIO $ do
    Happy_System_IO.hPutStr Happy_System_IO.stderr string
    return expr




infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is 0#, it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept 0# tk st sts (_ `HappyStk` ans `HappyStk` _) =
	happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
	(happyTcHack j (happyTcHack st)) (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action



happyDoAction i tk st
	= (happyTrace ("state: " ++ show (Happy_GHC_Exts.I# (st)) ++  		      ",\ttoken: " ++ show (Happy_GHC_Exts.I# (i)) ++ 		      ",\taction: ")) $


	  case action of
		0#		  -> (happyTrace ("fail.\n")) $
				     happyFail i tk st
		-1# 	  -> (happyTrace ("accept.\n")) $
				     happyAccept i tk st
		n | LT(n,(0# :: Happy_GHC_Exts.Int#)) -> (happyTrace ("reduce (rule " ++ show rule 						 ++ ")")) $

				     (happyReduceArr Happy_Data_Array.! rule) i tk st
				     where rule = (Happy_GHC_Exts.I# ((Happy_GHC_Exts.negateInt# ((n Happy_GHC_Exts.+# (1# :: Happy_GHC_Exts.Int#))))))
		n		  -> (happyTrace ("shift, enter state " 						 ++ show (Happy_GHC_Exts.I# (new_state)) 						 ++ "\n")) $


				     happyShift new_state i tk st
                                     where new_state = (n Happy_GHC_Exts.-# (1# :: Happy_GHC_Exts.Int#))
   where off    = indexShortOffAddr happyActOffsets st
         off_i  = (off Happy_GHC_Exts.+# i)
	 check  = if GTE(off_i,(0# :: Happy_GHC_Exts.Int#))
                  then EQ(indexShortOffAddr happyCheck off_i, i)
		  else False
         action
          | check     = indexShortOffAddr happyTable off_i
          | otherwise = indexShortOffAddr happyDefActions st


indexShortOffAddr (HappyA# arr) off =
	Happy_GHC_Exts.narrow16Int# i
  where
        i = Happy_GHC_Exts.word2Int# (Happy_GHC_Exts.or# (Happy_GHC_Exts.uncheckedShiftL# high 8#) low)
        high = Happy_GHC_Exts.int2Word# (Happy_GHC_Exts.ord# (Happy_GHC_Exts.indexCharOffAddr# arr (off' Happy_GHC_Exts.+# 1#)))
        low  = Happy_GHC_Exts.int2Word# (Happy_GHC_Exts.ord# (Happy_GHC_Exts.indexCharOffAddr# arr off'))
        off' = off Happy_GHC_Exts.*# 2#





data HappyAddr = HappyA# Happy_GHC_Exts.Addr#




-----------------------------------------------------------------------------
-- HappyState data type (not arrays)

{-# LINE 169 "templates/GenericTemplate.hs" #-}

-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state 0# tk st sts stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (Happy_GHC_Exts.I# (i)) -> i }) in
--     trace "shifting the error token" $
     happyDoAction i tk new_state (HappyCons (st) (sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state (HappyCons (st) (sts)) ((HappyTerminal (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn 0# tk st sts stk
     = happyFail 0# tk st sts stk
happySpecReduce_0 nt fn j tk st@((action)) sts stk
     = happyGoto nt j tk st (HappyCons (st) (sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn 0# tk st sts stk
     = happyFail 0# tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@((HappyCons (st@(action)) (_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (happyGoto nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn 0# tk st sts stk
     = happyFail 0# tk st sts stk
happySpecReduce_2 nt fn j tk _ (HappyCons (_) (sts@((HappyCons (st@(action)) (_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (happyGoto nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn 0# tk st sts stk
     = happyFail 0# tk st sts stk
happySpecReduce_3 nt fn j tk _ (HappyCons (_) ((HappyCons (_) (sts@((HappyCons (st@(action)) (_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (happyGoto nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn 0# tk st sts stk
     = happyFail 0# tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k Happy_GHC_Exts.-# (1# :: Happy_GHC_Exts.Int#)) sts of
	 sts1@((HappyCons (st1@(action)) (_))) ->
        	let r = fn stk in  -- it doesn't hurt to always seq here...
       		happyDoSeq r (happyGoto nt j tk st1 sts1 r)

happyMonadReduce k nt fn 0# tk st sts stk
     = happyFail 0# tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
      case happyDrop k (HappyCons (st) (sts)) of
        sts1@((HappyCons (st1@(action)) (_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> happyGoto nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn 0# tk st sts stk
     = happyFail 0# tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k (HappyCons (st) (sts)) of
        sts1@((HappyCons (st1@(action)) (_))) ->
         let drop_stk = happyDropStk k stk

             off = indexShortOffAddr happyGotoOffsets st1
             off_i = (off Happy_GHC_Exts.+# nt)
             new_state = indexShortOffAddr happyTable off_i



          in
          happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))

happyDrop 0# l = l
happyDrop n (HappyCons (_) (t)) = happyDrop (n Happy_GHC_Exts.-# (1# :: Happy_GHC_Exts.Int#)) t

happyDropStk 0# l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n Happy_GHC_Exts.-# (1#::Happy_GHC_Exts.Int#)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction


happyGoto nt j tk st = 
   (happyTrace (", goto state " ++ show (Happy_GHC_Exts.I# (new_state)) ++ "\n")) $
   happyDoAction j tk new_state
   where off = indexShortOffAddr happyGotoOffsets st
         off_i = (off Happy_GHC_Exts.+# nt)
         new_state = indexShortOffAddr happyTable off_i




-----------------------------------------------------------------------------
-- Error recovery (0# is the error token)

-- parse error if we are in recovery and we fail again
happyFail 0# tk old_st _ stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (Happy_GHC_Exts.I# (i)) -> i }) in
--	trace "failing" $ 
        happyError_ i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  0# tk old_st (HappyCons ((action)) (sts)) 
						(saved_tok `HappyStk` _ `HappyStk` stk) =
--	trace ("discarding state, depth " ++ show (length stk))  $
	happyDoAction 0# tk action sts ((saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail  i tk (action) sts stk =
--      trace "entering error recovery" $
	happyDoAction 0# tk action sts ( (HappyErrorToken (Happy_GHC_Exts.I# (i))) `HappyStk` stk)

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


{-# NOINLINE happyDoAction #-}
{-# NOINLINE happyTable #-}
{-# NOINLINE happyCheck #-}
{-# NOINLINE happyActOffsets #-}
{-# NOINLINE happyGotoOffsets #-}
{-# NOINLINE happyDefActions #-}

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
