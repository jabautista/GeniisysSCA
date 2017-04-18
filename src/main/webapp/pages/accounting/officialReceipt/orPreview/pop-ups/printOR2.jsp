<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="hiddenDiv">
	<input type="hidden" id="printerNames" value="${printerNames}">
	<input type="hidden" id="reportType" value="${reportType}">
	<input type="hidden" id="gaccTranId" value="${gaccTranId}"/>
	<input type="hidden" id="reportId" value="GIACR050"/> <!-- belle 11.21.2011 -->
</div>

<div id="reportGeneratorMain" class="sectionDiv" style="text-align: center; margin-top: 5px; margin-bottom: 10px; width: 99%;">
	<table style="margin-top: 10px; margin-bottom: 10px; width: 100%">
		<tr>
			<td class="rightAligned" style="width: 30%;">OR No. </td>
			<td class="leftAligned" style="width: 70%;">
				<input type="text" id="txtOrPref" name="txtOrPref" value="" style="width: 70px;" disabled="disabled" />
				<input class="integerNoNegativeUnformatted" type="text" id="txtOrNo" name="txtOrNo" value="" style="width: 140px; margin-left: 2px; text-align: right;" readonly="readonly" maxlength="10"/> <!-- added by steven 1/7/2013 class="integerUnformatted" -->
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 30%">OR Type </td>
			<td class="leftAligned">
				<div id="orTypeRadioBtnDiv">
					<label id="lblVatOR" style="width: 200px;"><input type="radio" id="vatOR" name="orType" value="V"/> VAT O.R.</label>
                    <label id="lblNvOR"  style="width: 200px;"><input type="radio" id="nvOR" name="orType" value="N"/> Non-VAT O.R.</label>
                    <label id="lblNvOAR" style="width: 200px;" ><input type="radio" id="nvOAR" name="orType" value="N"/> Non-VAT O.A.R.</label>
                    <label id="lblMiscOR" style="width: 200px;"><input type="radio" id="miscOR" name="orType" value="MIS" /> Misc O.R.</label>
				</div>
			</td>			
		</tr>
		<tr>
			<td class="rightAligned" style="width=30%;">Destination</td>
			<td class="leftAligned" style="width: 70%">
				<select id="reportDestination" style="width: 70%;">
					<option value="PRINTER">GENIISYS PRINTER</option>
					<option value="LOCAL">LOCAL PRINTER</option>	
			</select>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 30%;">Printer</td>
			<td class="leftAligned" style="width: 70%;">
				<select id="printerName" style="width: 70%;" class="required">
					<option value=""></option>
				</select>
			</td>
		</tr>
	</table>
</div>
<div id="" style="text-align: center;">
	<input type="button" class="button" id="btnPrint" value="OK" style="width: 80px;"/>
	<input type="button" class="button" id="btnReturn" value="Cancel"  style="width: 80px;"/>
</div>

