import Graphics.UI.WX
import Graphics.UI.WXCore
import Text.Pandoc

main :: IO ()
main = start gui

defaultId :: Int
defaultId = 0-1

gui :: IO ()
gui = do
    win <- frame [text := "", visible := False]
    textarea <- textCtrl win [font := fontFixed]
    html <- htmlWindowCreate win defaultId (rect (point 0 0) (sz 1 1)) wxHF_DEFAULTSTYLE "htmlWindow"
    set win [on closing := wxcAppExit]
    controlOnText textarea (doUpdate textarea html)
    set win [layout := fill $ row 5 [fill $ widget textarea, fill $ widget html]]
    set win [visible := True]

doUpdate :: TextCtrl () -> HtmlWindow () -> IO ()
doUpdate t h = do
    markdown <- get t text
    htmlWindowSetPage h (markdownToHtml markdown)

markdownToHtml :: String -> String
markdownToHtml = (writeHtmlString defaultWriterOptions)
                 . readMarkdown (defaultParserState { stateStrict = False })