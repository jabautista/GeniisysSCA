<div id="itemReserveInfoTGSectionDiv" style="margin: 10px;">
	<div id="itemReserveDetails" style="height:170px;" class="sectionDiv">
		<div id="itemReserveTableGridDiv" style="padding:5px;height:200px;">
			<div id="itemReserveListing" style="height:156px;width:100%;"></div>
		</div>
	</div>
</div>

<div id="reserveDistributionTableGridSectionDiv" style="margin: 10px;">
	<div id="resDistListingDiv" name="resDistListingDiv" style="height:170px;" class="sectionDiv">
		<div id="resDistListingTableGridDiv" style="padding:5px;height:200px;">
			<div id="resDistListingGrid" style="height:156px;width:100%;"></div>					
		</div>
	</div>
</div>

<div id="resDistReinsurersTableGridSectionDiv" style="margin: 10px;">
	<div id="resDistRIListingDiv" name="resDistListingDiv" style="height:170px;" class="sectionDiv">
		<div id="resDistRIListingTableGridDiv" style="padding:5px;height:200px;">
			<div id="resDistRIListingGrid" style="height:156px;width:100%;"></div>					
		</div>
	</div>
</div>

<script type="text/javascript">
var objItem = new Object();
objItem.objItemResListTableGrid = JSON.parse('${itemReserveInfoTableGrid}');
objItem.objItemResList = objItem.objItemResListTableGrid.rows;
	
