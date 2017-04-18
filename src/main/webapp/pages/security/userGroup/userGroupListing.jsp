<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="userGroupListingMainDiv" name="userGroupListingMainDiv" style="display: none;">
	<div id="outerDiv" name="outerDiv" style="width: 100%;">
		<div id="innerDiv" name="innerDiv">
			<label>User Group Maintenance</label>
		</div>
	</div>
	
	<jsp:include page="/pages/common/utils/filter.jsp"></jsp:include>
	<jsp:include page="/pages/common/utils/search.jsp"></jsp:include>
	
	<div id="userGroupListingTable" name="userGroupListingTable" class="sectionDiv tableContainer" style="height: 410px; width: 100%; padding: 0;">
		<div id="dummyDiv">
		</div>
	</div>
</div>
<div id="transactionDiv" name="transactionDiv" style="display: none; font-size: 11px;">
</div>
<script type="text/javascript">
	setModuleId("GIISS041");
	$("keyword").observe("keypress", function (evt) {
		if (13 == evt.keyCode) {
			goToPageNo("userGroupListingTable", "/GIISUserGroupMaintenanceController?ajax=1", "getUserGroupList", 1);
		}
	});
	
	$("go").observe("click", function () {
		goToPageNo("userGroupListingTable", "/GIISUserGroupMaintenanceController?ajax=1", "getUserGroupList", 1);
	});
</script>