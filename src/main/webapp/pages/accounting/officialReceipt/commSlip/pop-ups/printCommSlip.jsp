<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<!-- <object id="pdfDoc" name="pdfDoc" classid="clsid:CA8A9780-280D-11CF-A24D-444553540000" width="900px" height="100%">
     <param name="SRC" value="images/DR3111-001.pdf" />
 </object>
<embed id="pdfDocument" name="pdfDocument" type="application/pdf" src="images/DR3111-001.pdf" height="150px" width="150px"></embed>
<iframe id="pdfDocumentIFrame" name="pdfDocumentIFrame" type="application/pdf" src="images/DR3111-001.pdf" height="150px" width="150px"></iframe> -->
<div id="hiddenDiv">
	<input type="hidden" id="printerNames" value="${printerNames}">
	<input type="hidden" id="reportType" value="${reportType}">
	<input type="hidden" id="gaccTranId" value="${gaccTranId}"/>
</div>
<div id="reportGeneratorMain">
	<div id="reportGeneratorDiv1" class="sectionDiv" style="text-align: center; padding-bottom: 10px;">
		<table style="margin-top: 10px; width: 100%;">
			<tr>
				<td class="rightAligned" style="width: 30%;">Comm Slip No. </td>
				<!-- <td class="leftAligned" style="width: 70%">
					<input type="text" id="txtCommSlipPref" name="txtCommSlipPref" value="" style="width: 120px;" readonly="readonly" />
					<input type="text" id="txtCommSlipNo" name="txtCommSlipNo" value=""	style="width: 120px; margin-left: 2px;" readonly="readonly" />
				</td> -->
				<td class="leftAligned" style="width: 15%">
					<input type="text" id="txtCommSlipPref" name="txtCommSlipPref" value="" style="width: 120px;" readonly="readonly" tabindex="201"/>
				</td>
				<td class="leftAligned" style="width: 35%">
					<input type="text" id="txtCommSlipNo" name="txtCommSlipNo" value=""	style="width: 120px; margin-left: 2px;" readonly="readonly" tabindex="202"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 30%">Comm Slip Date</td>
				<td class="leftAligned" style="width: 15%">
					<div style="float:left; border: solid 1px gray; width: 126px; height: 21px; margin-right:3px; background-color: white;">
			    		<input style="height: 13px; width: 102px; border: none; float: left;" id="txtCommSlipDate" name="txtCommSlipDate" type="text" readonly="readonly" tabindex="203"/>
			    		<img name="imgCSDate" id="imgCSDate" style="margin-top: 1px;" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Comm Slip Date" onClick="scwShow($('txtCommSlipDate'),this, null);"/>
					</div>
				</td>
				<td class="leftAligned" style="width: 35%">
					<input type="checkbox" id="chkPerilDetail" name="chkPerilDetail" value="N" style="float: left; margin-right: 3px;" tabindex="204"/>
					<label for="chkPerilDetail" style="float: left;">Details</label>
				</td>
			</tr>
	
		</table>
	</div>
	
	<div id="reportGeneratorDiv2" class="sectionDiv" style="text-align: center; margin-top: 5px; margin-bottom: 10px; padding: 5px;">
		<table>
			<tr>
				<td class="rightAligned" style="width=35%;">Destination</td>
				<td class="leftAligned" style="width: 65%">
					<select id="selDestination" style="width: 90%;" tabindex="205">
						<option value="screen">Screen</option>
						<option value="printer">Printer</option>
						<option value="file">File</option>
						<option value="local">Local Printer</option>	
				</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 35%;">Printer</td>
				<td class="leftAligned" style="width: 65%;">
					<select id="selPrinter" style="width: 90%;" tabindex="206">
						<option></option>
						<c:forEach var="p" items="${printers}">
							<option value="${p.name}">${p.name}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 35%;">No of Copies</td>
				<td class="leftAligned" style="width: 65%;">
					<!-- <input type="text" id="noOfCopies" style="width: 60%; text-align: right;" class="integerNoNegativeUnformatted" 
						errorMsg="Entered No. of Person is invalid. Valid value is from 1 to 999" value="1" />
				    <button type="button" class="button" id="spinUpBtn">&uarr;</button>
					<button type="button" class="button" id="spinDownBtn">&darr;</button> -->	
				 	<input type="text" id="txtNoOfCopies" maxlength="3" style="float: left; text-align: right; width: 79.8%;" class="required integerNoNegativeUnformattedNoComma" tabindex="207">
					<div style="float: left; width: 9%;">
						<img id="imgSpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; cursor: pointer;">
						<img id="imgSpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; display: none;">
						<img id="imgSpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;">
						<img id="imgSpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;">
					</div>
				</td>
			</tr>
		</table>
	</div>
