/**
 * Shows LOV for Issue Code/ Source
 * @author robert
 * @date 12.14.2011
 */
function getPolbasicSublineLOV(lineCd) {
	LOV.show({
		controller: "ClaimsLOVController",
		urlParameters: {action : "getPolbasicSublineLOV",
									  lineCd: lineCd,
									  page : 1},
		title: "Subline Code",
		width: 370,
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
								id: 'sublineCd',
								title: 'Subline Cd',
								width: '100px'
							},
							{
								id: 'sublineName',
								title: 'Subline Name',
								width: '251px'
							}
		              ],
		draggable: true,
  		onSelect: function(row){
				$("txtSublineCd").value = row.sublineCd;
				$("txtSublineCd").focus();
  		},
  		onCancel: function(){
  				$("txtSublineCd").focus();
  		}
	});
}