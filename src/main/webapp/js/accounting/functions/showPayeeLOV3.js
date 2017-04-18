/**
Shows list of Payees
* @author s. ramirez
* @date 06.08.2012
* @module GIACS022
*/
function showPayeeLOV3(payeeClassCd){
	LOV.show({
		controller : "AccountingLOVController",
		urlParameters : {action : "getPayeeLOV",
						payeeClassCd:payeeClassCd
						},
		title: "Payee List",
		width: 470,
		height: 380,
		columnModel: [
 			{
				id : 'payeeNo',
				title: 'Payee No.',
				width : '70px',
				align: 'right'
			},
			{
				id : 'payeeLastName',
				title: 'Name',
			    width: '350px',
			    align: 'left'
			}
		],
		draggable: true,
		onSelect: function(row) {
			$("hiddenPayeeCd").value =row.payeeNo;
			$("txtPayeeFirstName").value=row.payeeFirstName;
			$("txtPayeeMiddleName").value=row.payeeMiddleName;
			$("txtPayeeLastName").value=unescapeHTML2(row.payeeLastName);
			$("txtPayeeCd").value = unescapeHTML2(row.payeeLastName);
		}
	});
}