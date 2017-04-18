<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
<div style="width: 96.5%; float: left; font-size: 11px; margin: 10px;" id="addModuleDiv">
	<form id="moduleForm" name="moduleForm">
		<input type="hidden" id="action" name="action" value="${empty module ? 'setGiisModule' : 'updateGiisModule'}" />
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label id="message">Please complete required fields.</label>
			</div>
		</div>
		<div class="sectionDiv" style="margin-bottom: 10px;">
			<table border="0" style="margin: 10px;">
				<tr>
					<td style="width: 100px;" class="rightAligned">Module Id: </td><td><input type="text" class="required" id="moduleId" name="moduleId" style="width: 150px;" value="${module.moduleId}" /></td>
					<td style="width: 120px;" class="rightAligned">Module Group: </td>
					<td>
						<select id="moduleGrp" name="moduleGrp" style="width: 158px;">
							<option></option>
							<c:forEach var="m" items="${moduleGrps}">
								<option value="${m.rvLowValue}" 
								<c:if test="${m.rvLowValue eq module.moduleGrp}">
								selected="selected"
								</c:if>
								>${m.rvMeaning}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Description: </td><td colspan="3"><input type="text" id="moduleDesc" name="moduleDesc" style="width: 437px;" value="${module.moduleDesc}" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Module Type: </td>
					<td>
						<select id="moduleType" name="moduleType" style="width: 158px;">
							<option></option>
							<c:forEach var="m" items="${moduleTypes}">
								<option value="${m.rvLowValue}"
								<c:if test="${m.rvLowValue eq module.moduleType}">
								selected="selected"
								</c:if> 
								>${m.rvMeaning}</option>
							</c:forEach>
						</select>
					</td>
					<td class="rightAligned">Module Access Tag: </td>
					<td>
						<select id="accessTag" name="accessTag" style="width: 158px;">
							<option></option>
							<c:forEach var="m" items="${accessTags}">
								<option value="${m.rvLowValue}" 
								<c:if test="${m.rvLowValue eq module.accessTag}">
								selected="selected"
								</c:if>
								>${m.rvMeaning}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Remarks: </td>
					<td colspan="3">
						<div style="border: 1px solid gray; height: 20px; width: 443px;">
							<textarea id="remarks" name="remarks" style="float: left; width: 411px; border: none; height: 13px;">${module.remarks}</textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="4" style="text-align: right;">
						<input type="button" class="button" id="btnSaveModule" name="btnSaveModule" value="Save" />
						<input type="button" class="button" value="Cancel" onclick="hideOverlay();" />
					</td>
				</tr>
			</table>
		</div>
	</form>
</div>

<script>
	$("btnSaveModule").observe("click", function () {
		if (!checkRequiredFields()) {
			showMessageBox("Please complete required fields.", imgMessage.ERROR);
			return false;
		} else {
			new Ajax.Request(contextPath+"/GIISModuleController", {
				asynchronous: true,
				evalScripts: true,
				method: "GET",
				parameters: Form.serialize("moduleForm"),
				onCreate: function () {
					$("moduleForm").disable();
					showNotice("Saving module, please wait...");
				},
				onComplete: function (response) {
					$("moduleForm").enable();
					if (checkErrorOnResponse(response)) {
						showMessageBox("Module is successfully saved!", imgMessage.SUCCESS);
						hideNotice("");
						hideOverlay();
					}
				}
			});
		}
	});

	makeAllInputFieldsUpperCase();

	$("editRemarks").observe("click", function () {
		showEditor("remarks", 4000);
	});
</script>
