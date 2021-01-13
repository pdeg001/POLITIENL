﻿B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=10.5
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: False
	#IncludeTitle: False
#End Region

Sub Process_Globals
	Dim xui As XUI
End Sub

Sub Globals
	Dim imgRotate As Float = 0
	Dim clsItemDetail As itemOwnerDetail
	Dim lstString, lstImages As List
	Dim url As String
	Private lblStationName As Label
	Private bbDescription As BBCodeView
	Private clvImage As CustomListView
	Private imgItem As ImageView
	Private pnlImg As Panel
	Private largeImage As B4XImageView
	Private imgZoom As ZoomImageView
	Private pnlimgContainer As Panel
	Private lblRotate As Label
	Private imgZoomTest As ZoomImageView
End Sub

Sub Activity_Create(FirstTime As Boolean)
	clsItemDetail.Initialize
	'***
	Activity.LoadLayout("itemFoundDetail")
	imgZoom.ImageView.Height = pnlImg.Height
	GetItemDetail
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub

Sub GetItemDetail
	clvImage.Clear
	url = $"https://api.politie.nl/v4/gezocht/eigenaargezocht?language=nl&radius=5.0&maxnumberofitems=10&offset=${Starter.itemsFoundOffset}"$
	Wait For (clsItemDetail.GetData(url, Starter.itemFoundUid)) Complete (done As Boolean)
	
	If done Then
		GetSetImages
	End If
	
End Sub

Sub SetStringItems(items As List)
	lstString.Initialize
	lstString = items
End Sub

Sub SetImageItems(image As List)
	lstImages.Initialize
	lstImages = image
	GetSetImages
End Sub

Sub GetSetImages
	For Each imageUrl As String In clsItemDetail.lstMeerafbeeldingen
		Wait For (GetImageFromUrl(imageUrl)) Complete (done As Boolean)
	Next
End Sub

Sub GetImageFromUrl(imgUrl As String)As ResumableSub
	Private job As HttpJob
	job.Initialize("", Me)
	job.Download(imgUrl)
	
	Wait For (job) jobDone(jobDone As HttpJob)
	
	If jobDone.Success Then
		
		Dim pnl As B4XView = xui.CreatePanel("")
	
		pnl.SetLayoutAnimated(0, 0, 0, 110dip, 130dip)
		pnl.LoadLayout("pnlItemImage")
		
		imgItem.Bitmap = job.GetBitmap
		
		clvImage.Add(pnl, "")
		Else
			Log(job.ErrorMessage)
	End If
	
		job.Release
		Return True
End Sub


Private Sub imgItem_Click
	Dim clickdImg As ImageView = Sender
	imgZoom.SetBitmap(clickdImg.Bitmap)
	imgZoom.ImageView.GetBitmap.Resize(pnlimgContainer.Width, pnlimgContainer.Height, True)
	pnlImg.Visible = True
	
End Sub

Private Sub pnlImg_Click
	pnlImg.Visible = False
End Sub

Private Sub lblRotate_Click
	If imgRotate = 360 Then
		imgRotate = 0
		Else
			imgRotate = imgRotate + 90
	End If
	
	imgZoom.ImageView.Rotation = imgRotate
End Sub
