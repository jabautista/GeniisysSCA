
<div id="claimItemHistDetails" style="height:200px;">
		<div id="claimItemHistTableGridDiv" style="padding:10px;height:200px;">
			<div id="claimItemHistListing" style="height:156px;width:100%;"></div>
		</div>
</div>
<script>
	var objItem = new Object();
	var itemHistTableGrid;
	objItem.objItemHistTableGrid = JSON.parse('${claimItemHistDetailTableGrid}'.replace(/\\/g, '\\\\'));
	objItem.objItemHist = objItem.objItemHistTableGrid.rows || [];
	
	function initializeGrid2(){
		try{
			var itemHistTableModel = {
				url:contextPath+"/GICLClaimsController?action=getClmItemHistDtls&refresh=1&claimId=" + objCLMGlobal.selectedRow.claimId + "&itemNo=" + objCLMGlobal.selectedRow.itemNo
						+ "&perilCd=" + objCLMGlobal.selectedRow.perilCd + "&groupedItemNo=" + objCLMGlobal.selectedRow.groupedItemNo ,
				options:{
						title: '',
						width: '900px',
						hideColumnChildTitle: true
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
					id : 'itemNo',
					width : '0',
					visible : false
				}, 				
				{
					id : 'perilCd',
					width : '0',
					visible : false
				}, 				
				{
					id : 'histSeqNo',
					title : 'History No.',
					width : '100',
					sortable : true								
				},	
				{
					id : 'itemStatCd',
					title : 'Status',
					width : '50',
					sortable : true							
				}, 
				{
					id : 'distSw',
					title : 'D',
					width : '25',
					sortable : true							
				}, 				
				{
					id : 'paidAmt',
					title : 'Paid Amount',
					titleAlign : 'center',
					type : 'number',
					width : '100px',
					geniisysClass : 'money',
					filterOption : true,
					filterOptionType : 'number'
				}, 
				{
					id : 'netAmt',
					title : 'Net Amount',
					titleAlign : 'center',
					type : 'number',
					width : '100px',
					geniisysClass : 'money',
					filterOption : true,
					filterOptionType : 'number'
				},
				{
					id : 'adviseAmt',
					title : 'Advise Amount',
					titleAlign : 'center',
					type : 'number',
					width : '100px',
					geniisysClass : 'money',
					filterOption : true,
					filterOptionType : 'number'
				},				
				{
					id : 'payeeType',
					title : 'P',
					width : '25',
					sortable : true							
				}, 		
				{
					id : 'payeeClassCd',
					title : 'Class Cd',
					width : '100',
					sortable : true							
				}, 		
				{
					id : 'payeeCd',
					title : 'Payee No.',
					width : '100',
					sortable : true							
				}, 		
				{
					id : 'payeeName',
					title : 'Payee Name',
					width : '200',
					sortable : true							
				}		
				],
				rows:objItem.objItemHist
			};

			itemHistTableGrid = new MyTableGrid(itemHistTableModel);
			//itemHistTableGrid.pager = objItem.objItemHistTableGrid;

		}catch(e){
			showErrorMessage("initializeGrid2", e);
		}
	}

	initializeGrid2();
	itemHistTableGrid.render('claimItemHistListing');
</script>