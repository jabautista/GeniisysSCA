/**
 * WORKS CORRECTLY BUT is not reusable
 */
function createDirectClaimPaymentRow(){
	var newRow = new Element("div");
	var tableContainer = $("directClaimPaymentListing");
	
	newRow.setAttribute("id", 	"dcpRow" + $F("txtAdviceSequence"));
	newRow.setAttribute("name", "dcpRow");
	newRow.setAttribute("class","tableRow");
	var properties = "";
	
	var disbrsAmt = formatCurrency($F("txtDisbursementAmount"));	var transType = $F("selTransactionType");
	var inputTax  = formatCurrency($F("txtInputTax"));				var adviceNum = $F("txtAdviceSequence");
	var wHoldClas = formatCurrency($F("txtWithholdingTax"));		var peril	  = $F("txtPeril");
	var netDsburs = formatCurrency($F("txtNetDisbursement"));		var payeeClas = $F("txtPayee");
	//var clmLossId = $("selPayeeClass").options[$("selPayeeClass").selectedIndex].getAttribute("claimLossId");
	//var payeeType = $("selPayeeClass").options[$("selPayeeClass").selectedIndex].getAttribute("payeeType");
	// visible properties
	var payeeShrt = "";
	
	if(payeeClas.length > 14){
		payeeShrt = payeeClas.substr(0,13) + "...";
	}else{
		payeeShrt = payeeClas;
	}

	var payeeVal = $("selPayeeClass").options[$("selPayeeClass").selectedIndex].getAttribute("payeeType");
	if(payeeVal == "L"){			payeeVal = "Loss";		}
	else if(payeeVal == "E"){		payeeVal = "Expense";	}

	var aDcpObj = new Object();
	aDcpObj.id = $F('txtAdviceSequence');
	aDcpObj.assuredName = $F('txtAssuredName');		
	aDcpObj.adviceNumber = $F('txtAdviceSequence');
	aDcpObj.adviceSequence = $F('sequenceAC017');
	aDcpObj.adviceYear = $F('yearAC017');
	aDcpObj.claimId = $F('claimIdAC017');
	aDcpObj.claimNumber	= $F("txtClaimNumber");
	aDcpObj.claimLossId = $("selPayeeClass").options[$("selPayeeClass").selectedIndex].getAttribute("claimLossId");
	aDcpObj.convertRate = $F("dcpConvertRate").replace(/,/g, ""); //aDcpObj.cpiBranchId;	aDcpObj.cpiRecNo;
	aDcpObj.currencyCode = $F("dcpCurrencyCode");
	aDcpObj.disbursementAmount	= disbrsAmt.replace(/,/g, "");
	aDcpObj.issueCode = $F('issCdAC017');
	aDcpObj.inputVatAmount = inputTax.replace(/,/g, "");
	aDcpObj.foreignCurrencyRate = $F("dcpForeignCurrencyAmt");
	aDcpObj.gaccTranId = objACGlobal.gaccTranId; //**
	aDcpObj.lineCode = $F('lineCdAC017');
	aDcpObj.netDisbursementAmount = netDsburs.replace(/,/g, "");
	//aDcpObj.orPrintTag;	//aDcpObj.originalCurrencyCode = $F("");	//aDcpObj.originalCurrencyRate = $F("");
	aDcpObj.payee = $F('txtPayee');
	aDcpObj.payeeClass = payeeVal;
	aDcpObj.payeeCode = $F('selPayeeClass');
	aDcpObj.payeeClassCode = $("selPayeeClass").options[$("selPayeeClass").selectedIndex].getAttribute("payeeClassCode");
	aDcpObj.payeeType = payeeType;
	aDcpObj.perilCode = $F('txtPeril');
	aDcpObj.policyNumber = $F('txtPolicyNumber');
	aDcpObj.remarks = $F('txtRemarks');
	aDcpObj.transactionType = transType;
	aDcpObj.withholdingTaxAmount = wHoldClas.replace(/,/g, "");
	aDcpObj.recordStatus = 0;
	properties = prepareDirectClaimPaymentContents(aDcpObj);
	newRow.update(properties);

	if($("dcpRow" + $F("txtAdviceSequence")) == null){
		tableContainer.insert(newRow);
		dcpJsonObjectList.push(aDcpObj);
	}else{
		showMessageBox("Direct Claim Payment entry already exists" + e.message ,imgMessage.ERROR);
	}
	addDcpRowEvents(newRow);
}