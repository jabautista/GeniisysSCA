<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<input type="hidden" id="selectedClientId" value="0" />
<div style="margin-top: 5px; width: 100%; display: none;" id="quotationListingTable" name="quotationListingTable">
	<div style="width: 99%;">
		<jsp:include page="/pages/common/utils/toolbar.jsp"></jsp:include>
	</div>
	<div class="tableHeader" style="width: 99%;">
		<label style="width: 210px; text-align: center; margin-left: 56px;">Quotation No.</label>
		<label style="width: 257px; text-align: center;">Assured Name</label>
   		<label style="width: 100px; text-align: center;">Date Created</label>
		<label style="width: 120px; text-align: center;">User Id</label>
		<label style="width: 100px; text-align: center;">Status</label>
	</div>
	<div style="height: 350px; overflow-y: auto; overflow-x: hidden;" id="quoteMainDiv">
		<input type="hidden" id="quoteId" name="quoteId" />
		<c:forEach var="quote" items="${quotationStatus}" varStatus="ctr">
			<div id="row${quote.quoteId}" name="row" class="tableRow" style="width: 98.7%;" quoteId="${quote.quoteId}">
				<input type="hidden" name="quoteId" 	value="${quote.quoteId}" />
				<input type="hidden" name="rowNo" value="${ctr.count}" />
				<label style="width: 230px; text-align: left; display: block; margin-left: 50px;">${quote.quoteNo}</label>
				<label style="width: 235px; text-align: left; display: block; margin-left: 10px;" title="${quote.assdName}">${quote.assdName}<c:if test="${empty quote.assdName}"> - </c:if></label>
	    		<label style="width: 100px; text-align: center; display: block;"><fmt:formatDate value="${quote.acceptDate}" pattern="MM-dd-yyyy" /><c:if test="${empty quote.acceptDate}"> - </c:if></label>
				<label style="width: 120px; text-align: center; display: block;">${quote.userId}</label>
				<label style="width: 100px; text-align: center; display: block;">${quote.status}</label>
			</div>
		</c:forEach>
		<jsp:include page="/pages/common/utils/pager.jsp"></jsp:include>
		<div id="quotations" name="quotations" style="display: none;">
			<json:object>
				<json:array name="quotations" var="q" items="${quotationStatus}">
					<json:object>
						<json:property name="quoteId" 		value="${q.quoteId}" />
						<json:property name="quoteNo" 		value="${q.quoteNo}" />
						<json:property name="assdName" 		value="${q.assdName}" />
						<json:property name="acceptDate" 	value="${q.acceptDate}" />
						<json:property name="userId" 		value="${q.userId}" />
						<json:property name="status"		value="${q.status}" />
						<json:property name="parAssd"		value="${q.parAssd}" />
						<json:property name="reasonDesc"	value="${q.reasonDesc}" />
						<json:property name="parNo"			value="${q.parNo}" />
						<json:property name="polNo"			value="${q.polNo}" />
						<json:property name="inceptDate"	value="${q.inceptDate}" />
						<json:property name="expiryDate"	value="${q.expiryDate}" />
					</json:object>
				</json:array>
			</json:object>
		</div>
	</div>
</div>
<script type="text/JavaScript">
	var addtlTools = '<label id="quotationInformation" name="quotationInformation" style="width: 150px; margin-left: 2px;">Quotation Information</label>'+
					 '<label id="refreshList" name="refreshList" style="width: 90px; float: right;">Refresh List</label>'+ 
					 '<label id="reloadForm" name="reloadForm" style="width: 90px; float: right;">Reload Form</label>';
					 //'<label id="moreFilter" name="moreFilter" style="width: 90px; float: right; margin-right: 2px;">More Filters</label>';
	
	$("delete").insert({after: addtlTools});

	$("filter").observe("click", function ()	{
		fadeElement("moreFilterDiv", .3, null);
		toggleDisplayElement("filterSpan", .3, "appear", focusFilterText);
	});
	
	$("search").observe("click", function ()	{
		fadeElement("filterSpan", .3, null);
		toggleDisplayElement("moreFilterDiv", .3, "appear", null);
	});

	$("reloadForm").observe("click", viewQuotationStatus);
	
	$("quotationInformation").observe("click", function () {
		if(($$("div#quotationListingTable .selectedRow")).length < 1){
			showMessageBox("Please select record first.", imgMessage.INFO);
			return false;
		}else{
			isMakeQuotationInformationFormsHidden = 1;
			
			$("quoteId").value = ($$("div#quotationListingTable .selectedRow"))[0].getAttribute("quoteId");
			showQuotationInformation();
		}		
	});

	$("refreshList").observe("click", function ()	{
		viewQuotationListingForQuotationStatus(1);
	});

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
					try {
						$$("div[name='row']").each(function (r)	{
							if (row.getAttribute("id") != r.getAttribute("id"))	{
								r.removeClassName("selectedRow");
							}
						});

						var rowNo = parseInt(row.down("input", 1).value)-1;
						var quote = quotationList.quotations[rowNo];
						$("quoteAssured").value = quote.assdName;
						$("parAssured").value = quote.parAssd;
						$("reasonForDenial").value = quote.reasonDesc;
						$("parNo").value = quote.parNo;
						$("policyNo").value = quote.polNo;
						//$("inceptDate").value = dateFormat(quote.inceptDate, "mm-dd-yyyy");
						$("inceptDate").value = quote.inceptDate;
						//$("expiryDate").value = dateFormat(quote.expiryDate, "mm-dd-yyyy");
						$("expiryDate").value = quote.expiryDate;
					} catch (e) {
						showErrorMessage("viewQuotationStatusListingTable.jsp - div[name='row']", e);
					}
				} else {
					clearQuotationStatusForm();
				}
			});
		}
	);

	$$("div[name='row']").each(function (div)	{
		if ((div.down("label", 1).innerHTML).length > 30)	{
			div.down("label", 1).update((div.down("label", 1).innerHTML).truncate(30, "..."));
		}
	});
	
	quotationList = ($("quotations").innerHTML).evalJSON();

	// position page div correctly
	if (!$("pager").innerHTML.blank()) {
		$("pager").setStyle("width: 98.7%;");
		$("page").observe("change", function () {
			viewQuotationListingForQuotationStatus($F("page"));
		});
	}

	$("add").hide();
	$("edit").hide();
	$("delete").hide();

	setModuleId("GIIMM004");
	var searchElement = $("filter");
	var arr = searchElement.cumulativeOffset();
	
	if(arr[0] > 0 || arr[1] > 0){
		//$("filterSpan").setStyle("margin-top: "+(arr[1] + 65)+"px; margin-right: 1em; margin-left: "+(arr[0] - 450)+"px;");
		$("filterSpan").setStyle("margin-top: 65px; margin-right: 1em; margin-left: -450px;");
	}
	
</script>