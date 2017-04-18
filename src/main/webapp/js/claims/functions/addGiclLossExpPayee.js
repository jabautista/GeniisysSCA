function addGiclLossExpPayee(){
	try{
		new Ajax.Request(contextPath + "/GICLLossExpPayeesController",{
			parameters : {
				action : "getPayeeClmClmntNo",
				claimId: objCLMGlobal.claimId,
				payeeCd: escapeHTML2($("payee").getAttribute("payeeNo")),
				payeeClassCd : escapeHTML2($("payeeClass").getAttribute("payeeClassCd"))
			},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					$("hidClmClmntNo").value = response.responseText;
					var newObj = setPayeeDetailObject();
					giclLossExpPayeesTableGrid.addBottomRow(newObj);
					payeeInsertSw = "Y";
					updateTGPager(giclLossExpPayeesTableGrid);
					clearAllRelatedPayeeRecords();
					($$("div#payeeDetailsSectionDiv [changed=changed]")).invoke("removeAttribute", "changed");
				}else{
					showMessageBox(response.responseText, "E");
				}
			}
		});
	}catch(e){
		showErrorMessage("addGiclLossExpPayee", e);
	}
}