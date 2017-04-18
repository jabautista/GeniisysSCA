<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="printDialogMainDiv" style="width: 99.5%; padding-top: 5px; float: left;" align="center">
	<input type="hidden" id="printApdcId" value="${apdcId}" />
	<div class="sectionDiv" style="float: left; padding: 5px 0;" id="printDialogOptionsFormDiv">
		<table style="margin-left: 64px; ">
			<tr>
				<td class="leftAligned" style="" for="printApdcNo">APDC No</td>
				<td class="rightAligned" style="float: left;">
					<input type="text" id="printApdcNo" name="printApdcNo" style="width: 190px; text-align: right;" value="${apdcNo}" class="required" maxlength="10"/>
				</td>				
			</tr>
			<tr>
				<td class="leftAligned" style=""></td>
				<td style="margin:2px; float: left;">					
					<label style="" title=""><input id="cicPrintTag" type="checkbox" style="" />w/ Certificate of Insurance Coverage</label>				
				</td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv" style="float: left;" id="printDialogFormDiv">
		<table id="printDialogMainTab" name="printDialogMainTab" align="center" style="padding: 10px;">
			<tr>
				<td class="rightAligned">Destination&nbsp;</td>
				<td class="leftAligned">
					<select id="selDestination" style="width: 200px;">
						<option value="screen">Screen</option>
						<option value="printer">Printer</option>
						<option value="file">File</option>
						<option value="local">Local Printer</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Printer&nbsp;</td>
				<td class="leftAligned">
					<select id="selPrinter" style="width: 200px;" class="required">
						<option></option>
						<%-- <c:forEach var="p" items="${printers}">
							<option value="${p.printerNo}">${p.printerName}</option>
						</c:forEach> --%>
						<!-- installed printers muna gamitin - andrew - 02.27.2012 -->
						<c:forEach var="p" items="${printers}">
							<option value="${p.name}">${p.name}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">No. of Copies&nbsp;</td>
				<td class="leftAligned">
					<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma">
					<div style="float: left; width: 15px;">
						<img id="imgSpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; cursor: pointer;">
						<img id="imgSpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; display: none;">
						<img id="imgSpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;">
						<img id="imgSpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;">
					</div>					
				</td>
			</tr>
		</table>
	</div>
	<div id="buttonsDiv" style="float: left; width: 100%; margin-top: 10px; margin-bottom: 5px;">
		<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="width: 80px;">
		<input type="button" class="button" id="btnPrintCancel" name="btnPrintCancel" value="Cancel">		
	</div>	
