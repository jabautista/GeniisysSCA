<div id="adjusterHistMainDiv" name="adjusterHistMainDiv" style="width: 825px; margin-top:5px;" class="sectionDiv">
	<table style="margin: 10px 0px;">
		<tr>
			<td class="rightAligned" style="width: 145px;">Adjusting Company</td>
			<td class="leftAligned" style="padding-left: 10px;">
				<input id="txtAdjCompanyCd" 	name="txtAdjCompanyCd" 	type="text" style="width: 50px;"  value="${adjCompanyCd}" readonly="readonly"/>
				<input id="txtAdjCompanyName" 	name="txtAdjCompName" 	type="text" style="width: 200px;"  readonly="readonly" />
			</td>
			<td class="rightAligned" style="width: 82px;">Adjuster</td>
			<td class="leftAligned" style="padding-left: 10px;">
				<input id="txtPrivAdjCd"   	name="txtPrivAdjCd" 	type="text" style="width: 50px;"  value="${privAdjCd}"   readonly="readonly"/>
				<input id="txtPrivAdjName" 	name="txtPrivAdjName" 	type="text" style="width: 200px;" value="${privAdjName}" readonly="readonly" />
			</td>
		</tr>
	</table>
	<div id="adjusterHistTableGridDiv" align="center">
		<div id="adjusterHistGridDiv" style="height: 215px; margin-top: 10px;">
			<div id="adjusterHistTableGrid" style="height: 206px; width: 760px;"></div>
		</div>
		<div align="center" style="margin:15px;">
			<input type="button" id="btnExitAdjHist" name="btnExitAdjHist" style="width: 120px;" class="button hover"  value="Return" />
		</div>
	</div>
</div>

<script type="text/javascript">
try{
	$("txtAdjCompanyName").value = unescapeHTML2('${adjCompanyName}'); //moved retrieving of value to handle special characters by robert 10.26.2013
	objAdjHist = JSON.parse('${jsonAdjusterHist}'.replace(/\\/g, '\\\\'));
	objAdjHist.adjHistList = objAdjHist.rows || [];
	
	var adjHistTableModel = {
			url: contextPath+"/GICLClmAdjHistController?action=showGICLS260ClmAdjusterHistory"+
					"&claimId=" + objCLMGlobal.claimId+
					"&adjCompanyCd="+$("txtAdjCompanyCd").value+
					"&privAdjCd="+$("txtPrivAdjCd").value,
			options:{
				hideColumnChildTitle: true,
				pager: {},
				onCellFocus: function(element, value, x, y, id){
					adjHistTableGrid.keys.removeFocus(adjHistTableGrid.keys._nCurrentFocus, true);
					adjHistTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus: function ( x, y, element) {
					adjHistTableGrid.keys.removeFocus(adjHistTableGrid.keys._nCurrentFocus, true);
					adjHistTableGrid.keys.releaseKeys();
				}
			},
			columnModel : [
		   			{ 							
		   				id: 'recordStatus',
		   			  	width: '0',
		   			  	visible: false
		   			},
		   			{
		   				id: 'divCtrId',
		   			  	width: '0',
		   			  	visible: false 
		   		 	}, 
		   		 	{
						id: 'strAssignDate',
						title: 'Date Assigned',
						width: '120px',
						sortable: true,
						align: 'left',
						visible: true
					},
					{
						id: 'strCompltDate',
						title: 'Date Completed',
						width: '120px',
						sortable: true,
						align: 'left',
						visible: true
					},
					{
						id: 'strCancelDate',
						title: 'Date Cancelled',
						width: '120px',
						sortable: true,
						align: 'left',
						visible: true
					},
					{
						id: 'strDeleteDate',
						title: 'Date Deleted',
						width: '120px',
						sortable: true,
						align: 'left',
						visible: true
					},
					{
						id: 'userId',
						title: 'User Id',
						width: '120px',
						sortable: true, 
						visible: true
					},
					{
						id: 'strLastUpdate',
						title: 'Last Update',
						width: '131px',
						sortable: true,
						align: 'left',
						visible: true
					},
					{
					    id: 'claimId',
					    title: '',
					    width: '0',
					    visible: false
					 }
				],
			rows : objAdjHist.adjHistList,
		};  
	
	adjHistTableGrid = new MyTableGrid(adjHistTableModel);
	adjHistTableGrid.pager = objAdjHist;
	adjHistTableGrid.render('adjusterHistTableGrid');
	
	$("btnExitAdjHist").observe("click", function(){
		Windows.close("clm_adj_hist_canvas");	
	});
	
	hideNotice("");
}catch(e){
	showErrorMessage("Claim Information - Adjuster History", e);
}	
</script>