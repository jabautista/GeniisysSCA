/**
 * Shows LOV for Issue Code/ Source
 * @author robert
 * @date 12.14.2011
 */
function getPolbasicIssLOV(lineCd, sublineCd) {
	LOV.show({
		controller: "ClaimsLOVController",
		urlParameters: {action : "getPolbasicIssLOV",
									  lineCd: lineCd,
									  sublineCd: sublineCd,
									  page : 1},
		title: "Issue Code",
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
								id: 'issCd',
								title: 'Iss Cd',	// change Iss to Iss Cd : shan 10.11.2013
								width: '100px'
							},
							{
								id: 'issName',
								title: 'Iss Name',
								width: '251px'
							}
		              ],
		draggable: true,
  		onSelect: function(row){
				$("txtIssCd").value = row.issCd;
				$("txtIssCd").focus();
  		},
  		onCancel: function(){
  				$("txtIssCd").focus();
  		}
	});
}