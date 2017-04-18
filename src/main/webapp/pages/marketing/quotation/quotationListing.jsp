<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="quotationListingMainDiv" name="quotationListingMainDiv" style="float: left; width: 100%; display: none;">
	<input type="hidden" id="quoteId" name="quoteId" />
	<span style="position: absolute; right: 6.1%; top: 21.7%; padding: 5px; border: 2px solid #FF0000; background: #C0C0C0; color: red; display: none; z-index: 100;" id="errorMessage" name="errorMessage"><label></label></span>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	  		<label id="">List of Generated Quotation for ${lineName}</label>
		</div>
	</div>
	
	<jsp:include page="/pages/common/utils/filter.jsp"></jsp:include>
	
	<!-- <span style="position: absolute; right: 6%; top: 23%; padding: 5px; background-color: #898989; display: none; z-index: 100; color: #fff; font-size: 11px;" id="searchSpan" name="searchSpan">Search keyword <input type="text" id="searchText" name="searchText" style="width: 150px; border: none;" /></span> -->
	<div id="searchDiv" class="searchSpan" style="width: 35%; display: none;">
		<div style="margin: 5px; text-align: center;">
			<form id="searchForm" name="searchForm" onsubmit="return false;">
				<input type="hidden" id="lineCd" name="lineCd"	value="${lineCd}" />
				<input type="hidden" id="lineName" name="lineName" value="${lineName}" />
				<input type="hidden" id="module" name="module" value="GIIMM015" />
				<input type="hidden" id="quotationNo" name="quotationNo" value="0" />
				<label class="rightAligned" style="width: 30%; float: left;">Subline </label>
				<span class="leftAligned" style="width: 68.5%; float: left;">
					<select id="sublineCd" name="sublineCd" style="width: 100%; float: left;">
						<option value=""></option>
						<c:forEach var="s" items="${sublineListing}">
							<option value="${s.sublineCd}">${s.sublineName}</option>
						</c:forEach>
					</select>
				</span><br style="height: 5px;" />
				<label class="rightAligned" style="width: 30%; float: left;">Issuing Source </label>
				<span class="leftAligned" style="width: 68.5%; float: left;">
					<select id="issCd" name="issCd" style="width: 100%; float: left;">
						<option value=""></option>
						<c:forEach var="branchSourceListing2" items="${branchSourceListing}">
							<option value="${branchSourceListing2.issCd}">${branchSourceListing2.issName}</option>
						</c:forEach>
					</select>
				</span><br />
				<label class="rightAligned" style="width: 30%; float: left;">Quotation Year </label>
				<span class="leftAligned" style="width: 68.5%; float: left;"><input type="text" id="quoteYear" name="quoteYear" style="width: 97%; float: left;" /></span><br />
				<label class="rightAligned" style="width: 30%; float: left;">Quotation Seq No </label>
				<span class="leftAligned" style="width: 68.5%; float: left;"><input type="text" id="quoteNo" name="quoteNo" style="width: 97%; float: left;" /></span><br />
				<label class="rightAligned" style="width: 30%; float: left;">Proposal No </label>
				<span class="leftAligned" style="width: 68.5%; float: left;"><input type="text" id="propSeqNo" name="propSeqNo" style="width: 97%; float: left;" /></span><br />
				<label class="rightAligned" style="width: 30%; float: left;">Assure Name </label>
				<span class="leftAligned" style="width: 68.5%; float: left;"><input type="text" id="assdName" name="assdName" class="toCaps" style="width: 97%; float: left;" /></span><br />
				<label style="float: right;"><input type="button" class="button" id="btnSearch" name="btnSearch" value="Search" /></label>
			</form>
		</div>
	</div>
	<div id="searchResult" align="center" class="sectionDiv tableContainer" style="border: 1px solid #E0E0E0; width: 100%; height: 410px; margin-top: 1px; display: block;">
		<div id="quotationListingTable"> <!-- dummy lang to para sa first load may fade effect pa rin - whofeih -->
		</div>
	</div>
	<div id="reassignQuotationDiv" name="reassignQuotationDiv" class="sectionDiv buttonsDiv" style="display: none;">
		<form id="reassignQuotationForm" name="reassignQuotationForm" style="margin: 5px;">
			<label class="rightAligned" style="width: 100px; float: none;">Quotation No </label> <input class="leftAligned" type="text" id="rqQuotationNo" name="rqQuotationNo" readonly="readonly" style="width: 185px;" />
			<label class="rightAligned" style="width: 100px; float: none;">Assured Name </label> <input class="leftAligned" type="text" id="rqAssuredName" name="rqAssuredName" readonly="readonly" style="width: 180px;" />
			<label class="rightAligned" style="width: 100px; float: none;">User Id </label> 
			<select id="rqUserId" name="rqUserId" style="width: 125px;">
				<option></option>
				<c:forEach var="user" items="${users}">
					<option value="${user.userId}">${user.userId}</option>
				</c:forEach>
			</select>
			<input type="button" class="button" id="btnReassignQuotation" name="btnReassignQuotation" value="Reassign Quotation" />
		</form>
	</div>
	<!-- <div class="buttonsDiv" id="buttonDiv" name="buttonDiv">
		<table align="center">
			<tr>
				<td><input type="button" class="disabledButton" value="Copy Quotation" id="btnCopyQuotation" name="btnCopyQuotation" /></td>
				<td><input type="button" class="disabledButton" value="Duplicate Quotation" id="btnDuplicateQuotation" name="btnDuplicateQuotation" /></td>
				<td><input type="button" class="button" value="Create Quotation" id="btnCreateQuotation" name="btnCreateQuotation" /></td>
				<td><input type="button" class="disabledButton" value="Edit Quotation" id="btnEditQuotation" name="btnEditQuotation" /></td>
				<td><input type="button" class="disabledButton" value="Delete Quotation" id="btnDeleteQuotation" name="btnDeleteQuotation" /></td>
			</tr>
		</table>
	</div> -->