</div>

<div id="buttonsDiv" style="text-align: center;">
	<input type="button" class="button" id="btnPrint" value="Print"/>
	<input type="button" class="button" id="btnReturn" value="Return"/>
</div>

<script type="text/javascript">
	//insertPrinterNames();
	var prnMap = eval((('(' + '${commMap}' + ')').replace(/&#62;/g, ">")).replace(/&#60;/g, "<"));

	var commPrinted = '${commPrinted}';
	var mesg = ((prnMap.mesg == null || prnMap.mesg == "") ? "Y" : prnMap.mesg);
	var commSlipNo = "";
	var commSlipPref = "";
	var commSlipDate = "";
	var intmNo = "";

	$("txtCommSlipPref").value = prnMap.commSlipPref;
	$("txtCommSlipNo").value = formatNumberDigits(prnMap.commSlipNo, 12);
	$("txtCommSlipDate").value = dateFormat(new Date(), "mm-dd-yyyy");

	if(mesg != "Y") {
		showMessageBox(mesg);
		Modalbox.hide();
	}

	toggleByDest();

	function toggleByDest() {	
		if($F("selDestination") == "printer"){			
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

	$("selDestination").observe("change", toggleByDest);
	
	$("imgSpinUp").observe("click", function(){
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if(no < 100){
			$("txtNoOfCopies").value = no + 1;
		}else{
			showMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "E");
			$("txtNoOfCopies").value = "";
		}
	});
	
	$("imgSpinDown").observe("click", function(){
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if(no > 1){
			$("txtNoOfCopies").value = no - 1;
		}else{
			showMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "E");
			$("txtNoOfCopies").value = "";
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
	
	/* $("spinUpBtn").observe("click", function() {spinner(1);});
	$("spinDownBtn").observe("click", function() {spinner(-1);});

	$("noOfCopies").observe("blur", function() {
		var nCopy = parseInt($F("noOfCopies"));
		if(isNaN(parseInt($F("noOfCopies")))) {
			showMessageBox("Legal characters are 0 - 9 + E.");
			return false;
		} else if(nCopy > 999 || nCopy < 1) {
			showMessageBox("Must be in range 1 to 999.");
			return false;
		}
	});
	
	function spinner(num) {
		var obj=document.getElementById('noOfCopies');
		var objNum = parseInt(obj.value);
		if(num < 0 && objNum == 1) {
			obj.value=objNum;
		} else if(objNum<999) {
			obj.value=parseInt(obj.value)+num;
		}
	} */

	$("txtNoOfCopies").observe("change", function(){
		if((isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") <= 0 || $F("txtNoOfCopies") > 100)){
			showMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "E");
			$("txtNoOfCopies").value = "";
		}
	});
	
	$("btnReturn").observe("click", function() {
		Modalbox.hide();
	});

	$("btnPrint").observe("click", function() {
		prnMap.commSlipDate = $F("txtCommSlipDate");
		
		if(checkAllRequiredFieldsInDiv("reportGeneratorDiv2")){
			if($F("txtCommSlipDate") == "") {
				showMessageBox("Comm Slip Date is required.");
				return false;
			} else {
				printCommSlipNo();
			}
		}
	});
	
	function afterPrintFunc(){
		if(commPrinted != "P") {
			showConfirmBox("Confirm", "Was the commission slip printed successfully?", "Yes", "No", 
					function() {confirmCSPrint("Y");}, 
					function() {confirmCSPrint("N");});
		} else {
			//confirmCSPrint("N"); added setTimeout to delay updating of records - Nica 08.16.2012
			setTimeout(function(){confirmCSPrint("N");}, 3000);
		}
	}
	
	function printCommSlipNo() {
		try {
			commSlipPref = $F("txtCommSlipPref") == "" ? prnMap.commSlipPref : $F("txtCommSlipPref");
			commSlipNo = $F("txtCommSlipNo") == "" ? prnMap.commSlipNo : $F("txtCommSlipNo");
			intmNo = prnMap.intmNo == null ? 0 : prnMap.intmNo;
			commSlipDate = $F("txtCommSlipDate");
			var reportId = $("chkPerilDetail").checked ? "GIACR250A" : "GIACR250";
			
			if(reportId == "GIACR250A"){
				showMessageBox(objCommonMessage.UNAVAILABLE_REPORT, "I");
				return;
			}
			
			var content = contextPath+"/GIACCommSlipController?action=printCommSlip2&gaccTranId="+objACGlobal.gaccTranId
						+"&gaccBranchCd="+objACGlobal.branchCd+"&intmNo="+intmNo+"&noOfCopies="+$F("txtNoOfCopies")
						+"&printerName="+$F("selPrinter")+"&reportId="+reportId+"&commSlipPref="+commSlipPref
						+"&commSlipNo="+commSlipNo+"&commSlipDate="+commSlipDate+"&destination="+$F("selDestination")
						+"&reportTitle=Commission Slip";
			
			if ("screen" == $F("selDestination")) {
				//window.open(content, "name=test", "location=no, toolbar=no, menubar=no, fullscreen=yes");
				showPdfReport(content, "Commission Slip"); // andrew - 12.12.2011
				
				hideNotice("");
				if (!(Object.isUndefined($("reportGeneratorMain")))){
					hideOverlay();
					afterPrintFunc();
				} 
			}else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					parameters : {printerName : $F("selPrinter"),
								  noOfCopies : $F("txtNoOfCopies")},
					onCreate : showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if(checkErrorOnResponse(response)){
							afterPrintFunc();
						}
					}
				});
			}else if("file" == $F("selDestination")){
				new Ajax.Request(content, {
					parameters : {destination : "FILE"},
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							if($("geniisysAppletUtil") == null || $("geniisysAppletUtil").copyFileToLocal == undefined){
								showMessageBox("Local printer applet is not configured properly. Please verify if you have accepted to run the Geniisys Utility Applet and if the java plugin in your browser is enabled.", imgMessage.ERROR);
							} else {
								var message = $("geniisysAppletUtil").copyFileToLocal(response.responseText, "reports");
								if(message.include("SUCCESS")){
									showWaitingMessageBox("Report file generated to " + message.substring(9), "I", afterPrintFunc);	
								} else {
									showMessageBox(message, "E");
								}
							}
						}
					}
				});
			}else if("local" == $F("selDestination")){
				new Ajax.Request(content, {
					parameters : {destination : "LOCAL"},
					onCreate : showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							printToLocalPrinter(response.responseText);
							afterPrintFunc();
						}
					}
				});
			}
		} catch(e) {
			showErrorMessage("printCommSlipNo", e);
		}
	}

	function exitCSPrintModal() {
		Modalbox.hide();
		//nieko Accounting Uploading
		if (objACGlobal.callingForm2 == "GIACS607"){
			new Ajax.Updater("otherModuleDiv", contextPath+ "/GIACCommSlipController?action=showCommSlip", {
				parameters : {
					gaccTranId : objACGlobal.gaccTranId,
					page : 1
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : function() {
					showNotice("Loading OR Preview...");
				},
				onComplete : function() {
					hideNotice("");
					$("otherModuleDiv").show();
					$("processPremAndCommDiv").hide();
				}
			});
		}else{
			showCommSlip();
		}
		//nieko end
	}

	function confirmCSPrint(printSuccess) {
		try {
			new Ajax.Request(contextPath+"/GIACCommSlipController?action=confirmCSPrinting&gaccTranId="+objACGlobal.gaccTranId
					+"&commSlipPref="+commSlipPref+"&commSlipNo="+commSlipNo+"&commSlipDate="+commSlipDate+"&prnSuccess="+printSuccess, {
				method: "POST",
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response) {
					exitCSPrintModal(); //edited by d.alcantara, 11/14/2011, remove condition to exit modal only after print successful
				}
			});
		} catch(e) {	
			showErrorMesg("confirmCSPrint", e);
		}
	}
</script>