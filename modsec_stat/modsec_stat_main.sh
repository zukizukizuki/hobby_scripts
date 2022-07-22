①メイン
/home/ubuntu/tool/No2.sh
/home/ubuntu/tool/No3.sh
echo "攻撃を通してしまった件数：" ; /home/ubuntu/tool/No4.sh
echo "攻撃を検出した総件数：" ; /home/ubuntu/tool/No5.sh

/home/ubuntu/tool/No6.sh

echo "■被害のあったサーバ：/usr/local/mod_security_summary/host/"`date +%Y%m%d`"
/home/ubuntu/tool/No7.sh
/home/ubuntu/tool/No8.sh

echo "■被害の内容：/usr/local/mod_security_summary/report/"`date +%Y%m%d`"
/home/ubuntu/tool/No9.sh
/home/ubuntu/tool/No10.sh

echo "■client：/usr/local/mod_security_summary/statistic/client/"`date +%Y%m%d`"
/home/ubuntu/tool/No11.sh

echo "■ruleid : /usr/local/mod_security_summary/statistic/ruleid/`date +%Y%m%d`"
/home/ubuntu/tool/No12.sh

echo "■user_agent : /usr/local/mod_security_summary/statistic/user_agent/`date +%Y%m%d`"
/home/ubuntu/tool/No13.sh

%s/`date +%Y%m%d`/$YYYYMMDD/g

②Intercepted以外を /tmpに移動
----
find /usr/local/mod_security_summary/`date +%Y%m%d`/ -type f | while read line;do severity=$line; if [ `grep Action $severity | grep Intercepted | wc -l` = 0 ];then mkdir -p /tmp/`date +%Y%m%d`/passed/ ; cp -p $severity /tmp/`date +%Y%m%d`/passed/ ;fi ; done
----
③被害の有無を判定しあり／なしを出力する。
NUM3=$(find /usr/local/mod_security_summary/`date +%Y%m%d` -type f | wc -l)

if [ $NUM3 = 0 ] ; then
        echo "■被害：なし"
else
        echo "■被害：あり"
fi

----
⑥閾値を持ち、その閾値以上の検出回数であるかを判定する。
NUM6=$(find /usr/local/mod_security_summary/`date +%Y%m%d` -type f | wc -l)

if [ $NUM6 > 3 ] ; then
        echo "■統計情報の確認：必要"
else
        echo "■統計情報の確認：不要"
fi
----
⑦被害のあったサーバのホスト情報（IP）を取得しファイル出力する。
echo "■被害の内容：/usr/local/mod_security_summary/report/"`date +%Y%m%d`  > /usr/local/mod_security_summary/host/`date +%Y%m%d`/No7 ; find /tmp/`date +%Y%m%d`/passed -type f | xargs grep REQUEST_HEADERS:Host | grep ModSecurity: | cut -d "[" -f 23 | tr -d "hostname" | tr -d \"] | sed 's/\(.*\)  \(.*\)/\2,\1/g' | sort | uniq >> /usr/local/mod_security_summary/host/`date +%Y%m%d`/No7

