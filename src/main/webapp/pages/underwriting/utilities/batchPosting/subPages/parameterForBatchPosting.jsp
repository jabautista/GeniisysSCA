<div style="padding-top: 10px;">
	<div id="lovDiv" class="sectionDiv" style="width: 430px; height: 150px; padding-top: 15px; margin-bottom: 10px; margin-left: 5px;" >
		<div  style="float: left; margin-left: 53px;">
			<table align="left">
				<tr>
					<td class="rightAligned" style="padding-right: 10px;">Subline</td>
					<td class="leftAligned" style="padding-top: 0px;">
						<span class="lovSpan"  style="float: left; width: 95px; margin-right: 2px; margin-top: 2px; height: 21px;">
							<input class="" type="text" id="txtSublineCd" name="Subline Cd" style="width: 70px; float: left; border: none; height: 15px; margin: 0;" maxlength="7" tabindex="301" lastValidValue="" ignoreDelKey="1"/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchSubline" name="imgSearchSubline" alt="Go" style="float: right;" tabindex="302"/>
						</span>
						<input id="txtSublineName" name="Subline Name" type="text" style="float: left; width: 190px; height: 15px; margin-top: 2px;" lastValidValue="" readonly="readonly" tabindex="303" ignoreDelKey="1"/>
					</td>	
				</tr>
			</table>
		</div>
		<div  style="float: left; margin-left: 10px;">
			<table align="left"">
				<tr>
					<td class="rightAligned" style="padding-right: 10px;">Issuing Source</td>
					<td class="leftAligned" style="padding-top: 0px;">
						<span class="lovSpan"  style="float: left; width: 95px; margin-right: 2px; margin-top: 2px; height: 21px;">
							<input class="" type="text" id="txtIssCd" name="Issource Cd" style="width: 70px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="101" lastValidValue="" ignoreDelKey="1"/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchIss" name="imgSearchIss" alt="Go" style="float: right;" tabindex="304"/>
						</span>
						<input id="txtIssName" name="Issource Name" type="text" style="float: left; width: 190px; height: 15px; margin-top: 2px;" lastValidValue="" readonly="readonly" tabindex="303" ignoreDelKey="1"/>
					</td>	
				</tr>
			</table>
		</div>	
		<%-- <div  style="float: left; width: 100%;"> removed by kenneth L. 02.17.2014
			<table align="left">
				<tr>
					<td class="rightAligned" style="padding-right: 10px; padding-left: 61px;">User ID</td>
					<td class="leftAligned" style="padding-top: 0px;" colspan="3">
						<div style="height: 20px;">
							<div id="assignDiv" style="border: 1px solid gray; width: 195px; height: 20px; margin:0 5px 0 0;">
								<input id="txtUserId" name="User ID" type="text" maxlength="8" style="border: none; float: left; width: 170px; height: 13px; margin: 0px;" value="" tabindex="305"/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchUser" name="imgSearchUser" alt="Go" style="float: right;" tabindex="306"/>
							</div>
						</div>						
					</td>
			</table>
		</div> --%>
		<div style="float: left; margin-top: 10px; margin-left: 30px; margin-bottom: 10px;">
			<fieldset style="width: 350px;">
				<legend>Par Type</legend>
				<table align="left">
					<tr>	
						<td style="padding-top: 10px; padding-bottom: 10px; padding-left: 25px;">
							<input type="radio" id="rdoPolicy" name="rdoParType" checked="checked" value="P"/>
						</td>
						<td>
							<label for="rdoPolicy" tabindex="401">Policy</label>
						</td>
						<td style="padding-left: 50px;">
							<input type="radio" id="rdoEndt" name="rdoParType" value="E"/>
						</td>
						<td>
							<label for="rdoEndt" tabindex="402">Endorsement</label>
						</td>
						<td style="padding-left: 50px;">
							<input type="radio" id="rdoAll" name="rdoParType" value=""/>
						</td>
						<td>
							<label for="rdoAll" tabindex="403">All</label>
						</td>				
					</tr>
				</table>
			</fieldset>			
		</div>
	</div>

	<div style="margin-top: 5px; float: left; margin-left: 140px;">
		<input id="btnOk" type="button" class="button" value="Ok" tabindex="501"/>
		<input id="btnCancel" type="button" class="button" value="Cancel" tabindex="502"/>
	</div>
