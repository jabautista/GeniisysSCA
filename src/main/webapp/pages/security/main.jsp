<jsp:include page="/pages/security/menu.jsp"></jsp:include>
<div id="mainContents" name="mainContents" style="text-align: center;">
	<div id="securityDiv" name="securityDiv" style="width: 100%; margin-bottom: 20px;">
		<img id="bannerSecurity" src="${pageContext.request.contextPath}/images/main/security.png" style="margin: 150px auto; opacity: 0.3;" border="0px" />
	</div>
</div>
<script type="text/javascript">
	new Effect.Opacity("bannerSecurity", {
		duration : 0.6,
		to : 1
	});
	
	changeTag = 0; //marco - 01.06.2014
</script>