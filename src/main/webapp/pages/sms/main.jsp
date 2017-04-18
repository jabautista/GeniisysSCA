<jsp:include page="/pages/sms/menu.jsp"></jsp:include>
<div id="mainContents" name="mainContents" style="text-align: center;">
	<div id="smsDiv" name="smsDiv" style="width: 100%; margin-bottom: 20px;">
		<img id="bannerSms" src="${pageContext.request.contextPath}/images/main/sms.png" style="margin: 150px auto; opacity: 0.3;" border="0px" />
	</div>
</div>

<script type="text/javascript">
	setModuleId("");
	setDocumentTitle("SMS Main");
	
	new Effect.Opacity("bannerSms", {
		duration : 0.6,
		to : 1
	});
</script>