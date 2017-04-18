/**
 * 
 * @param itemNo
 * @return
 */
function deleteRelatedElements(itemNo){
	try{
		$$("div[name='perilRow']").each(function(peril){
			if(peril.getAttribute("itemNo") == itemNo){
				peril.remove();
			}
		});

		resetTableStyle("itemPerilTable","itemPerilMotherDiv","perilRow");
		
		$$("div[name='mortgageeRow']").each(function(mort){
			if(mort.getAttribute("itemNo") == itemNo){
				mort.remove();
			}
		});

		resetTableStyle("mortgageeInformationDiv", "mortgageeListingDiv", "mortgageeRow");
		
		$$("div[name='deductibleRow']").each(function(ded){
			if(ded.getAttribute("itemNo") == itemNo){
				ded.remove();
			}
		});
		resetTableStyle("deductiblesTable", "deductibleListing", "deductibleRow");
	}catch(e){
	}
}