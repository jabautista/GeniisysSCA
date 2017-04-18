function getItemPerilDetails(){
	var itemNo = $F("itemNo");
	hideAllItemPerilOptions(); 		
	selectItemPerilOptionsToShow(); 
	hideExistingItemPerilOptions();  
	//showItemPerilMotherDiv($F("itemNo"));
	/*$$("div[name='row2'").each(function(row){
		row.hide();
		if (row.down("input", 0).value == itemNo){
			row.show();
		}
	});*/
	//$$("div[name='itemPerilMotherDiv']").each(function(i){i.hide();});
	hideItemPerilInfos();
	/*	Modified by		: mark jm 09.15.2010
	 * 	Modification	: Check first if item has existing peril
	 * 					: before showing peril details
	 */
	if(checkIfItemHashExistingPeril2(itemNo)){
		$("itemPerilMotherDiv"+$F("itemNo")).show();
		$$("div#itemPerilMotherDiv"+$F("itemNo")+" div[name='row2']").each(function(a){a.show();});
		checkIfToResizePerilTable("itemPerilMainDiv", "itemPerilMotherDiv"+$F("itemNo"), "row2");
	}	
}