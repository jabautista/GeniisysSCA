/**
 * Shows LOV for Pol Seq No.
 * @author robert
 * @date 12.14.2011
 */
function getPolbasicPolSeqNoLOV(lineCd, sublineCd, issCd, issueYy) {
	LOV.show({
		controller: "ClaimsLOVController",
		urlParameters: {action : "getPolbasicPolSeqNoLOV",
									  lineCd: lineCd,
									  sublineCd: sublineCd,
									  issCd: issCd,
									  issueYy: issueYy,
									  page : 1},
		title: "Policy Sequence Number",
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
								id: 'polSeqNo',
								title: 'Pol Seq No.',
								titleAlign: 'right',
								align: 'right',
								width: '200px',
								renderer: function (value){
									return nvl(value,'') == '' ? '' :formatNumberDigits(value,7);
								}
							}
		              ],
		draggable: true,
  		onSelect: function(row){
				$("txtPolSeqNo").value = parseInt(row.polSeqNo).toPaddedString(7);
				$("txtPolSeqNo").focus();
				$("txtRenewNo").clear(); //added by steven 12/19/2012
  		},
  		onCancel: function(){
  				$("txtPolSeqNo").focus();
  		}
	});
}