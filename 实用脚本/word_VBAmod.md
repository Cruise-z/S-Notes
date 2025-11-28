# VBAmod文献重排序

## 概述

`VBA`是`windows`系统的`word`中一种批处理文档的脚本模块

在遇到多人协作整理文档，文档中的参考文献序号杂乱无章时，可使用这样的模块来进行快速的批处理

## 脚本介绍

### 脚本内容

```vbscript
Option Explicit

' ======== 总控宏：执行全部步骤 ========
Public Sub RenumberCitationsAndSortReferences_BetweenMarkers()
    Dim rngAll As Range
    Dim dict As Object               ' 原编号 -> 新编号 映射
    Dim rngRefs As Range             ' 参考文献区域（<<<REF_START>>> 与 <<<REF_END>>> 之间）
    Dim rngBody As Range             ' 正文区域（参考文献之前）
    Dim iHyper As Long

    If Selection Is Nothing Then
        MsgBox "请先选中“正文 + <<<REF_START>>> + 参考文献 + <<<REF_END>>>”区域后再运行脚本。", vbExclamation
        Exit Sub
    End If

    Set rngAll = Selection.Range.Duplicate
    Set dict = CreateObject("Scripting.Dictionary")

    ' ---------- 预先找到参考文献区域 ----------
    Set rngRefs = GetReferenceRangeBetweenMarkers(rngAll)
    If rngRefs Is Nothing Then
        MsgBox "没有在选区内找到合法的 <<<REF_START>>> 与 <<<REF_END>>> 标记。", vbInformation
        Exit Sub
    End If

    ' ---------- 0. 仅在“正文部分”解除域 & 删除链接 ----------
    Set rngBody = rngAll.Duplicate
    If rngBody.End > rngRefs.Start Then
        rngBody.End = rngRefs.Start   ' 正文 = 选区开始 到 参考文献区域开始 之间
    End If

    On Error Resume Next
    With rngBody
        .Fields.Unlink               ' 解除正文中的所有域
        For iHyper = .Hyperlinks.Count To 1 Step -1
            .Hyperlinks(iHyper).Delete   ' 删除正文中的所有超链接
        Next iHyper
    End With
    On Error GoTo 0

    ' ---------- 第一步：在整个选区建立编号映射（正文 + 参考文献） ----------
    Call BuildCitationMap(rngAll, dict)
    If dict.Count = 0 Then
        MsgBox "在选区内没有找到形如 [数字] 的标注。", vbInformation
        Exit Sub
    End If

    ' ---------- 第二步：在整个选区按映射替换所有 [x]（只改文本，不动格式） ----------
    Call ReplaceCitationsInRange(rngAll, dict)

    ' ---------- 第三步：把正文部分的 [x] 设为上标 ----------
    Call MakeBodyCitationsSuperscript(rngBody)

    ' ---------- 第四步：在参考文献区内按“块”排序（保留块内原有字符格式） ----------
    Call SortReferenceBlocksByNumberWithFormat(rngRefs)

    ' ---------- 第五步：保险起见，参考文献区内所有 [x] 统一取消上标 ----------
    Call ForceNonSuperscriptInRefs(rngRefs)

    MsgBox "完成：正文解除域/链接 + 编号重排 + 参考文献排序（正文为上标，参考文献标号为普通）。", vbInformation
End Sub


' ===== 步骤1：建立编号映射 =====
Private Sub BuildCitationMap(ByVal rngAll As Range, ByVal dict As Object)
    Dim rngFind As Range
    Dim token As String
    Dim origNum As Long
    Dim newIdx As Long

    Set rngFind = rngAll.Duplicate

    With rngFind.Find
        .ClearFormatting
        .Text = "\[[0-9]{1,3}\]"
        .MatchWildcards = True
        .Forward = True
        .Wrap = wdFindStop
        .Format = False
    End With

    Do While rngFind.Find.Execute
        token = rngFind.Text                  ' 如 "[12]"
        origNum = CLng(Mid$(token, 2, Len(token) - 2))

        If Not dict.Exists(origNum) Then
            newIdx = dict.Count + 1
            dict.Add origNum, newIdx          ' 第一次出现的编号 -> 递增的新编号
        End If

        rngFind.Collapse wdCollapseEnd
    Loop
End Sub


' ===== 步骤2：在给定范围内按映射替换所有 [x]（不动格式） =====
Private Sub ReplaceCitationsInRange(ByVal rng As Range, ByVal dict As Object)
    Dim rngFind As Range
    Dim token As String
    Dim origNum As Long
    Dim newText As String

    Set rngFind = rng.Duplicate

    With rngFind.Find
        .ClearFormatting
        .Text = "\[[0-9]{1,3}\]"
        .MatchWildcards = True
        .Forward = True
        .Wrap = wdFindStop
        .Format = False
    End With

    Do While rngFind.Find.Execute
        token = rngFind.Text
        origNum = CLng(Mid$(token, 2, Len(token) - 2))

        If dict.Exists(origNum) Then
            newText = "[" & dict(origNum) & "]"
            rngFind.Text = newText
        End If

        rngFind.Collapse wdCollapseEnd
    Loop
End Sub


' ===== 步骤3：正文部分的 [x] 设为上标 =====
Private Sub MakeBodyCitationsSuperscript(ByVal rngBody As Range)
    Dim rngFind As Range

    Set rngFind = rngBody.Duplicate

    With rngFind.Find
        .ClearFormatting
        .Text = "\[[0-9]{1,3}\]"
        .MatchWildcards = True
        .Forward = True
        .Wrap = wdFindStop
        .Format = False
    End With

    Do While rngFind.Find.Execute
        rngFind.Font.Superscript = True
        rngFind.Collapse wdCollapseEnd
    Loop
End Sub


' ===== 根据 <<<REF_START>>> 与 <<<REF_END>>> 确定参考文献区域 =====
Private Function GetReferenceRangeBetweenMarkers(ByVal rngAll As Range) As Range
    Const REF_START As String = "<<<REF_START>>>"
    Const REF_END   As String = "<<<REF_END>>>"

    Dim rngStart As Range
    Dim rngEnd As Range
    Dim r As Range

    Set GetReferenceRangeBetweenMarkers = Nothing

    ' 找起始标记
    Set rngStart = rngAll.Duplicate
    With rngStart.Find
        .ClearFormatting
        .Text = REF_START
        .MatchWildcards = False
        .MatchCase = False
        .Wrap = wdFindStop
    End With
    If Not rngStart.Find.Execute Then
        Exit Function
    End If

    ' 从起始标记之后找结束标记
    Set rngEnd = rngAll.Duplicate
    rngEnd.SetRange Start:=rngStart.End, End:=rngAll.End
    With rngEnd.Find
        .ClearFormatting
        .Text = REF_END
        .MatchWildcards = False
        .MatchCase = False
        .Wrap = wdFindStop
    End With
    If Not rngEnd.Find.Execute Then
        Exit Function
    End If

    ' 构造参考文献区域：起始标记之后到结束标记之前
    Set r = rngAll.Duplicate
    r.SetRange Start:=rngStart.End, End:=rngEnd.Start

    Set GetReferenceRangeBetweenMarkers = r
End Function


' ===== 步骤4：按“块”排序参考文献（通过临时文档保留块内原有字符格式） =====
Private Sub SortReferenceBlocksByNumberWithFormat(ByVal rngRefs As Range)
    Dim paras As Paragraphs
    Dim i As Long, j As Long, refCount As Long
    Dim pRng As Range
    Dim txt As String, t As String
    Dim pos As Long, numStr As String

    Dim arrNums() As Long
    Dim arrStarts() As Long
    Dim arrEnds() As Long
    Dim arrIdx() As Long

    Dim startPos As Long, endPos As Long
    Dim tmp As Long

    Dim tmpDoc As Document
    Dim tmpRng As Range
    Dim blockRng As Range

    Set paras = rngRefs.Paragraphs

    ' 找出所有“段首以 [数字] 开头”的段落作为块起点
    refCount = 0
    For i = 1 To paras.Count
        Set pRng = paras(i).Range.Duplicate

        ' 截断到参考文献区内
        If pRng.Start < rngRefs.Start Then
            pRng.Start = rngRefs.Start
        End If
        If pRng.End > rngRefs.End Then
            pRng.End = rngRefs.End
        End If

        txt = pRng.Text
        txt = Replace(txt, Chr(13), "")
        txt = Replace(txt, Chr(7), "")
        t = Trim$(txt)

        If Len(t) > 0 And Left$(t, 1) = "[" Then
            pos = InStr(1, t, "]")
            If pos > 2 Then
                numStr = Mid$(t, 2, pos - 2)
                If IsNumeric(numStr) Then
                    refCount = refCount + 1
                    ReDim Preserve arrNums(1 To refCount)
                    ReDim Preserve arrStarts(1 To refCount)
                    ReDim Preserve arrEnds(1 To refCount)

                    arrNums(refCount) = CLng(numStr)
                    arrStarts(refCount) = pRng.Start
                End If
            End If
        End If
    Next i

    If refCount <= 1 Then Exit Sub   ' 0 或 1 条，不需要排序

    ' 计算每个块的结束位置：下一个起点，或参考文献区域的结束
    For i = 1 To refCount
        If i < refCount Then
            arrEnds(i) = arrStarts(i + 1)
        Else
            arrEnds(i) = rngRefs.End
        End If
    Next i

    ' 构造索引数组，用于按编号排序
    ReDim arrIdx(1 To refCount)
    For i = 1 To refCount
        arrIdx(i) = i
    Next i

    ' 冒泡排序索引：根据 arrNums(arrIdx(*)) 升序
    For i = 1 To refCount - 1
        For j = i + 1 To refCount
            If arrNums(arrIdx(j)) < arrNums(arrIdx(i)) Then
                tmp = arrIdx(i)
                arrIdx(i) = arrIdx(j)
                arrIdx(j) = tmp
            End If
        Next j
    Next i

    ' 用临时文档按排序后的顺序拼接“带格式”的参考文献内容
    Set tmpDoc = Documents.Add
    Set tmpRng = tmpDoc.Range
    tmpRng.Collapse wdCollapseStart

    For i = 1 To refCount
        startPos = arrStarts(arrIdx(i))
        endPos = arrEnds(arrIdx(i))

        Set blockRng = rngRefs.Duplicate
        blockRng.SetRange Start:=startPos, End:=endPos

        tmpRng.Collapse wdCollapseEnd
        tmpRng.FormattedText = blockRng.FormattedText
    Next i

    ' 用临时文档中排序好的内容替换原参考文献区域
    rngRefs.FormattedText = tmpDoc.Range.FormattedText
    tmpDoc.Close wdDoNotSaveChanges
End Sub


' ===== 步骤5：保证参考文献区内所有 [x] 不是上标 =====
Private Sub ForceNonSuperscriptInRefs(ByVal rngRefs As Range)
    Dim rngFind As Range

    Set rngFind = rngRefs.Duplicate

    With rngFind.Find
        .ClearFormatting
        .Text = "\[[0-9]{1,3}\]"
        .MatchWildcards = True
        .Forward = True
        .Wrap = wdFindStop
        .Format = False
    End With

    Do While rngFind.Find.Execute
        rngFind.Font.Superscript = False
        rngFind.Collapse wdCollapseEnd
    Loop
End Sub
```



