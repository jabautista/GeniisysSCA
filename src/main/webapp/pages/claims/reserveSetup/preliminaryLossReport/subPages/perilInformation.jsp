<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="perilInfoDiv" name="perilInfoDiv" class="sectionDiv" style="height: 252px; padding: 15px 15px 15px 15px; width: 891px;">
	<div id="perilInfoTableGrid" name="perilInfoTableGrid" style="height: 220px;"></div>
	<div id="buttonsDiv" name="buttonsDiv" class="buttonsDiv">
		<table align="center">
			<tr>
				<td><input type="button" class="button" style="width: 100px;" id="btnRiTsi" name="btnRiTsi" value="RI TSI"></td>
				<td><input type="button" class="button" style="width: 120px;" id="btnRiRes" name="btnRiRes" value="RI Reserve"></td>
			</tr>
		</table>
	</div>
</div>

<script type="text/javascript">
	var selectedIndex = -1;
	var objTGPerilInfoDetails = JSON.parse('${perilInfoTableGrid}'.replace(/\\/g,'\\\\'));
	var claimId = '${claimId}';
	var prelim = '${prelim}';
	var arrGICLS029Buttons = [MyTableGrid.REFRESH_BTN];
	var path = null;
	
	if(prelim == 'Y'){
		path = "/GICLReserveSetupController?action=getPerilInformation&refresh=1&claimId=${claimId}&lineCd=${lineCd}&prelim=${prelim}";
	}else if(prelim == 'N'){
		path = "/GICLReserveSetupController?action=getFinalPerilInformation&refresh=1&claimId=${claimId}&lineCd=${lineCd}&adviceId=${adviceId}&prelim=${prelim}";
	}
	
	try{
		var perilInfoModel = {
			url: contextPath+path,
			options: {
				title: '',
	          	height: '200px',
	          	width: '888px',
	          	onCellFocus: function(element, value, x, y, id){
            		selectedIndex = y;
            		perilInfoTableGrid.keys.releaseKeys();
	            },
	            onRemoveRowFocus: function(){
	            	selectedIndex = -1;
	            	perilInfoTableGrid.keys.releaseKeys();
	            },
	            onSort: function() {
	            	
	            },
	            onRefresh: function() {
	            	selectedIndex = -1;
	            },
	            toolbar: {
	            	elements:	(arrGICLS029Buttons)
	            }
			},
			columnModel:[
						{
							id: 'recordStatus',
						    width: '0px',
						    visible: false,
						    editor: 'checkbox' 			
						},
						{	
							id: 'divCtrId',
							width: '0px',
							visible: false
						},
						{
							id:	'dspPerilName',
							title: 'Peril Name',
							titleAlign: 'center',
							width: '150px',
							sortable: false
						},
						{
							id:	'annTsiAmt2',
							title: 'TSI Amt.',
							titleAlign: 'right',
							geniisysClass: 'money',
							align: 'right',
							width: '90px',
							sortable: false
						},
						{
							id:	'tsiTrty',
							title: 'Share Type',
							titleAlign: 'center',
							width: '119px',
							sortable: false
						},
						{
							id:	'shrTsiPct',
							title: 'Dist. Share',
							titleAlign: 'right',
							geniisysClass: 'rate',
							align: 'right',
							width: '100px',
							sortable: false
						},
						{
							id:	'trtyTsi',
							title: 'Share Amount',
							titleAlign: 'right',
							geniisysClass: 'money',
							align: 'right',
							width: '100px',
							sortable: false
						},
						{
							id:	'reserveAmt',
							title: 'Reserve',
							titleAlign: 'right',
							geniisysClass: 'money',
							align: 'right',
							width: '90px',
							sortable: false
						},
						{
							id:	'resTrty',
							title: 'Share Type',
							titleAlign: 'center',
							width: '119px',
							sortable: false
						},
						{
							id:	'shrPct',
							title: 'Dist. Share',
							titleAlign: 'right',
							geniisysClass: 'rate',
							align: 'right',
							width: '100px',
							sortable: false
						},
						{
							id:	'trtyReserve',
							title: 'Share Amount',
							titleAlign: 'right',
							geniisysClass: 'money',
							align: 'right',
							width: '100px',
							sortable: false
						},
						{	
							id: 'shareCd',
							width: '0px',
							visible: false
						},
						{	
							id: 'perilCd',
							width: '0px',
							visible: false
						}
  					],
  				rows: objTGPerilInfoDetails.rows,
  				id: 1116
		};
		perilInfoTableGrid = new MyTableGrid(perilInfoModel);
		perilInfoTableGrid.pager = objTGPerilInfoDetails;
		perilInfoTableGrid.render('perilInfoTableGrid');
	}catch(e){
		showMessageBox("Error in Peril Information: " + e, imgMessage.ERROR);		
	}
	
	$("btnRiTsi").observe("click", function(){
		if(selectedIndex > -1){
	    	perilInfoTableGrid.keys.releaseKeys();
			showReinsurance(claimId, perilInfoTableGrid.geniisysRows[selectedIndex].shareCd, perilInfoTableGrid.geniisysRows[selectedIndex].perilCd, "RI TSI");	
		}else{
			showMessageBox("Please select a distribution first.", imgMessage.ERROR);
		}
	});
	
	$("btnRiRes").observe("click", function(){
		if(selectedIndex > -1){
	    	perilInfoTableGrid.keys.releaseKeys();
			if('${prelim}' == 'Y'){
				showRiRes(claimId, perilInfoTableGrid.geniisysRows[selectedIndex].shareCd, perilInfoTableGrid.geniisysRows[selectedIndex].perilCd, "RI Reserve");
			}else if('${prelim}' == 'N'){
				showFinalRiRes(claimId, '${adviceId}', perilInfoTableGrid.geniisysRows[selectedIndex].shareCd, '${prelim}', perilInfoTableGrid.geniisysRows[selectedIndex].perilCd, "RI Reserve");
			} 
		}else{
			showMessageBox("Please select a distribution first.", imgMessage.ERROR);
		}
	});
</script>