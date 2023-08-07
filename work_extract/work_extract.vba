Sub ボタン1_Click()

    '高速化
    Application.Calculation = xlManual
    Application.ScreenUpdating = False
    
    Dim i As Integer
    Dim day As Date
    Dim day2 As Date
    Dim day3 As Date
    Dim day4 As Date
    Dim day5 As Date
    Dim day6 As Date
    Dim day7 As Date
    Dim work As String
    Dim WB As String
    
    WB = ActiveWorkbook.Name
    
    'i = "エクセルの検索開始行"
    i = 6

    work = "【作業予定】"
    day = Date
    day2 = DateAdd("d", 1, day)
    day3 = DateAdd("d", 2, day)
    day4 = DateAdd("d", 3, day)
    day5 = DateAdd("d", 4, day)
    day6 = DateAdd("d", 5, day)
    day7 = DateAdd("d", 6, day)
    
    'テスト用
    'Workbooks.Open "テスト対象のエクセルのフルパス", ReadOnly:=True
    '本番
    Workbooks.Open "本番のエクセルのフルパス", ReadOnly:=True
    Workbooks("開いたファイル名").Activate
    
    Do While Cells(i, 3) <> ""
        
        If InStr(Cells(i, 8), day) > 0 Or InStr(Cells(i, 8), day2) > 0 Or InStr(Cells(i, 8), day3) > 0 Or InStr(Cells(i, 8), day4) > 0 Or InStr(Cells(i, 8), day5) > 0 _
        Or InStr(Cells(i, 8), day6) > 0 Or InStr(Cells(i, 8), day7) > 0 Then
            If InStr(Cells(i, 14), "抽出したい文字列") > 0 Then
                work = work & vbCrLf & Left(Cells(i, 8), Len(Cells(i, 8)) - 3) & " " & Cells(i, 3)
            End If
            
        End If
        i = i + 1
    Loop
    
    Workbooks("開いたファイル名").Close
    Workbooks(WB).Activate
    
    If work <> "【作業予定】" Then
        MsgBox (work)
    Else
        MsgBox (day & " から " & day7 & "　の作業はありません")
    End If
    
End Sub
