<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="distributionDetailsDiv" style="width: 99.5%; margin-top: 5px;">
	<div class="sectionDiv" style="padding: 10px 0 10px 10px; width: 806px; height: 150px;">
		<div id="distributionTable" style="height: 115px; margin-left: auto;"></div>
	</div>
	<div class="sectionDiv" style="padding: 10px 0 10px 10px; width: 806px; height: 150px;">
		<div id="distributionRidsTable" style="height: 115px; margin-left: auto;"></div>
	</div>
	<center>
		<input type="button" class="button" value="Return" id="btnReturn" style="margin-top: 5px; width: 100px;" />
	</center>
</div>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/claims/claims.js">
	try{
		var jsonDistributionDsDetails = JSON.parse('${jsonDistributionDsDetails}');
		
		function showDistributionRids(rec){
			if(rec == null){
				distributionRidsTableGrid.url = contextPath+"/GICLLossRecoveryPaymentController?action=showGICLS270DistributionRids&refresh=1";
			}else{
				distributionRidsTableGrid.url = contextPath+"/GICLLossRecoveryPaymentController?action=showGICLS270DistributionRids&refresh=1"
														   + "&recoveryId=" + rec.recoveryId 
														   + "&recoveryPaytId=" + rec.recoveryPaytId
														   + "&recDistNo=" + rec.recDistNo
														   + "&grpSeqNo=" + rec.grpSeqNo;
				distributionRidsTableGrid._refreshList();
			}
		}
		
		//RIDS
		var objDistributionRids = new Object();
		objDistributionRids.objDistributionRidsTableGrid = {};
		distributionRidsTableModel = {
			id: "distributionRids",
			options: {
				width: '796px'
			},
			columnModel: [
				{   id: 'recordStatus',
				    width: '0px',
				    visible: false,
				    editor: 'checkbox'
				},
				{	id: 'divCtrId',
					width: '0px',
					visible: false
				},
				{	id: 'riCd',
					title: 'RI CD',
					width: '80px',
					visible: true,
					filterOption: true,
					align : 'right',
					titleAlign : 'right',
				},
				{
					id: 'riName',
					title: 'Reinsurer',
					width: '400px',
					visible: true,
					filterOption: true
				},
				{
					id : "shareRiPct",
					title: "Share Pct.",
					width: '150px',
					filterOption : true,
					align : 'right',
					titleAlign : 'right',
					filterOptionType: 'number',
					geniisysClass: 'money'
				},
				{
					id : "shrRiRecoveryAmt",
					title: "Share Recovery Amt.",
					width: '150px',
					filterOption : true,
					align : 'right',
					titleAlign : 'right',
					filterOptionType: 'number',
					geniisysClass: 'money'
				}
              ],
              rows: []
				
		};
		distributionRidsTableGrid = new MyTableGrid(distributionRidsTableModel);
		distributionRidsTableGrid.pager = objDistributionRids.objDistributionRidsTableGrid;
		distributionRidsTableGrid.render('distributionRidsTable');
		
		distributionTableModel = {
			id  : "distributionDetails",	
			url : contextPath+"/GICLLossRecoveryPaymentController?action=showGICLS270DistributionDs&refresh=1&recoveryId=" + objPayDet.recoveryId + "&recoveryPaytId="+objPayDet.recoveryPaytId,
			options: {
				width: '796px',
				onCellFocus : function(element, value, x, y, id) {
					showDistributionRids(tbgDistribution.geniisysRows[y]);
					tbgDistribution.keys.removeFocus(tbgDistribution.keys._nCurrentFocus, true);
					tbgDistribution.keys.releaseKeys();
					
				},
				onRemoveRowFocus : function(element, value, x, y, id){
					tbgDistribution.keys.removeFocus(tbgDistribution.keys._nCurrentFocus, true);
					tbgDistribution.keys.releaseKeys();
					showDistributionRids(null);
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
					id : "shareName",
					title: "Treaty Name",
					width: '400px',
					visible: true,
					filterOption: true
				},
				{
					id : "sharePct",
					title: "Share Pct.",
					width: '150px',
					visible: true,
					filterOption: true,
					align : 'right',
					titleAlign : 'right',
					filterOptionType: 'number',
					geniisysClass: 'money'
				},
				{
					id : "distYear",
					title: "Dist Yr.",
					width: '65px',
					filterOption : true
				},
				{
					id : "shrRecoveryAmt",
					title: "Share Recovery Amt.",
					width: '150px',
					visible: true,
					filterOption: true,
					align : 'right',
					titleAlign : 'right',
					filterOptionType: 'number',
					geniisysClass: 'money'
				},
			],
			rows: jsonDistributionDsDetails.rows
		};
	
		tbgDistribution = new MyTableGrid(distributionTableModel);
		tbgDistribution.pager = jsonDistributionDsDetails;
		tbgDistribution.render('distributionTable');
		tbgDistribution.afterRender = function() {
			if(tbgDistribution.geniisysRows.length > 0){
				var rec = tbgDistribution.geniisysRows[0];
				showDistributionRids(rec);
				tbgDistribution.selectRow('0');
			}
		};
	
		$("btnReturn").observe("click", function(){
			overlaydistributionDetails.close();
			delete overlaydistributionDetails;
			showGicls270PaymentDetails();
		});
	}catch(e){
		showMessageBox("Error in distributionDetails.jsp " + e, imgMessage.ERROR);
	}
</script>