----
⑧被害サーバの総数をカウントする。
NUM7=$(cat /usr/local/mod_security_summary/host/`date +%Y%m%d`/No7 | wc -l)
echo $((NUM7-1))
----
sed '1d' no7.log | wc -l
-----
⑨遮断出来なかったルールをファイル出力する。
mkdir -p /usr/local/mod_security_summary/report/`date +%Y%m%d`
echo "Severity , rule_id" > /usr/local/mod_security_summary/report/`date +%Y%m%d`/No9 ; find /usr/local/mod_security_summary/`date +%Y%m%d` -type f | xargs grep REQUEST_HEADERS:Host | grep ModSecurity: | cut -d "[" -f 9,12 | tr -d "id" | tr -d "][severty" | tr -d \" | sed 's/\(.*\)  \(.*\)/\2,\1/g' | sort | uniq >> /usr/local/mod_security_summary/report/`date +%Y%m%d`/No9
-----
⑩被害内容の各緊急度ごとの検出回数を出力する。
echo "WARNING" > txt1234  ;  cat /usr/local/mod_security_summary/report/`date +%Y%m%d`/No9  | grep WARNING | wc -l >> txt1234 ; cat txt1234 | tr '\n' ',' ; rm -rf txt1234
----
⑪攻撃元IPごとの発生回数をカウントしファイル出力する。
mkdir -p /usr/local/mod_security_summary/statistic/client/`date +%Y%m%d`
find /usr/local/mod_security_summary/`date +%Y%m%d`/ -type f | xargs grep REQUEST_HEADERS:Host | grep ModSecurity: | cut -d ""]"" -f 10,4 | tr -d ""\""[clientdata "" | sed s/]/,/g > /usr/local/mod_security_summary/statistic/client/`date +%Y%m%d`/No11
cat /usr/local/mod_security_summary/statistic/client/`date +%Y%m%d`/No11 | while read line;do severity=$line; echo -n ""$severity"""","";grep $severity /usr/local/mod_security_summary/statistic/client/`date +%Y%m%d`/No11 | wc -l ; done | sort | uniq | sed  '1s/^/date,host,client,count\n/'  | sed "s/^/`date +%Y%m%d`,/g"
----
⑫ルールごとの発生回数をカウントしファイル出力する。
mkdir -p /usr/local/mod_security_summary/statistic/ruleid/`date +%Y%m%d`
find /usr/local/mod_security_summary/`date +%Y%m%d`/ -type f | xargs grep REQUEST_HEADERS:Host | grep Message: | cut -d "]" -f 4,6,9,10 | tr -d "\"[iddatamaturityaccuracy" | sed s/]/,/g | sed 's/\(.*\)  \(.*\)  \(.*\)  \(.*\)/\2,\1,\3,\4/g' |  tr -d " " | sed s/,,/,/g > /usr/local/mod_security_summary/statistic/ruleid/`date +%Y%m%d`/No12
cat /usr/local/mod_security_summary/statistic/ruleid/`date +%Y%m%d`/No12 | while read line;do severity=$line; echo -n "$severity"",";grep $severity /usr/local/mod_security_summary/statistic/ruleid/`date +%Y%m%d`/No12 | wc -l ; done | sort | uniq | sed "s/^/`date +%Y%m%d`,/g" | sed  '1s/^/date,host,rule_id,maturity,accuracy,count\n/' 

----
⑬ユーザエージェントごとの検出回数をカウントしファイル出力する。
find /usr/local/mod_security_summary/`date +%Y%m%d`/ -type f | xargs grep REQUEST_HEADERS:Host | grep ModSecurity: | cut -d "]" -f 10 | tr -d "\"[data " > /usr/local/mod_security_summary/statistic/user_agent/`date +%Y%m%d`/No13-1
find /usr/local/mod_security_summary/`date +%Y%m%d`/ -type f | xargs grep User-Agent: | cut -d ":" -f 3 | tr -d " "  > /usr/local/mod_security_summary/statistic/user_agent/`date +%Y%m%d`/No13-2
paste -d , /usr/local/mod_security_summary/statistic/user_agent/`date +%Y%m%d`/No13-1 /usr/local/mod_security_summary/statistic/user_agent/`date +%Y%m%d`/No13-2 > /usr/local/mod_security_summary/statistic/user_agent/`date +%Y%m%d`/No13
cat /usr/local/mod_security_summary/statistic/user_agent/`date +%Y%m%d`/No13 | while read line;do severity=$line; echo -n "$severity"",";grep $severity /usr/local/mod_security_summary/statistic/user_agent/`date +%Y%m%d`/No13 | wc -l ; done | sort | uniq | sed "s/^/`date +%Y%m%d`,/g" | sed  '1s/^/date,host,user_agent,count\n/' 
----
■host,useragent抽出
find /usr/local/mod_security_summary/`date +%Y%m%d`/ -type f | xargs grep -E "Host:|User-Agent:" | cut -d ":" -f 2,3 | perl -pe 's/\n/ /g' | sed "s/ Host:/\\$'\n'/g" | sed  "s/User-Agent/,/g " | sed  "s/Host//g "  | tr -d "\:\'\$ " > /usr/local/mod_security_summary/statistic/user_agent/`date +%Y%m%d`/No13
■date,count追加
cat /usr/local/mod_security_summary/statistic/user_agent/`date +%Y%m%d`/No13 | while read line;do severity=$line; echo -n "$severity"",";grep $severity /usr/local/mod_security_summary/statistic/user_agent/`date +%Y%m%d`/No13 | wc -l ; done | sort | uniq | sed "s/^/`date +%Y%m%d`,/g" | sed  '1s/^/date,host,user_agent,count\n/'
