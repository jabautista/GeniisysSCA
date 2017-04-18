<div id="fullOrigItmPerilsTableGridSectionDiv" style="margin:0px auto 0px auto;">
		<div id="fullOrigItmPerilsTableGridDiv" style="">
			<div id="fullOrigItmPerilsListing" style="height:156px;width:400px;margin:0px auto 0px auto;"></div>
		</div>
</div>
<script>
	
	var objFullOrigItmPerils = new Object();
	objFullOrigItmPerils.objFullOrigItmPerilsListTableGrid = JSON.parse('${fullOrigItmPerilsList}'.replace(/\\/g, '\\\\'));
	objFullOrigItmPerils.objFullOrigItmPerilsList = objFullOrigItmPerils.objFullOrigItmPerilsListTableGrid.rows || [];
	
	try{
		var fullOrigItmPerilsTableModel = {
			url:contextPath+"/GIPIOrigItmPerilController?action=getFullOrigItmPerils"+
			"&refresh=1",
			options:{
					title: '',
					width: '400'
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
						id: 'fullPerilCode',
						title: 'Peril Code',
						width: '80%',
						visible: true
					},
					{
						id: 'fullPremRt',
						title: 'Prem Rt',
						width: '80%',
						visible: true
					},
					{
						id: 'fullTsiAmt',
						title: 'TSI Amount',
						width: '100%',
						visible: true
					},
					{
						id: 'fullPremAmt',
						title: 'Prem Amount',
						width: '100%',
						visible: true
					},
					{
						id: 'fullDiscountSw',
						title: 'D',
						width: '24%',
						visible: true
					}
			],
			rows:objFullOrigItmPerils.objFullOrigItmPerilsList
		};

		fullOrigItmPerilsTableGrid = new MyTableGrid(fullOrigItmPerilsTableModel);
		fullOrigItmPerilsTableGrid.render('fullOrigItmPerilsListing');
	}catch(e){
		showErrorMessage("fullOrigItmPerilsTableModel", e);
	}
	

</script>