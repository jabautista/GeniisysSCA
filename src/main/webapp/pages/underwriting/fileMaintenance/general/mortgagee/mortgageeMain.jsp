<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="mortgageeMainDiv" name="mortgageeMainDiv" style="display:none;" module="mortgagee">
	<div id="mortgageeMenu">
	 	<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="mortgageeMainExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
</div>
<!-- Issue Source Listing -->
<div id="SourceListingDiv">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Issue Source Listing</label>
			<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label> 
		 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	<div class="sectionDiv" id="sourceListingSectionDiv" style="height:245px; top: 10px; bottom: 10px;">
		<div id="sourceListingTableDiv" class= "subSectionDiv" style ="height:245px; top: 10px; bottom: 10px;">
			<jsp:include page="/pages/underwriting/fileMaintenance/general/mortgagee/subPages/sourceListing.jsp"></jsp:include>
		</div>
	</div>
</div>

<!-- Mortgagee Maintenance -->
<div id="mortgageeMaintenanceDiv">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Mortgagee Maintenance</label>
			<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label> 
			</span>
		</div>
	</div>
	<div class="sectionDiv" id="mortgageeMaintenanceSectionDiv">
		<div id="mortgageeMaintenanceTableDiv" >
			<div id="mortgageeMaintenanceInfoSectionDiv" >
				<jsp:include page="/pages/underwriting/fileMaintenance/general/mortgagee/subPages/mortgageeMaintenance.jsp"></jsp:include>
	 		</div>
	 	</div>
	</div>		
</div>

<!-- Cancel/Save -->
<div class="buttonsDiv" style="float:left; width: 100%; top: 10px; bottom: 10px;">
	<input type="button" class="button" id="btnCancelMortgageeMain" name="btnCancelMortgageeMain" value="Cancel" tabindex="301"/>
	<input type="button" class="button" id="btnSaveMortgageeMain" name="btnSaveMortgageeMain" value="Save" tabindex="302"/>
</div>

<script type="text/javascript">

	$("txtLastUpdate").value = dateFormat(new Date(),'mm-dd-yyyy hh:MM:ss TT');
	$("txtUserId").value = "${PARAMETERS['USER'].userId}";
	$("txtMortgCd").focus();
	
</script>
