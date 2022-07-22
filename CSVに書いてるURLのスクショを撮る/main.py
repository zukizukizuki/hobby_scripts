import time
import pytest
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
​
import csv
​
def read_csv_data(csv_path):
    rows = []
#    with open(str(csv_path), encoding="shift-jis") as csv_data:
    with open(str(csv_path)) as csv_data:
        content = csv.reader(csv_data)
        next(content, None)
        for row in content:
            rows.append(row)
        print(rows)
        return rows
​
​
class TestScreenshot():
​
    datalist = read_csv_data("./url.csv")
​
    @classmethod
    def setup_class(cls):
        options = Options()
        options.add_argument('--headless')
        options.add_argument('--hide-scrollbars')
        cls.driver = webdriver.Chrome(executable_path=ChromeDriverManager().install(), options=options)
        cls.driver.maximize_window()
​
    @pytest.mark.parametrize("id, url", datalist)
    def test_reserve_multi(self, id, url):
        driver = self.driver
        driver.get(url)
        time.sleep(3)
        page_height = driver.execute_script('return document.body.scrollHeight')
        driver.set_window_size(1920, page_height)
        driver.save_screenshot(id + '.png')
