function populateRepairLpsDtlFields(obj){
	try{
		$("itemNo").value = obj == null ? "": obj.itemNo;
		$("tinsmithType").value = obj == null ? "": obj.tinsmithType;
		$("dspLossDesc").value = obj == null ? "": unescapeHTML2(obj.dspLossDesc);
		if(obj!= null){
			if(obj.tinsmithRepairCd == "Y"){
				$("tinsmithRepairCd").checked = true;
			}else{
				$("tinsmithRepairCd").checked = false;
			}
			
			if(obj.paintingsRepairCd == "Y"){
				$("paintingsRepairCd").checked = true;
			}else{
				$("paintingsRepairCd").checked = false;
			}
			$("tinsmithType").disabled = "";
			$("tinsmithRepairCd").disabled = "";
			$("paintingsRepairCd").disabled = "";
		}else{
			$("paintingsRepairCd").checked = false;
			$("tinsmithRepairCd").checked = false;
			$("tinsmithType").disabled = "disabled";
			$("tinsmithRepairCd").disabled = "disabled";
			$("paintingsRepairCd").disabled = "disabled";
		}
		$("tinsmithAmount").value = obj == null ? "": formatCurrency(obj.tinsmithAmount);
		$("paintingsAmount").value = obj == null ? "": formatCurrency(obj.paintingsAmount);
		$("totalAmount").value = obj == null ? "": formatCurrency(obj.totalAmount);
		$("lossExpCd").value = obj == null ? "": obj.lossExpCd;
		
		if(variablesObj.giclRepairHdrAllowUpdate == "Y"){
			if(obj == null){
				$("btnAddRepairDet").value = "Add";
				disableButton("btnDeleteRepairDet");
			}else{
				$("btnAddRepairDet").value = "Update";
				enableButton("btnDeleteRepairDet");
			}
		}else{
			disableSearch("dspCompanyTypeIcon");
			disableSearch("dspCompanyIcon");
			$("tinsmithType").disable();
			$("paintingsRepairCd").disable();
			$("tinsmithRepairCd").disable();
		}
	}catch(e){
		showErrorMessage("populateRepairLpsDtlFields",e);
	}
}