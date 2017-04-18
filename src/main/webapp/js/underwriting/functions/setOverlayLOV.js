/**
 * Creates rows showing the list of values  
 * available for the joining of groups overlay.
 * @param id
 * @param objArray
 * @param width
 * @return
 */
function setOverlayLOV(id, objArray, width){
	try{
		for(var a=0; a<objArray.length; a++){
			var newDiv = new Element("div");
			newDiv.setAttribute("id", a);
			newDiv.setAttribute("name", id+"LovRow");
			newDiv.setAttribute("val", objArray[a]);
			newDiv.setAttribute("class", "lovRow");
			newDiv.setStyle("width:98%; margin:auto;");
			
			var codeDiv = new Element("label");
			codeDiv.setStyle("width:100%; float:left; text-align:center;");
			codeDiv.setAttribute("title", nvl(objArray[a],''));
			codeDiv.update(nvl(objArray[a],'&nbsp;'));
			
			newDiv.update(codeDiv);
			$("lovListingDiv").insert({bottom: newDiv});
			var header1 = generateOverlayLovHeader('100%', 'Existing Groups');
			$("lovListingDivHeader").innerHTML = header1;
			$("lovListingMainDivHeader").show();
		}
	}catch(e){
		showErrorMessage("setOverlayLOV", e);
	}
}