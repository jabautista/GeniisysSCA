<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="recoveryDetailsMainDiv" name="recoveryDetailsMainDiv">
	<div id="recoveryDetailsTableGridDiv" align="center">
		<div id="recoveryDetailsGridDiv" style="height: 200px; margin-top: 5px;">
			<div id="recoveryDetailsTableGrid" style="height: 156px; width: 786px;"></div>
		</div>
		<table border="0" style="margin-top: -7px; float: right;">
			<tr>
				<td class="rightAligned">Total Recoverable Amt. &nbsp;</td>
				<td class="leftAligned"><input type="text" id="txtTotalRecAmt" name="txtTotalRecAmt" style="width: 160px; margin-right: 10px;" value="" readonly="readonly" class="money"></td>
			</tr>
		</table>
		<div class="buttonsDiv" align="center" style="margin-bottom: 5px;">
			<input type="button" id="btnOk" name="btnOk" style="width: 120px;" class="button hover"  value="Return" />
		</div>
	</div>
</div>
<script type="text/javascript">
try {
	
	objCLM.recoveryOverlayTableGrid = JSON.parse('${recoveryDtlTG}'.replace(/\\/g, '\\\\'));
	objCLM.recoveryOverlayList = objCLM.recoveryOverlayTableGrid.rows || [];
	
	var recoveryOverlayTM = {
		url: contextPath+"/GICLClmRecoveryDtlController?action=showRecoveryDtl"+
				"&claimId=" + objCLMGlobal.claimId+
				"&recoveryId=" + objCLM.recoveryDetailsCurrRow.recoveryId+
				"&lineCd="+ objCLMGlobal.lineCd+
				"&refresh=1",
		options:{
			hideColumnChildTitle: true,
			title: '',
			onCellFocus: function(element, value, x, y, id){
				objCLM.recoveryOverlayTG.keys.removeFocus(objCLM.recoveryOverlayTG.keys._nCurrentFocus, true);
				objCLM.recoveryOverlayTG.keys.releaseKeys(); // andrew - 12.14.2012
            },
            onRemoveRowFocus: function(){
            	objCLM.recoveryOverlayTG.keys.removeFocus(objCLM.recoveryOverlayTG.keys._nCurrentFocus, true);
				objCLM.recoveryOverlayTG.keys.releaseKeys();
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
	            id: 'dspChkBox',
	            title: '&#160;',
	            altTitle: '',
	            titleAlign: 'center',
	            width: 20,
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
			    id: 'itemNo dspItemNo',
			    title: 'Item',
			    width : '240px',
			    children : [
		            {
		                id : 'itemNo',
		                title: 'Item No',
		                type: 'number',
		                width: 60,
		                filterOption: true,
		                filterOptionType: 'integer' 
		            },
		            {
		                id : 'dspItemNo', 
		                title: 'Item Title',
		                width: 180,
		                filterOption: true
		            }
				]
			},     
			{
			    id: 'perilCd dspPerilCd',
			    title: 'Peril',
			    width : '240px',
			    children : [
		            {
		                id : 'perilCd',
		                title: 'Peril Code',
		                type: 'number',
		                width: 60,
		                filterOption: true,
		                filterOptionType: 'integer' 
		            },
		            {
		                id : 'dspPerilCd', 
		                title: 'Peril Name',
		                width: 180,
		                filterOption: true
		            }
				]
			},
	        {
				id: 'dspTsiAmt',
				title: 'TSI Amount',
				titleAlign: 'right',
				width: 130,
				maxlength: 19,
				editable: false,
				align: 'right',
				geniisysClass: 'money',
	            filterOption: true,
	            filterOptionType: 'number' 
	        },
	        {
				id: 'recoverableAmt',
				title: 'Recoverable',
				titleAlign: 'right',
				width: 130,
				maxlength: 19,
				editable: false,
				align: 'right',
				geniisysClass: 'money',
	            filterOption: true,
	            filterOptionType: 'number' 
	        },
			{
				id: 'clmLossId',
				width: '0',
				visible: false
			},
			{
				id: 'claimId',
				width: '0',
				visible: false
			},
			{
				id: 'recoveryId',
				width: '0',
				visible: false
			}		
		],
		rows: objCLM.recoveryOverlayList,
		id: 4
	};	
				
	objCLM.recoveryOverlayTG = new MyTableGrid(recoveryOverlayTM);
	objCLM.recoveryOverlayTG.pager = objCLM.recoveryOverlayTableGrid;
	objCLM.recoveryOverlayTG._mtgId = 4;
	objCLM.recoveryOverlayTG.afterRender = function(){
		if (objCLM.recoveryOverlayTG.rows.length > 0){
			$("txtTotalRecAmt").value = formatCurrency(nvl(objCLM.recoveryOverlayTG.geniisysRows[0].dspTotalRecAmt,0));
		}else{
			$("txtTotalRecAmt").value = "0.00";
		}	
	};
	objCLM.recoveryOverlayTG.render('recoveryDetailsTableGrid');
	
	$("btnOk").observe("click", function(){
		//Windows.close("recovery_detail_view");
		overlayPremWarr.close();
		delete overlayPremWarr;
		delete objCLM.recoveryOverlayTG;
	});
	
} catch(e){
	showErrorMessage("Recovery Details Overlay", e);
}
</script>