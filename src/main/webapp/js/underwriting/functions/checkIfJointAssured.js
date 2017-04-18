function checkIfJointAssured(){
	try{
		if($("selectedAssuredType").innerHTML == 'Joint'){
			if($F("assuredNameMaint") != nvl(lastAssdName,' @@ ')){
				showConfirmBox("Confirm", "Entry on Assured will override previous Name entry. Do you want to continue anyway?", 
				"OK", "Cancel", 
				function(){
					if($("firstName").value != "" && $("lastName").value != ""){ //Added by Jerome Bautista 07.29.2015 SR 19507
					generateAssuredName();
					}
					lastAssdName = ltrim(rtrim($F("assuredNameMaint")));
					
					checkAssuredExistGiiss006b();
				},  function(){
					$("assuredNameMaint").value = lastAssdName;
				});
			}
		}else{
			checkAssuredExistGiiss006b();
		}
	}catch(e){
		showErrorMessage("checkIfJointAssured",e);
	}
}