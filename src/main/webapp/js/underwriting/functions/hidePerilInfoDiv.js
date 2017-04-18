function hidePerilInfoDiv()	{
	$$("div[name='perilInformationDiv']").each(function (perilDiv)	{
		perilDiv.hide();
	}); 
	//$("btnShowPerils").value = "Show Perils";
}