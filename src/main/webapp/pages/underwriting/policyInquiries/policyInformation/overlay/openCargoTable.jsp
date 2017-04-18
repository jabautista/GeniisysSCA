<div id="cargoTG" name="cargoTG" class="sectionDiv" style="width:750px;height:150px;margin:5px auto 0px auto;align:center; border:none;">
	<div id="cargoListing" style="height:150px;width:700px;align:center;margin:10px auto 0px auto;align:center;"></div>
</div>

<script type="text/javascript">
	var objOpenCargo = new Object();
	objOpenCargo.objOpenCargoListTableGrid = JSON.parse('${openCargoList}'.replace(/\\/g, '\\\\'));
	objOpenCargo.objOpenCargoList = objOpenCargo.objOpenCargoListTableGrid.rows || [];
	
	var moduleId = '${moduleId}';	
	var url;
	
	if(moduleId == "GIPIS100"){
		url = contextPath + "/GIPIOpenPolicyController?action=getOpenCargos&policyId=" + $F("hidPolicyId")
				+ "&geogCd=" + $F("hidGeogCd");
	} else {
		url = contextPath + "/GIXXOpenCargoController?action=getGIXXOpenCargoList" + "&refresh=1" +
		"&extractId=" + $F("hidExtractId") + "&geogCd=" + $F("hidGeogCd");
	}
	
	try {
		var cargoTableModel = {
				url : url,
				options: {
					title: '',
					width: '700px',
					height: '140px',
					onCellFocus: function(element, value, x, y, id){
						openCargoTableGrid.keys.removeFocus(openCargoTableGrid.keys._nCurrentFocus, true);
						openCargoTableGrid.keys.releaseKeys();	
					},
					onRowDoubleClick: function (param){
						
					}
				},
				columnModel: [
				           { 	
				        	    id: 'recordStatus',
								title: '',
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
								id: 'extractId',
								title: 'extractId',
								width: '0px',
								visible: false
							},
							{
								id: 'geogCd',
								title: 'geogCd',
								width: '0px',
								visible: false
							},
							{
								id: 'cargoClassCd',
								title: 'Class',
								titleAlign: 'center',
								width: '147px',
								align: 'right',
								visible: true
							},
							{
								id: 'cargoClassDesc',
								title: 'Description',
								titleAlign: 'center',
								width: '539px',
								visible: true
							}],									
				rows: objOpenCargo.objOpenCargoList					
		} ;
		openCargoTableGrid = new MyTableGrid(cargoTableModel);
		openCargoTableGrid.pager = objOpenCargo.objOpenCargoListTableGrid;
		openCargoTableGrid.render("cargoListing");
	} catch (e) {
		showErrorMessage("initializeCargoTG", e);
	}
</script>
