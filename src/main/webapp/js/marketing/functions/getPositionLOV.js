/**
 * Shows LOV for Position
 * @author robert
 * @date 12.14.2011
 */
function getPositionLOV() {
	LOV.show({
		controller: "MarketingLOVController",
		urlParameters: {action : "getCapacityLOV",
									  page : 1},
		title: "Position",
		width: 400,
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
								width: '383px'
							}
		              ],
		draggable: true,
  		onSelect: function(row){
				$("txtPositionCd").value = row.positionCd;
				$("txtDspOccupation").value = unescapeHTML2(row.position);
				$("txtDspOccupation").focus();
  		},
  		onCancel: function(){
  				$("txtDspOccupation").focus();
  		}
	});
}