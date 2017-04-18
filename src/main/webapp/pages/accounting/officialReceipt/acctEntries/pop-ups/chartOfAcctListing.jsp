<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="ajax" uri="http://ajaxtags.org/tags/ajax" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
<div id="chartOfAcctsDiv" name="chartOfAcctsDiv" style="margin: 10px;">
	<form name="selectGlAcctForm" id="selectGlAcctForm">
		<div style="width: 100%;">
			<div class="toolbar" style="margin-top: 22px;" id="toolbar" name="toolbar">
				<span>
				 	<label style="float: right; margin-right: 2px;" id="search" name="search">Search</label>
				<!-- <label style="float: right; margin-right: 2px;" id="okSelected" name="okSelected">Ok</label>  -->
					<label style="float: right; margin-right: 2px; visibility: hidden;" id="filter" name="filter">Filter</label>
				</span>
			</div>
			<span id="searchSpan" name="searchSpan" class="searchSpan" style="display: none; text-align: right; margin-top: 30px;">
				<label style="width: 20%; line-height: 22px;">Keyword </label>
				<span style="border: 1px solid gray; width: 79%; background-color: #fff; height: 21px; float: left;"> 
					<input type="text" id="keyword" name="keyword" style="border: none; float: left; width: 88%;" /> <img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchEntry" name="searchEntry" alt="Go" />
				</span>
			</span>
			<span id="filterSpan" name="filterSpan" style="display: none;">
				<label style="width: 20%; line-height: 22px;">Keyword</label> 
				<input type="text" id="filterText" name="filterText" style="width: 77%; border: none;" />
			</span>
		</div>
		
		<div id="glAcctListingDiv" name="glAcctListingDiv">
			<jsp:include page="/pages/accounting/officialReceipt/acctEntries/pop-ups/chartOfAcctListingTable.jsp"></jsp:include>	
		</div>
	</form>
	<div class="buttonsDiv" style="margin-bottom: 10px;">
		<input type="button" id="okSelected" name="okSelected" value="OK" style="width: 90px;" class="button" />
	<!-- <input type="button" id="cancelSelect" name="cancelSelect" value="Cancel" style="width: 90px;" class="button" />  -->			
	</div>
</div>

<script type="text/javascript">
	var searchElement = $("search");
	var arr = searchElement.cumulativeOffset();
	$("searchSpan").setStyle("margin-top: 1px; margin-right: 1em; margin-left: "+(arr[0] - 450)+"px;");

	// == == ==
	
</script>