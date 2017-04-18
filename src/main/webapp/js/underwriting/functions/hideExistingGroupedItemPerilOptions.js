function hideExistingGroupedItemPerilOptions(){
	var itemNo = $F("itemNo");
	var cGroupedItemNo = $F("groupedItemNo");
	var covPeril = "";
	
	$$("div[name='cov']").each(function(row){
		if (row.getAttribute("item") ==  itemNo && row.getAttribute("groupedItemNo") == cGroupedItemNo){
			covPeril = row.getAttribute("perilCd");
		}
		
		$("cPerilCd").childElements().each(function(o){
			if(o.value == covPeril){
				hideOption(o);
			}
		});
	});
}