<div style="width:468px;margin:10px auto 10px auto;">
	<div style="height:160px;margin:5px auto 5px auto;width:468px;">
		<div id="vehicleAccessoryListing" style="height:156px;width:468px;float:left;"></div>
	</div>
	<div style="margin: 5px auto 5px auto;text-align:right">
		Total Amount <input type="text" id="txtAccessoryTotalAmount" name="txtAccessoryTotalAmount" style="width:145px; text-align: right;" readonly="readonly">
	</div>
	<div style="margin: 5px auto 5px auto;text-align:center">
		<input type="button" class="button" id="btnReturnFromVehicleAccessory" name="btnReturnFromVehicleAccessory" value="Return" style="width:100px;"/>
	</div>
</div>

<script>

	//initialization
	var objVehicleAccessory = new Object();
	objVehicleAccessory.objVehicleAccessoryListTableGrid = JSON.parse('${vehicleAccessoryList}'.replace(/\\/g, '\\\\'));
	objVehicleAccessory.objVehicleAccessoryList = objVehicleAccessory.objVehicleAccessoryListTableGrid.rows || [];
	
	try{
		var vehicleAccessoryTableModel = {
			url:contextPath+"/?action=getVehicleAccessories"+
			"&policyId="+$("hidItemPolicyId").value+
			"&itemNo="+$("hidItemNo").value
				,
			options:{
					title: '',
					width: '468px',
					onCellFocus: function(element, value, x, y, id){
						vehicleAccessoryTableGrid.releaseKeys();
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						vehicleAccessoryTableGrid.releaseKeys();
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
						title: 'policyId',
						width: '0px',
						visible: false
					},
					{
						id: 'itemNo',
						title: 'itemNo',
						width: '0px',
						visible: false
					},
					{
						id: 'totalAccAmt',
						title: 'totalAccAmt',
						width: '0px',
						visible: false
					},
					{
						id: 'accessoryCd',
						title: 'Code',
						width: '100%',
						visible: true
					},
					{
						id: 'accessoryDesc',
						title: 'Accessory',
						width: '200%',
						visible: true
					},
					{
						id: 'accAmt',
						title: 'Amount',
						width: '150%',
						visible: true,
						geniisysClass: "money",
						align: "right"
					}
			],
			rows:objVehicleAccessory.objVehicleAccessoryList
		};
	
		vehicleAccessoryTableGrid = new MyTableGrid(vehicleAccessoryTableModel);
		vehicleAccessoryTableGrid.render('vehicleAccessoryListing');
	}catch(e){
		showErrorMessage("Motor Accessories", e);
	}
	try{
		$("txtAccessoryTotalAmount").value = formatCurrency(vehicleAccessoryTableGrid.getValueAt(4,0));
	}catch(e){}
	
	
	$("btnReturnFromVehicleAccessory").observe("click", function(){
		overlayVehicleAccessories.close();
	});

</script>