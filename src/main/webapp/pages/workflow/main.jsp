<jsp:include page="/pages/workflow/menu.jsp"></jsp:include>
<div id="mainContents" name="mainContents" style="text-align: center;">
	<div id="workflowMainPageDiv" name="workflowMainPageDiv" style="width: 100%; margin-bottom: 20px;">
		<img id="bannerWorkflow" src="${pageContext.request.contextPath}/images/main/workflow.png" style="margin: 150px auto; opacity: 0.3;" border="0px" />
	</div>
</div>
<script type="text/javascript">
	new Effect.Opacity("bannerWorkflow", {
		duration : 0.6,
		to : 1
	});
</script>