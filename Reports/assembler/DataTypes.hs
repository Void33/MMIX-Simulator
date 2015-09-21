module DataTypes where
import qualified Data.Map.Lazy as M
import MMix_Parser

type SymbolTable = M.Map Identifier RegisterAddress
type RegisterAddress = (Int, Maybe PseudoInstruction)

instance Ord ExpressionEntry where
    (ExpressionNumber num1) `compare` (ExpressionNumber num2) = num1 `compare` num2
