/*	Created by	: mark jm 12.15.2010
 * 	Description	: create the new object containing the details and add it to the list
 */
function addParItem(){
	try{
		var lineCd = (objUWGlobal.packParId != null ? objCurrPackPar.lineCd : $F("globalLineCd"));
		var newObj = setParItemObj();
		content = prepareEndtItemInfo(newObj);
		
		if($F("btnAddItem") == "Update"){
			$("row" + newObj.itemNo).update(content);
			addModifiedJSONObject(objGIPIWItem, newObj);
			fireEvent($("row" + newObj.itemNo), "click");
		}else{
			//addNewObjectByLine(newObj);
			if (objUWParList.binderExist == "Y"){
				showMessageBox("This PAR has corresponding records in the posted tables for RI. Could not proceed.", imgMessage.ERROR);				
				return false;
			}
			
			objFormMiscVariables.miscNbtInvoiceSw = "Y"; // Added by irwin. 11.24.11
			newObj.recordStatus = 0;
			objGIPIWItem.push(newObj);
			
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
			
			objItemNoList.push({"itemNo" : newObj.itemNo});
			
			checkIfToResizeTable("parItemTableContainer", "row");
			checkTableIfEmpty("row", "itemTable");			
			
			new Effect.Appear("row"+newObj.itemNo, {
					duration: 0.2
				});
		}
		
		setParItemForm(null);
		($$("div#itemInformationDiv [changed=changed]")).invoke("removeAttribute", "changed");
		($$("div#additionalItemInformationDiv [changed=changed]")).invoke("removeAttribute", "changed");		
		if (lineCd == "FI") {
			$("zoneDiv").removeAttribute("zoned");	//Gzelle 05252015 SR4347
		}
		if (objFormParameters.paramMenuLineCd == "CA") { //Deo [01.26.2017]: SR-23702
			supplyCAGrpItms(newObj.itemNo.toString());
	    }
	}catch(e){
		showErrorMessage("addParItem", e);
	}
}