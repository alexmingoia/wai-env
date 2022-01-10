module Network.Wai.Middleware.Environment
  ( withEnvironment,
    environment,
  )
where

import Data.Default (Default, def)
import Data.Maybe (fromMaybe)
import qualified Data.Vault.Lazy as V
import Network.Wai (Middleware, Request (..))
import System.IO.Unsafe (unsafePerformIO)

vaultKey :: Default a => V.Key a
vaultKey = unsafePerformIO V.newKey
{-# NOINLINE vaultKey #-}

-- | Parametize subsequent requests with environment.
withEnvironment :: Default a => a -> Middleware
withEnvironment env app req respond = do
  let req' = req {vault = V.insert vaultKey env (vault req)}
  app req' respond

-- | Retrieve request environment.
environment :: Default a => Request -> a
environment = fromMaybe def . V.lookup vaultKey . vault
