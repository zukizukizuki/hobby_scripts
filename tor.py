import subprocess

from selenium.webdriver.chrome.options import Options
from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager

def Tor_start():
    subprocess.call(r'taskkill /F /T /IM firefox.exe', stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    Tor = f'"C:\\Users\\asaka\\OneDrive\\Desktop\\Tor Browser\\Browser\\firefox.exe"'
    subprocess.Popen(Tor)

def Selenium_start():
    options = Options()
    #options.add_argument('--headless')
    options.add_argument('--proxy-server=socks5://127.0.0.1:9050')
    driver = webdriver.Chrome(ChromeDriverManager().install(), options=options)
    driver.implicitly_wait(20)
    driver.get(url)
    return driver

url = ''

if __name__ == '__main__':
    Tor_start()
    driver = Selenium_start()
