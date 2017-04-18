/*	Created by	: mark jm 07.28.2011
 * 	Moved from	: peril information page
 */
function getHighestBasicTsiAmt2(itemNo){
	try{
		/*
		var highestBasicTsiAmt = 0;
		$$("div[name='row2']").each(function(row){
			if (row.getAttribute("item") == itemNo){
				perilExistsForCurrentItem = true;
				if (row.down("input", 8).value == "B"){
					if (parseFloat(row.down("input", 5).value.replace(/,/g, "")) > parseFloat(highestBasicTsiAmt)){
						highestBasicTsiAmt = parseFloat(row.down("input", 5).value.replace(/,/g, ""));
					}
				}
			}
		});
		return highestBasicTsiAmt;
		*/
		var highestBasicTsiAmt = 0;
		
		var objArrFiltered = objGIPIWItemPeril.filter(function(obj){	return obj.itemNo == itemNo && obj.perilType == "B";	});
		
		if(objArrFiltered.length > 0){
			perilExistsForCurrentItem = true;
			highestBasicTsiAmt = parseFloat(objArrFiltered.max(function(obj) {
				return parseFloat(obj.tsiAmt);	 // edited by d.alcantara, replaced parseInt with parseFloat
			}));
		}		
		
		return highestBasicTsiAmt;
	}catch(e){
		showErrorMessage("getHighestBasicTsiAmt2", e);
	}	
}