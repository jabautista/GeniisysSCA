<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss046MainDiv" name="giiss046MainDiv" style="">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Tax Charge Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss028" name="gicls028">		
		<div class="sectionDiv">
			<div style="" align="center" id="lineDiv">
				<table cellspacing="2" border="0" style="margin: 10px auto;">	 			
					<tr>
						<td class="rightAligned" style="" id="">Issue Source</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan required" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required allCaps" type="text" id="txtIssCd" name="txtIssCd" style="width: 40px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="301" lastValidValue="" ignoreDelKey="1"/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIssLOV" name="searchIssLOV" alt="Go" style="float: right;" tabindex="302"/>
							</span>
							<input id="txtIssName" name="txtIssName" type="text" style="width: 220px; height: 15px;" value="" readonly="readonly" tabindex="303" lastValidValue=""/>
						</td>						
						<td style="width: 50px;"></td>
						<td class="rightAligned" style="" id="">Line</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan required" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required allCaps" type="text" id="txtLineCd" name="txtLineCd" style="width: 40px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="304" lastValidValue="" ignoreDelKey="1"/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineLOV" name="searchLineLOV" alt="Go" style="float: right;" tabindex="305"/>
							</span>
							<input id="txtLineName" name="txtLineName" type="text" style="width: 220px; height: 15px;" value="" tabindex="106" readonly="readonly" lastValidValue="" tabindex="306"/>
						</td>	
					</tr>
				</table>			
			</div>		
		</div>
		<div id="giiss028SubDiv" name="giiss028SubDiv">		
			<div class="sectionDiv">
				<div id="taxChargeDiv" style="padding-top: 10px;">
					<div id="taxChargeTable" style="height: 340px; margin-left: 10px;"></div>
				</div>
				<div align="center" id="taxChargeFormDiv" style="width: 620px; float: left; padding-left: 40px;">
					<table style="margin-top: 15px;">
						<td class="rightAligned" style="" id="">Tax Code</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan required" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required integerNoNegativeUnformattedNoComma" type="text" id="txtTaxCd" name="txtTaxCd" style="width: 40px; float: left; border: none; height: 15px; margin: 0; text-align: right;" maxlength="2" tabindex="307" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchTaxCdLOV" name="searchTaxCdLOV" alt="Go" style="float: right;" tabindex="308"/>
							</span>
							<input id="txtTaxDesc" name="txtTaxDesc" type="text" style="width: 441px; height: 15px;" value="" readonly="readonly" tabindex="309" lastValidValue=""/>
						</td>	
						<tr>
							<td width="" class="rightAligned">Function Name</td>
							<td class="leftAligned" colspan="3">
								<input id="txtFunctionName" type="text" class="" style="width: 513px;" maxlength="30" tabindex="310">
							</td>
						</tr>						
						<tr>
							<td class="rightAligned">Sequence</td>
							<td class="leftAligned"><input id="txtSequence" name="code" type="text" class="integerNoNegativeUnformattedNoComma" style="width: 210px; text-align: right;" maxlength="2" tabindex="311"></td>
							<td class="rightAligned" id="forRateType">Rate</td>
							<td class="leftAligned" id="forRate"><input id="txtRate" type="text" class="applyDecimalRegExp required" hasOwnKeyUp="N" hasOwnBlur="N" hasOwnChange="N" customLabel="Rate" max="100.000000000" min="0.000000000" regexppatt="pDeci0309" style="width: 205px; text-align: right;" tabindex="312"></td>
							<td class="rightAligned" id="forAmountType">Amount</td>
							<td class="leftAligned" id="forAmount"><input id="txtTaxAmount" type="text" class="money2" style="width: 205px; text-align: right;" lastValidValue="" tabindex="312"></td>
							<td class="rightAligned" id="forRangeType"></td>
							<td id="forRange"><input type="button" class="button" id="btnRange" value="Range" style="width: 220px;" tabindex="346"></td>
						</tr>	
							<td class="rightAligned">Start Date</td>
							<td class="leftAligned">
								<div id="fromDateDiv" style="float: left; border: 1px solid gray; width: 216px; height: 22px; background-color: #FFFACD;">
									<input id="txtStartDate" type="text" class="required" style="width: 185px; height: 13px; border: none; margin: 0px;" readonly="readonly" tabindex="313" tbgStartDate="" prevStartDate="">
									<img id="imgFromDate" alt="imgFromDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtStartDate'),this, null);" tabindex="314"/>
								</div>
							</td> 
							<td class="rightAligned">End Date</td>
							<td class="leftAligned">
								<div id="fromDateDiv" style="float: left; border: 1px solid gray; width: 211px; height: 22px; background-color: #FFFACD;">
									<input id="txtEndDate" type="text" class="required" style="width: 180px; height: 13px; border: none; margin: 0px;" readonly="readonly" tabindex="315" tbgEndDate="" prevEndDate="">
									<img id="imgToDate" alt="imgToDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtEndDate'),this, null);" tabindex="316"/>
								</div>
							</td> 
						<tr>
							<td class="rightAligned">DR GL Code</td>
							<td class="leftAligned"><input id="txtDrGlCd" name="code" type="text" class="integerNoNegativeUnformattedNoComma" style="width: 210px; text-align: right;" value="" maxlength="3" tabindex="317"></td>
							<td width="" class="rightAligned">CR GL Code</td>
							<td class="leftAligned"><input id="txtCrGlCd" name="code" type="text" class="integerNoNegativeUnformattedNoComma" style="width: 205px; text-align: right;" value="" maxlength="3" tabindex="318"></td>
						</tr>	
						<tr>
							<td class="rightAligned">DR GL Sblvl</td>
							<td class="leftAligned"><input id="txtDrGlSub" name="code" type="text" class="integerNoNegativeUnformattedNoComma" style="width: 210px; text-align: right;" value="" maxlength="2" tabindex="319"></td>
							<td width="" class="rightAligned">CR GL Sblvl</td>
							<td class="leftAligned"><input id="txtCrGlSub" name="code" type="text" class="integerNoNegativeUnformattedNoComma" style="width: 205px; text-align: right;" value="" maxlength="2" tabindex="320"></td>
						</tr>
						<tr>
						<td colspan="4">
							<div>
								<table>
									<tr>
										<td>
											<fieldset id="fsParApplicable" style="width: 180px; height: 100px;">
												<legend>Type of PAR Applicable</legend>
												<table border="0" cellspacing="2" cellpadding="2" >
													<tr>
														<td><input type="radio" id="rdoBoth" name="rdoParApplicable" value="B" style="float: left; margin-left: 13px;" tabindex="321"/></td>
														<td><label for="rdoBoth"> Both</label></td>
													</tr>
													<tr>
														<td><input type="radio" id="rdoPolicy" name="rdoParApplicable" value="P" style="float: left; margin-left: 13px;" tabindex="322"/></td>
														<td><label for="rdoPolicy"> Policy</label></td>
													</tr>
													<tr>
														<td><input type="radio" id="rdoEndt" name="rdoParApplicable" value="E" style="float: left; margin-left: 13px;" tabindex="323"/></td>
														<td><label for="rdoEndt"> Endorsement</label></td>
													</tr>
												</table>
											</fieldset>
										</td>
										<td>
											<fieldset id="fsTakeUp" style="width: 180px; height: 100px;">
												<legend>Take-Up Allocation Tag</legend>
												<table border="0" cellspacing="2" cellpadding="2" >
													<tr>
														<td><input type="radio" id="rdoFirst" name="rdoTakeUp" title="Report Date" value="F" style="float: left; margin-left: 13px;" tabindex="324"/></td>
														<td><label for="rdoFirst"> First</label></td>
													</tr>
													<tr>
														<td><input type="radio" id="rdoSpread" name="rdoTakeUp" title="Report Date" value="S" style="float: left; margin-left: 13px;" tabindex="325"/></td>
														<td><label for="rdoSpread"> Spread</label></td>
													</tr>
													<tr>
														<td><input type="radio" id="rdoLast" name="rdoTakeUp" title="Report Date" value="L" style="float: left; margin-left: 13px;" tabindex="326"/></td>
														<td><label for="rdoLast"> Last</label></td>
													</tr>
												</table>
											</fieldset>
										</td>
										<td>
											<fieldset id="fsAllocTag" style="width: 180px; height: 100px;">
												<legend>Installment Allocation Tag</legend>
												<table border="0" cellspacing="2" cellpadding="2" >
													<tr>
														<td><input type="radio" id="rdoAllocNone" name="rdoAllocTag" title="Report Date" value="N" style="float: left; margin-left: 13px;" tabindex="327"/></td>
														<td><label for="rdoAllocNone"> None</label></td>
													</tr>
													<tr>
														<td><input type="radio" id="rdoAllocFirst" name="rdoAllocTag" title="Report Date" value="F" style="float: left; margin-left: 13px;" tabindex="328"/></td>
														<td><label for="rdoAllocFirst"> First</label></td>
													</tr>
													<tr>
														<td><input type="radio" id="rdoAllocSpread" name="rdoAllocTag" title="Report Date" value="S" style="float: left; margin-left: 13px;" tabindex="329"/></td>
														<td><label for="rdoAllocSpread"> Spread</label></td>
													</tr>
													<tr>
														<td><input type="radio" id="rdoAllocLast" name="rdoAllocTag" title="Report Date" value="L" style="float: left; margin-left: 13px;" tabindex="330"/></td>
														<td><label for="rdoAllocLast"> Last</label></td>
													</tr>
												</table>
											</fieldset>
										</td>
									</tr>
								</table>
							</div>
						</td>
					</tr>
					</table>
				</div>
				<div id="checkBoxDiv" style="margin: 20px; width: 200px; height: 292px;" align="center" class="sectionDiv"> <!-- modified height by robert GENQA 4844 08.10.15 -->
					<div style="margin: 10px; margin-bottom: 2px; width: 180px; height: 245px;" align="center" class="sectionDiv"> <!-- modified height by robert GENQA 4844 08.10.15 -->
						<table style="margin-top: 5px;">
							<tr height="30">
							<td colspan="2">
							<select id="dDnTaxType" name="dDnTaxType" style="text-align: left; width: 150px;" tabindex="331">
								<option value="R">Fixed Rate</option>
								<option value="A">Fixed Amount</option>
								<option value="N">Range</option>
	 						</select>
							</td>
							</tr>
							<tr height="20">
								<td>
									<input id="chkWithoutRate" type="checkbox" style="height: 13px; float: right;" name="chkWithoutRate" tabindex="332">
								</td>
								<td>
									<label for="chkWithoutRate" title="Without Rate">Without Rate</label>
								</td>
							</tr>
							<tr height="20">
								<td>
									<input id="chkPremium" type="checkbox" style="height: 13px; float: right;" name="chkPremium" tabindex="333">
								</td>
								<td>
									<label for="chkPremium" title="Premium">Premium</label>
								</td>
							</tr>
							<tr height="20">
								<td>
									<input id="chkRequired" type="checkbox" style="height: 13px; float: right;" name="chkRequired" tabindex="334">
								</td>
								<td>
									<label for="chkRequired" title="Required">Required</label>
								</td>
							</tr>
							<tr height="20">
								<td>
									<input id="chkExpired" type="checkbox" style="height: 13px; float: right;" name="chkExpired" tabindex="335">
								</td>
								<td>
									<label for="chkExpired" title="Expired">Expired</label>
								</td>
							</tr>
							<tr height="20">
								<td>
									<input id="chkPerilDependent" type="checkbox" style="height: 13px; float: right;" name="chkPerilDependent" tabindex="336">
								</td>
								<td>
									<label for="chkPerilDependent" title="Peril Dependent">Peril Dependent</label>
								</td>
							</tr>
							<tr height="20">
								<td>
									<input id="chkIssueDate" type="checkbox" style="height: 13px; float: right;" name="chkIssueDate" tabindex="337">
								</td>
								<td>
									<label for="chkIssueDate" title="Issue Date">Issue Date</label>
								</td>
							</tr>
							<tr height="20">
								<td>
									<input id="chkCocCharges" type="checkbox" style="height: 13px; float: right;" name="chkCocCharges" tabindex="338">
								</td>
								<td>
									<label for="chkCocCharges" title="COC Charges">COC Charges</label>
								</td>
							</tr>
							<!-- added by robert GENQA 4844 08.10.15 -->
							<tr height="20">
								<td>
									<input id="chkRefundSw" type="checkbox" style="height: 13px; float: right;" name="chkRefundSw" tabindex="339">
								</td>
								<td>
									<label for="chkRefundSw" title="Refund">Refund</label>
								</td>
							</tr>
							<!-- end robert GENQA 4844 08.10.15 -->
							<tr height="20"> <!-- modified height by robert GENQA 4844 08.10.15 -->
								<td colspan="2" align="center">
									<input type="button" class="button" id="btnTaxPeril" value="Tax Peril" style="width: 150px;" tabindex="339">
								</td>
							</tr>
						</table>
					</div>
					<table>
						<tr>
							<td colspan="2" align="center">
								<input type="button" class="button" id="btnRatePerPlace" value="Rate per Place of Issuance" tabindex="340">
							</td>
						</tr>
					</table>
				</div>
				<div id="remarksFields" style="margin-top: 335px;" align="center">
					<table>
						<tr>
							<td width="" class="rightAligned">Remarks</td>
							<td class="leftAligned" colspan="3">
								<div id="remarksDiv" name="remarksDiv" style="float: left; width: 593px; border: 1px solid gray; height: 22px;">
									<textarea style="float: left; height: 16px; width: 565px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="341"></textarea>
									<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="342"/>
								</div>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">User ID</td>
							<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 250px;" readonly="readonly" tabindex="343"></td>
							<td width="" class="rightAligned">Last Update</td>
							<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 250px;" readonly="readonly" tabindex="344"></td>
						</tr>	
					</table>	
				</div>
				<div style="margin-top: 10px; margin-bottom: 10px;" align="center">
					<table>
						<tr>
							<td>
								<input type="button" class="button" id="btnAdd" value="Add" tabindex="345">
							</td>
							<td>
								<input type="button" class="button" id="btnDelete" value="Delete" tabindex="346">
							</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="347">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="348">
