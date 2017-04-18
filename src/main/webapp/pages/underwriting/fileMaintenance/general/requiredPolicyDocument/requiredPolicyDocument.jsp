<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="requiredDocMainDiv" name="requiredDocMainDiv" style="display:none;" module="requiredPolicyDocument">
	<div id="requiredDocMenu">
	 	<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="requiredDocExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
</div>

<form id="requiredDocForm" name="requiredDocForm">

	<!-- Line Listing -->
	<div id="lineListingDiv">
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label>Line Listing</label>
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label> 
			 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
				</span>
			</div>
		</div>
		<div class="sectionDiv" id="lineListingSectionDiv" style="height:230px;">
			<div id="lineListingTableDiv" class= "subSectionDiv" style ="height:245px;">
				<div class= "subSectionDiv" id="lineListingInfoSectionDiv" style= "width: 50%;border-bottom: 0px; padding: 10px" >
					<jsp:include page="/pages/underwriting/fileMaintenance/general/requiredPolicyDocument/subPages/lineListing.jsp"></jsp:include>
		 		</div>
		 	</div>
		</div>		
	</div>

	<!-- Subline Listing -->
	<div id="sublineListingDiv">
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label>Subline Listing</label>
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label> 
					<label id="reloadForm" name="reloadForm"></label>
				</span>
			</div>
		</div>
		<div class="sectionDiv" id="sublineListingSectionDiv" style="height:230px;">
			<div id="sublineListingTableDiv" class= "subSectionDiv" style ="height:245px;">
				<div class= "subSectionDiv" id="sublineListingInfoSectionDiv" style= "width: 100%;border-bottom: 0px; padding: 10px" >
					<jsp:include page="/pages/underwriting/fileMaintenance/general/requiredPolicyDocument/subPages/sublineListing.jsp"></jsp:include>
		 		</div>
		 	</div>
		</div>		
	</div>
	
	<!-- Required Documents Maintenance -->
	<div id="requiredDocumentsMaintenanceDiv">
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label>Required Documents Maintenance</label>
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label> 
				</span>
			</div>
		</div>
		<div class="sectionDiv" id="requiredDocumentsMaintenanceSectionDiv" style="height:470px;">
			<div id="requiredDocumentsMaintenanceTableDiv" class= "subSectionDiv" style ="height:245px;">
				<div class= "subSectionDiv" id="requiredDocumentsMaintenanceInfoSectionDiv" style= "width: 100%;border-bottom: 0px; padding: 10px" >
					<jsp:include page="/pages/underwriting/fileMaintenance/general/requiredPolicyDocument/subPages/requiredDocumentsMaintenance.jsp"></jsp:include>
		 		</div>
		 	</div>
		</div>		
	</div>
</form>

<script type="text/javascript">
	setDocumentTitle("Required Policy Documents Maintenance");
	setModuleId("GIISS035");
	makeInputFieldUpperCase();
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	objGIISS035 = {};
	objGIISS035.objLineMaintain = null;
	objGIISS035.objSublineMaintain = null;
	objGIISS035.objRequiredDocMaintain = null;
	
	/* var objG035 = new Object();  //kris 05.23.2013
	objG035.currDocList = null;
	objG035.lineCd = "";
	objG035.sublineCd = ""; */

	
	observeReloadForm("reloadForm",showRequiredPolicyDocument);	
	observeCancelForm("requiredDocExit", saveRequiredDoc, function (){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main" , null);
	});
	
	function saveRequiredDoc(){
		
	}
	
</script>