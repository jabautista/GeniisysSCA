function showCreditMemoDtlsLOV(fundCd, memoType, payMode) {
	LOV.show({
		controller: "AccountingLOVController",
		urlParameters: {action: "getCreditMemoDtlsList",
						fundCd: fundCd,
						memoType: memoType,
						payMode: payMode,
						page: 1},
		title: "Valid Values for RI Commissions Credit Memo",
		width: 470,
		height: 300,
		columnModel : [
		               {
		            	   id : 'cmNo',
		            	   title: memoType == "RCM" ? "RCM No." : "CM No.",
		            	   width: '100px'
		               },
		               {
		            	   id: 'memoDate',
		            	   type: 'date',
		            	   title: "Tran Date",
		            	   width: '75px'
		               },
		               {
		            	   id: 'amount',
		            	   title: "Local Amount",
		            	   geniisysClass: "money",
		            	   align: 'right',
		            	   width: '100px'
		               },
		               {
		            	   id: 'shortName',
		            	   title: "Currency",
		            	   width: '80px'
		               },
		               {
		            	   id: "currencyRt",
		            	   title: "Rate",
		            	   width: '90px'
		               }
		              ],
		draggable: true,
		onSelect: function(row) {
			$("checkCreditCardNo").value = unescapeHTML2(row.cmNo);
			$("checkDateCalendar").value = dateFormat(row.memoDate, "mm-dd-yyyy");
			$("localCurrAmt").value = formatCurrency(row.localAmt);
			$("currency").value = row.currencyCd;
			$("currRt").value = formatToNineDecimal(row.currencyRt);
			$("hidCmTranId").value = row.cmTranId;
			if (unformatCurrency("deductionComm") != 0 || unformatCurrency("vatAmount") != 0){
				$("origlocalCurrAmt").value = unformatCurrency("localCurrAmt") + (unformatCurrency("deductionComm") + unformatCurrency("vatAmount"));
				$("grossAmt").value = formatCurrency($F("origlocalCurrAmt"));
				$("fcGrossAmt").value = formatCurrency( Math.round((unformatCurrency("origlocalCurrAmt") / parseFloat($F("currRt")))*100)/100 );
				$("origFCGrossAmt").value  = unformatCurrency("fcGrossAmt");
			}else{
				$("origlocalCurrAmt").value = unformatCurrency("localCurrAmt");
				$("grossAmt").value = formatCurrency($F("localCurrAmt"));
				$("fcGrossAmt").value = formatCurrency( Math.round((unformatCurrency("localCurrAmt") / parseFloat($F("currRt"))) *100 ) /100);
				$("origFCGrossAmt").value = unformatCurrency("fcGrossAmt");
				$("fcNetAmt").value = formatCurrency( Math.round((unformatCurrency("localCurrAmt") / parseFloat($F("currRt"))) *100 ) /100);
			}
		}
	});
}