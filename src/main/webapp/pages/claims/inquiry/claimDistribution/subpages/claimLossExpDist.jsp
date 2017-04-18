<div id="lossExpInfoTGSectionDiv" style="margin: 10px;">
	<div id="lossExpInfoSectionDiv" name="lossExpInfoSectionDiv" style="height:170px;" class="sectionDiv">
		<div id="lossExpInfoTableGridDiv" style="padding:5px;height:200px;">
			<div id="lossExpInfoListing" style="height:156px;width:100%;"></div>
		</div>
	</div>
</div>

<div id="lossExpDistributionTableGridSectionDiv" style="margin: 10px;">
	<div id="lossDistListingDiv" name="lossDistListingDiv" style="height:170px;" class="sectionDiv">
		<div id="lossDistListingTableGridDiv" style="padding:5px;height:200px;">
			<div id="lossDistListingGrid" style="height:156px;width:100%;"></div>					
		</div>
	</div>
</div>

<div id="lossExpDistReinsurersTableGridSectionDiv" style="margin: 10px;">
	<div id="lossDistRIListingDiv" name="lossDistRIListingDiv" style="height:170px;" class="sectionDiv">
		<div id="lossDistRIListingTableGridDiv" style="padding:5px;height:200px;">
			<div id="lossDistRIListingGrid" style="height:156px;width:100%;"></div>					
		</div>
	</div>
</div>

