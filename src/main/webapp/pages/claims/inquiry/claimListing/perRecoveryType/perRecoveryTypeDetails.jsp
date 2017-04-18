<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="perRecoveryTypeDtailsMainDiv" style="width: 99.5%; padding-top: 5px;">
	<div class="sectionDiv" style="padding: 5px; width: 99%;">
		<div id="recoveryDetailsDiv">
			<table align="center">
				<tr>
					<td class="rightAligned" style="width: 120px;padding-right: 5px;">Recovery No. </td>
					<td class="rightAligned"><input style="width: 235px;" id="txtDspRecoveryNo" name="txtDspRecoveryNo" type="text" readOnly="readonly"/></td>
					<td style="width: 5px;"></td>
					<td class="rightAligned" style="width: 110px;padding-right: 5px;">Lawyer</td>
					<td class="rightAligned"><input style="width: 50px;" id="txtLawyerCd" name="txtLawyerCd" type="text" readOnly="readonly"/></td>
					<td class="rightAligned"><input style="width: 180px;" id="txtDspLawyerName" name="txtDspLawyerName" type="text" readOnly="readonly"/></td>
				</tr>
				<tr>										
					<td class="rightAligned" style="padding-right: 5px;">Recoverable Amount</td>
					<td class="rightAligned"><input style="width: 235px;" id="txtRecoverableAmt" name="txtRecoverableAmt" type="text" readOnly="readonly"/></td>
					<td></td>
					<td class="rightAligned" style="padding-right: 5px;">Third Party Item<br>Description</td>
					<td class="rightAligned" rowspan="2" colspan="2"><input style="width: 240px; height: 45px;" id="txtThirdPartyDesc" name="txtThirdPartyDesc" type="text" readOnly="readonly"/></td>			
				</tr>
				<tr>
					<td class="rightAligned" style="padding-right: 5px;">Recovered Amount</td>
					<td class="rightAligned"><input style="width: 235px;" id="txtRecoveredAmt" name="txtRecoveredAmt" type="text" readOnly="readonly"/></td>	
				</tr>
			</table>
		</div>
	</div>	
	<div class="sectionDiv" style="padding: 5px; width: 99%;">
		<div id="payorDetailsDiv">
			<table align="center">
				<tr>
					<td class="rightAligned" style="width: 120px;padding-right: 5px;">Payor Class</td>
					<td class="rightAligned"><input style="width: 50px;" id="txtPayorClass" name="txtPayorClass" type="text" readOnly="readonly"/></td>
					<td class="rightAligned"><input style="width: 185px;" id="txtPayorClassDesc" name="txtPayorClassDesc" type="text" readOnly="readonly"/></td>
					<td style="width: 5px;"></td>
					<td class="rightAligned" style="width: 110px;padding-right: 5px;">Recovered Amount</td>
					<td class="rightAligned"><input style="width: 235px;" id="txtPayorRecoveredAmt" name="txtPayorRecoveredAmt" type="text" readOnly="readonly"/></td>
				</tr>
				<tr>										
				<tr>
					<td class="rightAligned" style="padding-right: 5px;">Payor</td>
					<td><input style="width: 50px;" id="txtDspPolicyNo" name="txtPayorCd" type="text" readOnly="txtPayorCd"/></td>	
					<td class="rightAligned" colspan="4"><input style="width: 554px;" id="txtPayorName" name="txtPayorName" type="text" readOnly="readonly"/></td>	
				</tr>
			</table>
		</div>
	</div>
	<div class="sectionDiv" style="padding: 5px; width: 99%;">
		<div id="recoveryHistoryTableDiv" style="padding: 10px 0 10px 10px;">
			<div id="recoveryHistoryTable" style="height: 160px"></div>
		</div>
		<div align="center">		
			<input type="button" class="button" id="btnReturn" name="btnReturn" value="Return" style="width: 100px; margin-bottom: 5px;">		
		</div>
	</div>
</div>
<script type="text/javascript">
	recoveryHistoryTableModel = {
			url : contextPath+"/GICLClaimListingInquiryController?action=showPerRecoveryTypeDetails&refresh=1",
			options: {
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				},
				width: '725px',
				pager: {
				},
				onCellFocus : function(element, value, x, y, id) {
				},
				prePager: function(){
				},
				onRemoveRowFocus : function(element, value, x, y, id){					
				},
				onSort : function(){
				},
				onRefresh : function(){
				}	
			},									
			columnModel: [
				{
				    id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false
				},
				{
					id: 'divCtrId',
					width: '0',
					visible: false 
				},				
				{
					id : "HistNo",
					title: "Hist No",
					width: '50px'
				},				
				{
					id : "status",
					title: "Status",
					width: '150px',
				},				
				{
					id : "remarks",
					title: "Remarks",
					width: '290px',
				},				
				{
					id : "userId",
					title: "User ID",
					width: '100px',
				},				
				{
					id : "lastUpate",
					title: "Last Update",
					width: '100px',
					align : "center",
					titleAlign : "center"
				}
				
			],
			rows: []
		};
	
	tbgRecoveryHistory = new MyTableGrid(recoveryHistoryTableModel);
	tbgRecoveryHistory.pager = "";
	tbgRecoveryHistory.render('recoveryHistoryTable');

	$("btnReturn").observe("click", function(){
		overlayPerRecoveryTypeDetails.close();
		delete overlayPerRecoveryTypeDetails;
	});
</script>