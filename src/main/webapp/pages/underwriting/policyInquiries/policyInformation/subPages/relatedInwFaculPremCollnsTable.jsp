
<div id="polPremCollTableGridSectionDiv" class="sectionDiv" style="height:305px;width:776px;">
		<div id="polPremCollTableGridDiv" style="height:305px;">
			<div id="polPremCollListing" style="height:281px;width:776px;"></div>
		</div>
</div>

<script>

	var objInwFaculPrem = new Object();
	objInwFaculPrem.objInwFaculPremListTableGrid = JSON.parse('${gipiRelatedInwFaculPremCollnsTableGrid}'.replace(/\\/g, '\\\\'));
	objInwFaculPrem.objInwFaculPremList = objInwFaculPrem.objInwFaculPremListTableGrid.rows || [];	
	
	try{
		var inwFaculPremTableModel = {
			url:contextPath+"/GIACInwFaculPremCollnsController?action=refreshRelatedInwFaculPremColl&issCd="+$F("hidInvIssCd")+"&premSeqNo="+$F("hidInvPremSeqNo")
				,
			options:{
					title: '',
					width: '776px',
					onCellFocus: function(element, value, x, y, id){
						loadInwFaculPrem(inwFaculPremTableGrid.geniisysRows[y]);
						inwFaculPremTableGrid.keys.removeFocus(inwFaculPremTableGrid.keys._nCurrentFocus, true);
						inwFaculPremTableGrid.keys.releaseKeys();	
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						unloadInwFaculPrem();
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
						width: '150%',
						visible: true
					},
					{	id: 'tranDate',
						title: 'Tran Date',
						width: '150%',
						type: 'date',
						visible: true
					},
					{	id: 'premTax',
						title: 'Premium + Tax',
						width: '150%',
						visible: true
					},
					{	id: 'commWtax',
						title: 'Commission + Tax',
						width: '150%',
						visible: true
					},
					{	id: 'collectionAmt',
						title: 'Collection Amount',
						width: '150%',
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
	
	function loadInwFaculPrem(collns){

		$("txtParticulars").value = collns.particulars;
		$("txtUserId").value = collns.userId;
		$("txtLastUpdate").value = collns.lastUpdate;
	}

	function unloadInwFaculPrem(){
		
		$("txtParticulars").value 	= "";
		$("txtUserId").value 	 	= "";
		$("txtLastUpdate").value 	= "";
		
	}
</script>