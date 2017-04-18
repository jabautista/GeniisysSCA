<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<%
	request.setAttribute("contextPath", request.getContextPath());
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
<div id="editUserDiv" name="editUserDiv" style="margin: 10px; margin-top: 30px;">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label id="updateMessage" name="updateMessage">Edit user information</label>
		</div>
	</div>
	<div class="sectionDiv" changeTagAttr="true">
		<form id="updateUserForm" name="updateUserForm">
			<table style="margin: 5px;">
				<tr>
					<td class="rightAligned" style="width: 120px;">User Id: </td>
					<td class="leftAligned"><input type="text" class="required" id="userId" name="userId" value="${userInfo.userId}" readonly="readonly" style="width: 225px;" tabindex="1" maxlength="8" /></td>
					<td class="rightAligned" style="width: 225px;"><label for="activeFlag1" class="lblForCheckbox">Active?</label> </td>
					<td><input type="checkbox" id="activeFlag1" name="activeFlag1" value="Y"  tabindex="5" 
						<c:if test="${userInfo.activeFlag eq 'Y'}">
							checked=checked
						</c:if>
					 /></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 100px;">Username: </td>
					<td class="leftAligned"><input type="text" class="required" id="username" name="username" value="${userInfo.username}" style="width: 225px;" tabindex="2" maxlength="20" /></td>
					<td class="rightAligned"><label for="commUpdateTag1" class="lblForCheckbox">Commission Rates Access?</label> </td>
					<td><input type="checkbox" id="commUpdateTag1" name="commUpdateTag1" value="Y" tabindex="6" 
						<c:if test="${userInfo.commUpdateTag eq 'Y'}">
							checked=checked
						</c:if>
					 /></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 100px;">Email: </td>
					<td class="leftAligned"><input type="text" class="required" id="email" name="email" value="${userInfo.emailAdd }" style="width: 225px;" tabindex="3" maxlength="100" /></td>
					<td class="rightAligned"><label for="allUserSw1" class="lblForCheckbox">All User Access?</label> </td>
					<td><input type="checkbox" id="allUserSw1" name="allUserSw1" value="Y" tabindex="8" 
						<c:if test="${userInfo.allUserSw eq 'Y'}">
							checked=checked
						</c:if>
					 /></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 100px;">User Group: </td>
					<td class="leftAligned">
						<input style="display: none;" type="text" id="userGrpDesc" name="userGrpDesc" value="${userInfo.userGrp}" style="width: 225px;" />
						<select id="userGroup" class="required" name="userGroup" style="width: 233px;" tabindex="4">
							<option></option>
							<c:forEach var="userGrp" items="${userGroups}">
								<option value="${userGrp.userGrp}" grpisscd="${userGrp.grpIssCd}"
									<c:if test="${userGrp.userGrp eq userInfo.userGrp}">
										selected="selected"
									</c:if>
								>${userGrp.userGrpDesc}</option>
							</c:forEach>
						</select>
					</td>
					<td class="rightAligned"><label for="managerSw1" class="lblForCheckbox">Manager Access?</label> </td>
					<td><input type="checkbox" id="managerSw1" name="managerSw1" value="Y" tabindex="9" 
						<c:if test="${userInfo.mgrSw eq 'Y'}">
							checked=checked
						</c:if>
					 /></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 100px;">Group Issue Source: </td>
					<td class="leftAligned">
						<input style="display: none;" type="text" id="issCd" name="issCd" value="${userInfo.issCd}" style="width: 225px;" />
						<select id="grpIssHidden" name="grpIssHidden" style="display: none;">
							<option></option>
							<c:forEach var="grpIssCd" items="${grpIsSources}">
								<option value="${grpIssCd.issGrp}" 
									<c:if test="${grpIssCd.issGrp eq userInfo.issCd}">
										selected="selected"
									</c:if>
								>${grpIssCd.issGrpDesc}</option>
							</c:forEach>
						</select>
						<input type="hidden" id="grpIssCd" name="grpIssCd" />
						<input type="text" readonly="readonly" style="width: 225px;" id="grpIssName" name="grpIssName" />
					</td>
					<td class="rightAligned"><label for="marketingSw1" class="lblForCheckbox">Marketing Access?</label> </td>
					<td><input type="checkbox" id="marketingSw1" name="marketingSw1" value="Y" tabindex="10" 
						<c:if test="${userInfo.mktngSw eq 'Y'}">
							checked=checked
						</c:if>
					 /></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 100px; vertical-align: top;">Remarks: </td>
					<td class="leftAligned">
						<div style="border: 1px solid gray; height: 20px; width: 231px;">
							<textarea style="width: 199px; border: none; height: 13px;" id="remarks" name="remarks" tabindex="4">${userInfo.remarks}</textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
						</div>
					</td>
					<td class="rightAligned"><label for="misSw1" class="lblForCheckbox">MIS Access?</label> </td>
					<td><input type="checkbox" id="misSw1" name="misSw1" value="Y" tabindex="11" 
						<c:if test="${userInfo.misSw eq 'Y'}">
							checked=checked
						</c:if>
					 /></td>
				</tr>
				<tr>
					<td colspan="2"></td>
					<td class="rightAligned"><label for="workflowTag1" class="lblForCheckbox">Workflow Access?</label> </td>
					<td><input type="checkbox" id="workflowTag1" name="workflowTag1" value="Y" tabindex="12" 
						<c:if test="${userInfo.workflowTag eq 'Y'}">
							checked=checked
						</c:if>
					 /></td>
				</tr>
			</table>
		</form>
	</div>
	<div class="buttonsDivPopup">
		<input type="button" class="button" id="btnResetPassword" name="btnResetPassword" value="Reset Password" tabindex="13" style="width: 120px;" />
		<input type="button" class="button" id="saveEditUser" name="saveEditUser" value="Save" tabindex="14" style="width: 60px;" />
		<input type="button" class="button" id="cancelEditUser" name="cancelEditUser" value="Cancel" tabindex="15" style="width: 60px;" />
	</div>
