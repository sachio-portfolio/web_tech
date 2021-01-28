# ライブラリ「webrick」を呼び出す
require 'webrick'
# Webrickのインスタンスを作成し、serverというローカル変数に代入
server = WEBrick::HTTPServer.new({
  # !! 初期値として以下３つの設定が必要 !!
  # ①このWebアプリケーションのドメインの設定
  :DocumentRoot => '.',
  # ②このプログラムを実行（翻訳）できるプログラム（Rubyのこと）本体の居場所を指定する記述
  :CGIInterpreter => WEBrick::HTTPServlet::CGIHandler::Ruby,
  # ③このWebアプリケーションの情報の出入り口を表す設定
  :Port => '3000',
})
['INT', 'TERM'].each {|signal|
  Signal.trap(signal){ server.shutdown }
}
# Webサーバを起動した状態で、（DocumentRootの値）/testというURLを送信すると、同じディレクトリ階層にあるtest.html.erbファイルを表示するという機能を付与
server.mount('/test', WEBrick::HTTPServlet::ERBHandler, 'test.html.erb')
# <form action='indicate.cgi'> 〜 </form>の内部にある値を、indicate.rbに送信することができるようになる
server.mount('/indicate.cgi', WEBrick::HTTPServlet::CGIHandler, 'indicate.rb')
# goyaDBの情報を出力するためのページを作る準備
server.mount('/goya.cgi', WEBrick::HTTPServlet::CGIHandler, 'goya.rb')
# Webrickのサーバを起動させる
server.start
