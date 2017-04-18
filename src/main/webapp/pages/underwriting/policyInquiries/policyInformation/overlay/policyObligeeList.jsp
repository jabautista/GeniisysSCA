
<div id="obligeeTableGridSectionDiv" style="height:305px;width:400px;">
		<div id="obligeeTableGridDiv" style="height:305px;">
			<div id="obligeeListing" style="height:281px;width:350px;"></div>
		</div>
</div>

<script>
	
	$("btnReturn").observe("click", function(){
		overlayObligeeList.close();
	});
	
	var obligeeListSelectedIndex;
	var objObligee = new Object();
	objObligee.objObligeeListTableGrid = JSON.parse('${obligeeList}'.replace(/\\/g, '\\\\'));
	objObligee.objObligeeList = objObligee.objObligeeListTableGrid.rows || [];

	try{
		var obligeeTableModel = {
			url:contextPath+"/GIISObligeeController?action=getObligeeList"+
				"&refresh=1"
				,
			options:{
					title: '',
					width:'400px',
					onCellFocus: function(element, value, x, y, id){
						var mtgId = obligeeTableGrid._mtgId;
						obligeeListSelectedIndex = -1;
						obligeeTableGrid.releaseKeys();
						if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
							obligeeListSelectedIndex = y;
						}
					},
					onRowDoubleClick: function(param){
						var row = obligeeTableGrid.geniisysRows[param];
						$("txtObligeeName").value = unescapeHTML2(row.obligeeName);
						$("txtObligeeNo").value = row.obligeeNo;
						getPolicyByObligeeTable(row.obligeeNo);
						obligeeTableGrid.releaseKeys();
						overlayObligeeList.close();
					},
					onRemoveRowFocus: function(element, value, x, y, id){
						obligeeListSelectedIndex = -1;
						obligeeTableGrid.releaseKeys();
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
					{	id: 'obligeeName',
						title: 'Obligee Name',
						width: '388px',
						visible: true
					},
					
			],
			rows:objObligee.objObligeeList
		};
		obligeeTableGrid = new MyTableGrid(obligeeTableModel);
		obligeeTableGrid.pager = objObligee.objObligeeListTableGrid;
		obligeeTableGrid.render('obligeeListing');
	}catch(e){
		showErrorMessage("Obligee Table", e);
	}
	
	$("btnOk").observe("click", function () {		
		try{			
			if((obligeeListSelectedIndex)>-1){
				var row = obligeeTableGrid.geniisysRows[obligeeListSelectedIndex];
				$("txtObligeeName").value = unescapeHTML2(row.obligeeName);
				$("txtObligeeNo").value = row.obligeeNo;
				getPolicyByObligeeTable(row.obligeeNo);
					
			}
			
		}catch(e){
			
		}finally{
			overlayObligeeList.close();
		}
	});

</script>
	