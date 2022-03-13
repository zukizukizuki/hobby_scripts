from selenium import webdriver
from selenium.webdriver.chrome.options import Options
import subprocess

cmd = f'"C:\\Users\\asaka\\OneDrive\\Desktop\\Tor Browser\\Browser\\firefox.exe"'

p = subprocess.Popen(cmd)
options = Options()
options.add_argument('--proxy-server=socks5://127.0.0.1:9150')

driver = webdriver.Chrome(chrome_options=options)
driver.implicitly_wait(30)
driver.get('')