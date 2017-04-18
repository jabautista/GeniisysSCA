<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="contentsDiv">
	<!--  Hidden Fields -->
	<input type="hidden" id="selectedTranType" value="" />
	<input type="hidden" id="selectedIssCd" value="" />
	<input type="hidden" id="selectedPremSeqNo" value="" />
	<input type="hidden" id="selectedInstNo" value="" />
	<input type="hidden" id="selectedCollnAmt" value="" />
	<input type="hidden" id="selectedPremAmt" value="" />
	<input type="hidden" id="selectedTaxAmt" value="" />
	<input type="hidden" id="selectedCurrCd" value="" />
	<input type="hidden" id="selectedCurrRT" value="" />
	<!--  End Hidden Fields -->
	
	<div style="padding: 10px; height: 350px; background-color: #ffffff; overflow: auto;" id="datedCheckResults" align="center">
	</div>
	
	<div id="divB" align="right" style="margin: 10px; margin-right: 0;">
		<input type="button" id="btnOk" class="button" value="Ok" style="width: 60px;" />
		<input type="button" id="btnCancel" class="button" value="Cancel" style="width: 60px;" onclick="Modalbox.hide();" />
	</div>
</div>
<script type="text/javascript">
	getDatedChecks();
		
	$("btnOk").observe("click", function () {
		$("tranType").value = objAC.selectedTranType;
		$("tranSource").value = objAC.selectedIssCd;
		$("billCmNo").value = objAC.selectedPremSeqNo;
		$("instNo").value = objAC.selectedInstNo;
		$("premCollectionAmt").value = formatCurrency(objAC.selectedCollnAmt);
		$("directPremAmt").value = formatCurrency(objAC.selectedPremAmt);
		$("taxAmt").value = formatCurrency(objAC.selectedTaxAmt);
		
		if (!$F("tranType").empty() && !$F("tranSource").empty() && !$F("billCmNo").empty()){
			//validateBillNo();
			//$("requery").value = "true";
			//jsonDirectPremCollnsHiddenInfo.requery = "true";
			//objAC.preChangedFlag == 'Y';
			fireEvent($("instNo"), "change");
			$("premCollectionAmt").value = formatCurrency(objAC.selectedCollnAmt);
			$("directPremAmt").value = formatCurrency(objAC.selectedPremAmt);
			$("taxAmt").value = formatCurrency(objAC.selectedTaxAmt);
			fireEvent($("premCollectionAmt"), "change");
		}
		Modalbox.hide();
	});
	
	function getDatedChecks(){
		new Ajax.Updater("datedCheckResults", "GIACDirectPremCollnsController?action=showDatedCheckDetailResult", {
			parameters: {
				gaccTranId: objACGlobal.gaccTranId
		},
			onCreate: function() { 
				showLoading("datedCheckResults", "Getting list, please wait...", "100px");
			}, 
			asynchronous: true, 
			evalScripts: true
		});
		
		modalPageNo2 = 1;
	}
</script>