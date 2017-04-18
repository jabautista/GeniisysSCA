/*	Created by	: mark jm 07.28.2011
 * 	Moved from	: peril information page
 */
function getHighestAlliedTsiAmt2(itemNo){
	try{
		/*
		var highestAlliedTsiAmt = 0;
		$$("div[name='row2']").each(function(row){
			if (row.getAttribute("item") == itemNo){
				perilExistsForCurrentItem = true;
				if (row.down("input", 8).value == "A"){
					if (parseFloat(row.down("input", 5).value.replace(/,/g, "")) > parseFloat(highestAlliedTsiAmt)){
						highestAlliedTsiAmt = parseFloat(row.down("input", 5).value.replace(/,/g, ""));
					}
				}
			}
		});
		return highestAlliedTsiAmt;
		*/
		var highestAlliedTsiAmt = 0;
		
		var objArrFiltered = objGIPIWItemPeril.filter(function(obj){	return obj.itemNo == itemNo && obj.perilType == "A";	});
		
		if(objArrFiltered.length > 0){			
			perilExistsForCurrentItem = true;
			highestAlliedTsiAmt = parseFloat(objArrFiltered.max(function(obj) {
				return parseFloat(obj.tsiAmt);  // edited by d.alcantara, replaced parseInt with parseFloat
			}));
		}		
		
		return highestAlliedTsiAmt;
	}catch(e){
		showErrorMessage("getHighestAlliedTsiAmt2", e);
	}	
}