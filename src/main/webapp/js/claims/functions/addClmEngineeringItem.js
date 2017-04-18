/**
 * Add new engineering item record
 * 
 * @author eman
 */
function addClmEngineeringItem() {
	try{
		if($F("btnAddItem") == "Add"){
			objCLMItem.newItem[0].itemDesc = unescapeHTML2(objCLMItem.newItem[0].itemDesc); //added by steven 12/03/2012
			objCLMItem.newItem[0].itemDesc2 = unescapeHTML2(objCLMItem.newItem[0].itemDesc2); //added by steven 12/03/2012

			/*
			 * objCLMItem.newItem[0] = {}; objCLMItem.newItem[0].itemDesc =
			 * escapeHTML2($F("txtItemDesc")); objCLMItem.newItem[0].itemDesc2 =
			 * escapeHTML2($F("txtItemDesc2")); objCLMItem.newItem[0].currencyCd =
			 * escapeHTML2($F("txtCurrencyCd")); objCLMItem.newItem[0].currDesc =
			 * escapeHTML2($F("txtDspCurrDesc"));
			 * objCLMItem.newItem[0].regionDesc =
			 * escapeHTML2($F("txtDspRegion"));
			 * objCLMItem.newItem[0].currencyRate =
			 * escapeHTML2($F("txtCurrencyRate"));
			 * objCLMItem.newItem[0].provinceDesc =
			 * escapeHTML2($F("txtDspProvince"));
			 */
		}else{
			var gIndex = objCLMItem.selItemIndex ;
			itemGrid.setValueAt(escapeHTML2($F("txtItemDesc")),itemGrid.getColumnIndex("itemDesc"),gIndex,true);
			itemGrid.setValueAt(escapeHTML2($F("txtItemDesc2")),itemGrid.getColumnIndex("itemDesc2"),gIndex,true);
			itemGrid.setValueAt(escapeHTML2($F("txtCurrencyCd")),itemGrid.getColumnIndex("currencyCd"),gIndex,true);
			itemGrid.setValueAt(escapeHTML2($F("txtDspCurrDesc")),itemGrid.getColumnIndex("currDesc"),gIndex,true);
			itemGrid.setValueAt(escapeHTML2($F("txtDspRegion")),itemGrid.getColumnIndex("regionDesc"),gIndex,true);
			itemGrid.setValueAt(escapeHTML2($F("txtCurrencyRate")),itemGrid.getColumnIndex("currencyRate"),gIndex,true);
			itemGrid.setValueAt(escapeHTML2($F("txtDspProvince")),itemGrid.getColumnIndex("provinceDesc"),gIndex,true);
		}
		addClmItem();
		
	}catch(e){
		showErrorMessage("addClmEngineeringItem",e);
	}
}