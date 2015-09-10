module SymbolTable where

import MMix_Parser
import Registers
import qualified Data.Map.Lazy as M
import Data.Char (chr, ord)
import Text.Regex.Posix
import DataTypes

type Table = M.Map String Int
type BaseTable = M.Map Char Int
type RegisterOffset = (Char, Int)
type CounterMap = M.Map Int Int

createSymbolTable :: Either String [Line] -> Either String SymbolTable
createSymbolTable (Left msg) = Left msg
createSymbolTable (Right lines) =
        let symbols = foldl getSymbol (Right M.empty) lines
            regs = createRegisterTable $ Right lines
        in symbols

getSymbol :: Either String SymbolTable -> Line -> Either String SymbolTable
getSymbol (Left errorMsg) _ = Left errorMsg
getSymbol (Right table) (LabelledPILine pi@(GregAuto) ident address)
          | M.member ident table = Left $ "Identifier already present " ++ (show ident)
          | otherwise = Right $ M.insert ident (address, Just pi) table
getSymbol (Right table) (LabelledPILine pi@(GregSpecific _) ident address)
          | M.member ident table = Left $ "Identifier already present " ++ (show ident)
          | otherwise = Right $ M.insert ident (address, Just pi) table
getSymbol (Right table) (LabelledPILine pi@(GregEx (ExpressionRegister reg _)) ident address)
          | M.member ident table = Left $ "Identifier already present " ++ (show ident)
          | otherwise = Right $ M.insert ident (address, Just (IsRegister (ord reg))) table
getSymbol (Right table) (LabelledPILine val@(IsNumber _) ident address)
          | M.member ident table = Left $ "Identifier already present " ++ (show ident)
          | otherwise = Right $ M.insert ident (address, Just val) table
getSymbol (Right table) (LabelledPILine val@(IsRegister _) ident address)
          | M.member ident table = Left $ "Identifier already present " ++ (show ident)
          | otherwise = Right $ M.insert ident (address, Just val) table
getSymbol (Right table) (LabelledPILine val@(IsIdentifier _) ident address)
          | M.member ident table = Left $ "Identifier already present " ++ (show ident)
          | otherwise = Right $ M.insert ident (address, Just val) table
getSymbol (Right table) (LabelledPILine val ident address)
          | M.member ident table = Left $ "Identifier already present " ++ (show ident)
          | otherwise = Right $ M.insert ident (address, Just(val)) table
getSymbol (Right table) (LabelledOpCodeLine _ _ ident address _)
          | M.member ident table = Left $ "Identifier already present " ++ (show ident)
          | otherwise = Right $ M.insert ident (address, Nothing) table
getSymbol (Right table) _ = Right $ table

getRegisterFromSymbol :: SymbolTable -> Identifier -> Int
getRegisterFromSymbol st id = reg
    where reg = case M.lookup id st of
                     Just(_, Just (IsRegister r)) -> r
                     _                            -> -1

determineBaseAddressAndOffset :: (M.Map ExpressionEntry Char) -> RegisterAddress -> Maybe(RegisterOffset)
determineBaseAddressAndOffset rfa (required_address, _) =
  case (M.lookupLE (ExpressionNumber required_address) rfa) of
    Just((ExpressionNumber address), register) -> Just(register, offset)
      where offset = required_address - address
    _ -> Nothing

mapSymbolToAddress :: SymbolTable -> RegisterTable -> Identifier -> Maybe(RegisterOffset)
mapSymbolToAddress symbols registers identifier@(Id _)
    | M.member identifier symbols = determineBaseAddressAndOffset registersByAddress requiredAddress
    | otherwise = Just('b', 2)
     where registersByAddress = registersFromAddresses registers
           requiredAddress = symbols M.! identifier
mapSymbolToAddress _ _ _ = Nothing

update_counter :: Int -> Maybe Int -> Int -> CounterMap -> CounterMap
update_counter label (Just old_counter) adjustment counters = M.insert label new_counter counters
    where new_counter = old_counter + adjustment
update_counter _ _ _ counters = counters

updated_label :: Int -> Maybe Int -> Identifier
updated_label label (Just current_counter)  = Id $ system_symbol label current_counter
updated_label label _  = Id $ "??" ++ (show label) ++ "HMissing"

transformLocalSymbolLabel :: CounterMap -> Line -> (CounterMap, Line)
transformLocalSymbolLabel counters ln@(LabelledOpCodeLine _ _ (LocalLabel label) _ _) = (new_counters, ln{lpocl_ident=new_label})
    where current_counter = M.lookup label counters
          new_label = updated_label label current_counter
          new_counters = update_counter label current_counter 1 counters
transformLocalSymbolLabel counters ln@(LabelledPILine _ (LocalLabel label) _) = (new_counters, ln{lppl_ident=new_label})
    where current_counter = M.lookup label counters
          new_label = updated_label label current_counter
          new_counters = update_counter label current_counter 1 counters
transformLocalSymbolLabel counter line = (counter, line)

setLocalSymbolLabel :: CounterMap -> [Line] -> [Line] -> [Line]
setLocalSymbolLabel _ acc [] = reverse acc
setLocalSymbolLabel current_counters acc (x:xs) =
    let (new_counters, new_line) = transformLocalSymbolLabel current_counters x
        new_acc = new_line : acc
    in setLocalSymbolLabel new_counters new_acc xs

