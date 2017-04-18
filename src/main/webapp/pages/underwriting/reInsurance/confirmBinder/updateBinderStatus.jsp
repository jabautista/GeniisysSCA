<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="updateBinderStatusMainDiv" name="updateBinderStatusMainDiv" style="margin-top: 1px;">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="updateBinderStatusForm">
		<form id="updateBinderStatus" name="updateBinderStatus">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="outerDiv">
					<label>Update Binder Status</label>
					<span class="refreshers" style="margin-top: 0;">
						<!-- <label name="gro" style="margin-left: 5px;">Hide</label> --> 
					 	<label id="reloadForm" name="reloadForm">Reload Form</label> 
					</span>
				</div>
			</div>
			<div id="mainDiv" class="sectionDiv" style="padding-bottom: 10px;">
				<div id="binderDiv" class="sectionDiv" style="border: 0px;">
					<div id="binderDtlDiv" class="sectionDiv" style="border: 0px;">
						<table cellspacing="2" border="0" style="margin: 10px auto; margin-left: 44px;">
							<tbody>
								<tr>
									<td class="rightAligned" style="width: 80px;">Binder No.</td>
									<td class="leftAligned" style="width: 232px;">
										<input class="allCaps required" maxlength="2" type="text" value="" name="headerField" id="txtLineCd" tabindex="101" style="width: 50px; text-align: left; border: 1px solid gray;">
										<input class="upper integerNoNegativeUnformatted" maxlength="2" type="text" value="" name="headerField" id="txtBinderYy" tabindex="102" style="width: 50px; text-align: right; border: 1px solid gray;">
										<input class="upper integerNoNegativeUnformatted" maxlength="5" type="text" value="" name="headerField" id="txtBinderSeqNo" tabindex="103" style="width: 100px; text-align: right; border: 1px solid gray;">
									</td>
									<td>
										<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBinderLov" name="searchBinderLov" alt="Go" style="float: left;"/>
									</td>
									<td class="rightAligned" style="width: 223px;">Binder Date</td>
									<td class="leftAligned" style="width: 109px;">
										<input type="text" readonly="readonly" value="" name="txtBinderDate" id="txtBinderDate" tabindex="4" style="width: 195px; text-align: left; border: 1px solid gray;">
									</td>
								</tr>
								<tr>
									<td class="rightAligned" style="width: 80px;">Reinsurer</td>
									<td class="leftAligned" style="width: 232px;">
										<input type="text" readonly="readonly" value="" name="txtRiCd" id="txtRiCd" tabindex="5" style="width: 50px; text-align: right; border: 1px solid gray;">
										<input type="text" readonly="readonly" value="" name="txtRiSname" id="txtRiSname" tabindex="6" style="width: 162px; text-align: left; border: 1px solid gray;">
									</td>
									<td>
									</td>
									<td class="rightAligned" style="width: 100px;">Share %</td>
									<td class="leftAligned" style="width: 100px;">
										<input type="text" readonly="readonly" value="" name="txtRiShrPct" id="txtRiShrPct" tabindex="7" style="width: 195px; text-align: right; border: 1px solid gray;">
									</td>
								</tr>
								<tr>
									<td class="rightAligned" style="width: 80px;">RI TSI Share</td>
									<td class="leftAligned" style="width: 232px;">
										<input type="text" readonly="readonly" value="" name="txtRiTsiAmt" id="txtRiTsiAmt" tabindex="8" style="width: 224.5px; text-align: right; border: 1px solid gray;">
									</td>
									<td>
									</td>
									<td class="rightAligned" style="width: 100px;">RI Premium Share</td>
									<td class="leftAligned" style="width: 100px;">
										<input type="text" readonly="readonly" value="" name="txtRiPremAmt" id="txtRiPremAmt" tabindex="9" style="width: 195px; text-align: right; border: 1px solid gray;">
									</td>
								</tr>
								<tr>
									<td class="rightAligned" style="width: 87px;">Effectivity Date</td>
									<td class="leftAligned" style="width: 232px;">
										<input type="text" readonly="readonly" value="" name="txtEffDate" id="txtEffDate" tabindex="10" style="width: 224.5px; text-align: left; border: 1px solid gray;">
									</td>
									<td>
									</td>
									<td class="rightAligned" style="width: 100px;">Expiry Date</td>
									<td class="leftAligned" style="width: 100px;">
										<input type="text" readonly="readonly" value="" name="txtExpiryDate" id="txtExpiryDate" tabindex="11" style="width: 195px; text-align: left; border: 1px solid gray;">
									</td>
								</tr>
								<tr>
									<td class="rightAligned" style="width: 80px;">Confirm No.</td>
									<td class="leftAligned" style="width: 232px;">
										<input type="text" value="" name="txtConfirmNo" id="txtConfirmNo" tabindex="12" maxlength="20" style="width: 224.5px; text-align: left; border: 1px solid gray;">
									</td>
									<td>
									</td>
									<td class="rightAligned" style="width: 100px;">Confirm Date</td>
									<td class="leftAligned" style="width: 100px;">
										<div id="txtConfirmDateDiv" style="float: left; border: solid 1px gray; width: 201px; height: 20px; margin-left: 0px; margin-top: 0px;">
											<input readonly="readonly" type="text" id="txtConfirmDate" tabindex="13" style="float: left; margin-top: 0px; margin-right: 0.5px; width: 174.5px; height: 14px; border: none;" name="txtConfirmDate"/>
											<img id="imgConfirmDate" alt="imgConfirmDate" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"/>
										</div>
									</td>
								</tr>
								<tr>
									<td class="rightAligned" style="width: 80px;">Release by</td>
									<td class="leftAligned" style="width: 232px;">
										<input type="text" value="" name="txtReleaseBy" id="txtReleaseBy" tabindex="14" maxlength="20" style="width: 224.5px; text-align: left; border: 1px solid gray;">
									</td>
									<td>
									</td>
									<td class="rightAligned" style="width: 100px;">Release Date</td>
									<td class="leftAligned" style="width: 100px;">
										<div id="txtReleaseDateDiv" style="float: left; border: solid 1px gray; width: 201px; height: 20px; margin-left: 0px; margin-top: 0px;">
											<input readonly="readonly" type="text" id="txtReleaseDate" tabindex="15" style="float: left; margin-top: 0px; margin-right: 0.5px; width: 174.5px; height: 14px; border: none;" name="txtReleaseDate"/>
											<img id="imgReleaseDate" alt="imgReleaseDate" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"/>
										</div>
									</td>
								</tr>
								<tr>
									<td class="rightAligned" style="width: 80px;">Status</td>
									<td class="leftAligned" style="width: 232px;">
										<span class="lovSpan" style="width: 230px;">
											<input type="text" id="txtStatus" name="txtStatus" tabindex="16" readonly="readonly" style="width: 205px; float: left; border: none; height: 14px; margin: 0;"/>
											<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchStatus" name="searchStatus" alt="Go" style="float: right;"/>
										</span>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>	
				<div id="policyDiv" class="sectionDiv" style="border: 0px;">
					<table cellspacing="2" border="0" style="margin: 10px auto;">
						<tr>
							<td class="rightAligned" style="width: 73px;">Policy No.</td>
							<td class="leftAligned" style="width:400px;">
								<input type="text" readonly="readonly" value="" name="txtPolLineCd" id="txtPolLineCd" tabindex="17" style="width: 40px; text-align: left; border: 1px solid gray;">
								<input type="text" readonly="readonly" value="" name="txtPolSublineCd" id="txtPolSublineCd" tabindex="18" style="width: 70px; text-align: left; border: 1px solid gray;">
								<input type="text" readonly="readonly" value="" name="txtPolIssCd" id="txtPolIssCd" tabindex="19" style="width: 40px; text-align: left; border: 1px solid gray;">
								<input type="text" readonly="readonly" value="" name="txtPolIssueYy" id="txtPolIssueYy" tabindex="20" style="width: 40px; text-align: right; border: 1px solid gray;">
								<input type="text" readonly="readonly" value="" name="txtPolPolSeqNo" id="txtPolPolSeqNo" tabindex="21" style="width: 70px; text-align: right; border: 1px solid gray;">
								<input type="text" readonly="readonly" value="" name="txtPolRenewNo" id="txtPolRenewNo" tabindex="22" style="width: 40px; text-align: right; border: 1px solid gray;">
							</td>
							<td class="rightAligned" style="width:80px;">Endt No.</td>
							<td class="leftAligned" style="width: 228px;">
								<input type="text" readonly="readonly" value="" name="txtEndtIssCd" id="txtEndtIssCd" tabindex="23" style="width: 50px; text-align: left; border: 1px solid gray;">
								<input type="text" readonly="readonly" value="" name="txtEndtYy" id="txtEndtYy" tabindex="24" style="width: 50px; text-align: right; border: 1px solid gray;">
								<input type="text" readonly="readonly" value="" name="txtEndtSeqNo" id="txtEndtSeqNo" tabindex="25" style="width: 73px; text-align: right; border: 1px solid gray;">
							</td>
						</tr>
						<tr>
							<td class="rightAligned" style="width: 60px;">Assured</td>
							<td class="leftAligned" style="width: 400px;">
								<input type="text" readonly="readonly" value="" name="txtAssured" id="txtAssured" tabindex="26" style="width: 360px; text-align: left; border: 1px solid gray;">
							</td>
							<td class="rightAligned" style="width:80px;">FRPS No.</td>
							<td class="leftAligned" style="width: 228px;">
								<input type="text" readonly="readonly" value="" name="txtFrpsLineCd" id="txtFrpsLineCd" tabindex="27" style="width: 50px; text-align: left; border: 1px solid gray;">
								<input type="text" readonly="readonly" value="" name="txtFrpsYy" id="txtFrpsYy" tabindex="28" style="width: 50px; text-align: right; border: 1px solid gray;">
								<input type="text" readonly="readonly" value="" name="txtFrpsSeqNo" id="txtFrpsSeqNo" tabindex="29" style="width: 73px; text-align: right; border: 1px solid gray;">
							</td>
						</tr>
					</table>
				</div>
				<div id="acceptanceDiv" class="sectionDiv" style="border: 0px; width: 200px; margin-left: 139px; margin-top: 5px;">
					<fieldset id="fswithConfirmation" style="height: 50px;">
						<table style="margin-top: 15px; margin-left: 25px;">
							<tr>
								<td>
									<input type="checkbox" id="chkWConfirmation" disabled="disabled" style="margin-left: 15px; float: left; "/>
									<label for="chkWConfirmation" style="margin-left: 5px;">with Confirmation</label>
								</td>
							</tr>
						</table>
					</fieldset>
				</div>
				<div id="acceptanceDiv" class="sectionDiv" style="border: 0px; width: 340px; margin-left: 201px; margin-top: 5px; margin-bottom: 10px;">
					<fieldset id="fsAcceptanceInfo" style="height: 100px;">
						<table style="margin-top: 5px;">
							<tr>
								<td class="rightAligned" style="width: 71px;">Accepted By</td>
								<td class="leftAligned" style="width: 228px;">
									<input type="text" readonly="readonly" value="" name="txtAcceptedBy" id="txtAcceptedBy" tabindex="30" style="width: 198px; text-align: left; border: 1px solid gray;">
								</td>
							</tr>
							<tr>
								<td class="rightAligned" style="width: 60px;">AS No.</td>
								<td class="leftAligned" style="width: 228px;">
									<input type="text" readonly="readonly" value="" name="txtAsNo" id="txtAsNo" tabindex="31" style="width: 198px; text-align: left; border: 1px solid gray;">
								</td>
							</tr>
							<tr>
								<td class="rightAligned" style="width: 60px;">Accept Date</td>
								<td class="leftAligned" style="width: 228px;">
									<input type="text" readonly="readonly" value="" name="txtAcceptDate" id="txtAcceptDate" tabindex="32" style="width: 198px; text-align: left; border: 1px solid gray;">
								</td>
							</tr>
						</table>
					</fieldset>
				</div>
			</div>
			<div class="buttonDiv" style="float: left; width: 100%; margin-bottom: 20px; margin-top: 20px;">
				<table align="center" style="margin-bottom: 20px;">
					<tbody>
						<tr>
							<td>
								<input id="btnInspection" class="button noChangeTagAttr" type="button" style="display: none; value="Select Inspection" name="btnInspection">
							</td>
							<td>
								<input id="btnCancel" class="button" type="button" style="width: 100px;" value="Cancel" name="btnCancel">
							</td>
							<td>
								<input id="btnSave" class="button" type="button" style="width: 100px;" value="Save" name="btnSave">
							</td>
						</tr>
					</tbody>
				</table> 
			</div>
		</form>
	</div>
