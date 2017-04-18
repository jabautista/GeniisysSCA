<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="paymentDetailsDiv" style="width: 99.5%; margin-top: 5px;">
	<div class="sectionDiv" style="padding: 10px 0 10px 10px; width: 806px; height: 250px;">
		<div id="paymentTable" style="height: 115px; margin-left: auto;"></div>
	</div>
	<center>
		<input type="button" class="button" value="Distribution Details" id="btnDistDtl" style="margin-top: 5px; width: 200px;" />
		<input type="button" class="button" value="Return" id="btnReturn" style="margin-top: 5px; width: 100px;" />
	</center>
</div>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/claims/claims.js">
	try{
		var jsonPaymentDetails = JSON.parse('${jsonPaymentDetails}');
		
		function toggleDistBtn(rec){
			if(rec != null){
				if(rec.distSw == 'Y'){
// 				if(!rec.vCheck == 0){
					objPayDet.recoveryId = rec.recoveryId;
					objPayDet.recoveryPaytId = rec.recoveryPaytId;
					enableButton("btnDistDtl");
				}else{
					disableButton("btnDistDtl");
					objPayDet = new Object();
				}
			}else {
				disableButton("btnDistDtl");
				objPayDet = new Object();
			}
		}

		paymentTableModel = {
			id  : "paymentDetails",	
			url : contextPath+"/GICLLossRecoveryPaymentController?action=showGICLS270PaymentDetails&refresh=1&recoveryId=" + objLossRec.recoveryId,
			options: {
				width: '796px', height: '230px', 
				onCellFocus : function(element, value, x, y, id) {
					toggleDistBtn(tbgPayment.geniisysRows[y]);
					tbgPayment.keys.removeFocus(tbgPayment.keys._nCurrentFocus, true);
					tbgPayment.keys.releaseKeys();
					
				},
				onRemoveRowFocus : function(element, value, x, y, id){
					toggleDistBtn(null);
					tbgPayment.keys.removeFocus(tbgPayment.keys._nCurrentFocus, true);
					tbgPayment.keys.releaseKeys();
				},
				onSort : function() {
					toggleDistBtn(tbgPayment.geniisysRows[0]);
					tbgPayment.keys.removeFocus(tbgPayment.keys._nCurrentFocus, true);
					tbgPayment.keys.releaseKeys();
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
					id: 'cancelTag',
              		title : 'C',
              		altTitle: 'Cancel Tag',
	              	width: '32px',
	              	editable: false,
	              	visible: true,
	              	defaultValue: false,
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
				},
				{
					id: 'distSw',
              		title : 'D',
              		altTitle: 'Dist SW',
	              	width: '32px',
	              	editable: false,
	              	visible: true,
	              	defaultValue: false,
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
				},
				{
					id : "refNo",
					title: "Reference Number",
					width: '150px',
					visible: true,
					filterOption: true
				},
				{
					id : "payorDet",
					title: "Payor",
					width: '300px',
					visible: true,
					filterOption: true
				},
				{
					id : "recoveredAmt",
					title: "Recovery Amount",
					width: '130px',
					filterOption : true,
					align : 'right',
					titleAlign : 'right',
					filterOptionType: 'number',
					geniisysClass: 'money'
				},
				{
					id : "tranDate",
					title: "Recovery Date",
					width: '110px',
					visible: true,
					renderer: function(value){
						return dateFormat(value, "mm-dd-yyyy");
					},
					filterOption: true,
					filterOptionType : 'formattedDate'
				}
			],
			rows: jsonPaymentDetails.rows
		};
	
		tbgPayment = new MyTableGrid(paymentTableModel);
		tbgPayment.pager = jsonPaymentDetails;
		tbgPayment.render('paymentTable');
		tbgPayment.afterRender = function() {
			if(tbgPayment.geniisysRows.length > 0){
				var rec = tbgPayment.geniisysRows[0];
				tbgPayment.selectRow('0');
				objPayDet.recoveryId = rec.recoveryId;
				objPayDet.recoveryPaytId = rec.recoveryPaytId;
				toggleDistBtn(tbgPayment.geniisysRows[0]);
			}
		};
		
		$("btnDistDtl").observe("click", function(){
			overlayPaymentDetails.close();
			delete overlayPaymentDetails;
			showOverlayDistributionGicls270();
		});
	
		$("btnReturn").observe("click", function(){
			overlayPaymentDetails.close();
			delete overlayPaymentDetails;
		});
		
		function initGICLS270paymentDet(){
			disableButton("btnDistDtl");
			objPayDet = new Object();
		}
		
		initGICLS270paymentDet();
	}catch(e){
		showMessageBox("Error in paymentDetails.jsp " + e, imgMessage.ERROR);
	}
</script>