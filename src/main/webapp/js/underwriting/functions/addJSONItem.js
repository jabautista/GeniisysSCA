function addJSONItem(obj) {
	try {
		if (obj != null || isItemInfoValid()) {			
			var lineCd = (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : getLineCd());	
			var newObj = (obj != null ? obj : setEndtItemObj());
			newObj.parId = (nvl(newObj.parId, "0") == "0") ? objUWParList.parId : newObj.parId; //inserting parId when record for insert come from GIPI_ITEM - BRYAN 12.14.2010
			content = prepareEndtItemInfo(newObj);
			
			if($F("btnAddItem") == "Update" && obj == null){
				$("row"+newObj.itemNo).update(content);
				//addModifiedJSONObject(objEndtMNItems, newObj);
				addModifiedJSONObject(getItemObjects(), newObj);
				toggleEndtItemPeril("", objGIPIWItemPeril, objGIPIItemPeril); // andrew 01.07.2011 added this line
			} else {
				//addNewJSONObject(objEndtMNItems, newObj);	// commented by mark jm 09.30.2010 replaced with the next line
				addNewObjByLine(newObj);
				
				if (lineCd == "MN"){
					if ($F("paramPolFlagSw") != "N") {
						showMessageBox("This policy is cancelled, creation of new item is not allowed.", imgMessage.INFO);
						return false;
					}
				} 
				
				var itemTable = $("parItemTableContainer");
				var newDiv = new Element("div");
				newDiv.setAttribute("id", "row"+newObj.itemNo);
				newDiv.writeAttribute("new");
				newDiv.setAttribute("name", "row");
				newDiv.setAttribute("item", newObj.itemNo);
				newDiv.setStyle("display: none;");
				newDiv.addClassName("tableRow");
				
				newDiv.update(content);
				itemTable.insert({bottom : newDiv});
				
				loadRowMouseOverMouseOutObserver(newDiv);
								
				newDiv.observe("click", function() {
					clickParItemRow(newDiv, getItemObjects());
				});
				
				checkIfToResizeTable("parItemTableContainer", "row");
				checkTableIfEmpty("row", "itemTable");
				
				new Effect.Appear("row"+newObj.itemNo, {
						duration: 0.2
					});				
			}
			
			if(objUWGlobal.lineCd == objLineCds.MN || objUWGlobal.menuLineCd == objLineCds.MN){
				checkIfMultipleCarrier(newObj.itemNo, newObj.vesselCd);
				setDefaultValues();
			}
			
			setParItemForm();			
		}
	} catch (e) {
		showErrorMessage("addJSONItem", e);
	}
}