/**
 * Shows LOV for Aircaft Name
 * @author robert
 * @date 12.14.2011
 */
function getAircraftNameLOV() {	
	LOV.show({
		controller: "MarketingLOVController",
		urlParameters: {action : "getAircraftNameLOV",
						page   : 1},
		title: "Aircraft",
		width: 500,
		height: 400,
		columnModel: [ {   id: 'recordStatus',
							    title: '',
							    width: '0',
							    visible: false,
							    editor: 'checkbox' 			
							},
							{	id: 'divCtrId',
								width: '0',
								visible: false
							},
							{
								id: 'vesselCd',
								title: 'Vessel Code',
								sortable: false,
								width: '94px'
							},
							{
								id: 'vesselName',
								title: 'Vessel Name',
								sortable: false,
								width: '280px'
							},
							{
								id: 'rpcNo',
								title: 'Rpc No',
								sortable: false,
								width: '144px'
							},
							{
								id: 'vesselFlag',
								title: 'Vessel Flag',
								sortable: false,
								width: '100px'
							},
							{
								id: 'airDesc',
								title: 'Air Type',
								sortable: false,
								width: '190px'
							}
		              ],
		draggable: true,
  		onSelect: function(row){
				$("txtVesselName").value = unescapeHTML2(row.vesselName);
				$("txtAirType").value = unescapeHTML2(row.airDesc);
				$("txtRpcNo").value = row.rpcNo;
				$("txtVesselCd").value = row.vesselCd;
				$("txtVesselName").focus();
  		},
  		onCancel: function(){
  				$("txtVesselName").focus();
  		}
	});
}