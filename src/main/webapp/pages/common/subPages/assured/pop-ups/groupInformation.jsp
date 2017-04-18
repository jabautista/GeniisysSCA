<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div id="groupDiv" name="groupDiv" class="sectionDiv" style="width: 99.5%; margin-top: 3px;">
	<span class="notice" id="noticePopup" name="noticePopup" style="display: none;">Saving, please wait...</span>
	<form id="groupForm" name="groupForm" style="margin: 10px;">
		<input type="hidden" id="assdNo" name="assdNo" value="${assdNo}" />
		<div id="groupTable">
			<div class="tableHeader" id="groupListingHeader">
				<label style="text-align: center; width: 40%;">Group Code</label>
				<label style="text-align: left; width: 60%;">Group Description</label>
			</div>
			<div id="groupListing">
				<c:forEach var="i" items="${assdGroups}">
					<div name="group" id="group${i.groupCd}" class="tableRow"  groupCd="${i.groupCd}">
						<label style="width: 40%; text-align: center;">${i.groupCd}</label>
						<label style="width: 60%;">${i.groupDesc}</label>
						<input type="hidden" name="groupCds" value="${i.groupCd}" />
						<input type="hidden" name="groupDescs" value="${i.groupDesc}" />
						<input type="hidden" name="remarks" value="${i.remarks}" />
						<input type="hidden" name="userId" value="${i.userId}" />
						<input type="hidden" name="lastUpdate" value="${i.lastUpdate}" />
					</div>
				</c:forEach>
			</div>
		</div>
		
		<%-- <jsp:include page="../otherInformation.jsp"></jsp:include> --%>
		<table align="center" style="margin: 10px auto;">
			<tr>
				<td class="rightAligned">Group Code</td>
				<td class="leftAligned" colspan="3">
					<select id="groupCd" name="groupCd" style="width: 400px;" class="required">
						<option value=""></option>
						<c:forEach var="g" items="${groups}">
							<option value="${g.groupCd}">${g.groupDesc}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 100px;">
					Remarks </td> 
				<td class="leftAligned" colspan="3">
					<div style="border: 1px solid gray; height: 20px;">
						<textarea id="txtRemarks" name="txtRemarks" style="width: 370px; border: none; height: 13px;" tabindex="34" >${assured.remarks}</textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">
					User ID </td>
				<td class="leftAligned">
					<input type="text" id="userIdG" name="userIdG" style="width: 150px;" readonly="readonly" 
					<%-- <c:choose>
						<c:when test="${not empty assured}">
							value="${assured.userId}"
						</c:when>
						<c:otherwise>
							value="${PARAMETERS['USER'].userId}"
						</c:otherwise>
					</c:choose> --%>
					tabindex="35" /></td>
				<td class="rightAligned" style="width: 80px;">
					Last Update</td>
				<td class="leftAligned">
					<input type="text" id="lastUpdateG" name="lastUpdateG" style="width: 150px;" readonly="readonly" 
					<%-- <c:choose>
						<c:when test="${not empty assured}">
							value="<fmt:formatDate pattern="MM-dd-yyyy hh:mm:ss a" value="${assured.lastUpdate}" />"
						</c:when>
						<c:otherwise>
							value="<fmt:formatDate pattern="MM-dd-yyyy hh:mm:ss a" value="<%= new java.util.Date() %>" />"
						</c:otherwise>
					</c:choose> --%>
					tabindex="36" /></td>
			</tr>
		</table>
	</form>	
	
	<div id="buttonsDiv" align="center" style="margin-bottom: 8px;">
		<input type="button" class="button" id="btnAddG" name="btnAddG" value="Add" style="width: 60px;" />
		<input type="button" class="disabledButton" id="btnDeleteG" name="btnDeleteG" value="Delete" style="width: 60px;" />
	</div>
</div>

<div class="buttonsDivPopup">
	<!-- <input type="button" class="button" style="width: 60px;" id="btnSaveG" name="btnSaveG" value="Save" /> -->
	<input type="button" class="button" style="width: 60px;" id="btnCancel" name="btnCancel" value="Cancel" />
	<input type="button" class="button" style="width: 60px;" id="btnSaveG" name="btnSaveG" value="Save" />
</div>

