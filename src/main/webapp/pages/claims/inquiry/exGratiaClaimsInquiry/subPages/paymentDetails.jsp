<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="paymentDetailsDiv" style="width: 99.5%; margin-top: 5px;">
	<div id="paymentDetailsHeader" style="width: 806px; height: 100px;">
		<table style="margin: 5px; float: left;">
			<tr>
				<td class="rightAligned" style="width: 110px; padding-right: 4px;">Claim Number</td>
				<td class="leftAligned"><input type="text" id="txtClaimNo" style="width: 280px;" readonly="readonly" tabindex="303"/></td>
				<td class="rightAligned"style="width: 110px; padding-right: 4px;">Loss Category</td>
				<td class="leftAligned"><input type="text" id="txtLossCategory" style="width: 280px;" readonly="readonly" tabindex="304"/></td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 110px; padding-right: 4px;">Policy Number</td>
				<td class="leftAligned"><input type="text" id="txtPolicyNo" style="width: 280px;" readonly="readonly" tabindex="303"/></td>
				<td class="rightAligned"style="width: 110px; padding-right: 4px;">Loss Date</td>
				<td class="leftAligned"><input type="text" id="txtLossDate" style="width: 280px;" readonly="readonly" tabindex="304"/></td>
			</tr>
			<tr>
				<td class="rightAligned" style=" padding-right: 4px;">Assured</td>
				<td class="leftAligned" rowspan="3"><input type="text" id="txtAssured" style="width: 280px;" readonly="readonly" tabindex="305"/></td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv" style="padding: 10px 0 10px 10px; width: 806px; height: 250px;">
		<div id="paymentTable" style="height: 115px; margin-left: auto;"></div>
	</div>
	<center>
		<input type="button" class="button" value="Return" id="btnReturn" style="margin-top: 5px; width: 100px;" />
	</center>
</div>
<script type="text/javascript">
	try{
		var jsonPaymentDetails = JSON.parse('${jsonPaymentDetails}');
		var searchBy = '${searchBy}';
		var asOfDate = '${asOfDate}';
		var fromDate = '${fromDate}';
		var toDate = '${toDate}';

		paymentTableModel = {
			id  : "paymentDetails",	
			url : contextPath+"/GICLClaimsController?action=showGICLS273PaymentDetails&refresh=1&searchBy="+searchBy+"&asOfDate="+asOfDate+"&fromDate="+fromDate+"&toDate="+toDate+"&claimId="+objGICLS273.claimId,
			options: {
				hideColumnChildTitle: true,
				width: '796px', height: '230px', 
				onCellFocus : function(element, value, x, y, id) {
					tbgPayment.keys.removeFocus(tbgPayment.keys._nCurrentFocus, true);
					tbgPayment.keys.releaseKeys();
					
				},
				onRemoveRowFocus : function(element, value, x, y, id){
					tbgPayment.keys.removeFocus(tbgPayment.keys._nCurrentFocus, true);
					tbgPayment.keys.releaseKeys();
				},
				onSort : function() {
					tbgPayment.keys.removeFocus(tbgPayment.keys._nCurrentFocus, true);
					tbgPayment.keys.releaseKeys();
				},
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						tbgPayment.keys.removeFocus(tbgPayment.keys._nCurrentFocus, true);
						tbgPayment.keys.releaseKeys();
					}
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
					id : "itemNo itemTitle",
					title : 'Item',
					width : '160',
					sortable : true,
					children : [
						{
							id : 'itemNo',	
							title : 'Item No',
							filterOption : true,
							filterOptionType: 'integerNoNegative',
							width : 40,							
							editable : false,	
							align: 'right'
						},
						{
							id : 'itemTitle',
							title : 'Item Title',
							filterOption : true,
							width : 140,
							editable : false
						}
					]					
				}, 				
				{
					id : 'perilCd perilName',
					title : 'Peril',
					width : '160',
					sortable : true,
					children : [
						{
							id : 'perilCd',	
							title : 'Peril Cd',
							filterOptionType: 'integerNoNegative',
							filterOption : true,
							width : 40,							
							editable : false,	
							align: 'right'
						},
						{
							id : 'perilName',
							title : 'Peril Name',
							filterOption : true,
							width : 150,
							editable : false
						}
					            ]					
				}, 	
				{
					id : "histSeqNo",
					title: "Hist No.",
					width: '55px',
					align : 'right',
					titleAlign : 'right',
					visible: true,
					filterOptionType: 'integerNoNegative',
					filterOption: true
				},
				{
					id : 'classDesc payeeName',
					title : 'Payee',
					width : '250',
					sortable : true,
					children : [
						{
							id : 'classDesc',
							title : 'Class Desc',
							filterOption : true,
							width : 100,							
							editable : false	
						},
						{
							id : 'payeeName',
							title : 'Payee Name',
							filterOption : true,
							width : 170,
							editable : false
						}
					            ]					
				}, 		
				{
					id : 'netAmt',
					title : 'Loss Net Amt',
					filterOption : true,
					align : 'right',
					titleAlign : 'right',
					width : '130px',
					filterOptionType: 'number',
					geniisysClass: 'money'				
				},
				{
					id : 'paidAmt',
					title : 'Loss Paid Amt',
					filterOption : true,
					align : 'right',
					titleAlign : 'right',
					width : '130px',
					filterOptionType: 'number',
					geniisysClass: 'money'				
				},	
				{
					id : 'adviseAmt',
					title : 'Loss Advice Amt',
					filterOption : true,
					align : 'right',
					titleAlign : 'right',
					width : '130px',
					filterOptionType: 'number',
					geniisysClass: 'money'				
				},	
				{
					id: 'exGratiaSw',
              		title : 'E',
              		altTitle: 'Ex-Gratia Switch',
	              	width: '30px',
	              	align : 'center',
					titleAlign : 'center',
	              	editable: false,
	              	visible: true,
	              	defaultValue: false,
	              	sortable: false,
					otherValue:	false,
					filterOption: true,
					filterOptionType: 'checkbox',
					editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}else{
								return "N";	
		            		}	
		            	} 
		            })
				}
			],
			rows: jsonPaymentDetails.rows
		};
	
		tbgPayment = new MyTableGrid(paymentTableModel);
		tbgPayment.pager = jsonPaymentDetails;
		tbgPayment.render('paymentTable');
		tbgPayment.afterRender = function() {
			$("txtClaimNo").value = tbgPayment.geniisysRows[0].claimNo;
			$("txtPolicyNo").value = tbgPayment.geniisysRows[0].policyNo;
			$("txtAssured").value = unescapeHTML2(tbgPayment.geniisysRows[0].assdName);
			$("txtLossCategory").value = unescapeHTML2(tbgPayment.geniisysRows[0].lossCatDes);
			$("txtLossDate").value = tbgPayment.geniisysRows[0].lossDate;
		};
	
		$("btnReturn").observe("click", function(){
			overlayPaymentDetails.close();
			delete overlayPaymentDetails;
		});
		
	}catch(e){
		showMessageBox("Error in paymentDetails.jsp " + e, imgMessage.ERROR);
	}
</script>