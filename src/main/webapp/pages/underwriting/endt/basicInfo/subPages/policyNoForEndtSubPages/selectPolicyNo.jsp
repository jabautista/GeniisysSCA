<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
<div id="selectPolicyNoDiv" name="selectPolicyNoDiv" style="margin: 10px;">	
	<form name="selectPolicyForm" id="selectPolicyForm">		
		<div style="width: 100%;">
			<div class="toolbar" style="margin-top: 22px;" id="polToolbar" name="polToolbar">
				<span>
					<label style="float: right; margin-right: 2px;" id="searchPol" name="searchPol">Search</label>
					<label style="float: right; margin-right: 2px;" id="okSelected" name="okSelected">Ok</label>
				</span>
			</div>
			<span id="searchPolSpan" name="searchPolSpan" class="searchPolSpan" style="display: none; text-align: right; margin-top: 30px;">
				<label style="width: 20%; line-height: 22px;">Keyword </label>
				<span style="border: 1px solid gray; width: 79%; background-color: #fff; height: 21px; float: left;"> 
					<input type="text" id="keywordPol" name="keywordPol" style="border: none; float: left; width: 88%;" /> <img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchEntry" name="searchEntry" alt="Go" />
				</span>
			</span>
		</div>
	
		<input type="hidden" id="curLine" name="curLine" value="${curLine}"/>
		<input type="hidden" id="curIss" name="curIss" value="${curIss}"/>
		<input type="hidden" id="curSubline" name="curSubline" value="${curSubline}"/>
		
		<div id="policyNoListingDiv" name="policyNoListingDiv">
			<jsp:include page="/pages/underwriting/endt/basicInfo/subPages/policyNoForEndtSubPages/selectPolicyNoTable.jsp"></jsp:include>	
		</div>
		
		<div id="selectedDiv" name="selectedDiv">
			<input type="hidden" id="selectedSubline" name="selectedSubline" />
			<input type="hidden" id="selectedIssCd" name="selectedIssCd" />
			<input type="hidden" id="selectedIssueYy" name="selectedIssueYy" />
			<input type="hidden" id="selectedPolSeq" name="selectedPolSeq" />
			<input type="hidden" id="selectedRenewNo" name="selectedRenewNo" />
		</div>
		
		<!-- Tag for pack -->
		<input type="hidden" name="isPack"	id="isPack" value="${isPack}<c:if test="${empty isPack }">N</c:if>">
	</form>
</div>

<script type="text/javascript">

	$("searchPol").observe("click", function () {
		$("searchPolSpan").setStyle("right: 150px; top: 105px;");
		toggleDisplayElement("searchPolSpan", .3, "appear", focusSearchPolicyText);
	});
	
	$("okSelected").observe("click", function() {
		loadSelected();
	});
	
	function focusSearchPolicyText() {
		$("keywordPol").focus();
	}
	
	var searchElementP = $("searchPol");
	var arrP = searchElementP.cumulativeOffset();
	$("searchPolSpan").setStyle("margin-top: 1px; margin-right: 1em; margin-left: "+(arrP[0] - 450)+"px;");
	
</script>