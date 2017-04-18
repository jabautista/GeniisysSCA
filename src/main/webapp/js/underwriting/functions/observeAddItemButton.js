/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	10.14.2011	mark jm			set observer for add item button (table grid)
 */
function observeAddItemButton(addItemFunc){
	try{
		$("btnAddItem").observe("click", function(){
			function clearItemFormChangedAttribute(){
				($$("div#itemInformationDiv [changed=changed]")).invoke("removeAttribute", "changed");
				($$("div#additionalItemInformationDiv [changed=changed]")).invoke("removeAttribute", "changed");
				($$("div#personalAdditionalInformationInfo [changed=changed]")).invoke("removeAttribute", "changed");
			}
			
			function resetItemForm(){
				setParItemFormTG(null);
				setDefaultItemForm();
				clearItemFormChangedAttribute();
			}
			
			function preAdd(){
				//belle 05.22.2012 
				if($F("btnAddItem") == "Add") {
					objFormMiscVariables.miscNbtInvoiceSw = "Y";
				}

				if (objUWParList.binderExist == "Y" && objFormMiscVariables.miscNbtInvoiceSw == "Y"){
					showMessageBox("This PAR has corresponding records in the posted tables for RI. Could not proceed.", imgMessage.ERROR);		
					objFormMiscVariables.miscNbtInvoiceSw = "N";
					return false;
				}

				if(objFormParameters.paramIsPack == "Y" && $F("btnAddItem") == "Add"){ // added by andrew - 03.17.2011 - added to validate if package
					showConfirmBox("Confirmation", "You are not allowed to create items here. Create a new item in module Package Policy Item Data Entry - Policy?", "Yes", "No", showPackPolicyItems, "");
					return false;			
				}else if(objGIPIWPolbas.planSw == "Y" && objFormParameters.paramOra2010Sw == "Y" && $F("btnAddItem") == "Add" && objGIPIWItem.filter(function(o){	return nvl(o.recordStatus, 0) != -1;	}).length > 0){
					showMessageBox("You are not allowed to have more than one item for a package plan.", imgMessage.INFO);
					setParItemFormTG(null);
					setDefaultItemForm();
					($$("div#itemInformationDiv [changed=changed]")).invoke("removeAttribute", "changed");
					changeTag = 0;
					return false;
				}else if((tbgItemTable.getDeletedRows()).length > 0){
					showMessageBox("Please save changes first before adding new item.", imgMessage.INFO);
					clearItemFormChangedAttribute();
					return false;		
				}else if($("globalWithTariffSw").value == "Y"){
					var lineCd = getLineCd();
					var result = checkExistingTariffPeril($F("itemNo"));
					if (result == "X") {
						showConfirmBox("Tariff", "Existing peril is based on tariff rates. Changes will automatically delete the peril information." +
								" Do you want to continue?","Yes","No", function() {
								for ( var j = 0; j < objGIPIWItemPeril.length; j++) {
									if(objGIPIWItemPeril[j].itemNo == $F("itemNo")){
										objGIPIWItemPeril[j].recordStatus = -1;
									}
								}
								tbgItemPeril.empty();
								tbgItemPeril.clear();
								objDefaultPerilAmts.deleteWitemPerilTariff = true;		
								addItemFunc();
								}, function() {
									if (lineCd == "FI") {
										$("coverage").value 	= objDefaultPerilAmts.coverageCd;
										$("tariffZone").value 	= objDefaultPerilAmts.tariffZone;
										$("construction").value = objDefaultPerilAmts.tarfCd;
										$("construction").value = objDefaultPerilAmts.constructionCd;
									}else if (lineCd == "MC") {
										$("sublineType").value 	= objDefaultPerilAmts.sublineTypeCd;
										$("motorType").value 	= objDefaultPerilAmts.motorTypeCd;
									}
									objDefaultPerilAmts.deleteWitemPerilTariff = false;
								}
						);						
					}else {
						addItemFunc();
					}
				}else{			
					if($F("btnAddItem") == "Add" && objGIPIWPerilDiscount.length > 0 && objFormMiscVariables.miscDeletePerilDiscById == "N" && objFormMiscVariables.miscCopy == "N"){
						showConfirmBox("Discount", "Adding new item will result to the deletion of all discounts. Do you want to continue?",
								"Continue", "Cancel", function(){
							deleteDiscounts();
							addItemFunc();
						}, stopProcess);
						return false;
					}else{
						addItemFunc();
					}
				}
			}
			
			if($F("itemTitle").blank() || $F("itemTitle") == "") {
				var lineCd = getLineCd();
				
				if(lineCd != "FI" && lineCd != "MC"){
					//customShowMessageBox("Please enter the item title first.", imgMessage.ERROR, "itemTitle");
					customShowMessageBox("Required fields must be entered.", imgMessage.ERROR, "itemTitle");
					return false;
				}				
			}
			
			/*if((($$("div#itemInformationDiv [changed=changed]").length < 1 && $$("div#additionalItemInformationDiv [changed=changed]").length < 1) && objFormMiscVariables.miscCopy != "Y") && changeTag == 0){
				$$("#itemInfoTableGrid .selectedRow").invoke("removeClassName", "selectedRow");
				setParItemFormTG(null);
				setDefaultItemForm();
				return false;
			}*/
			
			/*if(!(isAllItemHasPerils())){
				if($F("btnAddItem") == "Add"){
					resetItemForm();
					
					showWaitingMessageBox("Please add peril/s before adding new item.", imgMessage.INFO, function(){	$("btnSave").click();	});	
				}else{
					preAdd();	
				}			
			}else{				
				if(objGIPIWItem.filter(function(o){ return o.recordStatus == 0; }).length == 1){
					resetItemForm();				
					showMessageBox("Please save changes first before adding new item.", imgMessage.INFO);
					return false;
				}else{
					preAdd();	
				}						
			}*/ // removed condition to allow saving of items even others have existing perils - Nica 04.17.2013	
			
			if(objGIPIWItem.filter(function(o){ return o.recordStatus == 0; }).length == 1){
				resetItemForm();				
				showMessageBox("Please save changes first before adding new item.", imgMessage.INFO);
				return false;
			}else{
				preAdd();	
			}
		});
	}catch(e){
		showErrorMessage("observeAddItemButton", e);
	}
}