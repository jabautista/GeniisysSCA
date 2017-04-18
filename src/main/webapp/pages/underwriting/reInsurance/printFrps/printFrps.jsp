<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="printDialogMainDiv" style="width: 99.5%; padding-top: 5px; float: left;" align="center">
	<div class="sectionDiv" style="float: left;" id="printDialogFormDiv">
		<table align="center" style="padding: 10px;">
			<tr>
				<td class="rightAligned">Destination</td>
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
				<%-- <td class="rightAligned">Printer</td>
				<td class="leftAligned">
					<select id="selPrinter" style="width: 200px;" class="required">
						<option></option>
						<c:forEach var="p" items="${printers}">
							<option id="selectedPrinter" value="${p.printerNo}">${p.printerName}</option>
							<option id="selectedPrinter" value="${p.printerName}">${p.printerName}</option>
						</c:forEach>
					</select>
				</td> --%>
				<td class="rightAligned">Printer</td>
				<td class="leftAligned">
					<select id="selPrinter" style="width: 200px;" class="required" tabindex="308">
						<option></option>
						<c:forEach var="p" items="${printers}">
							<option value="${p.name}">${p.name}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">No. of Copies</td>
				<td class="leftAligned">
					<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 175px;" class="required wholeNumber">
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
	<div id="chkbxDiv">
		<div style="float: left; margin-left: 80px; margin-top: 3px;">
			<label>
			 	<div><input type="checkbox" id="chkPrintReinsurance" style="float: left; margin-top: 3px;" title="Print Reinsurance Agreement Bond"></div>
				<div style="margin-top: 2px; width: 250px;" title="Print Reinsurance Agreement Bond">Print Reinsurance Agreement Bond</div>
			</label>
		</div>
	</div>
	<div id="buttonsDiv" style="float: left; width: 100%; margin-top: 10px; margin-bottom: 5px;">
		<!-- <input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="width: 80px;"> replaced by robert SR 4961 09.16.15--> 
		<input type="button" class="button" id="btnPrintBinders" name="btnPrintBinders" value="Print" style="width: 80px;"> <!-- added by robert SR 4961 09.16.15 -->
		<input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel">		
	</div>
