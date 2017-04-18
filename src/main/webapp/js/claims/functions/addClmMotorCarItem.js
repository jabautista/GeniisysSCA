/**
 * Add new motor item info record
 * 
 * @author Irwin Tabisora
 */
function addClmMotorCarItem(){
	try{
		if (objCLMItem.selected != {} || objCLMItem.selected != null) 
			// if
			// (unescapeHTML2(objCLMItem.selected[itemGrid.getColumnIndex('giclItemPerilExist')])
			// == "Y") return; commented out muna dahil wala nmn tlga na eedit
			// sa motor car aside sa driver details - irwin
		if (nvl(objCLMItem.ora2010Sw,"N") == "Y"){ // comment ko muna - nok }
													// &&
													// (itemGrid.getModifiedRows().length
													// != 0 ||
													// itemGrid.getNewRowsAdded().length
													// != 0)){
			/*$("txtAssignee").hide();
			$("lblAssignee").hide();*/ 
		}else{
			/*$("txtAssignee").show();
			$("lblAssignee").show();*/
		}
		if 	($F("txtItemNo") != ""){
			if($F("btnAddItem") == "Add"){
				if(objCLMGlobal.driverInfoPopulateSw == "Y"){
					objCLMItem.newItem[0].drvrName = escapeHTML2($F("txtDrvrName"));
					objCLMItem.newItem[0].drvrOccCd = $F("txtDrvrOccCd");
					objCLMItem.newItem[0].drvrOccDesc = escapeHTML2($F("txtDrvrOccDesc"));
					objCLMItem.newItem[0].drvrAdd = escapeHTML2($F("txtDrvrAdd"));
					objCLMItem.newItem[0].relation = escapeHTML2($F("txtRelation"));
					objCLMItem.newItem[0].drvngExp = $F("txtDrvngExp");
					objCLMItem.newItem[0].drvrAge = $F("txtDrvrAge");
					objCLMItem.newItem[0].drvrSex = $F("txtDrvrSex");
					objCLMItem.newItem[0].nationalityCd = $F("txtNationalityCd");
					objCLMItem.newItem[0].nationalityDesc = $F("txtNationalityDesc");
				}
			}else{
				if(objCLMGlobal.driverInfoPopulateSw == "Y"){
					var gIndex = objCLMItem.selItemIndex ;
					itemGrid.setValueAt(escapeHTML2($F("txtDrvrName")),itemGrid.getColumnIndex("drvrName"),gIndex,true);
					itemGrid.setValueAt($F("txtDrvrOccCd"),itemGrid.getColumnIndex("drvrOccCd"),gIndex,true);
					itemGrid.setValueAt(escapeHTML2($F("txtDrvrOccDesc")),itemGrid.getColumnIndex("drvrOccDesc"),gIndex,true);
					itemGrid.setValueAt(escapeHTML2($F("txtDrvrAdd")),itemGrid.getColumnIndex("drvrAdd"),gIndex,true);
					itemGrid.setValueAt(escapeHTML2($F("txtRelation")),itemGrid.getColumnIndex("relation"),gIndex,true);
					itemGrid.setValueAt($F("txtDrvngExp"),itemGrid.getColumnIndex("drvngExp"),gIndex,true);
					itemGrid.setValueAt($F("txtDrvrAge"),itemGrid.getColumnIndex("drvrAge"),gIndex,true);
					itemGrid.setValueAt(escapeHTML2($F("txtDrvrSex")),itemGrid.getColumnIndex("drvrSex"),gIndex,true);
					itemGrid.setValueAt(escapeHTML2($F("txtNationalityCd")),itemGrid.getColumnIndex("nationalityCd"),gIndex,true);
					itemGrid.setValueAt(escapeHTML2($F("txtNationalityDesc")),itemGrid.getColumnIndex("nationalityDesc"),gIndex,true);
				}
			}
		}
		
		addClmItem();
		
	}catch(e){
		showErrorMessage("addClmMotorCarItem",e);
	}
}