<script>
	// andrew - 03.02.2011 - added this 'if' block
	if($F("hidViewOnly") == "true") {
		$("btnSaveG").hide();
		$("btnCancel").value = "Close";
		//$("tabGroupInformation").hide();
		var tempDiv = new Element("div", {id:"tempDiv"});
		tempDiv.update("No group information records.");
		$("groupListing").insert({bottom: tempDiv});
		
		$("groupCd").disable();
		disableButton("btnAddG");
		disableButton("btnDeleteG");
		disableInputField("txtRemarks");
	}

	var changeTagForm = 0;
	var changeTagModal = 0;
	addStyleToInputs();
	initializeAll();
	initializeAccordion();
	filterGroupInfo();

	$("btnCancel").observe("click", function () {
		if(changeTagModal == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", saveAndExitG, exitG, "");
		} else {
			groupInfoOverlay.close();
			delete groupInfoOverlay;
			changeTag = 0;
		}
	});
	
	function exitG(){
		groupInfoOverlay.close();
		delete groupInfoOverlay;
		changeTag = 0;
	}; // ++robert - 07.08.2011
	
	function saveAndExitG(){
		saveG("Y");
	};// ++robert - 07.11.2011

	/* $("btnCancel").observe("click", function(){
		if(changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", saveAndExitG, exitG, "");
		}  else {
			Modalbox.hide();
		}
	}); */ // ++robert - 07.08.2011 comment out by bonok :: 08.22.2012

	$("btnAddG").observe("click", addG);
	$("btnDeleteG").observe("click", deleteG);
	$("btnSaveG").observe("click", saveG);
	
	/* $("btnSaveG").observe("click", function() {
		if(changeTag == 1) {
			saveG();
		} else {
			showMessageBox("No changes to save.", imgMessage.INFO);
		}
	}); */
	
	$$("div[name='group']").each(function (row) {
		row.observe("mouseover", function ()	{
			row.addClassName("lightblue");
		});
		
		row.observe("mouseout", function ()	{
			row.removeClassName("lightblue");
		});

		row.observe("click", function ()	{
			row.toggleClassName("selectedRow");
			
			if (row.hasClassName("selectedRow"))	{
				if($("btnAddG").value == "Add"){
					if($("groupCd").value != "" || $("txtRemarks").value != ""){
						var message = "Changes have been made. Press "+ $("btnAddG").value + " button first to apply changes.";
						showMessageBox(message);
						row.removeClassName("selectedRow");
						return false;	
					}
				}
				if(changeTagForm == 1 && $("btnAddG").value != "Add"){
					var message;
					message = "Changes have been made. Press "+ $("btnAddG").value + " button first to apply changes otherwise unselect the record to clear changes.";
					showMessageBox(message);
					row.removeClassName("selectedRow");
					return false;
				}
				$("txtRemarks").value = unescapeHTML2(row.down("input",2).getAttribute("value"));
				$$("div[name='group']").each(function (it)	{
					if (row.getAttribute("id") != it.getAttribute("id"))	{
						it.removeClassName("selectedRow");
					}
				});

				var groupCd = $("groupCd");
				for (var i=0; i<groupCd.length; i++)	{
					if (groupCd.options[i].value == row.down("input", 0).value)	{
						groupCd.selectedIndex = i;
					}
				}
				
				$("userIdG").value = row.down("input", 3).value;
				$("lastUpdateG").value = row.down("input", 4).value;

				$("btnAddG").value = "Update";
				/*$("btnDeleteG").enable();
				$("btnDeleteG").removeClassName("disabledButton");
				$("btnDeleteG").addClassName("button");*/
				enableButton("btnDeleteG");
			} else {
				changeTagForm = 0;
				resetGForm();
			}
		});
	});
	
	function resetGForm() {
		$("groupCd").selectedIndex = 0;
		$("btnAddG").value = "Add";
		disableButton("btnDeleteG");
		$("txtRemarks").value = "";
		/*$("btnDeleteG").removeClassName("button");
		$("btnDeleteG").addClassName("disabledButton");
		$("btnDeleteG").disable();*/
		$$("div[name='group']").each(function (it)	{
			it.removeClassName("selectedRow");
		});
		$("userIdG").value = "";
		$("lastUpdateG").value = "";
	}
	
	$("txtRemarks").observe("change", function(){
		if($("btnAddG").value == "Update"){
			changeTagForm = 1;	
		}
	});
	
	$("txtRemarks").observe("keyup", function () {
		limitText(this, 4000);
	});
	
	$("groupCd").observe("change", function(){
		if($("btnAddG").value == "Update"){
			changeTagForm = 1;	
		}
	});
	
	function addG() {		
		if(!checkAllRequiredFieldsInDiv("groupDiv")){
			return;
		}
		
		var groupCd = $F("groupCd");
		var groupDesc = $("groupCd").options[$("groupCd").selectedIndex].text;
		var remarks = escapeHTML2($F("txtRemarks"));
		if (groupCd.blank() || groupDesc.blank()) {
			//showNoticeInPopup("Please complete fields.");
			showMessageBox("Please complete required fields.", imgMessage.ERROR);
			return false;
		}

		var exists = false;
		$$("div[name='group']").each( function(i)	{
			if(changeTag == 0){
				if (i.getAttribute("id") == "group"+groupCd && $F("btnAddG") != "Update")	{ //marco - 08.19.2014 - added second condition
					//showNoticeInPopup("Record already exists!");
					showMessageBox("Record already exists!", imgMessage.ERROR);
					exists = true;
					return false;	
				}	
			}
		});

		if (!exists) {
			if ($F("btnAddG") == "Update") {
				$$("div[name='group']").each(function (group)	{
					if (group.hasClassName("selectedRow")){
						Effect.Fade(group, {
							duration: .5,
							afterFinish: function ()	{
								group.remove();
							} 
						});
					}
				});
			} 
			
			var newGDiv = new Element('div');
			newGDiv.setAttribute("name", "group");
			newGDiv.setAttribute("id", "group"+groupCd);
			newGDiv.setAttribute("groupCd", groupCd);
			newGDiv.setAttribute("remarks", remarks);
			newGDiv.setAttribute("groupDescs", groupDesc);
			newGDiv.addClassName("tableRow");
			newGDiv.setStyle("display: none;");
			newGDiv.update('<label style="width: 40%; text-align: center;">'+groupCd+'</label>'+								  
					 '<label style="width: 60%; text-align: left;">'+groupDesc+'</label>'+	
					 '<input type="hidden" name="groupCds" 		value="'+groupCd+'" />'+
					 '<input type="hidden" name="groupDescs" 	value="'+groupDesc+'" />'+
					 '<input type="hidden" name="remarks"		value="'+remarks+'"/>' +
					 '<input type="hidden" name="userId" 		value="'+userId+'" />'+
					 '<input type="hidden" name="lastUpdate"	value="'+dateFormat(new Date(), 'mm-dd-yyyy hh:MM:ss TT')+'"/>');
			
			$('groupListing').insert({bottom: newGDiv});
			filterGroupInfo();			
			newGDiv.observe("mouseover", function ()	{
				newGDiv.addClassName("lightblue");
			});
			
			newGDiv.observe("mouseout", function ()	{
				newGDiv.removeClassName("lightblue");
			});

			newGDiv.observe("click", function ()	{
				newGDiv.toggleClassName("selectedRow");
				if (newGDiv.hasClassName("selectedRow"))	{
					if($("btnAddG").value == "Add"){
						if($("groupCd").value != "" || $("txtRemarks").value != ""){
							var message = "Changes have been made. Press "+ $("btnAddG").value + " button first to apply changes.";
							showMessageBox(message);
							row.removeClassName("selectedRow");
							return false;	
						}
					}
					if(changeTagForm == 1 && $("btnAddG").value != "Add"){
						var message;
						message = "Changes have been made. Press "+ $("btnAddG").value + " button first to apply changes otherwise unselect the record to clear changes.";
						showMessageBox(message);
						row.removeClassName("selectedRow");
						return false;
					}
					$("txtRemarks").value = newGDiv.down("input",2).getAttribute("value");
					$$("div[name='group']").each(function (it)	{
							if (newGDiv.getAttribute("id") != it.getAttribute("id"))	{
							it.removeClassName("selectedRow");
						}
					});

					var group = $("groupCd");
					for (var i=0; i<group.length; i++)	{
						if (group.options[i].value == newGDiv.down("input", 0).value)	{
							group.selectedIndex = i;
						}
					}

					$("btnAddG").value = "Update";
					$("userIdG").value = newGDiv.down("input", 3).value;
					$("lastUpdateG").value = newGDiv.down("input", 4).value;
					/*$("btnDeleteG").removeClassName("disabledButton");
					$("btnDeleteG").addClassName("button");
					$("btnDeleteG").enable();*/
					enableButton("btnDeleteG");
				} else {
					changeTagForm = 0;
					resetGForm();
				}
			});

			Effect.Appear(newGDiv, {
				duration: .5,
				afterFinish: function ()	{
					checkTableIfEmpty("group", "groupListingHeader");
					checkIfToResizeTable("groupListing", "group");
				}
			});
			changeTag = 1;
			changeTagForm = 0;
			resetGForm();
			changeTagModal = 1;
		}
	}

	function deleteG(){		
		$$("div[name='group']").each(function (group)	{			
			if (group.hasClassName("selectedRow")){				
				new Ajax.Request(contextPath+"/GIISAssuredController", {
					parameters : {action : "valDeleteGroupInfo",
							      assdNo : $F("generatedAssuredNo"), 
						          groupCd : group.readAttribute("groupCd")},
					onComplete: function(response){
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){						
							Effect.Fade(group, {
								duration: .5,
								afterFinish: function ()	{
									group.remove();
									filterGroupInfo();
									resetGForm();
									checkTableIfEmpty("group", "groupListingHeader");
									checkIfToResizeTable("groupListing", "group");
								} 
							});
							changeTagModal = 1;
							changeTag = 1;
						}
					}
				});				
			}
		});
	}
	
	function filterGroupInfo(){
		(($$("select#groupCd option[disabled='disabled']")).invoke("show")).invoke("removeAttribute", "disabled");
		
		$$("div#groupListing div[name='group']").each(function(row){
				var groupCd = row.getAttribute("groupCd");
				(($$("select#groupCd option[value='" + groupCd+ "']")).invoke("hide")).invoke("setAttribute", "disabled", "disabled");				
		});
		$("groupCd").options[0].show();
		$("groupCd").options[0].disabled = false;
	}
	
	checkTableIfEmpty("group", "groupListingHeader");
	checkIfToResizeTable("groupListing", "group");

	function saveG(exitSw)	{
		/* var groupCd = $F("groupCd");
		var groupDesc = $("groupCd").options[$("groupCd").selectedIndex].text;
		if (groupCd.blank() || groupDesc.blank()) {
			showMessageBox("Please complete required fields.", imgMessage.ERROR);
			return false;
		} */
		//if(checkPendingRecordChanges()){ - bonok :: 8.16.2012
			if($("btnAddG").value == "Add"){
				if($("groupCd").value != "" || $("txtRemarks").value != ""){
					var message = "Changes have been made. Press "+ $("btnAddG").value + " button first to apply changes.";
					showMessageBox(message);
					return false;	
				}	
			}
			if(changeTag == 0){
				showMessageBox(objCommonMessage.NO_CHANGES);
				return false;
			}
			if(changeTagForm == 1) {
				var message = "Changes have been made. Press "+ $("btnAddG").value + " button first to apply changes otherwise unselect the record to clear changes.";
				showMessageBox(message);
			}else{
				new Ajax.Request(contextPath+"/GIISAssuredController?ajax=1&action=saveG", {
					method: "POST",
					postBody: Form.serialize("groupForm"),
					onCreate: function() {
						showNotice("Saving, please wait...");
					}, 
					onComplete: function (response)	{
						if (checkErrorOnResponse(response)) { 
							hideNotice();
							if (response.responseText == "SUCCESS") {
								changeTag = 0;								
								changeTagForm = 0;
								changeTagModal = 0;
								showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, nvl(exitSw, "N") == "Y" ? exitG : resetGForm);
							}
						}
					}
				});
			}
			
		//}	
	}
	// ++robert - 07.11.2011
	changeTag = 0;
	initializeChangeTagBehavior(saveG);
	initializeChangeAttribute();
	$("editRemarks").observe("click", function () {
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
</script>