</div>

<script type="text/JavaScript">
	changeTag = 0;
	var action = "updateUser";
	if ($$("form#updateUserForm #userId")[0].value.blank()) {
		action = "addUser";
		$$("form#updateUserForm #userId")[0].readOnly = false;
	}

	initializeAll();

	/**
	* Created by: 	andrew robes
	* Date: 		February 04, 2011
	* Description:  Used to reset user password 
	*/
	function resetPassword(){
		try {
			new Ajax.Request(contextPath+"/GIISUserMaintenanceController", {
					method: "POST",
					parameters: {action: 	 	"resetPassword",
								 userId: 	 	$F("userId"),
								 lastUserId: 	"${PARAMETERS['USER'].userId}",
								 emailAddress: 	$F("email")},
					onCreate: function(){
						showNotice("Processing request, please wait...");
					},
					onComplete: function(response){
						if(checkErrorOnResponse(response)){
							showMessageBox(response.responseText);
						}
					}
				});
		} catch(e){
			showErrorMessage("resetPassword", e);
		}		
	}
	
	function saveEditUser(){
		if (!checkRequiredFields()) {
			showMessageBox("Please complete required fields.", imgMessage.ERROR);
			return false;
		} else if (!checkEmailIfValid2($F("email"))){
			showMessageBox("Invalid email.", imgMessage.ERROR);
			return false;
		} else {
			new Ajax.Request(contextPath+"/GIISUserMaintenanceController?action="+action+"&ajaxModal=1", {
				method: "POST",
				postBody: Form.serialize("updateUserForm"),
				evalScripts: true,
				asynchronous: true,
				onCreate: function () {
					$("updateMessage").update("Processing record, please wait...");
					$("updateUserForm").disable();
				}, onComplete: function (response) {
					if (checkErrorOnResponse(response)) {
						$("updateMessage").update(response.responseText);
						if (response.responseText.include("SUCCESS")) {
							changeTag = 0;
							if (action == "updateUser") {
								var row = $("row"+$F("userId"));
								row.down("label", 1).update($F("username"));
								row.down("label", 2).update($("userGroup").options[$("userGroup").selectedIndex].text);
								row.down("label", 3).update($F("grpIssName"));
			
								updateTags(row);
			
								changeCheckImageColor();
								hideOverlay();
			
								new Effect.Shake("row"+$F("userId"), {duration: .2});
								
								deselectRows("userListTable", "row");
								
								$("userId").clear();
							} else {
								try	{
									if ($("userListTable").childElements().size() > 9) {
										$("userListTable").childElements()[9].remove();
									}
			
									var div = new Element("div");
									div.setAttribute("id", "row"+$$("form#updateUserForm #userId")[0].value);
									div.setAttribute("name", "row");
									div.addClassName("tableRow");
									div.setStyle("display: none;");
									div.update('<label style="width: 12%; text-align: left; margin-left: 20px;">'+$$("form#updateUserForm #userId")[0].value+'</label>'+
											'<label style="width: 18%; text-align: left;">'+$F("username")+'</label>'+
											'<label style="width: 30.5%; text-align: left;">'+$("userGroup").options[$("userGroup").selectedIndex].text+'</label>'+
											'<label style="width: 21.3%; text-align: left;">'+$F("grpIssName")+'</label>'+
											'<span style="float: left; width: 20px; text-align: center;"></span>'+
											'<span style="float: left; width: 20px; text-align: center;"></span>'+
											'<span style="float: left; width: 20px; text-align: center;"></span>'+
											'<span style="float: left; width: 20px; text-align: center;"></span>'+
											'<span style="float: left; width: 20px; text-align: center;"></span>'+
											'<span style="float: left; width: 20px; text-align: center;"></span>'+
											'<span style="float: left; width: 20px; text-align: center;"></span>');
		
									$("userListTable").insert({top: div});
		
									var row = $("row"+$$("form#updateUserForm #userId")[0].value);
									updateTags(row);
		
									row.observe("mouseover", function ()	{
										row.addClassName("lightblue");
									});
									
									row.observe("mouseout", function ()	{
										row.removeClassName("lightblue");
									});
									
									row.observe("click", function ()	{
										row.toggleClassName("selectedRow");
										if (row.hasClassName("selectedRow"))	{
											$("userId").value = row.getAttribute("id").substring(3);
											$$("div.tableContainer div[name='row']").each(function (r)	{
												if (row.getAttribute("id") != r.getAttribute("id"))	{
													r.removeClassName("selectedRow");
												}
											});
										} else {
											$("userId").value = "";
										}
									});
									positionPageDiv();
									changeCheckImageColor();
									hideOverlay();
									$("userId").clear();
									Effect.Appear(row, {duration: .5});
									$("updateUserForm").enable();
									$("updateUserForm").reset();
								} catch (e) {
									$("updateUserForm").enable();
									showErrorMessage("editUser.jsp - saveEditUser", e);
								}
							}
							positionPageDiv();
						}

						$("updateUserForm").enable();
					}
				}
			});
		}
	}
	
	function updateTags(row) {
		var checked = "<img name='checkedImg' style='width: 10px; height: 10px; text-align: left; display: block; margin-left: 1px;' />";
		var unchecked = "<label style='float: left; width: 10px; height: 10px; text-align: center;'>-</label>";
		
		if ($("activeFlag1").checked) {
			row.down("span", 0).update(checked);
		} else {
			row.down("span", 0).update(unchecked);
		}

		if ($("commUpdateTag1").checked) {
			row.down("span", 1).update(checked);
		} else {
			row.down("span", 1).update(unchecked);
		}

		if ($("allUserSw1").checked) {
			row.down("span", 2).update(checked);
		} else {
			row.down("span", 2).update(unchecked);
		}

		if ($("managerSw1").checked) {
			row.down("span", 3).update(checked);
		} else {
			row.down("span", 3).update(unchecked);
		}

		if ($("marketingSw1").checked) {
			row.down("span", 4).update(checked);
		} else {
			row.down("span", 4).update(unchecked);
		}

		if ($("misSw1").checked) {
			row.down("span", 5).update(checked);
		} else {
			row.down("span", 5).update(unchecked);
		}

		if ($("workflowTag1").checked) {
			row.down("span", 6).update(checked);
		} else {
			row.down("span", 6).update(unchecked);
		}
	}

	changeGroupIssueSource();
	makeAllInputFieldsUpperCase();

	function checkEmailIfValid(emailAdd){ //checking of email (in use)
		var isValid = true;
		
		if (emailAdd.indexOf("@") == 0 || emailAdd.indexOf("@") == -1 || emailAdd.indexOf("@") == emailAdd.length - 1){
			isValid = false;
		} else if (emailAdd.indexOf(".") == 0 || emailAdd.indexOf(".") == -1 || emailAdd.indexOf(".") == emailAdd.length - 1){
			isValid = false;
		} else if (emailAdd.indexOf("@") + 1 == emailAdd.indexOf(".") || emailAdd.indexOf(".") + 1 == emailAdd.indexOf("@")){
			isValid = false;
		} else if (count(emailAdd, "@") > 1 || (count(emailAdd.substring((emailAdd.indexOf("@") + 1), (emailAdd.length)), ".")) > 2 || emailAdd[emailAdd.indexOf(".") + 1] == "."){
			isValid = false;
		}

		return isValid;
	}

	function checkEmailIfValid2(emailAdd){ //alternate checking of email
		var isValid = true;
		var emailRegEx = /^([a-zA-Z0-9])+([\.a-zA-Z0-9_-])*@([a-zA-Z0-9])+(\.[a-zA-Z0-9_-]+)+$/;

		isValid = emailRegEx.test(emailAdd);

		return isValid;
	}

	function count(string, re){
		var cnt = 0;
		for (var i = 0; i < string.length; i++){
			if(string[i] == re){
				cnt++;
			}
		}
		return cnt;
	}
	
	$$("form#updateUserForm #userId")[0].focus();
	
	$("cancelEditUser").observe("click", function () {
		hideOverlay();
	});

	$("saveEditUser").observe("click", function () {
		saveEditUser();
	});
	
	$("btnResetPassword").observe("click", function(){
		if(changeTag == 1){
			showMessageBox("Please save your changes first before resetting the password.");
			return;
		} else if ($F("email") == ""){
			showMessageBox("Please enter an email address first for user " + $F("username") + " before resetting the password.");
			return;
		}
		showConfirmBox("Confirmation", "Are you sure you want to reset the password of user " + $F("username") + "?", "Yes", "No", 
						resetPassword, "");
	});
	
	$("userGroup").observe("change", function () {
		changeGroupIssueSource();
	});
	
	$("editRemarks").observe("click", function () {
		showEditor("remarks", 4000);
	});
	
	initializeChangeTagBehavior(saveEditUser);
</script>