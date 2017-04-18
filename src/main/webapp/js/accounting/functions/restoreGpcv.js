// referenced by GIACS149 - Overriding Commission Voucher
function restoreGpcv(stat){
	try{
		var strParams = prepareJsonAsParameter(objGIACS149.checkedVouchers);
		
		new Ajax.Request(contextPath+"/GIACGenearalDisbReportController",{
			method: "POST",
			parameters: {
				action:			"gpcvRestore",
				gpcvSelect:		strParams, //prepareJsonAsParameter(objGIACS149.gpcvSelect),
				stat:			stat,
				/*ocvNo:			objGIACS149.selectedRow.ocvNo,
				ocvPrefSuf:		objGIACS149.selectedRow.ocvPrefSuf,*/
				fromDate:		objGIACS149.fromDate,
				toDate:			objGIACS149.toDate,
				workflowColValue: null,
				docName:		objGIACS149.docName,
				voucherNo:		objGIACS149.voucherNo,
				voucherPrefSuf:	objGIACS149.voucherPrefSuf,
				ocvBranch:		objGIACS149.ocvBranch
			},
			evalScripts: true,
			asynchronous: true,
			onComplete: function(response){
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){					
					/*commVoucherTG.url = objGIACS149.url;*/
					//commVoucherTG._refreshList();
					
					if (printOk){
						if ($F("txtVoucherDate") == ""){
							new Ajax.Request(contextPath+"/GIACGenearalDisbReportController", {
								method: "POST",
								parameters: {
									action:			"updateUnprintedVoucher",
									/*gfunFundCd:		objGIACS149.selectedRow == null ? null : objGIACS149.selectedRow.gfunFundCd,
									gibrBranchCd:	objGIACS149.selectedRow == null ? null : objGIACS149.selectedRow.gibrBranchCd,
									gaccTranId:		objGIACS149.selectedRow == null ? null : objGIACS149.selectedRow.gaccTranId,
									transactionType:objGIACS149.selectedRow == null ? null : objGIACS149.selectedRow.transactionType,
									issCd:			objGIACS149.selectedRow == null ? null : objGIACS149.selectedRow.issCd,
									premSeqNo:		objGIACS149.selectedRow == null ? null : objGIACS149.selectedRow.premSeqNo,
									instNo:			objGIACS149.selectedRow == null ? null : objGIACS149.selectedRow.instNo,
									intmNo:			objGIACS149.selectedRow == null ? null : objGIACS149.selectedRow.intmNo,
									chldIntmNo:		objGIACS149.selectedRow == null ? null : objGIACS149.selectedRow.chldIntmNo,
									cvNo:			objGIACS149.selectedRow == null ? null : objGIACS149.selectedRow.ocvNo,*/
									checkedVouchers: strParams,
									voucherNo:		objGIACS149.voucherNo,
									voucherPrefSuf:	objGIACS149.voucherPrefSuf
								},
								evalScripts: true,
								asynchronous: true,
								onComplete: function(response){
									checkErrorOnResponse(response);
								}
							});
						}
					}else if(restoreOCV){
						new Ajax.Request(contextPath+"/GIACGenearalDisbReportController", {
							method: "POST",
							parameters: {
								action:			"updateDocSeqGIACS149",
								/*gfunFundCd:		objGIACS149.selectedRow == null ? null : objGIACS149.selectedRow.gfunFundCd,
								gibrBranchCd:	objGIACS149.selectedRow == null ? null : objGIACS149.selectedRow.gibrBranchCd,
								ocvPrefSuf:		objGIACS149.selectedRow == null ? null : objGIACS149.selectedRow.ocvPrefSuf,*/
								checkedVouchers: strParams,
								docName:		objGIACS149.docName,
							},
							evalScripts: true,
							asynchronous: true,
							onComplete: function(response){
								checkErrorOnResponse(response);
							}
						});
					}
				}
			}
		});
	}catch(e){
		showErrorMessage("restoreGpcv", e);	
	}
}