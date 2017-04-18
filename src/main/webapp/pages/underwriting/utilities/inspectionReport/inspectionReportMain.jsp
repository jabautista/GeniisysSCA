<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="inspectionReportMainDiv" changeTagAttr="true">
	<div id="inspectionReportMenuDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="exit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div>
		<jsp:include page="/pages/underwriting/utilities/inspectionReport/subPages/inspectionReportBody.jsp"></jsp:include>
	</div>	
</div>

<script type="text/javascript">
	changeTag = 0;
	initializeAll();
	initializeAllMoneyFields();//added by steven 10/30/2012
	initializeAccordion();
	inspData1Obj = JSON.parse('${inspData1}'.replace(/\\/g, '\\\\'));
	getInspInfo(inspData1Obj);
	inspectionReportObj.otherDtls = {};

	$("exit").observe("click", function () {
		if (changeTag == 1){
			showConfirmBox4("Confirm", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function() {
				//added by robert SR 16550 08.20.15
				if(nvl($("inspItemInfoContainer").down("div", 0), "") == ""){
					showMessageBox("Please encode at least one item before saving the record.", "I");
					return false;
				}else{
					saveInspectionReport();
					exitInspectionReport();
				}
				//end robert SR 16550 08.20.15
			}, exitInspectionReport, "");
		} else {
			showInspectionListing(); // changed by robert 01.22.2014 from exitInspectionReport();
		}
	});

	setModuleId("GIPIS197");
	setDocumentTitle("Inspection Report");

	initializeChangeTagBehavior(saveInspectionReport);
</script>

