/**Validate selected Gl Account Code
 * Created by   : Gzelle
 * Date Created : 11-06-2015
 * Remarks      : KB#132 - Accounting - AP/AR Enhancement
 * */
function validateGlAcctId(glAcctId, slTypeCd){

	function setDisabledFieldsForGlAcctRefNo(){
		 $("txtLedgerCd").clear();
		 $("txtSubLedgerCd").clear();
		 $("txtTranCd").clear();
		 $("txtSlCd").clear();
		 $("txtSeqNo").clear();
		 $("inputSlName").clear();
		 disableInputField("txtTranCd");
		 disableInputField("txtSeqNo");
		 disableSearch("imgSearchTranCd");
		 disableSearch("imgSearchSeqNo");
		 disableSearch("searchSlCd");
		 $("selTranDiv").removeClassName("required");
		 $("txtTranCd").removeClassName("required");
		 $("selSeqNoDiv").removeClassName("required");
		 $("txtSeqNo").removeClassName("required");
		 $("selTranDiv").style.backgroundColor = "#FFFFFF";
		 $("selSeqNoDiv").style.backgroundColor = "#FFFFFF";
		 $("inputSlName").removeClassName("required");
	   	 $("selectSlDiv").removeClassName("required");
	 	 $("inputSlName").style.backgroundColor = "#FFFFFF";
		 $("rdoSetUp").checked = true;
		 $("rdoSetUp").disable();
		 $("rdoKnockOff").disable();	
		 $("hidDspIsExisting").value = "N";
		 if(slTypeCd != null || slTypeCd != "" && $("hidDspIsExisting").value == "N") {
			 $("inputSlName").addClassName("required");
			 $("selectSlDiv").addClassName("required");
			 $("inputSlName").style.backgroundColor = "#FFFACD";
			 enableSearch("searchSlCd");
		 }
		 $("inputDebitAmt").clear();
		 $("inputCreditAmt").clear();
	}
	
	function checkUserFunc() {
		if(!validateUserFunc2("AA", "GIACS030")) {
			showConfirmBox("AP/AR ACCOUNTS", "User may enter AP/AR Accounts. Would you like to override?", "Yes", "No",
					function(){//do this for YES
				showGenericOverride( // this is the original function
						"GIACS030",
						"AA",
						function(ovr, userId, result){
							if(result == "FALSE"){
								showMessageBox("User " + userId + " is not allowed for override.", imgMessage.ERROR);
								$("txtOverrideUserName").clear();
								$("txtOverridePassword").clear();
								$("txtOverrideUserName").focus();
								setDisabledFieldsForGlAcctRefNo();
								$("hidDspIsExisting").value = "Y";
								return false;
							} else {
								if(result == "TRUE"){
									$("rdoSetUp").checked = true;
									disableSearch("imgSearchSeqNo");
									disableInputField("txtSeqNo");
									$("txtSeqNo").removeClassName("required");
									$("selSeqNoDiv").removeClassName("required");
									$("selSeqNoDiv").style.backgroundColor = "#FFFFFF";
									$("rdoSetUp").enable();
									$("rdoKnockOff").enable();
									$("selTranDiv").addClassName("required");
									$("txtTranCd").addClassName("required");
									$("txtLedgerCd").value = valResult[0].ledgerCd;
									$("txtSubLedgerCd").value = valResult[0].subLedgerCd;
									$("selTranDiv").style.backgroundColor = "#FFFACD";
									enableSearch("imgSearchTranCd");
									if ($("rdoKnockOff").checked) {
										$("selSeqNoDiv").addClassName("required");
										$("txtSeqNo").addClassName("required");
										$("selSeqNoDiv").style.backgroundColor = "#FFFACD";
									}
									$("inputDebitAmt").clear();
									$("inputCreditAmt").clear();
									$("inputSlName").clear();
									if ($("hiddenSlTypeCd").getAttribute("isSlExisting") == "N") {
										$("txtSlCd").value = "0";
									}else {
										$("txtSlCd").value = "";
									}
									ovr.close();
									delete ovr;	
								}	
							}
						},
						function(){
							$("inputGlAcctCtgy").clear();
							$$("input[name='glAccountCode']").each(function(gl) {
								gl.clear();
							});
							$("inputGlAcctName").clear();
							setDisabledFieldsForGlAcctRefNo();
							$("inputSlName").removeClassName("required");
							$("selectSlDiv").removeClassName("required");
							$("inputSlName").style.backgroundColor = "#FFFFFF";
							disableSearch("searchSlCd");
						}
				);	
			}, function(){	//do this for NO
				$("inputGlAcctCtgy").clear();
				$$("input[name='glAccountCode']").each(function(gl) {
					gl.clear();
				});
				$("inputGlAcctName").clear();
				setDisabledFieldsForGlAcctRefNo();
				$("inputSlName").removeClassName("required");
				$("selectSlDiv").removeClassName("required");
				$("inputSlName").style.backgroundColor = "#FFFFFF";
				disableSearch("searchSlCd");
			}, "");
		} else {
			$("rdoSetUp").checked = true;
			disableSearch("imgSearchSeqNo");
			disableInputField("txtSeqNo");
			$("txtSeqNo").removeClassName("required");
			$("selSeqNoDiv").removeClassName("required");
			$("selSeqNoDiv").style.backgroundColor = "#FFFFFF";
			$("rdoSetUp").enable();
			$("rdoKnockOff").enable();
			$("selTranDiv").addClassName("required");
			$("txtTranCd").addClassName("required");
			$("txtLedgerCd").value = valResult[0].ledgerCd;
			$("txtSubLedgerCd").value = valResult[0].subLedgerCd;
			$("selTranDiv").style.backgroundColor = "#FFFACD";
			$("inputSlName").addClassName("required");
			$("selectSlDiv").addClassName("required");
			$("inputSlName").style.backgroundColor = "#FFFACD";
			enableSearch("searchSlCd");
			enableSearch("imgSearchTranCd");
			if ($("rdoKnockOff").checked) {
				$("selSeqNoDiv").addClassName("required");
				$("txtSeqNo").addClassName("required");
				$("selSeqNoDiv").style.backgroundColor = "#FFFACD";
			}
			$("inputDebitAmt").clear();
			$("inputCreditAmt").clear();
			$("inputSlName").clear();
			if ($("hiddenSlTypeCd").getAttribute("isSlExisting") == "N") {
				$("txtSlCd").value = "0";
			} else {
				$("txtSlCd").clear();
			}
		}
	}
	
	new Ajax.Request(contextPath+ "/GIACGlAcctRefNoController", {
		method : "POST",
		parameters : {
			action : "valGlAcctIdGiacs030",
		  glAcctId : glAcctId
		},
		asynchronous : false,
		onComplete: function(response){
			if(checkErrorOnResponse(response)){
				 valResult = JSON.parse(response.responseText);
				 $("hidDspIsExisting").value = valResult[0].dspIsExisting;
				 $("hidDrCrTag").value = valResult[0].drCrTag;
				 $("hiddenSlTypeCd").setAttribute("isSlExisting", valResult[0].dspSlExisting); //returns Y if sl_type_cd has sl cd records
				 if (valResult[0].dspIsExisting == "N") {	//glAccount is not existing in giac_gl_sub_account_types
					 setDisabledFieldsForGlAcctRefNo();
				} else if (valResult[0].dspIsExisting == "Y") {		//glAccount is existing in giac_gl_sub_account_types
					//check user function here first before calling the if/else block
					checkUserFunc();
				}
			}
		}
	});
}