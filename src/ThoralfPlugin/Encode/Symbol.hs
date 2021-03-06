{-# LANGUAGE TypeFamilies, TypeInType, TypeOperators,
    GADTs, RecordWildCards, StandaloneDeriving
#-}

module ThoralfPlugin.Encode.Symbol ( symbolTheory ) where

import Type ( Type,
              splitTyConApp_maybe, isStrLitTy
            )
import TcPluginM ( TcPluginM )
import FastString ( unpackFS )
import TysWiredIn ( typeSymbolKindCon )


import ThoralfPlugin.Encode.TheoryEncoding


symbolTheory :: TcPluginM TheoryEncoding
symbolTheory = return symbolEncoding

symbolEncoding :: TheoryEncoding
symbolEncoding = emptyTheory
  { typeConvs = [symLitConv]
  , kindConvs = [symKindConv]
  }

symLitConv :: Type -> Maybe TyConvCont
symLitConv ty = do
  fastStr <- isStrLitTy ty
  let str = unpackFS fastStr
  let sexprStr = "\"" ++ str ++ "\""
  return $
    TyConvCont VNil VNil ((const . const) sexprStr) []


symKindConv :: Type -> Maybe KdConvCont
symKindConv ty = do
  (tcon, _) <- splitTyConApp_maybe ty
  case tcon == typeSymbolKindCon of
    False -> Nothing
    True ->
      Just $ KdConvCont VNil (const "String")
















