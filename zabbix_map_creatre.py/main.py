import requests
import json

# ZabbixのAPI情報
ZABBIX_URL = 'http://your_zabbix_server/api_jsonrpc.php'
ZABBIX_USER = 'your_username'
ZABBIX_PASSWORD = 'your_password'

# Zabbix APIへのリクエストを送信する関数
def call_zabbix_api(method, params):
    headers = {'Content-Type': 'application/json-rpc'}
    data = {
        'jsonrpc': '2.0',
        'method': method,
        'params': params,
        'auth': None,
        'id': 1,
    }
    response = requests.post(ZABBIX_URL, headers=headers, data=json.dumps(data))
    return response.json()

# Zabbixにログインし、セッションIDを取得する関数
def login():
    params = {
        'user': ZABBIX_USER,
        'password': ZABBIX_PASSWORD,
    }
    response = call_zabbix_api('user.login', params)
    return response.get('result')

# ホスト一覧を取得する関数
def get_hosts(session_id):
    params = {
        'output': ['hostid', 'host'],
        'selectInterfaces': ['ip'],
    }
    response = call_zabbix_api('host.get', params)
    return response.get('result')

# マップにホストを登録する関数
def create_host_on_map(session_id, host_id, map_id, x, y):
    params = {
        'selementid': host_id,
        'elementtype': 0,  # 0 for host
        'sysmapid': map_id,
        'x': x,
        'y': y,
    }
    response = call_zabbix_api('map.addselement', params)
    return response.get('result')

def main():
    session_id = login()
    if session_id:
        hosts = get_hosts(session_id)
        if hosts:
            map_id = 1  # マップのIDを適切な値に変更する必要があります
            x, y = 100, 100  # ホストの初期位置
            for host in hosts:
                host_id = host['hostid']
                create_host_on_map(session_id, host_id, map_id, x, y)
                # 位置を調整するためにxとyを更新
                x += 50
                y += 50
            print("ホストをマップに登録しました。")
        else:
            print("ホストが見つかりませんでした。")
    else:
        print("Zabbixへのログインに失敗しました。")

if __name__ == "__main__":
    main()