<script type="text/javascript">
	insertPrinterNames();
	initializeAll(); //added by steven 1/7/2013
	var orType = '${orType}';
	var paramMap = eval((('(' + '${prnORMap}' + ')').replace(/&#62;/g, ">")).replace(/&#60;/g, "<"));
	
	loadORTypesDflts(); //belle 11.17.2011
	
	if(paramMap.editOrNo == "Y") {
		$("txtOrNo").removeAttribute("readonly");
	} else {
		//$("txtOrNo").removeAttribute("readonly");
		$("txtOrNo").setAttribute("readonly", "readonly");
	}
	
	if(paramMap.printEnabled == "N") {
		disableButton("btnPrint");
	}
	
	$("reportDestination").selectedIndex = 0;
	$("txtOrPref").value = paramMap.orPref;
	$("txtOrNo").value = /*paramMap.orNo == null ? "1" :*/ parseFloat(paramMap.orNo).toPaddedString(10); //added padding by robert 11.07.2013
	
	//added by robert
	$("txtOrNo").observe("change", function() {
		if($F("txtOrNo").blank()) {
			customShowMessageBox("OR Number must be specified","I","txtOrNo");
		}else{
			if(parseFloat($F("txtOrNo"))== parseFloat(0)){
				customShowMessageBox("Must be in range 000000001 to 999999999.", "I","txtOrNo");
			}
			$("txtOrNo").value = parseFloat($F("txtOrNo")).toPaddedString(10);
		}
	});
	
	$("reportDestination").observe("change", function() {
		if($F("reportDestination") == "SCREEN") {
			$("printerName").disable();
		} else {
			$("printerName").enable();
		}
	});
	
	$$("input[name='orType']").each(function(r) {
		$(r.id).observe("click", function() {
			if(r.checked == true) {
				loadPrintORValues(r.value);
				if(r.id == "vatOR") {
					orType = "V";
					$("reportId").value = 'GIACR050'; //belle 11.22.2011
				} else if(r.id == "nvOR") {
					orType = "N";
					$("reportId").value = 'GIACR050';
				} else if(r.id == "miscOR"){
					orType = "MIS";
					$("reportId").value = 'GIACR050';
				} else if (r.id == "nvOAR"){
					$("reportId").value = 'GIACR050A';
				}
			}
		});
	});

	$("reportDestination").observe("change", function(){
		checkPrintORDestinationFields();
	});

	$("btnReturn").observe("click", function(){
		//Modalbox.hide();
		overlayOR.close();		
	});

	function loadPrintORValues(orPref) {
		try {
			new Ajax.Request(contextPath+"/PrintORController?action=changeORPref", {
				method: "GET",
				parameters:{
					globalGaccTranId	: objACGlobal.gaccTranId,
					globalGaccBranchCd	: objACGlobal.branchCd,
					globalGaccFundCd	: objACGlobal.fundCd,
					orPref				: orPref
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					paramMap = JSON.parse(response.responseText);
					$("txtOrPref").value = paramMap.orPref;
					$("txtOrNo").value = parseFloat(paramMap.orNo).toPaddedString(10); //added padding by robert 11.07.2013
					orType = paramMap.orType; //marco - 07.05.2013 - @ucpbgen
				}
			});
		} catch(e) {
			showErrorMesage("loadPrintORValues", e);
		}
	}

	$("btnPrint").observe("click", function() {
		if(paramMap.printEnabled == "N") {
			showMessageBox("This transaction already has an OR.", imgMessage.ERROR);
		} else {
			startORPrinting();
		}
	});
	
	function generateNewOR() {
		new Ajax.Request(contextPath+"/PrintORController", {
			method: "GET",
			parameters: {
				action: "generateNewORNo",
				globalGaccTranId: objACGlobal.gaccTranId,
				globalGaccBranchCd: objACGlobal.branchCd,
				globalGaccFundCd: objACGlobal.fundCd,
				orPref: $F("txtOrPref"),
				orNo: $F("txtOrNo"),
				orType: orType,
				editOrNo: paramMap.editOrNo
			},
			evalScripts: true,
			asynchronous: true,
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var res = JSON.parse(response.responseText);
					if(res.result == null || res.result == "Y") {
						$("txtOrNo").value = nvl(res.orNo, null) == null ? $F("txtOrNo") : res.orNo;
						$("txtOrNo").value = parseFloat($F("txtOrNo")).toPaddedString(10); //added by robert 11.07.2013
					} else {
						showMessageBox(res.result);
					}
				}
			}
		});
	}
	
	//if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
	function startORPrinting() {
		try {
			showNotice("Preparing to print...");
			if($F("txtOrPref").blank()) {
				showMessageBox("Unable to Print. OR Pref is required.");
				return false;
			} else if($F("txtOrNo").blank()) {
				showMessageBox("OR Number must be specified");
				$("txtOrNo").focus();
				return false;
			} else if(parseFloat($F("txtOrNo"))== parseFloat(0)){ //added by robert 11.07.2013
				customShowMessageBox("Must be in range 000000001 to 999999999.", "I","txtOrNo");
				return false;
			} else if ("PRINTER" == $F("reportDestination") && $F("printerName") == ""){
				showWaitingMessageBox("Please select a printer.", imgMessage.INFO, 
					function(){
						$("printerName").focus();
				});
			} else {
				new Ajax.Request(contextPath+"/PrintORController", {
					method: "GET",
					parameters: {
						action: "validateOR",
						globalGaccTranId: objACGlobal.gaccTranId,
						globalGaccBranchCd: objACGlobal.branchCd,
						globalGaccFundCd: objACGlobal.fundCd,
						orPref: $F("txtOrPref"),
						orNo: $F("txtOrNo"),
						orType: orType,
						editOrNo: paramMap.editOrNo
					},
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					//  if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, generateNewOR)){
							var paramMap2 = JSON.parse(response.responseText);
							if(paramMap.editOrNo == "N") {
								$("txtOrNo").value = paramMap2.orNo == null ? $F("txtOrNo") : paramMap2.orNo; // in case naupdate yun O.R. no sa UPDATE_GIOP_GIACS050
								$("txtOrNo").value = parseFloat($F("txtOrNo")).toPaddedString(10); //added by robert 11.07.2013
// 								processPrintedOR(); //remove by steven 2/26/2013
								processPrintedOR();  //brought back :) by jeffdojello 12.04.2013
							}// else {
							//processPrintedOR();//monmon commented out by jeffdojello 12.04.2013
							printCurrentOR($F("reportId"), $("reportDestination").value, $("printerName").value, "1", "1",  
									$("txtOrPref").value, $("txtOrNo").value);
							//}
						} 
					}
				});
			}
		} catch(e) {
			showErrorMessage("startORPrinting", e);
		}
	}

	function printCurrentOR(reportId, destination, printerName, noOfCopies, isDraft, orPref, orNo) {
		try {			
			var content = contextPath+"/PrintORController?action=printCurrentOR&globalGaccTranId="+objACGlobal.gaccTranId
			+"&globalGaccBranchCd="+objACGlobal.branchCd+"&globalGaccFundCd="+objACGlobal.fundCd
			+"&noOfCopies="+noOfCopies+"&printerName="+encodeURIComponent(printerName)+"&orPref="+orPref
			+"&orNo="+orNo+"&reportId="+reportId+"&destination="+destination;
			
			if ("SCREEN" == destination) {
				showPdfReport(content, "Official Receipt"); // andrew - 12.12.2011
				hideNotice("");
				if (!(Object.isUndefined($("reportGeneratorMain")))){
					hideOverlay();
				} 
				
				if(paramMap.editOrNo == "Y") {
					//showConfirmBox("Confirm", "Was the printing successful?", "Yes", "No", printingORDone/*processPrintedOR*/, confirmSpoilOR); //comment out by jeffdojello 12.04.2013
					showConfirmBox("Confirm", "Was the printing successful?", "Yes", "No", processPrintedOR, confirmSpoilOR);  //reverted by jeffdojello 12.04.2013
				} else {
					showConfirmBox("Confirm", "Was the printing successful?", "Yes", "No", function() {
						//objACGlobal.orFlag = "P";
						printingORDone(); //processPrintedOR(); //added by steven 2/26/2013
						setORParams("GIACS025");
						//Modalbox.hide();
						overlayOR.close();
						showORPreview();
					}, function() {
						confirmSpoilOR2();
					});
				}
			} else {
				new Ajax.Request(content, {
					method: "POST",
					evalScripts: true,
					asynchronous: false,
					onComplete: function(response){
						if (checkErrorOnResponse(response)){
							hideNotice();
							if(destination == "LOCAL"){	
								printORToLocalPrinter(response.responseText); //marco - 07.11.2013 - @ucpb from printToLocalPrinter
							}else{
								if(paramMap.editOrNo == "Y") {
									//showConfirmBox("Confirm", "Was the printing successful?", "Yes", "No", printingORDone/*processPrintedOR*/, confirmSpoilOR); //comment out by jeffdojello 12.04.2013
									showConfirmBox("Confirm", "Was the printing successful?", "Yes", "No", processPrintedOR, confirmSpoilOR);  //reverted by jeffdojello 12.04.2013
								} else {
									//processPrintedOR();
									showConfirmBox("Confirm", "Was the printing successful?", "Yes", "No", function() {
										//objACGlobal.orFlag = "P";
										printingORDone(); //processPrintedOR(); //added by steven 2/26/2013
										setORParams("GIACS025");
										//Modalbox.hide();
										overlayOR.close();
										showORPreview();
									}, function() {
										confirmSpoilOR2();
									});
								}
							}
						}else{ //marco - 07.11.2013 - @ucpb added to prompt printing confirmation if exception occured
							if(paramMap.editOrNo == "Y") {
								//showConfirmBox("Confirm", "Was the printing successful?", "Yes", "No", printingORDone/*processPrintedOR*/, confirmSpoilOR); //comment out by jeffdojello 12.04.2013
								showConfirmBox("Confirm", "Was the printing successful?", "Yes", "No", processPrintedOR, confirmSpoilOR);  //reverted by jeffdojello 12.04.2013
							} else {
								showConfirmBox("Confirm", "Was the printing successful?", "Yes", "No", function() {
									printingORDone(); //processPrintedOR();
									setORParams("GIACS025");
									//Modalbox.hide();
									overlayOR.close();
									showORPreview();
								}, confirmSpoilOR2);
							}
						}
					}
				});
				if (!(Object.isUndefined($("reportGeneratorMain")))){
					hideOverlay();
				} 
			}
			
		} catch(e) {
			showErrorMessage("printCurrentOR", e);
		}
	}
	
	//marco - 07.11.2013 - @ucpb copied from printToLocalPrinter from footer.jsp
	//					 - to avoid modification of common function for local printing
	function printORToLocalPrinter(url) {
		try {
			var maintenanceMode = "${maintenanceMode}";	
			
			function confirmPrinting(){
				if(paramMap.editOrNo == "Y") {
					//showConfirmBox("Confirm", "Was the printing successful?", "Yes", "No", printingORDone/*processPrintedOR*/, confirmSpoilOR); //comment out by jeffdojello 12.04.2013
					showConfirmBox("Confirm", "Was the printing successful?", "Yes", "No", processPrintedOR, confirmSpoilOR);  //reverted by jeffdojello 12.04.2013
				} else {
					showConfirmBox("Confirm", "Was the printing successful?", "Yes", "No", function() {
						printingORDone(); //processPrintedOR();
						setORParams("GIACS025");
						//Modalbox.hide();
						overlayOR.close();
						showORPreview();
					}, confirmSpoilOR2);
				}
			}
			
			function deletePrintedReport(){
				new Ajax.Request(contextPath + "/", {
					parameters : {
						action : "deletePrintedReport",
						url : url
					},
					asynchronous: false,
					evalScripts: true,
					onComplete: function(response){
						confirmPrinting();
					}
				});
			}
			
			if(maintenanceMode == "On"){
				showWaitingMessageBox("Local printer applet is not available during maintenance mode.", imgMessage.INFO, confirmPrinting);
			}
			
			if($("geniisysAppletUtil") == null || $("geniisysAppletUtil").printJRPrintFileToPrinter == undefined){
				showWaitingMessageBox("Local printer applet is not configured properly. Please verify if you have accepted to run the Geniisys Utility Applet and if the java plugin in your browser is enabled.", imgMessage.ERROR, confirmPrinting);
			} else {
				var message = $("geniisysAppletUtil").printJRPrintFileToPrinter(url);			
				if(nvl(message, "") != "SUCCESS"){
					showWaitingMessageBox(message, imgMessage.ERROR, deletePrintedReport);
				}else{
					deletePrintedReport();
				}
			}
		} catch (e){
			showWaitingMessageBox(e.message, "I", confirmPrinting);
		}
	}

	function processPrintedOR() {
		try {
			new Ajax.Request(contextPath+"/PrintORController", {
				method: "POST",
				parameters: {
					action: "processPrintedOR",
					globalGaccTranId: objACGlobal.gaccTranId,
					globalGaccBranchCd: objACGlobal.branchCd,
					globalGaccFundCd: objACGlobal.fundCd,
					orPref: $F("txtOrPref"),
					orNo: $F("txtOrNo"),
					orType: orType,
					editOrNo: paramMap.editOrNo
				},
				evalScripts: true,
				asynchronous: false,
				onComplete: function(response) {
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
						/* objACGlobal.orFlag = "P";
						objAC.tranFlagState = "P"; */
						if(paramMap.editOrNo == "Y") {
							setORParams("GIACS025");
							showMessageBox("Transaction successful.", imgMessage.SUCCESS);
							//Modalbox.hide();
							overlayOR.close();
							showORPreview();
							if(objACGlobal.orFlag == "P"){ //added by christian 03/18/2013
								if ($("orStatus") != undefined) $("orStatus").value = "PRINTED";
							}
						} //else { //marco - 07.08.2013 - @ucpb - comment out printCurrentOR to prevent multiple printing
							/* $("txtOrPref").value = paramMap2.orPref == null ? $F("txtOrPref") : paramMap2.orPref;
							$("txtOrNo").value = paramMap2.orNo == null ? $F("txtOrNo") : paramMap2.orNo; */
							//printCurrentOR(/*"OR"*/$F("reportId"), $("reportDestination").value, $("printerName").value, "1", "1",  //belle 11.21.2011
							//		$("txtOrPref").value, $("txtOrNo").value);
						//}
						
					}
				}
			});
		} catch(e) {
			showErrorMessage("processPrintedOR", e);
		}
		
	}
	
	function printingORDone() {
		try {
			if(paramMap.editOrNo == "Y") {
				setORParams("GIACS025");
				showMessageBox("Transaction successful.", imgMessage.SUCCESS);
				//Modalbox.hide();
				overlayOR.close();
				showORPreview();
			}
			
		} catch(e) {
			showErrorMessage("processPrintedOR", e);
		}
		
	}
	
	function confirmSpoilOR() {
		showConfirmBox("Confirmation", "What do you want to do?", "Spoil OR", "Restore OR", spoilPrintedOR, function() {
				//Modalbox.hide();
				overlayOR.close();
			});
	}

	function confirmSpoilOR2() {
		//showConfirmBox("Confirmation", "OR Number "+$F("txtOrNo")+"-"+$F("txtOrPref")+" will be spoiled.", "Ok", "Return", spoilPrintedOR2, //marco - 07.09.2013 @ucpb
		showConfirmBox("Confirmation", "OR Number "+$F("txtOrPref")+"-"+$F("txtOrNo")+" will be spoiled.", "Ok", "Return", spoilPrintedOR2,
				function() {
					showConfirmBox("Confirm", "Was the printing successful?", "Yes", "No", 
							function() {
									printingORDone(); //processPrintedOR(); //added by steven 2/26/2013
									setORParams("GIACS025");
									//Modalbox.hide();
									overlayOR.close();
									showORPreview();
								}, confirmSpoilOR2);
					
			});
	}
	
	function spoilPrintedOR() {
		try {
			new Ajax.Request(contextPath+"/PrintORController?action=spoilPrintedOR&globalGaccTranId="+objACGlobal.gaccTranId
					+"&globalGaccBranchCd="+objACGlobal.branchCd+"&globalGaccFundCd="+objACGlobal.fundCd
					+"&orPref="+$F("txtOrPref")+"&orNo="+$F("txtOrNo")+"&orType="+orType, {
				method: "POST",
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
				objACGlobal.orFlag = "P";
					if(checkErrorOnResponse(response)) {
						var check = response.responseText;
						if(check == "Y") {
							showMessageBox($F("txtOrPref")+"-"+$F("txtOrNo")+" has been spoiled.", imgMessage.SUCCESS);
							objACGlobal.orFlag = "N";
							//Modalbox.hide();
							overlayOR.close();
							showORPreview();
						} else if(check == "N"){
							showMessageBox("The current transaction ID has already been printed.", imgMessage.ERROR);
						} else {
							notSuccPrinting(); //added by steven 2/26/2013
							showMessageBox(check, imgMessage.ERROR);
						}
						//Modalbox.hide();
						overlayOR.close();
					}
				}
			});
			
		} catch(e) {
			showErrorMessage("spoilPrintedOR", e);
		}
	}
	/* added by steven 2/26/2013 
	*  description: to delete the value of or_no and or_pref_suf when the printing is not successful.
	*/
	function notSuccPrinting() {
		try {
			new Ajax.Request(contextPath+"/PrintORController?action=notSuccPrinting&globalGaccTranId="+objACGlobal.gaccTranId
					+"&globalGaccBranchCd="+objACGlobal.branchCd+"&globalGaccFundCd="+objACGlobal.fundCd, {
				method: "POST",
				onComplete: function(response){
					if(checkErrorOnResponse(response)) {
						//walang gagawin
					}
				}
			});
		} catch(e) {
			showErrorMessage("notSuccPrinting", e);
		}
	}
	//checkPrintDestinationFields
	function checkPrintORDestinationFields(){
		if ("SCREEN" == $("reportDestination").value || "" == $("reportDestination").value
				|| "LOCAL" == $("reportDestination").value){
			$("printerName").removeClassName("required");
			$("printerName").disable();
			//$("noOfCopies").disable();
			$("printerName").selectedIndex = 0;
			/*$("noOfCopies").selectedIndex = 0;
			if ($("isPreview") != undefined){
				$("isPreview").value = 1;
			}*/
		} else if ("PRINTER" == $F("reportDestination")){
			$("printerName").enable();
			$("printerName").addClassName("required");
/*			if ($("isPreview") != undefined){
				$("isPreview").value = 0;
			}*/
		}
	}
	
	function spoilPrintedOR2(){
		new Ajax.Request(contextPath+"/GIACOrderOfPaymentController?action=spoilOr", {
			method: "GET",
			parameters: {
				gaccTranId: objACGlobal.gaccTranId,
				butLabel: "Spoil OR",	
				orFlag: "P", //objACGlobal.orFlag, //marco - 07.09.2013
				orTag: objACGlobal.orTag,
				orPrefSuf: $F("txtOrPref"),
				orNo:	$F("txtOrNo"),
				gibrFundCd: objACGlobal.fundCd,
				gibrBranchCd: objACGlobal.branchCd,
				orDate:	$F("orDate"),
				dcbNo: objORPrinting.dcbNo,
				callingForm: "",
				moduleName: "GIACS050",
				orCancellation: 'N',
				payor: $F("payor"),
				collectionAmt: objORPrinting.collectionAmt,
				cashierCd: objORPrinting.cashierCd,
				grossAmt: objORPrinting.grossAmt,
				grossTag: objORPrinting.grossTag,
				itemNo: 1			
			},
			evalScripts: true,
			asynchronous: true,
			onComplete: function(response){
				var result = response.responseText.toQueryParams();
				if (result.message != "null") {
					notSuccPrinting(); //added by steven 2/26/2013
					showMessageBox(result.message, imgMessage.ERROR);
					//Modalbox.hide();
					overlayOR.close();
				}else{
					showMessageBox($F("txtOrPref")+"-"+$F("txtOrNo")+" has been spoiled.", imgMessage.SUCCESS);
					objACGlobal.orFlag = "N";
					//Modalbox.hide();
					overlayOR.close();
					//showORPreview();
				}
			}
		});
	}
	
    //belle 11.17.2011 display default OR types based on parameters
    function loadORTypesDflts(){
        try{
           if (paramMap.dspOrTypes == 'Y'){
                if (paramMap.issueNonvatOAR == 'Y'){
                    if(paramMap.premIncRelated == 'Y'){
                        /* removed by robert 04.03.2014
                           loadPrintORValues(paramMap.vatNonvatSeries);
                           $("vatOR").checked = true; 
                           $("lblNvOAR").hide(); */
                        //added by robert 04.03.2014 
                    	$("lblNvOR").hide();
                        if (paramMap.vatNonvatSeries == 'V'){
                            loadPrintORValues(paramMap.vatNonvatSeries);
                            $("vatOR").checked = true; 
                        }else if (paramMap.vatNonvatSeries == 'N'){
                            loadPrintORValues(paramMap.vatNonvatSeries);
                            $("nvOAR").checked = true;
                        }else if (paramMap.vatNonvatSeries == 'M'){ 
                            loadPrintORValues(paramMap.vatNonvatSeries);
                            $("miscOR").checked = true;
                        }
                        //end robert 04.03.2014
                    }else if (paramMap.premIncRelated == 'N'){
                        loadPrintORValues(orType);
                        $("nvOAR").checked = true; // OAR call GIACR050A
                        $("lblNvOR").hide();
                        $("reportId").value = 'GIACR050A';
                    }
                }else if (paramMap.issueNonvatOAR == 'N') { 
                    /* removed by robert 04.03.2014
                       $("lblNvOAR").hide();
                       if(orType == "V") {
                           $("vatOR").checked = true;
                       } else if(orType == "N") {
                           $("nvOR").checked = true;
                       } else {
                           $("miscOR").checked = true;
                       }*/
                    //added by robert 04.03.2014 
		    		$("lblNvOAR").hide();
                    if (paramMap.vatNonvatSeries == 'V'){
                        loadPrintORValues(paramMap.vatNonvatSeries);
                        $("vatOR").checked = true; 
                    }else if (paramMap.vatNonvatSeries == 'N'){
                        loadPrintORValues(paramMap.vatNonvatSeries);
                        $("nvOR").checked = true;
                    }else if (paramMap.vatNonvatSeries == 'M'){
                        loadPrintORValues(paramMap.vatNonvatSeries);
                        $("miscOR").checked = true;
                    }
                    //end robert 04.03.2014
                }
            }else if (paramMap.dspOrTypes == 'N'){
                if(paramMap.issueNonvatOAR == 'Y'){
                    if(paramMap.premIncRelated == 'Y'){
                        $("lblNvOAR").hide();
                        if (paramMap.vatNonvatSeries == 'V'){
                            loadPrintORValues(paramMap.vatNonvatSeries);
                            $("vatOR").checked = true; 
                            $("lblNvOR").hide();
                            $("lblMiscOR").hide();
                        }else if (paramMap.vatNonvatSeries == 'N'){
                            loadPrintORValues(paramMap.vatNonvatSeries);
                            //$("nvOR").checked = true; removed by robert 04.03.2014
                            $("lblNvOAR").show(); //added by robert 04.03.2014
                            $("nvOAR").checked = true; //added by robert 04.03.2014
                            $("lblVatOR").hide();
                            $("lblMiscOR").hide();
                            $("lblNvOR").hide(); //added by robert 04.03.2014
                        }else if (paramMap.vatNonvatSeries == 'M'){ 
                            loadPrintORValues(paramMap.vatNonvatSeries);
                            $("miscOR").checked = true;
                            $("lblVatOR").hide();
                            $("lblNvOR").hide();
                        }
                    }else if (paramMap.premIncRelated == 'N'){ // OAR call GIACR050A  
                        $("nvOAR").checked = true;
                        $("lblVatOR").hide();
                        $("lblNvOR").hide();
                        $("lblMiscOR").hide();
                        $("reportId").value = 'GIACR050A'; //marco - 07.10.2013 - @ucpb :(
                    }
                }else if (paramMap.issueNonvatOAR == 'N'){
                    $("lblNvOAR").hide();
                    if (paramMap.vatNonvatSeries == 'V'){
                        loadPrintORValues(paramMap.vatNonvatSeries);
                        $("vatOR").checked = true; 
                        $("lblNvOR").hide();
                        $("lblMiscOR").hide();
                    }else if (paramMap.vatNonvatSeries == 'N'){
                        loadPrintORValues(paramMap.vatNonvatSeries);
                        $("nvOR").checked = true;
                        $("lblVatOR").hide();
                        $("lblMiscOR").hide();
                    }else if (paramMap.vatNonvatSeries == 'M'){
                        loadPrintORValues(paramMap.vatNonvatSeries);
                        $("miscOR").checked = true;
                        $("lblVatOR").hide();
                        $("lblNvOR").hide();
                    }
                }
            }
        }catch(e){
            showErrorMessage("loadORTypesDflts", e);
        }
    }
</script>