<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="copyPolicyMainDiv" changeTagAttr="true" style="padding-top: 1px;">
	<div id="copyPolicyMenuDiv">
		<div id="mainNav" name="mainNav" >
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="copyPolExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div>
		<jsp:include page="/pages/underwriting/utilities/copyPolicyEndt/subPages/copyPolicySub.jsp"></jsp:include>
	</div>	
</div>