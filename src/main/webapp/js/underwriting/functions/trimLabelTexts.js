function trimLabelTexts(){
	$$("label[name='sublineText']").each(function (label)	{
		if ((label.innerHTML).length > 30)	{
			label.update((label.innerHTML).truncate(30, "..."));
		}
	});
	
	$$("label[name='remarksText']").each(function (label)	{
		if ((label.innerHTML).length > 20)	{
			label.update((label.innerHTML).truncate(20, "..."));
		}
	});
}