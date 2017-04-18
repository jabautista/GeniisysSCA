<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
	
<div id="userModules" name="userModules" style="display: none;">
	<json:object>
		<json:array name="userModules" var="m" items="${userModules}">
			<json:object>
				<json:property name="moduleId" 		value="${m.moduleId}" />
				<json:property name="moduleDesc" 	value="${m.moduleDesc}" />
				<json:property name="tranCd" 		value="${m.tranCd}" />
			</json:object>
		</json:array>
	</json:object>
</div>

<div id="curUserModules" name="curUserModules" style="display: none;">
	<json:object>
		<json:array name="curUserModules" var="m" items="${curUserModules}">
			<json:object>
				<json:property name="moduleId" 		value="${m.moduleId}" />
				<json:property name="moduleDesc" 	value="${m.moduleDesc}" />
				<json:property name="userID"	 	value="${m.userID}" />
				<json:property name="tranCd" 		value="${m.tranCd}" />
			</json:object>
		</json:array>
	</json:object>
</div>

<script type="text/javascript">
	//userModules = $("userModules").innerHTML.evalJSON();
	//curUserModules = $("curUserModules").innerHTML.evalJSON();
	
	curUserModules = eval((((('(' + $("curUserModules").innerHTML + ')').replace(/&amp;/g, '&')).replace(/&gt;/g, '>')).replace(/&lt;/g, '<')));
	userModules = eval((((('(' + $("userModules").innerHTML + ')').replace(/&amp;/g, '&')).replace(/&gt;/g, '>')).replace(/&lt;/g, '<')));

	userCreateModulesTable();
</script>