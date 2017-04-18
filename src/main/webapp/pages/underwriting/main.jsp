<input type="hidden" id="parTypeFlag" name="parTypeFlag" value="P" />
<div id="uwParParametersDiv" name="uwParParametersDiv" style="display: none;">
	<form id="uwParParametersForm" name="uwParParametersForm">
		<input type="hidden" name="globalParId" 		id="globalParId" 		value="0"/>
		<input type="hidden" name="globalQuoteId" 		id="globalQuoteId" 		value="0"/>
		<input type="hidden" name="globalParStatus" 	id="globalParStatus" 	value="0"/>
		<input type="hidden" name="globalPolFlag" 		id="globalPolFlag" 		value="0"/>
		<input type="hidden" name="globalOpFlag" 		id="globalOpFlag" 		value="0"/> 
		<input type="hidden" name="globalPackParId" 	id="globalPackParId"		value="0"/> 
		<input type='hidden' name="globalPackPolFlag" 	id="globalPackPolFlag" 		value="0"/>
	</form>
</div>
<div id="mainContents" name="mainContents">
	<div>
		<jsp:include page="/pages/underwriting/menu.jsp"></jsp:include>
		<div id="underwritingDiv" name="underwritingDiv" style="width: 100%; text-align: center;">
			<img id="bannerUnderwriting" src="${pageContext.request.contextPath}/images/main/underwriting.png" style="opacity: 0.3; margin: 150px auto;" border="0px" />
			<!-- <h1>MARKETING</h1> -->
		</div>
	</div>
</div>
<script type="text/javascript" defer="defer">
	new Effect.Opacity("bannerUnderwriting", {
		duration : 0.6,
		to : 1
	});

	changeTag = 0; // added by: Nica - to reset changeTag if user goes to UW Main page 04.27.2012
	creationFlag = false; // added by: Nica 05.09.2012- to reset global variable creationFlag used in par creation page
	objLineCds = JSON.parse('${lineCodes}');
	objLineCds = objLineCds[0];
	objGIPIS100.callingForm = "GIPIS000";
</script>