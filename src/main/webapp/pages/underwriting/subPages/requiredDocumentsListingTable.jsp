<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div style="width: 100%;" id="docsDivTablegrid">
<!-- 	<div class="tableHeader">
		<label style="width: 30%; text-align: left; margin-left: 50px;">Document Name</label>
		<label style="width: 30%; text-align: center;">Date Submitted</label>
		<label style="width: 30%; text-align: right;">P</label>-->
	</div> 
	<!-- <div id="docsDivTablegrid" name="docsDivTablegrid"> -->
		<%-- <c:forEach var="doc" items="${reqDocs}" varStatus="ctr">
			<div id="row${doc.docCd}" name="docRow" docCd="${doc.docCd}" class="tableRow" style="">
				<label name="docText" style="width: 30%; text-align: left; margin-left: 50px;">${doc.docName}</label>
   				<label name="text" style="width: 30%; text-align: center;"><fmt:formatDate value="${doc.dateSubmitted}" pattern="MM-dd-yyyy" /><c:if test="${empty doc.dateSubmitted}">---</c:if></label>
   				<label style="width: 30%; text-align: right;">
					<c:choose>
						<c:when test="${'Y' eq doc.docSw}">
							<img name="checkedImg" style="width: 10px; height: 10px; text-align: right; display: block; margin-left: 1px; float: right;" />
						</c:when>
						<c:otherwise>
							<span style="float: right; width: 10px; height: 10px;">-</span>
						</c:otherwise>
					</c:choose>
				</label>
				<input type="hidden" id="docSw${doc.docCd}" 		name="docSw${doc.docCd}" 			value="${fn:escapeXml(doc.docSw)}"/>
				<input type="hidden" id="dateSubmitted${doc.docCd}" name="dateSubmitted${doc.docCd}"	value="<fmt:formatDate value="${doc.dateSubmitted}" pattern="MM-dd-yyyy" />"/>
				<input type="hidden" id="docCd${doc.docCd}" 		name="docCd${doc.docCd}" 			value="${fn:escapeXml(doc.docCd)}"/>
				<input type="hidden" id="docName${doc.docCd}" 		name="docName${doc.docCd}" 			value="${fn:escapeXml(doc.docName)}"/>
				<input type="hidden" id="userId${doc.docCd}" 		name="userId${doc.docCd}" 			value="${fn:escapeXml(doc.userId)}"/>
				<input type="hidden" id="lastUpdate${doc.docCd}" 	name="lastUpdate${doc.docCd}" 		value="<fmt:formatDate value="${doc.lastUpdate}" pattern="MM-dd-yyyy" />"/>
				<input type="hidden" id="remarks${doc.docCd}" 		name="remarks${doc.docCd}" 			value="${fn:escapeXml(doc.remarks)}"/>
				<input type="hidden" id="docCode" 					name="docCode" 						value="${fn:escapeXml(doc.docCd)}"/>
			</div>
		</c:forEach>
		<div id="docForInsertDiv" style="visibility: hidden;"></div>
		<div id="docForDeleteDiv" style="visibility: hidden;"></div> --%>
	<!-- </div> -->
</div>
<script type="text/javaScript">

// initializeRows();
// changeCheckImageColor();
// checkIfToResizeTable("docsDiv", "docRow");
//checkTableItemInfo("docsDiv","docsTable","docRow");
// checkTableIfEmpty("docRow", "docsDiv");

/* function initializeRows(){
	$$("div[name='docRow']").each(
		function(row)	{
			observeReqDocRow(row);
		}
	);
} */

</script>