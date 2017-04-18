/**
Shows list of giac payees' names
* @author m. cadwising
* @date 03.22.2012
* @module GIACS039
*/
function showPayeeNamesLOV(payeeClassCd){
	LOV.show({
		controller : "AccountingLOVController",
		urlParameters : {action : "getPayeeNamesLOV",
			payeeClassCd : payeeClassCd },
		title: "Payee List",
		width: 700,
		height: 380,
		columnModel: [
 			{
				id : 'payeeNo',
				title: 'Payee No.',
				width : '101px',
				align: 'right',
				titleAlign: 'right'
			},
			{
				id : 'payeeFirstName',
				title: 'First Name',
			    width: '193px',
			    align: 'left',
			    titleAlign: 'left'
			},
			{
				id : 'payeeMiddleName',
				title: 'Middle Name',
			    width: '193px',
			    align: 'left',
			    titleAlign: 'left'
			},
			{
				id : 'payeeLastName',
				title: 'Last Name',
			    width: '194px',
			    align: 'left',
			    titleAlign: 'left'
			}
		],
		draggable: true,
		onSelect: function(row) {
			$("txtPayeeNameInputVat").value = (row.payeeFirstName == null ? '' : row.payeeFirstName + " ") + (row.payeeMiddleName ==  null ? '' : row.payeeMiddleName + " ") + (row.payeeLastName == null ? '' : row.payeeLastName + " ");
			$("hidPayeeNoInputVat").value = row.payeeNo;
		}
	});
}