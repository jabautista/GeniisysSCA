/**
 * retrieve list of payees per advice no.
 * 
 * @author John Dolon 3.9.2015
 * @version 1.0
 * @param line_cd, advice_cd, claim_id, tran_type
 * @return obj - list of records from gicl_clm_loss_exp
 */
function getListOfPayees(){
	try {
		new Ajax.Request(contextPath+"/GIACDirectClaimPaymentController", {
			method: "POST",
			parameters:{
				action: 	"getListOfPayees",
			 	lineCd: 	$F("txtLineCd"),
			 	adviceId:  	$F("adviceIdAC017"),
			 	claimId: 	$F("claimIdAC017"),
			 	tranType: 	$F("selTransactionType")
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				if(checkErrorOnResponse(response)) {
					var result = JSON.parse(response.responseText);
					
					for ( var i = 0; i < result.length; i++) {
						onSelectPayee(result[i]);
						computeSelectedAdvAmt(result[i]);
						$("sumDspNetAmt").value = formatCurrency(unformatCurrency("sumDspNetAmt") + unformatCurrency("txtNetDisbursement"));
						var obj = {};
						
						obj.gaccTranId 				= objACGlobal.gaccTranId;
						obj.transactionType 		= $F("selTransactionType");
						obj.claimId 				= $F("claimIdAC017");
						obj.claimLossId				= $F("claimLossId");
						obj.adviceId				= $F("adviceIdAC017");
						obj.payeeCd					= $F("payeeCode");
						obj.payeeClassCd			= $F("payeeClassCd");
						obj.payeeType				= $F("payeeType");
						obj.disbursementAmount		= unformatCurrency("txtDisbursementAmount");
						obj.currencyCode			= $F("selCurrency");	
						obj.convertRate				= $F("dcpConvertRate");
						obj.foreignCurrencyAmount	= unformatCurrency("dcpForeignCurrencyAmt");
						obj.orPrintTag				= "N";
						obj.remarks					= $F("txtRemarks");
						obj.inputVatAmount			= unformatCurrency("txtInputTax");
						obj.withholdingTaxAmount	= unformatCurrency("txtWithholdingTax");
						obj.netDisbursementAmount	= unformatCurrency("txtNetDisbursement");
						obj.originalCurrencyCode	= "";
						obj.originalCurrencyRate	= "";
						
						obj.dspAdviceNo				= $F("txtLineCd")+"-"+$F("txtIssCd")+"-"+
													  $F("txtAdviceYear")+"-"+lpad($F("txtAdvSeqNo"),7,0);
						obj.currencyDesc			= $F("dcpCurrencyDesc");
						obj.dspIssCd				= $F("txtIssCd");
						obj.dspLineCd				= $F("txtLineCd");
						obj.dspAdviceYear			= $F("txtAdviceYear");
						obj.dspAdviceSeqNo			= $F("txtAdvSeqNo");
						obj.dspPayeeDesc			= $F("selPayeeClass2");
						obj.dspPerilName			= $F("txtPeril");
						obj.dspPayeeName			= $F("txtPayee");
						obj.claimNumber				= $F("txtClaimNumber");
						obj.policyNumber			= $F("txtPolicyNumber");
						obj.dspAssuredName			= $F("txtAssuredName");
						
						obj.recordStatus = "0";
						
						gdcpGrid.addBottomRow(obj);
						changeTag = 1;
						
					}
					populateGDCPFields(null, false);
					enableDisableGDCPInputs();
					selectedGDCPIndex = null;
					gdcpGrid.releaseKeys();
				}
			}
		}); 
	} catch(e) {
		showErrorMessage("getListOfPayees", e);
	}
}
