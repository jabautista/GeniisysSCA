<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="lastPrintedCommSlipMainDiv" class="sectionDiv" align="center" style="height: 117px; width: 298px; margin: 5px 0 0 0;">
	<table style="margin: 17px 0 5px 0;">
		<tr>
			<td colspan="2"><label>Indicate the last successfully printed commission slip</label></td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<input style="width: 131px; height: 13px; text-align: right;" id="lastSlipNo" name="lastSlipNo" class="integerNoNegativeUnformatted" type="text" tabindex="301" maxlength="10"/>
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

	$("btnCancel").observe("click", function(){
		//closeLastNoOverlay();
	});
	
	initializeAll();
	$("lastORNo").focus();
</script>