//for PAR only
function deleteItemPerilsForItemNo(itemNo){
	for (var i=0; i<objGIPIWItemPeril.length; i++){
		if (objGIPIWItemPeril[i].itemNo == itemNo){ 
			objGIPIWItemPeril[i].recordStatus = -1;
		} 
	}
	
	$$("div#itemPerilMotherDiv"+itemNo+" div[name='row2']").each(function(row){
		$("perilCd").value = row.getAttribute("peril");
		Effect.Fade(row, {
			duration: .001,
			afterFinish: function (){
				//prepareItemPerilforDelete(1); // comment out by andrew - observe if this will cause error 
				row.remove();
				clearItemPerilFields();
				checkPerilTableIfEmpty("row2", "itemPerilMotherDiv"+$F("itemNo"), "itemPerilMainDiv");
				checkIfToResizePerilTable("itemPerilMainDiv", "itemPerilMotherDiv"+$F("itemNo"), "row2");
				hideAllItemPerilOptions();
				selectItemPerilOptionsToShow();
				hideExistingItemPerilOptions();
				getTotalAmounts();
				$("deleteTag").value = "N";
			}
		});
	});
}