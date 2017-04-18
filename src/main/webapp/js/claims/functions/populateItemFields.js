function populateItemFields(obj){
	try{
		$("textItemNo").value = obj == null? null : nvl(obj.itemNo,""); 
		$("textItemDesc").value = obj == null? null : unescapeHTML2(obj.dspItemDesc); 
		$("txtPlateNo").value = obj == null? null : nvl(unescapeHTML2(obj.plateNo),"");  
		$("txtPerilCd").value = obj == null? null : nvl(obj.perilCd,""); 
		$("txtPerilName").value = obj == null? null : unescapeHTML2(obj.dspPerilDesc); 
		
		// bonok :: 11.08.2013
		if(objCLMGlobal.callingForm == "GICLS260"){
			$("txtGICLS260PlateNo").value = obj == null? null : nvl(obj.plateNo,"");
		}
	}catch(e){
		showErrorMessage("populateItemFields",e);
	}
}