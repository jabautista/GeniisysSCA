//belle 02.09.2012
function populateBeneficiary(obj){
	try{
		$("beneficiaryName").value 	= obj == null ? null :unescapeHTML2(obj[beneficiaryGrid.getColumnIndex('beneficiaryName')]);
		$("benAddress").value 	    = obj == null ? null :unescapeHTML2(obj[beneficiaryGrid.getColumnIndex('beneficiaryAddr')]);
		$("dspBenPosition").value 	= obj == null ? null :unescapeHTML2(obj[beneficiaryGrid.getColumnIndex('dspBenPosition')]);
		$("relation").value 	    = obj == null ? null :unescapeHTML2(obj[beneficiaryGrid.getColumnIndex('relation')]);
		$("dspCivilStatus").value 	= obj == null ? null :obj[beneficiaryGrid.getColumnIndex('dspCivilStatus')];
		$("dateOfBirth").value   	= obj == null ? null : obj[beneficiaryGrid.getColumnIndex('dateOfBirth')] == null ? "" : dateFormat(obj[beneficiaryGrid.getColumnIndex('dateOfBirth')], "mm-dd-yyyy") ;
		$("age").value 				= obj == null ? null :obj[beneficiaryGrid.getColumnIndex('age')];
		$("dspSex").value 			= obj == null ? null :obj[beneficiaryGrid.getColumnIndex('dspSex')];
		
		if(obj != null){
			enableButton("btnDeleteBeneficiary");
			disableButton("btnAddBeneficiary");
			$("itemBenNo") ? $("itemBenNo").hide() :null;
		}else{
			enableButton("btnAddBeneficiary");
			disableButton("btnDeleteBeneficiary");
			$("itemBenNo") ? $("itemBenNo").show() :null;
		} 
	}catch(e){
		showErrorMessage("populateBeneficiary",e);
	}	
}