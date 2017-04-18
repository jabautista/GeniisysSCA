function printCurrentReport(reportId, destination, printerName, noOfCopies, isDraft, lineCd, sublineCd, isMulti){
	try {
		var content = contextPath+"/PrintPolicyController?action=printPolicyReport&extractId="+$F("extractId")
			+"&noOfCopies="+noOfCopies+"&printerName="+printerName			
			+"&reportId="+reportId+"&isDraft="+isDraft+"&lineCd="+lineCd+"&printPremium="+nvl($F("printPremiumHid"), "Y") + "&destination="+((destination.toUpperCase()=="LOCAL PRINTER") ? "LOCAL" : destination);//Added by pjsantos 01/20/2017 destination for  GENQA 5904
		if("GIPIR915" != reportId && "GIPIR914" != reportId){
			content = content+"&policyId="+$F("policyId");
		}
		
		if ("BONDS" == reportId || "SURETYSHIP" == reportId){	 
			content = content + "&sublineCd=" + ($("sublineCd") == null ? objUWParList.sublineCd : $F("sublineCd"))
			    + "&parId=" + ($("parId") == null ? objUWParList.parId : $F("parId"))
				+ "&bondParType="+nvl($F("bondParType"), "P");
			if($("hidRegDeedNo") != null) {
				content = content + "&regDeedNo="+$F("hidRegDeedNo")
						+ "&regDeed="+$F("hidRegDeed")
						+ "&dateIssued="+$F("hidDateIssued")
						+ "&bondTitle="+$F("hidBondTitle")
						+ "&reason="+$F("hidReason")
						+ "&savingsAcctNo="+$F("hidSavingsAcctNo")
						+ "&caseNo="+$F("hidCaseNo")
						+ "&versusA="+$F("hidVersusA")
						+ "&versusB="+$F("hidVersusB")
						+ "&versusC="+$F("hidVersusC")
						+ "&sheriffLoc="+$F("hidSheriffLoc")
						+ "&judge="+$F("hidJudge")
						+ "&partA="+$F("hidPartA")
						+ "&partB="+$F("hidPartB")
						+ "&partC="+$F("hidPartC")
						+ "&partD="+$F("hidPartD")
						+ "&partE="+$F("hidPartE")
						+ "&partF="+$F("hidPartF")
						+ "&branch="+$F("hidBranch")
						+ "&branchLoc="+$F("hidBranchLoc")
						+ "&appDate="+$F("hidAppDate")
						+ "&guardian="+$F("hidGuardian")
						+ "&complainant="+$F("hidComplainant")
						+ "&versus="+$F("hidVersus")
						+ "&section="+$F("hidSection")
						+ "&signA="+$F("hidSignAJCL5")
						+ "&signB="+$F("hidSignBJCL5")
						+ "&signatory="+$F("hidSignatory")
						+ "&rule="+$F("hidRule");
			}
		}  
		
		if ("ACK" == reportId){ // andrew - to handle the special case in rsic
			content = content + "&aojSw=" + ($("rowAOJ") != null && $("rowAOJ").getAttribute("name") == "forPrint" ? "Y" : "N");
		}
		
		if ("INDEM" == reportId) {
			content = content + "&period="+ $F("hidPeriod") +
			"&signA="+ escapeHTML2($F("hidSignA")) +
			"&signB="+ escapeHTML2($F("hidSignB")) +
			"&ackLoc="+ ($F("hidAckLoc") == "" ? "" : changeSingleAndDoubleQuotes2($F("hidAckLoc"))) +
			"&ackDate="+ $F("hidAckDate") +
			"&docNo="+ $F("hidDocNo") +
			"&pageNo="+ $F("hidPageNo") +
			"&bookNo="+ $F("hidBookNo") +
			"&series="+ $F("hidSeries");
		}
		
		if("GIPIR915" == reportId || "GIPIR914" == reportId) {
			if(objPrintAddtl == null || objPrintAddtl.printRows.length < 1) {
				showMessageBox("Please select the COC that you want to print.");
				return false;
			} else {
				content = content+ "&itemNo="+objPrintAddtl.rowToPrint.itemNo;
				content = content+ "&policyId="+objPrintAddtl.rowToPrint.policyId;
				//var cocContent = content;;
				//cocContent += "&itemNo="+objPrintAddtl.rowToPrint.itemNo;
				//objPrintAddtl.rowToPrint;
				//proceedToPrint(cocContent);
			}
			objPrintAddtl.rowToPrint = null;
		}
		
		//if(isDraft != undefined) content+="&isDraft="+isDraft;
		if ("SCREEN" == destination) {//if SCREEN						
			//window.open(content, '', 'location=0, toolbar=0, menubar=0, fullscreen=1');
			//showPdfReport(content, ""); // andrew - 12.12.2011
			
			//marco - added isMulti parameter to function - 06.25.2013
			if(nvl(isMulti, 'N') == 'Y'){
				reports.push({reportUrl : content, reportTitle : ""});
			}else{
				showPdfReport(content, "");
			}
			
			hideNotice("");
			if (!(Object.isUndefined($("reportGeneratorMainDiv")))){
				hideOverlay();
			}
		}else if("file" == destination){
			new Ajax.Request(content, {
				parameters : {destination : "FILE"},
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
				parameters : {destination : "LOCAL"},
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
		} else if ("LOCAL PRINTER" == destination) { //marco - 06.21.2013
			new Ajax.Request(content, {
				method: "POST",
				parameters : {destination : "LOCAL"},
				evalScripts: true,
				asynchronous: false,
				onCreate: function(){
					showNotice("Preparing to print...");
				},
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response)){
						var message = printToLocalPrinter(response.responseText);
						if(message != "SUCCESS"){
							showMessageBox(message, imgMessage.ERROR);
						}
					}
				}
			});
		} else { //PRINTER
			new Ajax.Request(content, {
				method: "POST",
				evalScripts: true,
				asynchronous: false,
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						hideNotice();
					}
				}
			});
			if (!(Object.isUndefined($("reportGeneratorMainDiv")))){
				hideOverlay();
			}
		}
	} catch(e){
		showErrorMessage("printCurrentReport", e);
	}
}
