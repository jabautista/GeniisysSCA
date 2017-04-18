<!--
Created by: Gzelle
Date: 11.23.2012
-->
<div id="copyToAnotherUserDiv" name="copyToAnotherUserDiv">
	<div class="sectionDiv" style="width: 360px; margin-top: 10px; margin-bottom: 10px; margin-left: 6px; margin-right: 5px;">
		<div id="copyToAnotherUserDivForm" name="copyToAnotherUserDivForm" align="center" style="margin-top: 10px; margin-left: 10px; margin-right: 10px; margin-bottom: 10px;">
			<table align="center">
				<tr>
					<td colspan="2" align="center">Copy From</td>
				</tr>
				<tr>
					<td class="rightAligned">User ID</td>
					<td class="leftAligned">
						<div class="required" style="border: 1px solid gray; width: 90px; height: 21px; float: left; margin-right: 2px; margin-top: 2px; margin-left: 3px;">
							<input type="text" class="upper required" id="txtUserIdFrom" name="txtUserIdFrom" style="width: 60px; height: 13px; float: left; border: none; margin-top: 0px;" maxlength="8" lastValidValue=""/>
							<img id="btnSearchUserFrom" alt="Go" name="btnSearchUserFrom" src="/Geniisys/images/misc/searchIcon.png" style="width: 19px; height: 19px; float: right;">
							<input type="checkbox" id="searchUserSw" name="searchUserSw" style="visibility: hidden;">
						</div>
						<input type="hidden" name="hidLastValidFrom" id="hidLastValidFrom" value=""/>
						<input type="hidden" name="hidLastValidTo" id="hidLastValidTo" value=""/>
						<input id="txtUserNameFrom" name="txtUserNameFrom" type="text" style="width: 150px;" value="" readonly="readonly" tabindex="103" lastValidValue=""/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Branch</td>
					<td class="leftAligned">
						<div class="required" style="border: 1px solid gray; width: 90px; height: 21px; float: left; margin-right: 2px; margin-left: 3px;">
							<input type="text" class="upper required" id="txtBranchFrom" name="txtBranchFrom" style="width: 60px; height: 13px; float: left; border: none; margin-top: 0px;" maxlength="2" lastValidValue="" />
							<img id="btnSearchBranchFrom" alt="Go" name="btnSearchBranchFrom" src="/Geniisys/images/misc/searchIcon.png" style="width: 19px; height: 19px; float: right;">
							<input type="checkbox" id="searchBranchSw" name="searchBranchSw" style="visibility: hidden;">
						</div>
						<input type="hidden" name="hidLastValidFromBranch" id="hidLastValidFromBranch" value=""/>
						<input type="hidden" name="hidLastValidToBranch" id="hidLastValidToBranch" value=""/>
						<input id="txtBranchFromName" name="txtBranchFromName" type="text" style="width: 150px; margin-top: 0px;" value="" readonly="readonly" tabindex="103" lastValidValue=""/>
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center">Copy To&nbsp;&nbsp;&nbsp;&nbsp;</td>
				</tr>
				<tr>
					<td class="rightAligned">User ID</td>
					<td class="leftAligned">
						<div class="required" style="border: 1px solid gray; width: 90px; height: 21px; float: left; margin-right: 3px; margin-top: 2px; margin-left: 3px;">
							<input class="upper required" id="txtUserIdTo" name="txtUserIdTo" type="text" style="width: 60px; height: 13px; float: left; border: none; margin-top: 0px;" maxlength="8" lastValidValue=""/> 
							<img id="btnSearchUserTo" alt="Go" name="btnSearchUserTo" src="/Geniisys/images/misc/searchIcon.png" style="width: 19px; height: 19px; float: right;">
						</div>
						<input id="txtUserNameTo" name="txtUserNameTo" type="text" style="width: 150px;" value="" readonly="readonly" tabindex="103" lastValidValue=""/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Branch</td>
					<td class="leftAligned">
						<div id="branchToDiv" class="required" style="border: 1px solid gray; width: 90px; height: 21px; float: left; margin-right: 3px; margin-left: 3px;">
							<input type="text" class="upper required" id="txtBranchTo" name="txtBranchTo" style="width: 60px; height: 13px; float: left; border: none; margin-top: 0px;" maxlength="2" lastValidValue=""/>
							<img id="btnSearchBranchTo" alt="Go" name="btnSearchBranchTo" src="/Geniisys/images/misc/searchIcon.png" style="width: 19px; height: 19px; float: right;">
						</div>
						<input id="txtBranchToName" name="txtBranchToName" type="text" style="width: 150px; margin-top: 0px;" value="" readonly="readonly" tabindex="103" lastValidValue=""/>
					</td>
				</tr>
				<tr>
					<td colspan="2" class="leftAligned">
						<br>
						<input type="checkbox" id="chkPopulateAll" name="chkPopulateAll" style="float: left; margin: 0pt; width: 13px; height: 13px;"/>
						<label for="chkPopulateAll" style="float: left; margin-left: 3px;">Populate All Branches</label>
					</td>
				</tr>
			</table>
			<div style="text-align: center;">
				<input type="button" class="button" style="width: 100px; margin-top: 10px;" id="btnOk" name="btnOk" value="Ok" />
				<input type="button" class="button" style="width: 100px; margin-top: 10px;" id="btnCancelCopy" name="btnCancelCopy" value="Cancel" />
			</div>
		</div>
	</div>
