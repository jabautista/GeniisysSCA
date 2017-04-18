<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
    <%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<!-- this page is not in use anymore due to the implementation of json on assuredListing.jsp -->
<input type="hidden" id="assuredNo" name="assuredNo" value="" />
<div id="assuredListingTableDiv" style="margin: 5px;">
	<jsp:include page="/pages/common/utils/toolbar.jsp"></jsp:include>
	<div class="tableHeader">
		<label style="width: 20%; text-align: left; margin-left: 20px;">Corporate Type</label>
		<label style="width: 30%; text-align: left;">Name</label>
		<label style="width: 37%; text-align: left;">Address</label>
		<label style="width: 10%; text-align: left;">Active Flag</label>
	</div>
	<div id="assuredListTable" name="assuredListTable" class="tableContainer" style="font-size: 12px;">
		<c:forEach var="assured" items="${searchResult}">
			<div id="row${assured.assdNo}" name="row" class="tableRow">
				<label style="width: 20%; text-align: left; margin-left: 20px;">${assured.corporateTag}</label>
				<label style="width: 30.5%; text-align: left;" name="assdName" title="${assured.assdName}">${assured.assdName}</label>
				<c:choose>
					<c:when test="${empty assured.mailAddress1 && empty assured.mailAddress2 && empty assured.mailAddress3}">
						<label style="width: 36%; text-align: left;" name="address" title="${assured.mailAddress1} ${assured.mailAddress2} ${assured.mailAddress3}">-</label>
					</c:when>
					<c:otherwise>
						<label style="width: 36%; text-align: left;" name="address" title="${assured.mailAddress1} ${assured.mailAddress2} ${assured.mailAddress3}">${assured.mailAddress1} ${assured.mailAddress2} ${assured.mailAddress3}</label>
					</c:otherwise>
				</c:choose>					
				<label style="width: 10%; text-align: center;">${assured.activeTag}</label>
			</div>
		</c:forEach>
	</div>
	<jsp:include page="/pages/common/utils/pager.jsp"></jsp:include>
</div>

<script type="text/JavaScript">
	$$("div[name='row']").each(
		function (row)	{
			row.observe("mouseover", function ()	{
				row.addClassName("lightblue");
			});
			
			row.observe("mouseout", function ()	{
				row.removeClassName("lightblue");
			});
			
			row.observe("click", function ()	{
				row.toggleClassName("selectedRow");
				if (row.hasClassName("selectedRow"))	{
					$("assuredNo").value = row.getAttribute("id").substring(3);
					$$("div[name='row']").each(function (r)	{
						if (row.getAttribute("id") != r.getAttribute("id"))	{
							r.removeClassName("selectedRow");
						}
					});
				} else {
					$("assuredNo").value = "";
				}
			});
		}
	);

	$$("label[name='address']").each(function (lbl) {
		lbl.update((lbl.innerHTML).truncate(40, "..."));
	});

	$$("label[name='assdName']").each(function (lbl) {
		lbl.update((lbl.innerHTML).truncate(35, "..."));
	});

	$("search").observe("click", function () {
		fadeElement("filterSpan", .3, null);
		toggleDisplayElement("searchSpan", .3, "appear", focusSearchText);
	});

	$("filter").observe("click", function () {
		fadeElement("searchSpan", .3, null);
		toggleDisplayElement("filterSpan", .3, "appear", focusFilterText);
	});

	$("edit").observe("click", function () {
		if ($F("assuredNo").blank()) {
			showMessageBox("Please select an assured first.", imgMessage.ERROR);
			return false;
		} else {
			//showMaintainAssuredForm($F("assuredNo"));
			maintainAssured("assuredListingMainDiv", $F("assuredNo"));
		}
	});

	$("add").observe("click", function () {
		//showMaintainAssuredForm($F("assuredNo"));
		maintainAssured("assuredListingMainDiv", "");
	});

	function deleteAssured() {
		new Ajax.Request(contextPath+"/GIISAssuredController?action=checkAssuredDependencies&assdNo="+$F("assuredNo"), {
			asynchronous: true,
			evalScripts: true,
			onCreate: showNotice("Checking assured dependencies, please wait..."),
			onComplete: function (response) {
				if (response.responseText.stripTags().trim().blank()) {
					new Ajax.Request(contextPath+"/GIISAssuredController?action=deleteAssured&assdNo="+$F("assuredNo"), {
						asynchronous: true,
						evalScripts: true,
						onCreate: showNotice("Deleting, please wait..."),
						onComplete: function (response1) {
							hideNotice();
							if (checkErrorOnResponse(response1)) {
								$("row"+$F("assuredNo")).remove();
								positionPageDiv();
							} 
						}
					});
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
					return false;
				}
			}
		});
	}
	
	$("delete").observe("click", function () {
		if ($F("assuredNo").blank()) {
			showMessageBox("No assured selected.", imgMessage.ERROR);
			return false;
		} else {
			showConfirmBox("Delete assured confirmation", "Are you sure you want to delete this record?", "Yes", "No", deleteAssured, "");
		}
	});

	if (modules.all(function (mod) {return mod != 'GIISS006B';})) {
		$("add").hide();
	}

	// initialize pagination
	if (!$("pager").innerHTML.blank()) {
		initializePagination("assuredListingTable", "/GIISAssuredController?isFromAssuredListingMenu=true", "getAssuredListing");
	}
</script>