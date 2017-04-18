
function showGlTranTypeLOV(search, ledgerCd, subLedgerCd) {
	LOV.show({
		controller: "ACGeneralLedgerTransactionsLOVController",
		urlParameters: {action : "getGiacs030TranTypeLOV",
					  ledgerCd : unescapeHTML2(ledgerCd),
				   subLedgerCd : unescapeHTML2(subLedgerCd),
				    filterText : search},
		title: "Transaction Types",
		width: 460,
		height: 300,
		columnModel : [
		               {
		            	   id : "transactionCd",
		            	   title: "Transaction Code",
		            	   width: '120px'
		               },
		               {
		            	   id: "transactionDesc",
		            	   title: "Transaction Desc",
		            	   width: '310px'
		               }
		              ],
		autoSelectOneRecord: true,
		filterText : search,		              
		draggable: true,
		onSelect: function(row) {
				$("txtTranCd").value = unescapeHTML2(row.transactionCd);
		}
	});
}