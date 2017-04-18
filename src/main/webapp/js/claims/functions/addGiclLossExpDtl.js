function addGiclLossExpDtl(){
	var newObj = setGiclLossExpDtlObject();
	
	if($("btnAddLossExpDtl").value == "Update"){
		updateGiclLossExpDtl(newObj);			
	}else{
		checkIfToAddLossExpDtl(newObj);
	}
	($$("div#lossExpDtlDiv [changed=changed]")).invoke("removeAttribute", "changed");
}