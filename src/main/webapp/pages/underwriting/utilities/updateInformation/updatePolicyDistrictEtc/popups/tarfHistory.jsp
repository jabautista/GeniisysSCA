<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<div id="tarfHistMainDiv">
	<div style="width: 580px; height: 280px; margin: 5px;"> 
		
		<div id="tarfHistTGDiv" style="width: 570px; height: 200px; margin: 5px;"></div>
		
		<div class="buttonsDiv">
			<input id="btnReturn" type="button" class="button" value="Return" style="width: 80px; margin-top: 20px;" tabindex="601"/> 
		</div>
	</div>
	
	
</div>


<script type="text/javascript">
try{
	$("btnReturn").focus();
	
	var selectedRowInfo = null;
	var selectedIndex = null;
	
	var objTarfHist = new Object();
	objTarfHist.tableGrid = JSON.parse('${tarfHistGrid}'.replace(/\\/g, '\\\\'));
	objTarfHist.objRows = objTarfHist.tableGrid.rows || [];
	objTarfHist.objList = [];
	
	
	try{
		var tarfHistTableModel = {
			url: contextPath+"/UpdateUtilitiesController?action=getGipis155TarfHistListing&refresh=1&policyId="+objGIPIS155.policyId+
							 "&itemNo="+objGIPIS155.itemNo+"&blockId="+objGIPIS155.blockId,
			width: '370px',
			height: '200px',
			options: {
				onCellFocus: function(element, value, x, y, id){
					selectedRowInfo = tarfHistTG.geniisysRows[y];
					selectedIndex = y;
				},
				onRemoveRowFocus: function(){
					tarfHistTG.keys.releaseKeys();
					selectedRowInfo = null;
					selectedIndex = null;
				},
				onSort: function(){
					tarfHistTG.onRemoveRowFocus();
				},
				onRefresh: function(){
					tarfHistTG.onRemoveRowFocus();
				},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onFilter: function(){
						tarfHistTG.onRemoveRowFocus();
					}
				}
			},
			columnModel: [
				{
					id: 'recordStatus',
					width: '0px',
					visible: false,
					editor: 'checkbox'
				},
				{
					id: 'divCtrId',
					width: '0px',
					visible: false
				},     
				{
					id: 'policyId',
					width: '0px',
					visible: false
				},
				{
					id: 'itemNo',
					width: '0px',
					visible: false
				},   
				{
					id: 'blockId',
					width: '0px',
					visible: false
				},
				{
					id: 'arcExtData',
					width: '0px',
					visible: false
				},      
				{
					id: 'origOldTarfCd',
					width: '0px',
					visible: false
				},
				{
					id: 'origNewTarfCd',
					width: '0px',
					visible: false
				},   
				{
					id: 'origUserId',
					width: '0px',
					visible: false
				},
				{
					id: 'origLastUpdate',
					width: '0px',
					visible: false
				},  
				{
					id: 'oldTarfCd',
					title: 'Old Tarf Cd',
					width: '140px',
					visible: true,
					sortable: true,
					filterOption: true
				},  
				{
					id: 'newTarfCd',
					title: 'New Tarf Cd',
					width: '140px',
					visible: true,
					sortable: true,
					filterOption: true
				},  
				{
					id: 'userId',
					title: 'User Id',
					width: '100px',
					visible: true,
					sortable: true,
					filterOption: true
				},  
				{
					id: 'lastUpdate',
					title: 'Last Update',
					width: '145px',
					visible: true,
					sortable: true
				}	
			],
			rows: objTarfHist.objRows
		};
		
		tarfHistTG = new MyTableGrid(tarfHistTableModel);
		tarfHistTG.pager = objTarfHist.tableGrid; 
		tarfHistTG.render('tarfHistTGDiv');
		tarfHistTG.afterRender = function(){
			objTarfHist.objList = tarfHistTG.geniisysRows;
		};
	}catch(e){
		showErrorMessage("Tarf History Tablegrid error", e);
	}
	
	$("btnReturn").observe("click", function(){
		tarfHistTG.onRemoveRowFocus();
		tarfHistOverlay.close();
	});
	
}catch(e){
	showErrorMessage("Page Error", e);
}
</script>