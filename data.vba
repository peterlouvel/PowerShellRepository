

Sub PurgeBackups()

   Dim fso As Object
   Dim fcount As Object
   Dim collection As New collection
   Dim obj As Variant
   Dim i As Long
   
   Dim db As DAO.Database
   Dim FullPath As String
   
   FullPath = "C:\RSL LogBook App\LogBookApplication\Backup\"

Set fso = CreateObject("Scripting.FileSystemObject")
'add each file to a collection
'For Each fcount In fso.GetFolder(ThisWorkbook.Path & "\" & "excel_backups" & "\").Files
'Filepath returns the path from the full path
For Each filename In fso.FilePath(FullPath & "\*.*")
    collection.Add filename
    Debug.Print collection
Next filename

'sort the collection descending using the CreatedDate
Set collection = SortCollectionDesc(collection)

'kill items from index 6 onwards
For i = 6 To collection.count
   ' Kill collection(i)
   Debug.Print collection(i)
Next i
   Debug.Print collection(i)
End Sub

Function SortCollectionDesc(collection As collection)
'Sort collection descending by datecreated using standard bubble sort
Dim coll As New collection

Set coll = collection
    Dim i As Long, j As Long
    Dim vTemp As Object


    'Two loops to bubble sort
   For i = 1 To coll.count - 1
        For j = i + 1 To coll.count
            If coll(i).DateCreated < coll(j).DateCreated Then
                'store the lesser item
               Set vTemp = coll(j)
                'remove the lesser item
               coll.Remove j
                're-add the lesser item before the greater Item
               coll.Add Item:=vTemp, before:=i
               Set vTemp = Nothing
            End If
        Next j
    Next i

Set SortCollectionDesc = coll

End Function
