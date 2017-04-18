/**
 * Shows giac bill no list of values
 * @author andrew robes
 * @date 11.3.2011
 * @module GIACS090
 */
function showBillNoLOV(issCd, tranType){
	LOV.show({
		//controller: "AccountingLOVController", kenneth SR 20856 12.02.2015
		controller: "AcCashReceiptsTransactionsLOVController",
		urlParameters: {action: "getBillNoLOV",
						issCd : issCd,
						tranType : tranType,
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
			/*$("txtPremSeqNo").writeAttribute("origPremSeqNo", $F("txtPremSeqNo"));
			$("txtPremSeqNo").value = formatNumberDigits(row.premSeqNo, 12);
			$("txtAssdName").value = row.assdName;
			$("txtPolicyEndtNo").value = row.policyNo;*/
		}
	});	
}