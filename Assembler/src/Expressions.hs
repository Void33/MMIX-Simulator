module Expressions where

import MMix_Parser

isSingleExprNumber :: [ExpressionEntry] -> Maybe Int
isSingleExprNumber ((ExpressionNumber val):[]) = Just val
isSingleExprNumber _ = Nothing

isSingleExprAT :: [ExpressionEntry] -> Bool
isSingleExprAT (ExpressionAT:[]) = True
isSingleExprAT _ = False