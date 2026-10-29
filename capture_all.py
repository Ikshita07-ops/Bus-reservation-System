from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By
import time, os

os.makedirs('d:/Ikshita/Bus Reservation/doc_screenshots', exist_ok=True)

options = Options()
options.add_argument('--headless=new')
options.add_argument('--no-sandbox')
options.add_argument('--disable-dev-shm-usage')
options.add_argument('--window-size=1280,850')

driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=options)

try:
    # 1. Login / Sign In
    driver.get('http://localhost:8080/auth/login')
    time.sleep(1)
    driver.save_screenshot('d:/Ikshita/Bus Reservation/doc_screenshots/fig1_login.png')
    print('Fig 1 saved: Login')

    # 2. Search Results
    driver.get('http://localhost:8080/search?source=Hyderabad&destination=Bangalore')
    time.sleep(1)
    driver.save_screenshot('d:/Ikshita/Bus Reservation/doc_screenshots/fig2_search_results.png')
    print('Fig 2 saved: Search Results')

    # 3. Interactive Seat Selection
    driver.get('http://localhost:8080/seats/1')
    time.sleep(2)
    driver.save_screenshot('d:/Ikshita/Bus Reservation/doc_screenshots/fig3_seat_selection.png')
    print('Fig 3 saved: Seat Selection')

    # 4. Boarding Pass / Ticket
    driver.get('http://localhost:8080/booking/ticket/BRS-20261021-9X2A')
    time.sleep(1)
    driver.save_screenshot('d:/Ikshita/Bus Reservation/doc_screenshots/fig4_ticket.png')
    print('Fig 4 saved: Ticket')

    # 5. Admin Dashboard
    driver.get('http://localhost:8080/auth/login')
    time.sleep(1)
    driver.find_element(By.NAME, 'email').send_keys('admin@busreservation.com')
    driver.find_element(By.NAME, 'password').send_keys('admin123')
    driver.find_element(By.CSS_SELECTOR, 'button[type="submit"]').click()
    time.sleep(2)
    driver.get('http://localhost:8080/admin/dashboard')
    time.sleep(1)
    driver.save_screenshot('d:/Ikshita/Bus Reservation/doc_screenshots/fig5_admin_dashboard.png')
    print('Fig 5 saved: Admin Dashboard')

finally:
    driver.quit()