</div>
<script type="text/javascript">
try{
	/* $("searchBinderLov").observe("click", function(){
		showBinderLov();
	}); */
	
	$("searchBinderLov").observe("click", function(){
		if ($F("txtLineCd") != ""){
			showBinderLov();
		} else {
			showMessageBox("Required fields must be entered.", "I");
		}	
	});
	
	$$("input[name='headerField']").each(function(i){
		i.observe("change", function(){
			if($F("txtLineCd") != "" || $F("txtBinderYy") != "" || $F("txtBinderSeqNo") != "" ){
				enableToolbarButton("btnToolbarEnterQuery");
			}else{
				disableToolbarButton("btnToolbarEnterQuery");
			}
		});
	});
	
	$("txtBinderSeqNo").observe("change", function(){
		if($F("txtBinderSeqNo") != ""){
			$("txtBinderSeqNo").value = lpad($F("txtBinderSeqNo"), 5, '0');
		}
	});
	
	function showBinderLov(){
		try {
			LOV.show({  controller : "UWReinsuranceLOVController",
						urlParameters : {
							action : "showBinderLov",
							lineCd: $F("txtLineCd"),
							binderYy: $F("txtBinderYy"),
							binderSeqNo: $F("txtBinderSeqNo"),
							page : 1
						},
						title : "List for Update of Binder Status",
						width : 800,
						height : 410,
						hideColumnChildTitle : true,
						filterVersion : "2",
						columnModel : [ {
							id : 'recordStatus',
							title : '',
							width : '0',
							visible : false,
							editor : 'checkbox'
						}, {
							id : 'divCtrId',
							width : '0',
							visible : false
						}, {
							id : 'lineCd',
							title : "Binder Line Cd",
							width : '0',
							filterOption : true,
							visible : false
						}, {
							id : 'binderYy',
							title : 'Binder Issue Year',
							type : 'number',
							width : '0',
							filterOption : true,
							filterOptionType: 'integerNoNegative',
							visible : false
						}, {
							id : 'binderSeqNo',
							title : 'Binder Seq. No',
							type : 'number',
							width : '0',
							filterOption : true,
							filterOptionType: 'integerNoNegative',
							visible : false
						}, {
							id : 'dspLineCd',
							title : 'Policy Line Code',
							width : '0',
							filterOption : true,
							visible : false
						}, {
							id : 'dspSublineCd',
							title : 'Policy Subline Code',
							width : '0',
							filterOption : true,
							visible : false
						}, {
							id : 'dspIssCd',
							title : 'Policy Issue Code',
							width : '0',
							filterOption : true,
							visible : false
						}, {
							id : 'dspIssueYy',
							title : 'Policy Issue Year',
							type : 'number',
							align : 'right',
							width : '0',
							filterOption : true,
							filterOptionType: 'integerNoNegative',
							visible : false
						}, {
							id : 'dspPolSeqNo',
							title : 'Policy Sequence No.',
							type : 'number',
							align : 'right',
							width : '0',
							filterOption : true,
							filterOptionType: 'integerNoNegative',
							visible : false
						}, {
							id : 'dspRenewNo',
							title : 'Policy Renew No.',
							type : 'number',
							align : 'right',
							width : '0',
							filterOption : true,
							filterOptionType: 'integerNoNegative',
							visible : false
						}, {
							id : "dspAssdName",
							title : "Assured Name",
							width : '0',
							filterOption : true,
							visible : false
						}, {
							id : "binderNo",
							title : "Binder No.",
							titleAlign : 'left',
							width : 100,
							align : 'left',
						}, {
							id : 'riCd',
							title : 'RI Code',
							type : 'number',
							align : 'right',
							width : 70,
							filterOption : true,
							filterOptionType: 'integerNoNegative'
						}, {
							id : "dspRiSname",
							title : "RI Name",
							width : 115,
							filterOption : true
						}, {
							id : "policyNo",
							title : "Policy No.",
							titleAlign : 'left',
							width : 180,
							align : 'left',
						}, {
							id : "dspAssdName",
							title : "Assured Name",
							width : 300
						}],
						draggable : true,
						autoSelectOneRecord: true,
						onSelect : function(row) {
							$("txtConfirmNo").disabled = false;
							$("txtReleaseBy").disabled = false;
							$("txtLineCd").value = row == null ? "" : row.lineCd;
							$("txtBinderYy").value = row == null ? "" : row.binderYy;
							$("txtBinderSeqNo").value = row == null ? "" : row.dspBinderSeqNo;
							$("txtBinderDate").value = row == null ? "" : row.binderDate == null ? "" : dateFormat(row.binderDate, "mm-dd-yyyy");
							$("txtRiCd").value = row == null ? "" : row.riCd;
							$("txtRiSname").value = row == null ? "" : unescapeHTML2(row.dspRiSname);
							$("txtRiShrPct").value = row == null ? "" : formatToNineDecimal(row.riShrPct);
							$("txtRiTsiAmt").value = row == null ? "" : formatCurrency(row.riTsiAmt);
							$("txtRiPremAmt").value = row == null ? "" : formatCurrency(row.riPremAmt);
							$("txtConfirmNo").value = row == null ? "" : row.confirmNo;
							$("txtConfirmDate").value = row == null ? "" : row.confirmDate == null ? "" : dateFormat(row.confirmDate, "mm-dd-yyyy");
							$("txtConfirmDate").setAttribute("lastValidValue", (row.confirmDate == null ? "" : dateFormat(row.confirmDate, "mm-dd-yyyy")));
							$("txtReleaseBy").value = row == null ? "" : unescapeHTML2(row.releaseBy);
							$("txtReleaseDate").value = row == null ? "" : row.releaseDate == null ? "" : dateFormat(row.releaseDate, "mm-dd-yyyy");
							$("txtReleaseDate").setAttribute("lastValidValue", (row.releaseDate == null ? "" : dateFormat(row.releaseDate, "mm-dd-yyyy")));
							$("txtPolLineCd").value = row == null ? "" : row.dspLineCd;
							$("txtPolSublineCd").value = row == null ? "" : row.dspSublineCd;
							$("txtPolIssCd").value = row == null ? "" : row.dspIssCd;
							$("txtPolIssueYy").value = row == null ? "" : row.dspIssueYy;
							$("txtPolPolSeqNo").value = row == null ? "" : row.dspPolSeqNo;
							$("txtPolRenewNo").value = row == null ? "" : row.dspRenewNo;
							$("txtEndtIssCd").value = row == null ? "" : row.dspEndtIssCd;
							$("txtEndtYy").value = row == null ? "" : row.dspEndtYy;
							$("txtEndtSeqNo").value = row == null ? "" : row.dspEndtSeqNo;
							$("txtFrpsLineCd").value = row == null ? "" : row.dspFrpsLineCd;
							$("txtFrpsYy").value = row == null ? "" : row.dspFrpsYy;
							$("txtFrpsSeqNo").value = row == null ? "" : row.dspFrpsSeqNo;
							$("txtAssured").value = row == null ? "" : unescapeHTML2(row.dspAssdName);
							$("txtStatus").value = row == null ? "" : unescapeHTML2(row.nbtBndrStatDesc);
							$("txtAcceptedBy").value = row == null ? "" : row.dspRiAcceptBy;
							$("txtAsNo").value = row == null ? "" : row.dspRiAsNo;
							$("txtAcceptDate").value = row == null ? "" : row.dspRiAcceptDate == null ? "" : dateFormat(row.dspRiAcceptDate, "mm-dd-yyyy");
							$("txtEffDate").value = row == null ? "" : row.dspEffDate == null ? "" : dateFormat(row.dspEffDate, "mm-dd-yyyy");
							//$("txtExpiryDate").value = row == null ? "" : row.dspEffDate == null ? "" : dateFormat(row.dspEffDate, "mm-dd-yyyy");//replaced by codes below --robert SR 20936 01.05.16
							$("txtExpiryDate").value = row == null ? "" : row.dspExpiryDate == null ? "" : dateFormat(row.dspExpiryDate, "mm-dd-yyyy");
							fnlBinderId = row == null ? '0' : row.fnlBinderId == null ? '0' : row.fnlBinderId;
							
							$$("input[name='headerField']").each(function(i){
								disableInputField(i.id);
							});
							
							if($F("txtConfirmNo") != "" || $F("txtConfirmDate") != ""){
								$("chkWConfirmation").checked = true;
							} else {
								$("chkWConfirmation").checked = false;
								enableSearch("searchBinderLov");
							}
							
							enableDisableSearchStatus();
							
							if(row.bndrStatCd == null){
								$("txtStatus").value = "UNRELEASED";
								enableSearch("searchStatus");
							}
							
							enableToolbarButton("btnToolbarEnterQuery");
							disableSearch("searchBinderLov");
						}
					});
		} catch (e) {
			showErrorMessage("showINPolbasLOV", e);
		}
	}
	
	$("btnSave").observe("click", function(){
		if($F("txtConfirmNo") != ""){
			if($F("txtConfirmDate") == ""){
				$("txtConfirmDate").value = dateFormat(dateToday, "mm-dd-yyyy");
				$("chkWConfirmation").checked = true;
			}
		} else if($F("txtConfirmDate") != ""){
			if($F("txtConfirmNo") == ""){
				customShowMessageBox("Confirm number must be entered.","I", "txtConfirmNo");
				return;
			}
		}
		
		if($F("txtReleaseDate") != ""){
			if($F("txtReleaseBy") == ""){
				customShowMessageBox("Release by value must be entered.","I", "txtReleaseBy");
				return;
			}
		} else if($F("txtReleaseBy") != ""){
			if($F("txtReleaseDate") == ""){
				customShowMessageBox("Release date must be entered.","I", "txtReleaseDate");
				return;
			}
		}
		
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
		} else {
			updateBinderStatusGIUTS012();	
		}
	});
	
	function updateBinderStatusGIUTS012(){
		try {
			new Ajax.Request(contextPath+"/GIRIBinderController",{
				method: "POST",
				parameters : {action : "updateBinderStatusGIUTS012",
					confirmNo:      $F("txtConfirmNo"),
					confirmDate:	$F("txtConfirmDate"),
					releaseBy:		$F("txtReleaseBy"),
					releaseDate:	$F("txtReleaseDate"),
					status:         $F("txtStatus"),
					fnlBinderId:    fnlBinderId
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Updating Binder Status, please wait...");
				},
				onComplete: function(response){
					changeTag = 0;
					changeTagFunc = "";
					hideNotice();
					if(exitTag == "Y"){
						showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function(){
							goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
						});						
					} else {
						showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
						//added condition edgar 12/02/2014
						if($("txtStatus").value == "UNRELEASED" ||$("txtStatus").value == "CONFIRMED" ||$("txtStatus").value == "RELEASED"||$("txtStatus").value == ""){
							updateBinderStatus();	
						}
					}
				}
			});
		} catch (e) {
			showErrorMessage("updateBinderStatusGIUTS012",e);
		}		
	}
	
	function updateBinderStatus(){
		if($F("txtConfirmNo") == "" && $F("txtConfirmDate") == "" && $F("txtReleaseBy") == "" && $F("txtReleaseDate") == ""){
			$("txtStatus").value = "UNRELEASED";//edgar 11/25/2014
		} else {
			if($F("txtConfirmNo") != "" && $F("txtConfirmDate") != ""){
				$("txtStatus").value = "CONFIRMED";
			} else if($F("txtReleaseBy") != "" && $F("txtReleaseDate") != ""){
				$("txtStatus").value = "RELEASED";
			} else if($F("txtConfirmNo") != "" && $F("txtReleaseBy") != ""){
				$("txtStatus").value = "CONFIRMED";
			} else if($F("txtConfirmNo") == "" && $F("txtReleaseBy") == "" && $F("txtReleaseDate") == ""){
				$("txtStatus").value = "UNRELEASED";//edgar 11/25/2014 : changed text from "UNREALEASE" to "UNREALEASED"
			}
		}
		
	}
	//edgar 12/03/2014
	function updateBinderStatus2(){
		if($F("txtConfirmNo") == "" && $F("txtConfirmDate") == "" && $F("txtReleaseBy") == "" && $F("txtReleaseDate") == ""){
			$("txtStatus").value = "UNRELEASED";
		} else {
			if($F("txtConfirmNo") != "" && $F("txtConfirmDate") != ""){
				$("txtStatus").value = "CONFIRMED";
			} else if($F("txtReleaseBy") != "" && $F("txtConfirmNo") == ""){
				$("txtStatus").value = "RELEASED";
			} else if($F("txtConfirmNo") != "" && $F("txtReleaseBy") != ""){
				$("txtStatus").value = "CONFIRMED";
			} else if($F("txtConfirmNo") == "" && $F("txtReleaseBy") == "" && $F("txtReleaseDate") == ""){
				$("txtStatus").value = "UNRELEASED";
			}
		}
		
	}
	
	function validateDateFormat(strValue, elemName){
		var text = strValue; 
		var comp = text.split('-');
		var m = parseInt(comp[0], 10);
		var d = parseInt(comp[1], 10);
		var y = parseInt(comp[2], 10);
		var status = true;
		var isMatch = text.match(/^(\d{1,2})-(\d{1,2})-(\d{4})$/);
		var date = new Date(y,m-1,d);
		
		if(isNaN(y) || isNaN(m) || isNaN(d) || y.toString().length < 4 || !isMatch ){
			customShowMessageBox("Date must be entered in a format like MM-DD-RRRR.", imgMessage.INFO, elemName);
			status = false;
		}
		if(0 >= m || 13 <= m){
			customShowMessageBox("Month must be between 1 and 12.", imgMessage.INFO, elemName);	
			status = false; 
		}
		if(date.getDate() != d){				
			customShowMessageBox("Day must be between 1 and the last of the month.", imgMessage.INFO, elemName);	
			status = false;
		}
		if(!status){
			$(elemName).value = "";
		}
	}
	
	$("txtConfirmDate").observe("blur", function(){
		if($F("txtConfirmDate") != "" && validateDateFormat($F("txtConfirmDate"), "txtConfirmDate")){
			// more validations if any
		}
	});
	
	$("txtReleaseDate").observe("blur", function(){
		if($F("txtReleaseDate") != "" && validateDateFormat($F("txtReleaseDate"), "txtReleaseDate")){
			// more validations if any
		}
	});
	
	$("txtConfirmNo").observe("change", function(){
		enableDisableSearchStatus();
		if(this.value != ""){
			if($F("txtConfirmDate") == ""){
				$("txtConfirmDate").value = dateFormat(dateToday, "mm-dd-yyyy");
			}
			$("chkWConfirmation").checked = true;
		} else {
			$("txtConfirmDate").value = "";
			$("chkWConfirmation").checked = false;
		}	
		updateBinderStatus2(); //edgar 12/03/2014
	});
	
	$("txtReleaseBy").observe("change", function(){
		if(this.value != ""){
			//$("txtReleaseDate").value = dateFormat(dateToday, "mm-dd-yyyy");
		} else {
			$("txtReleaseDate").value = "";
		}	
		updateBinderStatus2(); //edgar 12/03/2014
	});
	
	$("txtReleaseBy").observe("keyup", function(){
		enableDisableSearchStatus();
	});
	
	$("txtConfirmDate").observe("keyup", function(){
		enableDisableSearchStatus();
	});
	
	$("txtReleaseDate").observe("keyup", function(){
		enableDisableSearchStatus();
	});
	
	function enableDisableSearchStatus(){
		if($F("txtConfirmNo") == "" && $F("txtConfirmDate") == "" && $F("txtReleaseBy") == "" && $F("txtReleaseDate") == ""){
			enableSearch("searchStatus");
		} else {
			disableSearch("searchStatus");
		}
	}
	
	$("btnToolbarEnterQuery").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox("CONFIRMATION", "Entering query mode will disregard all changes. Proceed?", "Yes", "No", function () {
																														showGIUTS012();
																														changeTag = 0;
																												}, "");
		} else {
			showGIUTS012();
		}
	});
	
	$("searchStatus").observe("click", function(){
		getBinderStatusLOV();
	});
	
	function getBinderStatusLOV(){
		LOV.show({
			controller: 'UnderwritingLOVController',
			urlParameters: {
				action:		"getBinderStatusLOV"
			},
			title: "List of Binder Status",
			width: 405,
			height: 386,
			draggable: true,
			columnModel: [
				{
					id: "bndrStatCd",
					title: "Status Code",
					width: "100px"
				},
				{
					id: "bndrStatDesc",
					title: "Status Description",
					width: "290px"
				}
			],
			onSelect: function(row){
				if(row != undefined){
					$("txtStatus").value = unescapeHTML2(row.bndrStatDesc);
					changeTag = 1;
				}
			}
		});
	}
	
	$("imgConfirmDate").observe("click", function(){
		if($F("txtLineCd") != ""){
			scwShow($('txtConfirmDate'),this, null);	
		}
	});
	
	$("txtConfirmDate").observe("focus", function(){
		if($F("txtConfirmDate") != $("txtConfirmDate").readAttribute("lastValidValue")){
			changeTag = 1;
			changeTagFunc = updateBinderStatusGIUTS012;
		}
	});
	
	$("imgReleaseDate").observe("click", function(){
		if($F("txtLineCd") != ""){
			scwShow($('txtReleaseDate'),this, null);	
		}
	});
	
	$("txtReleaseDate").observe("focus", function(){
		if($F("txtReleaseDate") != $("txtReleaseDate").readAttribute("lastValidValue")){
			changeTag = 1;
			changeTagFunc = updateBinderStatusGIUTS012;
		}
	});
	
	$("txtReleaseBy").observe("keyup", function(){
		$("txtReleaseBy").value = $("txtReleaseBy").value.toUpperCase();
	});
	
	observeReloadForm("reloadForm", showGIUTS012);
	
	$("btnToolbarExit").observe("click", function(){
		if(changeTag == 1) {
			showConfirmBox4("Confirm", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", saveAndCancel, exit, "");
		} else {
			exit();
		}
	});
	
	$("btnCancel").observe("click", function(){
		if(changeTag == 1) {
			showConfirmBox4("Confirm", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", saveAndCancel, exit, "");
		} else {
			exit();
		}
	});
	
	function saveAndCancel(){
		if($F("txtConfirmNo") != ""){
			if($F("txtConfirmDate") == ""){
				$("txtConfirmDate").value = dateFormat(dateToday, "mm-dd-yyyy");
				$("chkWConfirmation").checked = true;
			}
		} else if($F("txtConfirmDate") != ""){
			if($F("txtConfirmNo") == ""){
				customShowMessageBox("Confirm number must be entered.","I", "txtConfirmNo");
				return;
			}
		}
		
		if($F("txtReleaseDate") != ""){
			if($F("txtReleaseBy") == ""){
				customShowMessageBox("Release by value must be entered.","I", "txtReleaseBy");
				return;
			}
		} else if($F("txtReleaseBy") != ""){
			if($F("txtReleaseDate") == ""){
				customShowMessageBox("Release date must be entered.","I", "txtReleaseDate");
				return;
			}
		}
		
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
		} else {
			exitTag = "Y";
			updateBinderStatusGIUTS012();	
		}
	}
	
	function exit(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);			
	}
	
	$$("div#binderDtlDiv input[type='text']").each(function(element) {
		if(element.id == "txtLineCd"){
			return;
		} else if (element.id == "txtBinderYy"){
			return;
		} else if (element.id == "txtBinderSeqNo"){
			return;
		} else {
		$(element.id).observe("change", function() {
			changeTag = 1;
			changeTagFunc = updateBinderStatusGIUTS012;
			});
		}
	});
	
	changeTag = 0;
	$("txtLineCd").focus();
	$("txtConfirmNo").disabled = true;
	$("txtReleaseBy").disabled = true;
	var dateToday = ignoreDateTime(new Date());
	var fnlBinderId;
	var exitTag = "N";
	disableSearch("searchStatus");
	initializeAll();
	initializeAccordion();
	addStyleToInputs();
	initializeAllMoneyFields();
	$("btnToolbarPrint").hide();
	$("btnToolbarExecuteQuery").hide();
	disableToolbarButton("btnToolbarEnterQuery");
	setModuleId("GIUTS012");
	setDocumentTitle("Update Binder Status");
} catch(e){
	showErrorMessage("Error : " , e);
}
</script>