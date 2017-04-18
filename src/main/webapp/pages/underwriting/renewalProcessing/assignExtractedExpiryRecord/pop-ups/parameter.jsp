<div style="padding-top: 10px;">
<div id="radioInputDiv" class="sectionDiv" style="width: 545px; height: 80px;" align="center">
	<table align="left">
		<tr>	
			<td style="padding-top: 10px; padding-bottom: 10px; padding-left: 101px;">
				<input type="radio" id="rdoByExpiry" name="rdoPer" checked="checked" value="BYEXPIRY"/>
			</td>
			<td>
				<label for="rdoByExpiry" tabindex="301">by Expiry date</label>
			</td>
			<td style="padding-left: 134px;">
				<input type="radio" id="rdoByExtract" name="rdoPer" value="BYEXTRACT"/>
			</td>
			<td>
				<label for="rdoByExtract" tabindex="302">by Extract Date</label>
			</td>
		</tr>
	</table>
	<table align="left">
		<tr>
			<td class="leftAligned" style="padding-right: 10px; padding-left: 35px;">Date From</td>
			<td>
				<div id="fromDateDiv" style="float: left; border: 1px solid gray; width: 145px; height: 20px;">
					<input id="txtFromDate" name="fromTo" readonly="readonly" type="text" class="leftAligned date" maxlength="10" style="border: none; float: left; width: 120px; height: 13px; margin: 0px;" value="" tabindex="303"/>
					<img id="imgFromDate" alt="imgFromDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtFromDate'),this, null);" tabindex="304"/>
				</div>
			</td>
			<td class="leftAligned" style="padding-right: 10px; padding-left: 37px; ">Date To</td>
			<td>
				<div id="fromDateDiv" style="float: left; border: 1px solid gray; width: 145px; height: 20px;">
					<input id="txtToDate" name="fromTo" readonly="readonly" type="text" class="leftAligned date" maxlength="10" style="border: none; float: left; width: 120px; height: 13px; margin: 0px;" value="" tabindex="305"/>
					<img id="imgToDate" alt="imgToDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtToDate'),this, null);"  tabindex="306"/>
				</div>
			</td>
		</tr>
	</table>
	</div>
	
	<div id="lovDiv" class="sectionDiv" style="width: 545px; height: 145px; padding-top: 15px; margin-bottom: 10px;" >
		<table align="left">
			<tr>
				<td class="rightAligned" style="padding-right: 10px; padding-left: 38px;">Line Code</td>
				<td style="padding-top: 0px;">
					<div style="height: 20px;">
						<div id="lineCdDiv" style="border: 1px solid gray; width: 90px; height: 20px; margin:0 5px 0 0;">
							<input id="txtLineCd" name="txtLineCd" type="text" maxlength="2" class="upper" style="border: none; float: left; width: 60px; height: 13px; margin: 0px;" value="" lastValidValue="" tabindex="307"/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCdLOV" name="searchLineCdLOV" alt="Go" style="float: right;"  tabindex="308"/>
						</div>
						
					</div>						
				</td>	
				<td>
					<%-- <div id="lineNameDiv" style="border: 1px solid gray; width: 288px; height: 20px; margin:0 5px 0 0;">
						<input id="txtLineName" name="txtLineName" type="text" maxlength="20" class="upper" style="border: none; float: left; width: 258px; height: 13px; margin: 0px;" value="" tabindex="309"/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineNameLOV" name="searchLineNameLOV" alt="Go" style="float: right;" tabindex="310"/>
					</div> --%>
					<input id="txtLineName" name="txtLineName" type="text" maxlength="20" class="upper" readonly="readonly" style="float: left; width: 282px; height: 13px; margin: 0px;" value="" lastValidValue="" tabindex="309"/>
				</td>
			</tr>
		</table>
		<table align="left">
			<tr>
				<td class="rightAligned" style="padding-right: 10px; padding-left: 19px;">Subline Code</td>
				<td style="padding-top: 0px;">
					<div style="height: 20px;">
						<div id="sublineCdDiv" style="border: 1px solid gray; width: 90px; height: 20px; margin:0 5px 0 0;">
							<input id="txtSublineCd" name="txtSublineCd" type="text" maxlength="7" class="upper" style="border: none; float: left; width: 60px; height: 13px; margin: 0px;" value="" lastValidValue="" tabindex="311"/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSublineCdLOV" name="searchSublineCdLOV" alt="Go" style="float: right;" tabindex="312"/>
						</div>
					</div>						
				</td>	
				<td>
					<%-- <div id="sublineNameDiv" style="border: 1px solid gray; width: 288px; height: 20px; margin:0 5px 0 0;">
						<input id="txtSublineName" name="txtSublineName" type="text" maxlength="30" class="upper" style="border: none; float: left; width: 258px; height: 13px; margin: 0px;" value="" tabindex="313"/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSublineNameLOV" name="searchSublineNameLOV" alt="Go" style="float: right;" tabindex="314"/>
					</div> --%>
					<input id="txtSublineName" name="txtSublineName" type="text" maxlength="30" class="upper" readonly="readonly" style="float: left; width: 282px; height: 13px; margin: 0px;" value="" lastValidValue="" tabindex="313"/>
				</td>
			</tr>
		</table>
		<table align="left">
			<tr>
				<td class="rightAligned" style="padding-right: 10px; padding-left: 20px;">Issue Source</td>
				<td style="padding-top: 0px;">
					<div style="height: 20px;">
						<div id="issCdDiv" style="border: 1px solid gray; width: 90px; height: 20px; margin:0 5px 0 0;">
							<input id="txtIssCd" name="txtIssCd" type="text" maxlength="2" class="upper" style="border: none; float: left; width: 60px; height: 13px; margin: 0px;" value="" lastValidValue="" tabindex="315"/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIssCdLOV" name="searchIssCdLOV" alt="Go" style="float: right;" tabindex="316"/>
						</div>
					</div>						
				</td>	
				<td>
					<%-- <div id="issNameDiv" style="border: 1px solid gray; width: 288px; height: 20px; margin:0 5px 0 0;">
						<input id="txtIssName" name="txtIssName" type="text" maxlength="20" class="upper" style="border: none; float: left; width: 258px; height: 13px; margin: 0px;" value="" tabindex="317"/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIssNameLOV" name="searchIssNameLOV" alt="Go" style="float: right;" tabindex="318"/>
					</div> --%>
					<input id="txtIssName" name="txtIssName" type="text" maxlength="20" class="upper" readonly="readonly" style="float: left; width: 282px; height: 13px; margin: 0px;" value="" lastValidValue="" tabindex="317"/>
				</td>
			</tr>
		</table>
		<table align="left">	<!-- Gzelle 07092015 SR4744 UW-SPECS-2015-065 -->
			<tr>
				<td class="rightAligned" style="padding-right: 9px; padding-left: 0px;">Crediting Branch</td>
				<td style="padding-top: 0px;">
					<div style="height: 20px;">
						<div id="credBranchDiv" style="border: 1px solid gray; width: 90px; height: 20px; margin:0 5px 0 0;">
							<input id="txtCredBranchCd" name="txtCredBranchCd" type="text" maxlength="2" class="upper" style="border: none; float: left; width: 60px; height: 13px; margin: 0px;" value="" lastValidValue="" tabindex="318"/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchCredBranchLOV" name="searchCredBranchLOV" alt="Go" style="float: right;" tabindex="319"/>
						</div>
					</div>						
				</td>	
				<td>
					<input id="txtCredBranchName" name="txtCredBranchName" type="text" maxlength="20" class="upper" readonly="readonly" style="float: left; width: 282px; height: 13px; margin: 0px;" value="" lastValidValue="" tabindex="320"/>
				</td>
			</tr>
		</table>				<!-- Gzelle 07092015 SR4744 UW-SPECS-2015-065 -->
		<table align="left">
			<tr>
				<td class="rightAligned" style="padding-right: 10px; padding-left: 20px;">Intermediary</td>
				<td style="padding-top: 0px;">
					<div style="height: 20px;">
						<div id="intmNoDiv" style="border: 1px solid gray; width: 90px; height: 20px; margin:0 5px 0 0;">
							<input id="txtIntmNo" name="txtIntmNo" type="text" maxlength="12" class="rightAligned integerNoNegativeUnformattedNoComma" style="border: none; float: left; width: 60px; height: 13px; margin: 0px;" value="" lastValidValue="" tabindex="321"/>	<!-- Gzelle 07092015 modified tabindex -->
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIntmNoLOV" name="searchIntmNoLOV" alt="Go" style="float: right;" tabindex="322"/>	<!-- Gzelle 07092015 modified tabindex -->
						</div>
					</div>						
				</td>	
				<td>
					<%-- <div id="intmNameDiv" style="border: 1px solid gray; width: 288px; height: 20px; margin:0 5px 0 0;">
						<input id="txtIntmName" name="txtIntmName" type="text" maxlength="240" class="upper" style="border: none; float: left; width: 258px; height: 13px; margin: 0px;" value="" tabindex="321"/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIntmNameLOV" name="searchIntmNameLOV" alt="Go" style="float: right;" tabindex="322"/>
					</div> --%>
					<input id="txtIntmName" name="txtIntmName" type="text" maxlength="240" class="upper" readonly="readonly" style="float: left; width: 282px; height: 13px; margin: 0px;" value="" lastValidValue=""  tabindex="323"/>		<!-- Gzelle 07092015 modified tabindex -->
				</td>
			</tr>
		</table>
		<!-- <table align="left">
			<tr>
				<td class="rightAligned" style="padding-right: 10px; padding-left: 41px;">Assign To</td>
				<td style="padding-top: 0px;" colspan="3">
					<div style="height: 20px;">
						<div id="assignDiv" style="border: 1px solid gray; width: 150px; height: 20px; margin:0 5px 0 0;">
							<input id="txtAssignTo" name="txtAssignTo" type="text" maxlength="8" class="upper" style="border: none; float: left; width: 125px; height: 13px; margin: 0px;" value="" lastValidValue=""  tabindex="323"/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchAssignToLOV" name="searchAssignToLOV" alt="Go" style="float: right;" tabindex="324"/>
						</div>
					</div>						
				</td>
		</table>	commented out by Gzelle 07092015 SR4744 UW-SPECS-2015-065 -->
