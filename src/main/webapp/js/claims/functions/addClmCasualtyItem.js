/**
 * @author rey
 * @date 10-06-2011
 */
function addClmCasualtyItem(){
	try{	
		if (objCLMItem.selected != {} || objCLMItem.selected != null)
			if (unescapeHTML2(objCLMItem.selected[itemGrid.getColumnIndex('giclItemPerilExist')]) == "Y") return;
		
		if($F("btnAddItem") == "Add"){
			// added by irwin 11.14.2012
			objCLMItem.newItem[0].groupedItemNo = $F("txtGrpCd");
			objCLMItem.newItem[0].groupedItemTitle 			= escapeHTML2($F("txtDspGrpDesc"));
			objCLMItem.newItem[0].amountCoverage 			= $F("txtAmtCov");
			objCLMItem.newItem[0].itemDesc = unescapeHTML2(objCLMItem.newItem[0].itemDesc); //added by steven 12/03/2012
	        objCLMItem.newItem[0].itemDesc2 = unescapeHTML2(objCLMItem.newItem[0].itemDesc2); //added by steven 12/03/2012
			/*objCLMItem.newItem[0].itemNo 					= $F("txtItemNo");
			objCLMItem.newItem[0].itemTitle 				= escapeHTML2($F("txtItemTitle"));
			objCLMItem.newItem[0].itemDesc1 				= escapeHTML2($F("txtItemDesc"));
			objCLMItem.newItem[0].groupedItemNo 			= $F("txtGrpCd");
			objCLMItem.newItem[0].goupedItemTitle 			= escapeHTML2($F("txtDspGrpDesc"));
			objCLMItem.newItem[0].itemDesc2 				= escapeHTML2($F("txtItemDesc2"));
			objCLMItem.newItem[0].currencyCd 				= $F("txtCurrencyCd");
			objCLMItem.newItem[0].currencyDesc 				= escapeHTML2($F("txtDspCurrencyDesc"));
			objCLMItem.newItem[0].propertyNoType 			= escapeHTML2($F("txtProperty"));
			objCLMItem.newItem[0].propertyNo 				= $F("txtPropertyNo");
			objCLMItem.newItem[0].currencyRate 				= $F("txtCurencyRate");
			objCLMItem.newItem[0].location 					= escapeHTML2($F("txtLocation"));
			objCLMItem.newItem[0].sectionOrHazardCd 		= escapeHTML2($F("txtSecHazCd"));
			objCLMItem.newItem[0].conveyanceInfo 			= escapeHTML2($F("txtConveyance"));
			objCLMItem.newItem[0].sectionOrHazardInfo 		= escapeHTML2($F("txtSecHazInfo"));
			objCLMItem.newItem[0].interestOnPremises 		= escapeHTML2($F("txtInterestPrems"));
			objCLMItem.newItem[0].amountCoverage 			= $F("txtAmtCov");
			objCLMItem.newItem[0].limitOfLiability 			= escapeHTML2($F("txtLimLiablty"));
			objCLMItem.newItem[0].capacityCd 				= $F("txtCapacityCd");
			objCLMItem.newItem[0].position 					= escapeHTML2($F("txtPosition"));
			objCLMItem.newItem[0].personnelName 			= escapeHTML2($F("txtPersonnel"));
			objCLMItem.newItem[0].positionDesc 				= escapeHTML2($F("txtCaPosition"));*/
		}else{
			var gIndex = objCLMItem.selItemIndex ; 
			itemGrid.setValueAt($F("txtItemNo"),itemGrid.getColumnIndex("itemNo"),gIndex,true);
			itemGrid.setValueAt(escapeHTML2($F("txtItemTitle")),itemGrid.getColumnIndex("itemTitle"),gIndex,true);
			itemGrid.setValueAt(escapeHTML2($F("txtItemDesc")),itemGrid.getColumnIndex("itemDesc1"),gIndex,true);
			itemGrid.setValueAt($F("txtGrpCd"),itemGrid.getColumnIndex("groupedItemNo"),gIndex,true);
			itemGrid.setValueAt(escapeHTML2($F("txtDspGrpDesc")),itemGrid.getColumnIndex("goupedItemTitle"),gIndex,true);
			itemGrid.setValueAt(escapeHTML2($F("txtItemDesc2")),itemGrid.getColumnIndex("itemDesc2"),gIndex,true);
			itemGrid.setValueAt($F("txtCurrencyCd"),itemGrid.getColumnIndex("currencyCd"),gIndex,true);
			itemGrid.setValueAt(escapeHTML2($F("txtDspCurrencyDesc")),itemGrid.getColumnIndex("currencyDesc"),gIndex,true);
			itemGrid.setValueAt(escapeHTML2($F("txtProperty")),itemGrid.getColumnIndex("propertyNoType"),gIndex,true);
			itemGrid.setValueAt($F("txtPropertyNo"),itemGrid.getColumnIndex("propertyNo"),gIndex,true);
			itemGrid.setValueAt($F("txtCurencyRate"),itemGrid.getColumnIndex("currencyRate"),gIndex,true);
			itemGrid.setValueAt(escapeHTML2($F("txtLocation")),itemGrid.getColumnIndex("location"),gIndex,true);
			itemGrid.setValueAt(escapeHTML2($F("txtSecHazCd")),itemGrid.getColumnIndex("sectionOrHazardCd"),gIndex,true);
			itemGrid.setValueAt(escapeHTML2($F("txtConveyance")),itemGrid.getColumnIndex("conveyanceInfo"),gIndex,true);
			itemGrid.setValueAt(escapeHTML2($F("txtSecHazInfo")),itemGrid.getColumnIndex("sectionOrHazardInfo"),gIndex,true);
			itemGrid.setValueAt(escapeHTML2($F("txtInterestPrems")),itemGrid,getColumnIndex("interestOnPremises"),gIndex,true);
			itemGrid.setValueAt($F("txtAmtCov"),itemGrid.getColumnIndex("amountCoverage"),gIndex,true);
			itemGrid.setValueAt(escapeHTML2($F("txtLimLiablty")),itemGrid.getColumnIndex("limitOfLiability"),gIndex,true);
			itemGrid.setValueAt($F("txtCapacityCd"),itemGrid.getColumnIndex("capacityCd"),gIndex,true);
			itemGrid.setValueAt(escapeHTML2($F("txtPosition")),itemGrid.getColumnIndex("position"),gIndex,true);
			itemGrid.setValueAt(escapeHTML2($F("txtPersonnel")),itemGrid.getColumnIndex("personnelName"),gIndex,true);
			itemGrid.setValueAt(escapeHTML2($F("txtCaPosition")),itemGrid.getColumnIndex("positionDesc"),gIndex,true);		
		}
		
		// Modified by J. Diago 10.17.2013 : Added validation of Location.
		if (nvl(objCLMItem.ora2010SwCA,"N") == "Y"){
			if (nvl(objCLMItem.objCALossLocation1,"") != $F("txtLocation")){
				if (!checkLocationOfLoss()) return false;
			}else{
				addClmItem();
			}
		}else{	//added by kenneth 11.18.2014
			addClmItem();
		}
		
		//addClmItem();		
	}
	catch(e){
		showErrorMessage("addClmCasualtyItem",e);
	}
}