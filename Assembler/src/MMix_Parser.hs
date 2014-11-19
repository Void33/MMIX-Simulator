{-# OPTIONS_GHC -w #-}
{-# OPTIONS -fglasgow-exts -cpp #-}
import Data.Char
import MMix_Lexer
import qualified Data.Array as Happy_Data_Array
import qualified GHC.Exts as Happy_GHC_Exts
import qualified System.IO as Happy_System_IO
import qualified System.IO.Unsafe as Happy_System_IO_Unsafe
import qualified Debug.Trace as Happy_Debug_Trace

-- parser produced by Happy Version 1.19.0

data HappyAbsSyn t4 t5 t7 t8 t9 t10 t11 t12 t13
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

happyActOffsets :: HappyAddr
happyActOffsets = HappyA# "\x00\x00\x00\x00\x01\x00\x20\x00\x00\x00\x00\x00\x14\x00\x03\x00\xf7\xff\x23\x00\x1c\x00\x2b\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x14\x00\x00\x00\x00\x00\x2a\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0e\x00\x00\x00\x00\x00\xfb\xff\x00\x00\x00\x00\x29\x00\x00\x00\x00\x00\x14\x00\x00\x00\x00\x00"#

happyGotoOffsets :: HappyAddr
happyGotoOffsets = HappyA# "\x26\x00\x28\x00\x19\x00\x00\x00\x00\x00\x00\x00\x1e\x00\x21\x00\x06\x00\x00\x00\xfd\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x1a\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x1f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00"#

happyDefActions :: HappyAddr
happyDefActions = HappyA# "\xfd\xff\x00\x00\xfe\xff\x00\x00\xfc\xff\xf7\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xea\xff\xe9\xff\xeb\xff\xed\xff\xe6\xff\xec\xff\xf6\xff\x00\x00\xfa\xff\xfb\xff\x00\x00\xf2\xff\xf1\xff\xf0\xff\xf3\xff\xef\xff\x00\x00\xf8\xff\xf9\xff\x00\x00\xe7\xff\xe8\xff\x00\x00\xf4\xff\xee\xff\x00\x00\xf5\xff"#

happyCheck :: HappyAddr
happyCheck = HappyA# "\xff\xff\x06\x00\x01\x00\x0c\x00\x01\x00\x08\x00\x0f\x00\x05\x00\x07\x00\x0e\x00\x09\x00\x0a\x00\x09\x00\x0a\x00\x0d\x00\x09\x00\x0d\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x03\x00\x04\x00\x05\x00\x06\x00\x02\x00\x08\x00\x03\x00\x04\x00\x05\x00\x07\x00\x03\x00\x04\x00\x05\x00\x05\x00\x06\x00\x00\x00\x01\x00\x07\x00\x01\x00\x0e\x00\x02\x00\x02\x00\x02\x00\x0b\x00\xff\xff\x10\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff"#

happyTable :: HappyAddr
happyTable = HappyA# "\x00\x00\x20\x00\x07\x00\x10\x00\x13\x00\x0b\x00\x11\x00\x25\x00\x08\x00\x21\x00\x09\x00\x0a\x00\x09\x00\x0a\x00\x0b\x00\x0e\x00\x0b\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x24\x00\x1b\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x04\x00\x1b\x00\x1c\x00\x1d\x00\x15\x00\x05\x00\x13\x00\x14\x00\x15\x00\x21\x00\x22\x00\x03\x00\x02\x00\x11\x00\x02\x00\x0d\x00\x25\x00\x1c\x00\x1f\x00\x0e\x00\x00\x00\xff\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"#

happyReduceArr = Happy_Data_Array.array (1, 25) [
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
	(25 , happyReduce_25)
	]

happy_n_terms = 17 :: Int
happy_n_nonterms = 10 :: Int

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
		 (PlainOpCodeLine (happy_var_1 + 1) happy_var_2
	)
happyReduction_4 _ _  = notHappyAtAll 

happyReduce_5 = happySpecReduce_2  2# happyReduction_5
happyReduction_5 (HappyAbsSyn7  happy_var_2)
	(HappyTerminal (TOpCode happy_var_1))
	 =  HappyAbsSyn6
		 (PlainOpCodeLine happy_var_1 happy_var_2
	)
happyReduction_5 _ _  = notHappyAtAll 

happyReduce_6 = happySpecReduce_3  2# happyReduction_6
happyReduction_6 (HappyAbsSyn8  happy_var_3)
	(HappyTerminal (TOpCode happy_var_2))
	(HappyTerminal (TIdentifier happy_var_1))
	 =  HappyAbsSyn6
		 (LabelledOpCodeLine (happy_var_2 + 1) happy_var_3 happy_var_1
	)
happyReduction_6 _ _ _  = notHappyAtAll 

happyReduce_7 = happySpecReduce_3  2# happyReduction_7
happyReduction_7 (HappyAbsSyn7  happy_var_3)
	(HappyTerminal (TOpCode happy_var_2))
	(HappyTerminal (TIdentifier happy_var_1))
	 =  HappyAbsSyn6
		 (LabelledOpCodeLine happy_var_2 happy_var_3 happy_var_1
	)
happyReduction_7 _ _ _  = notHappyAtAll 

happyReduce_8 = happySpecReduce_1  2# happyReduction_8
happyReduction_8 (HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn6
		 (PlainPILine happy_var_1
	)
happyReduction_8 _  = notHappyAtAll 

happyReduce_9 = happySpecReduce_2  2# happyReduction_9
happyReduction_9 (HappyAbsSyn11  happy_var_2)
	(HappyTerminal (TIdentifier happy_var_1))
	 =  HappyAbsSyn6
		 (LabelledPILine happy_var_2 happy_var_1
	)
happyReduction_9 _ _  = notHappyAtAll 

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
		 (PseudoCode 7
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

happyReduce_17 = happySpecReduce_1  6# happyReduction_17
happyReduction_17 (HappyTerminal (TIdentifier happy_var_1))
	 =  HappyAbsSyn10
		 (Id happy_var_1
	)
happyReduction_17 _  = notHappyAtAll 

happyReduce_18 = happySpecReduce_2  7# happyReduction_18
happyReduction_18 (HappyAbsSyn13  happy_var_2)
	_
	 =  HappyAbsSyn11
		 (LOC happy_var_2
	)
happyReduction_18 _ _  = notHappyAtAll 

happyReduce_19 = happySpecReduce_2  7# happyReduction_19
happyReduction_19 (HappyTerminal (THexLiteral happy_var_2))
	_
	 =  HappyAbsSyn11
		 (LOC happy_var_2
	)
happyReduction_19 _ _  = notHappyAtAll 

happyReduce_20 = happySpecReduce_2  7# happyReduction_20
happyReduction_20 _
	_
	 =  HappyAbsSyn11
		 (GregAuto
	)

happyReduce_21 = happySpecReduce_2  7# happyReduction_21
happyReduction_21 (HappyAbsSyn12  happy_var_2)
	_
	 =  HappyAbsSyn11
		 (ByteArray (reverse happy_var_2)
	)
happyReduction_21 _ _  = notHappyAtAll 

happyReduce_22 = happySpecReduce_1  8# happyReduction_22
happyReduction_22 (HappyTerminal (TStringLiteral happy_var_1))
	 =  HappyAbsSyn12
		 (reverse happy_var_1
	)
happyReduction_22 _  = notHappyAtAll 

happyReduce_23 = happySpecReduce_3  8# happyReduction_23
happyReduction_23 (HappyTerminal (TStringLiteral happy_var_3))
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 ((reverse happy_var_3) ++ happy_var_1
	)
happyReduction_23 _ _ _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_3  8# happyReduction_24
happyReduction_24 (HappyTerminal (TByteLiteral happy_var_3))
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (happy_var_3 : happy_var_1
	)
happyReduction_24 _ _ _  = notHappyAtAll 

happyReduce_25 = happySpecReduce_1  9# happyReduction_25
happyReduction_25 _
	 =  HappyAbsSyn13
		 (0x20000000
	)

happyNewToken action sts stk
	= lexwrap(\tk -> 
	let cont i = happyDoAction i tk action sts stk in
	case tk of {
	LEOF -> happyDoAction 16# tk action sts stk;
	TOpCode happy_dollar_dollar -> cont 1#;
	TComma -> cont 2#;
	THalt -> cont 3#;
	TFputS -> cont 4#;
	TStdOut -> cont 5#;
	TByteLiteral happy_dollar_dollar -> cont 6#;
	TIdentifier happy_dollar_dollar -> cont 7#;
	TRegister happy_dollar_dollar -> cont 8#;
	TLOC -> cont 9#;
	TGREG -> cont 10#;
	TAtSign -> cont 11#;
	TDataSegment -> cont 12#;
	TByte -> cont 13#;
	TStringLiteral happy_dollar_dollar -> cont 14#;
	THexLiteral happy_dollar_dollar -> cont 15#;
	_ -> happyError' tk
	})

happyError_ 16# tk = happyError' tk
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


data Line = PlainOpCodeLine Int OperatorList
          | LabelledOpCodeLine Int OperatorList String
          | PlainPILine PseudoInstruction
          | LabelledPILine PseudoInstruction String
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
               deriving (Eq, Show)

data PseudoInstruction = LOC Int
                       | GregAuto
                       | GregSpecific Int
                       | ByteArray [Char]
                       deriving (Eq, Show)

-- fullParse "/home/steveedmans/test.mms"
-- fullParse "/home/steveedmans/hail.mms"

parseError m = alexError $ "WHY! " ++ show m

lexwrap :: (Token -> Alex a) -> Alex a
lexwrap cont = do
    token <- alexMonadScan
    cont token

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
