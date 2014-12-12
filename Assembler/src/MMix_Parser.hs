{-# OPTIONS_GHC -w #-}
{-# OPTIONS -fglasgow-exts -cpp #-}
module MMix_Parser where

import Data.Char
import MMix_Lexer
import qualified GHC.Exts as Happy_GHC_Exts

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

action_0 (4#) = happyGoto action_3
action_0 (5#) = happyGoto action_2
action_0 x = happyTcHack x happyReduce_2

action_1 (5#) = happyGoto action_2
action_1 x = happyTcHack x happyFail

action_2 (14#) = happyShift action_6
action_2 (20#) = happyShift action_7
action_2 (22#) = happyShift action_8
action_2 (23#) = happyShift action_9
action_2 (26#) = happyShift action_10
action_2 (6#) = happyGoto action_4
action_2 (11#) = happyGoto action_5
action_2 x = happyTcHack x happyReduce_1

action_3 (29#) = happyAccept
action_3 x = happyTcHack x happyFail

action_4 x = happyTcHack x happyReduce_3

action_5 x = happyTcHack x happyReduce_9

action_6 (16#) = happyShift action_24
action_6 (17#) = happyShift action_25
action_6 (18#) = happyShift action_26
action_6 (19#) = happyShift action_27
action_6 (20#) = happyShift action_28
action_6 (21#) = happyShift action_29
action_6 (7#) = happyGoto action_20
action_6 (8#) = happyGoto action_21
action_6 (9#) = happyGoto action_22
action_6 (10#) = happyGoto action_23
action_6 x = happyTcHack x happyFail

action_7 (14#) = happyShift action_19
action_7 (22#) = happyShift action_8
action_7 (23#) = happyShift action_9
action_7 (26#) = happyShift action_10
action_7 (11#) = happyGoto action_18
action_7 x = happyTcHack x happyFail

action_8 (25#) = happyShift action_16
action_8 (28#) = happyShift action_17
action_8 (13#) = happyGoto action_15
action_8 x = happyTcHack x happyFail

action_9 (19#) = happyShift action_13
action_9 (24#) = happyShift action_14
action_9 x = happyTcHack x happyFail

action_10 (27#) = happyShift action_12
action_10 (12#) = happyGoto action_11
action_10 x = happyTcHack x happyFail

action_11 (15#) = happyShift action_33
action_11 x = happyTcHack x happyReduce_23

action_12 x = happyTcHack x happyReduce_24

action_13 x = happyTcHack x happyReduce_22

action_14 x = happyTcHack x happyReduce_21

action_15 x = happyTcHack x happyReduce_19

action_16 x = happyTcHack x happyReduce_27

action_17 x = happyTcHack x happyReduce_20

action_18 x = happyTcHack x happyReduce_6

action_19 (16#) = happyShift action_24
action_19 (17#) = happyShift action_25
action_19 (18#) = happyShift action_26
action_19 (19#) = happyShift action_27
action_19 (20#) = happyShift action_28
action_19 (21#) = happyShift action_29
action_19 (7#) = happyGoto action_31
action_19 (8#) = happyGoto action_32
action_19 (9#) = happyGoto action_22
action_19 (10#) = happyGoto action_23
action_19 x = happyTcHack x happyFail

action_20 x = happyTcHack x happyReduce_5

action_21 x = happyTcHack x happyReduce_4

action_22 (15#) = happyShift action_30
action_22 x = happyTcHack x happyFail

action_23 x = happyTcHack x happyReduce_17

action_24 x = happyTcHack x happyReduce_13

action_25 x = happyTcHack x happyReduce_14

action_26 x = happyTcHack x happyReduce_15

action_27 x = happyTcHack x happyReduce_12

action_28 x = happyTcHack x happyReduce_18

action_29 x = happyTcHack x happyReduce_16

action_30 (16#) = happyShift action_24
action_30 (17#) = happyShift action_25
action_30 (18#) = happyShift action_26
action_30 (19#) = happyShift action_27
action_30 (20#) = happyShift action_28
action_30 (21#) = happyShift action_29
action_30 (9#) = happyGoto action_36
action_30 (10#) = happyGoto action_37
action_30 x = happyTcHack x happyFail

action_31 x = happyTcHack x happyReduce_8

action_32 x = happyTcHack x happyReduce_7

action_33 (19#) = happyShift action_34
action_33 (27#) = happyShift action_35
action_33 x = happyTcHack x happyFail

action_34 x = happyTcHack x happyReduce_26

action_35 x = happyTcHack x happyReduce_25

action_36 (15#) = happyShift action_38
action_36 x = happyTcHack x happyFail

action_37 (15#) = happyReduce_17
action_37 x = happyTcHack x happyReduce_11

action_38 (16#) = happyShift action_24
action_38 (17#) = happyShift action_25
action_38 (18#) = happyShift action_26
action_38 (19#) = happyShift action_27
action_38 (20#) = happyShift action_28
action_38 (21#) = happyShift action_29
action_38 (9#) = happyGoto action_39
action_38 (10#) = happyGoto action_23
action_38 x = happyTcHack x happyFail

action_39 x = happyTcHack x happyReduce_10

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
happyReduction_4 (HappyAbsSyn8  happy_var_2)
	(HappyTerminal (TOpCode happy_var_1))
	 =  HappyAbsSyn6
		 (defaultPlainOpCodeLine { pocl_code = (happy_var_1 + 1), pocl_ops = happy_var_2 }
	)
happyReduction_4 _ _  = notHappyAtAll 

happyReduce_5 = happySpecReduce_2  6# happyReduction_5
happyReduction_5 (HappyAbsSyn7  happy_var_2)
	(HappyTerminal (TOpCode happy_var_1))
	 =  HappyAbsSyn6
		 (defaultPlainOpCodeLine { pocl_code = happy_var_1, pocl_ops = happy_var_2 }
	)
happyReduction_5 _ _  = notHappyAtAll 

happyReduce_6 = happySpecReduce_2  6# happyReduction_6
happyReduction_6 (HappyAbsSyn11  happy_var_2)
	(HappyTerminal (TIdentifier happy_var_1))
	 =  HappyAbsSyn6
		 (defaultLabelledPILine { lppl_id = happy_var_2, lppl_ident = happy_var_1 }
	)
happyReduction_6 _ _  = notHappyAtAll 

happyReduce_7 = happySpecReduce_3  6# happyReduction_7
happyReduction_7 (HappyAbsSyn8  happy_var_3)
	(HappyTerminal (TOpCode happy_var_2))
	(HappyTerminal (TIdentifier happy_var_1))
	 =  HappyAbsSyn6
		 (defaultLabelledOpCodeLine { lpocl_code = (happy_var_2 + 1), lpocl_ops = happy_var_3, lpocl_ident = happy_var_1}
	)
happyReduction_7 _ _ _  = notHappyAtAll 

happyReduce_8 = happySpecReduce_3  6# happyReduction_8
happyReduction_8 (HappyAbsSyn7  happy_var_3)
	(HappyTerminal (TOpCode happy_var_2))
	(HappyTerminal (TIdentifier happy_var_1))
	 =  HappyAbsSyn6
		 (defaultLabelledOpCodeLine { lpocl_code = happy_var_2, lpocl_ops = happy_var_3, lpocl_ident = happy_var_1}
	)
happyReduction_8 _ _ _  = notHappyAtAll 

happyReduce_9 = happySpecReduce_1  6# happyReduction_9
happyReduction_9 (HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn6
		 (defaultPlainPILine { ppl_id = happy_var_1 }
	)
happyReduction_9 _  = notHappyAtAll 

happyReduce_10 = happyReduce 5# 7# happyReduction_10
happyReduction_10 ((HappyAbsSyn9  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn9  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn9  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn7
		 (ListElements happy_var_1 happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_11 = happySpecReduce_3  8# happyReduction_11
happyReduction_11 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn8
		 (ListElementId happy_var_1 happy_var_3
	)
happyReduction_11 _ _ _  = notHappyAtAll 

happyReduce_12 = happySpecReduce_1  9# happyReduction_12
happyReduction_12 (HappyTerminal (TByteLiteral happy_var_1))
	 =  HappyAbsSyn9
		 (ByteLiteral happy_var_1
	)
happyReduction_12 _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_1  9# happyReduction_13
happyReduction_13 _
	 =  HappyAbsSyn9
		 (PseudoCode 0
	)

happyReduce_14 = happySpecReduce_1  9# happyReduction_14
happyReduction_14 _
	 =  HappyAbsSyn9
		 (fputs
	)

happyReduce_15 = happySpecReduce_1  9# happyReduction_15
happyReduction_15 _
	 =  HappyAbsSyn9
		 (PseudoCode 1
	)

happyReduce_16 = happySpecReduce_1  9# happyReduction_16
happyReduction_16 (HappyTerminal (TRegister happy_var_1))
	 =  HappyAbsSyn9
		 (Register happy_var_1
	)
happyReduction_16 _  = notHappyAtAll 

happyReduce_17 = happySpecReduce_1  9# happyReduction_17
happyReduction_17 (HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn9
		 (Ident happy_var_1
	)
happyReduction_17 _  = notHappyAtAll 

happyReduce_18 = happySpecReduce_1  10# happyReduction_18
happyReduction_18 (HappyTerminal (TIdentifier happy_var_1))
	 =  HappyAbsSyn10
		 (Id happy_var_1
	)
happyReduction_18 _  = notHappyAtAll 

happyReduce_19 = happySpecReduce_2  11# happyReduction_19
happyReduction_19 (HappyAbsSyn13  happy_var_2)
	_
	 =  HappyAbsSyn11
		 (LOC happy_var_2
	)
happyReduction_19 _ _  = notHappyAtAll 

happyReduce_20 = happySpecReduce_2  11# happyReduction_20
happyReduction_20 (HappyTerminal (THexLiteral happy_var_2))
	_
	 =  HappyAbsSyn11
		 (LOC happy_var_2
	)
happyReduction_20 _ _  = notHappyAtAll 

happyReduce_21 = happySpecReduce_2  11# happyReduction_21
happyReduction_21 _
	_
	 =  HappyAbsSyn11
		 (GregAuto
	)

happyReduce_22 = happySpecReduce_2  11# happyReduction_22
happyReduction_22 (HappyTerminal (TByteLiteral happy_var_2))
	_
	 =  HappyAbsSyn11
		 (GregSpecific happy_var_2
	)
happyReduction_22 _ _  = notHappyAtAll 

happyReduce_23 = happySpecReduce_2  11# happyReduction_23
happyReduction_23 (HappyAbsSyn12  happy_var_2)
	_
	 =  HappyAbsSyn11
		 (ByteArray (reverse happy_var_2)
	)
happyReduction_23 _ _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_1  12# happyReduction_24
happyReduction_24 (HappyTerminal (TStringLiteral happy_var_1))
	 =  HappyAbsSyn12
		 (reverse happy_var_1
	)
happyReduction_24 _  = notHappyAtAll 

happyReduce_25 = happySpecReduce_3  12# happyReduction_25
happyReduction_25 (HappyTerminal (TStringLiteral happy_var_3))
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 ((reverse happy_var_3) ++ happy_var_1
	)
happyReduction_25 _ _ _  = notHappyAtAll 

happyReduce_26 = happySpecReduce_3  12# happyReduction_26
happyReduction_26 (HappyTerminal (TByteLiteral happy_var_3))
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (happy_var_3 : happy_var_1
	)
happyReduction_26 _ _ _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_1  13# happyReduction_27
happyReduction_27 _
	 =  HappyAbsSyn13
		 (0x20000000
	)

happyNewToken action sts stk
	= lexwrap(\tk -> 
	let cont i = action i i tk (HappyState action) sts stk in
	case tk of {
	LEOF -> action 29# 29# tk (HappyState action) sts stk;
	TOpCode happy_dollar_dollar -> cont 14#;
	TComma -> cont 15#;
	THalt -> cont 16#;
	TFputS -> cont 17#;
	TStdOut -> cont 18#;
	TByteLiteral happy_dollar_dollar -> cont 19#;
	TIdentifier happy_dollar_dollar -> cont 20#;
	TRegister happy_dollar_dollar -> cont 21#;
	TLOC -> cont 22#;
	TGREG -> cont 23#;
	TAtSign -> cont 24#;
	TDataSegment -> cont 25#;
	TByte -> cont 26#;
	TStringLiteral happy_dollar_dollar -> cont 27#;
	THexLiteral happy_dollar_dollar -> cont 28#;
	_ -> happyError' tk
	})

happyError_ 29# tk = happyError' tk
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

data PseudoInstruction = LOC Int
                       | GregAuto
                       | GregSpecific Char
                       | ByteArray [Char]
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
