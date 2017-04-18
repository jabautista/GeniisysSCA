<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="batchCsrDetailDiv" name="batchCsrDetailDiv">
	<div id="batchCsrDiv" name="batchCsrDiv" class="sectionDiv" style="border-left: none; border-right: none; border-bottom: none;">
		<jsp:include page="/pages/claims/batchCsr/batchDetailHeader.jsp"></jsp:include>
		<div id="giclAdviceListTableGridDiv" name="giclAdviceListTableGridDiv" style="margin: 20px; height: 220px;" changeTagAttr="true">
		</div>
		<div align="center">
			<table>
				<tr>
					<td class="rightAligned">User Id</td>
					<td class="leftAligned">
						<input type="text" id="userId" name="userId" readonly="readonly" style="width: 100px;"/>
					</td>
					<td class="rightAligned" style="width: 100px;">Last Update</td>
					<td class="leftAligned">
						<input type="text" id="lastUpdate" name="lastUpdate" readonly="readonly" style="width: 150px;"/>
					</td>
					<td>
						<input type="button" class="button" id="btnAcctngEntries" name="btnAcctngEntries" style="background:url(images/misc/masterDetail.png); background-repeat:no-repeat; width: 32px; height: 32px; margin-left: 10px;">
					</td>
				</tr>
			</table>
		</div>
		<div id="batchCsrButtonsDiv" name="batchCsrButtonsDiv" align="center" style="margin: 10px; padding-bottom: 40px;">
			<input type="button" class="button" style="width: 100px;" id="btnGenerateBatch" name="btnGenerateBatch" 	value="Generate Batch"/>
			<input type="button" class="button" style="width: 100px;" id="btnCancelBatch" 	name="btnCancelBatch" 		value="Cancel Batch"/>
			<input type="button" class="button" style="width: 100px;" id="btnApproveBatch" 	name="btnApproveBatch" 		value="Approve Batch"/>
			<input type="button" class="button" style="width: 100px;" id="btnPrintBCSR" 	name="btnPrintBCSR" 		value="Print BSCR"/>
			<input type="button" class="button" style="width: 100px;" id="btnSave" 			name="btnSave" 				value="Save"/>
			<input type="button" class="button" style="width: 100px;" id="btnReturn" 		name="btnReturn" 			value="Return"/>
		</div>
	</div>
</div>

<script type="text/javascript">
</script>