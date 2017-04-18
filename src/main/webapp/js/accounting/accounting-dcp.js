/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	GIACS017 - DIRECT CLAIM PAYMENTS
 * Create Date	:	June 29, 2011
 ***************************************************/

/* GLOBAL VARIABLE DECLARATIONS */
var giacDirectClaimPaymentList = ""; 

var objDCPArr = [];  //added by d.alcantara, 04-11-2012, for direct claim payt table grid

/*=======
}

function filterPayeeClass(lineCd, adviceId, claimId) {
	new Ajax.Updater("payeeClassDiv", "GIACDirectClaimPaymentController?action=filterPayeeClass", {
		method:			"GET",
		parameters:	{
			transType:		$F("selTransactionType"),
			lineCd:			lineCd,
			adviceId:		adviceId,
			claimId:		claimId
		},
		evalScripts:	true,
		asynchronous:	true,
		onComplete: function(){
			$("txtClaimNumber").value 	= $F("tempClaimNo");
			$("txtPolicyNumber").value	= $F("tempPolicyNo");
			$("txtAssuredName").value 	= $F("tempAssured");
			$("selPayeeClass").enable();
		}
	});
}

function computeDCPAdviceAmounts(row) {
	try {
		if(!$F("selPayeeClass2").blank() && row != null){
			$("txtDisbursementAmount").value = formatCurrency(row.netAmount);
			$("txtPayee").value = row.payee;
			$("txtPeril").value = row.perilSname;

			// this section prevents unique key constraint exception
			var tranId 		= objACGlobal.gaccTranId;
			var claimLossId = row.claimLossId; // #currentTask
			var claimId		= $F("claimIdAC017");
			var proceed = true;
			for(var index = 0; index < dcpJsonObjectList.length; index++){
				if(dcpJsonObjectList[index].gaccTranId 	 == tranId  && 
					dcpJsonObjectList[index].claimId 	 == claimId	&&
					dcpJsonObjectList[index].claimLossId == claimLossId	){
					proceed = false;
				}
			}
			
			// compute inputVat, withholding, netDisbursement
			if(!proceed){
				showMessageBox("Claim Loss has already been used.", imgMessage.ERROR);
			}else{
				new Ajax.Request(contextPath+"/GIACDirectClaimPaymentController?action=computeAdviceAmounts", {
					method:			"GET",
					evalScripts:	true,
					asynchronous:	true,
					parameters:	{
						vCheck: 				"0",
						transactionType: 		$F("selTransactionType"),
						gaccTranId: 			objACGlobal.gaccTranId,
						claimId: 				$F("claimIdAC017"),
						claimLossId: 			row.claimLossId, // NOT null 
						adviceId: 				$F("adviceIdAC017"),
						inputVatAmount: 		$F("hidInputVatAmount"),
						withholdingTaxAmount: 	$F("hidWithholdingTaxAmount"),
						netDisbursementAmount: 	$F("hidNetDisbursementAmount"),
						toObject:				"N"
					},
					onComplete: function(response){
						if(checkErrorOnResponse(response)) {
							var res = JSON.parse(response.responseText);
							$("txtInputTax").value 			= formatCurrency($F("hidInputVatAmount"));
							$("txtWithholdingTax").value 	= formatCurrency($F("hidWithholdingTaxAmount"));
							$("txtNetDisbursement").value 	= formatCurrency($F("hidNetDisbursementAmount"));
							
							$("hidInputVatAmount").value = res.inputVatAmount;
							$("hidWithholdingTaxAmount").value = res.withholdingTaxAmount;
							$("hidNetDisbursementAmount").value = res.netDisbursementAmount;
							
							$("totalNetDisbursementAmount").value = res.totalNetDisbursementAmount;
							$("totalInputVatAmount").value = res.sumInputVatAmount;
							$("totalWithholdingTaxAmount").value = res.totalWithholdingTaxAmount;
						}
					} 
				});
			}
		}else{
			$("txtPayee").value	= "";
			$("txtPeril").value	= "";
			$("txtDisbursementAmount").value= formatCurrency(0);
		}
	} catch(e) {
		showErrorMessage("computeAdviceAmounts", e);
	}
}

function getDCPClaimDetail(claimId) {
	try {
		new Ajax.Request(contextPath+"/GIACDirectClaimPaymentController", {
			method: "GET",
			parameters: {
				action: "getClaimDetail",
				claimId: claimId
			},
			evalScripts:	true,
			asynchronous:	true,
			onComplete: function(response) {
				var res = JSON.parse(response.responseText);
				$("txtClaimNumber").value 	= res.claimNo;
				$("txtPolicyNumber").value	= res.policyNo;
				$("txtAssuredName").value 	= res.assured;
			}
		});
	} catch(e) {
		showErrorMessage("getDCPClaimDetail", e);
	}
} 
>>>>>>> .merge-right.r5481*/
//rechecked in SR-4238 for baseline : shan 05.22.2015