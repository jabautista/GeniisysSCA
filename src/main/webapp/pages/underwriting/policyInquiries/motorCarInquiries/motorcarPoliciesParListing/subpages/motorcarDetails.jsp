<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<div id="vehicleDetailsMainDiv">

	<div id="vehiclesDiv" class="sectionDiv" style="width: 920px; height: 45px;">
		<table style="margin: 7px 5px 5px 15px;">
			<tr>
				<td style="padding-right: 7px;">PAR No.</td>
				<td><input id="txtParNo" type="text" readonly="readonly" style="width: 250px;"/></td>
				<td style="padding: 0 7px 0 50px;">Assured</td>
				<td><input id="txtAssdName" type="text" readonly="readonly" style="width: 450px;"/></td>
			</tr>
		</table>
	</div>
	
	<div class="sectionDiv" style="width: 920px; height: 250px;">	
		<div id="vehicleListTGDiv" style="width: 899px; height: 200px; margin: 10px 5px 5px 12px;"> </div>
	</div>
	
	<div class="sectionDiv" style="width: 920px; height: 270px;">	
		<div id="vehicleItemsTGDiv" style="width: 900px; height: 190px; margin: 10px 5px 25px 12px;"> </div>
		
		<div class="buttonsDiv">
			<input id="btnReturn" type="button" class="button" value="Return" style="width: 80px;"/>
		</div>
	</div>		
</div>

