<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="recoveryDistMainDiv" name="recoveryDistMainDiv">
	<div id="recoveryDistTableGridDiv" align="center">
		<div id="recoveryDistGridDiv" style="float: left; height: 137px; margin-top: 3px; width: 99.8%;" class="sectionDiv">
			<div id="recoveryDistTableGrid" style="height: 106px; width: 786px; margin-top: 3px;"></div>
		</div>
		<div id="recoveryDistGridDiv2" name="recoveryDistGridDiv2"></div>
		<div class="buttonsDiv" align="center" style="margin-top: 5px; margin-bottom: 5px;">
			<input type="button" id="btnOk" name="btnOk" style="width: 120px;" class="button hover"  value="Return" />
		</div>
	</div>
</div>
<script type="text/javascript">
try {
	
	objCLM.recoveryDistTableGrid = JSON.parse('${recoveryDistTG}'.replace(/\\/g, '\\\\'));
	objCLM.recoveryDistList = objCLM.recoveryDistTableGrid.rows || [];
	objCLM.recoveryDistCurrRow = null;
	
	var recoveryDistTM = {
		url: contextPath+"/GICLRecoveryPaytController?action=getGiclRecoveryPaytGrid"+
				"&claimId=" + objCLMGlobal.claimId+
				"&recoveryId=" + objCLM.recoveryDetailsCurrRow.recoveryId+
				"&refresh=1",
		options:{
			hideColumnChildTitle: true,
			title: '',
			onCellFocus: function(element, value, x, y, id){ 
				objCLM.recoveryDistCurrRow = objCLM.recoveryDistTG.getRow(Number(y));
				objCLM.recoveryDistTG.keys.removeFocus(objCLM.recoveryDistTG.keys._nCurrentFocus, true);
				objCLM.recoveryDistTG.keys.releaseKeys();
				showRecoverySubDetails(objCLM.recoveryDistTG.geniisysRows[y].recoveryId, objCLM.recoveryDistTG.geniisysRows[y].recoveryPaytId);
			}, 
			onRemoveRowFocus: function ( x, y, element) {
				objCLM.recoveryDistCurrRow = null;
				objCLM.recoveryDistTG.keys.removeFocus(objCLM.recoveryDistTG.keys._nCurrentFocus, true);
				objCLM.recoveryDistTG.keys.releaseKeys();
				showRecoverySubDetails("", "");
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
                id : 'dspRefCd', 
                title: 'Reference No.',
                width: 170,
                filterOption: true
            },     
			{
			    id: 'payorCd dspPayorName',
			    title: 'Payor',
			    width : '320px',
			    children : [
		            {
		                id : 'payorCd',
		                title: 'Payor Code',
		                type: 'number',
		                width: 80,
		                filterOption: true,
		                filterOptionType: 'integer' 
		            },
		            {
		                id : 'dspPayorName', 
		                title: 'Payor Name',
		                width: 280,
		                filterOption: true
		            }
				]
			},
	        {
				id: 'recoveredAmt',
				title: 'Recovered Amount',
				titleAlign: 'right',
				width: 190,
				maxlength: 19,
				editable: false,
				align: 'right',
				geniisysClass: 'money',
	            filterOption: true,
	            filterOptionType: 'number' 
	        },
			{
	            id: 'dspCheckCancel',
	            title: '&#160;C',
	            altTitle: 'Cancelled',
	            titleAlign: 'center',
	            width: 22,
	            maxlength: 1, 
	            sortable: false, 
			   	hideSelectAllBox: true,
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
	            id: 'dspCheckDist',
	            title: '&#160;D',
	            altTitle: 'Distributed',
	            titleAlign: 'center',
	            width: 22,
	            maxlength: 1, 
	            sortable: false, 
			   	hideSelectAllBox: true,
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
				id: 'recoveryId',
				width: '0',
				visible: false
			},
			{
				id: 'recoveryPaytId',
				width: '0',
				visible: false
			}, 		
		],
		rows: objCLM.recoveryDistList,
		id: 5
	};	
	
	objCLM.recoveryDistTG = new MyTableGrid(recoveryDistTM);
	objCLM.recoveryDistTG.pager = objCLM.recoveryDistTableGrid;
	objCLM.recoveryDistTG._mtgId = 5;
	objCLM.recoveryDistTG.afterRender = function(){
		if (objCLM.recoveryDistTG.rows.length > 0){
			objCLM.recoveryDistCurrRow = objCLM.recoveryDistTG.getRow('0');
			objCLM.recoveryDistTG.selectRow('0');
			showRecoverySubDetails(objCLM.recoveryDistTG.geniisysRows[0].recoveryId, objCLM.recoveryDistTG.geniisysRows[0].recoveryPaytId);
		}else{
			showRecoverySubDetails("","");
		}	
	};
	objCLM.recoveryDistTG.render('recoveryDistTableGrid');
	
	function showRecoverySubDetails(recoveryId, recoveryPaytId){
		try{
			new Ajax.Request(contextPath+"/GICLRecoveryPaytController",{
				parameters: {
					action: "getGiclDistributionsGrid",
					recoveryId: recoveryId,
					recoveryPaytId: recoveryPaytId,
					pageSize: 3
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)) {
						$("recoveryDistGridDiv2").update(response.responseText);
					}
				}	
			});
		}catch(e){
			showErrorMessage("showRecoverySubDetails", e);	
		}	
	}	
	
	$("btnOk").observe("click", function(){
		Windows.close("distribution_detail_view");
	});
	
} catch(e){
	showErrorMessage("Recovery Distribution Overlay", e);
}
</script>