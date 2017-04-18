/**
 * Note: fromMcEval Parameter is changed to moduleId. June 1, 2012
 * */
function printCSL(objArray,moduleId){
	try{
		var reports = [];
		for ( var i = 0; i < objArray.length; i++) {
			
			var claimId = moduleId == "GICLS070" ? mcMainObj.claimId : objCLMGlobal.claimId;
			var payeeClassCd = moduleId == "GICLS070" ? objArray[i].payeeTypeCd : objArray[i].payeeClassCd;
			var payeeCd = objArray[i].payeeCd;
			var evalId = nvl(objArray[i].evalId,"");
			var clmLossId = moduleId == "GICLS070" ? "" : objArray[i].clmLossId;
			var perilCd = moduleId == "GICLS070" ? mcMainObj.perilCd : objCurrGICLItemPeril.perilCd;
			var itemNo = moduleId == "GICLS070" ? mcMainObj.itemNo : objCurrGICLItemPeril.itemNo;
			var classDesc = moduleId == "GICLS070" ? objArray[i].dspClassDesc : objArray[i].classDesc;
			var clmLineCd = moduleId == "GICLS070" ? mcMainObj.lineCd : objCLMGlobal.lineCd;
			var clmIssCd = moduleId == "GICLS070" ? mcMainObj.issCd : objCLMGlobal.issCd;
			var cslNo = objArray[i].cslNo; // andrew
			var destination = $F("selDestination");
			var reportId = 'GICLR030';
			var reportTitle='Cash Settlement Letter '+objArray[i].cslNo;
			var remarks=''; //added by steven 8.2.2012
				if (moduleId==="GICLS070"){
					remarks=$F("generateRemarks");
				}else if  (moduleId==="GICLS030"){
					remarks=$F("txtCslRemarks");
				}
			var tpClassCd = moduleId == "GICLS070" ? "" : nvl(objMcTpDtlRow.payeeClassCd, ""); //return null in Third Party Payee Class Code if module is GICLS070 by MAC 04/08/2013.
			var tpPayeeCd = moduleId == "GICLS070" ? "" : nvl(objMcTpDtlRow.payeeNo, ""); //return null in Third Party Payee Code if module is GICLS070 by MAC 04/08/2013.
			
			var content = contextPath+"/GICLMcEvaluationPrintController?action=printCSL&claimId="+claimId
			+"&payeeClassCd="+payeeClassCd+"&payeeCd="+payeeCd+"&evalId="+nvl(evalId,"")
			+"&clmIssCd="+clmIssCd+"&clmLineCd="+clmLineCd+"&classDesc="+classDesc
			+"&clmLossId="+clmLossId+"&perilCd="+perilCd+"&itemNo="+itemNo+"&moduleId="+moduleId
			+"&remarks="+encodeURIComponent(remarks)+"&reportId="+reportId+"&reportTitle="+reportTitle
			+"&printerName="+$F("selPrinter")+"&destination="+destination
			+"&cslNo="+cslNo // andrew
			//+"&tpClassCd="+nvl(objMcTpDtlRow.payeeClassCd, "")+"&tpPayeeCd="+nvl(objMcTpDtlRow.payeeNo, ""); //koks;
			+"&tpClassCd="+tpClassCd+"&tpPayeeCd="+tpPayeeCd;

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
		showErrorMessage("printCSL",e);
	}
}