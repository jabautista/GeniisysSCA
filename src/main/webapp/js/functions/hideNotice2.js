function hideNotice2()	{
	document.getElementById("noticeOverlay").style.display = "none";
	$$("div[name='notice']").invoke("hide");
}