</div>

<script type="text/JavaScript">

	makeInputFieldUpperCase();
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	objGiiss207.resetToLastValidValue = resetToLastValidValue;
	
 	function validateCopyUser(userId) {
		new Ajax.Request(contextPath + "/GIISPostingLimitController", {
			method: "POST",
			parameters: {
				action : "validateCopyUser",
				userId : userId
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (response.responseText == '0') {
					showUserLOV(userId);
				} else if(response.responseText == '1') {
					checkFields();
					$("hidLastValidTo").value = $("txtUserIdTo").value;
					$("hidLastValidFrom").value = $("txtUserIdFrom").value;
					showUserLOV(userId);	//Gzelle 03242014
				} else if(response.responseText.include("Sql")) {
					checkFields();
					showUserLOV(userId);
				}
			}
		});
	}
 	
 	function validateCopyBranch(issCd) {
		new Ajax.Request(contextPath + "/GIISPostingLimitController", {
			method: "POST",
			parameters: {
				action : "validateCopyBranch",
				issCd : issCd
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (response.responseText == '0') {
					showGiiss207BranchLOV(issCd);
				} else if(response.responseText == '1') {
					checkFields();
					$("hidLastValidToBranch").value = $("txtBranchTo").value;
					$("hidLastValidFromBranch").value = $("txtBranchFrom").value;
					showGiiss207BranchLOV(issCd);	//Gzelle 03242014
				} else if (response.responseText.include("Sql")) {
					checkFields();
					showGiiss207BranchLOV(issCd);
				}
			}
		});
	}
 	
 	function saveCopyToAnotherUser(){
 		try {
			new Ajax.Request(contextPath + "/GIISPostingLimitController", {
				method : "POST",
				parameters : {action : "saveCopyToAnotherUser",
							  copyToUser : $F("txtUserIdTo"),
							  copyToBranch : $F("txtBranchTo"),
							  copyFromUser : $F("txtUserIdFrom"),
							  copyFromBranch : $F("txtBranchFrom"),
							  populateAllSw : $("chkPopulateAll").checked ? "Y" : "N"},
				onComplete : function (response){
 					if(checkErrorOnResponse(response)){
						if("SUCCESS" == response.responseText){
							showWaitingMessageBox("Copy finished.", imgMessage.INFO, function() {
								overlayCopyToAnotherUser.close();
								postingLimitTableGrid._refreshList();
							});
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						} 
 					} 
				}
			});
 		} catch (e) {
 			showErrorMessage("saveCopyToAnotherUser", e);
 		} 
 	}
	
	function checkFields() {
		if ($("txtBranchFrom").value == "") {
			disableInputField("txtBranchTo");
			disableSearch("btnSearchBranchTo");
			$("txtBranchTo").clear();
			$("txtBranchTo").setAttribute("lastValidValue", "");
			$("chkPopulateAll").disabled = true;
			$("chkPopulateAll").checked = false;
		} else if ($("txtBranchFrom").value != "") {
			enableInputField("txtBranchTo");
			enableSearch("btnSearchBranchTo");
			$("chkPopulateAll").disabled = false;
		}
		
		if ($("chkPopulateAll").checked == true) {
			disableInputField("txtBranchTo");
			disableSearch("btnSearchBranchTo");
			$("txtBranchTo").clear();
			$("txtBranchToName").clear();
			$("txtBranchTo").setAttribute("lastValidValue", "");
			$("txtBranchToName").setAttribute("lastValidValue", "");
			$("txtBranchTo").removeClassName("required");
			$("branchToDiv").removeClassName("required");
			$("branchToDiv").setStyle({backgroundColor: 'white'});
		}else {
			if ($("txtUserIdTo").value != "") {
				enableInputField("txtBranchTo");
				enableSearch("btnSearchBranchTo");
				$("txtBranchTo").addClassName("required");
				$("branchToDiv").addClassName("required");
				$("branchToDiv").setStyle({backgroundColor: 'cornsilk'});
			}else {
				disableInputField("txtBranchTo");
				disableSearch("btnSearchBranchTo");
				$("txtBranchTo").addClassName("required");
				$("branchToDiv").addClassName("required");
				$("branchToDiv").setStyle({backgroundColor: 'cornsilk'});
			}
			
		}
	}
	
	function validateFields() {
		if(checkAllRequiredFieldsInDiv("copyToAnotherUserDivForm")){
			if ($("txtUserIdFrom").value == "") {
				customShowMessageBox("Copy from user cannot be null.", imgMessage.INFO, "txtUserIdFrom");
			}else if ($("txtUserIdTo").value == "") {
				customShowMessageBox("Copy to user cannot be null.", imgMessage.INFO, "txtUserIdTo");
			} else if ($("txtUserIdFrom").value == $("txtUserIdTo").value && $("txtBranchFrom").value == $("txtBranchTo").value) {
				customShowMessageBox("Cannot copy with the same User and Branch.", imgMessage.INFO, "txtUserIdTo");
			}else {
				saveCopyToAnotherUser();
			}
		}
	}
	
	function showUserLOV(trigger,search) {
		try {
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGiiss207UserLOV",
					search : search,
					page: 1
				},
				title : "List of Users",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "userId",
					title : "User ID",
					width : '120px'
				}, {
					id : "username",
					title : "User Name",
					width : '345px'
				} ],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : search,
				onSelect : function(row) {
					if (row != null || row != undefined) {
						if (trigger == 1) {	//FROM
							$("txtUserIdFrom").value = unescapeHTML2(row.userId);
							$("txtUserIdFrom").setAttribute("lastValidValue", unescapeHTML2(row.userId));
							$("txtUserNameFrom").value = unescapeHTML2(row.username);
							$("txtUserNameFrom").setAttribute("lastValidValue", unescapeHTML2(row.username));
							$("txtBranchFrom").focus();
							$("txtBranchFrom").clear();
							$("txtBranchFromName").clear();
							$("txtBranchFrom").setAttribute("lastValidValue", "");
							$("txtBranchFromName").setAttribute("lastValidValue", "");
							enableInputField("txtBranchFrom");
							enableSearch("btnSearchBranchFrom");
						}else {	
							$("txtUserIdTo").value = unescapeHTML2(row.userId);
							$("txtUserIdTo").setAttribute("lastValidValue", unescapeHTML2(row.userId));
							$("txtUserNameTo").value = unescapeHTML2(row.username);
							$("txtUserNameTo").setAttribute("lastValidValue", unescapeHTML2(row.username));
							$("txtBranchTo").focus();
							$("txtBranchTo").clear();
							$("txtBranchToName").clear();
							$("txtBranchTo").setAttribute("lastValidValue", "");
							$("txtBranchToName").setAttribute("lastValidValue", "");
							enableInputField("txtBranchTo");
							enableSearch("btnSearchBranchTo");
						}
					}
				},
				onCancel : function() {
					if (trigger == 1) { //FROM
						$("txtUserIdFrom").focus();
						$("txtUserIdFrom").value = $("txtUserIdFrom").readAttribute("lastValidValue");
						$("txtUserNameFrom").value = $("txtUserNameFrom").readAttribute("lastValidValue");
					}else {
						$("txtUserIdTo").focus();
						$("txtUserIdTo").value = $("txtUserIdTo").readAttribute("lastValidValue");
						$("txtUserNameTo").value = $("txtUserNameTo").readAttribute("lastValidValue");
					}
				},
				onUndefinedRow : function() {
					if (trigger == 1) { //FROM
						$("txtUserIdFrom").value = $("txtUserIdFrom").readAttribute("lastValidValue");
						$("txtUserNameFrom").value = $("txtUserNameFrom").readAttribute("lastValidValue");
						customShowMessageBox("No record selected.", imgMessage.INFO, "txtUserIdFrom");
					}else {
						$("txtUserIdTo").value = $("txtUserIdTo").readAttribute("lastValidValue");
						$("txtUserNameTo").value = $("txtUserNameTo").readAttribute("lastValidValue");
						customShowMessageBox("No record selected.", imgMessage.INFO, "txtUserIdTo");
					}
				}
			});
		} catch (e) {
			showErrorMessage("showUserLOV", e);
		}
	}
	
	function showBranchLOV(trigger,search) {
		try {
			var userParam = (trigger == 1 ? $F("txtUserIdFrom") : $F("txtUserIdTo"));
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGiiss207IssueSourceLOV",
					userId : userParam,
					search : search,
					page: 1
				},
				title : "List of Branches",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "issCd",
					title : "Branch Code",
					width : '120px'
				}, {
					id : "issName",
					title : "Branch Name",
					width : '345px'
				} ],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : search,
				onSelect : function(row) {
					if (row != null || row != undefined) {
						if (trigger == 1) {
							$("txtBranchFrom").value = unescapeHTML2(row.issCd);
							$("txtBranchFrom").setAttribute("lastValidValue", unescapeHTML2(row.issCd));
							$("txtBranchFromName").value = unescapeHTML2(row.issName);
							$("txtBranchFromName").setAttribute("lastValidValue", unescapeHTML2(row.issName));
							$("txtUserIdTo").focus();
						}else {
							$("txtBranchTo").value = unescapeHTML2(row.issCd);
							$("txtBranchTo").setAttribute("lastValidValue", unescapeHTML2(row.issCd));
							$("txtBranchToName").value = unescapeHTML2(row.issName);
							$("txtBranchToName").setAttribute("lastValidValue", unescapeHTML2(row.issName));
						}
					}
				},
				onCancel : function() {
					if (trigger == 1) {
						$("txtBranchFrom").focus();
						$("txtBranchFrom").value = $("txtBranchFrom").readAttribute("lastValidValue");
						$("txtBranchFromName").value = $("txtBranchFromName").readAttribute("lastValidValue");
					}else {
						$("txtBranchTo").focus();
						$("txtBranchTo").value = $("txtBranchTo").readAttribute("lastValidValue");
						$("txtBranchToName").value = $("txtBranchToName").readAttribute("lastValidValue");
					}
				},
				onUndefinedRow : function() {
					if (trigger == 1) {
						$("txtBranchFrom").value = $("txtBranchFrom").readAttribute("lastValidValue");
						$("txtBranchFromName").value = $("txtBranchFromName").readAttribute("lastValidValue");
						customShowMessageBox("No record selected.", imgMessage.INFO, "txtBranchFrom");
					}else {
						$("txtBranchTo").value = $("txtBranchTo").readAttribute("lastValidValue");
						$("txtBranchToName").value = $("txtBranchToName").readAttribute("lastValidValue");
						customShowMessageBox("No record selected.", imgMessage.INFO, "txtBranchTo");
					}
				}
			});
		} catch (e) {
			showErrorMessage("showBranchLOV", e);
		}
	}
	
