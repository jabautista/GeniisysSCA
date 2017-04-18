/**
 * Shows giac inst no list of values
 * @author andrew robes
 * @date 11.3.2011
 * @module GIACS090
 */
function showInstNoLOV(issCd, premSeqNo, notIn){
	LOV.show({
		controller: "AccountingLOVController",
		urlParameters: {action: "getInstNoLOV",
						issCd : issCd,
						premSeqNo : premSeqNo,
						notIn : notIn,
						page: 1},
		title: "Installment No. List",
		width: 378,
		height: 350,
		columnModel : [
		               {
		            	   id : "issCd",
		            	   title: "Issue Code",
		            	   width: '75px'		            	   
		               },
		               {
		            	   id: "premSeqNo",
		            	   title: "Bill No.",
		            	   width: '80px',
		            	   align: 'right'
		               },
		               {
		            	   id : "instNo",
		            	   title: "Inst No.",
		            	   width: '80px',
		            	   align: 'right'
		               },
		               {
		            	   id : "balAmtDue",
		            	   title: "Collection Amt",
		            	   width: '120px',
		            	   align: 'right',
		            	   renderer: function(value){
		            		   return formatCurrency(value);
		            	   }
		               },
		               {
		            	   id : "premBalDue",
		            	   title: "Premium Amt",
		            	   width: '0px',
		            	   align: 'right',
		            	   renderer: function(value){
		            		   return formatCurrency(value);
		            	   },
		            	   visible: false // bonok :: 3.21.2016 :: UCPB SR 21681
		               },
		               {
		            	   id : "taxBalDue",
		            	   title: "Tax Amt",
		            	   width: '0px',
		            	   align: 'right',
		            	   renderer: function(value){
		            		   return formatCurrency(value);
		            	   },
		            	   visible: false // bonok :: 3.21.2016 :: UCPB SR 21681
		               }
		              ],
		draggable: true,
		onSelect: function(row) {
			$("txtInstNo").writeAttribute("origInstNo", $F("txtInstNo"));
			$("txtInstNo").value = formatNumberDigits(row.instNo, 2);
			$("txtCollectionAmt").writeAttribute("origCollectionAmt", row.balAmtDue);
			$("txtCollectionAmt").writeAttribute("balancAmtDue", row.balAmtDue);
			$("txtCollectionAmt").value = formatCurrency(row.balAmtDue);
			$("txtPremAmt").value = formatCurrency(row.premBalDue);
			$("txtTaxAmt").value = formatCurrency(row.taxBalDue);
			//marco - UCPB SR 20856 - 11.27.2015
			$("selDtlCurrency").value = row.currencyCd;
			$("txtDtlCurrencyRt").value = formatToNineDecimal(row.currencyRt);
			if($F("txtCollectionAmt") != "" && $F("txtDtlCurrencyRt") != ""){
				$("txtDtlFCurrencyAmt").value = formatCurrency(parseFloat(nvl($F("txtCollectionAmt"), "0").replace(/,/g, "")) / parseFloat($F("txtDtlCurrencyRt")));
			}
		}
	});	
}