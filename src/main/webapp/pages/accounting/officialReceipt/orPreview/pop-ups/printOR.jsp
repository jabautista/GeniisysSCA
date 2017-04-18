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

<div id="reportGeneratorMain" class="sectionDiv" style="text-align: center;">
	<table style="margin-top: 10px; width: 100%">
		<tr>
			<td class="rightAligned" style="width: 30%;">OR No. </td>
			<td class="leftAligned" style="width: 70%;">
				<input type="text" id="txtOrPref" name="txtOrPref" value="" style="width: 70px;" disabled="disabled" />
				<input type="text" id="txtOrNo" name="txtOrNo" value="" style="width: 140px; margin-left: 2px; text-align: right;" readonly="readonly"/>
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
<div id="buttonsDiv" style="text-align: center;">
	<input type="button" class="button" id="btnPrint" value="OK" style=""/>
	<input type="button" class="button" id="btnReturn" value="Cancel"  style=""/>
</div>

<script type="text/javascript">
	insertPrinterNames();
	var orType = '${orType}';
	var paramMap = eval((('(' + '${prnORMap}' + ')').replace(/&#62;/g, ">")).replace(/&#60;/g, "<"));
	
	loadORTypesDflts(); //belle 11.17.2011
	if(paramMap.editOrNo == "Y") {
		$("txtOrNo").removeAttribute("readonly");
	} else {
		$("txtOrNo").setAttribute("readonly", "readonly");
	}
	
	if(paramMap.printEnabled == "N") {
		disableButton("btnPrint");
	}
	
	$("reportDestination").selectedIndex = 0;
	$("txtOrPref").value = paramMap.orPref;
	$("txtOrNo").value = /*paramMap.orNo == null ? "1" :*/ paramMap.orNo;

	/*if(orType == "V") {
		$("vatOR").checked = true;
	} else if(orType == "N") {
		$("nvOR").checked = true;
	} else {
		if($F("txtOrPref") == "V") {
			$("vatOR").checked = true;
		} else if($F("txtOrPref") == "NV" || $F("txtOrPref") == "N") {
			$("nvOR").checked = true;
		} else/* if($F("txtOrPref") == "MIS")*/ //{
			//$("miscOR").checked = true;
			//$("nvOR").checked = true;
	//	}
	//} //belle 11.17.2011 already handled in loadORTypesDflts
	
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
			/*	if(r.value == "vat") {
					//$("txtOrPref").value = "V";
					loadPrintORValues("V");
				} else if(r.value == "nonVat") {
					//$("txtOrPref").value = "NV";
					loadPrintORValues("NV");
				} else if(r.value == "misc") {
					//$("txtOrPref").value = "MIS";
					loadPrintORValues("MIS");
				} else {
					$("txtOrPref").value = "";
				}*/
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

	//$("printerName").disable();

	$("reportDestination").observe("change", function(){
		checkPrintORDestinationFields();
	});

	$("btnReturn").observe("click", function(){Modalbox.hide();});

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
					$("txtOrNo").value = /*paramMap.orNo == null ? "1" :*/ paramMap.orNo;
					/*if (response.responseText == "Y"){
						$("txtOrPref").value = paramMap.orPref;
						$("txtOrNo").value = paramMap.orNo;
					}*/
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
			} else if ("PRINTER" == $F("reportDestination") && $F("printerName") == ""){
				showWaitingMessageBox("Please select a printer.", imgMessage.INFO, 
					function(){
						$("printerName").focus();
				});
			} /*else if ("LOCAL" == $F("reportDestination")){
				printToLocalPrinter();
			}*/ else {
				//validateBeforePrint
				new Ajax.Request(contextPath+"/PrintORController?action=validateBeforePrint&globalGaccTranId="+objACGlobal.gaccTranId
						+"&globalGaccBranchCd="+objACGlobal.branchCd+"&globalGaccFundCd="+objACGlobal.fundCd
						+"&orPref="+$F("txtOrPref")+"&orNo="+$F("txtOrNo")+"&orType="+orType+"&editOrNo="+paramMap.editOrNo, {
					method: "POST",
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						var paramMap2 = JSON.parse(response.responseText);
						var mesg = paramMap2.result;
						if(checkErrorOnResponse(response)) {
							if(mesg == "Y" || mesg == "" || mesg == null) {
								if(paramMap.editOrNo == "N") {
									$("txtOrPref").value = paramMap2.orPref == null ? $F("txtOrPref") : paramMap2.orPref;
									$("txtOrNo").value = paramMap2.orNo == null ? $F("txtOrNo") : paramMap2.orNo;
									processPrintedOR();
								} else {
									printCurrentOR(/*"OR"*/$F("reportId"), $("reportDestination").value, $("printerName").value, "1", "1",  //belle 11.21.2011
											$("txtOrPref").value, $("txtOrNo").value);
								}
							} else {
								if(paramMap.editOrNo == "Y") {
									showMessageBox(mesg, imgMessage.ERROR);
								} 
							}
							
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
			+"&globalGaccBranchCd="+objACGlobal.branchCd+"&globalGaccFundCd="+objACGlobal.fundCd+
			+"&noOfCopies="+noOfCopies+"&printerName="+encodeURIComponent(printerName)+"&orPref="+orPref
			+"&orNo="+orNo+"&reportId="+reportId+"&destination="+destination;
			
			if ("SCREEN" == destination) {
				//window.open(content, "name=test", "location=no, toolbar=no, menubar=no, fullscreen=yes");
				showPdfReport(content, "Official Receipt"); // andrew - 12.12.2011
				hideNotice("");
				if (!(Object.isUndefined($("reportGeneratorMain")))){
					hideOverlay();
				} 
				
				if(paramMap.editOrNo == "Y") {
					showConfirmBox("Confirm", "Was the printing successful?", "Yes", "No", processPrintedOR, confirmSpoilOR);
				} else {
					showConfirmBox("Confirm", "Was the printing successful?", "Yes", "No", function() {
						objACGlobal.orFlag = "P";
						Modalbox.hide();
						showORPreview();
					}, function() {
						confirmSpoilOR2();
					});
				}
			} else {
				new Ajax.Request(content, {
					method: "POST",
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						if (checkErrorOnResponse(response)){
							hideNotice();
							if(destination == "LOCAL"){								
								printToLocalPrinter(response.responseText);
							}
							if(paramMap.editOrNo == "Y") {
								showConfirmBox("Confirm", "Was the printing successful?", "Yes", "No", processPrintedOR, confirmSpoilOR);
							} else {
								//processPrintedOR();
								showConfirmBox("Confirm", "Was the printing successful?", "Yes", "No", function() {
									objACGlobal.orFlag = "P";
									Modalbox.hide();
									showORPreview();
								}, function() {
									confirmSpoilOR2();
								});
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

	function processPrintedOR() {
		try {
			new Ajax.Request(contextPath+"/PrintORController?action=insUpdGIOP&globalGaccTranId="+objACGlobal.gaccTranId
					+"&globalGaccBranchCd="+objACGlobal.branchCd+"&globalGaccFundCd="+objACGlobal.fundCd
					+"&orPref="+$F("txtOrPref")+"&orNo="+$F("txtOrNo")+"&orType="+orType+"&editOrNo="+paramMap.editOrNo, {
				method: "POST",
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)) {
						var paramMap2 = JSON.parse(response.responseText);
						var check = paramMap2.pResult;
					/*	if(check == "Y") {
							objACGlobal.orFlag = "P";
							if(paramMap.editOrNo == "Y") {
								showMessageBox("Transaction successful.", imgMessage.SUCCESS);
								Modalbox.hide();
								showORPreview();
							} else {
								showConfirmBox("Confirm", "Was the printing successful?", "Yes", "No", function() {
									objACGlobal.orFlag = "P";
									Modalbox.hide();
									showORPreview();
								}, function() {
									confirmSpoilOR2();
								});
							}
						} else {
							objACGlobal.orFlag = "P";
							showMessageBox("The current transaction ID has already been printed.", imgMessage.ERROR);
							//Modalbox.hide();
						}*/
						if(check == "Y") {
							if(paramMap.editOrNo == "Y") {
								objACGlobal.orFlag = "P";
								showMessageBox("Transaction successful.", imgMessage.SUCCESS);
								Modalbox.hide();
								showORPreview();
							} else {
								objACGlobal.orFlag = "P";
								$("txtOrPref").value = paramMap2.orPref == null ? $F("txtOrPref") : paramMap2.orPref;
								$("txtOrNo").value = paramMap2.orNo == null ? $F("txtOrNo") : paramMap2.orNo;
								printCurrentOR(/*"OR"*/$F("reportId"), $("reportDestination").value, $("printerName").value, "1", "1",  //belle 11.21.2011
										$("txtOrPref").value, $("txtOrNo").value);
							}
						} else {
							objACGlobal.orFlag = "P";
							showMessageBox("The current transaction ID has already been printed.", imgMessage.ERROR);
						}
					}
				}
			});
		} catch(e) {
			showErrorMessage("processPrintedOR", e);
		}
		
	}

	function confirmSpoilOR() {
		showConfirmBox("Confirmation", "What do you want to do?", "Spoil OR", "Restore OR", spoilPrintedOR, function() {Modalbox.hide();});
	}

	function confirmSpoilOR2() {
		showConfirmBox("Confirmation", "OR Number "+$F("txtOrNo")+"-"+$F("txtOrPref")+" will be spoiled.", "Ok", "Return", spoilPrintedOR2, 
				function() {
					showConfirmBox("Confirm", "Was the printing successful?", "Yes", "No", 
							function() {
									Modalbox.hide();
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
							showMessageBox("O.R. spoiled.");
							objACGlobal.orFlag = "N";
							Modalbox.hide();
							showORPreview();
						} else if(check == "N"){
							showMessageBox("The current transaction ID has already been printed.", imgMessage.ERROR);
						} else {
							showMessageBox(check, imgMessage.ERROR);
						}
						Modalbox.hide();
					}
				}
			});
			
		} catch(e) {
			showErrorMessage("spoilPrintedOR", e);
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
				orFlag:   objACGlobal.orFlag,
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
					showMessageBox(result.message, imgMessage.ERROR);
				}else{
					showMessageBox("SUCCESS", imgMessage.SUCCESS);
					objACGlobal.orFlag = "N";
					Modalbox.hide();
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
                        loadPrintORValues(paramMap.vatNonvatSeries);
                        $("vatOR").checked = true; 
                        $("lblNvOAR").hide();
                    }else if (paramMap.premIncRelated == 'N'){
                        loadPrintORValues(orType);
                        $("nvOAR").checked = true; // OAR call GIACR050A
                        $("lblNvOR").hide();
                        $("reportId").value = 'GIACR050A';
                    }
                }else if (paramMap.issueNonvatOAR == 'N') { 
                    $("lblNvOAR").hide();
                    if(orType == "V") {
                        $("vatOR").checked = true;
                    } else if(orType == "N") {
                        $("nvOR").checked = true;
                    } else {
                        $("miscOR").checked = true;
                    }
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
                            $("nvOR").checked = true;
                            $("lblVatOR").hide();
                            $("lblMiscOR").hide();
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