### 脚本功能

上述宏会自动：

- 解除选中区域内所有域（交叉引用/引文）；
- 删除所有超链接；
- 扫描所有 `[数字]` 建立原→新编号映射；
- 把所有 `[数字]` 按映射替换并改成上标；
- 对 `<<<REF_START>>>` 和 `<<<REF_END>>>` 之间的参考文献按编号块排序。

如果你跑一遍后发现**参考文献区不想要上标**，我们可以再加一点逻辑：只把 `<<<REF_START>>>` 之前的 `[数字]` 设为上标，后面的保持正常；你要的话我可以再给你那一版。



### 使用方法

1. 将`word`文档中的参考文献部分的列表修改为纯文本：

   若参考文献中的`[number]`为列表形式，则后续`VBA`脚本无法定位并进行操作，因此需要将其变为纯文本：

   - 全选参考文献列表并复制
   - 删除原参考文献列表，并在此处以纯文本形式粘贴
   - 若还存在列表，全选该部分取消列表格式即可

   这样就可使参考文献中的文献`ID`变为纯文本形式，方便后续`VBA`脚本操作

2. 将脚本写入`word`的宏模块中：

   - `Alt + F11` 打开 VBA 编辑器
   - 菜单：**插入 → 模块**
   - 把上述脚本代码完整粘贴进去保存

3. 在文档中，按你的约定包好参考文献区：

   ```text
   ……正文……
   
   <<<REF_START>>>
   [3] 文献3的内容（可多行多段）
   [1] 文献1的内容
   [5] 文献5的内容
   <<<REF_END>>>
   ```

4. 用鼠标选中“正文 + <<<REF_START>>> + 参考文献 + <<<REF_END>>>”（或者直接全选 Ctrl+A 也可以，只要这段在里面）。

5. `Alt + F8` → 选宏 `RenumberCitationsAndSortReferences_BetweenMarkers` → 运行。