<script type="text/javascript">
	var objItem = new Object();
	objItem.objItemLossExpTableGrid = JSON.parse('${lossExpInfoTableGrid}'.replace(/\\/g, '\\\\'));
	objItem.objItemLossExp = objItem.objItemLossExpTableGrid.rows;
	
	function initializelossExpInfoTableGrid(){
		try{
			var itemLossExpTableModel = {
				url:contextPath+"/GICLClaimsController?action=getClmLossExpInfo&refresh=1&claimId="+objCLMGlobal.claimId+"&lineCd="+objCLMGlobal.lineCd ,
				id : 40,
				options:{
						title: '',
						width: '890px',
						hideColumnChildTitle: true,
						pager: {},
						onCellFocus: function(element, value, x, y, id){
							var obj = lossExpTable.geniisysRows[y];
							objCLMGlobal.clmLossId = obj.clmLossId;
							objCLMGlobal.itemNo = obj.itemNo;
							objCLMGlobal.perilCd = obj.perilCd;
							openLossExpDistList();
							showLossExpDistRIListing();
							lossExpTable.keys.removeFocus(lossExpTable.keys._nCurrentFocus, true);
							lossExpTable.keys.releaseKeys();
						},
						onRemoveRowFocus : function() {
							objCLMGlobal.clmLossId = "";
							objCLMGlobal.itemNo = "";
							objCLMGlobal.perilCd = "";
							openLossExpDistList();
							showLossExpDistRIListing();
							lossExpTable.keys.removeFocus(lossExpTable.keys._nCurrentFocus, true);
							lossExpTable.keys.releaseKeys();
						},
						onSort : function() {
							showLossExpDistList();
							showLossExpDistRIListing();
							lossExpTable.keys.removeFocus(lossExpTable.keys._nCurrentFocus, true);
							lossExpTable.keys.releaseKeys();
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
					id : 'clmLossId',
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
					width : '215',
					sortable : true,
					children : [
						{
							id : 'itemNo',							
							width : 50,							
							editable : false,	
							align: 'right'
						},
						{
							id : 'itemTitle',							
							width : 170,
							editable : false
						}
					            ]					
				},	
				{
					id : 'perilCd perilName',
					title : 'Peril',
					width : '215',
					sortable : true,
					children : [
						{
							id : 'perilCd',							
							width : 50,							
							editable : false,	
							align: 'right'
						},
						{
							id : 'perilName',							
							width : 170,
							editable : false
						}
					            ]					
				}, 
				{
					id : 'payeeName',
					title: 'Payee',
					width : '400px',
					editable : false
				},
				{
					id : 'paidAmt',
					title : 'Paid Amount',
					titleAlign : 'center',
					type : 'number',
					width : '100px',
					geniisysClass : 'money',
				}, 
				{
					id : 'netAmt',
					title : 'Net Amount',
					titleAlign : 'center',
					type : 'number',
					width : '100px',
					geniisysClass : 'money',
				},
				{
					id : 'adviseAmt',
					title : 'Advise Amount',
					titleAlign : 'center',
					type : 'number',
					width : '100px',
					geniisysClass : 'money',
				}],
				rows: objItem.objItemLossExp
			};
			lossExpTable = new MyTableGrid(itemLossExpTableModel);
			lossExpTable.pager = objItem.objItemLossExpTableGrid;
			lossExpTable.render('lossExpInfoListing');
		}catch(e){
			showErrorMessage("initializelossExpInfoTableGrid", e);
		}
	}
	
	function showLossExpDistList(){
		try{
			var lossDistTableModel = {
				url : contextPath +"/GICLClaimsController?action=getLossExpDisListing&refresh=1" ,
				id : 50,
				options : {
					title : '',
					width : '890px',
					pager: {}, 
					hideColumnChildTitle: true,
					onCellFocus : function(element, value, x, y, id) {
						var obj = lossDistTableGrid.geniisysRows[y];
						objCLMGlobal.grpSeqNo = obj.grpSeqNo;
						objCLMGlobal.clmDistNo = obj.clmDistNo;
						openLossExpRiDistList();
						lossDistTableGrid.keys.removeFocus(lossDistTableGrid.keys._nCurrentFocus, true);
						lossDistTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus : function() {
						objCLMGlobal.grpSeqNo = "";
						objCLMGlobal.clmDistNo = "";
						openLossExpRiDistList();
						lossDistTableGrid.keys.removeFocus(lossDistTableGrid.keys._nCurrentFocus, true);
						lossDistTableGrid.keys.releaseKeys();
					},
					onSort : function() {
						showLossExpDistRIListing();
						lossDistTableGrid.keys.removeFocus(lossDistTableGrid.keys._nCurrentFocus, true);
						lossDistTableGrid.keys.releaseKeys();
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
			            editable: false
			        },
				   	{
						id: 'shrLossExpPct',
						title: 'Share Percent',
						titleAlign : 'center',
						width : '90px',
						type: 'number',
						align: 'right'
					},
					{
						id: 'distYear',
						title: 'Dist Year',
						titleAlign : 'center',
						width : '75px',
						type: 'number',
						align: 'right'
					},
					{
						id : 'shrLePdAmt',
						title : 'Share Paid Amount',
						titleAlign : 'right',
						type : 'number',
						align: 'right',
						width : '160px',
						geniisysClass : 'money',
						editable : false
					}, 
					{
						id : 'shrLeAdvAmt',
						title : 'Share Advice Amount',
						titleAlign : 'right',
						align: 'right',
						type : 'number',
						width : '160px',
						geniisysClass : 'money',
						editable : false
					},
					{
						id : 'shrLeNetAmt',
						title : 'Share Net Amount',
						titleAlign : 'right',
						align: 'right',
						type : 'number',
						width : '160px',
						geniisysClass : 'money',
						editable : false
					}
				],
				rows : []
			};
			lossDistTableGrid = new MyTableGrid(lossDistTableModel);
			lossDistTableGrid.render('lossDistListingGrid');	
		}catch(e){
			showErrorMessage("Claims Distribution - Reserve Distribution", e);
		}
	}
	
	function openLossExpDistList(){
		lossDistTableGrid.url = contextPath +"/GICLClaimsController?action=getLossExpDisListing&refresh=1&claimId="+objCLMGlobal.claimId+"&clmLossId="+objCLMGlobal.clmLossId
				+"&itemNo=" + objCLMGlobal.itemNo + "&perilCd="+objCLMGlobal.perilCd;
		lossDistTableGrid._refreshList();
	}
	
	function showLossExpDistRIListing(){
		try{
			var lossDistRITableModel = {
				url : contextPath +"/GICLClaimsController?action=getLossExpRiDisListing&refresh=1" ,
				id : 60,
				options : {
					title : '',
					width : '890px',
					pager: {}, 
					hideColumnChildTitle: true,
					onCellFocus : function(element, value, x, y, id) {
						lossDistRITableGrid.keys.removeFocus(lossDistTableGrid.keys._nCurrentFocus, true);
						lossDistRITableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus : function() {
						lossDistRITableGrid.keys.removeFocus(lossDistTableGrid.keys._nCurrentFocus, true);
						lossDistRITableGrid.keys.releaseKeys();
					},
					onSort : function() {
						lossDistRITableGrid.keys.removeFocus(lossDistTableGrid.keys._nCurrentFocus, true);
						lossDistRITableGrid.keys.releaseKeys();
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
						width : '50px'
					},				
					{
			            id: 'riSname',
			            title: 'Reinsurer',
			            width: '242px',
			            editable: false
			        },
				   	{
						id: 'shrLossExpRiPct',
						title: 'Share Percent',
						width : '90px',
						type: 'number'
					},
					{
						id : 'shrLePdAmt',
						title : 'Share Paid Amount',
						titleAlign : 'center',
						type : 'number',
						width : '160px',
						geniisysClass : 'money'
					}, 
					{
						id : 'shrLeAdvAmt',
						title : 'Share Advice Amount',
						titleAlign : 'center',
						type : 'number',
						width : '160px',
						geniisysClass : 'money'
					},
					{
						id : 'shrLeNetAmt',
						title : 'Share Net Amount',
						titleAlign : 'center',
						type : 'number',
						width : '160px',
						geniisysClass : 'money'
					}
				],
				rows : []
			};
				
			lossDistRITableGrid = new MyTableGrid(lossDistRITableModel);
			lossDistRITableGrid.render('lossDistRIListingGrid');	
		}catch(e){
			showErrorMessage("Claims Distribution - Loss RI Distribution", e);
		}
	}
	
	function openLossExpRiDistList(){
		lossDistRITableGrid.url = contextPath +"/GICLClaimsController?action=getLossExpRiDisListing&refresh=1&claimId="+objCLMGlobal.claimId+"&clmLossId="+objCLMGlobal.clmLossId
				+"&grpSeqNo=" + objCLMGlobal.grpSeqNo + "&clmDistNo="+objCLMGlobal.clmDistNo;
		lossDistRITableGrid._refreshList();
	}
	
	initializelossExpInfoTableGrid();
	showLossExpDistList();
	showLossExpDistRIListing();
</script>