setLocalSymbolLabelAuto :: Either String [Line] -> Either String [Line]
setLocalSymbolLabelAuto (Right lns) = Right $ operands_set
    where labels_set = setLocalSymbolLabel localSymbolCounterMap [] lns
          operands_set = transformLocalSymbolLines initialForwardSymbolMap initialBackwardSymbolMap labels_set []
setLocalSymbolLabelAuto msg = msg

localSymbolCounterMap :: CounterMap
localSymbolCounterMap = M.fromList $ map (\x -> (x, 0)) [0..9]

initialForwardSymbolMap :: M.Map Int Identifier
initialForwardSymbolMap = M.fromList $ map (\x -> (x, (Id (system_symbol x 0)))) [0..9]

initialBackwardSymbolMap :: M.Map Int (Maybe Identifier)
initialBackwardSymbolMap = M.fromList $ map (\x -> (x, Nothing)) [0..9]

transformLocalSymbolLines :: M.Map Int Identifier -> M.Map Int (Maybe Identifier) -> [Line] -> [Line] -> [Line]
transformLocalSymbolLines _ _ [] acc = reverse acc
transformLocalSymbolLines f b (x:xs) acc = transformLocalSymbolLines f' b' xs new_acc
    where (f', b', new_line) = transformLocalSymbol f b x
          new_acc = new_line : acc

transformLocalSymbol :: M.Map Int Identifier -> M.Map Int (Maybe Identifier) -> Line -> (M.Map Int Identifier, M.Map Int (Maybe Identifier), Line)
transformLocalSymbol f b l = (f', b', l')
    where f' = transformForward f l
          b' = transformBackward b l
          l' = transformLocalSymbolLine f b l

transformLocalSymbolLine :: M.Map Int Identifier -> M.Map Int (Maybe Identifier) -> Line -> Line
transformLocalSymbolLine f b ln@(PlainOpCodeLine _ elements _ _) = ln{pocl_ops = new_elements}
    where new_elements = transformLocalSymbolElements f b elements []
transformLocalSymbolLine f b ln@(LabelledOpCodeLine _ elements _ _ _) = ln{lpocl_ops = new_elements}
    where new_elements = transformLocalSymbolElements f b elements []
transformLocalSymbolLine _ _ ln = ln

transformForward :: M.Map Int Identifier -> Line -> M.Map Int Identifier
transformForward f ln@(LabelledOpCodeLine _ _ (Id label) _ _)
    | is_system_id label = M.insert l new_id f
    | otherwise          = f
       where Just(l, c) = system_id label
             new_label  = system_symbol l (c + 1)
             new_id     = Id new_label
transformForward f ln@(LabelledPILine _ (Id label) _)
    | is_system_id label = M.insert l new_id f
    | otherwise          = f
       where Just(l, c) = system_id label
             new_label  = system_symbol l (c + 1)
             new_id     = Id new_label
transformForward f _ = f


transformBackward :: M.Map Int (Maybe Identifier) -> Line -> M.Map Int (Maybe Identifier)
transformBackward b ln@(LabelledOpCodeLine _ _ (Id label) _ _)
    | is_system_id label = M.insert l new_id b
    | otherwise          = b
       where Just(l, _) = system_id label
             new_id     = Just(Id label)
transformBackward b ln@(LabelledPILine _ (Id label) _)
    | is_system_id label = M.insert l new_id b
    | otherwise          = b
       where Just(l, _) = system_id label
             new_id     = Just(Id label)
transformBackward b l = b

transformLocalSymbolElements :: M.Map Int Identifier -> M.Map Int (Maybe Identifier) -> [OperatorElement] -> [OperatorElement] -> [OperatorElement]
transformLocalSymbolElements _ _ [] acc = reverse acc
transformLocalSymbolElements f b (x:xs) acc = transformLocalSymbolElements f b xs new_acc
    where new_value = transformLocalSymbolElement f b x
          new_acc = new_value : acc

transformLocalSymbolElement :: M.Map Int Identifier -> M.Map Int (Maybe Identifier) -> OperatorElement -> OperatorElement
transformLocalSymbolElement forwards _ (LocalForward label) = Ident (identifier)
    where Just identifier = M.lookup label forwards
transformLocalSymbolElement _ backwards elem@(LocalBackward label) = v
    where i = M.lookup label backwards
          v = extractWithDefault i elem
transformLocalSymbolElement _ _ element = element

extractWithDefault :: Maybe (Maybe Identifier) -> OperatorElement -> OperatorElement
extractWithDefault (Just (Just v)) _ = Ident v
extractWithDefault _ d = d

system_id :: String -> Maybe (Int, Int)
system_id label
    | is_system_id label = Just(l, c)
    | otherwise = Nothing
        where l = read $ drop 2 $ take 3 label
              c = read $ drop 4 label

system_symbol_pattern = "^\\?\\?[0-9]H[0-9]+$"

is_system_id :: String -> Bool
is_system_id symbol = symbol =~ system_symbol_pattern

system_symbol :: Int -> Int -> String
system_symbol label counter = "??" ++ (show label) ++ "H" ++ (show counter)