</div>

<script type="text/javascript">
	setModuleId("GIISS028");
	setDocumentTitle("Tax Charge Maintenance");
	initializeAll();
	initializeAccordion();
	initializeAllMoneyFields();
	makeInputFieldUpperCase();
	changeTag = 0;
	var rowIndex = -1;
	taxId = null;
	taxCd = null;
	fundCd = "";
	lastValidFundCd  = "";
	var parApplicable = "B";
	var takeUp = "F";
	var installAlloc = "N";
	objGIISS028 = {};
	var valSequence = null;
	var valOnCheck = "N";
	var valOnUpdateExp = false;
	var executeQuery = false;
	var changed = false;
	
	function saveGiiss028() {
		if (changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgTaxCharge.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgTaxCharge.geniisysRows);
		new Ajax.Request(contextPath + "/GIISTaxChargesController", {
			method : "POST",
			parameters : {
				action : "saveGiiss028",
				setRows : prepareJsonAsParameter(setRows),
				delRows : prepareJsonAsParameter(delRows)
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete : function(response) {
				hideNotice();
				if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)) {
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function() {
						if (objGIISS028.exitPage != null) {
							objGIISS028.exitPage();
							objGIISS028.exitPage = null;
						} else {
							tbgTaxCharge._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}

	observeReloadForm("reloadForm", showGiiss028);
	
	var objTaxCharge = null;
	objGIISS028.taxChargeList = JSON.parse('${jsonTaxChargesList}');
	objGIISS028.exitPage = null;

	var taxChargeTable = {
		url : contextPath + "/GIISTaxChargesController?action=showGiiss028&refresh=1",
		options : {
			width : '900px',
			hideColumnChildTitle : true,
			pager : {},
			onCellFocus : function(element, value, x, y, id) {
				rowIndex = y;
				objTaxCharge = tbgTaxCharge.geniisysRows[y];
				//setFieldValues(objTaxCharge);
				tbgTaxCharge.keys.removeFocus(tbgTaxCharge.keys._nCurrentFocus, true);
				tbgTaxCharge.keys.releaseKeys();
				$("txtTaxDesc").focus();
				onFocus();
			},
			onRemoveRowFocus : function() {
				rowIndex = -1;
				ifExpired(false);
				setFieldValues(null);
				tbgTaxCharge.keys.removeFocus(tbgTaxCharge.keys._nCurrentFocus, true);
				tbgTaxCharge.keys.releaseKeys();
				$("txtTaxCd").focus();
				//$("txtSequence").value = formatNumberDigits(maxSequence,2);
			},
			toolbar : {
				elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
				onFilter : function() {
					if (executeQuery) {
						rowIndex = -1;
						ifExpired(false);
						setFieldValues(null);
					}
					tbgTaxCharge.keys.removeFocus(tbgTaxCharge.keys._nCurrentFocus, true);
					tbgTaxCharge.keys.releaseKeys();
				}
			},
			beforeSort : function() {
				if (changeTag == 1) {
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function() {
						$("btnSave").focus();
					});
					return false;
				}
			},
			onSort : function() {
				if (executeQuery) {
					rowIndex = -1;
					ifExpired(false);
					setFieldValues(null);	
				}
				tbgTaxCharge.keys.removeFocus(tbgTaxCharge.keys._nCurrentFocus, true);
				tbgTaxCharge.keys.releaseKeys();
			},
			onRefresh : function() {
				if (executeQuery) {
					rowIndex = -1;
					ifExpired(false);
					setFieldValues(null);
				}
				tbgTaxCharge.keys.removeFocus(tbgTaxCharge.keys._nCurrentFocus, true);
				tbgTaxCharge.keys.releaseKeys();
			},
			prePager : function() {
				if (changeTag == 1) {
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function() {
						$("btnSave").focus();
					});
					return false;
				}
				rowIndex = -1;
				ifExpired(false);
				setFieldValues(null);
				tbgTaxCharge.keys.removeFocus(tbgTaxCharge.keys._nCurrentFocus, true);
				tbgTaxCharge.keys.releaseKeys();
			},
			checkChanges : function() {
				return (changeTag == 1 ? true : false);
			},
			masterDetailRequireSaving : function() {
				return (changeTag == 1 ? true : false);
			},
			masterDetailValidation : function() {
				return (changeTag == 1 ? true : false);
			},
			masterDetail : function() {
				return (changeTag == 1 ? true : false);
			},
			masterDetailSaveFunc : function() {
				return (changeTag == 1 ? true : false);
			},
			masterDetailNoFunc : function() {
				return (changeTag == 1 ? true : false);
			}
		},
		columnModel : [ { 
			id : 'recordStatus',
			width : '0',
			visible : false
		}, {
			id : 'divCtrId',
			width : '0',
			visible : false
		}, {
			id: 'noRateTag',
	    	title: 'W',
	    	width: '23px',
        	align: 'center',
        	altTitle : 'Without Rate',
			titleAlign: 'center',
			sortable : true,
			filterOption : true,
			filterOptionType: 'checkbox',
			editor : new MyTableGrid.CellCheckbox({getValueOf : function(value) {
					if (value) {
						return "Y";
					} else {
						return "N";
					}
				}
			})
	    }, {
			id: 'includeTag',
	    	title: 'P',
	    	width: '23px',
        	align: 'center',
        	altTitle : 'Premium',
			titleAlign: 'center',
			sortable : true,
			filterOption : true,
			filterOptionType: 'checkbox',
			editor : new MyTableGrid.CellCheckbox({getValueOf : function(value) {
					if (value) {
						return "Y";
					} else {
						return "N";
					}
				}
			})
	    }, {
			id: 'primarySw',
	    	title: 'R',
	    	width: '23px',
        	align: 'center',
        	altTitle : 'Required',
			titleAlign: 'center',
			sortable : true,
			filterOption : true,
			filterOptionType: 'checkbox',
			editor : new MyTableGrid.CellCheckbox({getValueOf : function(value) {
					if (value) {
						return "Y";
					} else {
						return "N";
					}
				}
			})
	    }, {
			id: 'expiredSw',
	    	title: 'E',
	    	width: '23px',
        	align: 'center',
        	altTitle : 'Expired',
			titleAlign: 'center',
			sortable : true,
			filterOption : true,
			filterOptionType: 'checkbox',
			editor : new MyTableGrid.CellCheckbox({getValueOf : function(value) {
					if (value) {
						return "Y";
					} else {
						return "N";
					}
				}
			})
	    }, {
			id: 'perilSw',
	    	title: 'D',
	    	width: '23px',
        	align: 'center',
        	altTitle : 'Peril Dependent',
			titleAlign: 'center',
			sortable : true,
			filterOption : true,
			filterOptionType: 'checkbox',
			editor : new MyTableGrid.CellCheckbox({getValueOf : function(value) {
					if (value) {
						return "Y";
					} else {
						return "N";
					}
				}
			})
	    }, {
			id: 'issueDateTag',
	    	title: 'I',
	    	width: '23px',
        	align: 'center',
        	altTitle : 'Issue Date',
			titleAlign: 'center',
			sortable : true,
			filterOption : true,
			filterOptionType: 'checkbox',
			editor : new MyTableGrid.CellCheckbox({getValueOf : function(value) {
					if (value) {
						return "Y";
					} else {
						return "N";
					}
				}
			})
	    }, {
			id: 'cocCharge',
	    	title: 'C',
	    	width: '23px',
        	align: 'center',
        	altTitle : 'COC Charges',
			titleAlign: 'center',
			sortable : true,
			filterOption : true,
			filterOptionType: 'checkbox',
			editor : new MyTableGrid.CellCheckbox({getValueOf : function(value) {
					if (value) {
						return "Y";
					} else {
						return "N";
					}
				}
			})
	    }, {
			//added by robert GENQA 4844 08.10.15
	    	id: 'refundSw',
	    	title: 'R',
	    	width: '23px',
        	align: 'center',
        	altTitle : 'Refund',
			titleAlign: 'center',
			sortable : true,
			filterOption : true,
			filterOptionType: 'checkbox',
			editor : new MyTableGrid.CellCheckbox({getValueOf : function(value) {
					if (value) {
						return "Y";
					} else {
						return "N";
					}
				}
			})
	    }, {
	    //end robert GENQA 4844 08.10.15
			id : "taxCd",
			title : "Tax Code",
			filterOption : true,
			filterOptionType : 'integerNoNegative',
			align : 'right',
			titleAlign : 'right',
			width : '100px',
			renderer: function(value) {
			  	return formatNumberDigits(value, 2);
	   		 }
		}, {
			id : 'taxDesc',
			filterOption : true,
			title : 'Tax Description',
			width : '250px'
		},  {
			id : "sequence",
			title : "Sequence",
			filterOption : true,
			filterOptionType : 'integerNoNegative',
			align : 'right',
			titleAlign : 'right',
			width : '100px',
			renderer: function(value) {
			  	return value == "" ? "" : formatNumberDigits(value, 2);
	   		 }
		},  {
			id : 'effStartDate',
			filterOption : true,
			filterOptionType : 'formattedDate',
			title : 'Start Date',
			width : '120px',
			align : 'center',
			titleAlign : 'center'
		},  {
			id : 'effEndDate',
			filterOption : true,
			filterOptionType : 'formattedDate',
			title : 'End Date',
			width : '120x',
			align : 'center',
			titleAlign : 'center'
		}],
		rows : objGIISS028.taxChargeList.rows
	};

	tbgTaxCharge = new MyTableGrid(taxChargeTable);
	tbgTaxCharge.pager = objGIISS028.taxChargeList;
	tbgTaxCharge.render("taxChargeTable");
	tbgTaxCharge.afterRender = function() {
		if(tbgTaxCharge.geniisysRows.length > 0){
			var rec = tbgTaxCharge.geniisysRows[0];
			maxSequence = rec.maxSequence;
			maxMaxValue = rec.maxMaxValue;
			if (tbgTaxCharge.geniisysRows[0].sequence != null) {
				$("txtSequence").value = formatNumberDigits(maxSequence,2);
			}else {
				$("txtSequence").value = formatNumberDigits(maxSequence+1,2);
			}
		}
	};
	
	
	function showLineLOV(isIconClicked) {
		try {
			var searchString = isIconClicked ? "%" : ($F("txtLineCd").trim() == "" ? "%" : $F("txtLineCd"));

			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGiiss028LineLOV",
					searchString : unescapeHTML2(searchString),
					issCd : unescapeHTML2($F("txtIssCd")),
					moduleId : "GIISS028"
				},
				title : "List of Lines",
				width : 450,
				height : 386,
				columnModel : [ {
					id : "lineCd",
					title : "Line Code",
					width : '123px'
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
						$("txtLineCd").value = unescapeHTML2(row.lineCd);
						$("txtLineCd").setAttribute("lastValidValue", unescapeHTML2(row.lineCd));
						$("txtLineName").value = unescapeHTML2(row.lineName);
						$("txtLineName").setAttribute("lastValidValue", unescapeHTML2(row.lineName));
						enableToolbarButton("btnToolbarExecuteQuery");
						enableToolbarButton("btnToolbarEnterQuery"); 
					}
				},
				onCancel : function() {
					$("txtLineCd").focus();
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
					$("txtLineName").value = $("txtLineName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function() {
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
					$("txtLineName").value = $("txtLineName").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtLineCd");
				}
			});
		} catch (e) {
			showErrorMessage("showLineLOV", e);
		}
	}
	
	$("searchLineLOV").observe("click", function() {
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
			disableToolbarButton("btnToolbarExecuteQuery");
		}
	});
	
	function showIssLOV(isIconClicked) {
		try {
			var searchString = isIconClicked ? "%" : ($F("txtIssCd").trim() == "" ? "%" : $F("txtIssCd"));

			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGiiss028IssLOV",
					searchString : unescapeHTML2(searchString),
					lineCd : unescapeHTML2($F("txtLineCd")),
					moduleId : "GIISS028"
				},
				title : "List of Issue Sources",
				width : 450,
				height : 386,
				columnModel : [ {
					id : "issCd",
					title : "Issue Code",
					width : '123px'
				}, {
					id : "issName",
					title : "Issue Name",
					width : '310px'
				}, {
					id : "fundCd",
					width : '0px',
					visible : false
				} ],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : escapeHTML2(searchString),
				onSelect : function(row) {
					if (row != null || row != undefined) {
						$("txtIssCd").value = unescapeHTML2(row.issCd);
						$("txtIssCd").setAttribute("lastValidValue", unescapeHTML2(row.issCd));
						$("txtIssName").value = unescapeHTML2(row.issName);
						$("txtIssName").setAttribute("lastValidValue", unescapeHTML2(row.issName));
						fundCd = unescapeHTML2(row.fundCd);
						lastValidFundCd = unescapeHTML2(row.fundCd);
						enableSearch("searchLineLOV");
						$("txtLineCd").disabled = false;
						$("txtLineCd").value = "";
						$("txtLineCd").setAttribute("lastValidValue", "");
						$("txtLineName").value = "";
						$("txtLineName").setAttribute("lastValidValue", "");
						$("txtLineCd").focus();
						enableToolbarButton("btnToolbarEnterQuery");
						disableToolbarButton("btnToolbarExecuteQuery");
					}
				},
				onCancel : function() {
					$("txtIssCd").focus();
					$("txtIssCd").value = $("txtIssCd").readAttribute("lastValidValue");
					$("txtIssName").value = $("txtIssName").readAttribute("lastValidValue");
					fundCd = lastValidFundCd;
				},
				onUndefinedRow : function() {
					$("txtIssCd").value = $("txtIssCd").readAttribute("lastValidValue");
					$("txtIssName").value = $("txtIssName").readAttribute("lastValidValue");
					fundCd = lastValidFundCd;
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtIssCd");
				}
			});
		} catch (e) {
			showErrorMessage("showIssLOV", e);
		}
	}
	
	$("searchIssLOV").observe("click", function() {
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
			$("txtLineCd").value = "";
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtLineName").value = "";
			$("txtLineName").setAttribute("lastValidValue", "");
			disableToolbarButton("btnToolbarExecuteQuery");
			disableToolbarButton("btnToolbarEnterQuery");
			disableSearch("searchLineLOV");
			$("txtLineCd").disabled = true;
			fundCd = "";
			lastValidFundCd = "";
		}
	});
	
	function showTaxLOV(isIconClicked) {
		try {
			var searchString = isIconClicked ? "%" : ($F("txtTaxCd").trim() == "" ? "%" : $F("txtTaxCd"));

			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGiiss028TaxLOV",
					searchString : searchString + "%",
					fundCd : fundCd
				},
				title : "List of Taxes",
				width : 520,
				height : 386,
				columnModel : [ {
					id : "taxCd",
					title : "Tax Code",
					width : '98px',
					align : 'right',
					titleAlign : 'right',
					renderer: function(value) {
					  	return value == "" ? "" : formatNumberDigits(value, 2);
			   		 }
				}, {
					id : "taxName",
					title : "Tax Name",
					width : '325px'
				}, {
					id : "taxType",
					title : "Tax Type",
					width : '80px'
				} ],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : escapeHTML2(searchString),
				onSelect : function(row) {
					if (row != null || row != undefined) {
						var valTaxCd = row.taxCd;
						new Ajax.Request(contextPath + "/GIISTaxChargesController", {
							parameters : {
								action : "valAddRec",
								lineCd : unescapeHTML2($F("txtLineCd")),
								issCd : unescapeHTML2($F("txtIssCd")),
								taxCd : valTaxCd
							},
							onCreate : showNotice("Processing, please wait..."),
							onComplete : function(response) {
								hideNotice();
								function populateFields(){
									$("txtTaxCd").value = formatNumberDigits(unescapeHTML2(row.taxCd),2);
									$("txtTaxCd").setAttribute("lastValidValue", formatNumberDigits(row.taxCd,2));
									$("txtTaxDesc").value = unescapeHTML2(row.taxName);
									$("txtTaxDesc").setAttribute("lastValidValue", unescapeHTML2(row.taxName));
									$("txtStartDate").value = "";
									$("txtEndDate").value = "";
									$("chkExpired").checked = false;
								}
								checkTax = false;
								for(var i=0; i<tbgTaxCharge.geniisysRows.length; i++){
									if(tbgTaxCharge.geniisysRows[i].recordStatus == 0 || tbgTaxCharge.geniisysRows[i].recordStatus == 1){	
										if(tbgTaxCharge.geniisysRows[i].taxCd == unescapeHTML2(row.taxCd) && tbgTaxCharge.geniisysRows[i].expiredSw != "Y"){
											checkTax = true;
										}	
									}
								}
								if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
									if(response.responseText == 1 || checkTax){
										showConfirmBox3("CONFIRMATION", "The former tax with this tax code has not yet been tagged as expired. Are you sure you want to create another tax record with the same tax code?", "Yes", "No", 
											populateFields,
											function(){
												$("txtTaxCd").value = "";
												$("txtTaxCd").setAttribute("lastValidValue", "");
												$("txtTaxDesc").value = "";
												$("txtTaxDesc").setAttribute("lastValidValue", "");
										});
									}else{
										populateFields();
									}
								}
							}
						});
					}
				},
				onCancel : function() {
					$("txtTaxCd").focus();
					$("txtTaxCd").value = $("txtTaxCd").readAttribute("lastValidValue");
					$("txtTaxDesc").value = $("txtTaxDesc").readAttribute("lastValidValue");
				},
				onUndefinedRow : function() {
					$("txtTaxCd").value = $("txtTaxCd").readAttribute("lastValidValue");
					$("txtTaxDesc").value = $("txtTaxDesc").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtTaxCd");
				}
			});
		} catch (e) {
			showErrorMessage("showTaxLOV", e);
		}
	}
	
	$("searchTaxCdLOV").observe("click", function() {
		showTaxLOV(true);
	});

	$("txtTaxCd").observe("change", function() {
		if (this.value != "") {
			showTaxLOV(false);
		} else {
			$("txtTaxCd").value = "";
			$("txtTaxCd").setAttribute("lastValidValue", "");
			$("txtTaxDesc").value = "";
			$("txtTaxDesc").setAttribute("lastValidValue", "");
			//disableToolbarButton("btnToolbarExecuteQuery");
		}
	});
	
	maxSequence = "";
	maxTaxId = "";
	
	function setFieldValues(rec) {
		try {
			valSequence = rec == null ? "" : rec.sequence;
			taxCd 							= (rec == null ? "" : rec.taxCd);
			$("txtTaxCd").value 			= (rec == null ? "" : formatNumberDigits(rec.taxCd, 2));
			$("txtTaxDesc").value 			= (rec == null ? "" : unescapeHTML2(rec.taxDesc));
			$("txtFunctionName").value 		= (rec == null ? "" : unescapeHTML2(rec.functionName));
			$("txtSequence").value 			= (rec == null ? (tbgTaxCharge.geniisysRows.length == 0 ? formatNumberDigits(maxSequence+1, 2) : formatNumberDigits(maxSequence, 2))  : rec.sequence == null ? "" : formatNumberDigits(rec.sequence, 2));
			$("txtRate").value 				= (rec == null ? formatToNineDecimal(0) : formatToNineDecimal(rec.rate)); 
			$("txtTaxAmount").value 		= (rec == null ? "" : formatCurrency(rec.taxAmount));
			$("txtStartDate").value 		= (rec == null ? "" : unescapeHTML2(rec.effStartDate));
			$("txtEndDate").value 			= (rec == null ? "" : unescapeHTML2(rec.effEndDate));
			$("txtDrGlCd").value 			= (rec == null ? "" : rec.drGlCd == null ? "" : rec.drGlCd == "" ? "" : formatNumberDigits(rec.drGlCd, 3));	
			$("txtCrGlCd").value 			= (rec == null ? "" : rec.crGlCd == null ? "" : rec.crGlCd == "" ? "" : formatNumberDigits(rec.crGlCd, 3));
			$("txtDrGlSub").value 			= (rec == null ? "" : rec.drSub1 == null ? "" : rec.drSub1 == "" ? "" : formatNumberDigits(rec.drSub1, 2));
			$("txtCrGlSub").value 			= (rec == null ? "" : rec.crSub1 == null ? "" : rec.crSub1 == "" ? "" :formatNumberDigits(rec.crSub1, 2));
			$("chkWithoutRate").checked 	= (rec == null ? "" : rec.noRateTag == 'Y' ? true : false);
			$("chkPremium").checked 		= (rec == null ? "" : rec.includeTag == 'Y' ? true : false);
			$("chkRequired").checked 		= (rec == null ? "" : rec.primarySw == 'Y' ? true : false);
			$("chkExpired").checked 		= (rec == null ? "" : rec.expiredSw == 'Y' ? true : false);
			$("chkPerilDependent").checked 	= (rec == null ? "" : rec.perilSw == 'Y' ? true : false);
			$("chkIssueDate").checked 		= (rec == null ? "" : rec.issueDateTag == 'Y' ? true : false);
			$("chkCocCharges").checked 		= (rec == null ? "" : rec.cocCharge == 'Y' ? true : false);
			$("chkRefundSw").checked 		= (rec == null ? "" : rec.refundSw == 'Y' ? true : false); //added by robert GENQA 4844 08.10.15
			$("dDnTaxType").value 			= (rec == null ? "R" : rec.taxType);
			$("rdoBoth").checked 			= (rec == null ? true : rec.polEndtSw == 'B' ? true : false);
			$("rdoPolicy").checked 			= (rec == null ? "" : rec.polEndtSw == 'P' ? true : false);
			$("rdoEndt").checked 			= (rec == null ? "" : rec.polEndtSw == 'E' ? true : false);
			$("rdoFirst").checked 			= (rec == null ? true : rec.takeupAllocTag == 'F' ? true : false);
			$("rdoSpread").checked 			= (rec == null ? "" : rec.takeupAllocTag == 'S' ? true : false);
			$("rdoLast").checked 			= (rec == null ? "" : rec.takeupAllocTag == 'L' ? true : false);
			$("rdoAllocNone").checked 		= (rec == null ? true : rec.allocationTag == 'N' ? true : false);
			$("rdoAllocFirst").checked 		= (rec == null ? "" : rec.allocationTag == 'F' ? true : false);
			$("rdoAllocSpread").checked 	= (rec == null ? "" : rec.allocationTag == 'S' ? true : false);
			$("rdoAllocLast").checked 		= (rec == null ? "" : rec.allocationTag == 'L' ? true : false);
			$("txtUserId").value 			= (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value 		= (rec == null ? "" : rec.strLastUpdate);
			$("txtRemarks").value 			= (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			$("txtTaxCd").setAttribute("lastValidValue", 	(rec == null ? "" : rec.taxCd));
			$("txtStartDate").setAttribute("prevStartDate", (rec == null ? "" : rec.effStartDate));
			$("txtEndDate").setAttribute("prevEndDate", 	(rec == null ? "" : rec.effEndDate));

			taxId = (rec == null ? maxTaxId : rec.taxId);
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? enableButton("btnAdd") : enableButton("btnAdd");
			rec == null ? $("txtTaxCd").readOnly = false : $("txtTaxCd").readOnly = true;
			rec == null ? $("txtFunctionName").readOnly = false : $("txtFunctionName").readOnly = true;
			rec == null ? $("txtRate").readOnly = false : rec.strExists == "Y" ? $("txtRate").readOnly = true : $("txtRate").readOnly = false;
			rec == null ? $("txtTaxAmount").readOnly = false : rec.strExists == "Y" ? $("txtTaxAmount").readOnly = true : $("txtTaxAmount").readOnly = false;
			rec == null ? $("txtDrGlCd").readOnly = false : $("txtDrGlCd").readOnly = true;
			rec == null ? $("txtCrGlCd").readOnly = false : $("txtCrGlCd").readOnly = true;
			rec == null ? $("txtDrGlSub").readOnly = false : $("txtDrGlSub").readOnly = true;
			rec == null ? $("txtCrGlSub").readOnly = false : $("txtCrGlSub").readOnly = true;
			rec == null ? $("dDnTaxType").disabled = false : rec.strExists == "Y" ? $("dDnTaxType").disabled = true : $("dDnTaxType").disabled = false;
			rec == null ? $("txtRate").addClassName("required") : $("txtRate").removeClassName("required");
			valOnCheck = rec == null ? "N" : rec.issueDateTag == 'Y' ? "I" : rec.primarySw == 'Y' ? "R" : "N";
			;
			if(rec == null){
				$("txtTaxCd").setAttribute("lastValidValue", "");
				$("txtTaxDesc").setAttribute("lastValidValue", "");
			}
			
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			$("chkPerilDependent").checked != true ? disableButton("btnTaxPeril") : (rec.newRecord!= "Y"? enableButton("btnTaxPeril"):disableButton("btnTaxPeril"));
			//rec == null ? disableButton("btnRatePerPlace") : enableButton("btnRatePerPlace");
			rec == null ? enableSearch("searchTaxCdLOV") : disableSearch("searchTaxCdLOV");
			rec == null ? $("txtTaxAmount").setAttribute("lastValidValue", "") : $("txtTaxAmount").setAttribute("lastValidValue", formatCurrency(rec.taxAmount));
			//added by robert 01.30.2015 to reset values of variables 
			parApplicable 	= (rec == null ? "B" : rec.polEndtSw); 
			takeUp 			= (rec == null ? "F" : rec.takeupAllocTag);
			installAlloc 	= (rec == null ? "N" : rec.allocationTag);
			
			taxTypeFunc();
			objTaxCharge = rec;
		} catch (e) {
			showErrorMessage("setFieldValues", e);
		}
	}

	
	function onFocus(){
		if(objTaxCharge.expiredSw == "Y"){
			setFieldValues(objTaxCharge);
			ifExpired(true);
			disableButton("btnTaxPeril");
			disableButton("btnRatePerPlace");
			disableButton("btnTaxPeril");
			disableButton("btnAdd");
			disableButton("btnDelete");
			disableDate("imgFromDate");
			disableDate("imgToDate");
		}else{
			enableDate("imgFromDate");
			enableDate("imgToDate");
			enableButton("btnTaxPeril");
			enableButton("btnRatePerPlace");
			enableButton("btnTaxPeril");
			enableButton("btnAdd");
			enableButton("btnDelete");
			ifExpired(false);
			setFieldValues(objTaxCharge);
			onRowClick(objTaxCharge);
		}
	}
	
	function ifExpired(toggle){
		$$("div#taxChargeFormDiv input[type='text'], div#checkBoxDiv input[type='text'], div#remarksFields input[type='text']").each(function(btn) {
			if(btn.id == "txtTaxDesc" || btn.id == "txtStartDate" || btn.id == "txtEndDate" || btn.id == "txtUserId" || btn.id == "txtLastUpdate"){
				btn.readOnly = true;
			}else{
				btn.readOnly = toggle;	
			}
		});
		$$("div#taxChargeFormDiv input[type='radio'], div#checkBoxDiv input[type='radio'], div#remarksFields input[type='radio']").each(function(btn) {
			btn.disabled = toggle;
		});
		$$("div#taxChargeFormDiv input[type='checkbox'], div#checkBoxDiv input[type='checkbox'], div#remarksFields input[type='checkbox']").each(function(btn) {
			btn.disabled = toggle;
		});
		$$("div#taxChargeFormDiv textArea, div#checkBoxDiv textArea, div#remarksFields textArea").each(function(btn) {
			btn.readOnly = toggle;
		});
		enableDate("imgFromDate");
		enableDate("imgToDate");
	}
	
	$$("input[name='rdoParApplicable']").each(function(rdo) {
		rdo.observe("click", function() {
			parApplicable = $F(rdo);
		});
	});
	
	$$("input[name='rdoTakeUp']").each(function(rdo) {
		rdo.observe("click", function() {
			takeUp = $F(rdo);
		});
	});
	
	$$("input[name='rdoAllocTag']").each(function(rdo) {
		rdo.observe("click", function() {
			installAlloc = $F(rdo);
		});
	});
	
    function setRec(rec) {
		try {
			var obj = (rec == null ? {} : rec);
			obj.issCd 			= $F("txtIssCd");
			obj.lineCd 			= escapeHTML2($F("txtLineCd"));
			obj.taxCd 			= $F("txtTaxCd");
			obj.taxDesc 		= escapeHTML2($F("txtTaxDesc"));
			obj.functionName 	= escapeHTML2($F("txtFunctionName"));
			obj.sequence 		= $F("txtSequence") == "" ? null : $F("txtSequence");
			obj.rate 			= $F("txtRate");
			obj.taxAmount 		= $F("txtTaxAmount");
			obj.effStartDate 	= escapeHTML2($F("txtStartDate"));
			obj.effEndDate 		= escapeHTML2($F("txtEndDate"));
			obj.drGlCd 			= $F("txtDrGlCd");
			obj.crGlCd 			= $F("txtCrGlCd");
			obj.drSub1 			= $F("txtDrGlSub");
			obj.crSub1 			= $F("txtCrGlSub");
			obj.noRateTag 		= $("chkWithoutRate").checked ? "Y" : "N";
			obj.includeTag 		= $("chkPremium").checked ? "Y" : "N";
			obj.primarySw 		= $("chkRequired").checked ? "Y" : "N";
			obj.expiredSw 		= $("chkExpired").checked ? "Y" : "N";
			obj.perilSw 		= $("chkPerilDependent").checked ? "Y" : "N";
			obj.issueDateTag 	= $("chkIssueDate").checked ? "Y" : "N";
			obj.cocCharge 		= $("chkCocCharges").checked ? "Y" : "N";
			obj.refundSw 		= $("chkRefundSw").checked ? "Y" : "N"; //added by robert GENQA 4844 08.10.15
			obj.taxType 		= $F("dDnTaxType");
			obj.polEndtSw 		= parApplicable;
			obj.takeupAllocTag 	= takeUp;
			obj.allocationTag 	= installAlloc;
			obj.taxId 			= taxId;
			obj.remarks 		= escapeHTML2($F("txtRemarks"));
			obj.userId 			= userId;
			var lastUpdate = new Date();
			obj.strLastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			obj.newRecord = ($F("btnAdd")=="Add" ? "Y" : (rec.newRecord==""? "": rec.newRecord));
			
			return obj;
		} catch (e) {
			showErrorMessage("setRec", e);
		}
	}

	function addRec() {
		try {
			changeTagFunc = saveGiiss028;
			var tax = setRec(objTaxCharge);
			function onAdd(){
				if ($F("btnAdd") == "Add") {
					tbgTaxCharge.addBottomRow(tax);
					maxSequence = maxSequence + 1;
				} else {
					tbgTaxCharge.updateVisibleRowOnly(tax, rowIndex, false);
				}
				changeTag = 1;
				setFieldValues(null);
				tbgTaxCharge.keys.removeFocus(tbgTaxCharge.keys._nCurrentFocus, true);
				tbgTaxCharge.keys.releaseKeys();
				valOnUpdateExp = false;
			}
			if(valOnUpdateExp){
				showConfirmBox3("CONFIRMATION", "Do you wish to commit the record you tag as expired?", "Yes", "No", 
						onAdd,null);
			}else{
				onAdd();
			}
		} catch (e) {
			showErrorMessage("addRec", e);
		}
	} 
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("taxChargeFormDiv")){
				if($F("txtSequence")>99){
					customShowMessageBox("Invalid Sequence. Valid value should be from 0 to 99.", "I", "txtSequence");
				}else{
					if($F("txtSequence") == valSequence) {
						addRec();
					}else{
						var addedSameExists = false;
						var deletedSameExists = false;	
						for(var i=0; i<tbgTaxCharge.geniisysRows.length; i++){
							if(tbgTaxCharge.geniisysRows[i].recordStatus == 0 || tbgTaxCharge.geniisysRows[i].recordStatus == 1){	
								if ($F("txtSequence") != "") {
									if(tbgTaxCharge.geniisysRows[i].sequence == $F("txtSequence")){
										addedSameExists = true;	
									}	
								}
							} else if(tbgTaxCharge.geniisysRows[i].recordStatus == -1){
								if(tbgTaxCharge.geniisysRows[i].sequence == formatNumberDigits($F("txtSequence"), 2)){
									deletedSameExists = true;
								}
							}
						}
						if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
							showMessageBox("Record already exists with the same sequence.", "E");
							return;
						} else if(deletedSameExists && !addedSameExists){
							addRec();
							return;
						}
						new Ajax.Request(contextPath + "/GIISTaxChargesController", {
							parameters : {action : "valSeqOnAdd",
										  issCd : unescapeHTML2($F("txtIssCd")),
										  lineCd : unescapeHTML2($F("txtLineCd")),
										  sequence : $F("txtSequence")},
							onCreate : showNotice("Processing, please wait..."),
							onComplete : function(response){
								hideNotice();
								if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
									addRec();
								}
							}
						}); 
					}
				}
			}else{
				
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}	
	                                                                               
	function deleteRec() {
		changeTagFunc = saveGiiss028;
		objTaxCharge.recordStatus = -1;
		tbgTaxCharge.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	$("btnAdd").observe("click", valAddRec);
	
	$("btnDelete").observe("click", valDeleteRec);
	
	function valDeleteRec() {
		try {
			new Ajax.Request(contextPath + "/GIISTaxChargesController", {
				parameters : {
					action : "valDeleteRec",
					lineCd : unescapeHTML2($F("txtLineCd")),
					issCd : unescapeHTML2($F("txtIssCd")),
					taxCd : taxCd,
					taxId : nvl(taxId,0)
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
						deleteRec();
					}
				}
			});
		} catch (e) {
			showErrorMessage("valDeleteRec", e);
		}
	}

	function exitPage() {
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}

	function cancelGiiss213() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function() {
				objGIISS028.exitPage = exitPage;
				saveGiiss028();
			}, function() {
				goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
			}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}
	
	
	function togglePerilGroupFields(enable) {
		try {
				$("txtTaxCd").readOnly = enable;	
				$("txtFunctionName").readOnly = enable;
				$("txtSequence").readOnly = enable;
				$("txtRate").readOnly = enable;
				//$("txtStartDate").readOnly = enable;
				//$("txtEndDate").readOnly = enable;
				$("txtDrGlCd").readOnly = enable;
				$("txtCrGlCd").readOnly = enable;
				$("txtDrGlSub").readOnly = enable;
				$("txtCrGlSub").readOnly = enable;
				$("chkWithoutRate").disabled = enable;
				$("chkPremium").disabled = enable;
				$("chkRequired").disabled = enable;
				$("chkExpired").disabled = enable;
				$("chkPerilDependent").disabled = enable;
				$("chkIssueDate").disabled = enable;
				$("chkCocCharges").disabled = enable;
				$("chkRefundSw").disabled = enable; //added by robert GENQA 4844 08.10.15
				$("dDnTaxType").disabled = enable;
				$("rdoBoth").disabled = enable;
				$("rdoBoth").checked = !enable;
				$("rdoPolicy").disabled = enable;
				$("rdoEndt").disabled = enable;
				$("rdoFirst").disabled = enable;
				$("rdoFirst").checked = !enable;
				$("rdoSpread").disabled = enable;
				$("rdoLast").disabled = enable;
				$("rdoAllocNone").disabled = enable;
				$("rdoAllocNone").checked = !enable;
				$("rdoAllocFirst").disabled = enable;
				$("rdoAllocSpread").disabled = enable;
				$("rdoAllocLast").disabled = enable;
				//$("txtUserId").readOnly = enable;
				//$("txtLastUpdate").readOnly = enable;
				$("txtRemarks").readOnly = enable;
				$("txtIssCd").readOnly = !enable;
				$("txtLineCd").readOnly = !enable; 
				$("editRemarks").disabled = enable;
				if(enable){
					disableSearch("searchLineLOV");
					$("txtLineCd").disabled = true;
					enableSearch("searchIssLOV");
					disableButton("btnAdd");
					disableDate("imgToDate");
					disableDate("imgFromDate");
				}else{
					disableSearch("searchLineLOV");
					disableSearch("searchIssLOV");
					enableSearch("searchTaxCdLOV");
					enableButton("btnAdd");
					enableDate("imgToDate");
					enableDate("imgFromDate");
				}
		} catch (e) {
			showErrorMessage("togglePerilGroupFields", e);
		}
	}

	function enterQuery() {
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		tbgTaxCharge.url = contextPath + "/GIISTaxChargesController?action=showGiiss028&refresh=1";
		tbgTaxCharge._refreshList();
		$("txtIssCd").clear();
		$("txtIssName").clear();
		$("txtLineCd").clear();
		$("txtLineName").clear();
		$("txtTaxCd").clear();
		$("txtSequence").clear();
		togglePerilGroupFields(true);
		$("txtIssCd").focus();
		$("txtIssCd").setAttribute("lastValidValue", "");
		$("txtIssName").setAttribute("lastValidValue", "");
		$("txtLineCd").setAttribute("lastValidValue", "");
		$("txtLineName").setAttribute("lastValidValue", "");
		$("txtTaxCd").setAttribute("lastValidValue", "");
		$("txtTaxDesc").setAttribute("lastValidValue", "");
		$("txtTaxAmount").setAttribute("lastValidValue", "");
		enableSearch("searchIssLOV");
		disableSearch("searchLineLOV");
		disableSearch("searchTaxCdLOV");
		$("txtLineCd").disabled = true;
		$("txtTaxCd").readOnly = true;
		executeQuery = false;
		maxSequence = "";
		$("txtSequence").value = formatNumberDigits(maxSequence+1,2);
	} 

	$("btnToolbarEnterQuery").observe("click", function() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function() {
				objGIISS028.exitPage = enterQuery;
				saveGiiss028();
			}, function() {
				enterQuery();
				changeTag = 0;
			}, "");
		} else {
			enterQuery();
		}
	}); 

	disableButton("btnDelete");
	//disableButton("btnTaxPeril");
	//disableButton("btnRatePerPlace");
	
	$("txtTaxCd").readOnly = true;
	disableSearch("searchTaxCdLOV");
	
	showToolbarButton("btnToolbarSave");
	hideToolbarButton("btnToolbarPrint");
	disableToolbarButton("btnToolbarEnterQuery");
	disableToolbarButton("btnToolbarExecuteQuery");

	observeSaveForm("btnSave", saveGiiss028);
	observeSaveForm("btnToolbarSave", saveGiiss028);
	
	$("btnCancel").observe("click", cancelGiiss213);

	$("btnToolbarExit").stopObserving("click");
	$("btnToolbarExit").observe("click", function() {
		fireEvent($("btnCancel"), "click");
	});

	$("txtIssCd").focus();

	togglePerilGroupFields(true);
	
	$("btnToolbarExecuteQuery").observe("click", function() {
		disableToolbarButton(this.id);
		enableToolbarButton("btnToolbarEnterQuery");
		tbgTaxCharge.url = contextPath
				+ "/GIISTaxChargesController?action=showGiiss028&refresh=1&issCd="
				+ encodeURIComponent($F("txtIssCd")) + "&lineCd=" + encodeURIComponent($F("txtLineCd")); 
		tbgTaxCharge._refreshList();
		//enableButton("btnTaxPeril");
		//enableButton("btnRatePerPlace");
		togglePerilGroupFields(false);
		executeQuery = true;
		if(tbgTaxCharge.geniisysRows.length == 0){
			$("txtSequence").value = formatNumberDigits(maxSequence+1,2);	
		}
		$("txtRate").value = formatToNineDecimal(0);
	});

	
	function showOverlay(action, title, h, w) {
		try {
			overlayTax = Overlay.show(contextPath
					+ "/GIISTaxChargesController", {
				urlContent : true,
				urlParameters : {
					action : action,
					issCd : unescapeHTML2($F("txtIssCd")),
					lineCd : unescapeHTML2($F("txtLineCd")),
					taxCd : taxCd,
					taxId : taxId
				},
				title : title,
				height : h,
				width : w,
				draggable : true
			});
		} catch (e) {
			showErrorMessage("Error: Overlay", e);
		}
	}
	
	$("btnTaxPeril").observe("click", function() {
		if(checkAllRequiredFieldsInDiv("taxChargeFormDiv") && $F("btnAdd") == "Add"){
			showConfirmBox3("CONFIRMATION", "Record must be saved before adding peril. Do you want to save the record?", "Yes", "No", 
					function(){
				fireEvent($("btnAdd"), "click");
				fireEvent($("btnSave"), "click");
			},null);	
		}else if($F("btnAdd") == "Update"){
			
			/* tbgTaxCharge.geniisysRows[i].recordStatus == 0) */
			
			showOverlay("getTaxPeril", "Tax Peril", 475, 473);
		}
	});
	
	/* $("btnRatePerPlace").observe("click", function() {
		if (changeTag == 1) {
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		} else {
			showOverlay("getTaxPlaceList", "Place of Issuance", 410, 473);
		}
	}); */
	
	$("btnRatePerPlace").observe("click", function() {
		if(checkAllRequiredFieldsInDiv("taxChargeFormDiv") && $F("btnAdd") == "Add"){
			showConfirmBox3("CONFIRMATION", "Record must be saved before adding range. Do you want to save the record?", "Yes", "No", 
					function(){
				fireEvent($("btnAdd"), "click");
				fireEvent($("btnSave"), "click");
			},null);	
		}else if($F("btnAdd") == "Update"){
			showOverlay("getTaxPlaceList", "Place of Issuance", 475, 473);
		}
	});

	
	/* $("btnRange").observe("click", function() {
		if (changeTag == 1) {
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		} else {
			showOverlay("getTaxRangeList", "Range", 440, 550);
		}
	});  */
	
	$("btnRange").observe("click", function() {
		if(checkAllRequiredFieldsInDiv("taxChargeFormDiv") && $F("btnAdd") == "Add"){
			showConfirmBox3("CONFIRMATION", "Record must be saved before adding range. Do you want to save the record?", "Yes", "No", 
					function(){
				fireEvent($("btnAdd"), "click");
				fireEvent($("btnSave"), "click");
			},null);	
		}else if($F("btnAdd") == "Update"){
			showOverlay("getTaxRangeList", "Range", 440, 550);
		}
	});
	
	
	
	$("editRemarks").observe("click", function() {
		showOverlayEditor("txtRemarks", 2000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("dDnTaxType").observe("change", function() {
		taxTypeFunc();
		if ($("chkWithoutRate").checked == true) {
				$("txtRate").removeClassName("required");	
		}
	});
	
	taxTypeFunc();
	
	disableButton("btnTaxPeril");
	disableButton("btnRatePerPlace");
	$("chkPerilDependent").disabled = true;
	$("chkWithoutRate").disabled = true;
	
	function taxTypeFunc(){
		if($F("dDnTaxType") == "R"){
			$("forRateType").show();
			$("forRate").show();
			$("forAmountType").hide();
			$("forAmount").hide();
			$("forRangeType").hide();
			$("forRange").hide();
			$("txtTaxAmount").value = "";
			$("chkPerilDependent").disabled = false;
			$("chkWithoutRate").disabled = false;
			disableButton("btnRatePerPlace");
			$("txtRate").addClassName("required");
			if ($F("txtRate") == "") {
				$("txtRate").value = formatToNineDecimal(0);
			}
			if($("chkWithoutRate").checked == true){ //added by robert SR 21845 03.28.16
				$("txtRate").removeClassName("required");
			}else{
				$("txtRate").addClassName("required");
			}
		}else if($F("dDnTaxType") == "A"){
			$("forRateType").hide();
			$("forRate").hide();
			$("forAmountType").show();
			$("forAmount").show();
			$("forRangeType").hide();
			$("forRange").hide();
			$("txtRate").value = "";
			$("chkPerilDependent").disabled = true;
			$("chkWithoutRate").disabled = true;
			disableButton("btnRatePerPlace");
			$("txtRate").removeClassName("required");
		}else{
			$("forRateType").hide();
			$("forRate").hide();
			$("forAmountType").hide();
			$("forAmount").hide();
			$("forRangeType").show();
			$("forRange").show();
			$("txtRate").value = "";
			$("txtTaxAmount").value = "";
			$("chkPerilDependent").disabled = true;
			$("chkWithoutRate").disabled = true;
			disableButton("btnRatePerPlace");
			disableButton("btnRange");
			$("txtRate").removeClassName("required");
		}
	}
	
	function checkNegative(txtId){
			for(var i = 0; i < txtId.length; i++){
				if (txtId.charAt(i)=='-'){
					return true;
				}
			}
			return false;
		}
	
	$("txtTaxAmount").observe("change",function() {
		var minPrem = $F("txtTaxAmount").replace(/,/g, "");
		if (isNaN(minPrem) || parseInt(minPrem) < 0 || parseFloat(minPrem) > parseFloat(9999999999.99) || checkNegative(minPrem)) {
			customShowMessageBox("Invalid Tax Amount. Valid value should be from 0.00 to 9,999,999,999.99.", "I", "txtTaxAmount");
			$("txtTaxAmount").value = $("txtTaxAmount").readAttribute("lastValidValue");
		}else{
			$("txtTaxAmount").value = formatCurrency($("txtTaxAmount").value);
			$("txtTaxAmount").setAttribute("lastValidValue", formatCurrency($("txtTaxAmount").value));
		}
	});

	/* $("txtRate").observe("change",function(){
		var rateFieldValue = formatToNineDecimal($F("txtRate"));
		if (rateFieldValue < 0 && rateFieldValue != "") {
			customShowMessageBox("Invalid Rate. Valid value should be from 0.000000000 to 100.000000000.", imgMessage.INFO, "txtRate");
			$("txtRate").value = "";
		}else if ($F("txtRate") != "" && isNaN($F("txtRate"))) {
			customShowMessageBox("Invalid Rate. Valid value should be from 0.000000000 to 100.000000000.", imgMessage.INFO, "txtRate");
			$("txtRate").value = "";
		}else if (rateFieldValue > 100 && rateFieldValue != ""){
			customShowMessageBox("Invalid Rate. Valid value should be from 0.000000000 to 100.000000000.", imgMessage.INFO, "txtRate");
			$("txtRate").value = "";
		}else if ($F("txtRate").include("-")){
			customShowMessageBox("Invalid Rate. Valid value should be from 0.000000000 to 100.000000000.", imgMessage.INFO, "txtRate");
			$("txtRate").value = "";
		}else if ($F("txtRate") == ""){
			$("txtRate").value = "";
		}else{
			
			var returnValue = "";
			var amt;
			amt = (($F("txtRate")).include(".") ? $F("txtRate") : ($F("txtRate")).concat(".00")).split(".");
		
			if(9 < amt[1].length){				
				returnValue = amt[0] + "." + amt[1].substring(0, 9);
				customShowMessageBox("Invalid Rate. Valid value should be from 0.000000000 to 100.000000000.", imgMessage.INFO, "txtRate");
				$("txtRate").value = "";
				
			}else{				
				returnValue = amt[0] + "." + rpad(amt[1], 9, "0");
				$("txtRate").value = returnValue;
			}
		} 
	}); */
	
	$$("input[name='code']").each(function(btn) {
		btn.observe("change", function() {
			if(btn.value == ""){
				btn.value = "";
			}else{
				btn.value = formatNumberDigits(btn.value, btn.getAttribute("maxlength"));	
			}
		});
	}); 
	
	//Checkbox observers
	$("chkWithoutRate").observe("click",function() {
		if($("chkWithoutRate").checked == true){
			$("txtRate").removeClassName("required");
			//$("txtRate").clear(); //removed by robert SR 21845 03.28.16
		}else{
			$("txtRate").addClassName("required");
			//$("txtRate").value = formatToNineDecimal(0);  //removed by robert SR 21845 03.28.16
		}
	});
			
	$("chkRequired").observe("click",function() {
		if($("chkRequired").checked == true && $("chkIssueDate").checked == true){
			showWaitingMessageBox("Tax tagged by Issue Date is not permitted to be required.", "I", function(){
				$("chkRequired").checked = false;
			});
		}
		var checkOnAdd = false;
		var checkOnDel = false;	
		for(var i=0; i<tbgTaxCharge.geniisysRows.length; i++){
			if(tbgTaxCharge.geniisysRows[i].recordStatus == 0 || tbgTaxCharge.geniisysRows[i].recordStatus == 1){	
				if(tbgTaxCharge.geniisysRows[i].issueDateTag == "Y" && tbgTaxCharge.geniisysRows[i].taxCd == $F("txtTaxCd")){
					checkOnAdd = true;	
				}	
			} else if(tbgTaxCharge.geniisysRows[i].recordStatus == -1){
				if(tbgTaxCharge.geniisysRows[i].issueDateTag == "Y" && tbgTaxCharge.geniisysRows[i].taxCd == $F("txtTaxCd")){
					checkOnDel = true;
				}
			}
		}
		if(valOnCheck == "I" && $("chkIssueDate").checked == false && checkOnAdd == true){
			checkOnAdd = false;	
		}else if (valOnCheck != "I" && $("chkIssueDate").checked == false && checkOnAdd == true){
			checkOnAdd = true;	
		}
		if((checkOnAdd && !checkOnDel) || (checkOnDel && checkOnAdd)){
			showWaitingMessageBox("Tax tagged by Issue Date is not permitted to be required.", "I", function(){
				$("chkRequired").checked = false;
			});
			return
		} 
	});
	
	$("chkIssueDate").observe("click",function() {
		if($("chkRequired").checked == true && $("chkIssueDate").checked == true){
			showWaitingMessageBox("Tax tagged as required is not permitted to be tagged by issue date.", "I", function(){
				$("chkIssueDate").checked = false;
			});
		}
		var checkOnAdd = false;
		var checkOnDel = false;	
		for(var i=0; i<tbgTaxCharge.geniisysRows.length; i++){
			if(tbgTaxCharge.geniisysRows[i].recordStatus == 0 || tbgTaxCharge.geniisysRows[i].recordStatus == 1){	
				if(tbgTaxCharge.geniisysRows[i].primarySw == "Y" && tbgTaxCharge.geniisysRows[i].taxCd == $F("txtTaxCd")){
					checkOnAdd = true;	
				}	
			} else if(tbgTaxCharge.geniisysRows[i].recordStatus == -1){
				if(tbgTaxCharge.geniisysRows[i].primarySw == "Y" && tbgTaxCharge.geniisysRows[i].taxCd == $F("txtTaxCd")){
					checkOnDel = true;
				}
			}
		}
		if(valOnCheck == "R" && $("chkRequired").checked == false && checkOnAdd == true){
			checkOnAdd = false;	
		}else if (valOnCheck != "R" && $("chkRequired").checked == false && checkOnAdd == true){
			checkOnAdd = true;	
		}
		if((checkOnAdd && !checkOnDel) || (checkOnDel && checkOnAdd)){
			showWaitingMessageBox("Tax tagged as required is not permitted to be tagged by issue date.", "I", function(){
				$("chkIssueDate").checked = false;
			});
			return
		}
	});
	
	/* $("chkPerilDependent").observe("click",function() {
		if($("chkPerilDependent").checked == true){
			enableButton("btnTaxPeril");
		}else{
			disableButton("btnTaxPeril");
		}
	}); */
	
	$("chkExpired").observe("click",function() {
		if($("chkExpired").checked == true){
			valOnUpdateExp = true;
			showOverlay("getTaxExpiryOverlay", "Enter Expiry Date", 120, 205);
		}
	});
	
	function valDateOnAdd(field) {
		try {
			var tbgStartDate = "";
			var tbgEndDate = "";
			var startDate = $F("txtStartDate") != "" ? new Date($F("txtStartDate").replace(/-/g, "/")) : "";
			var endDate = $F("txtEndDate") != "" ? new Date($F("txtEndDate").replace(/-/g, "/")) : "";
			var addedSameDateExists = false;

			if($F("btnAdd") == "Add") {
				for(var i=0; i<tbgTaxCharge.geniisysRows.length; i++){
					if(tbgTaxCharge.geniisysRows[i].recordStatus == 0 || tbgTaxCharge.geniisysRows[i].recordStatus == 1){	
						if (tbgTaxCharge.geniisysRows[i].taxCd == $F("txtTaxCd")) {
							if (tbgTaxCharge.geniisysRows[i].expiredSw != "Y") {
								$("txtStartDate").setAttribute("tbgStartDate", tbgTaxCharge.geniisysRows[i].effStartDate);
								$("txtEndDate").setAttribute("tbgEndDate", tbgTaxCharge.geniisysRows[i].effEndDate);
								tbgStartDate =  $("txtStartDate").getAttribute("tbgStartDate") != "" ? new Date($("txtStartDate").getAttribute("tbgStartDate").replace(/-/g, "/")) : "";
								tbgEndDate =  $("txtEndDate").getAttribute("tbgEndDate") != "" ? new Date($("txtEndDate").getAttribute("tbgEndDate").replace(/-/g, "/")) : "";		
								
								if ((endDate >= tbgStartDate && endDate <= tbgEndDate)) {
									addedSameDateExists = true;	
								}else if ((startDate >= tbgStartDate && startDate <= tbgEndDate)) {
									addedSameDateExists = true;	
								}else if (endDate >= tbgEndDate && startDate <= tbgStartDate) {
									addedSameDateExists = true;	
								}
							}
						}
					}
				}				
				
				if(addedSameDateExists){
					showMessageBox("The effectivity of this tax falls within the current "+$F("txtTaxDesc") + ".", "E");
					$(field).clear();
					return;
				}
				new Ajax.Request(contextPath + "/GIISTaxChargesController", {
					parameters : {
						action : "valDateOnAdd",
						lineCd : unescapeHTML2($F("txtLineCd")),
						issCd : unescapeHTML2($F("txtIssCd")),
						taxCd : taxCd,
						effStartDate : $F("txtStartDate"),
						effEndDate : $F("txtEndDate"),
						tran : "ADD",
						taxId : taxId
					},
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {

						}else{
							$(field).clear();
						}
					}
				});
			}else {
				if (changed) {
					new Ajax.Request(contextPath + "/GIISTaxChargesController", {
						parameters : {
							action : "valDateOnAdd",
							lineCd : unescapeHTML2($F("txtLineCd")),
							issCd : unescapeHTML2($F("txtIssCd")),
							taxCd : taxCd,
							effStartDate : $F("txtStartDate"),
							effEndDate : $F("txtEndDate"),
							tran : "UPDATE",
							taxId : taxId
						},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response) {
							hideNotice();
							if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {

							}else{
								$(field).clear();
							}
						}
					});
				}
			}
		} catch (e) {
			showErrorMessage("valDateOnAdd", e);
		}
	}
	
	function validateFromAndTo(field) {
		var toDate = $F("txtEndDate") != "" ? new Date($F("txtEndDate").replace(/-/g, "/")) : "";
		var fromDate = $F("txtStartDate") != "" ? new Date($F("txtStartDate").replace(/-/g, "/")) : "";
		
		if(fromDate != "" || toDate != "") {
			if (fromDate > toDate && toDate != "") {
				$(field).clear();
				customShowMessageBox("Start Date should not be later than End Date.", "I", field);
			}else {
				valDateOnAdd(field);
			}
		}
	}
	
	$("txtStartDate").observe("focus", function() {
		if ($("imgFromDate").disabled == true) return;
		if ($F("txtStartDate") != $("txtStartDate").getAttribute("prevStartDate")) {
			changed = true;
		}
		if ($F("txtStartDate") != "") {
			validateFromAndTo("txtStartDate");
		}
	});
	
	$("txtEndDate").observe("focus", function() {
		if ($("imgToDate").disabled == true) return;
		if ($F("txtEndDate") != $("txtEndDate").getAttribute("prevEndDate")) {
			changed = true;
		}
		if ($F("txtEndDate") != "") {
			validateFromAndTo("txtEndDate");
		}
	});
	
	function onRowClick(obj){
		if(obj.taxType == "R"){
			if(obj.newRecord!="Y"){
				enableButton("btnRatePerPlace");
			}
		}else if(obj.taxType == "A"){
			disableButton("btnRatePerPlace");
		}else{
			disableButton("btnRatePerPlace");
			if(obj.newRecord!="Y"){
				enableButton("btnRange");
			}
		}
	}
	//added by gab 06.02.2016 SR 21333
	$("txtRate").observe("change",function(){
		if($("rdoAllocSpread").checked == true && $("dDnTaxType").value == 'R' && $F("txtRate") == 0){
			showMessageBox("Rate should not be 0.",imgMessage.ERROR);
			disableButton("btnAdd");
			$("txtRate").focus();
		}else{
			enableButton("btnAdd");
		}
	});
	//added by gab 06.02.2016 SR 21333
	$("chkWithoutRate").observe("change",function(){
		if($("chkWithoutRate").checked == true){
			showMessageBox("Rate in transactions will be 0.", imgMessage.WARNING);
		}
		
	});
	
	observeBackSpaceOnDate("txtStartDate");
	observeBackSpaceOnDate("txtEndDate");
	$("txtSequence").value = formatNumberDigits(maxSequence+1,2);
</script>