function initializeItemResTableGrid(){
	try{
		var itemResTableModel = {
			url:contextPath+"/GICLClaimsController?action=getItemReserveInfo&refresh=1&claimId=" + objCLMGlobal.claimId ,
			id: 10,
			options:{
					title: '',
					width: '890px',
					hideColumnChildTitle: true,
					pager: {},
					onCellFocus: function(element, value, x, y, id){
						var obj = itemResTableGrid.geniisysRows[y];
						objCLMGlobal.clmResHistId = obj.clmResHistId;
						openResDisListing();
						reinsurersListing();
						itemResTableGrid.keys.removeFocus(itemResTableGrid.keys._nCurrentFocus, true);
						itemResTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus : function() {
						objCLMGlobal.clmResHistId = "";
						openResDisListing();
						reinsurersListing();
						itemResTableGrid.keys.removeFocus(itemResTableGrid.keys._nCurrentFocus, true);
						itemResTableGrid.keys.releaseKeys();
					},
					onSort : function() {
						reserveDistributionListing();
						reinsurersListing();
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
				id : 'claimResHistId',
				width : '0',
				visible : false
			}, 				
			{
				id : 'groupedItemNo',
				width : '0',
				visible : false
			}, 
			{
				id : 'itemTitle',
				title : 'Item',
				width : '245px',
				/* children : [
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
				            ]		 */			
			},	
			{
				id : 'perilName',
				title : 'Peril',
				width : '245px',
				/* children : [
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
				            ]	 */				
			}, 
			{
				id : 'lossReserve',
				title : 'Loss Reserve',
				titleAlign : 'center',
				type : 'number',
				width : '188px',
				geniisysClass : 'money',
			}, 
			{
				id : 'expenseReserve',
				title : 'Expense Reserve',
				titleAlign : 'center',
				type : 'number',
				width : '188px',
				geniisysClass : 'money',
			}],
			rows:objItem.objItemResList
		};
		itemResTableGrid = new MyTableGrid(itemResTableModel);
		itemResTableGrid.pager = objItem.objItemResListTableGrid;
		itemResTableGrid.render('itemReserveListing');
	}catch(e){
		showErrorMessage("initializeItemResTableGrid", e);
	}
}
function openResDisListing(){
	reserveDistGrid.url = contextPath + "/GICLClaimsController?action=getReserveDs&refresh=1&claimId="+objCLMGlobal.claimId+"&clmResHistId="+objCLMGlobal.clmResHistId;
	reserveDistGrid._refreshList();
}

function reserveDistributionListing(){
	try{
		var reserveDistTableModel = {
			id: 20,
			url : contextPath + "/GICLClaimsController?action=getReserveDs&refresh=1&claimId="+objCLMGlobal.claimId+"&clmResHistId="+objCLMGlobal.clmResHistId,
			options : {
				title : '',
				width : '890px',
				pager: {}, 
				hideColumnChildTitle: true,
				onCellFocus : function(element, value, x, y, id) {
					var obj = reserveDistGrid.geniisysRows[y];
					objCLMGlobal.grpSeqNo = obj.grpSeqNo;
					objCLMGlobal.clmDistNo = obj.clmDistNo;
					openReinsurerListing();
					reserveDistGrid.keys.removeFocus(reserveDistGrid.keys._nCurrentFocus, true);
					reserveDistGrid.keys.releaseKeys();
				},
				onRemoveRowFocus : function() {
					reinsurersListing();
					reserveDistGrid.keys.removeFocus(reserveDistGrid.keys._nCurrentFocus, true);
					reserveDistGrid.keys.releaseKeys();
				},
				onSort : function() {
					reinsurersListing();
					reserveDistGrid.keys.removeFocus(reserveDistGrid.keys._nCurrentFocus, true);
					reserveDistGrid.keys.releaseKeys();
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
					id : 'clmResHistId',
					width : '0',
					visible : false
				},
				{
					id : 'clmDistNo',
					width : '0',
					visible : false
				},
				{
					id : 'grpSeqNo',
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
					id : 'lineCd',
					width : '0',
					visible : false
				},
				{
		            id: 'trtyName',
		            title: 'Treaty Name',
		            width: '243px',
		            visible: true,
		            editable: false
		        },
			   	{
					id: 'shrPct',
					title: 'Share Percent',
					width : '90px',
					titleAlign : 'center',
					visible: true,
					type: 'number'
				},
			   	{
					id: 'distYr',
					title: 'Dist Year',
					width : '75px',
					visible: true,
					type: 'number'
				},
				{
					id : 'shrLossResAmt',
					title : 'Treaty Share Loss Amount',
					titleAlign : 'center',
					type : 'number',
					width : '225px',
					geniisysClass : 'money',
					visible: true
				}, 
				{
					id : 'shrExpResAmt',
					title : 'Treaty Share Expense Amount',
					titleAlign : 'center',
					type : 'number',
					width : '225px',
					geniisysClass : 'money',
					visible: true
				}
			],
			rows : []
		};
		reserveDistGrid = new MyTableGrid(reserveDistTableModel);
		reserveDistGrid.render('resDistListingGrid');
	}catch(e){
		showErrorMessage("Claims Distribution - Reserve Distribution", e);
	}
}

function openReinsurerListing(){
	reserveDistRITableGrid.url = contextPath + "/GICLClaimsController?action=getReserveDsRI&refresh=1&claimId="+objCLMGlobal.claimId+"&clmResHistId="+objCLMGlobal.clmResHistId+"&grpSeqNo="+objCLMGlobal.grpSeqNo+"&clmDistNo="+objCLMGlobal.clmDistNo;
	reserveDistRITableGrid._refreshList();	
}

function reinsurersListing(){	
	try{
		var reserveDistRITableModel = {
			url : contextPath + "/GICLClaimsController?action=getReserveDsRI&refresh=1",
			id: 30,
			options : {
				title : '',
				width : '890px',
				pager: {}, 
				hideColumnChildTitle: true,
				onCellFocus : function(element, value, x, y, id) {
					reserveDistRITableGrid.keys.removeFocus(reserveDistGrid.keys._nCurrentFocus, true);
					reserveDistRITableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus : function() {
					reserveDistRITableGrid.keys.removeFocus(reserveDistGrid.keys._nCurrentFocus, true);
					reserveDistRITableGrid.keys.releaseKeys();
				},
				onSort : function() {
					reserveDistRITableGrid.keys.removeFocus(reserveDistGrid.keys._nCurrentFocus, true);
					reserveDistRITableGrid.keys.releaseKeys();
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
					id : 'clmResHistId',
					width : '0',
					visible : false
				},
				{
					id : 'clmDistNo',
					width : '0',
					visible : false
				},
				{
					id : 'grpSeqNo',
					width : '0',
					visible : false
				},				
				{
					id : 'lineCd',
					width : '0',
					visible : false
				},
				{
					id : 'riCd',
					title: 'RI Code',
					width : '50px',
					editable: false
				},				
				{
		            id: 'riName',
		            title: 'Reinsurer',
		            width: '272px',
		            editable: false
		        },
			   	{
					id: 'shrRIPct',
					title: 'Share Percent',
					width : '90px',
					type: 'number'
				},
				{
					id : 'shrLossRIResAmt',
					title : 'Share Loss Reserve Amount',
					titleAlign : 'center',
					type : 'number',
					width : '225px',	
					geniisysClass : 'money'
				}, 
				{
					id : 'shrExpRIResAmt',
					title : 'Share Expense Reserve Amount',
					titleAlign : 'center',
					type : 'number',
					width : '225px',
					geniisysClass : 'money'
				}
			],
			rows : []
		};
			
		reserveDistRITableGrid = new MyTableGrid(reserveDistRITableModel);
		reserveDistRITableGrid.render('resDistRIListingGrid');
		//reserveDistRITableGrid.pager = objItem.objResDisRITableGrid;
	}catch(e){
		showErrorMessage("Claims Distribution - Reserve RI Distribution", e);
	}
}

initializeItemResTableGrid();
reserveDistributionListing();
reinsurersListing();

</script>