<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "No-cache");
	response.setHeader("Pragma", "No-cache");
%>
<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
   		<label>Distribution Details</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label name="gro" style="margin-left: 5px;">Hide</label>
   		</span>
   	</div>
</div>
<div id="distDetailsSectionDiv" class="sectionDiv">
	<div id="distDetailsGrid" style="height: 106px; width: 800px; margin: auto; margin-top: 10px; margin-bottom: 35px;"></div>
</div>
<script type="text/javascript">
try{
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	
	objCLM.distDetailsGrid = JSON.parse('${distDetailsTG}');
	objCLM.distDetailsRows = objCLM.distDetailsGrid.rows || [];
	
	objCLM.distDetailsCurrXX = null;
	objCLM.distDetailsCurrYY = null;
	objCLM.distDetailsCurrRow = null;
	
	objCLM.distDetailsTM = {
		url: contextPath+"/GICLReserveDsController?action=showDistDetailsPLA"+
				"&claimId=" +  	 	(objCLM.reserveDetailsRow == null ? "" :nvl(objCLM.reserveDetailsRow.claimId,objCLMGlobal.claimId))+
				"&lineCd=" + 	 	(objCLM.reserveDetailsRow == null ? "" :nvl(objCLM.reserveDetailsRow.lineCd,objCLMGlobal.lineCd))+
				"&clmResHistId=" +  (objCLM.reserveDetailsRow == null ? "" :nvl(String(objCLM.reserveDetailsRow.clmResHistId),""))+
				"&itemNo=" + 		(objCLM.reserveDetailsRow == null ? "" :nvl(String(objCLM.reserveDetailsRow.itemNo),""))+
				"&groupedItemNo=" + (objCLM.reserveDetailsRow == null ? "" :nvl(String(objCLM.reserveDetailsRow.groupedItemNo),""))+
				"&perilCd=" + 		(objCLM.reserveDetailsRow == null ? "" :nvl(String(objCLM.reserveDetailsRow.perilCd),""))+
				"&histSeqNo=" + 	(objCLM.reserveDetailsRow == null ? "" :nvl(String(objCLM.reserveDetailsRow.histSeqNo),""))+
				"&refresh=1",
		options:{
			hideColumnChildTitle: true,
			title: '',
			newRowPosition: 'bottom',
			onCellFocus: function(element, value, x, y, id){
				objCLM.distDetailsCurrXX = Number(x);
				objCLM.distDetailsCurrYY = Number(y);
				objCLM.distDetailsCurrRow = objCLM.distDetailsTG.getRow(objCLM.distDetailsCurrYY);
				showPLADetails(objCLM.distDetailsCurrRow.claimId, String(objCLM.distDetailsCurrRow.grpSeqNo), String(objCLM.reserveDetailsRow.clmResHistId), String(objCLM.distDetailsCurrRow.shareType));
				if (objCLM.distDetailsCurrRow.dspShrLossResAmt == null && objCLM.distDetailsCurrRow.dspShrExpResAmt){
					disableButton("btnCancelPLA");
				}else{
					enableButton("btnCancelPLA");	
				}
				objCLM.distDetailsTG.keys.removeFocus(objCLM.distDetailsTG.keys._nCurrentFocus, true); // andrew - 12.13.2012
				objCLM.distDetailsTG.keys.releaseKeys();
			},
			beforeClick: function(){ //Added by: Jerome Cris 03032015
				if(changeTag == 1){
					showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
					return false;
				}
			},
			beforeSort: function(){
				if (changeTag == 1){
					showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
					return false;
				}
			},
			prePager: function(){
				if (changeTag == 1){
					showMessageBox(objCommonMessage.SAVE_CHANGES,"I");
					return false;
				}
			},
			onSort: function(){
				if(changeTag == 1){
					showMessageBox(objCommonMessage.SAVE_CHANGES,"I");
					return false;
				}
			},
			onRemoveRowFocus: function ( x, y, element) {
				objCLM.distDetailsCurrXX = null;
				objCLM.distDetailsCurrYY = null;
				objCLM.distDetailsCurrRow = null;
				showPLADetails("", "", "", "");
				objCLM.distDetailsTG.keys.removeFocus(objCLM.distDetailsTG.keys._nCurrentFocus, true);
				objCLM.distDetailsTG.keys.releaseKeys(); //used releaseKeys to be able to use Enter key in Text Editor by MAC 05/08/2013
			} 	
		},
		columnModel: [
			{
			    id: 'recordStatus',
			    title : '&nbsp;',
             	altTitle: '',
	            width: '0',
	            visible: false,
	            editor: "checkbox",
	            editable: true,
	            hideSelectAllBox: true,
	            sortable: false
			},
			{
				id: 'divCtrId',
				width: '0',
				visible: false
			},
			{
				id: 'claimId',
				width: '0',
				visible: false
			},
			{
				id: 'clmResHistId',
				width: '0',
				visible: false
			},
			{
				id: 'distYear',
				width: '0',
				visible: false
			},
			{
				id: 'clmDistNo',
				width: '0',
				visible: false
			},
			{
				id: 'itemNo',
				width: '0',
				visible: false
			},
			{
				id: 'perilCd',
				width: '0',
				visible: false
			},
			{
				id: 'grpSeqNo',
				width: '0',
				visible: false
			},
			{
				id: 'lineCd',
				width: '0',
				visible: false
			},
			{
				id: 'userId',
				width: '0',
				visible: false
			},
			{
				id: 'acctTrtyType',
				width: '0',
				visible: false
			},
			{
				id: 'lastUpdate',
				width: '0',
				visible: false
			},
			{
				id: 'shareType',
				width: '0',
				visible: false
			},
			{
				id: 'histSeqNo',
				width: '0',
				visible: false
			},
			{
				id: 'dspTrtyName',
				title: 'Treaty Name',
				width: '230',
				visible: true
			},
			{
				id: 'shrPct',
				title: 'Share Percentage',
				titleAlign: 'right',
				type: 'number',
				geniisysClass: 'money',
				width: '130',
				visible: true
			},
			{
				id: 'dspShrLossResAmt',
				title: 'Share Loss Reserve Amt.',
				width: '200',
				titleAlign: 'right',
				type: 'number',
				geniisysClass: 'money',
				visible: true
			},
			{
				id: 'dspShrExpResAmt',
				title: 'Share Expense Reserve Amt.',
				width: '200',
				titleAlign: 'right',
				type: 'number',
				geniisysClass: 'money',
				visible: true
			}
		],
		resetChangeTag: true,
		rows: objCLM.distDetailsRows,
		id: 2
	};
	
	objCLM.distDetailsTG = new MyTableGrid(objCLM.distDetailsTM);
	objCLM.distDetailsTG.pager = objCLM.distDetailsGrid;
	objCLM.distDetailsTG._mtgId = 2;
	objCLM.distDetailsTG.afterRender = function(){
		if (objCLM.distDetailsTG.rows.length > 0){
			objCLM.distDetailsCurrYY = Number(0);
			objCLM.distDetailsTG.selectRow('0');
			objCLM.distDetailsCurrRow = objCLM.distDetailsTG.getRow(objCLM.distDetailsCurrYY);
			showPLADetails(objCLM.distDetailsCurrRow.claimId, String(objCLM.distDetailsCurrRow.grpSeqNo), String(objCLM.reserveDetailsRow.clmResHistId), String(objCLM.distDetailsCurrRow.shareType))
			if (objCLM.distDetailsCurrRow.dspShrLossResAmt == null && objCLM.distDetailsCurrRow.dspShrExpResAmt){
				disableButton("btnCancelPLA");
			}else{
				enableButton("btnCancelPLA");	
			}
		}else{
			showPLADetails("", "", "", "");
		}	
	};	
	objCLM.distDetailsTG.render('distDetailsGrid');
	
	hideNotice("");
}catch(e){
	showErrorMessage("PLA - Distributuin Details page.", e);
}
</script>	