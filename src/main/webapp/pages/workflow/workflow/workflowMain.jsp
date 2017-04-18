<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="workflowMainDiv" style="margin-bottom: 50px; float: left; width: 100%;">
	<jsp:include page="/pages/workflow/workflow/subPages/workflowEvents.jsp"></jsp:include>
</div>
<script type="text/javascript">
	setModuleId("WOFLO001");
	setDocumentTitle("Workflow");
	initializeAccordion();
	if(objWorkflow != undefined || objWorkflow != null && objWorkflow.callingForm != "GENIISYS"){
		$("maintenance").hide();
	}
</script>