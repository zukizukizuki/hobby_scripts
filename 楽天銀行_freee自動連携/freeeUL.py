#
# freeeサイトへログイン＆CSVアップロード
#

import time
import json
from datetime import datetime, timedelta
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as ec
from webdriver_manager.chrome import ChromeDriverManager

# 設定ファイルからログイン情報を取得
login_info = json.load(open("login_info.json", "r", encoding="utf-8"))

# ログインサイト名
site_name = "freee"

# ログイン画面URL
url_login = login_info[site_name]["url"]

# ユーザー名とパスワードの指定
USER = login_info[site_name]["id"]
PASS = login_info[site_name]["pass"]

# chromeを起動する
browser = webdriver.Chrome(ChromeDriverManager().install())

# ログイン画面取得
browser.get(url_login)

# 入力
e = browser.find_element_by_id("user_email")
e.clear()
e.send_keys(USER)
e = browser.find_element_by_name("password")
e.clear()
e.send_keys(PASS)

# ログイン
button = browser.find_element_by_name("commit")
button.click()

# ページロード完了まで待機
time.sleep(3)

#残高を取得
FreeeMoney =browser.find_element_by_class_name("walletable___StyledDiv8-sc-3etvmj-8")

#楽天APIに移動
c = browser.find_element_by_class_name("walletable___StyledA-sc-3etvmj-3")
c.click()

# ページロード完了まで待機
time.sleep(3)

#明細アップロードに移動
c = browser.find_element_by_id("wtxns-upload")
c.click()

#ファイルを選択し入力
now = datetime.now()
this_month_first_day = now.replace(day=1)
last_month_last_day = this_month_first_day - timedelta(days=1)
last_month_first_day = last_month_last_day.replace(day=1)
from1 = str(last_month_first_day).replace('-','')[:8]
to1 = str(last_month_last_day).replace('-','')[:8]
browser.find_element_by_id("ofx").send_keys('C:\\Users\\asaka\\Documents\\work\\税務\\' + from1 + '_'+ to1 + '.csv');

#次へをクリック
c = browser.find_element_by_name("commit")
c.click()
