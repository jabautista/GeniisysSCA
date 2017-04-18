<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="mcFairMarketValueMainDiv" name="mcFairMarketValueMainDiv" style="display:none;" module="mcFairMarketValue">
	<div id="mcFairMarketValueMenu">
	 	<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="mcFairMarketValueMainExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
</div>

<!-- Motor Car Listing -->
<div id="MotorCarListingDiv">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Fair Market Value Maintenance</label>
			<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label> 
		 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	
	<div class="sectionDiv" id="motorCarListingSectionDiv" style="height:245px; top: 10px; bottom: 10px;">
		<div id="MotorCarListingTableDiv" class= "subSectionDiv" style ="height:245px; top: 10px; bottom: 10px;">
			<jsp:include page="/pages/underwriting/fileMaintenance/general/mcFairMarketValue/subPages/motorCarListing.jsp"></jsp:include>
		</div>
	</div>
</div>

<!-- Fair Market Value Maintenance -->
<div id="fairMarketValueMaintenanceDiv">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label> 
			</span>
		</div>
	</div>
	<div class="sectionDiv" id="fairMarketValueMaintenanceSectionDiv">
		<div id="fairMarketValueMaintenanceTableDiv" >
			<div id="fairMarketValueMaintenanceInfoSectionDiv" >
				<jsp:include page="/pages/underwriting/fileMaintenance/general/mcFairMarketValue/subPages/fairMarketValueMaintenance.jsp"></jsp:include>
	 		</div>
	 	</div>
	</div>		
</div>

<script type="text/javascript">

	$("txtLastUpdate").value = dateFormat(new Date(),'mm-dd-yyyy hh:MM:ss TT');
	$("txtUserId").value = "${PARAMETERS['USER'].userId}";	
</script>
