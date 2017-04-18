<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="lastPrintedCheckMainDiv" class="sectionDiv" align="center" style="height: 117px; width: 298px; margin: 5px 0 0 0;">
	<table style="margin: 17px 0 5px 0;">
		<tr>
			<td colspan="2"><label>Indicate the last printed OR Number</label></td> <!-- change by steven 08.08.2014; before:"Indicate the last successfully printed OR" -->
		</tr>
		<tr>
			<td colspan="2" align="center">
				<input style="width: 131px; height: 13px; text-align: right;" id="lastORNo" name="lastORNo" class="integerNoNegativeUnformatted" type="text" tabindex="301" maxlength="10"/>
			</td>
		</tr>
		<tr align="center">
			<td colspan="2">
				<input type="button" id="btnOk" name="btnOk" class="button" value="Ok" tabindex="302" style="margin-top: 10px;">
				<input type="button" id="btnCancel" name="btnCancel" class="button" value="Cancel" tabindex="303">
			</td>
		</tr>
	</table>	
</div>

<script type="text/javascript">
	function checkLastPrintedOR(){
		new Ajax.Request(contextPath+"/GIACOrderOfPaymentController", {
			parameters: {
				action: "checkLastPrintedOR",
				lastOrNo: $F("lastORNo"),
				lastOrPrinted: $F("lastPrintedOR"),
				orType: $("vatOr").checked ? "V" : $("nonVatOr").checked ? "N" : "M"
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					var orNumbers = response.responseText;
					if(nvl(orNumbers, "") != ""){
						showConfirmBox("Confirmation", "The following OR Number(s): " + orNumbers + "will be spoiled.", "Yes", "No",
							spoilBatchOr,
							function(){
								$("lastORNo").value = "";
								$("lastORNo").focus();
							});
					}else{
						spoilBatchOr();
					}
				}
			}
		});
	}
	
	function spoilBatchOr(){
		new Ajax.Request(contextPath+"/GIACOrderOfPaymentController", {
			method: "POST",
			parameters: {
				action: "spoilBatchOR",
				lastOrNo: $F("lastORNo"),
				orType: $("vatOr").checked ? "V" : $("nonVatOr").checked ? "N" : "M",
				fundCd: $F("fundCd"),
				branchCd: $F("branchCd")
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					if($F("lastORNo") == ""){
						objBatchOR.generatedOR = false;
					}
					
					lastORNoOverlay.close();
					delete lastORNoOverlay;
					showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function(){
						batchORTG._refreshList();
						objBatchOR.getDefaultOrValues();
					});
				}
			}
		});
	}

	function closeLastORNoOverlay(){
		lastORNoOverlay.close();
		delete lastORNoOverlay;
		
		showConfirmBox("Validate Printing", "Were all the O.R.s successfully printed?", "Yes", "No",
				objBatchOR.processPrintedOR, objBatchOR.showLastORNoOverlay, "1");
	}
	
	$("btnOk").observe("click", function(){
		checkLastPrintedOR();
	});
	
	$("btnCancel").observe("click", function(){
		closeLastORNoOverlay();
	});
	
	initializeAll();
	$("lastORNo").focus();
</script>