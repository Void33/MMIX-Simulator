module Paths_Assembler (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch


version :: Version
version = Version {versionBranch = [1,0], versionTags = []}
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/steveedmans/.cabal/bin"
libdir     = "/home/steveedmans/.cabal/lib/x86_64-linux-ghc-7.6.3/Assembler-1.0"
datadir    = "/home/steveedmans/.cabal/share/x86_64-linux-ghc-7.6.3/Assembler-1.0"
libexecdir = "/home/steveedmans/.cabal/libexec"
sysconfdir = "/home/steveedmans/.cabal/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "Assembler_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "Assembler_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "Assembler_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "Assembler_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "Assembler_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
