function addDeleteItems(choice, itemNos){
	try {
		if(choice == 1){
			for(var a=0; a<itemNos.length; a++){
				for (var i=0; i<objPolbasics.length; i++) {
					for(var j=0; j<objPolbasics[i].gipiItems.length; j++){					
						if(objPolbasics[i].gipiItems[j].itemNo == itemNos[a]){	
							objPolbasics[i].gipiItems[j].recFlag = "C"; //items added through this process acquires a C recFlag; BJGA 12.17.2010
							addEndtItem(objPolbasics[i].gipiItems[j]);
							
							if (objFormParameters.paramMenuLineCd == "CA") { //Added by Jerome 12.01.2016 SR 5606
								var pflSublineCd = objFormParameters.paramSublineCd.split(",");
								for (var i = 0; i < pflSublineCd.length; i++){
									var pflSublineCd2 = pflSublineCd[i];
									
									if ($F("globalSublineCd") == ltrim(pflSublineCd2)) {
										$("rowLocationCd").show();
										$("locationCd").addClassName("required");
										break;
									}
								}
						    }
						}
					}
				}
			}
			if (objFormParameters.paramMenuLineCd == "CA") { //Deo [01.26.2017]: SR-23702
				supplyCAGrpItms(itemNos.toString());
		    }
		} else if (choice == 2) {
			for(var i=0; i<itemNos.length; i++){
				for(var j=0; j<objGIPIWItem.length; j++){
					if(parseInt(objGIPIWItem[j].itemNo) == itemNos[i]){
						/*var itemNo = $F("itemNo");

						var itemTsiDeductibleExist = checkDeductibleType(objDeductibles, 1, "T");		

						if(itemTsiDeductibleExist && objFormMiscVariables.miscDeletePolicyDeductibles == "N"){
							showConfirmBox("Deductibles", "The PAR has an existing deductible based on % of TSI.  Deleting the item will delete the existing deductible. Continue?",
									"Yes", "No", function(){				
								delRec(itemNo);
							}, stopProcess);
						}else{
							delRec(itemNo);
						}*/
						
						deleteParItem(objGIPIWItem[j]);
						objGIPIWItem[j].recordStatus = -1; //marco - 04.14.2014
					}
				}
			}
		}
		
		//marco - 04.14.2014 - added to filter drop down list
		if($("vesselCd") != null){
			filterAviationVesselLOV("vesselCd", "");
		}
		//fireEvent($("btnSave"), "click"); // added by irwin 11.25.11
	} catch (e) {
		showErrorMessage("addDeleteItems", e);
	}
}