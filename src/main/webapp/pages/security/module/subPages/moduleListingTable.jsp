<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<input type="hidden" id="moduleId" name="moduleId" value="" />
<div style="margin: 5px; display: none;">
	
	<jsp:include page="/pages/common/utils/toolbar.jsp"></jsp:include>
	
	<div class="tableHeader">
		<label style="width: 20%; text-align: left; margin-left: 20px;">Module Id</label>
		<label style="width: 56.5%; text-align: left;">Module Description</label>
		<label style="width: 20%; text-align: center;">Type</label>
	</div>
	<div id="moduleListTable" class="moduleListTable" style="font-size: 12px;">
		<c:forEach var="module" items="${searchResult}">
			<div id="row${module.moduleId}" name="row" class="tableRow">
				<label style="width: 20%; text-align: left; margin-left: 20px;">${module.moduleId}</label>
				<label style="width: 57%; text-align: left;">${module.moduleDesc}</label>
				<label style="width: 20%; text-align: center;">${module.moduleType}</label>
				<input type="hidden" value="${module.accessTag}" />	
			</div>
		</c:forEach>
	</div>
	<jsp:include page="/pages/common/utils/pager.jsp"></jsp:include>
</div>
<script type="text/JavaScript">
	initializeTable("tableContainer", "row", "moduleId", "");

	$("filter").observe("click", function ()	{
		fadeElement("searchSpan", .3, null);
		toggleDisplayElement("filterSpan", .3, "appear", focusFilterText);
	});

	//$("searchSpan").setStyle("margin-top: 31px; margin-right: 4px;");
	$("search").observe("click", function () {
		fadeElement("filterSpan", .3, null);
		toggleDisplayElement("searchSpan", .3, "appear", focusSearchText);
	});

	$("delete").hide();

	var addtlTools = "<label id='transaction' name='transaction' style='width: 100px;'>Transaction</label>"+
					 "<label id='userAccess' name='userAccess' style='width: 130px;'>Users w/ Access</label>"+
					 "<label id='userGrpAccess' name='userGrpAccess' style='width: 160px;'>User Groups w/ Access</label>";
	
	$("delete").insert({after: addtlTools});

	// initialize pagination
	if (!$("pager").innerHTML.blank()) {
		initializePagination("moduleListingTable", "/GIISModuleController", "getModuleList");
	}

	$("add").observe("click", function () {
		showOverlayContent(contextPath+"/GIISModuleController?action=showAddModulePage", "Add Module", "", $$("body").first().getWidth()/2-300, $$("body").first().getHeight()/2+150, 250);
	});

	$("edit").observe("click", function () {
		if ($F("moduleId").blank()) {
			showMessageBox("No module is selected.", imgMessage.ERROR);
			return false;
		} else {
			showOverlayContent(contextPath+"/GIISModuleController?action=showAddModulePage&moduleId="+$F("moduleId"), "Edit/Update Module", "", $$("body").first().getWidth()/2-300, $$("body").first().getHeight()/2+150, 250);
		}
	});

	$("transaction").observe("click", function () {
		if (getSelectedRowId("row").blank()) {
			showMessageBox("Please select a module.", imgMessage.ERROR);
			return false;
		} else {
			showOverlayContent(contextPath+"/GIISModuleController?action=getModuleTranList&moduleId="+$F("moduleId"), "Transactions Per Module", showModuleTrans, $$("body").first().getWidth()/2-300, $$("body").first().getHeight()/2+150, 260);
		}
	});

	$("userAccess").observe("click", function () {
		if (getSelectedRowId("row").blank()) {
			showMessageBox("Please select a module.", imgMessage.ERROR);
			return false;
		} else {
			var moduleDesc = $("row"+$F("moduleId")).down("label", 1).innerHTML;
			
			var params = "&moduleDesc="+moduleDesc;
			showOverlayContent(contextPath+"/GIISModuleController?action=getModuleUsers&moduleId="+$F("moduleId")+params, "Users with Access", showModuleUsers, $$("body").first().getWidth()/2-300, $$("body").first().getHeight()/2+150, 260);
		}
	});

	$("userGrpAccess").observe("click", function () {
		if (getSelectedRowId("row").blank()) {
			showMessageBox("Please select a module.", imgMessage.ERROR);
			return false;
		} else {
			var moduleDesc = $("row"+$F("moduleId")).down("label", 1).innerHTML;
			var accessTag = $("row"+$F("moduleId")).down("input", 0).value;
			var params = "&moduleDesc="+moduleDesc+"&accessTag="+accessTag;
			showOverlayContent(contextPath+"/GIISModuleController?action=getModuleUserGrps&moduleId="+$F("moduleId")+params, "User Groups with Access", showModuleUserGrps, $$("body").first().getWidth()/2-300, $$("body").first().getHeight()/2+150, 260);
		}
	});
</script>