</div>
<script type="text/javascript">

	initializeAll();
	$("chkbxDiv").hide();
	
	if(objUW.wdistFrpsVDtls.lineCd == 'SU'){
		$("chkbxDiv").show();
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
			$("selPrinter").removeClassName("required");
			$("txtNoOfCopies").removeClassName("required");
			$("selPrinter").disabled = true;
			$("txtNoOfCopies").disabled = true;
			$("imgSpinUp").hide();
			$("imgSpinDown").hide();
			$("imgSpinUpDisabled").show();
			$("imgSpinDownDisabled").show();			
		}
	}

	$("btnCancel").observe("click", function(){
		overlayGenericPrintDialog.close();
		//printCancel();
	});
	
	function printCancel() {
		if (nvl(objRiFrps.lineCd,null) == null && nvl(objRiFrps.lineName,null) == null){	
			getLineListingForFRPS();
		}else{
			updateMainContentsDiv("/GIRIDistFrpsController?action=showFrpsListing&ajax=1&lineCd="+objRiFrps.lineCd+"&lineName="+objRiFrps.lineName,
			  "Getting FRPS listing, please wait...");
		}
	}
	
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
	
	var chkPrintRI = 'N';
	
	$("chkPrintReinsurance").observe("change", function(){
		chkPrintRI = $("chkPrintReinsurance").checked ? 'Y' : 'N';
		
		if($("chkPrintReinsurance").checked){
			showRIAgreementBondDialog("Reinsurance Signatory");
		}
	});
	
	var reports = [];
	//var rabReports = []; //removed by robert SR 20437 09.30.15
	/* $("btnPrint").observe("click", function(){ replaced by robert SR 4961 09.16.15*/
	$("btnPrintBinders").observe("click", function(){ // added by robert SR 4961 09.16.15
		if(validatePrint()){
			//if((chkPrintRI == 'Y') && (objUW.wdistFrpsVDtls.lineCd == 'SU')){ // bonok :: 10.17.2103
			if(objUW.printRab == "Y"){
			//if((chkPrintRI == 'Y')){
				//chkPrintRI = 'N';
				//$("chkPrintReinsurance").checked = false;
				//showRIAgreementBondDialog("Reinsurance Signatory"); // bonok :: 10.17.2103
				getPrintFrps();
				
				/* moved to getPrintFrps function by robert SR 20437 09.30.15
				 if($("chkPrintReinsurance").checked){
						for(var i=0; i<objUW.fnlBinderIdArr.length; i++){
							printFrpsRab(objUW.fnlBinderIdArr[i]);
						}
						if ("screen" == $F("selDestination")) {
							showMultiPdfReport(rabReports);
							rabReports = [];
						}
					} */
			}else{
				getPrintFrps();
			}
		}
	});
	
	toggleRequiredFields("screen");
	
	function validatePrint(){
		var result = true;
		if(($("selPrinter").selectedIndex == 0) && ($("selDestination").value == "printer")){
			result = false;
			$("selPrinter").focus();
			showMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR);
		}else if(($("txtNoOfCopies").value == "") && ($("selDestination").value == "printer")){
			result = false;
			$("txtNoOfCopies").focus();
			showMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR);
		}
		return result;
	}
	
	function getPrintFrps(){
		var content = contextPath+"/GIRIWFrpsRiController?action=getPrintFrps&distNo="+objUW.wdistFrpsVDtls.distNo;
		new Ajax.Request(content, {
				method: "GET",
				parameters : {noOfCopies : $F("txtNoOfCopies"),
						 	 printerName : $("selPrinter").value},
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						obj = JSON.parse(response.responseText);
						for(var i=0; i<obj.length; i++){
							printFrps(obj[i].lineCd, obj[i].binderYy, obj[i].binderSeqNo, obj[i].fnlBinderId);	
						}
						if($("chkPrintReinsurance").checked){ //added by robert SR 20437 09.30.15
							for(var i=0; i<objUW.fnlBinderIdArr.length; i++){
								printFrpsRab(objUW.fnlBinderIdArr[i]);
							}
						}
						if ("screen" == $F("selDestination")) {
							showMultiPdfReport(reports);
							reports = [];
							overlayGenericPrintDialog.close();
						}
					}
				}
			});
	}

	function printFrps(lineCd, binderYy, binderSeqNo, fnlBinderId){
		var content = contextPath+"/ReinsuranceAcceptanceController?action=doPrintFrps&lineCd="+lineCd+"&binderYy="+binderYy+"&binderSeqNo="+binderSeqNo+"&fnlBinderId="+fnlBinderId;
			if($F("selDestination") == "screen"){
				reports.push({reportUrl : content, reportTitle : "GIRIR001_MAIN"+"_"+lineCd+"-"+binderYy+"-"+binderSeqNo});
				/* showPdfReport(content, "Reinsurance Agreement");*/
			} else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					method: "GET",
					parameters : {noOfCopies : $F("txtNoOfCopies"),
							 	 printerName : $("selPrinter").value},
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						if (checkErrorOnResponse(response)){
							showMessageBox("Printing complete.", "S");
							overlayGenericPrintDialog.close();
						}
					}
				});
			} else if("file" == $F("selDestination")){
				new Ajax.Request(content, {
					method: "POST",
					parameters: {destination : "file"},
					evalScripts: true,
					asynchronous: true,
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if(checkErrorOnResponse(response)){
							copyFileToLocal(response);
							overlayGenericPrintDialog.close();
						}
					}
				});
			} else if("local" == $F("selDestination")){
				new Ajax.Request(content, {
					method: "POST",
					parameters : {destination : "local"},
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							var message = printToLocalPrinter(response.responseText);
							if(message != "SUCCESS"){
								showMessageBox(message, imgMessage.ERROR);
							}
							overlayGenericPrintDialog.close();
						}
					}
				});
			}
	}
	
	function showRIAgreementBondDialog(title){
		overlayRIAgreementBondDialog = Overlay.show(contextPath+"/GIRIBinderController", {
			urlContent : true,
			urlParameters: {action : "getRiAgreementBond"},
		    title: title,
		    height: 153,
		    width: 480,
		    draggable: true
		});
	}
	
	function printFrpsRab(fnlBinderId){
		var content = contextPath+"/ReinsuranceAcceptanceController?action=doRiAgreementBond&fnlBinderId="+fnlBinderId+"&riAgrmntBndName="+encodeURIComponent(objUW.riAgrmntBndName)+"&riAgrmntBndDesignation="+encodeURIComponent(objUW.riAgrmntBndDesignation)+"&riAgrmntBndAttest="+encodeURIComponent(objUW.riAgrmntBndAttest);
		if($F("selDestination") == "screen"){
			//rabReports.push({reportUrl : content, reportTitle : "Reinsurance Agreement"}); //replaced by robert SR 20437 09.30.15
			reports.push({reportUrl : content, reportTitle : "Reinsurance Agreement"}); //changed from rabReports to reports 
			//showPdfReport(content, "Reinsurance");
		} else if($F("selDestination") == "printer"){
			new Ajax.Request(content, {
				method: "GET",
				parameters : {
							 noOfCopies : $F("txtNoOfCopies"),
						 	 printerName : $("selPrinter").value
				             },
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						hideNotice();
					}
				}
			});
		} else if("file" == $F("selDestination")){
			new Ajax.Request(content, {
				method: "POST",
				parameters: {destination : "file"},
				evalScripts: true,
				asynchronous: true,
				onCreate: showNotice("Generating report, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						copyFileToLocal(response);
					}
				}
			});
		} else if("local" == $F("selDestination")){
			new Ajax.Request(content, {
				method: "POST",
				parameters : {destination : "local"},
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
	}
</script>