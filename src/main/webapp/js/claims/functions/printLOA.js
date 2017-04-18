function printLOA(objArray,moduleId){
	try{
		var reports = [];
		for ( var i = 0; i < objArray.length; i++) {
			var claimId = moduleId == "GICLS070" ? mcMainObj.claimId : objCLMGlobal.claimId;
			var payeeClassCd = moduleId == "GICLS070" ? objArray[i].payeeTypeCd : objArray[i].payeeClassCd;
			var payeeCd = objArray[i].payeeCd;
			var mainPayeeClassCd = moduleId == "GICLS070"? selectedMcEvalObj.payeeClassCd : nvl(objArray[i].tpPayeeClassCd, nvl(objMcTpDtlRow.payeeClassCd, "")); // Kris 03.26.2014: added nvl(objMcTpDtlRow.payeeClassCd, "")
			var mainPayeeNo = nvl((moduleId == "GICLS070"? selectedMcEvalObj.payeeNo : nvl(objArray[i].tpPayeeNo, nvl(objMcTpDtlRow.payeeNo, ""))),""); // Kris 03.26.2014: added nvl(objMcTpDtlRow.payeeNo, "")
			var evalId = nvl(objArray[i].evalId,"");
			var clmLineCd = moduleId == "GICLS070" ? mcMainObj.lineCd : objCLMGlobal.lineCd;
			var clmIssCd = moduleId == "GICLS070" ? mcMainObj.issCd : objCLMGlobal.issCd;
			var loaNo = objArray[i].loaNo;
			var tpSw = moduleId == "GICLS070"? selectedMcEvalObj.tpSw : objArray[i].tpSw;
			var clmLossId = moduleId == "GICLS070" ? "" : objArray[i].clmLossId;
			var itemNo = moduleId == "GICLS070" ? mcMainObj.perilCd : objCurrGICLItemPeril.itemNo;
			var destination = $F("selDestination");
			var reportId = 'GICLR027';
			var reportTitle='Letter of Authority '+objArray[i].loaNo;
			var remarks=''; //return value of Remarks field by MAC 04/08/2013
				if (moduleId==="GICLS070"){
					remarks = $F("generateRemarks");
				}else if  (moduleId==="GICLS030"){
					remarks = $F("txtLoaRemarks");
				}
			var tpClassCd = moduleId == "GICLS070" ? "" : nvl(objMcTpDtlRow.payeeClassCd, ""); //return null in Third Party Payee Class Code if module is GICLS070 by MAC 04/08/2013.
			var tpPayeeCd = moduleId == "GICLS070" ? "" : nvl(objMcTpDtlRow.payeeNo, ""); //return null in Third Party Payee Code if module is GICLS070 by MAC 04/08/2013.
			
			var content = contextPath+"/GICLMcEvaluationPrintController?action=printLOA&claimId="+claimId
			+"&payeeClassCd="+payeeClassCd+"&payeeCd="+payeeCd+"&evalId="+nvl(evalId,"")
			+"&mainPayeeClassCd="+mainPayeeClassCd+"&mainPayeeNo="+mainPayeeNo
			+"&clmIssCd="+clmIssCd+"&clmLineCd="+clmLineCd+"&loaNo="+loaNo
			+"&clmLossId="+clmLossId+"&tpSw="+tpSw+"&itemNo="+itemNo+"&moduleId="+moduleId
			+"&reportId="+reportId+"&reportTitle="+reportTitle
			+"&printerName="+$F("selPrinter")+"&destination="+destination
			//+"&tpClassCd="+nvl(objMcTpDtlRow.payeeClassCd, "")+"&tpPayeeCd="+nvl(objMcTpDtlRow.payeeNo, "") //koks; // commented by: Nica 07.18.2013 - to consider calling the report from GICLS070
			+"&tpClassCd="+tpClassCd+"&tpPayeeCd="+tpPayeeCd
			+"&remarks="+remarks; //return value of Remarks field by MAC 04/08/2013

			reports.push({reportUrl : content, reportTitle : reportTitle});
			
			if("printer" == destination){
				new Ajax.Request(content, {
					method: "POST",
					evalScripts: true,
					asynchronous: false,
					onComplete: function(response){
						if (checkErrorOnResponse(response)){
							showMessageBox("Printing Completed.", "I");
						}
					}
				});	
			}else if("file" == destination){
				new Ajax.Request(content, {
					method: "POST",
					evalScripts: true,
					asynchronous: true,
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							copyFileToLocal(response);
						}
					}
				});
			}else if("local" == destination){
				new Ajax.Request(content, {
					method: "POST",
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							var message = printToLocalPrinter(response.responseText);
							if(message != "SUCCESS"){
								showMessageBox(message, imgMessage.ERROR);
							}
						}
					}
				});
			}
			
			if ((i+1) == objArray.length){
				if("screen" == destination){
					showMultiPdfReport(reports); 
				}
			}
		}
	}catch(e){
		showErrorMessage("printLOA",e);
	}
}