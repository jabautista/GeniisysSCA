<div id="polCargoInfoInfoTableGridSectionDiv" style="margin:0px auto 0px auto;">
		<div id="polCargoInfoInfoTableGridDiv" style="padding:10px;">
			<div id="polCargoInfoInfoListing" style="height:156px;width:412px;margin:0px auto 0px auto;"></div>
		</div>
		<div style="text-align:center;">
			<input type="button" class="button" id="btnOk" value="Ok"/>
		</div>
</div>
<script>
	
	var objCargoInfo = new Object();
	objCargoInfo.objCargoInfoListTableGrid = JSON.parse('${policyCargoInformations}'.replace(/\\/g, '\\\\'));
	objCargoInfo.objCargoInfoList = objCargoInfo.objCargoInfoListTableGrid.rows || [];
	
	try{
		var cargoInfoTableModel = {
			url:contextPath+"/GIPIVesAirController?action=getCargoInformations"+
			"&policyId="+$F("hidPolicyId")+
			"&refresh=1",
			options:{
					title: '',
					width: '412px',
					onCellFocus: function(element, value, x, y, id){
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
					{
						id: 'policyId',
						title: 'Policy id',
						width: '0px',
						visible: false
					},
					{
						id: 'vesselName',
						title: 'Carrier / Conveyance',
						width: '300%',
						visible: true
					},
					{
						id: 'vesselFlag',
						title: 'Vessel Flag',
						width: '100%',
						visible: true
					},
					
					
			],
			rows:objCargoInfo.objCargoInfoList
		};

		cargoInfoTableGrid = new MyTableGrid(cargoInfoTableModel);
		cargoInfoTableGrid.render('polCargoInfoInfoListing');
	}catch(e){
		showErrorMessage("cargoInfoTableModel", e);
	}


	$("btnOk").observe("click", function(){
		overlayCargoInformation.close();
	});

</script>