<script type="text/javascript">
try{
	var returnSw = false;
	
	var selectedVehicleRow = null;
	var selectedVehicleY = null;	
	
	var selectedVItemRow = null;
	var selectedVItemY = null;
	
	var objVehicle = new Object();
	objVehicle.tablegrid = JSON.parse('${parVehiclesListing}'.replace(/\\/g, '\\\\'));
	objVehicle.objRows = objVehicle.tablegrid.rows || [];
	objVehicle.objList = [];
	
	
	try{
		var vehicleTableModel = {
			url: contextPath + "/GIPIPARListController?action=getParVehiclesGIPIS211&refresh=1",
			width: '893px',
			height: '250px',
			options: {
				onCellFocus: function(element, value, x, y, id){
					selectedVehicleRow = vehicleTG.geniisysRows[y];
					selectedVehicleY = y;
					refreshVehicleItemsTableGrid();
				},
				onRemoveRowFocus: function(){
					vehicleTG.keys.releaseKeys();
					selectedVehicleRow = null;
					selectedVehicleY = null;
					vItemTG.onRemoveRowFocus();
					refreshVehicleItemsTableGrid();
				},
				onSort: function(){
					vehicleTG.onRemoveRowFocus();
				},
				onRefresh: function(){
					vehicleTG.onRemoveRowFocus();
				},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onFilter: function(){
						vehicleTG.onRemoveRowFocus();
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
					id: 'parId',
					width: '0px',
					visible: false
				},
				{
					id: 'nbtPolicyId',
					width: '0px',
					visible: false
				},
				{
					id: 'nbtLineCd',
					width: '0px',
					visible: false
				},
				{
					id: 'nbtIssId',
					width: '0px',
					visible: false
				},
				{
					id: 'nbtParYy',
					width: '0px',
					visible: false
				},
				{
					id: 'nbtParSeqNo',
					width: '0px',
					visible: false
				},
				{
					id: 'nbtQuoteSeqNo',
					width: '0px',
					visible: false
				},
				{
					id: 'itemNo',
					title: 'Item No.',
					align: 'right',
					width: '100px',
					sortable: true,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{
					id: 'itemDesc',
					title: 'Description',
					width: '302px',
					sortable: true,
					filterOption: true
				},
				{
					id: 'plateNo',
					title: 'Plate No.',
					width: '150px',
					sortable: true,
					filterOption: true
				},
				{
					id: 'serialNo',
					title: 'Chassis No.',
					width: '150px',
					sortable: true,
					filterOption: true
				},
				{
					id: 'motorNo',
					title: 'Engine No.',
					width: '150px',
					sortable: true,
					filterOption: true
				}
			],
			rows: objVehicle.objRows
		};
		
		vehicleTG = new MyTableGrid(vehicleTableModel);
		vehicleTG.pager = objVehicle.tablegrid;
		vehicleTG.render('vehicleListTGDiv');
		
	}catch(e){
		showErrorMessage("Vehicle Listing table grid error", e);
	}
	
	
	var objVehicleItems = new Object();
	objVehicleItems.tablegrid = JSON.parse('${parVehicleItems}'.replace(/\\/g, '\\\\'));
	objVehicleItems.objRows = objVehicleItems.tablegrid.rows || [];
	objVehicleItems.objList = [];
	
	try{
		var vItemTableModel = {
			url:  contextPath + "/GIPIPARListController?action=getParVehicleItemsGIPIS211&refresh=1",
			width: '900px',
			height: '240px',
			options: {
				onCellFocus: function(element, value, x, y, id){
					selectedVItemRow = vItemTG.geniisysRows[y];
					selectedVItemY = y;
				},
				onRemoveRowFocus: function(){
					vItemTG.keys.releaseKeys();
					selectedVItemRow = null;
					selectedVItemY = null;
				},
				onSort: function(){
					vItemTG.onRemoveRowFocus();
				},
				onRefresh: function(){
					vItemTG.onRemoveRowFocus();
				},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onFilter: function(){
						vItemTG.onRemoveRowFocus();
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
					id: 'parId',
					width: '0px',
					visible: false
				},
				{
					id: 'policyId',
					width: '0px',
					visible: false
				},
				{
					id: 'lineCd',
					width: '0px',
					visible: false
				},
				{
					id: 'parNo',
					title: 'PAR No.',
					width: '120px',
					sortable: true,
					filterOption: true
				},
				{
					id: 'policyNo',
					title: 'Policy No.',
					width: '250px',
					sortable: true,
					filterOption: true
				},
				{
					id: 'assdName',
					title: 'Assured',
					width: '250px',
					sortable: true,
					filterOption: true
				},
				{
					id: 'plateNo',
					title: 'Plate No.',
					width: '120px',
					sortable: true,
					filterOption: true
				},
				{
					id: 'serialNo',
					title: 'Chassis No.',
					width: '120px',
					sortable: true,
					filterOption: true
				},
				{
					id: 'motorNo',
					title: 'Engine No.',
					width: '120px',
					sortable: true,
					filterOption: true
				},
				{
					id: 'inceptDate',
					title: 'Incept Date',
					width: '80px',
					visible: true,
					sortable: true,
					filterOption: true,
					filterOptionType: 'formattedDate',
					renderer: function(value){
						return formatDateToDefaultMask(value);
					}
				},
				{
					id: 'expiryDate',
					title: 'Expiry Date',
					width: '80px',
					visible: true,
					sortable: true,
					filterOption: true,
					filterOptionType: 'formattedDate',
					renderer: function(value){
						return formatDateToDefaultMask(value);
					}
				},
				{	id: 'tsi',
					title: 'TSI',
					width: '155px',
					align: 'right',
					geniisysClass: 'money',
					sortable: true
				},
				{	id: 'prem',
					title: 'Prem',
					width: '155px',
					align: 'right',
					geniisysClass: 'money',
					sortable: true
				},
				{	id: 'premCollns',
					title: 'Prem Collns',
					width: '155px',
					align: 'right',
					geniisysClass: 'money',
					sortable: true
				},
				{	id: 'claimsPd',
					title: 'Claims Paid',
					width: '155px',
					align: 'right',
					geniisysClass: 'money',
					sortable: true
				}   
			],
			rows: objVehicleItems.objRows
		};
		
		vItemTG = new MyTableGrid(vItemTableModel);
		vItemTG.pager = objVehicleItems.tablegrid;
		vItemTG.render('vehicleItemsTGDiv');
		
	}catch(e){
		showErrorMessage("Vehicle Item Details Listing table grid error", e);
	}
	
	
	function refreshVehicleItemsTableGrid(){
		if (selectedVehicleRow == null){
			vItemTG.onRemoveRowFocus();
			vItemTG.url = contextPath + "/GIPIPARListController?action=getParVehicleItemsGIPIS211&refresh=1";
			vItemTG._refreshList();
		}else if (selectedVehicleRow != null){
			vItemTG.onRemoveRowFocus();
			vItemTG.url = contextPath + "/GIPIPARListController?action=getParVehicleItemsGIPIS211&refresh=1&nbtLineCd="+selectedVehicleRow.nbtLineCd+
							"&nbtPlateNo="+selectedVehicleRow.plateNo+"&nbtSerialNo="+selectedVehicleRow.serialNo+
							"&nbtMotorNo="+selectedVehicleRow.motorNo;
			vItemTG._refreshList();
		}
	}
	
}catch(e){
	showErrorMessage("Subpage error", e);
}
</script>