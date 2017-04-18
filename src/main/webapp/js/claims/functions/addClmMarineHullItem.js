/**
 * @author rey
 * @date 07.12.2011
 */
function addClmMarineHullItem(){
	try{
		if (objCLMItem.selected != {} || objCLMItem.selected != null)
			if (unescapeHTML2(objCLMItem.selected[itemGrid.getColumnIndex('giclItemPerilExist')]) == "Y") return;
		
		if($F("btnAddItem") == "Add"){
			/*objCLMItem.newItem[0].itemNo 					= $F("txtItemNo");
			objCLMItem.newItem[0].itemTitle 				= escapeHTML2($F("txtItemTitle"));
			objCLMItem.newItem[0].currencyCd				= $F("txtCurrencyCd");
			objCLMItem.newItem[0].itemTitle					= escapeHTML2($F("txtItemTitle"));
			objCLMItem.newItem[0].vesselCd					= escapeHTML2($F("txtVesselCd"));	 
			objCLMItem.newItem[0].geogLimit					= $F("txtGeoLimit");
			objCLMItem.newItem[0].deductText				= escapeHTML2($F("txtDeduct"));
			objCLMItem.newItem[0].dryDate					= escapeHTML2($F("txtDryDate"));
			objCLMItem.newItem[0].dryPlace					= escapeHTML2($F("txtDryPlace"));
			objCLMItem.newItem[0].currencyRate				= $F("txtCurencyRate");*/
		}else{
			var gIndex = objCLMItem.selItemIndex ; 
			itemGrid.setValueAt($F("txtItemNo"),itemGrid.getColumnIndex("itemNo"),gIndex,true);
			itemGrid.setValueAt(escapeHTML2($F("txtItemTitle")),itemGrid.getColumnIndex("itemTitle"),gIndex,true);
			itemGrid.setValueAt($F("txtCurrencyCd"),itemGrid.getColumnIndex("currencyCd"),gIndex,true);
			itemGrid.setValueAt(escapeHTML2($F("txtItemTitle")),itemGrid.getColumnIndex("itemTitle"),gIndex,true);
			itemGrid.setValueAt(escapeHTML2($F("txtVesselCd")),itemGrid.getColumnIndex("vesselCd"),gIndex,true);
			itemGrid.setValueAt($F("txtGeoLimit"),itemGrid.getColumnIndex("geogLimit"),gIndex,true);
			itemGrid.setValueAt(escapeHTML2($F("txtDeduct")),itemGrid.getColumnIndex("deductText"),gIndex,true);
			itemGrid.setValueAt(escapeHTML2($F("txtDryDate")),itemGrid.getColumnIndex("dryDate"),gIndex,true);
			itemGrid.setValueAt(escapeHTML2($F("txtDryPlace")),itemGrid.getColumnIndex("dryPlace"),gIndex,true);
			itemGrid.setValueAt($F("txtCurencyRate"),itemGrid.getColumnIndex("currencyRate"),gIndex,true);
		}		
		
		addClmItem();
		clearMarineHullItems();
		
	}catch(e){
		showErrorMessage("addClmMarineHullItem",e);
	}
}