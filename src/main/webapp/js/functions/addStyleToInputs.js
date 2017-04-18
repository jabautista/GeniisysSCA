// add style to inputs depending on type, 
// this was used before to handle IE6
function addStyleToInputs()	{
	//$$('input[type="text"], .text').each(function (obj) {
	//	obj.setStyle("font-size: 11px; font-family: Verdana; color: #000000; border: solid 1px gray; padding: 3px;");
	//});
	
	$$('input[type="checkbox"]').each(function (chk)	{
		chk.setStyle("margin: 0; width: 13px; height: 13px; overflow: hidden;");
	});
}