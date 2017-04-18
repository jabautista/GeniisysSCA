function printRenewalNotice(policyId, giexs006ReportName){//PJD 09/30/2013 to pass the reason as parameters for non renewal report
	try{
		var reason1 = "";  
		var reason2 = "";
		var reason3 = "";
		var reason4 = "";
		//added by jeffdojello 10.17.2013 to pass the value of Contact No. and Sales Assistant to Renewal Notice
		var telNo1 = "";
		var telNo2 = "";
		var telNo3 = "";
		var telNo4 = "";
		var salesAsst1 = "";
		var salesAsst2 = "";
		var salesAsst3 = "";
		
		if(objGiexs006.giexs006Report == "RENEWAL NOTICE"){ //added by jeffdojello 10.17.2013
			telNo1  = $F("telNo1");
			telNo2  = $F("telNo2");
			telNo3  = $F("telNo3");
			telNo4  = $F("telNo4");
			salesAsst1  = $F("salesAsst1");
			salesAsst2  = $F("salesAsst2");
			salesAsst3  = $F("salesAsst3");
		}			
		if(objGiexs006.giexs006Report == "NON-RENEWAL NOTICE"){
			if(objGiexs006.lineCd == "FI"){
				if($("chkReason1").checked){
					reason1 = "Unfavorable Loss Experience";
				}else{
					reason1 = "";
				}
				if($("chkReason2").checked){ 
					reason2 = "Risk insured is categorized as a \"Prohibited Risk\"";
					reason2 = escapeHTML2(reason2); //added by pjd 10.22.13 to handle double quote when passing parameter
				}else{
					reason2 = "";
				}
				if($("chkReason3").checked){
					reason3 = "Risk is situated in an area /acceptance is already saturated";
				}else{
					reason3 = "";
				}
				if($("chkReason4").checked){
					reason4 = $F("txtOther");
				}else{
					reason4 = "";
				}
			}else{
				if($("chkReason1").checked){
					reason1 = "Unfavorable Loss Experience";
				}else{
					reason1 = "";
				}
				if($("chkReason2").checked){
					reason2 = "Vehicle is over 10 years old";	
				}else{
					reason2 = "";
				}
				if($("chkReason3").checked){
					reason3 = "Vehicle is considered prohibited";
				}else{
					reason3 = "";
				}
				if($("chkReason4").checked){
					reason4 = $F("txtOther");
				}else{
					reason4 = "";
				}
			} 
		} //PJD 09/30/2013 to pass the reason as parameters for non renewal report		
		//modified by jeffdojello 10.17.2013 - added Renewal Notice Parameters
		var content = contextPath+"/GIEXExpiryPrintController?action=printGiexs006Report&policyId="+policyId+"&printerName="+$F("selPrinter")+"&reportName="+giexs006ReportName+"&reason1="+reason1+"&reason2="+reason2+"&reason3="+reason3+"&reason4="+reason4+"&telNo1="+telNo1+"&telNo2="+telNo2+"&telNo3="+telNo3+"&telNo4="+telNo4+"&salesAsst1="+salesAsst1+"&salesAsst2="+salesAsst2+"&salesAsst3="+salesAsst3;
			if($F("selDestination") == "SCREEN"){
				//reports.push({reportUrl : content, reportTitle : "GIEXS006"});
				showPdfReport(content, "GIEXS006");
			}else if($F("selDestination") == "PRINTER"){
				new Ajax.Request(content, {
					method: "GET",
					parameters : {noOfCopies : $F("txtNoOfCopies"),
							 	 printerName : $F("selPrinter")
							 	 },
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						if (checkErrorOnResponse(response)){
							showMessageBox("Printing complete.",imgMessage.SUCCESS);	//added by Gzelle 05202015 SR3705 
						}
					}
				});
			}else if($F("selDestination") == "FILE"){
				new Ajax.Request(content, {
					method: "POST",
					parameters : {destination : "FILE"},
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
			}else if("LOCAL" == $F("selDestination")){
				new Ajax.Request(content, {
					method: "POST",
					parameters : {destination : "LOCAL"},
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
			objGiexs006.reqRenewalNo = "N";	//Gzelle 05202015 SR3698, 3703
	}catch(e){
		showErrorMessage("printRenewalNotice", e);
	}	
}