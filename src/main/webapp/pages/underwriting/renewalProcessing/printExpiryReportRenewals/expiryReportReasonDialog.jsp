<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="renewalDialogMainDiv" style="width: 99.5%; padding-top: 5px; float: left;" align="center">
	<div class="sectionDiv" style="float: left;" id="renewalDialogFormDiv">
		<div id="renewalDialogMainDiv" width="400" style="padding: 5px;">
			<div style="margin-bottom: 15px; margin-top: 15px;"><b>Choose Reason for Non - Renewal</b></div>
			<table width="91%">
				<tr>
					<td width="5%" height="30px">A.</td>
					<td width="4%"><input type="checkbox" id="chkReason1"/></td>
					<td width="60%" id="reason1">OPTION_1</td>
				</tr>
				<tr>
					<td width="5%" height="30px">B.</td>
					<td width="4%"><input type="checkbox" id="chkReason2"/></td>
					<td width="60%" id="reason2">OPTION_2</td>
				</tr>
				<tr>
					<td width="5%" height="30px">C.</td>
					<td width="4%"><input type="checkbox" id="chkReason3"/></td>
					<td width="60%" id="reason3">OPTION_3</td>
				</tr>
				<tr>
					<td width="5%" height="30px">D.</td>
					<td width="4%"><input type="checkbox" id="chkReason4"/></td>
					<td width="60%" id="reason4">Other:
						<input type="text" id="txtOther" style="width: 85%;"/> 
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div id="buttonsDiv" name="buttonsDiv" style="text-align:center; width: 100%; height: 35px; align: center; float: left;">
		<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="margin-top: 16px;"/>
		<input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel" style="margin-top: 16px;"/>
	</div>
</div>

<script type="text/javascript">
try{
	objGiexs006.dialog = "reason";
	
	if(objGiexs006.lineCd == "FI"){
		$("reason1").innerHTML = "Unfavorable Loss Experience";
		$("reason2").innerHTML = "Risk insured is categorized as a \"Prohibited Risk\"";
		$("reason3").innerHTML = "Risk is situated in an area\/acceptance is already saturated";
	}else{
		$("reason1").innerHTML = "Unfavorable Loss Experience";
		$("reason2").innerHTML = "Vehicle is over 10 years old";
		$("reason3").innerHTML = "Vehicle is considered prohibited";
	}
	
	$("btnCancel").observe("click", function(){
		overlayExpiryReportReasonDialog.close();
	});
	
	$("btnPrint").observe("click", function(){
		setGiexs006Params();
	});
}catch(e){
	showErrorMessage("expiryReportReasonDialog page", e);
}
	
</script>