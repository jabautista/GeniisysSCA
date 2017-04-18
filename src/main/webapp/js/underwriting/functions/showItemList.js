function showItemList(objArray){
	try {
		var itemTable = $("parItemTableContainer");
		
		objArray = objArray.filter(function(obj){ return nvl(obj.recordStatus, 0) != -1; });
		
		for(var i=0; i<objArray.length; i++) {			
			var content = prepareEndtItemInfo(objArray[i]);										
			var newDiv = new Element("div");
			
			newDiv.setAttribute("id", "row"+objArray[i].itemNo);
			newDiv.setAttribute("name", "row");
			newDiv.setAttribute("parId", objArray[i].parId);
			newDiv.setAttribute("item", objArray[i].itemNo);
			newDiv.addClassName("tableRow");

			if(objUWGlobal.packParId != null && objCurrPackPar == null){
				newDiv.setStyle("display : none;");
			}
			
			newDiv.update(content);
			itemTable.insert({bottom : newDiv});
			
			// mark jm 10.08.2010
			// store item nos in object
			/*
			if($F("globalLineCd") == "CA" 
				|| $F("globalLineCd") == "MH"
				|| $F("globalLineCd") == "AH"){
				objItemNoList.push({"itemNo" : objArray[i].itemNo});
			}
			*/			
		}
		
		checkIfToResizeTable("parItemTableContainer", "row");
		checkTableIfEmpty("row", "itemTable");
		
		if(objUWGlobal.packParId != null){
			resizeTableBasedOnVisibleRows("itemTable", "parItemTableContainer");
		}		
	} catch (e) {
		showErrorMessage("showItemList", e);
		//showMessageBox("showItemList : " + e.message);
	}
}