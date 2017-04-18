function processMortgagedItem(){
 	var tag = "N";
 	
 	if(nvl(objCLMGlobal.totalTag, "N") == "Y" && isGiclMortgExist == "Y"){
 		tag = "Y";
 		isGiclMortgExist = "Y";
 		$("payeeClass").value = $("hidMortgClassDesc").value;
		$("payeeClass").setAttribute("payeeClassCd", $("hidMortgClassCd").value);
 	}
		
 	if(tag == "N"){
 		if(isGiclMortgExist == "Y"){
 			isGiclMortgExist = "Y";
 			showConfirmBox("Confirmation", "The item is mortgaged. Do you want to create payment record for mortgagee?", "Ok", "No", 
					function(){
 						$("payeeClass").value = $("hidMortgClassDesc").value;
 						$("payeeClass").setAttribute("payeeClassCd", $("hidMortgClassCd").value);
 						validateMortgageeClassCd($("payeeClass").getAttribute("payeeClassCd")); //kenneth
 					}, function(){
 						showLossExpPayeeClassLov();
 					});
 		}else{
 			showLossExpPayeeClassLov();
 		}
 	}else{
 		isGiclMortgExist = "Y";
		validateMortgageeClassCd($("payeeClass").getAttribute("payeeClassCd"));
 	}
}