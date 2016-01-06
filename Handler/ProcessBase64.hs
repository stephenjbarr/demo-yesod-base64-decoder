{-# LANGUAGE OverloadedStrings, DeriveGeneric, ScopedTypeVariables #-}

module Handler.ProcessBase64 where

import Import

import System.IO.Temp
import qualified Data.Text as T
import qualified Data.ByteString as B
import qualified Data.ByteString.Base64 as B64


maybeTempBS :: Text ->  ByteString -> IO (Maybe (FilePath, Handle))
maybeTempBS model_dot_suffix bs = do
    (fp, handle) <- openTempFile "/tmp" (T.unpack model_dot_suffix)
    print fp
    B.hPut handle bs
    hClose handle
    return (Just (fp, handle))


data InputBase64 = InputBase64 {
    ib__name :: Text
  , ib__val  :: Text
} deriving (Show, Generic)

instance FromJSON InputBase64
instance ToJSON   InputBase64

postProcessBase64R :: Handler Value
-- postProcessBase64R = error "Undefined"
postProcessBase64R = do
  ib64 <- requireJsonBody :: Handler InputBase64
  let decoded = B64.decode $ encodeUtf8 $  ib__val ib64 

  case decoded of Right ry -> do
                    mfhh <- liftIO $ maybeTempBS "myimage.jpg" ry
                    case mfhh of (Just (fp, _)) -> sendFile "application/pdf" fp
                                 Nothing        -> sendResponseStatus status403 ("export failed" :: Text)

                  Left  s  ->   sendResponseStatus status403 (s :: String)
  


-- sendResponseStatus status201 ("Successful decode" :: String)
