<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="lastPrintedCVMainDiv" class="sectionDiv" align="center" style="height: 117px; width: 298px; margin: 5px 0 0 0;">
	<table style="margin: 17px 0 5px 0;">
		<tr>
			<td colspan="2"><label>Indicate the last successfully printed CV</label></td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<input style="width: 131px; height: 13px;" id="lastCVNo" name="lastCVNo" class="integerNoNegativeUnformatted" type="text" tabindex="301" maxlength="10"/>
			</td>
		</tr>
		<tr align="center">
			<td colspan="2">
				<input type="button" id="btnOkCV" name="btnOkCV" class="button" value="Ok" tabindex="302">
				<input type="button" id="btnCancelCV" name="btnCancelCV" class="button" value="Cancel" tabindex="303">
			</td>
		</tr>
	</table>	
</div>

<script type="text/javascript">	
	function processLastCVNo(){
		var startCVNo = $F("cvSeqNo");
		if($F("lastCVNo") == ""){
			closeLastCVOverlay();
		}else{
			if($F("lastCVNo") >= startCVNo){
				if($F("lastCVNo") <= objGIACS251.maxCVNo){
					updatePrintedCVs();
				}else{
					showWaitingMessageBox("Please enter a valid CV number.", "I", function(){
						$("lastCVNo").value = "";
						$("lastCVNo").focus();
					});
				}
			}else{
				showWaitingMessageBox("Please enter a valid CV number.", "I", function(){
					$("lastCVNo").value = "";
					$("lastCVNo").focus();
				});
			}
		}
	}
	
	function updatePrintedCVs(){
		var rows = objGIACS251.taggedCommDueList;
		for (var i=0; i<rows.length; i++){
			if (rows[i].cvNo <= $F("lastCVNo")){
				rows.splice(i, 1);
			}
		}
		
		objGIACS251.updateCommDueTags(rows, true);	
		closeLastCVOverlay();
	}
	
	function closeLastCVOverlay(){
		lastCVNoOverlay.close();
		delete lastCVNoOverlay;
	}
	
	$("btnOkCV").observe("click", function(){
		processLastCVNo();
	});
	
	$("btnCancelCV").observe("click", function(){
		closeLastCVOverlay();
	});
	
	initializeAll();
	$("lastCVNo").focus();
	
	$("lastCVNo").observe("change", function(){
		fireEvent($("btnOkCV"), "click");	
	});
	
</script>