</div>
<script type="text/javascript">
	var cicPrintTag = "${cicPrintTag}";

	initializeAll();

	function verifyARPrinting(){
		if ($F("statusCd") == "N" && $F("apdcNoText") == ""){
			new Ajax.Request(contextPath+"/PrintAcknowledgmentReceiptController?action=verifyARPrinting",{
				method: "POST",
				parameters: {
					apdcNo: $F("printApdcNo"),
					apdcPref: $F("apdcNo1"),
					branchCd: $F("globalBranchCd"),
					fundCd: $F("globalFundCd")
				},
				evalScripts: true,
				asynchronous: false,
				onCreate: function (){
	
				},
				onSuccess: function (response){
					if (checkErrorOnResponse(response)){
						if (response.responseText == "Success"){
							printAcknowledgementReceipt();
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
							return false;
						}
					}
				}
			});
		} else {
			printAcknowledgementReceipt();
		}
	}

	function printAcknowledgementReceipt(){
		new Ajax.Request(contextPath+"/PrintAcknowledgmentReceiptController?action=prepareARReportVariables",{
			evalScripts: true,
			asynchronous: false,
			onCreate: function (){

			},
			onSuccess: function (response){
				if (checkErrorOnResponse(response)){
					changeTag = 0;
					printParams = JSON.parse(response.responseText);
					var content = contextPath+"/PrintAcknowledgmentReceiptController?action=printAcknowledgmentReceipt&apdcId="+
						$F("printApdcId")+"&company="+printParams.company+"&companyAddr="+printParams.companyAddr+"&printerName="+$F("selPrinter")+
						"&noOfCopies="+$F("txtNoOfCopies")+"&destination="+$F("selDestination")+//added destination - Halley 11.15.13
						"&apdcNo="+$F("printApdcNo"); //added by jeffdojello 12.12.2013
						
					
					printGenericReport(content, "Acknowledgment Receipt", confirmPrint);  //added by Halley 11.15.13
					
					//commented out, replaced with printGenericReport - Halley 11.15.13
					/*if ("screen" == $F("selDestination")) {
						showPdfReport(content, "Acknowledgment Receipt"); // andrew - 12.12.2011
						/* if (!(Object.isUndefined($("printAPDCMainDiv")))){
							hideOverlay();
						} */
				    /*} else {
						/*new Ajax.Request(content,{
							method: "POST",
							evalScripts: true,
							asynchronous: false,
							onCreate: function (){
								
							},
							onSuccess: function (response){
								
							}
						});
					}
					/*if(!$("printApdcNo").hasAttribute("readonly")){
						showConfirmBox("Print APDC", "Was the APDC printed correctly?",
								"Yes", "No",
								savePrintChanges, "");
					}*/
				}
			}
		}); 
	}
	
	//added by Halley 11.15.13
	function confirmPrint(){ 
		if(!$("printApdcNo").hasAttribute("readonly")){
			showConfirmBox("Print APDC", "Was the APDC printed correctly?",
					"Yes", "No",
					savePrintChanges, "");
		}
	}

	function savePrintChanges(){
		new Ajax.Request(contextPath+"/PrintAcknowledgmentReceiptController?action=savePrintChanges",{
			method: "POST",
			parameters: {
				apdcId: $F("printApdcId"),
				apdcNo: $F("printApdcNo"),
				branchCd: $F("globalBranchCd"),
				fundCd: $F("globalFundCd"),
				cicPrintTag : ($("cicPrintTag").checked ? "Y" : "N"),
			},
			evalScripts: true,
			asynchronous: false,
			onComplete : function (response){
				if (checkErrorOnResponse(response)){
					showAcknowledgementReceipt($F("globalBranchCd"), "GIACS090");
					$("printApdcNo").writeAttribute("readonly", "readonly");
					$("cicPrintTag").disable();
				}
			}
		});
	}
	
	
	function toggleRequiredFields(dest){
		if(dest == "printer"){			
			$("selPrinter").disabled = false;
			$("txtNoOfCopies").disabled = false;
			$("selPrinter").addClassName("required");
			$("txtNoOfCopies").addClassName("required");
			$("imgSpinUp").show();
			$("imgSpinDown").show();
			$("imgSpinUpDisabled").hide();
			$("imgSpinDownDisabled").hide();
			$("txtNoOfCopies").value = 1;
		} else {
			$("selPrinter").value = "";
			$("txtNoOfCopies").value = "";
			$("selPrinter").disabled = true;
			$("txtNoOfCopies").disabled = true;
			$("selPrinter").removeClassName("required");
			$("txtNoOfCopies").removeClassName("required");
			$("imgSpinUp").hide();
			$("imgSpinDown").hide();
			$("imgSpinUpDisabled").show();
			$("imgSpinDownDisabled").show();			
		}
	}

	$("btnPrintCancel").observe("click", function(){
		overlayAPDCPrintDialog.close();
	});
	
	$("imgSpinUp").observe("click", function(){
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		$("txtNoOfCopies").value = no + 1;
	});
	
	$("imgSpinDown").observe("click", function(){
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if(no > 1){
			$("txtNoOfCopies").value = no - 1;
		}
	});
	
	$("imgSpinUp").observe("mouseover", function(){
		$("imgSpinUp").src = contextPath + "/images/misc/spinupfocus.gif";
	});
	
	$("imgSpinDown").observe("mouseover", function(){
		$("imgSpinDown").src = contextPath + "/images/misc/spindownfocus.gif";
	});
	
	$("imgSpinUp").observe("mouseout", function(){
		$("imgSpinUp").src = contextPath + "/images/misc/spinup.gif";
	});
	
	$("imgSpinDown").observe("mouseout", function(){
		$("imgSpinDown").src = contextPath + "/images/misc/spindown.gif";
	});
	
	$("selDestination").observe("change", function(){
		var dest = $F("selDestination");
		toggleRequiredFields(dest);
	});	
		
	$("btnPrint").observe("click", function(){
		var dest = $F("selDestination");
		if(dest == "printer" && checkAllRequiredFieldsInDiv("printDialogFormDiv")){			
			verifyARPrinting();
		}else{
			verifyARPrinting();		
		}	
	});
	
	$("printApdcNo").observe("change", function(){
		if(parseInt($F("printApdcNo")) < 1 || parseInt($F("printApdcNo")) > 9999999999){
			showWaitingMessageBox("Invalid APDC No. Valid value is from 1 to 9999999999.", "E", function(){
				$("printApdcNo").focus();
				$("printApdcNo").select();
			});
		} else {
			$("printApdcNo").value = formatNumberDigits(parseInt($F("printApdcNo")), 10);			
		}
	});
	
	$("printApdcNo").observe("keyup", function(){
		if(isNaN($F("printApdcNo"))){
			$("printApdcNo").value = "";
		}
	});
	
	toggleRequiredFields("screen");
	$("printApdcNo").focus();
	$("printApdcNo").select();	
	
	if($F("statusCd") == "P"){
		$("printApdcNo").setAttribute("readonly", "readonly");
		$("cicPrintTag").disable();
	} else {
		$("printApdcNo").removeAttribute("readonly");
	}
	
	if(cicPrintTag == "Y"){
		$("cicPrintTag").checked = true;
	}
</script>