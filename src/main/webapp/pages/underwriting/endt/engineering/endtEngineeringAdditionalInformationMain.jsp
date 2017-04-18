<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="endtEngineeringAdditionalInformationMainDiv" name="endtEngineeringAdditionalInformationMainDiv" style="margin-top: 1px;">	
	<jsp:include page="/pages/underwriting/subPages/parInformation.jsp"></jsp:include>	
	<jsp:include page="/pages/underwriting/endt/engineering/subPages/endtEngineeringAdditionalInformation.jsp"></jsp:include>
</div>
<div class="buttonsDiv" style="float:left; width: 100%;">			
	<input type="button" style="width: 80px; margin-left: 35px;" id="btnSave" name="btnSave" class="button" value="Save" />
	<input type="button" style="width: 80px;" id="btnCancel" name="btnCancel"	class="disabledButton" value="Cancel" />
</div> 
<script>
	setModuleId("GIPIS066");
	
</script>