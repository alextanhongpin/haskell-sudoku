main :: IO()
main = do
    let input = [[1, 0, 0, 1, 0, 0, 1],
            [1, 0, 0, 1, 0, 0, 0],
            [0, 0, 0, 1, 1, 0, 1],
            [0, 0, 1, 0, 1, 1, 0],
            [0, 1, 1, 0, 0, 1, 1],
            [0, 1, 0, 0, 0, 0, 1]]

    let columnSize = length $ head input
    let columnLabels = mkColumnLabels columnSize
    let links = mkLinks $ ["h"] ++ columnLabels
    -- print $ takeF links "C"
    print $ value $ head $ mkDancingNodes input

-- Converts characters to string
charToStr :: Char -> String
charToStr n = n:[]

-- Returns a column header labels from the given length
mkColumnLabels :: Int -> [String]
mkColumnLabels n
    | n <= 26 = map charToStr $ take n ['A'..'Z']
    | otherwise = map show [0..n]

data Grid a = Node { left :: Grid a
                   , right :: Grid a
                   , up :: Grid a
                   , down :: Grid a
                   , columnNode :: Grid a
                   , row :: Int
                   , column :: Int
                   , size :: Int
                   , name :: String
                   , value :: a
                   }
            | Empty deriving (Show, Eq)

-- Tying the knot
mkLinks :: [a] -> Grid a
mkLinks xs = let (first, last) = go last xs first
             in first
    where go :: Grid a -> [a] -> Grid a -> (Grid a, Grid a)
          go prev [] next = (next, prev)
          go prev (x:xs) next = let this = Node { left = prev
                                                , right = rest
                                                , up = Empty
                                                , down = Empty
                                                , columnNode = Empty
                                                , row = 0
                                                , column = 0
                                                , size = 0
                                                , name = "x"
                                                , value = x
                                                }
                                    (rest, last) = go this xs next
                                in (this, last)

mkDancingNodes :: [[a]] -> [Grid a]
mkDancingNodes [] = []
mkDancingNodes (x:xs) = [mkLinks x] ++ mkDancingNodes xs

takeF :: Grid a -> String -> [String]
takeF node n = case isEq of True -> [val]
                            False -> [val] ++ (takeF r n)
    where r = right node
          valR = name r
          isEq = valR == n
          val = name node
