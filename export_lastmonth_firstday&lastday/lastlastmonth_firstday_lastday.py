from datetime import datetime, timedelta
from pickletools import TAKEN_FROM_ARGUMENT1

def last_month_firstday_lastday():

   now = datetime.now()
   this_month_first_day = now.replace(day=1)
   last_month_last_day = this_month_first_day - timedelta(days=1)
   last_month_first_day = last_month_last_day.replace(day=1)

   from1 = str(last_month_first_day).replace('-','/')[:10]
   to1 = str(last_month_last_day).replace('-','/')[:10]

   #print(now)
   #print(this_month_first_day)
   #print(last_month_last_day)
   #print(last_month_first_day)
   #print(from1)
   #print(to1)

last_month_firstday_lastday()
