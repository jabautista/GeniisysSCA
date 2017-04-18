
<div id="polPremCollTableGridSectionDiv" class="sectionDiv" style="height:305px;width:776px;">
		<div id="polPremCollTableGridDiv" style="height:305px;">
			<div id="polPremCollListing" style="height:281px;width:776px;"></div>
		</div>
</div>

<script>

	var objInwFaculPrem = new Object();
	objInwFaculPrem.objInwFaculPremListTableGrid = JSON.parse('${gipiRelatedInwFaculPremCollnsTableGrid}'.replace(/\\/g, '\\\\'));
	objInwFaculPrem.objInwFaculPremList = objInwFaculPrem.objInwFaculPremListTableGrid.rows || [];	
	var issCd = unescapeHTML2(objInwFaculPrem.objInwFaculPremListTableGrid.issCd);
	var premSeqNo = objInwFaculPrem.objInwFaculPremListTableGrid.premSeqNo;
	
	try{
		var inwFaculPremTableModel = {
			url:contextPath+"/GIACInwFaculPremCollnsController?action=refreshRelatedInwFaculPremColl&issCd="//$F("txtInvIssCd")+"&premSeqNo="+$F("txtInvPremSeqNo")
					+issCd+"&premSeqNo="+premSeqNo
				,
			options:{
					title: '',
					width: '776px',
					onCellFocus: function(element, value, x, y, id){
						var row = inwFaculPremTableGrid.geniisysRows[y];
						loadCollInfo(row);
						inwFaculPremTableGrid.keys.removeFocus(inwFaculPremTableGrid.keys._nCurrentFocus, true);
						inwFaculPremTableGrid.keys.releaseKeys();	
					},
					/*onRowDoubleClick: function(param){
						var row = inwFaculPremTableGrid.geniisysRows[param];
						loadCollInfo(row);
					},*/onRemoveRowFocus : function(){
						$("txtParticulars").clear();
						$("txtUserId").clear();
						$("txtLastUpdate").clear();
						inwFaculPremTableGrid.keys.removeFocus(inwFaculPremTableGrid.keys._nCurrentFocus, true);
						inwFaculPremTableGrid.keys.releaseKeys()
					}
			},
			columnModel:[
			 		{   id: 'recordStatus',
					    title: '',
					    width: '0px',
					    visible: false,
					    editor: 'checkbox' 			
					},
					{	id: 'divCtrId',
						width: '0px',
						visible: false
					},
					{	id: 'rowNum',
						title: 'rowNum',
						width: '0%',
						visible: false
					},
					{	id: 'rowCount',
						title: 'rowCount',
						width: '0%',
						visible: false
					},
					{	id: 'totalPremWtax',
						title: 'totalPremWtax',
						width: '0%',
						visible: false
					},
					{	id: 'totalCommWtax',
						title: 'totalCommWtax',
						width: '0%',
						visible: false
					},
					{	id: 'totalCollection',
						title: 'totalCollection',
						width: '0%',
						visible: false
					},
					{	id: 'refNo',
						title: 'Reference No',
						width: '140%',
						visible: true
					},
					{	id: 'instNo',
						title: 'Inst No',
						width: '50%',
						visible: true
					},
					{	id: 'tranDate',
						title: 'Tran Date',
						width: '138%',
						type: 'date',
						visible: true
					},
					{	id: 'premTax',
						title: 'Premium + Tax',
						width: '140%',
						visible: true
					},
					{	id: 'commWtax',
						title: 'Commission + Tax',
						width: '140%',
						visible: true
					},
					{	id: 'collectionAmt',
						title: 'Collection Amount',
						width: '140%',
						visible: true
					},
					],
			rows:objInwFaculPrem.objInwFaculPremList
		};
	
		inwFaculPremTableGrid = new MyTableGrid(inwFaculPremTableModel);
		inwFaculPremTableGrid.pager = objInwFaculPrem.objInwFaculPremListTableGrid;
		inwFaculPremTableGrid.render('polPremCollListing');
	}catch(e){
		showErrorMessage("inwFaculPremTableModel", e);
	}
	loadTotals(inwFaculPremTableGrid);

	function loadTotals(tableGrid){
		try{
			$("txtTotalPrem").value = formatCurrency(tableGrid.getValueAt(4,0));
			$("txtTotalTaxOrComm").value = formatCurrency(tableGrid.getValueAt(5,0));
			$("txtTotalCollection").value = formatCurrency(tableGrid.getValueAt(6,0));
		}catch(e){}
	}
	
	function loadCollInfo(collns){

		$("txtParticulars").value = collns.particulars;
		$("txtUserId").value = collns.userId;
		$("txtLastUpdate").value = collns.lastUpdate;
	}
</script>