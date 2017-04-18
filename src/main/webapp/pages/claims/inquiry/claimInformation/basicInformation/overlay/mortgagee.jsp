<div id="mortgageeMainDiv" name="mortgageeMainDiv">
	<div id="mortgageeTableGridDiv" align="center">
		<div id="mortgageeGridDiv" style="height: 230px; margin-top: 5px;">
			<div id="mortgageeTableGrid" style="height: 206px; width: 580px;"></div>
		</div>
		<div class="buttonsDiv" align="center" style="margin-bottom: 5px;">
			<input type="button" id="btnOk" name="btnOk" style="width: 120px;" class="button hover" value="Return" />
		</div>
	</div>
</div>

<script type="text/javascript">
	try {
		objClaimMortgagee = JSON.parse('${jsonClaimMortgagee}'.replace(/\\/g, '\\\\'));
		objClaimMortgagee.mortgageeList = objClaimMortgagee.rows || [];
 
		var mortgageeTableModel = {
				url: contextPath+"/GICLClaimsController?action=showGICLS260TableGridPopup&action1=getGiclMortgageeGrid&itemNo=0&claimId=" + objCLMGlobal.claimId,
				options:{
					title: '',
					width: '580px',
					onCellFocus: function(element, value, x, y, id){
						mortgageeTableGrid.keys.removeFocus(mortgageeTableGrid.keys._nCurrentFocus, true);
						mortgageeTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus: function() {
						mortgageeTableGrid.keys.removeFocus(mortgageeTableGrid.keys._nCurrentFocus, true);
						mortgageeTableGrid.keys.releaseKeys();
					},
					onSort: function() {
						mortgageeTableGrid.keys.removeFocus(mortgageeTableGrid.keys._nCurrentFocus, true);
						mortgageeTableGrid.keys.releaseKeys();
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
						id: 'mortgCd',
						title: 'Code',
						width: '120px',
						sortable: true,
						align: 'left',
						visible: true
					},	
	
					{
						id: 'nbtMortgNm',
						title: 'Mortgagee',
						width: '310px',
						sortable: true,
						align: 'left',
						visible: true
					},	
							
					{
						id: 'amount',
						title: 'Amount',
						width: '138px',
						sortable: true,
						align: 'right',
						geniisysClass: "money",
						visible: true
					},
				],
				resetChangeTag: true,
				rows: objClaimMortgagee.mortgageeList
		};
	
		mortgageeTableGrid = new MyTableGrid(mortgageeTableModel);
		mortgageeTableGrid.pager = objClaimMortgagee;
		mortgageeTableGrid.render('mortgageeTableGrid');
			
	} catch(e){
		showErrorMessage("Claim Information - mortgagee.jsp", e);
	}

	$("btnOk").observe("click", function(){
		Windows.close("modal_dialog_lov");
	});
		
</script>