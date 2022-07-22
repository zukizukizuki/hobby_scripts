from math import dist
from os import write
import glob
​
import os.path
import csv
from unicodedata import name
​
from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError
​
#./result.csv 削除
file_names = glob.glob('./result.csv')
for file_name in file_names:
    os.remove(file_name)
​
# If modifying these scopes, delete the file token.json.
SCOPES = ['https://www.googleapis.com/auth/admin.directory.group.readonly']
​
def main():
    """Shows basic usage of the Drive v3 API.
    Prints the names and ids of the first 10 files the user has access to.
    """
    creds = None
    # The file token.json stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first
    # time.
​
    #token.jsonが実在すればTRUE
    if os.path.exists('token.json'):
        #Jsonから資格情報を作成
        creds = Credentials.from_authorized_user_file('token.json', SCOPES)
    # If there are no (valid) credentials available, let the user log in.
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                'client-key_sd-inventory-check.json', SCOPES)
            creds = flow.run_local_server(port=0)
        # Save the credentials for the next run
        with open('token.json', 'w') as token:
            token.write(creds.to_json())
​
    try:
        #create service 
        service = build('admin', 'directory_v1', credentials=creds)
​
        cnt = 0
        group_name = list()
        group_email = list()
​
        #グループ名を全部取得
        results = service.groups().list(domain='ドメイン名').execute()
        results = results.get('groups', [])
        
        while (cnt < len(results)):
            groups = results[cnt]
​
            #特定のグループのみリストに入れる
            if 'infra' in groups.get('name') or 'ML_sendastest2' in groups.get('name') :
                 group_name.append(groups.get('name'))
                 group_email.append(groups.get('email'))
            
            cnt = cnt + 1
​
        #group_emailに入れた内容をキーに読み込んでいく
        i = 0
​
        while (i < len(group_email)):
            result = service.members().list(groupKey=group_email[i]).execute()
            result = result.get('members')
​
            #writing          
            labels = ['group_name','email','role','type','status','kind', 'etag', 'id']
            with open('./result.csv', 'a' ,newline='') as f:
                writer = csv.DictWriter(f, fieldnames=labels )
                if i == 0:
                    writer.writeheader()
​
                for elem in result:
                    elem['group_name']=group_name[i]
                    writer.writerow(elem)
​
            i=i+1
        
​
    except HttpError as error:
        # TODO(developer) - Handle errors from drive API.
        print(f'An error occurred: {error}')
​
if __name__ == '__main__':
    main()
