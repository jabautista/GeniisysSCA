
<div id="polPremCollTableGridSectionDiv" class="sectionDiv" style="height:305px;width:776px; border: 0px;">
		<div id="polPremCollTableGridDiv" style="height:305px;">
			<div id="polPremCollListing" style="height:281px;width:776px;"></div>
		</div>
</div>

<script>

	var objDirectPrem = new Object();
	objDirectPrem.objDirectPremListTableGrid = JSON.parse('${gipiRelatedDirectPremCollnsTableGrid}'.replace(/\\/g, '\\\\'));
	objDirectPrem.objDirectPremList = objDirectPrem.objDirectPremListTableGrid.rows || [];

	try{
		var directPremTableModel = {
			url:contextPath+"/GIACDirectPremCollnsController?action=refreshRelatedDirectPremColl&issCd="+$F("hidInvIssCd")+"&premSeqNo="+$F("hidInvPremSeqNo")
				,
			options:{
					title: '',
					width: '776px',
					onCellFocus: function(element, value, x, y, id){
						loadDirectPrem(directPremTableGrid.geniisysRows[y]);
						directPremTableGrid.keys.removeFocus(directPremTableGrid.keys._nCurrentFocus, true);
						directPremTableGrid.keys.releaseKeys();	
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						unloadDirectPrem();
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
						width: '0px',
						visible: false
					},
					{	id: 'rowCount',
						title: 'rowCount',
						width: '0px',
						visible: false
					},
					{	id: 'totalPrem',
						width: '0px',
						visible: false
					},
					{	id: 'totalTax',
						width: '0px',
						visible: false
					},
					{	id: 'totalCollection',
						width: '0px',
						visible: false
					},
					{	id: 'refNo',
						title: 'Reference No.',
						width: '150%',
						visible: true
					},
					{	id: 'strTranDate', //id: 'tranDate', replaced by: Nica 05.17.2013
						title: 'Transaction Date',
						width: '150%',
						type:'date',
						titleAlign: 'center',
						align: 'center',
						visible: true,
						renderer: function(value){
							return formatDateToDefaultMask(value);
						}
					},
					{	id: 'premAmt',
						title: 'Premium',
						width: '150px',
						align: 'right',
						titleAlign: 'right',
						visible: true,
						geniisysClass : 'money',     
			            geniisysMinValue: '-999999999999.99',     
			            geniisysMaxValue: '999,999,999,999.99'
					},
					{	id: 'taxAmt',
						title: 'Tax',
						width: '150px',
						visible: true,
						align: 'right',
						titleAlign: 'right',
						geniisysClass : 'money',     
			            geniisysMinValue: '-999999999999.99',     
			            geniisysMaxValue: '999,999,999,999.99'
					},
					{	id: 'collAmt',
						title: 'Collection',
						width: '150px',
						visible: true,
						align: 'right',
						titleAlign: 'right',
						geniisysClass : 'money',     
			            geniisysMinValue: '-999999999999.99',     
			            geniisysMaxValue: '999,999,999,999.99'
					}
			],
			rows:objDirectPrem.objDirectPremList
		};
	
		directPremTableGrid = new MyTableGrid(directPremTableModel);
		directPremTableGrid.pager = objDirectPrem.objDirectPremListTableGrid;
		directPremTableGrid.render('polPremCollListing');
	}catch(e){
		showErrorMessage("GIPIS100 - Premium Collns", e);
	}
	
	loadTotals(directPremTableGrid);
	
	
	function loadTotals(tableGrid){
		try{
			$("txtTotalPrem").value = formatCurrency(tableGrid.getValueAt(4,0));
			$("txtTotalTaxOrComm").value = formatCurrency(tableGrid.getValueAt(5,0));
			$("txtTotalCollection").value = formatCurrency(tableGrid.getValueAt(6,0));
		}catch(e){}
	}
	
	function loadDirectPrem(collns){

		$("txtParticulars").value = unescapeHTML2(collns.particulars);
		$("txtUserId").value = unescapeHTML2(collns.userId);
		$("txtLastUpdate").value = nvl(collns.strLastUpdate, null); // == null ? "" : dateFormat(collns.lastUpdate,"mm-dd-yyyy HH:MM:ss TT");
		
	}
	function unloadDirectPrem(){
		
		$("txtParticulars").value 	= "";
		$("txtUserId").value 	 	= "";
		$("txtLastUpdate").value 	= "";
		
	}
	
</script>