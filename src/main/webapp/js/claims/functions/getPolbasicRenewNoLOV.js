/**
 * Shows LOV for Renew No.
 * @author robert
 * @date 12.14.2011
 */
function getPolbasicRenewNoLOV(lineCd, sublineCd, issCd, issueYy, polSeqNo) {
	LOV.show({
		controller: "ClaimsLOVController",
		urlParameters: {action : "getPolbasicRenewNoLOV",
									  lineCd: lineCd,
									  sublineCd: sublineCd,
									  issCd: issCd,
									  issueYy: issueYy,
									  polSeqNo: polSeqNo,
									  page : 1},
		title: "Renew Number",
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
								id: 'renewNo',
								title: 'Renew No.',
								titleAlign: 'right',
								align: 'right',
								width: '200px',
								renderer: function (value){
									return nvl(value,'') == '' ? '' :formatNumberDigits(value,2);
								}
							}
		              ],
		draggable: true,
  		onSelect: function(row){
				$("txtRenewNo").value = parseInt(row.renewNo).toPaddedString(2);
				$("txtRenewNo").focus();
  		},
  		onCancel: function(){
  				$("txtRenewNo").focus();
  		}
	});
}