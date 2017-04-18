<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="printDialogMainDiv" style="width: 99.5%; padding-top: 5px; float: left;" align="center">
	<div class="sectionDiv" style="float: left;" id="printDialogFormDiv">
		<!-- <label style="padding-top: 5px; padding-left: 5px;">Reinsurer Signatory</label> -->
		<table align="center" style="padding: 10px;">
			<tr>
				<td class="rightAligned" style="padding-right: 5px;">Name</td>
				<td class="leftAligned">
					<input type="text" id="txtRiAgrmntBndName" style="width: 250px;" maxlength="50">
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 5px;">Designation</td>
				<td class="leftAligned">
					<input type="text" id="txtRiAgrmntBndDesignation" style="width: 250px;" maxlength="50">
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 5px;">Attest</td>
				<td class="leftAligned">
					<input type="text" id="txtRiAgrmntBndAttest" style="width: 250px;" maxlength="50">			
				</td>
			</tr>
		</table>
	</div>
	<div id="buttonsDiv" style="float: left; width: 100%; margin-top: 5px; margin-bottom: 5px;">
		<input type="button" class="button" id="btnOk" name="btnOk" value="Ok" style="width: 80px;">
		<input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel">		
	</div>
</div>

<script type="text/javascript">
	
	var reports = [];
	
	$("btnCancel").observe("click", function(){
		overlayRIAgreementBondDialog.close();
	});
	
	$("btnOk").observe("click", function(){
		getPrintFrpsRab();
		overlayRIAgreementBondDialog.close();
	});
	
	function getPrintFrpsRab(){
		/* var riAgrmntBndName = $F("txtRiAgrmntBndName");
		var riAgrmntBndDesignation = $F("txtRiAgrmntBndDesignation");
		var riAgrmntBndAttest = $F("txtRiAgrmntBndAttest"); */
		
		// bonok :: 10.17.2013 :: SR473 - GENQA
		objUW.riAgrmntBndName = $F("txtRiAgrmntBndName");
		objUW.riAgrmntBndDesignation = $F("txtRiAgrmntBndDesignation");
		objUW.riAgrmntBndAttest = $F("txtRiAgrmntBndAttest");
		
		var content = contextPath+"/GIRIWFrpsRiController?action=getRiAgreementBond&lineCd=" + objUW.wdistFrpsVDtls.lineCd+"&frpsYy="+objUW.wdistFrpsVDtls.frpsYy+"&frpsSeqNo="+objUW.wdistFrpsVDtls.frpsSeqNo;
		//var content = contextPath+"/GIRIWFrpsRiController?action=getRiAgreementBond&lineCd=" +"SU"+"&frpsYy="+13+"&frpsSeqNo="+31;
		new Ajax.Request(content, {
			method: "GET",
			parameters : {noOfCopies : $F("txtNoOfCopies"),
					 	 printerName : $("selPrinter").value},
			evalScripts: true,
			asynchronous: true,
			onComplete: function(response){
				if (checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					/* for(var i=0; i<obj.length; i++){
						var fnlBinderId = obj[i];
						printFrpsRab(fnlBinderId, riAgrmntBndName, riAgrmntBndDesignation, riAgrmntBndAttest);
					} */ // bonok :: 10.17.2013 :: SR473 - GENQA
					objUW.fnlBinderIdArr = obj; // bonok :: 10.17.2013 :: SR473 - GENQA
					objUW.printRab = "Y"; // bonok :: 10.17.2013 :: SR473 - GENQA
					/* if ("screen" == $F("selDestination")) {
						showMultiPdfReport(reports);
						reports = [];
					} */ // bonok :: 10.17.2013 :: SR473 - GENQA
				}
			}
		});
	}
	
	function printFrpsRab(fnlBinderId, riAgrmntBndName, riAgrmntBndDesignation, riAgrmntBndAttest){
		var content = contextPath+"/ReinsuranceAcceptanceController?action=doRiAgreementBond&fnlBinderId="+fnlBinderId+"&riAgrmntBndName="+encodeURIComponent(riAgrmntBndName)+"&riAgrmntBndDesignation="+encodeURIComponent(riAgrmntBndDesignation)+"&riAgrmntBndAttest="+encodeURIComponent(riAgrmntBndAttest);
			if($F("selDestination") == "screen"){
				reports.push({reportUrl : content, reportTitle : "Reinsurance Agreement"});
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
							showMessageBox("Printing complete.", "S");
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