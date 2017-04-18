/**
 * Shows giac bill no list of values per tran type
 * @author John Dolon
 * @date 10.1.2014
 * @module GIACS090
 */
function showBillNoLOVPerTranType(issCd, tranType, notIn){
	LOV.show({
		controller: "AccountingLOVController",
		urlParameters: {action: "getBillNoLOVPerTranType",
						issCd : issCd,
						tranType : tranType,
						notIn : notIn,
						page: 1},
		title: "Bill No. List",
		width: 700,
		height: 380,
		columnModel : [
		               {
		            	   id : "issCd",
		            	   title: "Issue Cd",
		            	   width: '60px',
		            	   sortable : false
		               },
		               {
		            	   id: "premSeqNo",
		            	   title: "Prem Seq No",
		            	   width: '80px',
		            	   align: 'right'
		               },
		               {
		            	   id : "policyNo",
		            	   title: "Policy/Endorsement No",
		            	   width: '270px'
		               },
		               {
		            	   id : "assdName",
		            	   title: "Assured Name",
		            	   width: '250px'
		               }
		              ],
		draggable: true,
		onSelect: function(row) {
			giacPdcPremCollns.onSelectBill(row);
		}
	});	
}