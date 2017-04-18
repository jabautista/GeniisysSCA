<jsp:include page="/pages/accounting/menu.jsp"></jsp:include>
<jsp:include page="/pages/accounting/officialReceipt/subPages/orParameters.jsp"></jsp:include>
<div id="mainContents" name="mainContents" style="text-align: center;">
	<div id="accountingDiv" name="accountingDiv" style="width: 100%; margin-bottom: 20px;">
		<img id="bannerAccounting" src="${pageContext.request.contextPath}/images/main/accounting.png" style="opacity: 0.3; margin: 150px auto;" border="0px" />
	</div>
</div>
<script type="text/javascript">
	new Effect.Opacity("bannerAccounting", {
		duration : 0.6,
		to : 1
	});

	changeTag = 0; // added by: Nica - to reset changeTag if user goes to Accounting Main page 04.27.2012
	$("acExit").hide();
	clearObjectValues(objAC);
</script>