</div>
<div align="center" style="height: 10px;">
	<input id="btnOk" type="button" class="button" value="Ok" tabindex="325"/>
	<input id="btnCancel" type="button" class="button" value="Cancel" tabindex="326"/>
</div>
</div>

<script type="text/javascript">
	initializeAll();
	makeInputFieldUpperCase();
	$("txtLineCd").focus();
	observeBackSpaceOnDate("txtToDate");
	observeBackSpaceOnDate("txtFromDate");
	batchParams = new Object();
	resetParams();
	result = "";
	disableSearch("searchSublineCdLOV");	//Gzelle 08052015 SR4744
	disableInputField("txtSublineCd");		//Gzelle 08052015 SR4744
	$("btnCancel").observe("click", function() {
		resetParams();
		overlayParameters.close();
	});

	function resetParams() {
		fromDate = "";
		toDate = "";
		lineCode = "";
		sublineCode = "";
		issueSource = "";
		creditingBranch = "";	//Gzelle 07092015 SR4744 UW-SPECS-2015-065
		intmNumber = "";
		assignToUser = "";
		expiryExtract = "BYEXPIRY";
	}

	$$("input[name='rdoPer']").each(function(btn) {
		btn.observe("click", function() {
			expiryExtract = $F(btn);
		});
	});

	function showLineLOV(isIconClicked) {
		try {
			var searchString = isIconClicked ? "%" : ($F("txtLineCd").trim() == "" ? "%" : $F("txtLineCd"));

			LOV.show({
				controller : "UWRenewalProcessingLOVController",	//Gzelle 09162015 SR4744
				urlParameters : {
					action : "getGiexs008LineLov",
					search : searchString + "%",
					issCd  : $F("txtIssCd"),	//Gzelle 09142015 SR4744
					page : 1
				},
				title : "List of Lines",
				width : 410,
				height : 386,
				columnModel : [ {
					id : "lineCd",
					title : "Line Cd",
					width : '80px'
				}, {
					id : "lineName",
					title : "Line Name",
					width : '310px'
				} ],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : escapeHTML2(searchString),
				onSelect : function(row) {
					if (row != null || row != undefined) {
						$("txtLineCd").value = row.lineCd;
						$("txtLineCd").setAttribute("lastValidValue", row.lineCd);
						$("txtLineName").value = unescapeHTML2(row.lineName);
						$("txtLineName").setAttribute("lastValidValue", unescapeHTML2(row.lineName));
						lineCode = $("txtLineCd").readAttribute("lastValidValue");
						enableSearch("searchSublineCdLOV");	//Gzelle 08052015 SR4744
						enableInputField("txtSublineCd");	//Gzelle 08052015 SR4744
					}
				},
				onCancel : function() {
					$("txtLineCd").focus();
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
					$("txtLineName").value = $("txtLineName").readAttribute("lastValidValue");
					lineCode = $("txtLineCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function() {
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
					$("txtLineName").value = $("txtLineName").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtLineCd");
					lineCode = $("txtLineCd").readAttribute("lastValidValue");
				}
			});
		} catch (e) {
			showErrorMessage("showLineLOV", e);
		}
	}
	
	$("searchLineCdLOV").observe("click", function() {
		showLineLOV(true);
	});

	$("txtLineCd").observe("change", function() {
		if (this.value != "") {
			showLineLOV(false);
		} else {
			$("txtLineCd").value = "";
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtLineName").value = "";
			$("txtLineName").setAttribute("lastValidValue", "");
			lineCode = "";
			disableSearch("searchSublineCdLOV");					//start Gzelle 08052015 SR4744
			disableInputField("txtSublineCd");		
			$("txtSublineCd").value = "";
			$("txtSublineCd").setAttribute("lastValidValue", "");
			$("txtSublineName").value = "";
			$("txtSublineName").setAttribute("lastValidValue", "");	//end Gzelle 08052015 SR4744
		}
	});
	
	//Line LOV
	/* function showLineLOV(lineCd) {
		try {
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGiexs008LineLov",
					search : lineCd,
					issCd : $F("txtIssCd")
				},
				width : 410,
				height : 386,
				autoSelectOneRecord : true,
				filterText : lineCd,
				title : "List of Lines",
				columnModel : [ {
					id : "lineCd",
					title : "Line Cd",
					width : '80px'
				}, {
					id : "lineName",
					title : "Line Name",
					width : '310px'
				} ],
				draggable : true,
				onSelect : function(row) {
					$("txtLineCd").value = unescapeHTML2(row.lineCd);
					$("txtLineName").value = unescapeHTML2(row.lineName);
					lineCode = row.lineCd;
				},
				onUndefinedRow : function() {
					showMessageBox("No record selected.", imgMessage.INFO);
				}
			});
		} catch (e) {
			showErrorMessage("showLineLOV", e);
		}
	} */

	function showSublineLOV(isIconClicked) {
		try {
			var searchString = isIconClicked ? "%" : ($F("txtSublineCd").trim() == "" ? "%" : $F("txtSublineCd"));

			LOV.show({
				controller : "UWRenewalProcessingLOVController", //Gzelle 09162015 SR4744
				urlParameters : {
					action : "getGiexs008SublineLov",
					search : searchString + "%",
					lineCd : $F("txtLineCd"),
					page : 1
				},
				title : "List of Sublines",
				width : 410,
				height : 386,
				columnModel : [ {
					id : "sublineCd",
					title : "Subline Cd",
					width : '80px'
				}, {
					id : "sublineName",
					title : "Subline Name",
					width : '310px'
				} ],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : escapeHTML2(searchString),
				onSelect : function(row) {
					/* if (row != null || row != undefined) {
						$("txtSublineCd").value = row.sublineCd;
						$("txtSublineCd").setAttribute("lastValidValue", row.sublineCd);
						$("txtSublineName").value = unescapeHTML2(row.sublineName);
						$("txtSublineName").setAttribute("lastValidValue", unescapeHTML2(row.sublineName));
					} */
					new Ajax.Request(contextPath + "/GIEXExpiriesVController?", {
						parameters : {
							action : "checkSubline",
							lineCd : $F("txtLineCd"),
							sublineCd : row.sublineCd
						},
						asynchronous : true,
						evalScripts : true,
						onComplete : function(response) {
							chkSub = response.responseText;
							if(chkSub == "Y"){
								showWaitingMessageBox("Too many records found with this subline code in table giis_subline.", imgMessage.INFO, function(){
									$("txtSublineCd").value = "";
									$("txtSublineCd").setAttribute("lastValidValue", "");
									$("txtSublineName").value = "";
									$("txtSublineName").setAttribute("lastValidValue", "");
								});
							}else{
								$("txtSublineCd").value = row.sublineCd;
								$("txtSublineCd").setAttribute("lastValidValue", row.sublineCd);
								$("txtSublineName").value = unescapeHTML2(row.sublineName);
								$("txtSublineName").setAttribute("lastValidValue", unescapeHTML2(row.sublineName));
								sublineCode = row.sublineCd;
							}
						}
					});
					
				},
				onCancel : function() {
					$("txtSublineCd").focus();
					$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
					$("txtSublineName").value = $("txtSublineName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function() {
					$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
					$("txtSublineName").value = $("txtSublineName").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtSublineCd");
				}
			});
		} catch (e) {
			showErrorMessage("showSublineLOV", e);
		}
	}
	
	$("searchSublineCdLOV").observe("click", function() {
		checkSubline(true);
	});

	$("txtSublineCd").observe("change", function() {
		if (this.value != "") {
			checkSubline(false);
		} else {
			$("txtSublineCd").value = "";
			$("txtSublineCd").setAttribute("lastValidValue", "");
			$("txtSublineName").value = "";
			$("txtSublineName").setAttribute("lastValidValue", "");
		}
	});
	
	//Subline LOV
	/*function showSublineLOV(sublineCd) {
		try {
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGiexs008SublineLov",
					search : sublineCd,
					lineCd : $F("txtLineCd")
				},
				width : 410,
				height : 386,
				autoSelectOneRecord : true,
				filterText : sublineCd,
				title : "List of Sublines",
				columnModel : [ {
					id : "sublineCd",
					title : "Subline Cd",
					width : '80px'
				}, {
					id : "sublineName",
					title : "Subline Name",
					width : '310px'
				} ],
				draggable : true,
				onSelect : function(row) {
					new Ajax.Request(contextPath + "/GIEXExpiriesVController?", {
						parameters : {
							action : "checkSubline",
							lineCd : $F("txtLineCd"),
							sublineCd : row.sublineCd
						},
						asynchronous : true,
						evalScripts : true,
						onComplete : function(response) {
							chkSub = response.responseText;
							if(chkSub == "Y"){
								showWaitingMessageBox("Too many records found with this subline code in table giis_subline.", imgMessage.INFO, function(){
									$("txtSublineName").value = "";
									$("txtSublineCd").value = "";
								});
							}else{
								$("txtSublineCd").value = unescapeHTML2(row.sublineCd);
								$("txtSublineName").value = unescapeHTML2(row.sublineName);
								sublineCode = row.sublineCd;
							}
						}
					});
				},
				onUndefinedRow : function() {
					showMessageBox("No record selected.", imgMessage.INFO);
				}
			});
		} catch (e) {
			showErrorMessage("showSublineLOV", e);
		}
	} */
	
	function showIssLOV(isIconClicked) {
		try {
			var searchString = isIconClicked ? "%" : ($F("txtIssCd").trim() == "" ? "%" : $F("txtIssCd"));

			LOV.show({
				controller : "UWRenewalProcessingLOVController",	//Gzelle 09162015 SR4744
				urlParameters : {
					action : "getGiexs008IssLov",
					search : searchString + "%",
					lineCd : $F("txtLineCd"),
					page : 1
				},
				title : "List of Issue Sources",
				width : 410,
				height : 386,
				columnModel : [ {
					id : "issCd",
					title : "Branch Cd",
					width : '80px'
				}, {
					id : "issName",
					title : "Branch Name",
					width : '310px'
				} ],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : escapeHTML2(searchString),
				onSelect : function(row) {
					if (row != null || row != undefined) {
						$("txtIssCd").value = row.issCd;
						$("txtIssCd").setAttribute("lastValidValue", row.issCd);
						$("txtIssName").value = unescapeHTML2(row.issName);
						$("txtIssName").setAttribute("lastValidValue", unescapeHTML2(row.issName));
						issueSource = $("txtIssCd").readAttribute("lastValidValue");
					}
				},
				onCancel : function() {
					$("txtIssCd").focus();
					$("txtIssCd").value = $("txtIssCd").readAttribute("lastValidValue");
					$("txtIssName").value = $("txtIssName").readAttribute("lastValidValue");
					issueSource = $("txtIssCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function() {
					$("txtIssCd").value = $("txtIssCd").readAttribute("lastValidValue");
					$("txtIssName").value = $("txtIssName").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtIssCd");
					issueSource = $("txtIssCd").readAttribute("lastValidValue");
				}
			});
		} catch (e) {
			showIssLOV("showIssLOV", e);
		}
	}
	
	$("searchIssCdLOV").observe("click", function() {
		showIssLOV(true);
	});

	$("txtIssCd").observe("change", function() {
		if (this.value != "") {
			showIssLOV(false);
		} else {
			$("txtIssCd").value = "";
			$("txtIssCd").setAttribute("lastValidValue", "");
			$("txtIssName").value = "";
			$("txtIssName").setAttribute("lastValidValue", "");
			issueSource = "";
		}
	});
	
	function showCredBranchLOV(isIconClicked) {	//start Gzelle 07092015 SR4744
		try {
			var searchString = isIconClicked ? "%" : ($F("txtCredBranchCd").trim() == "" ? "%" : $F("txtCredBranchCd"));

			LOV.show({
				controller : "UWRenewalProcessingLOVController",
				urlParameters : {
					action : "getGiexs008CredBranchLov",
					search : searchString + "%",
					lineCd : $F("txtLineCd"),
					page : 1
				},
				title : "List of Crediting Branches",
				width : 410,
				height : 386,
				columnModel : [ {
					id : "credBranchCd",
					title : "Crediting Branch Cd",
					width : '80px'
				}, {
					id : "credBranchName",
					title : "Crediting Branch Name",
					width : '310px'
				} ],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : escapeHTML2(searchString),
				onSelect : function(row) {
					if (row != null || row != undefined) {
						$("txtCredBranchCd").value = row.credBranchCd;
						$("txtCredBranchCd").setAttribute("lastValidValue", row.credBranchCd);
						$("txtCredBranchName").value = unescapeHTML2(row.credBranchName);
						$("txtCredBranchName").setAttribute("lastValidValue", unescapeHTML2(row.credBranchName));
						creditingBranch = $("txtCredBranchCd").readAttribute("lastValidValue");
					}
				},
				onCancel : function() {
					$("txtCredBranchCd").focus();
					$("txtCredBranchCd").value = $("txtCredBranchCd").readAttribute("lastValidValue");
					$("txtCredBranchName").value = $("txtCredBranchName").readAttribute("lastValidValue");
					creditingBranch = $("txtCredBranchCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function() {
					$("txtCredBranchCd").value = $("txtCredBranchCd").readAttribute("lastValidValue");
					$("txtCredBranchName").value = $("txtCredBranchName").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtCredBranchCd");
					creditingBranch = $("txtCredBranchCd").readAttribute("lastValidValue");
				}
			});
		} catch (e) {
			showIssLOV("showCredBranchLOV", e);
		}
	}
	
	$("searchCredBranchLOV").observe("click", function() {
		showCredBranchLOV(true);
	});

	$("txtCredBranchCd").observe("change", function() {
		if (this.value != "") {
			showCredBranchLOV(false);
		} else {
			$("txtCredBranchCd").value = "";
			$("txtCredBranchCd").setAttribute("lastValidValue", "");
			$("txtCredBranchName").value = "";
			$("txtCredBranchName").setAttribute("lastValidValue", "");
			creditingBranch = "";
		}
	});		//end Gzelle 07092015 SR4744
	
	//Iss LOV
	/* function showIssLOV(issCd) {
		try {
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGiexs008IssLov",
					search : issCd,
					lineCd : $F("txtLineCd")
				},
				width : 410,
				height : 386,
				autoSelectOneRecord : true,
				filterText : issCd,
				title : "List of Issue Sources",
				columnModel : [ {
					id : "issCd",
					title : "Branch Cd",
					width : '80px'
				}, {
					id : "issName",
					title : "Branch Name",
					width : '310px'
				} ],
				draggable : true,
				onSelect : function(row) {
					$("txtIssCd").value = unescapeHTML2(row.issCd);
					$("txtIssName").value = unescapeHTML2(row.issName);
					issueSource = row.issCd;
				},
				onUndefinedRow : function() {
					showMessageBox("No record selected.", imgMessage.INFO);
				}
			});
		} catch (e) {
			showErrorMessage("showIssLOV", e);
		}
	} */
	
	function showIntmLOV(isIconClicked) {
		try {
			var searchString = isIconClicked ? "%" : ($F("txtIntmNo").trim() == "" ? "%" : $F("txtIntmNo"));

			LOV.show({
				controller : "UWRenewalProcessingLOVController",	//Gzelle 09162015 SR4744
				urlParameters : {
					action : "getGiexs008IntmLov",
					search : searchString,
					page : 1
				},
				title : "List of Intermediaries",
				width : 410,
				height : 386,
				columnModel : [ {
					id : "intmNo",
					title : "Intermediary No",
					width : '80px'
				}, {
					id : "intmName",
					title : "Intermediary Name",
					width : '310px'
				} ],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : escapeHTML2(searchString),
				onSelect : function(row) {
					if (row != null || row != undefined) {
						$("txtIntmNo").value = row.intmNo;
						$("txtIntmNo").setAttribute("lastValidValue", row.intmNo);
						$("txtIntmName").value = unescapeHTML2(row.intmName);
						$("txtIntmName").setAttribute("lastValidValue", unescapeHTML2(row.intmName));
						intmNumber = $("txtIntmNo").readAttribute("lastValidValue");
					}
				},
				onCancel : function() {
					$("txtIntmNo").focus();
					$("txtIntmNo").value = $("txtIntmNo").readAttribute("lastValidValue");
					$("txtIntmName").value = $("txtIntmName").readAttribute("lastValidValue");
					intmNumber = $("txtIntmNo").readAttribute("lastValidValue");
				},
				onUndefinedRow : function() {
					$("txtIntmNo").value = $("txtIntmNo").readAttribute("lastValidValue");
					$("txtIntmName").value = $("txtIntmName").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtIntmNo");
					intmNumber = $("txtIntmNo").readAttribute("lastValidValue");
				}
			});
		} catch (e) {
			showErrorMessage("showIntmLOV", e);
		}
	}
	
	$("searchIntmNoLOV").observe("click", function() {
		showIntmLOV(true);
	});

	$("txtIntmNo").observe("change", function() {
		if (this.value != "") {
			showIntmLOV(false);
		} else {
			$("txtIntmNo").value = "";
			$("txtIntmNo").setAttribute("lastValidValue", "");
			$("txtIntmName").value = "";
			$("txtIntmName").setAttribute("lastValidValue", "");
			issueSource = "";
		}
	});
	
	/* //Iss LOV
	function showIntmLOV(intmNo) {
		try {
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGiexs008IntmLov",
					search : intmNo
				},
				width : 410,
				height : 386,
				autoSelectOneRecord : true,
				filterText : intmNo,
				title : "List of Intermediaries",
				columnModel : [ {
					id : "intmNo",
					title : "Intermediary No",
					width : '80px'
				}, {
					id : "intmName",
					title : "Intermediary Name",
					width : '310px'
				} ],
				draggable : true,
				onSelect : function(row) {
					$("txtIntmNo").value = row.intmNo;
					$("txtIntmName").value = unescapeHTML2(row.intmName);
					intmNumber = row.intmNo;
				},
				onUndefinedRow : function() {
					showMessageBox("No record selected.", imgMessage.INFO);
				}
			});
		} catch (e) {
			showErrorMessage("showIntmLOV", e);
		}
	} */

	/*function showParameterUserLOV(isIconClicked) {	--start commented by Gzelle 07102015 SR4744
		try {
			var searchString = isIconClicked ? "%" : ($F("txtAssignTo").trim() == "" ? "%" : $F("txtAssignTo"));

			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGiexs008UserLov",
					search : searchString,
					page : 1
				},
				title : "List of Extract Users", //Kenneth L. 05.07.2014
				width : 410,
				height : 386,
				columnModel : [ {
					id : "userId",
					title : "Extract User",
					width : '395px'
				} ],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : escapeHTML2(searchString),
				onSelect : function(row) {
					if (row != null || row != undefined) {
						$("txtAssignTo").value = row.userId;
						$("txtAssignTo").setAttribute("lastValidValue", row.userId);
						assignToUser = $("txtAssignTo").readAttribute("lastValidValue");
					}
				},
				onCancel : function() {
					$("txtAssignTo").focus();
					$("txtAssignTo").value = $("txtAssignTo").readAttribute("lastValidValue");
					assignToUser = $("txtAssignTo").readAttribute("lastValidValue");
				},
				onUndefinedRow : function() {
					$("txtAssignTo").value = $("txtAssignTo").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtAssignTo");
					assignToUser = $("txtAssignTo").readAttribute("lastValidValue");
				}
			});
		} catch (e) {
			showErrorMessage("showParameterUserLOV", e);
		}
	}
	
	$("searchAssignToLOV").observe("click", function() {
		showParameterUserLOV(true);
	});

	$("txtAssignTo").observe("change", function() {
		if (this.value != "") {
			showParameterUserLOV(false);
		} else {
			$("txtAssignTo").value = "";
			$("txtAssignTo").setAttribute("lastValidValue", "");
			assignToUser = "";
		}
	});	--end commented by Gzelle 07102015 SR4744*/
	
	/* function showParameterUserLOV(userLov) {
		try {
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGiexs008UserLov",
					search : userLov
				},
				width : 410,
				height : 386,
				autoSelectOneRecord : true,
				filterText : userLov,
				title : "List of Users",
				columnModel : [ {
					id : "userId",
					title : "Extract User",
					width : '395px'
				} ],
				draggable : true,
				onSelect : function(row) {
					$("txtAssignTo").value = unescapeHTML2(row.userId);
					assignToUser = row.userId;
				},
				onUndefinedRow : function() {
					showMessageBox("No record selected.", imgMessage.INFO);
				}
			});
		} catch (e) {
			showErrorMessage("showParameterUserLOV", e);
		}
	} */

	function checkSubline(observer) {
		new Ajax.Request(contextPath + "/GIEXExpiriesVController?", {
			parameters : {
				action : "checkSubline",
				lineCd : $F("txtLineCd"),
				sublineCd : $F("txtSublineCd")
			},
			asynchronous : true,
			evalScripts : true,
			onComplete : function(response) {
				chkSub = response.responseText;
				if(chkSub == "Y"){
					showWaitingMessageBox("Too many records found with this subline code in table giis_subline.", imgMessage.INFO, function(){
						$("txtSublineName").value = "";
						$("txtSublineCd").value = "";
					});
				}else{
					showSublineLOV(observer);
					/* if(observer == true){
						showSublineLOV(true);
					}else if (observer == false){
						checkLov("getGiexs008SublineLov", showSublineLOV,
								getSublineIssParams("txtSublineCd"),
								"txtSublineCd", "txtSublineCd",
								"txtSublineName", "",
								"Subline code does not exist in table giis_subline.");
					} */
				}
			}
		});
	}
	
	//LOV validation
	function checkLov(action, func, params, search, primary, desc, message, notInTable) {
		var output = validateTextFieldLOV("/UWRenewalProcessingLOVController?action=" + action + params, $(search).value, "Searching, please wait..."); //Gzelle 09162015 SR4744
		if (output == 2) {
			func($(search).value);
		} else if (output == 0) {
			$(primary).clear();
			$(desc).value = message;
			customShowMessageBox(notInTable, "I", search);
		} else {
			func($(search).value);
		}
	}

	function getLineParams(search) {
		var params = "&search=" + $F(search) + "&issCd=" + $F("txtIssCd");
		return params;
	}

	function getSublineIssParams(search) {
		var params = "&search=" + $F(search) + "&lineCd=" + $F("txtLineCd");
		return params;
	}

	/* $("txtLineCd").observe("change", function() {
		if ($("txtLineCd").value == "") {
			$("txtLineName").value = "";
		} else {
			checkLov("getGiexs008LineLov", showLineLOV,
					getLineParams("txtLineCd"), "txtLineCd",
					"txtLineCd", "txtLineName", "",
					"Line Code does not exist in table giis_line.");
		}
	}); */

	/* $("txtLineName").observe("change", function() {
		checkLov("getGiexs008LineLov", showLineLOV,
				getLineParams("txtLineName"), "txtLineName",
				"txtLineCd", "txtLineName", "",
				"Line Code does not exist in table giis_line.");
	}); */

	/* $("searchLineCdLOV").observe("click", function() {
		showLineLOV("%");
	}); */

	/* $("searchLineNameLOV").observe("click", function() {
		showLineLOV($("txtLineCd").value);
	}); */
	
	
	
	/* $("txtSublineCd").observe("change", function() {
		if ($("txtSublineCd").value == "") {
			$("txtSublineName").value = "";
		} else {
			checkSubline("change");
		}
	}); */

	/* $("txtSublineName").observe("change", function() {
		checkLov("getGiexs008SublineLov", showSublineLOV,
				getSublineIssParams("txtSublineName"),
				"txtSublineName", "txtSublineCd", "txtSublineName", "",
				"Subline code does not exist in table giis_subline.");
	}); */

	/* $("searchSublineCdLOV").observe("click", function() {
		checkSubline("click");
	}); */

	/* $("searchSublineNameLOV").observe("click", function() {
		showSublineLOV($("txtSublineCd").value);
	}); */

	/* $("txtIssCd").observe("change", function() {
		if ($("txtIssCd").value == "") {
			$("txtIssName").value = "";
		} else {
			checkLov("getGiexs008IssLov", showIssLOV,
					getSublineIssParams("txtIssCd"),
					"txtIssCd", "txtIssCd", "txtIssName", "",
					"Branch code does not exist in table giis_issource.");
		}
	}); */

	/* $("txtIssName").observe("change", function() {
		checkLov("getGiexs008IssLov", showIssLOV,
				getSublineIssParams("txtIssName"), "txtIssName",
				"txtIssCd", "txtIssName", "",
				"Branch code does not exist in table giis_issource.");
	}); */

	/* $("searchIssCdLOV").observe("click", function() {
		showIssLOV("%");
	}); */

	/* $("searchIssNameLOV").observe("click", function() {
		showIssLOV($("txtIssCd").value);
	}); */

	/* $("txtIntmNo").observe("change", function() {
		if ($("txtIntmNo").value == "") {
			$("txtIntmName").value = "";
		} else {
			checkLov("getGiexs008IntmLov", showIntmLOV,
					"&search=" + $F("txtIntmNo"), "txtIntmNo",
					"txtIntmNo", "txtIntmName", "",
					"Itermediary does not exist in table giis_intermediary.");
		}
	}); */

	/* $("txtIntmName").observe("change", function() {
		checkLov("getGiexs008IntmLov", showIntmLOV, "&search="
				+ $F("txtIntmName"), "txtIntmName",
				"txtIntmNo", "txtIntmName", "",
				"Itermediary does not exist in table giis_intermediary.");
	}); */

	/* $("searchIntmNoLOV").observe("click", function() {
		showIntmLOV("%");
	}); */

	/* $("searchIntmNameLOV").observe("click", function() {
		showIntmLOV($("txtIntmNo").value);
	}); */

	/* $("txtAssignTo").observe("change", function() {
		if ($("txtAssignTo").value == "") {
			$("txtAssignTo").value = "";
		} else{
			var output = validateTextFieldLOV("/UnderwritingLOVController?action=getGiexs008UserLov&search=" + $F("txtAssignTo"), $F("txtAssignTo"), "Searching, please wait...");
			if (output == 2) {
				showParameterUserLOV($F("txtAssignTo"));
			} else if (output == 0) {
				$("txtAssignTo").value = "";
				customShowMessageBox("User ID does not exist in the maintenance table.", "I", "txtAssignTo");
			} else {
				showParameterUserLOV($F("txtAssignTo"));
			}
		}
	});

	$("searchAssignToLOV").observe("click", function() {
		showParameterUserLOV("%");
	}); */
	
	//start - Gzelle 07202015 SR4744
	var stat = false;
	function areThereQueryParam() {
		$$("input[type='text']").each(function(field) {
			if (!stat) {
				if (field.name != "mtgPageInput1") {
					if ($F(field) != "") {
						stat = true;
					}else {
						stat = false;
					}
				}
			}
		});
		return stat;
	}	//end

	$("btnOk").observe("click", function() {
		fromDate = $F("txtFromDate");
		toDate = $F("txtToDate");
		if (areThereQueryParam()) {	//start - Gzelle 07202015 SR4744 
			checkBeforeSave();
		}else {
			overlayParameters.close();
		}	//end
	});

	function checkBeforeSave() {
		new Ajax.Request(contextPath + "/GIEXExpiriesVController?", {
			parameters : {
				action : "checkRecords",
				extractUser : assignToUser,
				fromDate : fromDate,
				toDate : toDate,
				byDate : expiryExtract,
				misSw : mis,
				lineCd : lineCode,
				sublineCd : sublineCode,
				issCd : issueSource,
				intmNo : intmNumber
			},
			asynchronous : true,
			evalScripts : true,
			onComplete : function(response) {
				if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
					result = response.responseText;
					assignExtractedExpiriesTable._refreshList(); /* start - Gzelle 07102015 SR4744 */
					queryExtractedExpiryRec();	
				}
			}
		});
	}
	
	function queryExtractedExpiryRec() {	/* start Gzelle 07102015 SR4744 */
		assignExtractedExpiriesTable.url = contextPath + "/GIEXExpiriesVController?action=showAssignExtractedExpiryRecord&refresh=1"+
														 "&fromDate="+fromDate+"&toDate="+toDate+"&byDate="+expiryExtract+
														 "&lineCd="+lineCode+"&sublineCd="+sublineCode+"&issCd="+issueSource+
														 "&credBranch="+creditingBranch+"&intmNo="+intmNumber;
		assignExtractedExpiriesTable.refresh(); 
		if(assignExtractedExpiriesTable.geniisysRows.length == 0){
			overlayParameters.close();
		} else {
			recToAssign = [];
			recToRemove = [];
			result = "QUERY";
			assignTag = 4;
			overlayParameters.close();
			params.assignByBatch();
		}
	}										//end Gzelle 07102015 SR4744
	
	//date validation
	function validateFromAndTo(field) {
		var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g, "/")) : "";
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g, "/")) : "";
		
		if (fromDate > toDate && toDate != "") {
			showMessageBox("From date must not be later than to date.", "I");
			$(field).focus();
			$(field).clear();
			
		}
	}
	
	$$("input[name='fromTo']").each(function(field) {
		 field.observe("focus", function() {
			 validateFromAndTo(field.id);
			 return;
		});
	});
</script>