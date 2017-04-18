<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="userListingMainDiv" name="userListingMainDiv" style="display: none;">
	<div id="outerDiv" name="outerDiv" style="width: 100%;">
		<div id="innerDiv" name="innerDiv">
			<label>User Maintenance</label>
		</div>
	</div>
	
	<jsp:include page="/pages/common/utils/filter.jsp"></jsp:include>
	<form id="searchForm" name="searchForm" action="" onSubmit="return false;">
		<span id="searchSpan" name="searchSpan" style="display: none;">
			<label style="float: left; width: 20%; line-height: 22px;">Keyword</label>
			<span style="width: 79%; background-color: #fff; height: 21px; float: left;"> 
				<input type="text" id="keyword" name="keyword" style="width: 88%; border: none; float: left;" /> <img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="go" name="go" alt="Go" style="margin: 2px 1px 0 0; padding: 0; height: 17px; width: 18px;" />
			</span>
			<span style="float: right;">
				<span>
					<label for="activeFlag" 	style="width: 20px; float: left; text-align: center;" title="Active Tag">A</label>
					<label for="commUpdateTag" 	style="width: 20px; float: left; text-align: center;" title="Commision Tag">C</label>
					<label for="allUserSw" 		style="width: 20px; float: left; text-align: center;" title="All User Switch">U</label>
					<label for="managerSw" 		style="width: 20px; float: left; text-align: center;" title="Manager Switch">M</label>
					<label for="marketingSw" 	style="width: 20px; float: left; text-align: center;" title="Marketing Switch">K</label>
					<label for="misSw" 			style="width: 20px; float: left; text-align: center;" title="MIS Switch">I</label>
					<label for="workflowTag" 	style="width: 20px; float: left; text-align: center;" title="Workflow Tag">W</label>
				</span>
				<br />
				<span>
					<span style="width: 20px; float: left;" title="Active Tag"> <input type="checkbox" id="activeFlag" name="activeFlag" value="Y" /></span>
					<span style="width: 20px; float: left;" title="Commision Tag"> <input type="checkbox" id="commUpdateTag" name="commUpdateTag" value="Y" /></span>
					<span style="width: 20px; float: left;" title="All User Switch"> <input type="checkbox" id="allUserSw" name="allUserSw" value="Y" /></span>
					<span style="width: 20px; float: left;" title="Manager Switch"> <input type="checkbox" id="managerSw" name="managerSw" value="Y" /></span>
					<span style="width: 20px; float: left;" title="Marketing Switch"> <input type="checkbox" id="marketingSw" name="marketingSw" value="Y" /></span>
					<span style="width: 20px; float: left;" title="MIS Switch"> <input type="checkbox" id="misSw" name="misSw" value="Y" /></span>
					<span style="width: 20px; float: left;" title="Workflow Tag"> <input type="checkbox" id="workflowTag" name="workflowTag" value="Y" /></span>
				</span>
			</span>
		</span>
	</form>
	<div id="userListingTable" name="userListingTable" class="sectionDiv tableContainer" style="height: 410px; width: 100%; padding: 0; margin-bottom: 20px;">
		<div id="dummyDiv">
		</div>
	</div>
	<div class="buttonsDiv" style="display: none;">
		<!-- <input type="button" class="button" id="btnChangePassword" 	name="btnChangePassword" 	value="Change Password" />
		<input type="button" class="button" id="btnTransaction" 	name="btnTransaction" 		value="Transaction" />
		<input type="button" class="button" id="btnGroupAccess" 	name="btnGroupAccess" 		value="Group Access" />
		<input type="button" class="button" id="btnHistory" 		name="btnHistory" 			value="History" />
		<input type="button" class="button" id="btnSave" 			name="btnSave" 				value="Save" /> -->
	</div>
</div>
<div id="transactionDiv" name="transactionDiv" style="display: none; font-size: 11px;">
</div>

<script type="text/JavaScript">
	setModuleId("GIISS040");
	$("keyword").observe("keypress", function (evt) {
		onEnterEvent(evt, submitSearch);
	});

	$("filterText").observe("keyup", function (evt) {
		if (evt.keyCode == 27) {
			$("filterText").clear();
			showAllRows("userListTable", "row");
			Effect.Fade("filterSpan", {
				duration: .3
			});
		} else if (evt.keyCode == 13) {
			Effect.Fade("filterSpan", {
				duration: .3
			});
		} else {
			var text = ($F("filterText").strip()).toUpperCase();

			$$("div[name='row']").each(function (row) {
				/*
				if (null != row.up("div").down("label", 0).innerHTML.toUpperCase().match(text) ||
					null != row.up("div").down("label", 1).innerHTML.toUpperCase().match(text) ||
					null != row.up("div").down("label", 2).innerHTML.toUpperCase().match(text) ||
					null != row.up("div").down("label", 3).innerHTML.toUpperCase().match(text)) {
					row.show();
				} */
				if (null != row.childNodes[1].innerHTML.toUpperCase().match(text) ||
					null != row.childNodes[3].innerHTML.toUpperCase().match(text) ||
					null != row.childNodes[5].innerHTML.toUpperCase().match(text) ||
					null != row.childNodes[7].innerHTML.toUpperCase().match(text)){
					row.show();
				} else {
					row.hide();
				}
				if (!$("pager").innerHTML.blank()) {
					positionPageDiv();
				}
			});
		}
	});

	function submitSearch() {
		goToPageNo("userListingTable", "/GIISUserMaintenanceController?"+Form.serialize("searchForm"), "getUserList", 1);
	}
	
	$("go").observe("click", function () {
		submitSearch();
	});
</script>