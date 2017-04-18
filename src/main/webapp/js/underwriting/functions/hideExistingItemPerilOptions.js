function hideExistingItemPerilOptions(){
	var itemNo = $F("itemNo");
	
	for (var i=0; i<objGIPIWItemPeril.length; i++){
		if ((objGIPIWItemPeril[i].itemNo == itemNo)
				&& (objGIPIWItemPeril[i].recordStatus != -1)){
			$("perilCd").childElements().each(function (o) {
				if (o.value == objGIPIWItemPeril[i].perilCd){
					hideOption(o);
				}
			});
		}
	}
}