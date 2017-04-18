function enableEndtPackPolicyItemForm(enable){
	$("itemNo").readOnly 	= enable ? false : true;
	$("itemTitle").readOnly = enable ? false : true;
	$("itemDesc").readOnly 	= enable ? false : true;
	$("itemDesc2").readOnly = enable ? false : true;
	$("rate").readOnly		= enable ? false : true;
	enable ? enableButton("btnAddItem") : disableButton("btnAddItem");
	
	if(enable){
		$("currency").enable();
		$("editDesc").show();
		$("editDesc2").show();
	}else{
		$("currency").disable();
		$("editDesc").hide();
		$("editDesc2").hide();
	}
}