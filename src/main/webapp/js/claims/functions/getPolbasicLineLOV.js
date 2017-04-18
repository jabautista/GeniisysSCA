/**
 * Shows LOV for Issue Code/ Source
 * @author robert
 * @date 12.14.2011
 */
function getPolbasicLineLOV(moduleId, issCd) {
	LOV.show({
		controller: "ClaimsLOVController",
		urlParameters: {action : 	"getPolbasicLineLOV",
					    moduleId: 	moduleId,	// parameter added by shan 10.14.2013
					    issCd:	  	issCd,	// parameter added by shan 10.14.2013
						page : 		1},
		title: "Line Code",
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
								id: 'lineCd',
								title: 'Line Cd',
								width: '100px'
							},
							{
								id: 'lineName',
								title: 'Line Name',
								width: '251px'
							}
		              ],
		draggable: true,
  		onSelect: function(row){
				$("txtLineCd").value = row.lineCd;
				$("txtLineCd").focus();
  		},
  		onCancel: function(){
  				$("txtLineCd").focus();
  		}
	});
}