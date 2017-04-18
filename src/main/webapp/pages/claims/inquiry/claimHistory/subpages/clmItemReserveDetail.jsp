
<div id="claimItemReserveDetails" style="height:200px;">
		<div id="claimItemResTableGridDiv" style="padding:10px;height:200px;">
			<div id="claimItemResListing" style="height:156px;width:100%;"></div>
		</div>
</div>
<script>
	var objItem = new Object();
	var itemResTableGrid;
	objItem.objItemResListTableGrid = JSON.parse('${claimItemResDetailTableGrid}'.replace(/\\/g, '\\\\'));
	objItem.objItemResList = objItem.objItemResListTableGrid.rows || [];
	
	function showHistPerilsTbleGICLS254(claimId, itemNo, perilCd, groupedItemNo){
		try{
			new Ajax.Updater("clmHistDetailListGrid", contextPath+"/GICLClaimsController",{
				parameters:{
					action: "getClmItemHistDtls",
					claimId: objCLMGlobal.selectedRow.claimId,
					itemNo: objCLMGlobal.selectedRow.itemNo,
					perilCd: objCLMGlobal.selectedRow.perilCd,
					groupedItemNo: objCLMGlobal.selectedRow.groupedItemNo
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)) {
						 null;
					}
				}
			});
		}catch(e){
			showErrorMessage("showHistPerilsTbleGICLS254", e);	
		}
	}
	
	function initializeGrid(){
		try{
			var itemResTableModel = {
				url:contextPath+"/GICLClaimsController?action=getClaimItemResDtls&refresh=1&claimId="+ objCLMGlobal.claimId ,
				options:{
						title: '',
						width: '900px',
						hideColumnChildTitle: true,
						onCellFocus: function(element, value, x, y, id){
							objCLMGlobal.selectedRow = itemResTableGrid.geniisysRows[y];
							showHistPerilsTbleGICLS254();
							itemResTableGrid.keys.removeFocus(itemResTableGrid.keys._nCurrentFocus, true);
							itemResTableGrid.keys.releaseKeys();
						},
						onRemoveRowFocus:function(element, value, x, y, id){
							//unloadItemInfo();
							objCLMGlobal.selectedRow = '';
						}
					
				},columnModel:[{
					id : 'recordStatus',
					title : '',
					width : '0',
					visible : false,
					editor : 'checkbox'
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				}, 
				{
					id : 'claimId',
					width : '0',
					visible : false
				}, 
				{
					id : 'groupedItemNo',
					width : '0',
					visible : false
				}, 
				{
					id : 'itemNo itemTitle',
					title : 'Item',
					width : '250px',
					sortable : false,					
					children : [
						{
							id : 'itemNo',							
							width : 50,							
							sortable : false,
							editable : false,	
							align: 'right'
						},
						{
							id : 'itemTitle',							
							width : 200,
							sortable : false,
							editable : false
						}
					            ]					
				},	
				{
					id : 'perilCd perilName',
					title : 'Peril',
					width : '250',
					sortable : false,					
					children : [
						{
							id : 'perilCd',							
							width : 50,							
							sortable : false,
							editable : false,	
							align: 'right'
						},
						{
							id : 'perilName',							
							width : 200,
							sortable : false,
							editable : false
						}
					            ]					
				}, 
				{
					id : 'lossReserve',
					title : 'Loss Reserve',
					titleAlign : 'center',
					type : 'number',
					width : '190px',
					geniisysClass : 'money',
					filterOption : true,
					filterOptionType : 'number'
				}, 
				{
					id : 'expenseReserve',
					title : 'Expense Reserve',
					titleAlign : 'center',
					type : 'number',
					width : '190px',
					geniisysClass : 'money',
					filterOption : true,
					filterOptionType : 'number'
				}],
				rows:objItem.objItemResList
			};

			itemResTableGrid = new MyTableGrid(itemResTableModel);
			//itemResTableGrid.pager = objItem.objItemResListTableGrid;

		}catch(e){
			showErrorMessage("initializeGrid", e);
		}
	}
	
	initializeGrid();
	if(nvl(objCLMGlobal.claimId, null) != null){
 		if (itemResTableGrid.geniisysRows.length == 0) {
			customShowMessageBox("Query caused no records to be retrieved. Re-enter.", imgMessage.INFO, "txtNbtClmLineCd");
		}
	}

	itemResTableGrid.render('claimItemResListing');

</script>