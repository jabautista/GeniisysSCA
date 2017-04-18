<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<div id="recoveryRidsGridDiv" style="height: 137px; margin-top: 3px;">
	<div id="recoveryRidsTableGrid" style="height: 106px; width: 786px;"></div>
</div>
<script type="text/javascript">
try {
	
	objCLM.recoveryRidsTableGrid = JSON.parse('${recoveryRidsTG}'.replace(/\\/g, '\\\\'));
	objCLM.recoveryRidsList = objCLM.recoveryRidsTableGrid.rows || [];
	
	var recoveryRidsTM = {
		url: contextPath+"/GICLRecoveryPaytController?action=getGiclRecoveryRidsGrid"+
				"&recoveryPaytId=" + (nvl(objCLM.recoveryDSCurrRow,null) != null ? nvl(objCLM.recoveryDSCurrRow.recoveryPaytId,"") :"")+
				"&recoveryId=" + (nvl(objCLM.recoveryDSCurrRow,null) != null ? nvl(objCLM.recoveryDSCurrRow.recoveryId,"") :"")+
				"&recDistNo=" + (nvl(objCLM.recoveryDSCurrRow,null) != null ? nvl(objCLM.recoveryDSCurrRow.recDistNo,"") :"")+
				"&grpSeqNo=" + (nvl(objCLM.recoveryDSCurrRow,null) != null ? nvl(objCLM.recoveryDSCurrRow.grpSeqNo,"") :"")+
				"&refresh=1",
		options:{
			hideColumnChildTitle: true,
			title: '',
			onCellFocus: function(element, value, x, y, id){ 
				objCLM.recoveryRidsTG.keys.removeFocus(objCLM.recoveryRidsTG.keys._nCurrentFocus, true);
				objCLM.recoveryRidsTG.keys.releaseKeys();
			}, 
			onRemoveRowFocus: function ( x, y, element) {
				objCLM.recoveryRidsTG.keys.removeFocus(objCLM.recoveryRidsTG.keys._nCurrentFocus, true);
				objCLM.recoveryRidsTG.keys.releaseKeys(); 
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
			    id: 'riCd dspRiName',
			    title: 'Reinsurer',
			    width : '362px',
			    children : [
		            {
		                id : 'riCd',
		                title: 'RI Code',
		                type: 'number',
		                width: 82,
		                filterOption: true,
		                filterOptionType: 'integer' 
		            },
		            {
		                id : 'dspRiName', 
		                title: 'RI Name',
		                width: 320,
		                filterOption: true
		            }
				]
			}, 
            {
                id : 'shareRiPct',
                title: 'Share%',
                type: 'number',
                titleAlign: 'right',
                align: 'right',
                width: 120,
                geniisysClass: 'rate',
	            deciRate: 2,
                filterOption: true,
                filterOptionType: 'number' 
            }, 
	        {
				id: 'shrRiRecoveryAmt',
				title: 'Share Recovery Amount',
				titleAlign: 'right',
				width: 228,
				maxlength: 19,
				editable: false,
				align: 'right',
				geniisysClass: 'money',
	            filterOption: true,
	            filterOptionType: 'number' 
	        },
			{
				id: 'recoveryId',
				width: '0',
				visible: false
			},
			{
				id: 'recoveryPaytId',
				width: '0',
				visible: false
			}, 
			{
				id: 'recDistNo',
				width: '0',
				visible: false
			}, 
			{
				id: 'lineCd',
				width: '0',
				visible: false
			}, 
			{
				id: 'grpSeqNo',
				width: '0',
				visible: false
			}, 
			{
				id: 'distYear',
				width: '0',
				visible: false
			}, 
			{
				id: 'shareType',
				width: '0',
				visible: false
			}, 
			{
				id: 'acctTrtyType',
				width: '0',
				visible: false
			}, 
			{
				id: 'shareRiPctReal',
				width: '0',
				visible: false
			}, 
			{
				id: 'negateTag',
				width: '0',
				visible: false
			} , 
			{
				id: 'negateDate',
				width: '0',
				visible: false
			}  		
		],
		rows: objCLM.recoveryRidsList,
		id: 7
	};	
	
	objCLM.recoveryRidsTG = new MyTableGrid(recoveryRidsTM);
	objCLM.recoveryRidsTG.pager = objCLM.recoveryRidsTableGrid;
	objCLM.recoveryRidsTG._mtgId = 7;
	objCLM.recoveryRidsTG.render('recoveryRidsTableGrid');
	
}catch(e){
	showErrorMessage("Recovery Distribution Rids", e);
}
</script>