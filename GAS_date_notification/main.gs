function mailAlerts() {
  //シートを取得
  var bk = SpreadsheetApp.getActiveSpreadsheet();
  var sh = bk.getActiveSheet();

  var last_row = sh.getLastRow(); //最後の行を取得(繰り返し処理の回数)
  var begin_row = 2;// 処理を開始する行 (1行目は項目名なので2から)

  //今日の日付を取得し文字列を成型する
  var today = new Date();
  var formatDate = Utilities.formatDate(today, "JST", "yyyy/MM/dd");

  //繰り返し処理(1行づつ処理し、行の数だけ繰り返す)
  for (var i = begin_row; i <= last_row; i++) {
    //それぞれのセルの中身を取得していく
    //イベント日
    var sell1 = "A" + i;
    var value1 = sh.getRange(sell1).getValue();
    var value1 = new Date(value1);
    var value1 = Utilities.formatDate(value1, "JST", "yyyy/MM/dd");
    console.log(value1);

    //会場
    var sell2 = "B" + i;
    var value2 = sh.getRange(sell2).getValue();
    console.log(value2);

    //解禁日
    var sell3 = "C" + i;
    var value3 = sh.getRange(sell3).getValue();
    if ("" != value3) {
      if ("解禁済" != value3) {
        var value3 = new Date(value3);
        var value3 = Utilities.formatDate(value3, "JST", "yyyy/MM/dd");
        console.log(value3);
      }
    }

    //チケ発日
    var sell4 = "D" + i;
    var value4 = sh.getRange(sell4).getValue();
    if ("" != value4) {
      var value4 = new Date(value4);
      var value4 = Utilities.formatDate(value4, "JST", "yyyy/MM/dd");
      console.log(value4);
    }

    //TT告知日
    var sell5 = "E" + i;
    var value5 = sh.getRange(sell5).getValue();
    if ("" != value5) {
      if ("不要" != value5) {
        var value5 = new Date(value5);
        var value5 = Utilities.formatDate(value5, "JST", "yyyy/MM/dd");
        console.log(value5);
      }
    }

    //チケ発URL
    var sell6 = "F" + i;
    var value6 = sh.getRange(sell6).getValue();

    //今日の日付が解禁日の場合メールを送る
    if (formatDate == value3) {
      GmailApp.sendEmail(
        "official.soranaki@gmail.com,asakarabanmade1015@gmail.com,cheese.gyoumu.renraku@gmail.com,hirohiroakisan@gmail.com,nnmnna6@gmail.com",
        "【要確認】本日イベント解禁日" + "/イベント日:" + value1,
        "■イベント日:" + value1 + "\n■会場:" + value2 + "\n■解禁日:" + value3 + "\n■チケ発日:" + value4 + "\n■TT告知日:" + value5 + "\n■チケ発URL:" + value6
      );
    }
    //今日の日付がチケ発日の場合メールを送る
    if (formatDate == value4) {
      GmailApp.sendEmail(
        "official.soranaki@gmail.com,asakarabanmade1015@gmail.com,cheese.gyoumu.renraku@gmail.com,hirohiroakisan@gmail.com,nnmnna6@gmail.com",
        "【要確認】本日チケ発日" + "/イベント日:" + value1,
        "■イベント日:" + value1 + "\n■会場:" + value2 + "\n■解禁日:" + value3 + "\n■チケ発日:" + value4 + "\n■TT告知日:" + value5 + "\n■チケ発URL:" + value6
      );
    }

    //今日の日付がTT告知日の場合メールを送る
    if (formatDate == value5) {
      GmailApp.sendEmail(
      "official.soranaki@gmail.com,asakarabanmade1015@gmail.com,cheese.gyoumu.renraku@gmail.com,hirohiroakisan@gmail.com,nnmnna6@gmail.com",
      "【要確認】本日TT告知日" + "/イベント日:" + value1,
      "■イベント日:" + value1 + "\n■会場:" + value2 + "\n■解禁日:" + value3 + "\n■チケ発日:" + value4 + "\n■TT告知日:" + value5 + "\n■チケ発URL:" + value6
    );
  }
  }
}