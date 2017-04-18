<div id="marineHullsTableGridSectionDiv" style="height:305px;width:618px;margin:0 auto 0 auto;">
		<div id="marineHullsTableGridDiv" style="height:305px;">
			<div id="marineHullsListing" style="height:281px;width:618px;"></div>
		</div>
</div>
<script type="text/javascript" src="underwriting.js">
	var marineHullsSelectedIndex;
	var objMarineHulls = new Object();
	objMarineHulls.objMarineHullsListTableGrid = JSON.parse('${marineHullsTableGrid}'.replace(/\\/g, '\\\\'));
	objMarineHulls.objMarineHullsList = objMarineHulls.objMarineHullsListTableGrid.rows || [];
	
	try{
		var marineHullsTableModel = {
			url:contextPath+"/GIPIItemVesController?action=refreshMarineHullsTable"
				,
			options:{
					title: '',
					width:'618px',
					onCellFocus: function(element, value, x, y, id){
						var mtgId = marineHullsTableGrid._mtgId;
						marineHullsSelectedIndex = -1;
						if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
							marineHullsSelectedIndex = y;
							enableButton("btnSummarizedInfo");
						}
						marineHullsTableGrid.keys.removeFocus(marineHullsTableGrid.keys._nCurrentFocus, true);
						marineHullsTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						marineHullsSelectedIndex = -1;
						disableButton("btnSummarizedInfo");
						marineHullsTableGrid.keys.removeFocus(marineHullsTableGrid.keys._nCurrentFocus, true);
						marineHullsTableGrid.keys.releaseKeys();
					},
					onRowDoubleClick: function(param){
						var row = marineHullsTableGrid.geniisysRows[param];
						getPolicyEndtSeq0(row.policyId);
						marineHullsTableGrid.keys.removeFocus(marineHullsTableGrid.keys._nCurrentFocus, true);
						marineHullsTableGrid.keys.releaseKeys();
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
					{	id: 'policyId',
						title: 'policyId',
						width: '0px',
						visible: false
					},
					{	id: 'vesselCd',
						title: 'Vessel Code',
						width: '100%',
						visible: true
					},
					{	id: 'vesselName',
						title: 'Vessel Name',
						width: '300%',
						visible: true
					},
					{	id: 'policyNo',
						title: 'Policy No.',
						width: '200%',
						visible: true
					},
					
			],
			rows:objMarineHulls.objMarineHullsList
		};
		marineHullsTableGrid = new MyTableGrid(marineHullsTableModel);
		marineHullsTableGrid.pager = objMarineHulls.objMarineHullsListTableGrid;
		marineHullsTableGrid.render('marineHullsListing');
		marineHullsTableGrid.afterRender = function(){
			disableButton("btnSummarizedInfo");
			marineHullsTableGrid.keys.removeFocus(marineHullsTableGrid.keys._nCurrentFocus, true);
			marineHullsTableGrid.keys.releaseKeys();
		};		
		
	}catch(e){
		showErrorMessage("marineHullsTableModel", e);
	}

	$("btnSummarizedInfo").observe("click", function () {		
		try{
			var row = marineHullsTableGrid.geniisysRows[marineHullsSelectedIndex];
			getPolicyEndtSeq0(row.policyId);
		}catch(e){}
	});
	hideNotice();
</script>