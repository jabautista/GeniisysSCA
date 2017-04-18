<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="perilDepreciationMainDiv" style="float: left; width: 100%">
	<div id="perilDepreciationMenuDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="perilDepreciationExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>

	<jsp:include page="/pages/underwriting/fileMaintenance/general/perilDepreciation/subPages/lineListing.jsp"></jsp:include>
	<jsp:include page="/pages/underwriting/fileMaintenance/general/perilDepreciation/subPages/perilDepreciationMaintenanceDtl.jsp"></jsp:include>

	<div class="buttonsDiv" style="float:left; width: 100%;">
		<input type="button" class="button" id="btnCancelPerilDepreciation" name="btnCancelPerilDepreciation" value="Cancel" tabindex=401 />
		<input type="button" class="button" id="btnSavePerilDepreciation" name="btnSavePerilDepreciation" value="Save" tabindex=402/>
	</div>
</div>	

<script type="text/javascript">
	setModuleId("GIISS208");
	setDocumentTitle("Peril Depreciation Maintenance");
	initializeAll();
	initializeAccordion();
	initializeAllMoneyFields();
	makeInputFieldUpperCase();	
</script>