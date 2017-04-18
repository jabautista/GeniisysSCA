<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="ajax" uri="http://ajaxtags.org/tags/ajax" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<select id="selAdviceSequenceNo" name="selAdviceSequenceNo" title="Advice Sequence Number" class="required" style="width: 72px; text-align:right;">
	<option></option>
</select>
<input type="hidden" id="claimIdAC017" name="claimIdAC017" value=""/>
<input type="hidden" id="adviceIdAC017" name="adviceIdAC017" value=""/>
<script type="text/javascript">
	var adviceSequenceArrayObj = eval('${adviceSequenceJsonObj}');
	
	function setAdviceSequenceOptions(){
		var selSequenceNo = $("selAdviceSequenceNo");
		selSequenceNo.update("<option></option>");
		for(var i = 0; i < adviceSequenceArrayObj.length; i++){
			var opt = new Element("option");
			opt.setAttribute("value", adviceSequenceArrayObj[i].adviceSequenceNumber.toPaddedString(6));
			opt.setAttribute("claimId", adviceSequenceArrayObj[i].claimId);
			opt.setAttribute("adviceId", adviceSequenceArrayObj[i].adviceId);
			opt.innerHTML = adviceSequenceArrayObj[i].adviceSequenceNumber.toPaddedString(6);
			selSequenceNo.insert(opt);
		}
	}

	$("selAdviceSequenceNo").observe("change", function(){
		$("claimIdAC017").value = $("selAdviceSequenceNo").options[$("selAdviceSequenceNo").selectedIndex].getAttribute("claimId");
		$("adviceIdAC017").value = $("selAdviceSequenceNo").options[$("selAdviceSequenceNo").selectedIndex].getAttribute("adviceId");
		if(!$F("selAdviceSequenceNo").blank()){
			$("claimIdAC017").value = $("selAdviceSequenceNo").options[$("selAdviceSequenceNo").selectedIndex].getAttribute("claimId");
			new Ajax.Updater("payeeClassDiv", "GIACDirectClaimPaymentController?action=filterPayeeClass", {
				method:			"GET",
				parameters:	{
					transType:		$F("selTransactionType"),
					lineCd:			$F("selAdviceLineCd"),
					adviceId:		$F("adviceIdAC017"),
					claimId:		$F("claimIdAC017")
				},
				evalScripts:	true,
				asynchronous:	true,
				onComplete: function(){
					$("txtClaimNumber").value 	= $F("tempClaimNo");
					$("txtPolicyNumber").value	= $F("tempPolicyNo");
					$("txtAssuredName").value 	= $F("tempAssured");
					$("selPayeeClass").enable();
					$("hidAdviceNumber").value 	= $F("selAdviceLineCd") + "-" + 
												  $F("selAdviceIssCd")	+ "-" + 
												  $F("selAdviceYear")	+ "-" + 
												  $F("selAdviceSequenceNo") ;
				}
			});
		}else{
			$("claimIdAC017").value 	= "";
			$("txtClaimNumber").value 	= "";
			$("txtPolicyNumber").value	= "";
			$("txtAssuredName").value 	= "";
			$("selPayeeClass").value 	= "";
			$("selPayeeClass").disable();
			$("hidAdviceNumber").value 	= "";
			$("txtPayee").value 		= "";
			$("txtPeril").value 		= "";
			$("txtDisbursementAmount").value = "";
		}	
	});
	
	setAdviceSequenceOptions();
</script>