<!--
Remarks: For deletion
Date : 03-20-2012
Developer: Maggie Cadwising
Replacement : /pages/common/reason/reasonMaintenanceTableGrid.jsp
--> 



<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="maintainReasonDiv" name="maintainReasonDiv" style="margin-top: 1px;">
 	<form id="maintainReasonForm" name="maintainReasonForm">  
	
		<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv">
				<label>Reasons for Denial Maintenance</label>
				<span class="refreshers" style="margin-top: 0;">
					<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
					<label id="reloadReasonForm" name="reloadReasonForm">Reload Form</label>
				</span>
			</div>
		</div>
		<div id="reasonsInfoDiv" name="reasonsInfoDiv" class="sectionDiv" align="center">
			<div id="reasonsListDiv" name="reasonsListDiv" style="margin: 10px; width: 96%;">
				<div id="usedReasonsDiv" name="usedReasonsDiv" style="display: none;">
					<c:forEach var="usedReason" items="${usedReasons}">	
						<input type="hidden" id="usedReasonCd${usedReason.reasonCd}" name="usedReasonCd" value="${usedReason.reasonCd}" />
					</c:forEach>
				</div>	
				<div class="tableHeader" id="reasonInfoTable" name="reasonInfoTable"> 
					<label style="width: 150px; text-align: left; margin-left: 5px;">Line of Business</label>
					<label style="width: 125px; text-align: left; margin-left: 5px;">Reason Code</label>
					<label style="width: 150px; text-align: left; margin-left: 5px;">Description</label>
					<label style="width: 350px; text-align: left; margin-left: 10px;">Remarks</label>
				</div>
				
				<div id="forDeleteDiv" name="forDeleteDiv" style="visibility: hidden;"></div>
				<div id="forInsertDiv" name="forInsertDiv" style="visibility: hidden;"></div>
				
				<div id="reasonsList" name="reasonsList" class="tableContainer">
					<c:forEach var="reason" items="${reasons}">
						<div id="reason${reason.reasonCd}" name="reasonRow"  class="tableRow"  >
							<input type="hidden" id="reasonCd${reason.reasonCd}" 	name="reasonCd" 	value="${reason.reasonCd}" />
							<input type="hidden" id="reasonDesc${reason.reasonCd}" 	name="reasonDesc" 	value="${reason.reasonDesc}" />
							<input type="hidden" id="remarks${reason.reasonCd}" 	name="remarks" 		value="${reason.remarks}" />
							<input type="hidden" id="lineCd${reason.reasonCd}" 		name="lineCd" 		value="${reason.lineCd}" />
							<input type="hidden" id="lineName${reason.reasonCd}" 	name="lineName" 	value="${reason.lineName}" />
						
  							<label style="width: 150px; text-align: left; margin-left: 5px;" name="lineName" title="${reason.lineCd}" >${reason.lineName}</label>
							<label style="width: 125px; text-align: left; margin-left: 5px;" name="reasonCd" title="${reason.reasonCd}" >${reason.reasonCd}</label>
							<label style="width: 150px; text-align: left; margin-left: 5px;" name="reasonDesc" title="${reason.reasonDesc}" >${reason.reasonDesc}</label>
							<label style="width: 350px; height: 13px; text-align: left; margin-left: 10px;" name="remarksDisp" title="${reason.remarks}" >${reason.remarks}</label>						
						</div>
					</c:forEach>
				</div>
			</div>
			<div id="reasonInfoDiv" name="reasonInfoDiv" style="width: 100%, margin: 10px 0px 5px 0px;">
				<table align="center" width="60%">
					<tr>
						<td class="rightAligned">Line of Business</td>
						<td class="leftAligned">
							<!-- <input type="text" id="inputLineDisplay" name="inputLineDisplay" readonly="readonly" class="required" style="width: 80%;; display: none;" /> -->	
							<select id="inputLine" name="inputLine" style="width: 82.2%;" class="required">
								<option value="" ></option>
								<c:forEach var="line" items="${lines}">
									<option value="${line.lineCd}">${line.lineName}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Reason Code</td>
						<td class="leftAligned">
							<input type="text" id="inputReasonCd" name="inputReasonCd" style="width: 80%; text-align: right;" value="" readonly="readonly" disabled="disabled" />
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Description</td>
						<td class="leftAligned">
						<div style="border: 1px solid gray; height: 20px; width: 81.7%;">
							<textarea id="inputDesc" name="inputDesc" style="width: 91% ; border: none; height: 13px;" class="required"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="EditDesc" id="editDescriptionText" />
						</div>
							<!-- <input type="text" style="width: 80%;; text-align: left;" id="inputDesc" name="inputDesc" class="required" /> -->
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Remarks</td>
						<td class="leftAligned">
							<div style="border: 1px solid gray; height: 20px; width: 81.7%; ">
								<textarea id="inputRemarks" name="inputRemarks" style="width: 91% ; border: none; height: 13px;"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="EditRemark" id="editRemarksText" />
							</div>
						</td>
					</tr>
				</table>
			</div>
		
			<div style="margin-bottom: 10px; margin-top: 10px;">
				<input type="button" class="button" style="width: 60px;" id="btnAddReason" name="btnAddReason" value="Add" />
				<input type="button" class="disabledButton" style="width: 60px;" id="btnDelReason" name="btnDelReason" value="Delete" disabled="disabled" />
			</div>	
		</div>
		<div class="buttonsDiv" id="reasonButtonsDiv">
			<input type="button" class="button" style="width: 90px;" id="btnReasonCancel" name="btnReasonCancel" value="Cancel" />
			<input type="button" class="button" style="width: 90px;" id="btnReasonSave" name="btnReasonSave" value="Save" />
		</div>
 	</form>  
