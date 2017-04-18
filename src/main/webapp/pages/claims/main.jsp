<jsp:include page="/pages/claims/menu.jsp"></jsp:include>
<div id="mainContents" name="mainContents" style="">
	<div id="claimsDiv" name="claimsDiv" style="width: 100%; margin-bottom: 20px;">
		<img id="bannerClaims" src="${pageContext.request.contextPath}/images/main/claims.png" style="opacity: 0.3; margin: 150px; margin-left: 90px; auto;" border="0px" />
	</div>
</div>
<script>
	new Effect.Opacity("bannerClaims", {
		duration : 0.6,
		to : 1
	});

	changeTag = 0; // added by: Nica - to reset changeTag if user goes to Claims Main page 04.27.2012
	objLineCds = JSON.parse('${lineCodes}');
	objLineCds = objLineCds[0];
	objCLMGlobal.callingForm = "GICLS001";
	objCLMGlobal.issCd = "${branchCd}";
	setModuleId(null);
</script>	
