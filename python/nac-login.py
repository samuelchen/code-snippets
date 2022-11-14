""" 登录 nac 网御系统 """

from selenium import webdriver
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.firefox.options import Options
from datetime import datetime
options = Options()
options.add_argument('--headless')
browser = webdriver.Firefox(options=options)
#browser = webdriver.Firefox()

print('>>>>> ', datetime.now(), ' <<<<<')
browser.get('http://10.56.7.10/nac/welcome/home')
print(browser.title, browser.current_url)

locator = (By.CLASS_NAME, 'app-button--default')
#locator = (By.XPATH, "//button[contains(., '我是员工')]")
try:
    WebDriverWait(browser, 20, 0.5).until(EC.presence_of_element_located(locator))
except Exception as e:
    print(e)

btn = browser.find_element(*locator)
btn.send_keys(Keys.ENTER)

locator = (By.CSS_SELECTOR, '.app-item:nth-child(1) .app-input__inner:nth-child(2)')
WebDriverWait(browser, 20, 0.5).until(EC.presence_of_element_located(locator))
input = browser.find_element(*locator)
input.send_keys('username')

locator = (By.CSS_SELECTOR, '.app-item:nth-child(2) .app-input__inner:nth-child(2)')
#WebDriverWait(browser, 20, 0.5).until(EC.presence_of_element_located(locator))
input = browser.find_element(*locator)
input.send_keys('password')

locator = (By.CSS_SELECTOR, '.btn-area > .app-button')
#WebDriverWait(browser, 20, 0.5).until(EC.presence_of_element_located(locator))
input = browser.find_element(*locator)
input.send_keys(Keys.ENTER)

locator = (By.CSS_SELECTOR, '.finish')
WebDriverWait(browser, 20, 0.5).until(EC.presence_of_element_located(locator))
print(browser.title, browser.current_url)

p = browser.find_element(*locator)
print(p.text)
print('-' * 40)

#btn = browser.find_element(By.XPATH, '//button[contains(., "登录")]')
#btn.send_keys(Keys.ENTER
#input.send_keys(Keys.ENTER)
#print(browser.current_url)
#print(browser.get_cookies())
#print(browser.page_source)
browser.quit()
