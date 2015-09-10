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
evaluateLine st ln@(LabelledPILine (LocEx expr) _ address) = ln{lppl_id = (LocEx (ExpressionNumber v))}
   where v = evaluate expr address st
evaluateLine st ln@(PlainPILine (LocEx expr) address) = ln{ppl_id = (LocEx (ExpressionNumber v))}
   where v = evaluate expr address st
evaluateLine st ln@(PlainOpCodeLine _ ops _ _) = ln{pocl_ops = updated_operands}
   where updated_operands = evaluateOperands st [] ops
evaluateLine st ln@(LabelledOpCodeLine _ ops _ _ _) = ln{lpocl_ops = updated_operands}
   where updated_operands = evaluateOperands st [] ops
evaluateLine _ ln = ln

evaluateOperands :: SymbolTable -> [OperatorElement] -> [OperatorElement] -> [OperatorElement]
evaluateOperands st acc [] = reverse acc
evaluateOperands st acc (op:ops) = evaluateOperands st (new_op : acc) ops
    where new_op = evaluateOperand st op

evaluateOperand :: SymbolTable -> OperatorElement -> OperatorElement
evaluateOperand _ op@(Expr (ExpressionNumber _)) = op
evaluateOperand _ op@(Expr (ExpressionRegister _ _)) = op
evaluateOperand _ op@(Expr (ExpressionIdentifier _)) = op
evaluateOperand _ op@(Expr (ExpressionGV _)) = op
evaluateOperand _ op@(Expr ExpressionAT) = op
evaluateOperand st (Expr expr) = Expr (ExpressionNumber val)
    where val = evaluate expr 0 st
evaluateOperand _ op = op

evaluate :: ExpressionEntry -> Int -> SymbolTable -> Int
evaluate (ExpressionNumber val) _ _ = val
evaluate ExpressionAT loc _ = loc
evaluate (ExpressionMinus expr1 expr2) loc st = v1 - v2
    where v1 = evaluate expr1 loc st
          v2 = evaluate expr2 loc st
evaluate (ExpressionPlus expr1 expr2) loc st = v1 + v2
    where v1 = evaluate expr1 loc st
          v2 = evaluate expr2 loc st
evaluate (ExpressionMultiply expr1 expr2) loc st = v1 * v2
    where v1 = evaluate expr1 loc st
          v2 = evaluate expr2 loc st
evaluate (ExpressionDivide expr1 expr2) loc st = quot v1 v2
    where v1 = evaluate expr1 loc st
          v2 = evaluate expr2 loc st
evaluate (ExpressionIdentifier id) _ st
    | M.member id st = v
        where Just(val, lv) = M.lookup id st
              v = evaluatePI lv val
evaluate _ _ _ = -999999

evaluatePI :: Maybe PseudoInstruction -> Int -> Int
evaluatePI (Just (IsNumber val)) _ = val
evaluatePI _ val = val