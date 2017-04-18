<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="moduleListingMainDiv" name="moduleListingMainDiv" style="display: none;">
	<div id="outerDiv" name="outerDiv" style="width: 100%;">
		<div id="innerDiv" name="innerDiv">
			<label>User Modules Maintenance</label>
		</div>
	</div>
	
	<jsp:include page="/pages/common/utils/filter.jsp"></jsp:include>
	<jsp:include page="/pages/common/utils/search.jsp"></jsp:include>
	
	<div id="moduleListingTable" name="moduleListingTable" class="sectionDiv tableContainer" style="height: 410px; width: 100%; padding: 0;">
		<div id="dummyDiv">
		</div>
	</div>
</div>

<script type="text/JavaScript">
	setModuleId("GIISS081");
	initializeAll();

	$("keyword").observe("keypress", function (evt) {
		onEnterEvent(evt, submitSearch);
	});
	
	$("filterText").observe("keyup", function (evt) {
		if (evt.keyCode == 27) {
			$("filterText").clear();
			showAllRows("moduleListTable", "row");
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
				if (null != row.down("label", 0).innerHTML.toUpperCase().match(text) ||
					null != row.down("label", 1).innerHTML.toUpperCase().match(text) ||
					null != row.down("label", 2).innerHTML.toUpperCase().match(text)) {
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
		goToPageNo("moduleListingTable", "/GIISModuleController?keyword="+$F("keyword"), "getModuleList", 1);
	}

	$("go").observe("click", function () {
		submitSearch();
	});
</script>