</div>

<script type="text/javascript">
	var pageActions = {none: 0, save : 1, reload : 2, cancel : 3};
	var pAction = pageActions.none;
	addStyleToInputs();
	initializeAll();
	initializeAccordion();
	
	initializeTable("tableContainer", "reasonRow", "", "");
	setDocumentTitle("Maintain Reason");
	setModuleId("GIISS204");
	checkTableIfEmpty("reasonRow", "reasonsListDiv");
	checkIfToResizeTable("reasonsList", "reasonRow");
	
	changeTag = 0;

	$("quotationMenus").hide();
	truncReasonLabels();
	
	var reasonCd = null;
	var reasonDesc = null;
	var remarks = null;
	var lineCd = null;
	var lineName = null;
	
	$("btnAddReason").observe("click", checkInput);
	$("btnDelReason").observe("click", deleteReason);
	$("btnReasonSave").observe("click", function() {
		if(changeTag == 0){
			showMessageBox("No changes to save.");
		} else {
			pAction = pageActions.save;
			saveReasonInfo();
		}
	});
	
	$("btnReasonCancel").observe("click", function() {
		if(changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", saveAndCancel, showCreateQuotationPage, "");
		} else {
			showCreateQuotationPage();
		}
	});

	$("reloadReasonForm").observe("click", function() {
		if(changeTag == 1) {
			//showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", saveAndReloadReason, showMaintainReasonForm, "");
			showConfirmBox("Confirmation", objCommonMessage.RELOAD_WCHANGES, "Yes", "No", 
					function(){
						showMaintainReasonForm();
						changeTag = 0;
					}, stopProcess);
		} else {
			showMaintainReasonForm();
		}
	});
	
	$$("div[name='reasonRow']").each(function (row){
		
		row.observe("click", function() {
			if(row.hasClassName("selectedRow")) {
				setReasonInfoForm(row);
			} else {
				setReasonInfoForm(null);
			}
		});
	});

	function checkIfInUse() {
		setVariables();
		var exists = false;
		$$("input[name='usedReasonCd']").each(function (c) {
			if(c.value == reasonCd) {
				exists = true;
			}
		});
		return exists;
	}

	$("inputLine").observe("focus", function() {
		var exists = checkIfInUse();
		if(exists && $F("btnAddReason") == "Update") {
			$("inputLine").disable();
			showMessageBox("Unable to update. Selected Reason is already used in a Quotation.");
		} 
	});

	$("inputLine").observe("change", function() {
		if($F("inputReasonCd") == "" && $F("btnAddReason") == "Add") {
			$("inputReasonCd").value = getReasonCode();
		}
	});

	$("inputDesc").observe("focus", function() {
		var exists = checkIfInUse();
		if(exists && $F("btnAddReason") == "Update") {
			$("inputDesc").setAttribute("readonly", "readonly");
			showMessageBox("Unable to update. Selected Reason is used in a Quotation.");
		} 
	});

	function truncReasonLabels() {
		$$("label[name='remarksDisp']").each(function (label) {
			if((label.innerHTML).length > 50) {
				label.update((label.innerHTML).truncate(50, "..."));
			}
		});

		$$("label[name='reasonDesc']").each(function (label) {
			label.update((label.innerHTML).truncate(20, "..."));
		});
	}
	
	function getReasonCode() {
		var rCd = 0;
		$$("div[name='reasonRow']").each(function(row) {
			if(rCd < row.down("input", 0).value) {
				rCd = parseInt(row.down("input", 0).value);
			}
		});
		return rCd+1;
	}
	
	function setVariables() {	
		reasonCd = $F("inputReasonCd");
		reasonDesc = changeSingleAndDoubleQuotes($F("inputDesc")).escapeHTML();
		remarks = changeSingleAndDoubleQuotes($F("inputRemarks")).escapeHTML();
		lineCd = $F("inputLine");
		lineName = $("inputLine").options[$("inputLine").selectedIndex].text;
	}
	
	function setReasonInfoForm(row) {
		try{
			if(row==null) {
				$("inputLine").enable();
				$("inputLine").selectedIndex = 0;
				$("inputReasonCd").clear();
				$("inputDesc").clear();
				$("inputRemarks").clear();
				$("inputDesc").removeAttribute("readonly");
			} else {
				var r = $("inputLine");
				var rowSelected;
				for(var i=0; i<r.length; i++) {
					if(r.options[i].value == row.down("input", 3).value) {
						r.selectedIndex = i;
						rowSelected = row.down("input", 4).value;
					}
				}
				$("inputLine").value = rowSelected;
				$("inputReasonCd").value = row.down("input", 0).value;
				$("inputDesc").value = row.down("input", 1).value;
				$("inputRemarks").value = row.down("input", 2).value;

				var inUse = checkIfInUse();
				if(inUse) {
					$("inputLine").disable();
					$("inputDesc").setAttribute("readonly", "readonly");
				} else {
					$("inputLine").enable();
					$("inputDesc").removeAttribute("readonly");
				}
			}
			$("btnAddReason").value = (row == null ? "Add" : "Update");
			(row == null ? disableButton("btnDelReason") : enableButton("btnDelReason"));
		} catch(e) {
			showErrorMessage("setReasonInfoForm", e);
			//showMessageBox("setReasonInfoForm: " + e.message);
		}
		
	}
	
	function checkInput() {
		var exists = checkIfInUse();
		if(reasonDesc == "" && lineCd == "") {
			showMessageBox("Required fields must be entered.", imgMessage.ERROR);
			$("inputDesc").focus();
			return false;
		} else if (reasonDesc == "") {
			showMessageBox("Required fields must be entered.", imgMessage.ERROR);
			$("inputDesc").focus();
			return false;
		} else if(lineCd == "") {
			showMessageBox("Required fields must be entered.", imgMessage.ERROR);
			$("inputLine").focus();
			return false;		
		} else if(exists == true && $F("btnAddReason") != "Update") {
			showMessageBox("Required fields must be entered.", imgMessage.ERROR);
			$("inputLine").focus();
			return false;	
		} else {
			addReason();
		}
	}
	
	function addReason() {
		try{
			var reasonInfoDiv = $("reasonsList");
			var forInsertDiv = $("forInsertDiv");
			var insertContent = '<input type="hidden" 	id="insReasonCd'+ reasonCd + '" 	name="insReasonCd" 		value="'+ reasonCd +'" />' + 
								'<input type="hidden" 	id="insReasonDesc'+ reasonCd +'"	name="insReasonDesc"	value="'+ reasonDesc +'"/>' + 
								'<input type="hidden" 	id="insRemarks'+ reasonCd +'"		name="insRemarks"		value="'+ remarks +'"/>' + 
								'<input type="hidden" 	id="insLineCd'+ reasonCd +'"		name="insLineCd"		value="'+ lineCd +'"/>';
								'<input type="hidden" 	id="insLineName'+ reasonCd +'"		name="insLineName"		value="'+ lineName +'"/>';
	
			var viewContent = 	'<input type="hidden" 	id="reasonCd'+ reasonCd +'" 	name="reasonCd" 	value="'+ reasonCd +'" />' + 
								'<input type="hidden" 	id="reasonDesc'+ reasonCd +'" 	name="reasonDesc" 	value="'+ changeSingleAndDoubleQuotes2(fixTildeProblem(reasonDesc)) +'" />' +
								'<input type="hidden" 	id="remarks'+ reasonCd +'" 		name="remarks" 		value="'+ changeSingleAndDoubleQuotes2(fixTildeProblem(remarks)) +'" />' +
								'<input type="hidden" 	id="lineCd'+ reasonCd +'" 		name="lineCd" 		value="'+ lineCd +'" />' +
								'<input type="hidden" 	id="lineName'+ reasonCd +'" 	name="lineName" 	value="'+ lineName +'" />' +
								
								'<label style="width: 150px; text-align: left; margin-left: 5px;" 	name="lineName" 		title="'+ lineCd +'" >'+ lineName +'</label>'	+
								'<label style="width: 125px; text-align: left; margin-left: 5px;" 	name="reasonCd" 		title="'+ reasonCd +'" >'+ reasonCd +'</label>'	+
								'<label style="width: 150px; height: 13px; text-align: left; margin-left: 5px; " 			name="reasonDesc" 		title="'+ reasonDesc +'" >'+ reasonDesc +'</label>' +
								'<label style="width: 350px; height: 13px; text-align: left; margin-left: 10px;" 			name="remarksDisp" 		title="'+ remarks +'" >'+ remarks +'</label>';
			
			if ($F("btnAddReason") == "Update") {				
				$("reason"+reasonCd).update(viewContent);
			} else {
				var newDiv = new Element("div");	
				newDiv.setAttribute("id", "reason"+reasonCd);
				newDiv.setAttribute("name", "reasonRow");
				newDiv.addClassName("tableRow");
				newDiv.setStyle("display: none;");
				newDiv.update(viewContent);
	
				reasonInfoDiv.insert({bottom : newDiv});
				
				var insertDiv = new Element("div");
				insertDiv.setAttribute("id", "insReason"+reasonCd);
				insertDiv.setAttribute("name", "insReason");
				insertDiv.setStyle("visibility: hidden;");
				insertDiv.update(insertContent);
				
				forInsertDiv.insert({bottom : insertDiv});
						
				newDiv.observe("mouseover", function() {
					newDiv.addClassName("lightblue");
				});						
	
				newDiv.observe("mouseout", function ()	{
					newDiv.removeClassName("lightblue");
				});
	
				newDiv.observe("click", function() {
					newDiv.toggleClassName("selectedRow");
					if(newDiv.hasClassName("selectedRow")) {
						setReasonInfoForm(newDiv);
					} else {
						setReasonInfoForm(null);
					}	
				});
				
				Effect.Appear(newDiv, {
					duration: .5,
					afterFinish: function () {
						setReasonInfoForm(null);
					}
				});
				
				checkTableIfEmpty("reasonRow", "reasonsListDiv");
				checkIfToResizeTable("reasonsList", "reasonRow");
			}
			changeTag = 1;
			setReasonInfoForm(null);
			$("inputReasonCd").clear();
			truncReasonLabels();
			
		}catch(e) {
			showErrorMessage("addReason", e);
			//showMessageBox("add reason: " + e.message);
		}
	}
	
	function deleteReason() {
		try {
			var exists = checkIfInUse();
	/*		setVariables();
			$$("input[name='usedReasonCd']").each(function(u) {
				if(u.value == reasonCd) {
					exists = true;
				}	
			});*/
			if(exists == true) {
				showMessageBox("Unable to Delete. Selected Reason is used in a Quotation.");
				setReasonInfoForm(null);
				return false;
			} else {
				showConfirmBox("Delete Reason","Are you sure you want to delete reason as lost bid reason for " + lineName +"?", 
								"Yes", "No", 
								function(){
					$$("div[name='reasonRow']").each(function(row) {
						if(row.hasClassName("selectedRow")) {
							var reasonCd 		= row.down("input", 0).value;
							var forDeleteDiv 	= $("forDeleteDiv");
							var deleteContent	= '<input type="hidden" id="delReasonCd'+ reasonCd +'" 	name="delReasonCd"	value="'+ reasonCd +'" />';
							var deleteDiv		= new Element("div");
			
							deleteDiv.setAttribute("id", "delReason"+reasonCd);
							deleteDiv.setStyle("visibility: hidden;");
							deleteDiv.update(deleteContent);
			
							forDeleteDiv.insert({bottom: deleteDiv});
			
							$$("div[name='insReason']").each(function(div) {
								var id = div.getAttribute("id");
								if(id == "insReason"+reasonCd){
									div.remove();
								}
							});

							Effect.Fade(row, {
								duration: .5,
								afterFinish: function () {
									row.remove();
									setReasonInfoForm(null);
									checkTableIfEmpty("reasonRow", "reasonsListDiv");
									checkIfToResizeTable("reasonsList", "reasonRow");
								}
							});					
							changeTag = 1;
						}
				}, "");
				
				});
			}
		}	
			
		 catch(e) {
			showErrorMessage("deleteReason", e);
			//showMessageBox("delete reason: " + e.message);
		}
	}
	
	function saveReasonInfo() {
		new Ajax.Request("GIISLostBidController?action=saveReasonInfo", {
			method: "POST",
			asynchronous: true,
			postBody: changeSingleAndDoubleQuotes(fixTildeProblem(Form.serialize("maintainReasonForm"))),
			onCreate: function() {
				setCursor("wait");
				$("maintainReasonForm").disable();
				disableButton($("btnAddReason"));
				disableButton($("btnDelReason"));
				disableButton($("btnReasonSave"));
				disableButton($("btnReasonCancel"));
				showNotice("Saving, please wait...");
			},
			onComplete: function(response) {
				hideNotice("");
				setCursor("default");
				$("maintainReasonForm").enable();
				enableButton($("btnAddReason"));
				enableButton($("btnDelReason"));	
				enableButton($("btnReasonSave"));
				enableButton($("btnReasonCancel"));
				pActions = pageActions.none;

				if(checkErrorOnResponse(response)) {
					$("forInsertDiv").update("");
					$("forDeleteDiv").update("");
					setReasonInfoForm(null);
					changeTag = 0;
					
					if(pActions == pageActions.reload) {
						showMaintainReasonForm();
					} else if (pActions == pageActions.cancel) {
						showCreateQuotationPage();
					} else {
						showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
						lastAction();
						lastAction = "";
					}
				}
			}
		});
	}

	function showCreateQuotationPage() {
		Effect.Fade("maintainReasonDiv", {
			duration: 0.001,
			beforeFinish: function() {
				Effect.Fade("assuredDiv", {duration: 0.001});
				Effect.Appear("contentsDiv", {duration: 0.001});
				$("quotationMenus").show();
				initializeMenu(); // andrew - 03.03.2011 - to fix menu problem
			}
		});
	}

	$("editDescriptionText").observe("click", function () {
		var exists = checkIfInUse();
		if(exists && $F("btnAddReason") == "Update") {
			$("inputDesc").setAttribute("readonly", "readonly");
			showMessageBox("Unable to update. Selected Reason is used in a Quotation.");
		} else {
			showEditor("inputDesc", 200);
		}
	});

	$("editRemarksText").observe("click", function () {
		showEditor("inputRemarks", 4000);
	});

	$("inputRemarks").observe("keyup", function () {
		limitText(this, 4000);
	});

	$("inputDesc").observe("keyup", function () {
		limitText(this, 200);
	}); 

	function saveAndReloadReason(){
		pAction = pageActions.reload;
		saveReasonInfo();
	}

	function saveAndCancel(){
		pAction = pageActions.cancel;
		saveReasonInfo();
		showCreateQuotationPage();
	}
	changeTag = 0;
	initializeChangeTagBehavior(saveReasonInfo);
	initializeChangeAttribute();
</script>