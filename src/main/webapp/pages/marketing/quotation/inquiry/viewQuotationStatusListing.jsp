<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="viewQuotationStatusDiv" name="viewQuotationStatusDiv" style="display: none; margin-bottom: 50px;">
	<form id="searchForm" name="searchForm">
		<input type="hidden" id="module" name="module" value="GIIMM004" />
		<span style="position: absolute; right: 6.1%; top: 21.7%; padding: 5px; border: 2px solid #FF0000; background: #C0C0C0; color: red; display: none; z-index: 100;" id="errorMessage" name="errorMessage"><label></label></span>
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
		  		<label id="">View Quotation Status</label>
		  		<!-- <label id="moreFilter" name="moreFilter" style="float: right; font-size: 10px; cursor: pointer;"><a style="margin: 0 5px;">More Filters</a></label>
		  		<label id="filter" name="filter" style="float: right; font-size: 10px; cursor: pointer;"><a style="margin: 0 5px;">Filter by Keyword</a>|</label>
		  		<label id="refreshList" style="float: right; font-size: 10px; cursor: pointer;"><a style="margin: 0 5px;">Refresh List</a>|</label> 
		  		<label id="reloadForm" style=" float: right; font-size: 10px; cursor: pointer;"><a style="margin: 0 5px;">Reload Form</a>|</label>
		  		<label id="viewQuotationInformation" style="float: right; font-size: 10px; cursor: pointer;"><a style="margin: 0 5px;">Quotation Information</a>|</label>-->
			</div>
		</div>
		
		<jsp:include page="/pages/common/utils/moreFilters.jsp"></jsp:include>
		<jsp:include page="/pages/common/utils/filter.jsp"></jsp:include>
		
		<!-- <div id="filterByKeywordDiv" name="filterByKeywordDiv" style="background-color: #E0E0E0; position: absolute; display: none; z-index: 10; width: 35%; margin: 3px; border: 5px solid #c9c9c9; -moz-border-radius: 5px;">
			<span style="float: left; z-index: 6; width: 100%; background-color: #c0c0c0;">
				<label style="margin: 5px;">Filter by Keyword</label>
				<label id="lblCloseKeywordDiv" name="closer">Close</label>
			</span>
			<div style="z-index: 5; float: left; width: 100%;">	
				<div style="padding: 5px; margin-bottom: 5px;">
					<table>
						<tr>
							<td class="rightAligned" style="width: 100px;">Filter keyword </td>
							<td class="leftAligned"><input type="text" id="filterText" name="filterText" style="width: 190px; border: none;" /></td>
						</tr>
					</table>
				</div>
			</div>
		</div> -->
	</form>
	<div id="searchResult" align="center" class="sectionDiv" style="width: 100%; height: 410px; margin-top: 1px;">
		<div id="dummyDiv">
		</div>
	</div>
	<div class="sectionDiv" style="text-align: center; margin-top: 1px; margin-bottom: 50px;">
		<table align="center">
			<tr>
				<td class="rightAligned">Quote Assured </td>
				<td colspan="3">
					<input type="text" class="leftAligned" style="width: 500px;" readonly="readonly" id="quoteAssured" name="quoteAssured" /> <br /></td>
			</tr>
			<tr>
				<td class="rightAligned">PAR Assured </td>
				<td colspan="3">
					<input type="text" class="leftAligned" style="width: 500px;" readonly="readonly" id="parAssured" name="parAssured" /> <br /></td>
			</tr>
			<tr>
				<td class="rightAligned">Reason for Denial </td>
				<td colspan="3">
					<input type="text" class="leftAligned" style="width: 500px;" readonly="readonly" id="reasonForDenial" name="reasonForDenial" /> <br /></td>
			</tr>
			<tr>
				<td class="rightAligned">PAR No. </td>
				<td>
					<input type="text" class="leftAligned" style="width: 206px;" readonly="readonly" id="parNo" name="parNo" /> <br /></td>
				<td class="rightAligned">Policy No. </td>
				<td>
					<input type="text" class="leftAligned" style="width: 208px;" readonly="readonly" id="policyNo" name="policyNo" /> <br /></td>
			</tr>
			<tr>
				<td class="rightAligned">Inception Date </td>
				<td>
					<input type="text" class="leftAligned" style="width: 206px;" readonly="readonly" id="inceptDate" name="inceptDate" /> <br /></td>
				<td class="rightAligned">Expiry Date </td>
				<td>
					<input type="text" class="leftAligned" style="width: 208px;" readonly="readonly" id="expiryDate" name="expiryDate" /> <br /></td>
			</tr>
		</table>
	</div>
</div>
<script type="text/JavaScript">
	viewQuotationListingForQuotationStatus(1);
	
	$("btnFilters").observe("click", function () {
		viewQuotationListingForQuotationStatus(1);
	});	

	/* grace 10.12.10
	** added cancel button in the search window
	*/
	$("btnFiltersCancel").observe("click", function(){
		$("moreFilterDiv").hide();	
	});
	
	initializeAll();
	addStyleToInputs();

	$("filterText").observe("keyup", function (evt)	{
		if (evt.keyCode == 27) {
			if ($F("filterText").blank()) {
				Effect.Fade("filterByKeywordDiv", {duration: .3});
			} else {
				$("filterText").clear();
				$$("div[name='row']").each(function (div)	{
					div.show();
				});
			}
		} else {
			try {
			var text = ($F("filterText").strip()).toUpperCase();
			for (var i=0; i<quotationList.quotations.length; i++)	{
				if (nvl(quotationList.quotations[i].quoteNo, "").toUpperCase().match(text) != null || 
					nvl(quotationList.quotations[i].assdName, "").toUpperCase().match(text) != null || 
					nvl(quotationList.quotations[i].parAssd, "").toUpperCase().match(text) != null ||
					nvl(quotationList.quotations[i].parNo, "").toUpperCase().match(text) != null ||
					nvl(quotationList.quotations[i].polNo, "").toUpperCase().match(text) != null ||
					nvl(quotationList.quotations[i].inceptDate, "").toUpperCase().match(text) != null ||
					nvl(quotationList.quotations[i].expiryDate, "").toUpperCase().match(text) != null ||
					nvl(quotationList.quotations[i].validDate, "").toUpperCase().match(text) != null || 
					nvl(quotationList.quotations[i].userId, "").toUpperCase().match(text) != null || 
					nvl(quotationList.quotations[i].status, "").toUpperCase().match(text) != null)	{
					$("row"+quotationList.quotations[i].quoteId).show();
				} else {
					$("row"+quotationList.quotations[i].quoteId).hide();
				}
			}
			if (!$("pager").innerHTML.blank()) {
				positionPageDiv();
			}
			} catch (e) {
				showErrorMessage("viewQuotationStatusListing.jsp - filterText", e);
			}
		}
	});

	$("from").setStyle("border: none; width: 67px; margin: 0;");
	$("from").up("span", 0).setStyle("float: left; background-color: #fff; border: 1px solid gray; padding: 0; width: 95px;");

	$("to").setStyle("border: none; width: 67px; margin: 0;");
	$("to").up("span", 0).setStyle("float: left; background-color: #fff; border: 1px solid gray; padding: 0; width: 95px;");	
</script>