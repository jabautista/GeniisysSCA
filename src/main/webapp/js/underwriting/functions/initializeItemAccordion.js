/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	08.18.2011	mark jm			item version of initializeAccordion
 * 	09.02.2011	mark jm			added case for accessory
 * 	09.13.2011	mark jm			added case for grouped items and personnel
 * 	09.21.2011	mark jm			added case for cargo carriers
 * 	09.29.2011	mark jm			added case for accident beneficiary
 * 	10.03.2011	mark jm			added case for grouped items beneficiary
 * 	10.06.2011	mark jm			added case for grouped itemperil coverage
 */
function initializeItemAccordion(){
	try{
		$$("label[name='groItem']").each(function (label)	{
			var tableGridName = "";
			tableGridName = label.getAttribute("tableGrid");
			
			label.observe("click", function(){
				if(tableGridName == "tbgItmperlGrouped"){			
					/*if(objGIPIWItemPeril.length > 0 && objGIPIWItmperlGrouped.length == 0){
						showMessageBox("You cannot insert grouped item perils because there are existing item perils for this item. " +
								"Please check the records in the item peril module.", imgMessage.INFO);
						return false;
					}*/ //belle 09132012 replaced by codes below 
					
					var cntItemPeril = 0;
					var cntItemPerilGrp = 0;
					
					for (var i=0; i<objGIPIWItemPeril.length; i++ ){
						if (objGIPIWItemPeril[i].itemNo == $F("itemNo")){
							cntItemPeril++;
						}
					}
					
					for (var i=0; i<objGIPIWItmperlGrouped.length; i++ ){
						if (objGIPIWItmperlGrouped[i].itemNo == $F("itemNo")){
							cntItemPerilGrp++;
						}
					}
					
					if(cntItemPeril > 0 && cntItemPerilGrp == 0){
						showMessageBox("You cannot insert grouped item perils because there are existing item perils for this item. " +
								"Please check the records in the item peril module.", imgMessage.INFO);
						return false;
					}			
					
				}

				label.innerHTML = label.innerHTML == "Hide" ? "Show" : "Hide";
				var infoDiv = label.up("div", 1).next().readAttribute("id");
				
				// Apollo 10.28.2014 - Prevents losing of newly added record when hiding/showing a block
				function resize(){
					if(!label.getAttribute("clicked")) {
						switch(tableGridName){
							case "tbgPolicyDeductible"		: (nvl(tbgPolicyDeductible, false) ? tbgPolicyDeductible.resize() : null); break;
							case "tbgItemDeductible"		: (nvl(tbgItemDeductible, false) ? tbgItemDeductible.resize() : null); break;
							case "tbgMortgagee"				: (nvl(tbgMortgagee, false) ? tbgMortgagee.resize() : null); break;
							case "tbgItemPeril"				: (nvl(tbgItemPeril, false) ? tbgItemPeril.resize() : null); break;
							case "tbgPerilDeductible"		: (nvl(tbgPerilDeductible, false) ? tbgPerilDeductible.resize() : null); break;
							case "tbgAccessory"				: (nvl(tbgAccessory, false) ? tbgAccessory.resize() : null); break;
							case "tbgGroupedItems"			: (nvl(tbgGroupedItems, false) ? tbgGroupedItems.resize() : null); break;
							case "tbgCasualtyPersonnel"		: (nvl(tbgCasualtyPersonnel, false) ? tbgCasualtyPersonnel.resize() : null); break;
							case "tbgCargoCarriers"			: (nvl(tbgCargoCarriers, false) ? tbgCargoCarriers.resize() : null); break;
							case "tbgBeneficiary"			: (nvl(tbgBeneficiary, false) ? tbgBeneficiary.resize() : null); break;
							case "tbgGrpItemsBeneficiary"	: (nvl(tbgGrpItemsBeneficiary, false) ? tbgGrpItemsBeneficiary.resize() : null);
															  (nvl(tbgItmperlBeneficiary, false) ? tbgItmperlBeneficiary.resize() : null); break;
							case "tbgItmperlGrouped"		: (nvl(tbgItmperlGrouped, false) ? tbgItmperlGrouped.resize() : null); break;
						}		
						
						label.setAttribute("clicked", true);
					}
				}
				
				Effect.toggle(infoDiv, "blind", {
					duration: .3, 
					afterFinish: resize
				});	
				
				/*Effect.toggle(infoDiv, "blind", {
					duration: .3, 
					afterFinish: function(){
						switch(tableGridName){
							case "tbgPolicyDeductible"		: (nvl(tbgPolicyDeductible, false) ? tbgPolicyDeductible.resize() : null); break;
							case "tbgItemDeductible"		: (nvl(tbgItemDeductible, false) ? tbgItemDeductible.resize() : null); break;
							case "tbgMortgagee"				: (nvl(tbgMortgagee, false) ? tbgMortgagee.resize() : null); break;
							case "tbgItemPeril"				: (nvl(tbgItemPeril, false) ? tbgItemPeril.resize() : null); break;
							case "tbgPerilDeductible"		: (nvl(tbgPerilDeductible, false) ? tbgPerilDeductible.resize() : null); break;
							case "tbgAccessory"				: (nvl(tbgAccessory, false) ? tbgAccessory.resize() : null); break;
							case "tbgGroupedItems"			: (nvl(tbgGroupedItems, false) ? tbgGroupedItems.resize() : null); break;
							case "tbgCasualtyPersonnel"		: (nvl(tbgCasualtyPersonnel, false) ? tbgCasualtyPersonnel.resize() : null); break;
							case "tbgCargoCarriers"			: (nvl(tbgCargoCarriers, false) ? tbgCargoCarriers.resize() : null); break;
							case "tbgBeneficiary"			: (nvl(tbgBeneficiary, false) ? tbgBeneficiary.resize() : null); break;
							case "tbgGrpItemsBeneficiary"	: (nvl(tbgGrpItemsBeneficiary, false) ? tbgGrpItemsBeneficiary.resize() : null);
															  (nvl(tbgItmperlBeneficiary, false) ? tbgItmperlBeneficiary.resize() : null); break;
							case "tbgItmperlGrouped"		: (nvl(tbgItmperlGrouped, false) ? tbgItmperlGrouped.resize() : null); break;
						}
					}
				});*/							
			});
		});
		
/*		if ($("showDeductible3") != null){
			objUWGlobal.parItemPerilChangeTag = 0; // andrew - 07.25.2012 SR 10143
			$("showDeductible3").observe("click", function(){ // andrew - 07.25.2012 SR 10143
				if(objUWGlobal.parItemPerilChangeTag == 1 && $("showDeductible3").innerHTML == "Show"){
					showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
					return false;
				} else {
					$("showDeductible3").innerHTML = $("showDeductible3").innerHTML == "Hide" ? "Show" : "Hide";
					var infoDiv = $("showDeductible3").up("div", 1).next().readAttribute("id");
					
					Effect.toggle(infoDiv, "blind", {
						duration: .3, 
						afterFinish: function(){					
							(nvl(tbgPerilDeductible, false) ? tbgPerilDeductible.resize() : null);					
						}
					});
				}
			});
		}*/
	}catch(e){
		showErrorMessage("initializeItemAccordion", e);
	}		
}