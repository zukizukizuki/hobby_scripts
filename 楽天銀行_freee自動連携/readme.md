# ファイル説明
・main.bat
→ rakutenDL.py を実行した後に freeeUL.py を実行する

・rakutenDL.py
→一か月前の月初日から月末日までの楽天銀行の明細をダウンロードします

・freeeUL.py
→指定した楽天銀行の明細ファイルをfreee会計にアップロードします

・login_info.json
→アカウント情報。ログイン時に使用する

・chromedriver.exe
→chromeでwebスクレイピングを実行するためのドライバー

# 編集箇所
・login_info.json
→3行目、4行目、8行目、9行目

・rakutenDL.py
→95行目

・freeeUL.py
→66行目

# 使用方法
1.python実行環境の構築
2.必要ライブラリのインストール(selenium等)
3.編集箇所を編集
4.main.batを実行
※あとはお好みでタスクスケジューラで自動実行するように設定してください
