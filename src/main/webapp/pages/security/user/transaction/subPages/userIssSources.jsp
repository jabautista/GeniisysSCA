<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="userIssSources" name="userIssSources" style="display: none;">
	<json:object>
		<json:array name="userIssSources" var="i" items="${userIssSources}">
			<json:object>
				<json:property name="issCd" 		value="${i.issCd}" />
				<json:property name="issName" 		value="${i.issName}" />
			</json:object>
		</json:array>
	</json:object>
</div>

<div id="curUserIssSources" name="curUserIssSources" style="display: none;">
	<json:object>
		<json:array name="curUserIssSources" var="i" items="${curUserIssSources}">
			<json:object>
				<json:property name="issCd" 		value="${i.issCd}" />
				<json:property name="issName" 		value="${i.issName}" />
				<json:property name="tranCd" 		value="${i.tranCd}" />
				<json:property name="userID" 		value="${i.userID}" />
			</json:object>
		</json:array>
	</json:object>
</div>

<script type="text/javascript">
	//curUserIssSources = $("curUserIssSources").innerHTML.evalJSON();
	//userIssSources = $("userIssSources").innerHTML.evalJSON();
	
	curUserIssSources = eval((((('(' + $("curUserIssSources").innerHTML + ')').replace(/&amp;/g, '&')).replace(/&gt;/g, '>')).replace(/&lt;/g, '<')));
	userIssSources = eval((((('(' + $("userIssSources").innerHTML + ')').replace(/&amp;/g, '&')).replace(/&gt;/g, '>')).replace(/&lt;/g, '<')));

	userCreateIssTable();
</script>