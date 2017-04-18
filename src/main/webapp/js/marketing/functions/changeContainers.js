/**moved from creationQuotation.jsp - irwin*/
function changeContainers(param){
	if(param=="text"){
		var subline = $("subline").value;
		var issSource = $("issSource").value;			
		var content1 = '<input id="subline" name="subline" style="width: 170px;" type="text" value="'+subline+'" readonly="readonly" />';
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
}