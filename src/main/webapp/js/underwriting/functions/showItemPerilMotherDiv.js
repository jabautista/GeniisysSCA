function showItemPerilMotherDiv(itemNo) {
	/*	Modified by		: mark jm 09.15.2010
	 * 	Modification	: Check first if item has existing peril
	 * 					: before showing peril details
	 * 					: Transfer the process of showing peril main div from itemInfo page to this page
	 */
	
	if(checkIfItemHashExistingPeril2(itemNo)){		
		if ($("itemPerilMotherDiv"+itemNo) != null) {
			$("itemPerilMotherDiv"+itemNo).show();
			$$("div#itemPerilMotherDiv"+itemNo+" div[name='row2']").each(
				function(row){
					row.show();
			});
			
			$("itemPerilMainDiv").show();	   							
			$("itemPerilMotherDiv"+itemNo).show();
		}
	}
}