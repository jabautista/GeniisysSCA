<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="mcDepreciationRatesMainDiv" name="mcDepreciationRatesMainDiv" style="display:none;" module="mcDepreciationRates">
	<div id="mcDepreciationRatesMenu">
	 	<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="mcDepreciationRatesMainExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
</div>

<!-- Motor Car Depreciation Rates Listing -->
<div id="McDepreciationMaintenanceDiv">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Motorcar Depreciation Maintenance</label>
			<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label> 
		 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	
 	<div class="sectionDiv" id="mcDepRateListingSectionDiv" style="height:580px; top: 10px; bottom: 10px;">
		<div id="McDepRateListingTableDiv" class= "subSectionDiv" style ="height:245px; top: 10px; bottom: 10px;">
			<jsp:include page="/pages/underwriting/fileMaintenance/general/mcDepreciationRates/subPages/mcDepRateListing.jsp"></jsp:include>
		</div>
	</div> 
</div>

<script type="text/javascript">

	$("txtLastUpdate").value = dateFormat(new Date(),'mm-dd-yyyy hh:MM:ss TT');
	$("txtUserId").value = "${PARAMETERS['USER'].userId}";	
</script>