</div>
<script type="text/JavaScript">
	loadQuotationList(1);
	setModuleId("GIIMM001");
	
	$("btnSearch").observe("click", function () {
		loadQuotationList(1);
	});

	$$(".searchFieldBoxes").each(function (b) {
		b.observe("keydown", function (evt) {
			if (evt.keyCode == 13) {
				loadQuotationList(1);
			}
		});
	});

	$$("input[type='text'].toCaps, input[type='hidden'].toCaps").each(function (e) {
		e.observe("keyup", function(){
			e.value = e.value.toUpperCase();
		});
	});
	
	if(fromReassignQuotation == 1){
		$("reassignQuotationDiv").show();
		$("quotationMenus").hide();
		setDocumentTitle("Reassign Quotation");

		$("btnReassignQuotation").observe("click", function () {
			try {
				new Ajax.Request(contextPath+"/GIPIQuotationController?action=reassignQuotation&quoteId="+quoteIdToEdit, {
					method: "POST",
					postBody: Form.serialize("reassignQuotationForm"),
					asynchronous: true,
					evalScripts: true,
					onCreate: function(){
						showNotice("Reassigning quotation, please wait...");
						$("reassignQuotationForm").disable();
					}, onComplete: function (response) {
						if (checkErrorOnResponse(response)) {
							hideNotice(response.responseText);
							if ("SUCCESS" == response.responseText) {
								showMessageBox(response.responseText, imgMessage.SUCCESS);//changed success message BJGA 12.28.2010
								$("row" + quoteIdToEdit).down("label", 5).update($F("rqUserId"));
								new Effect.Highlight($("row" + quoteIdToEdit).down("label", 5), {duration: .5});
								$("reassignQuotationForm").enable();
							}
						}
					}
				});
			}catch(e){
				showErrorMessage("quotationListing.jsp", e);
			}
		});
	} else{
		$("quotationMenus").show();
		$("marketingMainMenu").hide();
		initializeMenu();  // andrew - 03.02.2011 - to fix menu problem
		setDocumentTitle("Quotation Listing");
	}
</script>