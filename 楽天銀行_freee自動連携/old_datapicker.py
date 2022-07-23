from selenium import webdriver #webdriverのインポート

id = 'datePick' #操作対象のカレンダー(daterpicker)のID
value = '2020/07/23' #任意の日付

driver = webdriver.Chrome(r"クロムドライバーパス") #Chromeを動かすドライバを読み込み
driver.get("http://example.selenium.jp/reserveApp_Renewal/")
#カレンダーにを任意の日付を設定
driver.execute_script("$('#" + id + "').datepicker('setDate',new Date('" + value + "'));")
#日付変更イベントを強制的に起こす
driver.execute_script("$('#" + id + "').datepicker().trigger('changeDate');")
