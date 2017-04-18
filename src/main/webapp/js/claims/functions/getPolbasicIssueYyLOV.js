/**
 * Shows LOV for Issue Yy
 * @author robert
 * @date 12.14.2011
 */
function getPolbasicIssueYyLOV(lineCd, sublineCd, issCd) {
	LOV.show({
		controller: "ClaimsLOVController",
		urlParameters: {action : "getPolbasicIssueYyLOV",
									  lineCd: lineCd,
									  sublineCd: sublineCd,
									  issCd: issCd,
									  page : 1},
		title: "Issue Year",
		width: 350,
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
								id: 'issueYy',
								title: 'Issue Yy',
								width: '200px',
								titleAlign: 'right',
								align: 'right',
								renderer: function (value){
									return nvl(value,'') == '' ? '' :formatNumberDigits(value,2);
								}
							}
		              ],
		draggable: true,
  		onSelect: function(row){
				$("txtIssueYy").value = parseInt(row.issueYy).toPaddedString(2);
				$("txtIssueYy").focus();
  		},
  		onCancel: function(){
  				$("txtIssueYy").focus();
  		}
	});
}