function setDeductibleListing(obj, dedLevel) {
	try {
		$("inputDeductible"+dedLevel).update('<option value="" dText="" dAmt="" dRate="" dType=""></option>');
		for(var i=0; i<obj.length; i++) {
			var exist = false;
			// added by: nica 10.13.2010 to replace null value of deductible attributes
			var minAmt = obj[i].minimumAmount == null ? "" : obj[i].minimumAmount;
			var maxAmt = obj[i].maximumAmount == null ? "" : obj[i].maximumAmount;
			var rangeSw = obj[i].rangeSw == null ? "" : obj[i].rangeSw;
			var rate = obj[i].deductibleRate == null ? "" : obj[i].deductibleRate;
			var itemNo = (1 < dedLevel ? $F("itemNo") : 0);
			var perilCd = (3 == dedLevel ? $F("perilCd") : 0);			
			$$("div#wdeductibleListing"+dedLevel+ " div[name='ded"+dedLevel+"']").each(function(ded){
				//if(ded.getStyle("display") != "none") { commented by: nica 10.13.2010
				// modified by: nica 10.14.2010 to handle sorting of deductibles per deductible Level
				// andrew - 11.18.2010 modified the condition to handle all deductible levels, the commented block of code below can be deleted
				if(obj[i].deductibleCd == ded.getAttribute("dedCd") 
						&& itemNo == ded.getAttribute("item") 
						&& perilCd == ded.getAttribute("perilCd")) {
					exist = true;
				}				
				/*
				if(dedLevel == 1){
					// Policy Deductibles
					if(obj[i].deductibleCd == ded.down("input", 4).value) {
						exist = true;
					}
				}if(dedLevel == 2){
					// Item Deductibles
					if(obj[i].deductibleCd == ded.down("input", 4).value && itemNo == ded.down("input", 0).value) {
						exist = true;
					}
				}if(dedLevel == 3){
					// Peril Deductibles
					if(obj[i].deductibleCd == ded.down("input", 4).value && itemNo == ded.down("input", 0).value && perilCd == ded.down("input", 2).value) {
						exist = true;
					}
				}*/
			});
			if (!exist){
				var opt = '<option value="'+obj[i].deductibleCd +'" rangeSw="'+rangeSw  
							+'" minAmt="'+minAmt+ '" maxAmt="'+maxAmt  
							+'" dText="'+ obj[i].deductibleText + '" dAmt="'+ obj[i].deductibleAmt 
							+ '" dRate="'+rate+'" dType="'+ obj[i].deductibleType 
							+ '">'+ obj[i].deductibleTitle +'</option>';
				$("inputDeductible"+dedLevel).insert({bottom: opt});
			}
		}
		$("inputDeductible"+dedLevel).selectedIndex = 0;
	} catch (e) {
		showErrorMessage("setDeductibleListing" , e);
	}
}