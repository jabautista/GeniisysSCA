/**
 * Shows giac inst no list of values
 * @author d.alcantara
 * @date 03.12.2012
 * @module GICLS017
 */
function showPayeeLOVGIACS017(tranType, lineCd, adviceId, claimId, notIn) {//added notIn reymon 04252013
	LOV.show({
		controller: "AccountingLOVController",
		urlParameters: {action: "getPayeeClassLOV",
			tranType: 	tranType,
			lineCd: 	lineCd,
			adviceId : 	adviceId,
			claimId: 	claimId,
			notIn:		notIn},
		title: "Payee Class List",
		width: 700,
		height: 320,
		columnModel: [
				{
				   id: "payeeType",
				   title: "Payee Type",
				   width: '75px',
				   align: 'center',
				   titleAlign: 'center'
				},
				{
				   id: "payeeClassCode",
				   title: "Class Cd",
				   width: '75px',
				   align: 'center',
				   titleAlign: 'center'
				},
				{
				   id: "payeeCode",
				   title: "Payee Cd",
				   width: '70px',
				   align: 'center',
				   titleAlign: 'center'
				},
				{
				   id: "payee",
				   title: "Payee",
				   width: '250px',
				   align: 'left',
				   titleAlign: 'center'
				},
				{
				   id: "perilSname",
				   title: "Peril",
				   width: '50px',
				   align: 'left',
				   titleAlign: 'center'
				},
				{
				   id: "netAmount",
				   title: "Disbursement Amt.",
				   width: '150px',
				   align: 'right',
				   titleAlign: 'center',
            	   renderer: function(value){
            		   return formatCurrency(value);
            	   }
				}
		   ],
		draggable: true,
		onSelect: function(row) {
			$("selPayeeClass2").value = row.payeeTypeDescription;
			onSelectPayee(row);
			//computeDCPAdviceAmounts(row);
			computeSelectedAdvAmt(row);
		}
	});
}