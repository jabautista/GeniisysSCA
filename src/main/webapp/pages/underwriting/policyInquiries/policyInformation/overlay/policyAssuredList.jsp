
<div id="assuredTableGridSectionDiv" class="sectionDiv" style="height:305px;width:414px;">
		<div id="assuredTableGridDiv" style="height:305px;">
			<div id="assuredListing" style="height:281px;width:300px;"></div>
		</div>
</div>

<script>
	
	$("btnReturn").observe("click", function(){
		overlayAssuredList.close();
	});
	var assuredListSelectedIndex;
	var objAssured = new Object();
	objAssured.objAssuredListTableGrid = JSON.parse('${assuredList}'.replace(/\\/g, '\\\\'));
	objAssured.objAssuredList = objAssured.objAssuredListTableGrid.rows || [];

	try{
		var assuredTableModel = {
			url:contextPath+"/GIPIPARListController?action=getAssuredList"+
				"&refresh=1"
				,
			options:{
					title: '',
					width:'414px',
					onCellFocus: function(element, value, x, y, id){
						var mtgId = assuredTableGrid._mtgId;
						assuredTableGrid.releaseKeys();
						assuredListSelectedIndex = -1;
						if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
							assuredListSelectedIndex = y;
						}
					},
					onRowDoubleClick: function(param){
						var row = assuredTableGrid.geniisysRows[param];
						$("txtAssdNo").value   = row.assdNo;
						$("txtAssdName").value = unescapeHTML2(row.assdName);
						getPolicyByAssuredTable(row.assdNo);
						assuredTableGrid.releaseKeys();
						overlayAssuredList.close();
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
					{	id: 'assdNo',
						title: 'Assured No.',
						width: '100%',
						visible: true
					},
					{	id: 'assdName',
						title: 'Assured Name',
						width: '300%',
						visible: true
					},
					
			],
			rows:objAssured.objAssuredList
		};
		assuredTableGrid = new MyTableGrid(assuredTableModel);
		assuredTableGrid.pager = objAssured.objAssuredListTableGrid;
		assuredTableGrid.render('assuredListing');
	}catch(e){
		showErrorMessage("Assured Table", e);
	}
	$("btnOk").observe("click", function () {		
		try{
			var row = assuredTableGrid.geniisysRows[assuredListSelectedIndex];
			$("txtAssdNo").value   = row.assdNo;
			$("txtAssdName").value = unescapeHTML2(row.assdName);
			getPolicyByAssuredTable(row.assdNo);
		}catch(e){
			
		}finally{
			overlayAssuredList.close();
		}
	});


	
</script>