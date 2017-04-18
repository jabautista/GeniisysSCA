function changeQuotationContainers(param){
	var subline = $("subline").options[$("subline").selectedIndex].text;
	var sublineCd = $("subline").options[$("subline").selectedIndex].getAttribute("sublineCd");
	var sublineName = $("subline").options[$("subline").selectedIndex].getAttribute("sublineName");
	//var issSource = $("issSource").value;
	var issSource = $("issName").value;	//emsy09102012
	var content1 = '<input id="subline" name="subline" style="width: 170px;" type="text" value="'+subline+'" sublineCd="'+sublineCd+'" sublineName="'+sublineName+'" readonly="readonly" />';
	var content2 = '<input id="issSource" name="issSource" style="width: 170px;" type="text" value="'+issSource+'" readonly="readonly" />';
	$("sublineContainer").innerHTML = "";
	$("sublineContainer").update(content1);
	$('subline').observe("focus", function ()	{
		$('subline').addClassName("textFocused");
	});
	$('subline').observe("blur", function ()	{
		$('subline').removeClassName("textFocused");
	});
	$("issSourceContainer").innerHTML = "";
	$("issSourceContainer").update(content2);
	$('issSource').observe("focus", function ()	{
		$('issSource').addClassName("textFocused");
	});
	$('issSource').observe("blur", function ()	{
		$('issSource').removeClassName("textFocused");
	});			
}