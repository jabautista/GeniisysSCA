<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="hiddenDiv">
	<input type="hidden" id="printerNames" value="${printerNames}" />
</div>
<div id="printCNCMainDiv" class="sectionDiv" style="text-align: center;">
	<table style="margin-top: 10px; margin-bottom:10px; width: 100%;">
		<tr>
			<td class="rightAligned" style="width: 35%;">Destination</td>
			<td class="leftAligned" style="width: 65%;">
				<select id="reportDestination" style="width: 60%;">
					<option value="SCREEN">SCREEN</option>
					<option value="PRINTER">PRINTER</option>
					<option value="FILE">FILE</option>
					<option value="LOCAL">LOCAL PRINTER</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 35%;">Printer Name</td>
			<td class="leftAligned" style="width: 65%;">
				<select id="printerName" style="width: 60%;">
					<option value=""></option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 35%;">No of Copies</td>
			<td class="leftAligned" style="width: 65%;">
				<input type="text" id="noOfCopies" style="width: 51.5%; text-align: right; float: left;" class="integerNoNegativeUnformatted" 
					errorMsg="Entered No. of Copies is invalid." value="1" />
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
<c:if test="${reportVersion eq 'CPI'}">
	<div  class="sectionDiv">
		<br>
			<input type="checkbox" id="chk1" name="chk1" tabindex="1"  value="" style="margin-left: 20px;"/> <label for="chk1" style="float: none;">is insured with us against CTPL/BI only</label></br>
			<input type="checkbox" id="chk2" name="chk2" tabindex="2"  value="" style="margin-left: 20px;"/> <label for="chk2" style="float: none;">was not involved in any accident</label></br>
			<input type="checkbox" id="chk3" name="chk3" tabindex="3"  value="" style="margin-left: 20px;"/> <label for="chk3" style="float: none;">was involved in an accident but wishes to claim against the adverse party</label></br>
			<input type="checkbox" id="chk4" name="chk4" tabindex="4"  value="" style="margin-left: 20px;"/> <label for="chk4" style="float: none;">did not file a claim with us in connection with an accident</label></br>
		<br>
	</div>
</c:if>
<div id="buttonsDiv" style="text-align: center;">
	<input type="button" class="button" id="btnPrint" value="Print" style="width: 80px; margin-top: 10px;" />
	<input type="button" class="button" id="btnCancel" value="Cancel" style="width: 80px; margin-top: 10px;" />
</div>
<script>
	initializeAll();
	insertPrinterNames();
	toggleDest();
	
	$("printerName").disable();
	$("noOfCopies").disable();
	
	function populateGICLR062(){
		try {
			objCLM.noClaims.noClaimNo = $F('hidNoClaimNo');
			var content = contextPath+"/PrintNoClaimCertificateController?action=populateGICLR062&noClaimId="+$F('hidNoClaimNo')+"&noClaimNo="+objCLM.noClaims.noClaimNo+"&policyId="+object.policyId;	
			if ("SCREEN" == $F("reportDestination")) {
				showPdfReport(content, "CNC - "+objCLM.noClaims.noClaimNo);				
				hideNotice("");
			} else if ("PRINTER" == $F("reportDestination")) {
				new Ajax.Request(content, {
					method: "POST",
					parameters : {noOfCopies : $F("noOfCopies"),
								  printerName : $F("printerName"),
								  },
								  
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							
						}
					}
				});
			} else  if("FILE" == $F("reportDestination")){
				new Ajax.Request(content, {
					method: "POST",
					parameters : {destination : "FILE"},
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							copyFileToLocal(response);
						}
					}
				});
			}else if("LOCAL" == $F("reportDestination")){
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
		} catch(e){
			showErrorMessage("populateGICLR062", e);
		}
	}
	
	
	
	function validateBeforePrint(){
		var result = true;
		if (($("printerName").selectedIndex == 0) && ($("reportDestination").value == "PRINTER")){
			result = false;
			customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "printerName");
		} else if (($("noOfCopies").value == 0) && ($("reportDestination").value == "PRINTER")){
			result = false;
			customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "noOfCopies");
		}
		new Ajax.Request(contextPath+"/GICLNoClaimController?action=getGICLR062Desname&reportId="+objCLM.noClaims.reportId, {
			evalScripts: true,
			asynchronous: false,
			method: "GET",
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					var desname = response.responseText;
					if(desname != ""){
						
					}else{
						result = false;
						showMessageBox("No data found in GIIS_REPORTS.", "I");
					}
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
		return result;
	}
	
	function spinner(num) {
		var obj=document.getElementById('noOfCopies');
		var objNum = parseInt(obj.value);
		if(num < 0 && objNum == 1) {
		} else {
			obj.value=parseInt(obj.value)+num;
		}
	}
	
	function toggleDest(){
		if ($F("reportDestination") == "PRINTER"){
			$("printerName").enable();
			$("noOfCopies").enable();
			$("noOfCopies").value = "1";
			$("printerName").addClassName("required");
			$("noOfCopies").addClassName("required");
			$("imgSpinUp").show();
			$("imgSpinDown").show();
			$("imgSpinUpDisabled").hide();
			$("imgSpinDownDisabled").hide();
		} else {
			$("printerName").removeClassName("required");
			$("noOfCopies").removeClassName("required");
			$("printerName").selectedIndex = 0;
			$("printerName").value = "";
			$("noOfCopies").value = "";
			$("printerName").disable();
			$("noOfCopies").disable();	
			$("imgSpinUp").hide();
			$("imgSpinDown").hide();
			$("imgSpinUpDisabled").show();
			$("imgSpinDownDisabled").show();	
		}
	}
	
	$("reportDestination").observe("change", function(){
		 toggleDest();
	});
	
	$("btnPrint").observe("click", function(){
		if (validateBeforePrint()){
			if(objCLM.noClaims.version == "RSIC" || objCLM.noClaims.versionB == "RSIC"){
				populateGICLR062();				
			}else{				
				populateGICLR062();
				}
			
		}
	});
	
    $("imgSpinUp").observe("click", function() {spinner(1);});
	$("imgSpinDown").observe("click", function() {spinner(-1);});
	
	$("btnCancel").observe("click", function (){
		Modalbox.hide();
	});
</script>