/**
 * Shows LOV for Capacity
 * @author robert
 * @date 12.14.2011
 */
function getCapacityLOV() {
	LOV.show({
		controller: "MarketingLOVController",
		urlParameters: {action : "getCapacityLOV",
									  page : 1},
		title: "Capacity",
		width: 500,
		height: 386,
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
								id: 'position',
								title: 'Position',
								sortable: false,
								width: '387px'
							},
							{
								id: 'positionCd',
								title: 'Capacity Code',
								sortable: false,
								titleAlign: 'right',
								align: 'right',
								width: '94px'
							}
		              ],
		draggable: true,
  		onSelect: function(row){
				$("txtCapacityCd").value = row.positionCd;
				$("txtPosition").value = unescapeHTML2(row.position);
				$("txtCapacityCd").focus();
  		},
  		onCancel: function(){
  				$("txtCapacityCd").focus();
  		}
	});
}