// 	function showLOV(searchBtn, searchSw, txtField, status, LOV){
// 		objGiiss207.LOV = LOV;
// 		searchBtn.observe("click", function() {
// 			searchSw.checked = status;
// 			LOV(txtField.value);
// 		});
// 	}
	
// 	function validateTxt(txtField, validation) {
// 		objGiiss207.validation = validation;
// 		txtField.observe("change", function() {
// 			if (txtField.value != "") {
// 				validation(txtField.value);
// 			}
// 		});
// 	}
	
	function resetToLastValidValue(txtFieldTo, lastValidValueTo, txtFieldFrom, lastValidValueFrom) {
		txtFieldTo.value = lastValidValueTo.value;
		txtFieldFrom.value = lastValidValueFrom.value;
	}

	$("btnSearchUserFrom").observe("click", function() {
		showUserLOV(1, "%");
	});

	$("txtUserIdFrom").observe("change", function() {
		if (this.value != "") {
			showUserLOV(1, $("txtUserIdFrom").value);
		} else {
			checkFields();
			$("txtUserIdFrom").value = "";
			$("txtUserIdFrom").setAttribute("lastValidValue", "");
			$("txtUserNameFrom").value = "";
			$("txtUserNameFrom").setAttribute("lastValidValue", "");
			$("txtBranchFrom").value = "";
			$("txtBranchFrom").setAttribute("lastValidValue", "");
			$("txtBranchFromName").value = "";
			$("txtBranchFromName").setAttribute("lastValidValue", "");
			disableSearch("btnSearchBranchFrom");
			disableInputField("txtBranchFrom");
			$("txtUserIdFrom").focus();
		}
	});	

	$("btnSearchUserTo").observe("click", function() {
		showUserLOV(2, "%");
	});

	$("txtUserIdTo").observe("change", function() {
		if (this.value != "") {
			showUserLOV(2, $("txtUserIdTo").value);
		} else {
			checkFields();
			$("txtUserIdTo").value = "";
			$("txtUserIdTo").setAttribute("lastValidValue", "");
			$("txtUserNameTo").value = "";
			$("txtUserNameTo").setAttribute("lastValidValue", "");
			$("txtBranchTo").value = "";
			$("txtBranchTo").setAttribute("lastValidValue", "");
			$("txtBranchToName").value = "";
			$("txtBranchToName").setAttribute("lastValidValue", "");
			disableSearch("btnSearchBranchTo");
			disableInputField("txtBranchTo");
			$("txtUserIdTo").focus();
		}
	});	
	
	$("btnSearchBranchFrom").observe("click", function() {
		showBranchLOV(1,"%");
	});

	$("txtBranchFrom").observe("change", function() {
		if (this.value != "") {
			showBranchLOV(1,$("txtBranchFrom").value);
		} else {
			checkFields();
			$("txtBranchFrom").value = "";
			$("txtBranchFrom").setAttribute("lastValidValue", "");
			$("txtBranchFromName").value = "";
			$("txtBranchFromName").setAttribute("lastValidValue", "");
		}
	});
	
	$("btnSearchBranchTo").observe("click", function() {
		showBranchLOV(2,"%");
	});

	$("txtBranchTo").observe("change", function() {
		if (this.value != "") {
			showBranchLOV(2,$("txtBranchTo").value);
		} else {
			checkFields();
			$("txtBranchTo").value = "";
			$("txtBranchTo").setAttribute("lastValidValue", "");
			$("txtBranchToName").value = "";
			$("txtBranchToName").setAttribute("lastValidValue", "");
		}
	});
	
	$("chkPopulateAll").observe("change", function() {
		checkFields();
	});
	
	$("btnOk").observe("click", validateFields);
	$("txtUserIdFrom").value = objGiiss207.userId;
	$("txtUserNameFrom").value = objGiiss207.userName;
	$("txtUserIdFrom").setAttribute("lastValidValue", $F("txtUserIdFrom"));
	$("txtUserNameFrom").setAttribute("lastValidValue", $F("txtUserNameFrom"));
	$("txtBranchFrom").value = objGiiss207.issCd;
	$("txtBranchFromName").value = objGiiss207.issName;
	$("txtBranchFrom").setAttribute("lastValidValue", $F("txtBranchFrom"));
	$("txtBranchFromName").setAttribute("lastValidValue", $F("txtBranchFromName"));
	$("txtUserIdTo").focus();
	disableSearch("btnSearchBranchTo");
	$("btnCancelCopy").observe("click", function() {
		overlayCopyToAnotherUser.close();
	});

</script>