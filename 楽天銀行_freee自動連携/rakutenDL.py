#
# 楽天銀行サイトへログイン＆CSVダウンロード
#

import shutil
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
site_name = "bank_rakuten"

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
e = browser.find_element_by_id("LOGIN:USER_ID")
e.clear()
e.send_keys(USER)
e = browser.find_element_by_id("LOGIN:LOGIN_PASSWORD")
e.clear()
e.send_keys(PASS)

# ログイン
button = browser.find_element_by_id("LOGIN:_idJsp43")
button.click()

# ページロード完了まで待機
WebDriverWait(browser, 10).until(
    ec.presence_of_element_located((By.ID, "footer-copyright"))
)

# 入出金明細画面へ遷移
browser.find_element_by_link_text("入出金明細").click()

# ページロード完了まで待機
WebDriverWait(browser, 10).until(
    ec.presence_of_element_located((By.ID, "FORM_DOWNLOAD_IND:_idJsp692"))
)

# ダウンロード対象期間入力
#開始日を入力
datepicker = browser.find_element_by_id("FORM_DOWNLOAD_IND:datepicker_from")
datepicker.click()

datepicker1 = browser.find_element_by_class_name("ui-datepicker-prev")
datepicker1.click()

datepicker2 = browser.find_element_by_class_name("ui-state-default")
datepicker2.click()

#終了日を入力
datepicker3 = browser.find_element_by_id("FORM_DOWNLOAD_IND:datepicker_to")
datepicker3.click()

datepicker4 = browser.find_element_by_class_name("ui-datepicker-prev")
datepicker4.click()

datepicker5 = browser.find_elements_by_class_name("ui-state-default")
datepicker5 = datepicker5[-1]
datepicker5.click()

#CSV形式でダウンロード
browser.find_element_by_id("FORM_DOWNLOAD_IND:_idJsp692").click()
time.sleep(5)

# 処理終了
browser.quit()

#ファイルの移動
now = datetime.now()
this_month_first_day = now.replace(day=1)
last_month_last_day = this_month_first_day - timedelta(days=1)
last_month_first_day = last_month_last_day.replace(day=1)
from1 = str(last_month_first_day).replace('-','')[:8]
to1 = str(last_month_last_day).replace('-','')[:8]
shutil.move('C:\\' , 'C:\\' + from1 + '_'+ to1 + '.csv')

#----------------Jqueryを使ったパターン(直接入力出来ないため使用不可)----------------
#id = "datepicker_from"

#カレンダーにを任意の日付を設定
#browser.execute_script("$('#" + id + "').datepicker('setDate',new Date('" + from1 + "'));")
#日付変更イベントを強制的に起こす
#browser.execute_script("$('#" + id + "').datepicker().trigger('changeDate');")

#id = "datepicker_to"

#カレンダーにを任意の日付を設定
#browser.execute_script("$('#" + id + "').datepicker('setDate',new Date('" + to1 + "'));")
#日付変更イベントを強制的に起こす
#browser.execute_script("$('#" + id + "').datepicker().trigger('changeDate');")