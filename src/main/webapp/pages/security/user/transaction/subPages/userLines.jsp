<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
	
<div id="userLines" name="userLines" style="display: none;"><json:object>
		<json:array name="userLines" var="l" items="${userLines}">
			<json:object>
				<json:property name="lineCd" 		value="${l.lineCd}" />
				<json:property name="lineName" 		value="${l.lineName}" />
			</json:object>
		</json:array>
	</json:object></div>

<div id="curUserLines" name="curUserLines" style="display: none;">
	<json:object>
		<json:array name="curUserLines" var="l" items="${curUserLines}">
			<json:object>
				<json:property name="lineCd" 		value="${l.lineCd}" />
				<json:property name="lineName" 		value="${l.lineName}" />
				<json:property name="userID" 		value="${l.userID}" />
				<json:property name="tranCd" 		value="${l.tranCd}" />
				<json:property name="issCd" 		value="${l.issCd}" />
			</json:object>
		</json:array>
	</json:object>
</div>

<script type="text/javascript">
	//curUserLines = $("curUserLines").innerHTML.evalJSON();
	//userLines = $("userLines").innerHTML.evalJSON();

	curUserLines = eval((((('(' + $("curUserLines").innerHTML + ')').replace(/&amp;/g, '&')).replace(/&gt;/g, '>')).replace(/&lt;/g, '<')));
	userLines = eval((((('(' + $("userLines").innerHTML + ')').replace(/&amp;/g, '&')).replace(/&gt;/g, '>')).replace(/&lt;/g, '<')));
	
	userCreateLinesTable();
</script>