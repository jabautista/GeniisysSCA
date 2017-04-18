<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="ajax" uri="http://ajaxtags.org/tags/ajax" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<select id="selPayeeClass" name="selPayeeClass" title="Payee Class" class="required" style="width: 215px;">
	<option></option>
</select>
<input type="hidden" id="tempPolicyNo" 	name="tempPolicyNo"	value="${policyNumber}"/>
<input type="hidden" id="tempClaimNo" 	name="tempClaimNo" 	value="${claimNumber}"/>
<input type="hidden" id="tempAssured"	name="tempAssured"	value="${assuredName}"/>
<script type="text/javascript">
	var payeeClassArrayObj = null;
	try{
		payeeClassArrayObj = JSON.parse('${payeeClassJsonObj}'.replace(/\\/g, '\\\\'));
	}catch(e){
		showErrorMessage("payeeClassByAdviceSequence.jsp", e);
	}
		
	function setPayeeClassOptions(){
		var selPayeeClass = $("selPayeeClass");

		selPayeeClass.update("<option></option>");
		for(var i = 0; i < payeeClassArrayObj.length; i++){
			var opt = new Element("option");
			var payeeType;
			
			if(payeeClassArrayObj[i].payeeType == "L"){
				payeeType = "Loss";
			}else if(payeeClassArrayObj[i].payeeType == "E"){
				payeeType = "Expense";
			}
			opt.value = payeeClassArrayObj[i].payeeCode;
			opt.setAttribute("perilSname", payeeClassArrayObj[i].perilSname);
			//opt.setAttribute("value", payeeClassArrayObj[i].payeeCode);
			opt.setAttribute("objindex", i + 1);
			opt.setAttribute("payeeType", payeeClassArrayObj[i].payeeType);
			opt.setAttribute("payeeClassCode", payeeClassArrayObj[i].payeeClassCode);
			opt.setAttribute("claimLossId", payeeClassArrayObj[i].claimLossId);
			opt.setAttribute("payee", payeeClassArrayObj[i].payee);
			opt.setAttribute("disb", payeeClassArrayObj[i].netAmount);
			opt.innerHTML = payeeType;
			selPayeeClass.insert(opt);
		}
	}

	$("selPayeeClass").observe("change", function(){
		if(!$F("selPayeeClass").blank()){
			$("txtDisbursementAmount").value = formatCurrency($("selPayeeClass").options[$("selPayeeClass").selectedIndex].getAttribute("disb"));
			$("txtPayee").value = $("selPayeeClass").options[$("selPayeeClass").selectedIndex].getAttribute("payee");
			$("txtPeril").value = $("selPayeeClass").options[$("selPayeeClass").selectedIndex].getAttribute("perilSname");

			// this section prevents unique key constraint exception
			var tranId 		= objACGlobal.gaccTranId;
			var claimLossId = $("selPayeeClass").options[$("selPayeeClass").selectedIndex].getAttribute("claimLossId"); // #currentTask
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
				new Ajax.Updater("dcpAmountsDiv", "GIACDirectClaimPaymentController?action=computeAdviceAmounts", {
					method:			"POST",
					evalScripts:	true,
					asynchronous:	true,
					parameters:	{
						vCheck: 				"0",
						transactionType: 		$F("selTransactionType"),
						gaccTranId: 			objACGlobal.gaccTranId,
						claimId: 				$F("claimIdAC017"),
						claimLossId: 			$("selPayeeClass").options[$("selPayeeClass").selectedIndex].getAttribute("claimLossId"), // NOT null 
						adviceId: 				$F("adviceIdAC017"),
						inputVatAmount: 		$F("hidInputVatAmount"),
						withholdingTaxAmount: 	$F("hidWithholdingTaxAmount"),
						netDisbursementAmount: 	$F("hidNetDisbursementAmount"),
						toObject:				"N"
					},
					onCreate: function(){
					},
					onComplete: function(){
						$("txtInputTax").value 			= formatCurrency($F("hidInputVatAmount"));
						$("txtWithholdingTax").value 	= formatCurrency($F("hidWithholdingTaxAmount"));
						$("txtNetDisbursement").value 	= formatCurrency($F("hidNetDisbursementAmount"));
					} 
				});
			}
		}else{
			$("txtPayee").value	= "";
			$("txtPeril").value	= "";
			$("txtDisbursementAmount").value= formatCurrency(0);
		}
	});
	
	setPayeeClassOptions();
</script>