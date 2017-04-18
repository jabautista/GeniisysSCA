<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
<div id="moduleTranListDiv" class="sectionDiv" style="width: 98%; margin: 5px; display: none;">
	<div class="tableHeader">
		<label style="width: 30%; text-align: left; margin-left: 20px;">Tran Code</label>
		<label style="width: 65%; text-align: left;">Description</label>
	</div>
	<div id="moduleTranListTable" class="tableContainer" style="font-size: 12px;">
		<c:forEach var="tran" items="${moduleTrans}">
			<div id="row${tran.tranCd}" name="row" class="tableRow">
				<label style="width: 30%; text-align: left; margin-left: 20px;">${tran.tranCd}</label>
				<label style="width: 65%; text-align: left;" title="${tran.moduleDesc}" name="moduleDesc">${tran.moduleDesc}</label>
			</div>
		</c:forEach>
	</div>
</div>

<script type="text/JavaScript">
	truncateLongDisplayTexts("label", "moduleDesc");
	resizeTableToRowNum("moduleTranListTable", "row", 8);
</script>