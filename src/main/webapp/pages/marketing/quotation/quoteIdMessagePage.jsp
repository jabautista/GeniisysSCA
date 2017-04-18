${message}
<input type="hidden" id="generatedQuoteId" name="generatedQuoteId" value="${quoteId}" />
<input type="hidden" id="message" name="message" value="${message}" />
<input type="hidden" id="quoteNo" name="quoteNo" value="${quotationNo}" />

<div name="row" class="selectedRow">
	<input type="hidden" value="${quoteId}">
	<input type="hidden" value="${quotationNo}" />
</div>
<script>
	if ($F("message") == "SUCCESS")	{
		/*$("btnMortgageeInformation").enable();
		$("btnMortgageeInformation").removeClassName("disabledButton");
		$("btnMortgageeInformation").addClassName("button");*/
		enableButton("btnMortgageeInformation");
	}
</script>