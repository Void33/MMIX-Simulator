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
setLocation nextLoc ln@(LabelledPILine (Set _) _ _) = (newLoc, ln { lppl_loc = nextLoc })
    where newLoc = nextLoc + 4
setLocation nextLoc ln@(PlainPILine (Set _) _) = (newLoc, ln { ppl_loc = nextLoc })
    where newLoc = nextLoc + 4
setLocation nextLoc ln@(PlainPILine _ _) = (nextLoc, ln { ppl_loc = nextLoc })
setLocation nextLoc ln@(LabelledPILine _ _ _) = (nextLoc, ln { lppl_loc = nextLoc })
setLocation nextLoc ln@(PlainOpCodeLine _ _ _) = (newLoc, ln { pocl_loc = nextLoc })
    where newLoc = nextLoc + 4
setLocation nextLoc ln@(LabelledOpCodeLine _ _ _ _) = (newLoc, ln { lpocl_loc = nextLoc })
    where newLoc = nextLoc + 4
