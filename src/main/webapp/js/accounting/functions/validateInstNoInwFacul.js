/**
 * Validate the installment no. in Inward Facultative Premium Collections
 * 
 * @author Jerome Orio 09.06.2010
 * @version 1.0
 * @param
 * @return
 */
function validateInstNoInwFacul(instNo, populate) {
	var vMsgAlert = "";
	var a180RiCd;
	if ($("transactionTypeInw").value == "2"
			|| $("transactionTypeInw").value == "4") {
		a180RiCd = $("a180RiCdInw").value;
	} else {
		a180RiCd = $("a180RiCd2Inw").value;
	}
	new Ajax.Request(contextPath
			+ '/GIACInwFaculPremCollnsController?action=validateInstNo', {
		parameters : {
			a180RiCd : a180RiCd,
			b140IssCd : $("b140IssCdInw").value,
			transactionType : $("transactionTypeInw").value,
			b140PremSeqNoInw : $("b140PremSeqNoInw").value,
			instNo : instNo,
			tranDate : $("tranDate").value //Deo [01.20.2017]: SR-5909
		},
		asynchronous : false,
		evalScripts : true,
		onComplete : function(response) {
			var text = response.responseText;
			var arr = text.split(resultMessageDelimiter);
			vMsgAlert = arr[8];
			if (isNaN(arr[0]) && arr[0] != "null") {
				vMsgAlert = arr[0];
			}
			if (vMsgAlert == "" || vMsgAlert == null || vMsgAlert == "null") {
				if (populate == "Y") {
					$("collectionAmtInw").value = formatCurrency(arr[0]);
					$("defCollnAmtInw").value = arr[0];
					$("premiumAmtInw").value = formatCurrency(arr[1]);
					$("premiumTaxInw").value = arr[2];
					$("wholdingTaxInw").value = arr[3];
					$("commAmtInw").value = formatCurrency(arr[4]);
					$("foreignCurrAmtInw").value = formatCurrency(arr[5]);
					$("defForgnCurAmtInw").value = arr[5];
					$("taxAmountInw").value = formatCurrency(arr[6]);
					$("commVatInw").value = formatCurrency(arr[7]);

					$("variableSoaCollectionAmtInw").value = arr[0];
					$("variableSoaPremiumAmtInw").value = arr[1];
					$("variableSoaPremiumTaxInw").value = arr[2];
					$("variableSoaWholdingTaxInw").value = arr[3];
					$("variableSoaCommAmtInw").value = arr[4];
					$("variableSoaTaxAmountInw").value = arr[6];
					$("variableSoaCommVatInw").value = arr[7];

					// $("assdNoInw").value = arr[9];
					// $("assuredNameInw").value = arr[10];
					// $("policyNoInw").value = arr[11];
					$("convertRateInw").value = formatToNineDecimal(arr[12]);
					$("currencyCdInw").value = arr[13];
					$("currencyDescInw").value = arr[14];
					$("hasClaim").value = arr[15]; //Deo [01.20.2017]: SR-5909
					$("daysOverDue").value = arr[16]; //Deo [01.20.2017]: SR-5909
				}
			}
			$("vldtInstNoMsg").value = vMsgAlert; //Deo [01.20.2017]: SR-5909
		}
	});
	return vMsgAlert;
}