</div>

<script type="text/javascript">
	initializeAll();
	$("rdoAll").checked = true;
	//$("txtIssCd").value = '${issCd}'; commented by kenneth L. 02.10.2014
	$("txtIssName").value = "ALL ISSUING SOURCE"; //added by kenneth L. 02.10.2014
	$("txtIssName").setAttribute("lastValidValue","ALL ISSUING SOURCE");
	$("txtSublineName").value = "ALL SUBLINES";
	$("txtSublineName").setAttribute("lastValidValue","ALL SUBLINES");
	//$("txtUserId").value = '${appUser}';
	paramUserId = '${appUser}';
	paramIssCd = "";
	paramParType = "";
	paramSublineCd = "";
	
	function showSublineLOV(isIconClicked) {
		try {
			var searchString = isIconClicked ? "%" : ($F("txtSublineCd").trim() == "" ? "%" : $F("txtSublineCd"));
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getSublineForBatchPostingLOV",
					search : searchString,
					lineCd : objUWGlobal.lineCd
				},
				width : 410,
				height : 386,
				autoSelectOneRecord : true,
				filterText : searchString,
				title : "List of Sublines",
				columnModel : [ {
					id : "sublineCd",
					title : "Subline Code",
					width : '80px'
				}, {
					id : "sublineName",
					title : "Subline Name",
					width : '310px'
				} ],
				draggable : true,
				onSelect : function(row) {
					$("txtSublineCd").value = unescapeHTML2(row.sublineCd);
					$("txtSublineName").value = unescapeHTML2(row.sublineName);
					$("txtSublineCd").setAttribute("lastValidValue", $F("txtSublineCd"));
					$("txtSublineName").setAttribute("lastValidValue", $F("txtSublineName"));
					paramSublineCd = row.sublineCd;
				},
				onUndefinedRow : function() {
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtSublineCd");
					$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
					$("txtSublineName").value = $("txtSublineName").readAttribute("lastValidValue");
				},
				onCancel : function() {
					$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
					$("txtSublineName").value = $("txtSublineName").readAttribute("lastValidValue");
					$("txtSublineCd").focus();
				}
			});
		} catch (e) {
			showErrorMessage("showSublineLOV", e);
		}
	}

	function showIssLOV(isIconClicked) {
		try {
			var searchString = isIconClicked ? "%" : ($F("txtIssCd").trim() == "" ? "%" : $F("txtIssCd"));
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getIssForBatchPostingLOV",
					search : searchString,
					lineCd : objUWGlobal.lineCd
				},
				width : 410,
				height : 386,
				autoSelectOneRecord : true,
				filterText : searchString,
				title : "List of Issuing Source",
				columnModel : [ {
					id : "issCd",
					title : "Code",
					width : '80px'
				}, {
					id : "issName",
					title : "Description",
					width : '310px'
				} ],
				draggable : true,
				onSelect : function(row) {
					$("txtIssCd").value = unescapeHTML2(row.issCd);
					$("txtIssName").value = unescapeHTML2(row.issName);
					$("txtIssCd").setAttribute("lastValidValue", $F("txtIssCd"));
					$("txtIssName").setAttribute("lastValidValue", $F("txtIssName"));
					paramIssCd = row.issCd;
				},
				onUndefinedRow : function() {
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtIssCd");
					$("txtIssCd").value = $("txtIssCd").readAttribute("lastValidValue");
					$("txtIssName").value = $("txtIssName").readAttribute("lastValidValue");
				},
				onCancel : function() {
					$("txtIssCd").value = $("txtIssCd").readAttribute("lastValidValue");
					$("txtIssName").value = $("txtIssName").readAttribute("lastValidValue");
					$("txtIssCd").focus();
				}
			});
		} catch (e) {
			showErrorMessage("showIssLOV", e);
		}
	}

	/* function showUserLOV() {
		try {
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getUserForBatchPostingLOV",
					search : $F("txtUserId")
				},
				width : 410,
				height : 386,
				autoSelectOneRecord : true,
				filterText : $F("txtUserId"),
				title : "Valid values for User ID",
				columnModel : [ {
					id : "userId",
					title : "User ID",
					width : '80px'
				}, {
					id : "userName",
					title : "User Name",
					width : '310px'
				} ],
				draggable : true,
				onSelect : function(row) {
					$("txtUserId").value = row.userId;
					paramUserId = row.userId;
				},
				onUndefinedRow : function() {
					showMessageBox("No record selected.", imgMessage.INFO);
				}
			});
		} catch (e) {
			showErrorMessage("showParameterUserLOV", e);
		}
	} */

	function checkLov(action, cd, func, label) {
		var output = validateTextFieldLOV("/UnderwritingLOVController?action=" + action + "&search=" + $(cd).value + "&lineCd=" + objUWGlobal.lineCd , $(cd).value, "Searching, please wait...");
		if (output == 2) {
			func();
		} else if (output == 0) {
			$(cd).clear();
			customShowMessageBox($(cd).getAttribute("name") + " does not exist.", "I", cd);
		} else {
			func();
		}
	}
	
	function checkUser() {
		//if ($F("txtUserId") == "" || $F("txtUserId") == null) {
		if (paramUserId == "" || paramUserId == null) {
			showConfirmBox("Post All PAR?",
					"These will POST all PARs that are ready for posting. Do you want to continue?",
					"Yes", "No", function() {
						paramUserId = "";
						tagByParameter = true;
						tempArrayForUntaggedRecords = [];
						recordsForPostingManually = [];
						batchPosting.getParByParameter();
						batchPosting.tagRecordsForPosting();
					}, "", "");
		}else {
			tagByParameter = true;
			tempArrayForUntaggedRecords = [];
			recordsForPostingManually = [];
			batchPosting.getParByParameter();
			batchPosting.tagRecordsForPosting();
		}
	}

	function resetParameters() {
		paramSublineCd = "";
		paramIssCd     = "";
		paramUserId    = "";
		paramParType   = "";
	}
	
	$("txtSublineCd").observe("change", function() {
		if (this.value != "") {
			showSublineLOV(false);
		} else {
			$("txtSublineName").value = "ALL SUBLINES";
			$("txtSublineName").setAttribute("lastValidValue", "ALL SUBLINES");
			$("txtSublineCd").value = "";
			$("txtSublineCd").setAttribute("lastValidValue", "");
			paramSublineCd = "";
		}
	});
	
	/* $("txtSublineCd").observe("change", function() { replaced by kenenth L. 02.10.2014
		if ($("txtSublineCd").value != "") {
			checkLov("getSublineForBatchPostingLOV", "txtSublineCd", showSublineLOV);	
		}
	}); */

	$("txtIssCd").observe("change", function() {
		if (this.value != "") {
			showIssLOV(false);
		} else {
			$("txtIssName").value = "ALL ISSUING SOURCE";
			$("txtIssName").setAttribute("lastValidValue", "ALL ISSUING SOURCE");
			$("txtIssCd").value = "";
			$("txtIssCd").setAttribute("lastValidValue", "");
			paramIssCd = "";
		}
	});
	
	/* $("txtIssCd").observe("change", function() { replaced by kenenth L. 02.10.2014
		if ($("txtIssCd").value != "") {
			checkLov("getIssForBatchPostingLOV", "txtIssCd", showIssLOV);
		}
	}); */
	
	/* $("txtUserId").observe("change", function() {
		if ($("txtUserId").value != "") {
			checkLov("getUserForBatchPostingLOV", "txtUserId", showUserLOV);	
		}
	}); */
	
	$("imgSearchSubline").observe("click", function() {
		showSublineLOV(true);
	});
	
	/* $("imgSearchSubline").observe("click", function() {replaced by kenenth L. 02.10.2014
		showSublineLOV();
	}); */
	
	$("imgSearchIss").observe("click", function() {
		showIssLOV(true);
	});
	
	//$("imgSearchIss").observe("click", showIssLOV); replaced by kenenth L. 02.10.2014
	
	//$("imgSearchUser").observe("click", showUserLOV);
	
	$("btnOk").observe("click", function() {
		checkUser();
		overlayParameter.close();
	});
	
	$("btnCancel").observe("click", function() {
		overlayParameter.close();
		resetParameters();
	});
	
	$$("input[name='rdoParType']").each(function(radio) {
		radio.observe("click", function() {
			paramParType = radio.value;
		});
	});
	
	$("txtSublineCd").focus();


</script>