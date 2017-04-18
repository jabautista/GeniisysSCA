/**
Shows list of Payee Class List
* @author s. ramirez
* @date 06.08.2012
* @module GIACS022
*/
function showPayeeClassLOV(){
	LOV.show({
		controller : "AccountingLOVController",
		urlParameters : {action : "getPayeeClassListLOV",
						},
		title: "Payee Class List",
		width: 470,
		height: 380,
		columnModel: [
 			{
				id : 'payeeClassCd',
				title: 'Payee Class',
				width : '70px',
				align: 'right'
			},
			{
				id : 'classDesc',
				title: 'Class Desc',
			    width: '350px',
			    align: 'left'
			}
		],
		draggable: true,
		onSelect: function(row) {
			$("txtPayeeCd").clear();
			$("hiddenPayeeClassCd").value =row.payeeClassCd;
			$("txtPayeeClassCd").value = unescapeHTML2(row.classDesc);
		}
	});
}