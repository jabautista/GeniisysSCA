<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="recoveryDSTableGridDiv" align="center" style="float: left; width: 99.8%;" class="sectionDiv">
	<div id="recoveryDSGridDiv" style="height: 134px; margin-top: 3px;" >
		<div id="recoveryDSTableGrid" style="height: 106px; width: 786px;"></div>
	</div>
</div>
<div id="recoveryRidsTableGridDiv" align="center" style="float: left; width: 99.8%;" class="sectionDiv"></div>
<script type="text/javascript">
try {
	
	objCLM.recoveryDSTableGrid = JSON.parse('${recoveryDSTableGrid}'.replace(/\\/g, '\\\\'));
	objCLM.recoveryDSList = objCLM.recoveryDSTableGrid.rows || [];
	objCLM.recoveryDSCurrRow = null;
	
	var recoveryDSTM = {
		url: contextPath+"/GICLRecoveryPaytController?action=getGiclDistributionsGrid"+
				"&recoveryPaytId=" + (nvl(objCLM.recoveryDistCurrRow,null) != null? nvl(objCLM.recoveryDistCurrRow.recoveryPaytId,"") :"")+
				"&recoveryId=" + (nvl(objCLM.recoveryDistCurrRow,null) != null? nvl(objCLM.recoveryDistCurrRow.recoveryId,"") :"")+
				"&pageSize=3&refresh=1",
		options:{
			hideColumnChildTitle: true,
			title: '',
			onCellFocus: function(element, value, x, y, id){ 
				objCLM.recoveryDSCurrRow = objCLM.recoveryDSTG.getRow(Number(y));
				objCLM.recoveryDSTG.keys.removeFocus(objCLM.recoveryDSTG.keys._nCurrentFocus, true);
				objCLM.recoveryDSTG.keys.releaseKeys();
				showRecoveryRidsDetails(
					objCLM.recoveryDSTG.geniisysRows[y].recoveryId, 
					objCLM.recoveryDSTG.geniisysRows[y].recoveryPaytId,
					objCLM.recoveryDSTG.geniisysRows[y].recDistNo,
					objCLM.recoveryDSTG.geniisysRows[y].grpSeqNo
				);
			}, 
			onRemoveRowFocus: function ( x, y, element) {
				objCLM.recoveryDSCurrRow = null;
				objCLM.recoveryDSTG.keys.removeFocus(objCLM.recoveryDSTG.keys._nCurrentFocus, true);
				objCLM.recoveryDSTG.keys.releaseKeys();
				showRecoveryRidsDetails("", "", "", "");
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
                id : 'dspShareName', 
                title: 'Treaty Name',
                width: 290,
                filterOption: true
            },
            {
                id : 'sharePct',
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
                id : 'distYear',
                title: 'Dist. Year',
                titleAlign: 'right',
                align: 'right',
                type: 'number',
                width: 120,
                filterOption: true,
                filterOptionType: 'number' 
            },
	        {
				id: 'shrRecoveryAmt',
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
				id: 'shareType',
				width: '0',
				visible: false
			}, 
			{
				id: 'acctTrtyType',
				width: '0',
				visible: false
			} 		
		],
		rows: objCLM.recoveryDSList,
		id: 6
	};	
	
	objCLM.recoveryDSTG = new MyTableGrid(recoveryDSTM);
	objCLM.recoveryDSTG.pager = objCLM.recoveryDSTableGrid;
	objCLM.recoveryDSTG._mtgId = 6;
	objCLM.recoveryDSTG.afterRender = function(){
		if (objCLM.recoveryDSTG.rows.length > 0){
			objCLM.recoveryDSCurrRow = objCLM.recoveryDSTG.getRow('0');
			objCLM.recoveryDSTG.selectRow('0');
			showRecoveryRidsDetails(
				objCLM.recoveryDSTG.geniisysRows[0].recoveryId, 
				objCLM.recoveryDSTG.geniisysRows[0].recoveryPaytId,
				objCLM.recoveryDSTG.geniisysRows[0].recDistNo,
				objCLM.recoveryDSTG.geniisysRows[0].grpSeqNo
			);
		}else{
			showRecoveryRidsDetails("","", "", "");
		}	
	};
	objCLM.recoveryDSTG.render('recoveryDSTableGrid');
	
	function showRecoveryRidsDetails(recoveryId, recoveryPaytId, recDistNo, grpSeqNo){
		try{
			new Ajax.Request(contextPath+"/GICLRecoveryPaytController",{
				parameters: {
					action: "getGiclRecoveryRidsGrid",
					recoveryId: recoveryId,
					recoveryPaytId: recoveryPaytId,
					recDistNo: recDistNo,
					grpSeqNo: grpSeqNo
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)) {
						$("recoveryRidsTableGridDiv").update(response.responseText);
					}
				}	
			});
		}catch(e){
			showErrorMessage("showRecoveryRidsDetails", e);	
		}	
	}	
	
} catch(e){
	showErrorMessage("Recovery Distribution DS", e);
}
</script>