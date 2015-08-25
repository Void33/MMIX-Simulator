module Expressions where

import MMix_Parser
import DataTypes
import qualified Data.Map.Lazy as M

isSingleExprNumber :: ExpressionEntry -> Maybe Int
isSingleExprNumber (ExpressionNumber val) = Just val
isSingleExprNumber _ = Nothing

evaluateAllExpressions :: Either String [Line] -> Either String SymbolTable -> Either String [Line]
evaluateAllExpressions (Left msg) _ = Left msg
evaluateAllExpressions _ (Left msg) = Left msg
evaluateAllExpressions (Right lines) (Right st) = Right $ evaluateAllLines st lines []

evaluateAllLines :: SymbolTable -> [Line] -> [Line] -> [Line]
evaluateAllLines _ [] acc = reverse acc
evaluateAllLines st (ln:lns) acc = evaluateAllLines st lns (new_line : acc)
    where new_line = evaluateLine st ln

evaluateLine :: SymbolTable -> Line -> Line
evaluateLine st ln@(LabelledPILine (GregEx (ExpressionRegister reg expr)) _ address) = new_line
   where v = evaluate expr address st
         new_reg = ExpressionRegister reg (ExpressionNumber v)
         new_line = ln{lppl_id = (GregEx new_reg)}
evaluateLine _ ln = ln

evaluate :: ExpressionEntry -> Int -> SymbolTable -> Int
evaluate (ExpressionNumber val) _ _ = val
evaluate ExpressionAT loc _ = loc
evaluate (ExpressionMinus expr1 expr2) loc st = v1 - v2
    where v1 = evaluate expr1 loc st
          v2 = evaluate expr2 loc st
evaluate (ExpressionPlus expr1 expr2) loc st = v1 + v2
    where v1 = evaluate expr1 loc st
          v2 = evaluate expr2 loc st
evaluate (ExpressionIdentifier id) _ st
    | M.member id st = v
        where Just(_, lv) = M.lookup id st
              Just(v) = evaluatePI lv
evaluate _ _ _ = -999999

evaluatePI :: Maybe PseudoInstruction -> Maybe Int
evaluatePI (Just (IsNumber val)) = Just(val)
evaluatePI _ = Nothing