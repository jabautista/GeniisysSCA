function createDirectClaimPaytObj(){
	var aDcpObj = new Object();
	var disbrsAmt = formatCurrency($F("txtDisbursementAmount"));	var transType = $F("selTransactionType");
	var inputTax  = formatCurrency($F("txtInputTax"));				var adviceNum =  $F("txtLineCd")+" - "+$F("txtIssCd")+" - "+
	  																				$F("txtAdviceYear")+" - "+$F("txtAdvSeqNo");;
	var wHoldClas = formatCurrency($F("txtWithholdingTax"));		var peril	  = $F("txtPeril");
	var netDsburs = formatCurrency($F("txtNetDisbursement"));		var payeeClas = $F("txtPayee");
	var clmLossId = $F("claimLossId");
	var payeeType = $F("payeeType");

    var payeeVal = "";
	if(payeeType == "L"){			payeeVal = "Loss";		}
	else if(payeeType == "E"){		payeeVal = "Expense";	}
	aDcpObj.id				= $F("claimIdAC017")+$("claimLossId");
	aDcpObj.assuredName		= $F('txtAssuredName');
	aDcpObj.lineCode		= $F("txtLineCd");
	aDcpObj.issueCode		= $F("txtIssCd");
	aDcpObj.adviceYear		= $F("txtAdviceYear");
	aDcpObj.adviceSequence	= $F("txtAdvSeqNo");
	
	aDcpObj.adviceNumber	= $F("txtLineCd")+" - "+$F("txtIssCd")+" - "+
							  $F("txtAdviceYear")+" - "+$F("txtAdvSeqNo");
	
	aDcpObj.claimId			= $F("claimIdAC017");
	aDcpObj.claimNumber		= $F("txtClaimNumber");
	aDcpObj.claimLossId		= clmLossId;
	aDcpObj.convertRate		= $F("dcpConvertRate").replace(/,/g, "");
	aDcpObj.currencyCode	= $F("dcpCurrencyCode");
	aDcpObj.disbursementAmount	= disbrsAmt.replace(/,/g, "");
	
	aDcpObj.inputVatAmount	= inputTax.replace(/,/g, "");
	aDcpObj.foreignCurrencyRate = $F("dcpForeignCurrencyAmt");
	aDcpObj.gaccTranId		= objACGlobal.gaccTranId;
	
	aDcpObj.netDisbursementAmount = netDsburs.replace(/,/g, "");
	aDcpObj.payee = $F("txtPayee");
	aDcpObj.payeeClass = payeeVal;
	aDcpObj.payeeCode = $F("payeeCode");
	aDcpObj.payeeClassCode = $F("payeeClassCd");
	aDcpObj.payeeTypeDescription = $F("selPayeeClass2");
	aDcpObj.payeeType = payeeType;
	aDcpObj.perilCode = $F("hidPerilCd");
	aDcpObj.perilSname = $F("txtPeril");
	aDcpObj.policyNumber = $F("txtPolicyNumber");
	aDcpObj.remarks = $F("txtRemarks");
	aDcpObj.transactionType = transType;
	aDcpObj.withholdingTaxAmount = wHoldClas.replace(/,/g, "");

	aDcpObj.recordStatus = 0;
	return aDcpObj;
}