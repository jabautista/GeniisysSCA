<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<!-- 
	This module can be deleted.
	Functionalities moved to orListing.jsp
 -->

<input type="hidden" id="gaccTranId" name="gaccTranId" value="" />
<div id="orListingTableDiv" style="margin: 5px;">
	<jsp:include page="/pages/common/utils/toolbar.jsp"></jsp:include>
	<div class="tableHeader">
		<label style="width: 7%; text-align: c; margin-left: 20px;">DCB No.</label>
		<label style="width: 10%; text-align: left;">OR No.</label>
		<label style="width: 13%; text-align: center;">OR Date</label>		
		<label style="width: 20%; text-align: left;">Payor</label>
		<label style="width: 39%; text-align: left;">DCB Bank Account</label>
		<label style="width: 8%; text-align: left;">OR Status</label>
	</div>
	<div id="orListTable" name="orListTable" class="tableContainer" style="font-size: 12px;">		
		<c:forEach var="orItem" items="${searchResult}">
			<div id="row<fmt:formatNumber value="${orItem.itemNo}" pattern="00"/>${orItem.gaccTranId}" name="row" class="tableRow">
				<label style="width: 7%; text-align: left; margin-left: 20px;">${orItem.dcbNo}</label>
				<label style="width: 10%; text-align: left;" name="ORNo" title="${orItem.orNo}">${orItem.orNo}</label>
				<label style="width: 13%; text-align: center;"><fmt:formatDate value="${orItem.orDate}" pattern="MM-dd-yyyy"/></label>				
				<label style="width: 20%; text-align: left;" name="payor">${orItem.payor}</label>
				<label style="width: 39%; text-align: left;" name="dcbBankAcct">${orItem.dcbBankAcct}</label>
				<label style="width: 8%; text-align: left;">${orItem.orStatus}</label>
			</div>
		</c:forEach>
	</div>
	<jsp:include page="/pages/common/utils/pager.jsp"></jsp:include>
</div>

<script type="text/JavaScript">
	$("delete").hide();
	
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
					$("gaccTranId").value = row.getAttribute("id").substring(5);
					$$("div[name='row']").each(function (r)	{
						if (row.getAttribute("id") != r.getAttribute("id"))	{
							r.removeClassName("selectedRow");
						}
					});
				} else {
					$("gaccTranId").value = "";
				}
			});
		}
	);

	$$("label[name='payor']").each(function (lbl) {
		lbl.update((lbl.innerHTML).truncate(20, "..."));
	});

	$$("label[name='dcbBankAcct']").each(function (lbl) {
		lbl.update((lbl.innerHTML).truncate(45, "..."));
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
		if ($F("gaccTranId").blank()) {
			showMessageBox("Please select an OR first.", imgMessage.ERROR);
			return false;
		} else {
			editORInformation();
		}
	});

	$("add").observe("click", createORInformation);

	if (modules.all(function (mod) {return mod != 'GIACS001';})) {
		$("add").hide();
	}

	// initialize pagination
	if (!$("pager").innerHTML.blank()) {
		initializePagination("orListingTable", "/GIACOrderOfPaymentController?isFromORListingMenu=true", "getORListing");
	}
	
</script>