<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<div id="additionalInformationDiv" name="additionalInformationDiv"style="display: none;">
	<div class="sectionDiv" id="additionalInformationSectionDiv" name="additionalInformationSectionDiv" style="overflow: visible; padding-bottom: 10px;">
		<form id="engineeringAdditionalInfoForm" name="engineeringAdditionalInfoForm">
			<table align="center" style="margin-top: 10px;">
				<tr>
					<td class="rightAligned" width="150px">Title of Contract</td>
					<td class="leftAligned" width="360px" colspan="3">
						<div style="width: 350px; border: 1px solid gray; height: 20px; padding-bottom: 1px;">
							<input type="hidden" id="txtEnggBasicInfoNum" name="txtEnggBasicInfoNum"/>
							<input type="text"  style="width: 323px; height: ; float: left; border: none;" id="txtConProjBussTitle" name="txtConProjBussTitle" maxlength="250" class="aiInput"  tabindex="301" readonly="readonly"/>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: left;" alt="EditTitle" id="editTitle" class="hover" tabindex="302"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" width="150px">Location of Contract Site</td>
					<td class="leftAligned" width="360px" colspan="3">
						<div style="width: 350px; border: 1px solid gray; height: 20px; padding-bottom: 1px;">
							<input type="text" style="width: 323px; height: ; float: left; border: none;" id="txtSiteLocation" name="txtSiteLocation" maxlength="250" class="aiInput upper" tabindex="303" readonly="readonly"/>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: left;" alt="EditLocation" id="editLocation" class="hover" tabindex="304"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" width="150px">Construction Period From: </td>
					<td class="leftAligned" width="140px">
						<input type="text" id="txtConstructStartDate" name="txtConstructStartDate" style="float: left; margin-top: 0px; margin-right: 3px; width: 129px;" readonly="readonly" tabindex="305"/>
					</td>
					<td class="rightAligned" width="58px">To: </label></td>
					<td class="leftAligned" width="140px">
						<input type="text" id="txtConstructEndDate" name="txtConstructEndDate" style="float: left; margin-top: 0px; margin-right: 3px; width: 129px;" readonly="readonly"  tabindex="307"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" width="150px">Maintenance Period From: </td>
					<td class="leftAligned" width="140px">
						<input type="text" id="txtMaintainStartDate" name="txtMaintainStartDate" style="float: left; margin-top: 0px; margin-right: 3px; width: 129px;" readonly="readonly" tabindex="309"/>
					</td>
					<td class="rightAligned" width="58px">To: </td>
					<td class="leftAligned" width="140px">
						<input type="text" id="txtMaintainEndDate" name="txtMaintainEndDate" style="float: left; margin-top: 0px; margin-right: 3px; width: 129px;" readonly="readonly" tabindex="311"/>
					</td>
				</tr>
			</table>
		</form>
	</div>
</div>

<script type="text/javascript">
	$("editTitle").observe("click", function () {
		showEditor("txtConProjBussTitle", 250, "true");
	});
	
	$("editTitle").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showEditor("txtConProjBussTitle", 250, "true");
		}
	});

	$("editLocation").observe("click", function () {
		showEditor("txtSiteLocation", 250, "true");
	});
	
	$("editLocation").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showEditor("txtSiteLocation", 250, "true");
		}
	});
</script>