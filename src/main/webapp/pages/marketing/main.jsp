<jsp:include page="/pages/marketing/menu.jsp"></jsp:include>
<div id="mkQuotationParameters" name="mkQuotationParameters" style="display: none;">
	<input type='hidden' name='globalQuoteId' 	id='globalQuoteId' 	value="0"/>
	<input type='hidden' name='globalPackQuoteId' 	id='globalPackQuoteId' 	value="0"/>
</div>
<div id="mainContents" name="mainContents" style="text-align: center;">
	<div id="marketingDiv" name="marketingDiv" style="width: 100%; margin-bottom: 20px;">
		<img id="bannerMarketing" src="${pageContext.request.contextPath}/images/main/marketing.png" style="opacity: 0.3; margin: 150px auto;" border="0px" />
		<!-- <h1>MARKETING</h1> -->
	</div>
</div>
<script type="text/javascript" defer="defer">
	new Effect.Opacity("bannerMarketing", {
		duration : 0.6,
		to : 1
	});

	changeTag = 0; // added by: Nica - to reset changeTag if user goes to UW Main page 04.27.2012
	objLineCds = JSON.parse('${lineCodes}');
	objLineCds = objLineCds[0];
</script>