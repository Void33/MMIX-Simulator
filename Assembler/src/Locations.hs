module Locations where

import MMix_Parser
import Expressions

setInnerLocation nextLoc acc [] = reverse acc
setInnerLocation nextLoc acc (ln:lns) = setInnerLocation newLoc newAcc lns
    where (newLoc, newLine) = setLocation nextLoc ln
          newAcc = newLine : acc

setLocation :: Int -> Line -> (Int, Line)
setLocation nextLoc ln@(PlainPILine (LocEx loc) _) =
    case isSingleExprNumber loc of
       Just val -> (val, ln { ppl_loc = val })
       _ -> (nextLoc, ln)
setLocation nextLoc ln@(LabelledPILine (LocEx loc) _ _) =
    case isSingleExprNumber loc of
       Just val -> (val, ln { lppl_loc = val })
       _ -> (nextLoc, ln)
setLocation nextLoc ln@(LabelledPILine (ByteArray arr) _ _) = (newLoc, ln { lppl_loc = nextLoc })
    where newLoc = nextLoc + (length arr)
setLocation nextLoc ln@(PlainPILine (ByteArray arr) _) = (newLoc, ln { ppl_loc = nextLoc })
    where newLoc = nextLoc + (length arr)
setLocation nextLoc ln@(LabelledPILine (WydeArray arr) _ _) = (newLoc, ln { lppl_loc = addjusted_loc })
    where addjusted_loc = case (rem nextLoc 2) of
                             0 -> nextLoc
                             x -> nextLoc + x
          newLoc = addjusted_loc + ((length arr) * 2)
setLocation nextLoc ln@(PlainPILine (WydeArray arr) _) = (newLoc, ln { ppl_loc = addjusted_loc })
    where addjusted_loc = case (rem nextLoc 2) of
                             0 -> nextLoc
                             x -> nextLoc + x
          newLoc = addjusted_loc + ((length arr) * 2)
setLocation nextLoc ln@(LabelledPILine (TetraArray arr) _ _) = (newLoc, ln { lppl_loc = addjusted_loc })
    where addjusted_loc = case (rem nextLoc 4) of
                             0 -> nextLoc
                             x -> nextLoc + (4 - x)
          newLoc = addjusted_loc + ((length arr) * 4)
setLocation nextLoc ln@(PlainPILine (TetraArray arr) _) = (newLoc, ln { ppl_loc = addjusted_loc })
    where addjusted_loc = case (rem nextLoc 4) of
                             0 -> nextLoc
                             x -> nextLoc + (4 - x)
          newLoc = addjusted_loc + ((length arr) * 4)
setLocation nextLoc ln@(LabelledPILine (OctaArray arr) _ _) = (newLoc, ln { lppl_loc = addjusted_loc })
    where addjusted_loc = case (rem nextLoc 8) of
                             0 -> nextLoc
                             x -> nextLoc + (8 - x)
          newLoc = addjusted_loc + ((length arr) * 8)
setLocation nextLoc ln@(PlainPILine (OctaArray arr) _) = (newLoc, ln { ppl_loc = addjusted_loc })
    where addjusted_loc = case (rem nextLoc 8) of
                             0 -> nextLoc
                             x -> nextLoc + (8 - x)
          newLoc = addjusted_loc + ((length arr) * 8)
setLocation nextLoc ln@(LabelledPILine (Set _) _ _) = (newLoc, ln { lppl_loc = nextLoc })
    where newLoc = nextLoc + 4
setLocation nextLoc ln@(PlainPILine (Set _) _) = (newLoc, ln { ppl_loc = nextLoc })
    where newLoc = nextLoc + 4
setLocation nextLoc ln@(PlainPILine _ _) = (nextLoc, ln { ppl_loc = nextLoc })
setLocation nextLoc ln@(LabelledPILine _ _ _) = (nextLoc, ln { lppl_loc = nextLoc })
setLocation nextLoc ln@(PlainOpCodeLine _ _ _ _) = (newLoc, ln { pocl_loc = nextLoc })
    where newLoc = nextLoc + 4
setLocation nextLoc ln@(LabelledOpCodeLine _ _ _ _ _) = (newLoc, ln { lpocl_loc = nextLoc })
    where newLoc = nextLoc + 4
