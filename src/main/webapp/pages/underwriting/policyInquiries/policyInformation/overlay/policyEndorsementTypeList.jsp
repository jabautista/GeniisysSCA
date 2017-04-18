
<div id="endorsementTypeTableGridSectionDiv" class="sectionDiv" style="height:305px;width:414px;">
		<div id="endorsementTypeTableGridDiv" style="height:305px;">
			<div id="endorsementTypeListing" style="height:281px;width:300px;"></div>
		</div>
</div>

<script>
	
	$("btnReturn").observe("click", function(){
		overlayEndorsementTypeList.close();
	});
	var endorsementTypeListSelectedIndex;
	var objEndorsementType = new Object();
	objEndorsementType.objEndorsementTypeListTableGrid = JSON.parse('${endorsementList}'.replace(/\\/g, '\\\\'));
	objEndorsementType.objEndorsementTypeList = objEndorsementType.objEndorsementTypeListTableGrid.rows || [];

	try{
		var endorsementTypeTableModel = {
			url:contextPath+"/GIPIPARListController?action=getEndorsementTypeList"+
				"&refresh=1"
				,
			options:{
					title: '',
					width:'414px',
					onCellFocus: function(element, value, x, y, id){
						var mtgId = endorsementTypeTableGrid._mtgId;
						endorsementTypeListSelectedIndex = -1;
						if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
							endorsementTypeListSelectedIndex = y;
						}
					},
					onRowDoubleClick: function(param){
						var row = endorsementTypeTableGrid.geniisysRows[param];
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
					{	id: 'endtCd',
						title: 'endtType',
						width: '100%',
						visible: true
					},
					{	id: 'endtTitle',
						title: 'endtTitle',
						width: '300%',
						visible: true
					},					
			],
			rows:objEndorsementType.objEndorsementTypeList
		};
		endorsementTypeTableGrid = new MyTableGrid(endorsementTypeTableModel);
		endorsementTypeTableGrid.pager = objEndorsementType.objEndorsementTypeListTableGrid;
		endorsementTypeTableGrid.render('endorsementListing');
	}catch(e){
		showErrorMessage("endorsementTypeTableModel", e);
	}
	
	$("btnOk").observe("click", function () {		
		try{
			var row = endorsementTypeTableGrid.geniisysRows[endorsementTypeListSelectedIndex];
			$("txtAssdNo").value   = row.assdNo;
			$("txtAssdName").value = row.assdName;
			getPolicyByEndorsementTypeTable(row.assdNo);
		}catch(e){
			
		}finally{
			overlayEndorsementTypeList.close();
		}
	});


	
</script>