function hideAllPerilDivs()	{
	$$("div[name='itemPerilMotherDiv']").each(function (perilDiv)	{
		perilDiv.hide();
	}); 
}