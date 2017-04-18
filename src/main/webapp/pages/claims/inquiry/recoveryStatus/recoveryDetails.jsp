<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="recoveryDetailDiv" style="width: 99.5%; margin-top: 5px;">
	
	<div class="sectionDiv" style="padding: 10px 0 10px 10px; width: 786px; height: 95px;">
		<table border="0" style="margin-bottom: 0px;">
			<tr>
				<td width="100px" class="rightAligned">Lawyer</td>
				<td>&nbsp;</td>
				<td><input class="rightAligned" type="text" readonly="readonly" id="txtLawyer" value="${lawyerCd}" style="width: 60px;" /></td>
				<td><input type="text" readonly="readonly" id="txtLawyerDesc" value="${lawyer}" style="width: 228px;" /></td>
				<td width="50px"></td>
				<td class="rightAligned">Recoverable Amount</td>
				<td>&nbsp;</td>
				<td><input class="rightAligned" type="text" readonly="readonly" id="txtRecoverableAmt" value="${recoverableAmt}" style="width: 170px;" /></td>
			</tr>
			<tr rowspan="1">
				<td class="rightAligned">Third Party Item Description</td>
				<td>&nbsp;</td>
				<td colspan="2" rowspan="3"><textarea rows="2" cols="45" style="resize:none" readonly="readonly" id="txtThirdPartyItemDesc">${tpItemDesc}</textarea></td>
				<td>&nbsp;</td>
				<td class="rightAligned">Recovered Amount</td>
				<td>&nbsp;</td>
				<td><input class="rightAligned" type="text" readonly="readonly" id="txtRecoveredAmt" value="${recoveredAmtR}" style="width: 170px;" /></td>
			</tr>
			<tr></tr>
			<tr >
				<td></td>
				<td colspan="2"></td>
				<td></td>
				<td class="rightAligned">Plate No.</td>
				<td>&nbsp;</td>
				<td><input class="rightAligned" type="text" readonly="readonly" id="txtPlateNo" value="${plateNo}" style="width: 170px;" /></td>
			</tr>
		</table>
	</div>
	
	<div class="sectionDiv" style="padding: 10px 0 10px 10px; width: 786px; height: 250px;">
		<div id="detailTable" style="height: 115px; margin-left: auto;"></div>
	</div>
	
	
	<center>
		<input type="button" class="button" value="Return" id="btnReturn" style="margin-top: 5px; width: 100px;" />
	</center>
</div>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/claims/claims.js">
	try{
		var jsonRecoveryDetails = JSON.parse('${jsonRecoveryDetails}');
		
		detailTableModel = {
			id  : "recoveryDetail",	
			url : contextPath+"/GICLLossRecoveryStatusController?action=showGICLS269RecoveryDetails&refresh=1&claimId="+'${claimId}'+"&recoveryId="+'${recoveryId}',
			options: {
				hideColumnChildTitle: true,
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
				},
				width: '776px', height: '230px', 
				onCellFocus : function(element, value, x, y, id) {
					tbgDetail.keys.removeFocus(tbgDetail.keys._nCurrentFocus, true);
					tbgDetail.keys.releaseKeys();
					
				},
				onRemoveRowFocus : function(element, value, x, y, id){
					tbgDetail.keys.removeFocus(tbgDetail.keys._nCurrentFocus, true);
					tbgDetail.keys.releaseKeys();
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
					id : "payorClassCd payeeClassDesc",
					title: "Payor Class&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp",
					width: '300px',					
					children : [{
			                id : 'payorClassCd',
			                title:'Payor Class Code',
			                align : 'right',
			                width: 70,
			                filterOption: true,
			                filterOptionType : 'integerNoNegative'
			            },{
			                id : 'payeeClassDesc',
			                title: 'Payor Class Description',
			                align : "left",
			                width: 140,
			                filterOption: true
			            }]
				},				
				{
					id : "payorCd payeeName",
					title: "Payor&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp",
					width: '300px',					
					children : [{
					     id : 'payorCd',
			                title:'Payor Code',
			                align : 'right',
			                width: 70,
			                filterOption: true,
			                filterOptionType : 'integerNoNegative'
			            },{
			                id : 'payeeName',
			                title: 'Payor Name',
			                align : "left",
			                width: 300,
			                filterOption: true						
						}]
				},				
				{
					id : "recoveredAmtP",
					title: "Recoverable Amount",
					width: '160px',
					visible: true,
					filterOption: false,
					titleAlign : "right",
					align : "right",
					renderer: function(value) {
	  					return formatCurrency(value);
	  				}
				}
			],
			rows: jsonRecoveryDetails.rows
		};
	
		tbgDetail = new MyTableGrid(detailTableModel);
		tbgDetail.pager = jsonRecoveryDetails;
		tbgDetail.render('detailTable');
		tbgDetail.afterRender = function() {
			$("txtRecoverableAmt").value = formatCurrency($("txtRecoverableAmt").value);
			$("txtRecoveredAmt").value = formatCurrency($("txtRecoveredAmt").value );
		};
		
		
		$("btnReturn").observe("click", function(){
			overlayRecoveryDetails.close();
			delete overlayRecoveryDetails;
		});
		
	}catch(e){
		showMessageBox("Error in recoveryDetails.jsp " + e, imgMessage.ERROR);
	}
</script>