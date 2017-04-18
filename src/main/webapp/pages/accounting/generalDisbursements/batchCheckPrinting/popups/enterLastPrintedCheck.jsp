<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="lastPrintedCheckMainDiv" class="sectionDiv" align="center" style="height: 117px; width: 298px; margin: 5px 0 0 0;">
	<table style="margin: 17px 0 5px 0;">
		<tr>
			<td colspan="2"><label>Indicate the last successfully printed check</label></td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<input style="width: 131px; height: 13px;" id="lastCheckNo" name="lastCheckNo" class="integerNoNegativeUnformatted" type="text" tabindex="301" maxlength="10"/>
			</td>
		</tr>
		<tr align="center">
			<td colspan="2">
				<input type="button" id="btnOkCheck" name="btnOkCheck" class="button" value="Ok" tabindex="302">
				<input type="button" id="btnCancelCheck" name="btnCancelCheck" class="button" value="Cancel" tabindex="303">
			</td>
		</tr>
	</table>	
</div>

<script type="text/javascript">
	function processLastCheckNo(){
		var startCheckNo =$F("checkSeqNo");
		objChkBatch.lastCheckNo = $F("lastCheckNo");
		
		if(objChkBatch.lastCheckNo == ""){
			closeLastCheckOverlay();
		}else{
			if(objChkBatch.lastCheckNo >= startCheckNo){
				if(objChkBatch.lastCheckNo <= objChkBatch.maxCheckNo){
					updatePrintedChecks();
				}else{
					showWaitingMessageBox("Please enter a valid check number.", "I", function(){
						$("lastCheckNo").value = "";
						$("lastCheckNo").focus();
					});
				}
			}else{
				showWaitingMessageBox("Please enter a valid check number.", "I", function(){
					$("lastCheckNo").value = "";
					$("lastCheckNo").focus();
				});
			}
		}
	}
	
	function updatePrintedChecks(){
		//var rows = objChkBatch.rows.filter(function(obj){return nvl(obj.checkNumber, "") != "" && nvl(obj.batchTag, "N") != "Y";});
		var rows = objGIACS054.tempTaggedRecords.filter(function(obj){return nvl(obj.checkNumber, "") != "" && nvl(obj.batchTag, "N") != "Y";});
		
		new Ajax.Request(contextPath+"/GIACChkDisbursementController", {
			method: "POST",
			parameters: {
				action: "updatePrintedChecks",
				parameters: prepareJsonAsParameter(rows),
				lastCheckNo: $F("lastCheckNo"),
				checkPref: $F("chkPrefix"),
				fundCd: $F("fundCd"),
				branchCd: $F("branchCd"),
				bankCd: $F("bankCd"),
				bankAcctCd: $F("bankAcctCd"),
				checkDvPrint:	objChkBatch.checkDvPrint
			},
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					objChkBatch.updateBatchTags(false);
					objChkBatch.getCheckSeqNo();
					closeLastCheckOverlay();
				}
			}
		});
	}
	
	function closeLastCheckOverlay(){
		lastCheckNoOverlay.close();
		delete lastCheckNoOverlay;
		$("checkSeqNo").value = objChkBatch.lastCheckNo;
		objChkBatch.toggleOnPrint(true, true, true);
	}
	
	$("btnOkCheck").observe("click", function(){
		processLastCheckNo();
	});
	
	$("btnCancelCheck").observe("click", function(){
		closeLastCheckOverlay();
	});
	
	initializeAll();
	$("lastCheckNo").focus();
</script>