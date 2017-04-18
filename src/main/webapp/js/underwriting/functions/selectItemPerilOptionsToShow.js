function selectItemPerilOptionsToShow(){
	var itemNo = $F("itemNo");

	for (var i=0; i<objGIPIWItemPeril.length; i++){
		if ((objGIPIWItemPeril[i].itemNo == itemNo) 
				&& (objGIPIWItemPeril[i].recordStatus != -1)){
			showAllPerilsOptions();
		} else {
			showBasicPerilsOnly();
		}
	}
	showBasicPerilsOnly();
}