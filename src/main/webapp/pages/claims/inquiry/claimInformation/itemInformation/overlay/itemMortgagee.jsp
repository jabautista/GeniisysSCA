<div id="itemMortgageeMainDiv" name="mortgageeMainDiv">
	<div id="itemMortgageeTableGridDiv" align="center">
		<div id="itemMortgageeGridDiv" style="height: 230px; margin-top: 5px;">
			<div id="itemMortgageeTableGrid" style="height: 206px; width: 580px;"></div>
		</div>
		<div class="buttonsDiv" align="center" style="margin-bottom: 5px;">
			<input type="button" id="btnOk" name="btnOk" style="width: 120px;" class="button hover" value="Return" />
		</div>
	</div>
</div>

<script type="text/javascript">
	try {
		objItemMortgagee = JSON.parse('${giclMortgagee}'.replace(/\\/g, '\\\\'));
		objItemMortgagee.mortgageeList = objItemMortgagee.rows || [];
 
		var itemMortgageeTableModel = {
				url: contextPath+"/GICLMortgageeController?action=showGICLS260ItemMortgagee&claimId=" + objCLMGlobal.claimId+
						"&itemNo="+$("txtItemNo").value,
				options:{
					title: '',
					width: '580px',
					toolbar: {
						elements: [MyTableGrid.REFRESH_BTN],
						onRefresh: function(){
							itemMortgageeTableGrid.keys.removeFocus(itemMortgageeTableGrid.keys._nCurrentFocus, true);
							itemMortgageeTableGrid.keys.releaseKeys();
						}
					},
					onCellFocus: function(element, value, x, y, id){
						itemMortgageeTableGrid.keys.removeFocus(itemMortgageeTableGrid.keys._nCurrentFocus, true);
						itemMortgageeTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus: function() {
						itemMortgageeTableGrid.keys.removeFocus(itemMortgageeTableGrid.keys._nCurrentFocus, true);
						itemMortgageeTableGrid.keys.releaseKeys();
					},
					onSort: function() {
						itemMortgageeTableGrid.keys.removeFocus(itemMortgageeTableGrid.keys._nCurrentFocus, true);
						itemMortgageeTableGrid.keys.releaseKeys();
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
				rows: objItemMortgagee.mortgageeList
		};
	
		itemMortgageeTableGrid = new MyTableGrid(itemMortgageeTableModel);
		itemMortgageeTableGrid.pager = objItemMortgagee;
		itemMortgageeTableGrid.render('itemMortgageeTableGrid');
			
	} catch(e){
		showErrorMessage("Claim Information - Item Mortgagee", e);
	}

	$("btnOk").observe("click", function(){
		Windows.close("item_mortg_canvas");
	});
		
</script>