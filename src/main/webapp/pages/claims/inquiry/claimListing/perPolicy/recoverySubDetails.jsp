<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>    
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>    
<div id="clmRecoveryDetailsGrid1" style="height: 56px; width: 810px; margin: auto; margin-top: 3px; margin-bottom: 25px;"></div>
<div id="clmRecoveryDetailsGrid2" style="height: 106px; width: 810px; margin: auto;  margin-top: 15px; margin-bottom: 25px;"></div>
<script type="text/javascript">
try{
	//Initialize
	initializeAll();
	
	var claimId = ('${claimId}');
	var recoveryId = ('${recoveryId}');
	
	//Recovery Payor
	var recoveryPayorGrid = JSON.parse('${recoveryPayorTG}'.replace(/\\/g, '\\\\'));
	var recoveryPayorRows = recoveryPayorGrid.rows || [];
	var recoveryPayorXX = null;
	var recoveryPayorYY = null;
	
	var recoveryPayorTM = {
			url: contextPath+"/GICLClmRecoveryController?action=showRecoveryPayorSubDetails"+
					"&claimId=" + claimId+
					"&recoveryId=" + recoveryId+
					"&refresh=1",
			options:{
				hideColumnChildTitle: true,
				title: '',
				newRowPosition: 'bottom',
				onCellFocus: function(element, value, x, y, id){ 
					recoveryPayorXX = Number(x);
					recoveryPayorYY = Number(y);  
				}, 
				onRemoveRowFocus: function ( x, y, element) {
					recoveryPayorXX = null;
					recoveryPayorYY = null;  
				} 	
			},
			columnModel: [
				{
				    id: 'recordStatus',
				    title : '',
		            width: '0',
		            visible: false,
		            editor: "checkbox"
				},
				{
					id: 'divCtrId',
					width: '0',
					visible: false
				},	
				{
				    id: 'payorClassCd classDesc',
				    title: 'Payor Class',
				    width : '260px',
				    children : [
					            {
					                id : 'payorClassCd',
					                title: 'Code',
					                type: 'number',
					                width: 80,
					                filterOption: true
					            },
					            {
					                id : 'classDesc', 
					                title: 'Description',
					                width: 180,
					                filterOption: true
					            }
								]
				},
				{
				    id: 'payorCd payorName',
				    title: 'Payor',
				    width : '350px',
				    children : [
					            {
					                id : 'payorCd',
					                title: 'Payor Code',
					                type: 'number',
					                width: 80,
					                filterOption: true
					            },
					            {
					                id : 'payorName', 
					                title: 'Payor Name',
					                width: 270,
					                filterOption: true
					            } 
								]
				}, 
				{
					id: 'recoveredAmt',
					title: 'Recovered Amount',
					type: 'number',
					geniisysClass: 'money',
					width: '180',
					visible: true
				}, 
				{
					id: 'recoveryId',
					width: '0',
					visible: false
				},
				{
					id: 'claimId',
					width: '0',
					visible: false
				}
				
			], 
			rows: recoveryPayorRows,
			id: 11
	};
	
	recoveryPayorTG = new MyTableGrid(recoveryPayorTM);
	recoveryPayorTG.pager = recoveryPayorGrid; 
	recoveryPayorTG._mtgId = 11; 
	recoveryPayorTG.render('clmRecoveryDetailsGrid1');
	
	//Recovery History
	var recoveryHistGrid = JSON.parse('${recoveryHistTG}'.replace(/\\/g, '\\\\'));
	var recoveryHistRows = recoveryHistGrid.rows || [];
	var recoveryHistXX = null;
	var recoveryHistYY = null;
	
	var recoveryHistTM = {
			url: contextPath+"/GICLClmRecoveryController?action=showRecoveryHistSubDetails"+
					"&claimId=" + claimId+
					"&recoveryId=" + recoveryId+
					"&refresh=1",
			options:{
				hideColumnChildTitle: true,
				title: '',
				newRowPosition: 'bottom',
				onCellFocus: function(element, value, x, y, id){ 
					recoveryHistXX = Number(x);
					recoveryHistYY = Number(y);  
				}, 
				onRemoveRowFocus: function ( x, y, element) {
					recoveryHistXX = null;
					recoveryHistYY = null;  
				} 	
			},
			columnModel: [
				{
				    id: 'recordStatus',
				    title : '',
		            width: '0',
		            visible: false,
		            editor: "checkbox"
				},
				{
					id: 'divCtrId',
					width: '0',
					visible: false
				},
				{
					id: 'recHistNo',
					title: 'Hist No.',
					width: '80',
					type: 'number',
					renderer: function (value){
						return nvl(value,'') == '' ? '' :formatNumberDigits(value,3);
					},
					visible: true
				},	
				{
				    id: 'recStatCd dspRecStatDesc',
				    title: 'Staus',
				    width : '235px',
				    children : [
					            {
					                id : 'recStatCd',
					                title: 'Code',
					                width: 65,
					                filterOption: true
					            },
					            {
					                id : 'dspRecStatDesc', 
					                title: 'Description',
					                width: 170,
					                filterOption: true
					            }
								]
				},
				{
					id: 'remarks',
					title: 'Remarks',
					width: '240',
					visible: true
				},
				{
					id: 'userId',
					title: 'User Id',
					width: '100',
					visible: true
				},
				{
					id: 'strLastUpdate',
					title: 'Last Update',
					width: '135', 
					visible: true
				},
				{
					id: 'claimId',
					width: '0',
					visible: false
				}
			], 
			rows: recoveryHistRows,
			id: 12
	};
	
	recoveryHistTG = new MyTableGrid(recoveryHistTM);
	recoveryHistTG.pager = recoveryHistGrid; 
	recoveryHistTG._mtgId = 12; 
	recoveryHistTG.render('clmRecoveryDetailsGrid2');
	
}catch(e){
	showErrorMessage("Recovery Sub Details", e);	
}	
</script>