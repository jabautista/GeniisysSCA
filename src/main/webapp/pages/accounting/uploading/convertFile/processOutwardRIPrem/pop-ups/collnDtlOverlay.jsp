<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="collnDtlDiv" >
	<div class="sectionDiv" id="collnDtlDiv" changeTagAttr="true" style="margin-top: 2px; width: 864px;">
		<div id="gucdTableGrid" style="margin: 2px; height: 172px;"></div>
		
		<fieldset class="sectionDiv" style="width:858px; margin:0 2px 10px 2px;">
			<legend style="font-weight: bold; font-size: 11px;">Totals</legend>
			<div id="totalsDiv" class="" style="padding:4px 8px 4px 61px">
				<table>
					<tr>
						<td id="totAmtLabel" class="rightAligned" style="width:150px; padding-right: 4px;">Local Currency Amount</td>
						<td class="leftAligned">
							<input type="text" id="txtTotAmount" style="width: 169px; text-align: right;" readonly="readonly" tabIndex="201" />
							<input type="hidden" id="dspTotLoc" value=""/>
							<input type="hidden" id="dspTotFc" value=""/>
						</td>
					</tr>
				</table>
			</div>
		</fieldset>
		
		<div class="sectionDiv" id="collectionBreakdownBody" style="margin-top: 5px;" changeTagAttr="true">		
			<table width="85%" align="center" border="0" style="padding-right: 5px; float: center;">
				<tr>
					<td class="rightAligned" style="width:120px; padding-right: 3px;">Payment Mode</td>
					<td class="leftAligned">
						<input type="hidden" id="nextItemNo" name="nextItemNo" value=""/>
						<input type="hidden" id="itemNo" name="itemNo" value=""/>
						<select id="payMode" name="collnDtlSelect" style="width: 177px; margin-bottom: 0px;" class="required list" tabIndex="202" >
							<option value="">Select..</option>
							<option value="CA">Cash</option>
							<option value="CHK">Check</option>
							<option value="CC">Credit Card</option>
							<option value="CM">Credit Memo</option>
							<option value="CW">Creditable Withholding Tax</option>
							<option value="WT">Wire Transfer</option>
						</select>
					</td>
					<td id="inputAmtLabel" class="rightAligned" style="width:120px; padding-right: 3px;">Local Currency Amount</td>
					<td class="leftAligned">
						<input id="inputAmt" type="text" name="collnDtlTxt" style="width: 169px;" class="money2 required dcbEvent" value="" maxLength="17" tabIndex="203" />
						<input type="hidden" id="amount" value=""/>
						<input type="hidden" id="dspFcNet" value=""/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width:120px; padding-right: 3px;">Bank</td>
					<td class="leftAligned">
						<div id="bankDiv" name="backDiv" style="border: 1px solid gray; width: 175px; height: 21px; float: left;" class="withIconDiv">
							<input style="width: 150px; border: none; height: 15px; float: left;" id="dspBankName" name="collnDtlTxt" type="text" class="withIcon" ignoreDelKey="1" maxLength="100" tabIndex="204" />
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovBank" name="collnDtlLov" alt="Go" />
							<input type="hidden" id="bankCd" name="bankCd" value=""/>
							<input type="hidden" id="dspBankSname" name="dspBankSname" value=""/>
						</div>
					</td>
					<td class="rightAligned" style="width:150px; padding-right: 3px;">Currency</td>
					<td class="leftAligned">
						<div id="currencyDiv" name="backDiv" style="border: 1px solid gray; width: 175px; height: 21px; float: left;" class="withIconDiv required"> 
							<input style="width: 150px; border: none; height: 13px; float: left;" id="dspCcyDesc" name="collnDtlTxt" value="" type="text" class="withIcon required" ignoreDelKey="1" maxLength="20" tabIndex="205" />
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovCurrency" name="collnDtlLov" alt="Go" />
							<input type="hidden" id="currencyCd" name="currencyCd" value=""/>
							<input type="hidden" id="dspShortName" name="dspShortName" value=""/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width:120px; padding-right: 3px;">Check Class</td>
					<td class="leftAligned">
						<select id="checkClass" name="collnDtlSelect" style="width: 177px; margin-bottom: 0px;" class="list dcbEvent" tabIndex="206" >
							<option value="">Select..</option>
								<c:forEach var="checkClassDetail" items="${checkClassDetails}">
									<option checkDesc="${checkClassDetail.rvMeaning}" value="${checkClassDetail.rvLowValue}">${checkClassDetail.rvMeaning}</option>
								</c:forEach>
						</select>
					</td>
					<td class="rightAligned" style="width:150px; padding-right: 3px;">Convert Rate</td>
					<td class="leftAligned"><input id="currencyRt" type="text" name="collnDtlTxt" style="width: 169px; text-align: right;"  value="" class="dcbEvent" readonly="readonly" tabIndex="207" /></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width:120px; padding-right: 3px;">Check/Credit Card No.</td>
					<td class="leftAligned">
						<input id="checkNo" type="text" name="collnDtlTxt" style="width: 169px;" maxLength="25" tabIndex="208" />
					</td>
					<td class="rightAligned" style="width:150px; padding-right: 3px;">Check Date</td>
					<td class="leftAligned">
						<div id="checkDateBack" name="backDiv" style="float: left; height: 21px; border: 1px solid gray; width: 175px;" >
					    	<input style="width: 150px; border: none; height: 15px;" id="checkDate" name="collnDtlTxt" type="text" class="withIcon" readonly="readonly" ignoreDelKey="1" tabIndex="209" />
					    	<img id="hrefCheckDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Check Date" style="padding-right: 1px;"/>
					    </div>
					</td>
				</tr>	
				<tr>
					<td class="rightAligned" style="width:150px; padding-right: 3px;">DCB Bank Account</td>
					<td class="leftAligned" colspan="3">
						<div id="dcbBankNameDiv" name="backDiv" style="border: 1px solid gray; width: 293px; height: 21px; float: left;" class="withIconDiv">
							<input style="width: 268px; border: none; height: 15px; float: left;" id="dspDcbBankName" name="collnDtlTxt" type="text" class="withIcon" ignoreDelKey="1" maxLength="100" tabIndex="210" />
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovDcvBankName" name="collnDtlLov" alt="Go" />
							<input type="hidden" id="dcbBankCd" name="dcbBankCd" value=""/>
						</div>
						<label style="padding: 3px 5px 0 5px;">/</label>
						<div id="dcbBankAcctDiv" name="backDiv" style="border: 1px solid gray; width: 225px; height: 21px; float: left;" class="withIconDiv">
							<input style="width: 199px; border: none; height: 15px; float: left;" id="dspDcbBankAcctNo" name="collnDtlTxt" type="text" class="withIcon" ignoreDelKey="1" maxLength="30" tabIndex="211" />
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovDcbBankAcctNo" name="collnDtlLov" alt="Go" />
							<input type="hidden" id="dcbBankAcctCd" name="dcbBankAcctCd" value=""/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width:120px; padding-right: 3px;">Particulars</td>
					<td class="leftAligned" colspan="3"> 
						<div name="backDiv" style="border: 1px solid gray; height: 21px; width: 539px; margin-top: 3px; background-color: transparent">
							<textarea id="particulars" name="particulars" style="width: 493px; border: none; height: 13px; float: left; resize:none;" class="list dcbEvent" maxlength="500" onkeyup="limitText(this,500)" tabIndex="212" ></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; background-color: transparent; " alt="Edit" id="editParticulars" />
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovOR" name="collnDtlLov" alt="Go" />
						</div>
					</td>
				</tr>
			</table>
		</div>
			
		<div class="buttonsDiv" style="margin: 10px 0 5px 0;">
			<input type="button" id="btnAdd" class="button" value="Add" style="width: 120px;" tabIndex="213" />
			<input type="button" id="btnDelete" class="button" value="Delete" style="width: 120px;" tabIndex="214" />
		</div>
	</div>
	
	<div class="buttonsDiv" style="margin: 5px 0 0 0;">
		<input type="button" id="btnSave" class="button" value="Save" style="width: 120px;" tabIndex="215" />
		<input type="button" id="btnReturn" class="button" value="Return" style="width: 120px;" tabIndex="216" />
		<input type="button" id="btnFcDtl" class="button" value="FC Details" style="width: 120px;" tabIndex="217" />
		<input type="hidden" id="grossAmt" value=""/>
		<input type="hidden" id="commissionAmt" value=""/>
		<input type="hidden" id="vatAmt" value=""/>
		<input type="hidden" id="fcCommAmt" value=""/>
		<input type="hidden" id="fcVatAmt" value=""/>
		<input type="hidden" id="fcGrossAmt" value=""/>
		<input type="hidden" id="tranId" value=""/>
	</div>
</div>

<script type="text/javascript">
	try {
		/* variables */
		var objGUCDList = JSON.parse('${jsonGUCD}');
		var rowIndex = -1;
		var objGUCD = null;
		var delAll = "N";
		
		/* observe elements */
		$("payMode").observe("change", function() {
			validatePayMode();
		});
	
		$("inputAmt").observe("change", function() {
			var amt = parseFloat(unformatCurrencyValue(this.value));
			if (amt == 0) {
				this.value = formatCurrency(this.readAttribute("lastValidValue"));
				
				if ($F("btnFcDtl") == "FC Details") {
					customShowMessageBox("Local Currency Amount cannot be zero.", imgMessage.INFO, "inputAmt");
				} else {
					customShowMessageBox("Foreign Currency Amount cannot be zero.", imgMessage.INFO, "inputAmt");
				}
			} else {
				this.setAttribute("lastValidValue", unformatCurrencyValue(this.value));
				computeAmt();
			}
		});
		
		$("lovBank").observe("click", function() {
			showBankLOV(true);
		});

		$("dspBankName").observe("change", function() {
			if (this.value != "") {
				showBankLOV(false);
			} else {
				$("dspBankName").setAttribute("lastValidValue", "");
				$("bankCd").clear();
				$("dspBankSname").clear();
			}
		});
		
		$("lovCurrency").observe("click", function() {
			showCurrencyLOV(true);
		});
		
		$("dspCcyDesc").observe("focus", function() {
			if ($F("dspCcyDesc") == "" && $("dspCcyDesc").readOnly == false) {
				$("dspCcyDesc").value = unescapeHTML2($F("guopCurrencyDesc"));
				$("dspCcyDesc").setAttribute("lastValidValue", $F("dspCcyDesc"));
				$("currencyCd").value = $F("guopCurrencyCd");
				$("dspShortName").value = $F("guopCurrencySname");
				$("currencyRt").value = formatToNineDecimal($F("guopConvertRate"));
				computeAmt();
				this.writeAttribute("changed", true);
				changeTag = 1;
			}
		});

		$("dspCcyDesc").observe("change", function() {
			if (this.value != "") {
				showCurrencyLOV(false);
			} else {
				$("dspCcyDesc").setAttribute("lastValidValue", "");
				$("currencyCd").clear();
				$("dspShortName").clear();
				$("currencyRt").clear();
			}
		});

		$("checkClass").observe("change", function() {
			if ($F("checkDate") != "") {
				validateCheckDate();
			}
		});

		$("hrefCheckDate").observe("click", function() {
			scwNextAction = validateCheckDate.runsAfterSCW(this, null);
			scwShow($("checkDate"), this, null);
		});

		$("lovDcvBankName").observe("click", function() {
			showDcbBankLOV(true);
		});

		$("dspDcbBankName").observe("change", function() {
			if (this.value != "") {
				showDcbBankLOV(false);
			} else {
				$("dspDcbBankName").setAttribute("lastValidValue", "");
				$("dcbBankCd").clear();
				$("dcbBankAcctCd").clear();
				$("dspDcbBankAcctNo").clear();
				$("dspDcbBankAcctNo").readOnly = true;
				disableSearch("lovDcbBankAcctNo");
			}
		});

		$("lovDcbBankAcctNo").observe("click", function() {
			showDcbBankAcctLOV(true);
		});

		$("dspDcbBankAcctNo").observe("change", function() {
			if (this.value != "") {
				showDcbBankAcctLOV(false);
			} else {
				$("dspDcbBankAcctNo").setAttribute("lastValidValue", "");
				$("dcbBankAcctCd").clear();
			}
		});
		
		$("editParticulars").observe("click", function() {
			showOverlayEditor("particulars", 500, $("particulars").hasAttribute("readonly"),
				function() {
					changeTag = 1;
				});
		});
		
		$("lovOR").observe("click", function() {
			showORLOV();
		});

		$("btnAdd").observe("click", addRec);

		$("btnDelete").observe("click", function() {
			changeTagFunc = saveGiacs609CollnDtl;
			objGUCD.recordStatus = -1;
			tbgGUCD.deleteRow(rowIndex);
			changeTag = 1;
			recomputeTotals(false, objGUCD);
			var maxItemNo = parseInt($F("nextItemNo")) - 1;
			
			if (maxItemNo == tbgGUCD.geniisysRows[rowIndex].itemNo) {
				$("nextItemNo").value = maxItemNo;
			}
			setFieldValues(null);
		});

		observeSaveForm("btnSave", saveGiacs609CollnDtl);

		$("btnReturn").observe("click", function() {
			if (changeTag == 1) {
				showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
						function() {
							saveGiacs609CollnDtl(true);
						}, function() {
							exitOverlay();
						}, "");
			} else {
				exitOverlay();
			}
		});
		
		$("btnFcDtl").observe("click", function() {
			toggleFcBtn();
		});
		
		$("collnDtlDiv").observe("keydown", function(event){
			var curEle = document.activeElement.id;
			if (event.keyCode == 9 && !event.shiftKey) {
				if (curEle == "btnFcDtl" || curEle == "mtgPageInput3") {
					$("txtTotAmount").focus();
					event.preventDefault();
				}
			} else if (event.keyCode == 9 && event.shiftKey) {
				if (curEle == "txtTotAmount") {
					$("btnFcDtl").focus();
					event.preventDefault();
				}
			}
		});
		
		$$("div#collnDtlDiv input[name='collnDtlTxt'], div#collnDtlDiv textarea, "
				+ "div#collnDtlDiv select[name='collnDtlSelect']").each(function(o) {
			$(o).observe("change", function() {
				changeTag = 1;
				changeTagFunc = saveGiacs609CollnDtl;
			});
		});
		
		/* funtions: populate*/
		function populateTableGrid() {
			try {
				var gucdTableModel = {
					url : contextPath
							+ "/GIACUploadingController?action=showGiacs609CollnDtlOverlay&refresh=1&sourceCd="
							+ guf.sourceCd + "&fileNo=" + guf.fileNo,
					options : {
						width : '860px',
						hideColumnChildTitle : true,
						pager : {},
						onCellFocus : function(element, value, x, y, id) {
							rowIndex = y;
							objGUCD = tbgGUCD.geniisysRows[y];
							setFieldValues(objGUCD);
							tbgGUCD.keys.removeFocus(tbgGUCD.keys._nCurrentFocus, true);
							tbgGUCD.keys.releaseKeys();
						},
						onRemoveRowFocus : function() {
							rowIndex = -1;
							setFieldValues(null);
							tbgGUCD.keys.removeFocus(tbgGUCD.keys._nCurrentFocus, true);
							tbgGUCD.keys.releaseKeys();
						},
						toolbar : {
							elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
							onFilter : function() {
								rowIndex = -1;
								setFieldValues(null);
								tbgGUCD.keys.removeFocus(tbgGUCD.keys._nCurrentFocus, true);
								tbgGUCD.keys.releaseKeys();
							}
						},
						beforeSort : function() {
							if (changeTag == 1) {
								showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO,
									function() {
										$("btnSave").focus();
									});
								return false;
							}
						},
						onSort : function() {
							rowIndex = -1;
							setFieldValues(null);
							tbgGUCD.keys.removeFocus(tbgGUCD.keys._nCurrentFocus, true);
							tbgGUCD.keys.releaseKeys();
						},
						onRefresh : function() {
							rowIndex = -1;
							setFieldValues(null);
							tbgGUCD.keys.removeFocus(tbgGUCD.keys._nCurrentFocus, true);
							tbgGUCD.keys.releaseKeys();
						},
						prePager : function() {
							if (changeTag == 1) {
								showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO,
									function() {
										$("btnSave").focus();
									});
								return false;
							}
							rowIndex = -1;
							setFieldValues(null);
							tbgGUCD.keys.removeFocus(tbgGUCD.keys._nCurrentFocus, true);
							tbgGUCD.keys.releaseKeys();
						},
						checkChanges : function() {
							return (changeTag == 1 ? true : false);
						},
						masterDetailValidation : function() {
							return (changeTag == 1 ? true : false);
						},
						masterDetail : function() {
							return (changeTag == 1 ? true : false);
						},
						masterDetailSaveFunc : function() {
							return saveGiacs609CollnDtl();
						},
						masterDetailNoFunc : function() {
							changeTag = 0;
							delAll = "N";
						}
					},
					columnModel : [
							{
								id : 'recordStatus',
								width : '0',
								visible : false
							}, {
								id : 'divCtrId',
								width : '0',
								visible : false
							}, {
								id : 'itemNo',
								title : 'Item #',
								altTitle : 'Item No.',
								titleAlign : 'right',
								align : 'right',
								width : '52px',
								filterOption : true,
								filterOptionType : 'integerNoNegative',
								renderer : function(value) {
									return lpad(value, 2, 0);
								}
							}, {
								id : 'payMode',
								title : 'Pay Mode',
								altTitle : 'Payment Mode',
								filterOption : true,
								width : '69px',
								renderer : function(value) {
									return unescapeHTML2(value);
								}
							}, {
								id : 'dspBankSname',
								title : 'Bank',
								width : '88px',
								filterOption : true,
								renderer : function(value) {
									return unescapeHTML2(value);
								}
							}, {
								id : 'dspClassMean',
								title : 'Check Class',
								width : '86px',
								filterOption : true,
								renderer : function(value) {
									return unescapeHTML2(value);
								}
							}, {
								id : 'checkNo',
								title : 'Check/Credit Card No.',
								width : '138px',
								filterOption : true,
								renderer : function(value) {
									return unescapeHTML2(value);
								}
							}, {
								id : 'checkDate',
								title : 'Check Date',
								width : '80px',
								align : 'center',
								titleAlign : 'center',
								filterOption : true,
								filterOptionType : 'formattedDate',
								renderer : function(value) {
									return unescapeHTML2(value);
								}
							}, {
								id : 'dspAmount',
								title : 'Local Currency Amt',
								altTitle : 'Local Currency Amount',
								align : 'right',
								titleAlign : 'right',
								width : '138px',
								filterOption : false,
								renderer : function(value) {
									return formatCurrency(value);
								}
							}, {
								id : 'dspShortName',
								title : 'Currency',
								width : '68px',
								align : 'center',
								titleAlign : 'center',
								filterOption : true,
								renderer : function(value) {
									return unescapeHTML2(value);
								}
							 }, {
								id : 'dcbBankCd dcbBankAcctCd',
								title : 'DCB Bank Acct',
								altTitle : 'DCB Bank Account',
								titleAlign : 'right',
								width : 88,
								children : [ {
									id : 'dcbBankCd',
									width : 46,
									align : 'right',
									filterOption : true,
									title : 'DCB Bank Code',
									renderer : function(value) {
										return unescapeHTML2(value);
									}
								}, {
									id : 'dcbBankAcctCd',
									width : 46,
									align : 'right',
									filterOption : true,
									title : 'DCB Bank Acct Code',
									renderer : function(value) {
										return unescapeHTML2(value);
									}
								} ]
							}, {
								id : 'amount',
								title : 'Local Currency Amount',
								width : '0',
								visible : false,
								filterOption : true,
								filterOptionType : 'number'
							}, {
								id : 'dspFcNet',
								title : 'Foreign Currency Amount',
								width : '0',
								visible : false,
								filterOption : true,
								filterOptionType : 'number'
							}, {
								id : 'particulars',
								title : 'Particulars',
								width : '0',
								visible : false,
								filterOption : true
							} ],
					rows : objGUCDList.rows
				};
	
				tbgGUCD = new MyTableGrid(gucdTableModel);
				tbgGUCD.pager = objGUCDList;
				tbgGUCD.render("gucdTableGrid");
				tbgGUCD.afterRender = function() {
					var row = tbgGUCD.geniisysRows.length > 0 ? tbgGUCD.geniisysRows[0] : [];
					
					$("dspTotLoc").value = nvl(row.dspTotLoc, 0);
					$("dspTotLoc").setAttribute("lastValidValue", nvl(row.dspTotLoc, 0));
					$("dspTotFc").value = nvl(row.dspTotFc, 0);
					$("nextItemNo").value = nvl(row.nextItemNo, 1);
					$("tranId").value = nvl(row.tranId, "");
					assignDspAmount();
					toggleFields();
				};
	
			} catch (e) {
				showErrorMessage("populateTableGrid", e);
			}
		}
		
		function assignDspAmount() {
			try {
				var mtgId = tbgGUCD._mtgId;
				var colDsp = tbgGUCD.getColumnIndex("dspAmount");
				var ccy = "";
				
				if ($F("btnFcDtl") == "FC Details") {
					ccy = "loc";
					$("txtTotAmount").value = formatCurrency($F("dspTotLoc"));
				} else {
					ccy = "fc";
					$("txtTotAmount").value = formatCurrency($F("dspTotFc"));
				}
				
				for (var i = 0; i < tbgGUCD.geniisysRows.length; i++) {
					var amt = (ccy == "fc") ? tbgGUCD.geniisysRows[i].dspFcNet : tbgGUCD.geniisysRows[i].amount;
					tbgGUCD.setValueAt(formatCurrency(amt), colDsp, i);
					$('mtgIC' + mtgId + '_' + colDsp + ',' + i).removeClassName('modifiedCell');
				}
			} catch (e) {
				showErrorMessage("assignDspAmount", e);
			}
		}
		
		function setFieldValues(row) {
			try {
				$("itemNo").value = (row != null) ? row.itemNo : $F("nextItemNo");
				$("payMode").value = (row != null) ? unescapeHTML2(row.payMode) : "";
				$("bankCd").value = (row != null) ? row.bankCd : "";
				$("dspBankSname").value = (row != null) ? unescapeHTML2(row.dspBankSname) : "";
				$("dspBankName").value = (row != null) ? unescapeHTML2(row.dspBankName) : "";
				$("dspBankName").setAttribute("lastValidValue", unescapeHTML2($F("dspBankName")));
				$("checkClass").value = (row != null) ? unescapeHTML2(row.checkClass) : "";
				$("checkNo").value = (row != null) ? unescapeHTML2(row.checkNo) : "";
				$("checkDate").value = (row != null) ? unescapeHTML2(row.checkDate) : "";
				$("dcbBankCd").value = (row != null) ? row.dcbBankCd : "";
				$("dspDcbBankName").value = (row != null) ? unescapeHTML2(row.dspDcbBankName) : "";
				$("dspDcbBankName").setAttribute("lastValidValue", unescapeHTML2($F("dspDcbBankName")));
				$("dcbBankAcctCd").value = (row != null) ? row.dcbBankAcctCd : "";
				$("dspDcbBankAcctNo").value = (row != null) ? unescapeHTML2(row.dspDcbBankAcctNo) : "";
				$("dspDcbBankAcctNo").setAttribute("lastValidValue", unescapeHTML2($F("dspDcbBankAcctNo")));
				$("inputAmt").value = (row != null) ? formatCurrency($F("btnFcDtl") == "FC Details" ? row.amount : row.dspFcNet) : "";
				$("inputAmt").setAttribute("lastValidValue", unformatCurrencyValue($F("inputAmt")));
				$("dspCcyDesc").value = (row != null) ? unescapeHTML2(row.dspCcyDesc) : "";
				$("dspCcyDesc").setAttribute("lastValidValue", unescapeHTML2($F("dspCcyDesc")));
				$("currencyCd").value = (row != null) ? row.currencyCd : "";
				$("dspShortName").value = (row != null) ? unescapeHTML2(row.dspShortName) : "";
				$("currencyRt").value = (row != null) ? formatToNineDecimal(row.currencyRt) : "";
				$("particulars").value = (row != null) ? unescapeHTML2(row.particulars) : "";
				$("grossAmt").value = (row != null) ? row.grossAmt : "";
				$("commissionAmt").value = (row != null) ? row.commissionAmt : "";
				$("vatAmt").value = (row != null) ? row.vatAmt : "";
				$("fcCommAmt").value = (row != null) ? row.fcCommAmt : "";
				$("fcVatAmt").value = (row != null) ? row.fcVatAmt : "";
				$("fcGrossAmt").value = (row != null) ? row.fcGrossAmt : "";
				$("dspFcNet").value = (row != null) ? row.dspFcNet : "";
				$("dspFcNet").setAttribute("lastValidValue", $F("dspFcNet"));
				$("amount").value = (row != null) ? row.amount : "";
				$("amount").setAttribute("lastValidValue", $F("amount"));
				
				if (row == null) {
					$("btnAdd").value = "Add";
					disableButton("btnDelete");
					
					if (guf.fileStatus != "1") {
						setDfltAttrib(false);
					} else {
						setDfltAttrib(true);
						toggleFields();
					}
				} else {
					if (guf.fileStatus == "1") {
						enableButton("btnDelete");
						$("btnAdd").value = "Update";
						validatePayMode();
					}
				}
				
				objGUCD = row;
				clearChangeAttribute("collectionBreakdownBody");
			} catch (e) {
				showErrorMessage("setFieldValues", e);
			}
		}
		
		function populateORCollnDtls(tranId) {
			try {
				var origUrl = tbgGUCD.url;
				tbgGUCD.url = contextPath +"/GIACUploadingController?action=showGiacs609CollnDtlOverlay&refresh=1";
				tbgGUCD._refreshList();
				tbgGUCD.url = origUrl;
				delAll = "Y";

				new Ajax.Request(contextPath + "/GIACUploadingController", {
					method : "POST",
					parameters : {
						action : "getGiacs609ORCollnDtls",
						sourceCd : guf.sourceCd,
						fileNo : guf.fileNo,
						tranId : tranId
					},
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response) {
						hideNotice();
						if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)) {
							changeTagFunc = saveGiacs609CollnDtl;
							var obj = JSON.parse(response.responseText);

							for (var i = 0; i < obj.length; i++) {
								tbgGUCD.addBottomRow(obj[i]);

								if (obj[i].rownum_ == obj.length) {
									$("dspTotLoc").value = nvl(obj[i].dspTotLoc, 0);
									$("dspTotFc").value = nvl(obj[i].dspTotFc, 0);
								}
							}
							
							$("tranId").value = tranId;
							assignDspAmount();
							changeTag = 1;
							setFieldValues(null);
							tbgGUCD.keys.removeFocus(tbgGUCD.keys._nCurrentFocus, true);
							tbgGUCD.keys.releaseKeys();
						}
					}
				});
			} catch (e) {
				showErrorMessage("populateORCollnDtls", e);
			}
		}
		
		function addRec() {
			try {
				if (checkAllRequiredFieldsInDiv("collnDtlDiv")) {					
					changeTagFunc = saveGiacs609CollnDtl;
					var gucd = setRec(objGUCD);

					if ($F("btnAdd") == "Add") {
						tbgGUCD.addBottomRow(gucd);
						$("nextItemNo").value = parseInt($F("nextItemNo")) + 1;
					} else {
						tbgGUCD.updateVisibleRowOnly(gucd, rowIndex, false);
					}
					
					changeTag = 1;
					recomputeTotals(true, gucd);
					setFieldValues(null);
					tbgGUCD.keys.removeFocus(tbgGUCD.keys._nCurrentFocus, true);
					tbgGUCD.keys.releaseKeys();
				}
			} catch (e) {
				showErrorMessage("addRec", e);
			}
		}
		
		function setRec(rec) {
			try {
				var obj = (rec == null ? {} : rec);
				
				obj.sourceCd = escapeHTML2(guf.sourceCd);
				obj.fileNo = guf.fileNo;
				obj.itemNo = $F("btnAdd") == "Add" ? $F("nextItemNo") : $F("itemNo");
				obj.payMode = escapeHTML2($F("payMode"));
				obj.bankCd = $F("bankCd");
				obj.dspBankSname = escapeHTML2($F("dspBankSname"));
				obj.dspBankName = escapeHTML2($F("dspBankName"));
				obj.checkClass = escapeHTML2($F("checkClass"));
				obj.dspClassMean = $F("checkClass") == "" ? "" : escapeHTML2($("checkClass").options[$("checkClass").selectedIndex].text);
				obj.checkNo = escapeHTML2($F("checkNo"));
				obj.checkDate = escapeHTML2($F("checkDate"));
				obj.amount = $F("amount");
				obj.currencyCd = $F("currencyCd");
				obj.dspShortName = escapeHTML2($F("dspShortName"));
				obj.dspCcyDesc = escapeHTML2($F("dspCcyDesc"));
				obj.currencyRt = $F("currencyRt");
				obj.dcbBankCd = $F("dcbBankCd");
				obj.dspDcbBankName = escapeHTML2($F("dspDcbBankName"));
				obj.dcbBankAcctCd = $F("dcbBankAcctCd");
				obj.dspDcbBankAcctNo = escapeHTML2($F("dspDcbBankAcctNo"));
				obj.particulars = escapeHTML2($F("particulars"));
				obj.grossAmt = $F("grossAmt");
				obj.commissionAmt = $F("commissionAmt");
				obj.vatAmt = $F("vatAmt");
				obj.fcCommAmt = $F("fcCommAmt");
				obj.fcVatAmt = $F("fcVatAmt");
				obj.fcGrossAmt = $F("fcGrossAmt");
				obj.dspAmount = $F("btnFcDtl") == "FC Details" ? $F("amount") : $F("dspFcNet");
				obj.dspFcNet = $F("dspFcNet");

				return obj;
			} catch (e) {
				showErrorMessage("setRec", e);
			}
		}
		
		function populateDfltDcb(populate) {
			try {
				$("dcbBankCd").value = populate ? nvl(unescapeHTML2(parameters.dfltDcbBankCd), "") : "";
				$("dspDcbBankName").value = populate ? nvl(unescapeHTML2(parameters.dfltDcbBankName), "") : "";
				$("dspDcbBankName").setAttribute("lastValidValue", $F("dspDcbBankName"));
				$("dcbBankAcctCd").value = populate ? nvl(unescapeHTML2(parameters.dfltDcbBankAcctCd), "") : "";
				$("dspDcbBankAcctNo").value = populate ? nvl(unescapeHTML2(parameters.dfltDcbBankAcctNo), "") : "";
				$("dspDcbBankAcctNo").setAttribute("lastValidValue", $F("dspDcbBankAcctNo"));
				
				if ($F("dcbBankCd") == "") {
					disableSearch("lovDcbBankAcctNo");
				}
			} catch (e) {
				showErrorMessage("populateDfltDcb", e);
			}
		}
		
		/* functions: LOV */
		function showBankLOV(isIconClicked) {
			try {
				var searchString = isIconClicked ? "%" : ($F("dspBankName").trim() == "" ? "%" : $F("dspBankName"));

				LOV.show({
					controller : "ACUploadingLOVController",
					urlParameters : {
						action : "getGiacs609BankLOV",
						searchString : searchString,
						page : 1
					},
					title : "List of Banks",
					width : 380,
					height : 386,
					columnModel : [ {
						id : 'bankSname',
						title : 'Bank',
						width : '120px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					}, {
						id : 'bankName',
						title : 'Bank Name',
						width : '245px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					} ],
					draggable : true,
					autoSelectOneRecord : true,
					filterText : escapeHTML2(searchString),
					onSelect : function(row) {
						if (row != null || row != undefined) {
							$("bankCd").value = row.bankCd;
							$("dspBankName").value = unescapeHTML2(row.bankName);
							$("dspBankName").setAttribute("lastValidValue", unescapeHTML2(row.bankName));
							$("dspBankSname").value = unescapeHTML2(row.bankSname);
							
							changeTag = 1;
							changeTagFunc = saveGiacs609CollnDtl;
							
							if (isIconClicked) {
								$("dspBankName").focus();
							}
						}
					},
					onCancel : function() {
						$("dspBankName").focus();
						$("dspBankName").value = $("dspBankName").readAttribute("lastValidValue");
					},
					onUndefinedRow : function() {
						$("dspBankName").value = $("dspBankName").readAttribute("lastValidValue");
						customShowMessageBox("No record selected.", imgMessage.INFO, "dspBankName");
					}
				});
			} catch (e) {
				showErrorMessage("showBankLOV", e);
			}
		}
		
		function showCurrencyLOV(isIconClicked) {
			try {
				var searchString = isIconClicked ? "%" : ($F("dspCcyDesc").trim() == "" ? "%" : $F("dspCcyDesc"));

				LOV.show({
					controller : "ACUploadingLOVController",
					urlParameters : {
						action : "getGiacs609CurrencyLOV",
						searchString : searchString,
						page : 1
					},
					title : "List of Currency",
					width : 382,
					height : 386,
					columnModel : [ {
						id : 'shortName',
						title : 'Short Name',
						width : '85px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					}, {
						id : 'currencyDesc',
						title : 'Description',
						width : '180px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					}, {
						id : 'mainCurrencyCd',
						title : 'Currency Code',
						titleAlign : 'right',
						align : 'right',
						width : '100px',
						renderer : function(value) {
							return value;
						}
					} ],
					draggable : true,
					autoSelectOneRecord : true,
					filterText : escapeHTML2(searchString),
					onSelect : function(row) {
						if (row != null || row != undefined) {
							if (row.mainCurrencyCd != $F("guopCurrencyCd")) {
								customShowMessageBox("Chosen currency does not match uploaded currency.", imgMessage.INFO, "dspCcyDesc");
								$("dspCcyDesc").value = $("dspCcyDesc").readAttribute("lastValidValue");
							} else {
								$("currencyCd").value = row.mainCurrencyCd;
								$("dspCcyDesc").value = unescapeHTML2(row.currencyDesc);
								$("dspCcyDesc").setAttribute("lastValidValue", unescapeHTML2(row.currencyDesc));
								$("dspShortName").value = unescapeHTML2(row.shortName);
								$("currencyRt").value = formatToNineDecimal($F("guopConvertRate"));
								computeAmt();
								
								changeTag = 1;
								changeTagFunc = saveGiacs609CollnDtl;
								
								if (isIconClicked) {
									$("dspCcyDesc").focus();
								}
							}
						}
					},
					onCancel : function() {
						$("dspCcyDesc").focus();
						$("dspCcyDesc").value = $("dspCcyDesc").readAttribute("lastValidValue");
					},
					onUndefinedRow : function() {
						$("dspCcyDesc").value = $("dspCcyDesc").readAttribute("lastValidValue");
						customShowMessageBox("No record selected.", imgMessage.INFO, "dspCcyDesc");
					}
				});
			} catch (e) {
				showErrorMessage("showCurrencyLOV", e);
			}
		}

		function showDcbBankLOV(isIconClicked) {
			try {
				var searchString = isIconClicked ? "%" : ($F("dspDcbBankName").trim() == "" ? "%" : $F("dspDcbBankName"));

				LOV.show({
					controller : "ACUploadingLOVController",
					urlParameters : {
						action : "getGiacs609DcbBankLOV",
						searchString : searchString,
						page : 1
					},
					title : "List of DCB Banks",
					width : 380,
					height : 386,
					columnModel : [ {
						id : 'bankCd',
						title : 'Bank Code',
						width : '90px',
						titleAlign : 'right',
						align : 'right',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					}, {
						id : 'bankName',
						title : 'Bank Name',
						width : '275px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					} ],
					draggable : true,
					autoSelectOneRecord : true,
					filterText : escapeHTML2(searchString),
					onSelect : function(row) {
						if (row != null || row != undefined) {
							$("dcbBankCd").value = row.bankCd;
							$("dspDcbBankName").value = unescapeHTML2(row.bankName);
							$("dspDcbBankName").setAttribute("lastValidValue", unescapeHTML2(row.bankName));

							$("dcbBankAcctCd").clear();
							$("dspDcbBankAcctNo").clear();
							$("dspDcbBankAcctNo").readOnly = false;
							enableSearch("lovDcbBankAcctNo");
							
							changeTag = 1;
							changeTagFunc = saveGiacs609CollnDtl;
							
							if (isIconClicked) {
								$("dspDcbBankName").focus();
							}
						}
					},
					onCancel : function() {
						$("dspDcbBankName").focus();
						$("dspDcbBankName").value = $("dspDcbBankName").readAttribute("lastValidValue");
					},
					onUndefinedRow : function() {
						$("dspDcbBankName").value = $("dspDcbBankName").readAttribute("lastValidValue");
						customShowMessageBox("No record selected.", imgMessage.INFO, "dspDcbBankName");
					}
				});
			} catch (e) {
				showErrorMessage("showDcbBankLOV", e);
			}
		}

		function showDcbBankAcctLOV(isIconClicked) {
			try {
				var searchString = isIconClicked ? "%" : ($F("dspDcbBankAcctNo").trim() == "" ? "%" : $F("dspDcbBankAcctNo"));

				LOV.show({
					controller : "ACUploadingLOVController",
					urlParameters : {
						action : "getGiacs609DcbBankAcctLOV",
						dcbBankCd : $F("dcbBankCd"),
						searchString : searchString,
						page : 1
					},
					title : "List of DCB Bank Accounts",
					width : 380,
					height : 386,
					columnModel : [ {
						id : 'bankAcctCd',
						title : 'Bank Acct Cd',
						altTitle : 'Bank Account Code',
						width : '100px',
						titleAlign : 'right',
						align : 'right',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					}, {
						id : 'bankAcctNo',
						title : 'Bank Account No.',
						width : '250px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					} ],
					draggable : true,
					autoSelectOneRecord : true,
					filterText : escapeHTML2(searchString),
					onSelect : function(row) {
						if (row != null || row != undefined) {
							$("dcbBankAcctCd").value = row.bankAcctCd;
							$("dspDcbBankAcctNo").value = unescapeHTML2(row.bankAcctNo);
							$("dspDcbBankAcctNo").setAttribute("lastValidValue", unescapeHTML2(row.bankAcctNo));
							
							changeTag = 1;
							changeTagFunc = saveGiacs609CollnDtl;
							
							if (isIconClicked) {
								$("dspDcbBankAcctNo").focus();
							}
						}
					},
					onCancel : function() {
						$("dspDcbBankAcctNo").focus();
						$("dspDcbBankAcctNo").value = $("dspDcbBankAcctNo").readAttribute("lastValidValue");
					},
					onUndefinedRow : function() {
						$("dspDcbBankAcctNo").value = $("dspDcbBankAcctNo").readAttribute("lastValidValue");
						customShowMessageBox("No record selected.", imgMessage.INFO, "dspDcbBankAcctNo");
					}
				});
			} catch (e) {
				showErrorMessage("showDcbBankAcctLOV", e);
			}
		}
		
		function showORLOV() {
			try {
				LOV.show({
					controller : "ACUploadingLOVController",
					urlParameters : {
						action : "getGiacs609ORLOV",
						orDate : $F("txtNbtORDate"),
						page : 1
					},
					title : "List of ORs",
					width : 550,
					height : 402,
					columnModel : [ {
						id : 'branchCd',
						title : 'Branch Cd',
						altTitle : 'Branch Code',
						width : '80px',
						align : 'center',
						titleAlign : 'center',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					}, {
						id : 'orDate',
						title : 'OR Date',
						align : 'center',
						titleAlign: 'center',
						width : '80px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					}, {
						id : 'dcbNo',
						title : 'DCB No.',
						width : '80px',
						align : 'right',
						titleAlign: 'right',
						renderer : function(value) {
							return value;
						}
					}, {
						id : 'particulars',
						title : 'Particulars',
						width : '450px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					}, {
						id : 'orNo',
						title : 'OR No.',
						width : '120px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					} ],
					draggable : true,
					autoSelectOneRecord : false,
					onSelect : function(row) {
						showConfirmBox("Confirmation", "The collection details provided will be changed to the collection details of "
							+ "the chosen particulars. Do you wish to proceed?",
							"Yes", "No", function() {
								if (row.hasCollnDtl == "N") {
									customShowMessageBox("The OR selected has no collection details.", imgMessage.ERROR, "particulars");
								} else {
									populateORCollnDtls(row.tranId);
									changeTag = 1;
									changeTagFunc = saveGiacs609CollnDtl;
									$("particulars").focus();
								}
							}, function() {
								$("particulars").focus();
							}, null);
					},
					onCancel : function() {
						$("particulars").focus();
						$("particulars").value = $("particulars").readAttribute("lastValidValue");
					},
					onUndefinedRow : function() {
						$("particulars").value = $("particulars").readAttribute("lastValidValue");
						customShowMessageBox("No record selected.", imgMessage.INFO, "particulars");
					}
				});
			} catch (e) {
				showErrorMessage("showORLOV", e);
			}
		}
		
		/* functions: set attributes */
		function initAll() {
			try {
				if (guf.fileStatus != "1") {
					setDfltAttrib(false);
					$("btnReturn").focus();
				} else {
					$$("div#collnDtlDiv input[type='text']").each(function(o) {
						if ($(o).hasClassName("money2")) {
							$(o).clear();
							$(o).readOnly = false;
						}
					});
					
					setDfltAttrib(true);
					$("txtTotAmount").focus();
				}
	
				disableButton("btnDelete");			
				initializeAllMoneyFields();
			} catch (e) {
				showErrorMessage("initAll", e);
			}
		}
		
		function setDfltAttrib(dflt) {
			try {
				if (!dflt) {
					$$("div#collnDtlDiv input[name='collnDtlTxt'], div#collnDtlDiv textarea[name='particulars'], "
							+ "div#collnDtlDiv select[name='collnDtlSelect']").each(function(o) {
								$(o).clear();
								$(o).readOnly = true;
								$(o).disabled = true;
								$(o).removeClassName("required");
					});
	
					$$("div#collnDtlDiv img[name='collnDtlLov']").each(function(o) {
						disableSearch($(o));
					});
					
					$$("div#collnDtlDiv div[name='backDiv']").each(function(o) {
						$(o).style.backgroundColor = "#d4d0c8";
					});
					
					disableDate("hrefCheckDate");
					disableButton("btnAdd");
					disableButton("btnSave");
				} else {
					$("bankCd").clear();
					$("dspBankSname").clear();
					$("dspBankName").clear();
					$("checkClass").clear();
					$("checkNo").clear();
					$("checkDate").clear();
					$("payMode").disabled = false;
					$("inputAmt").readOnly = false;
					$("dspCcyDesc").readOnly = false;
					$("dspBankName").disabled = true;
					$("checkClass").disabled = true;
					$("checkNo").disabled = true;
					$("checkDate").disabled = true;
					$("dspDcbBankName").disabled = false;
					$("dspDcbBankAcctNo").disabled = false;
					$("particulars").disabled = false;
					disableSearch("lovBank");
					enableSearch("lovCurrency");
					disableDate("hrefCheckDate");
					enableSearch("lovDcvBankName");
					enableSearch("lovDcbBankAcctNo");
					$("dspBankName").removeClassName("required");
					$("checkClass").removeClassName("required");
					$("checkNo").removeClassName("required");
					$("checkDate").removeClassName("required");
					$("dspDcbBankName").removeClassName("required");
					$("dspDcbBankAcctNo").removeClassName("required");
					$("dcbBankNameDiv").style.removeProperty("background-color");
					$("dcbBankAcctDiv").style.removeProperty("background-color");
					$("dcbBankNameDiv").removeClassName("required");
					$("dcbBankAcctDiv").removeClassName("required");
					$("bankDiv").style.backgroundColor = "#d4d0c8";
					$("checkDateBack").style.backgroundColor = "#d4d0c8";
					populateDfltDcb(false);
				}
			} catch (e) {
				showErrorMessage("setDfltAttrib", e);
			}
		}
		
		function validatePayMode() {
			try {
				if ($F("payMode") == "CA") {
					$("bankCd").clear();
					$("dspBankSname").clear();
					$("dspBankName").clear();
					$("checkClass").clear();
					$("checkNo").clear();
					$("checkDate").clear();
					$("dspBankName").disabled = true;
					$("checkClass").disabled = true;
					$("checkNo").disabled = true;
					$("checkDate").disabled = true;
					$("dspDcbBankName").disabled = false;
					$("dspDcbBankAcctNo").disabled = false;
					disableSearch("lovBank");
					disableDate("hrefCheckDate");
					enableSearch("lovDcvBankName");
					enableSearch("lovDcbBankAcctNo");
					$("dspBankName").removeClassName("required");
					$("checkClass").removeClassName("required");
					$("checkNo").removeClassName("required");
					$("checkDate").removeClassName("required");
					$("bankDiv").removeClassName("required");
					$("checkDateBack").removeClassName("required");
					$("bankDiv").style.backgroundColor = "#d4d0c8";
					$("checkDateBack").style.backgroundColor = "#d4d0c8";
					$("dcbBankNameDiv").style.removeProperty("background-color");
					$("dcbBankAcctDiv").style.removeProperty("background-color");
					$("dspDcbBankName").addClassName("required");
					$("dspDcbBankAcctNo").addClassName("required");
					$("dcbBankNameDiv").addClassName("required");
					$("dcbBankAcctDiv").addClassName("required");
					$F("dcbBankCd") == "" ? populateDfltDcb(true) : null;
				} else if ($F("payMode") == "CHK") {
					$("dspBankName").disabled = false;
					$("checkClass").disabled = false;
					$("checkNo").disabled = false;
					$("checkDate").disabled = false;
					$("dspDcbBankName").disabled = false;
					$("dspDcbBankAcctNo").disabled = false;
					enableSearch("lovBank");
					enableDate("hrefCheckDate");
					enableSearch("lovDcvBankName");
					enableSearch("lovDcbBankAcctNo");
					$("dspBankName").addClassName("required");
					$("checkClass").addClassName("required");
					$("checkNo").addClassName("required");
					$("checkDate").addClassName("required");
					$("bankDiv").style.removeProperty("background-color");
					$("checkDateBack").style.removeProperty("background-color");
					$("bankDiv").addClassName("required");
					$("checkDateBack").addClassName("required");
					$("dcbBankNameDiv").style.removeProperty("background-color");
					$("dcbBankAcctDiv").style.removeProperty("background-color");
					$("dspDcbBankName").addClassName("required");
					$("dspDcbBankAcctNo").addClassName("required");
					$("dcbBankNameDiv").addClassName("required");
					$("dcbBankAcctDiv").addClassName("required");
					$F("dcbBankCd") == "" ? populateDfltDcb(true) : null;
				} else if ($F("payMode") == "CC") {
					$("checkDate").clear();
					$("checkClass").clear();
					$("dspBankName").disabled = false;
					$("checkClass").disabled = true;
					$("checkNo").disabled = false;
					$("checkDate").disabled = true;
					$("dspDcbBankName").disabled = false;
					$("dspDcbBankAcctNo").disabled = false;
					enableSearch("lovBank");
					disableDate("hrefCheckDate");
					enableSearch("lovDcvBankName");
					enableSearch("lovDcbBankAcctNo");
					$("dspBankName").addClassName("required");
					$("checkClass").removeClassName("required");
					$("checkNo").addClassName("required");
					$("checkDate").removeClassName("required");
					$("bankDiv").style.removeProperty("background-color");
					$("bankDiv").addClassName("required");
					$("checkDateBack").removeClassName("required");
					$("checkDateBack").style.backgroundColor = "#d4d0c8";
					$("dcbBankNameDiv").style.removeProperty("background-color");
					$("dcbBankAcctDiv").style.removeProperty("background-color");
					$("dspDcbBankName").addClassName("required");
					$("dspDcbBankAcctNo").addClassName("required");
					$("dcbBankNameDiv").addClassName("required");
					$("dcbBankAcctDiv").addClassName("required");
					$F("dcbBankCd") == "" ? populateDfltDcb(true) : null;
				} else if ($F("payMode") == "CM" || $F("payMode") == "WT") {
					$("checkClass").clear();
					$("dspBankName").disabled = false;
					$("checkClass").disabled = true;
					$("checkNo").disabled = false;
					$("checkDate").disabled = false;
					$("dspDcbBankName").disabled = false;
					$("dspDcbBankAcctNo").disabled = false;
					enableSearch("lovBank");
					enableDate("hrefCheckDate");
					enableSearch("lovDcvBankName");
					enableSearch("lovDcbBankAcctNo");
					$("dspBankName").addClassName("required");
					$("checkClass").removeClassName("required");
					$("checkNo").removeClassName("required");
					$("checkDate").removeClassName("required");
					$("bankDiv").style.removeProperty("background-color");
					$("checkDateBack").style.removeProperty("background-color");
					$("bankDiv").addClassName("required");
					$("checkDateBack").removeClassName("required");
					$("dcbBankNameDiv").style.removeProperty("background-color");
					$("dcbBankAcctDiv").style.removeProperty("background-color");
					$("dspDcbBankName").addClassName("required");
					$("dspDcbBankAcctNo").addClassName("required");
					$("dcbBankNameDiv").addClassName("required");
					$("dcbBankAcctDiv").addClassName("required");
					$F("dcbBankCd") == "" ? populateDfltDcb(true) : null;
				} else if ($F("payMode") == "CW") {
					$("bankCd").clear();
					$("dspBankSname").clear();
					$("dspBankName").clear();
					$("checkClass").clear();
					$("dspBankName").disabled = true;
					$("checkClass").disabled = true;
					$("checkNo").disabled = false;
					$("checkDate").disabled = false;
					$("dspDcbBankName").disabled = true;
					$("dspDcbBankAcctNo").disabled = true;
					disableSearch("lovBank");
					enableDate("hrefCheckDate");
					disableSearch("lovDcvBankName");
					disableSearch("lovDcbBankAcctNo");
					$("dspBankName").removeClassName("required");
					$("checkClass").removeClassName("required");
					$("checkNo").removeClassName("required");
					$("checkDate").removeClassName("required");
					$("dspDcbBankName").removeClassName("required");
					$("dspDcbBankAcctNo").removeClassName("required");
					$("dcbBankNameDiv").removeClassName("required");
					$("dcbBankAcctDiv").removeClassName("required");
					$("bankDiv").removeClassName("required");
					$("checkDateBack").removeClassName("required");
					$("bankDiv").style.backgroundColor = "#d4d0c8";
					$("checkDateBack").style.removeProperty("background-color");
					$("dcbBankNameDiv").style.backgroundColor = "#d4d0c8";
					$("dcbBankAcctDiv").style.backgroundColor = "#d4d0c8";
					populateDfltDcb(false);
				} else if ($F("payMode") == "") {
					setDfltAttrib(true);
				}
				
				toggleFields();
			} catch (e) {
				showErrorMessage("validatePayMode", e);
			}
		}
		
		function toggleFields() {
			try {
				if ($F("tranId") != "" && $F("txtTotAmount") != 0) {
					$("payMode").disabled = true;
					$("checkClass").disabled = true;
					disableDate("hrefCheckDate");
					disableButton("btnAdd");
					
					$$("div#collnDtlDiv input[name='collnDtlTxt'], div#collnDtlDiv textarea").each(function(o) {
						$(o).readOnly = true;
					});
					
					$$("div#collnDtlDiv img[name='collnDtlLov']").each(function(o) {
						if ($(o).id != "lovOR") {
							disableSearch($(o));
						}
					});
				} else {
					if (guf.fileStatus == 1) {
						$$("div#collnDtlDiv input[name='collnDtlTxt'], div#collnDtlDiv textarea").each(function(o) {
							$(o).readOnly = ($(o).id != "currencyRt" ? false : true);
						});
						
						enableButton("btnAdd");
						$("tranId").value = "";
					}
				}
			} catch (e) {
				showErrorMessage("toggleFields", e);
			}
		}
		
		/* functions: computation */
		function recomputeTotals(add, row) {
			try {
				var prevAmt = parseFloat(nvl($("amount").readAttribute("lastValidValue"), 0));
				var prevFcNet = parseFloat(nvl($("dspFcNet").readAttribute("lastValidValue"), 0));
				
				if (add) {
					$("dspTotLoc").value = parseFloat($F("dspTotLoc")) + parseFloat(nvl(row.amount, 0)) - prevAmt;
					$("dspTotFc").value = parseFloat($F("dspTotFc")) + parseFloat(nvl(row.dspFcNet, 0)) - prevFcNet;
				} else {
					$("dspTotLoc").value = parseFloat($F("dspTotLoc")) - parseFloat(nvl(row.amount, 0));
					$("dspTotFc").value = parseFloat($F("dspTotFc")) - parseFloat(nvl(row.dspFcNet, 0));
				}
				
				if ($F("btnFcDtl") == "FC Details") {
					$("txtTotAmount").value = formatCurrency($F("dspTotLoc"));
				} else {
					$("txtTotAmount").value = formatCurrency($F("dspTotFc"));
				}
				
				
			} catch (e) {
				showErrorMessage("recomputeTotals", e);
			}
		}
		
		function computeAmt() {
			try {
				if ($F("inputAmt") == "") {
					$("amount").value = "";
					$("dspFcNet").value = "";
					$("fcGrossAmt").value = "";
					$("grossAmt").value = "";
					return;
				}
				
				var fcAmt = 0;
				var locAmt = 0;
				
				if ($F("btnFcDtl") == "FC Details") {
					fcAmt = parseFloat(unformatCurrencyValue($F("inputAmt"))) / parseFloat(nvl($F("currencyRt"), 1));
					locAmt = parseFloat(unformatCurrencyValue($F("inputAmt")));
				} else {
					fcAmt = parseFloat(unformatCurrencyValue($F("inputAmt")));
					locAmt = parseFloat(unformatCurrencyValue($F("inputAmt"))) * parseFloat(nvl($F("currencyRt"), 1));
				}
				
				$("amount").value = Number(Math.round(locAmt + 'e2') + 'e-2');
				$("dspFcNet").value = Number(Math.round(fcAmt + 'e2') + 'e-2');
				$("fcGrossAmt").value = parseFloat($F("dspFcNet")) + parseFloat(nvl($F("fcCommAmt"), 0)) + parseFloat(nvl($F("fcVatAmt"), 0));
				$("grossAmt").value = parseFloat($F("amount")) + parseFloat(nvl($F("commissionAmt"), 0)) + parseFloat(nvl($F("vatAmt"), 0));
			} catch (e) {
				showErrorMessage("computeAmt", e);
			}
		}
		
		/* functions: validation */
		function validateCheckDate() {
			try {
				if ($F("payMode") == "CHK") {
					if ($F("checkDate") != "") {
						var orDate = Date.parse($F("txtNbtORDate"));
						var checkDate = Date.parse($F("checkDate"));
						var staleDate = Date.parse($F("txtNbtORDate"));
						var staleParam = $F("checkClass") == "M" ? parseInt(parameters.staleMgrChk) : parseInt(parameters.staleCheck);
						staleDate = new Date(staleDate.addMonths(staleParam * -1));

						if (checkDate > orDate) {
							$("checkDate").clear();
							customShowMessageBox("This check is post-dated.", imgMessage.INFO, "checkDate");
							return;
						}

						if (checkDate <= staleDate) {
							$("checkDate").clear();
							customShowMessageBox("This is a stale check.", imgMessage.INFO, "checkDate");
							return;
						}

						var checkStDate = new Date(checkDate.addMonths(staleParam));
						var staleDaysNo = (checkStDate - orDate) / (1000 * 60 * 60 * 24);
						if (staleDaysNo <= parseInt(parameters.staleDays) && staleDaysNo != 0) {
							if (staleDaysNo == 1) {
								showMessageBox("This check will be stale tomorrow.", imgMessage.INFO);
								return false;
							} else {
								showMessageBox("This check will be stale within " + staleDaysNo + " days.", imgMessage.INFO);
								return false;
							}
						}
					}
				}
			} catch (e) {
				showErrorMessage("validateCheckDate", e);
			}
		}
		
		function checkPending() {
			try {
				var pending = false;
				if ($("btnAdd").disabled == false) {
					$$("div#collectionBreakdownBody input[name='collnDtlTxt'], div#collectionBreakdownBody textarea, "
						+ "div#collectionBreakdownBody select[name='collnDtlSelect']").each(function(o) {
							if ($(o).hasAttribute("changed")) {
								pending = true;
							}
					});
				}
				return pending;
			} catch (e) {
				showErrorMessage("checkPending", e);
			}
		}
		
		function validCurrency() {
			try {
				var valid = true;
				for (var i = 0; i < tbgGUCD.geniisysRows.length; i++) {
					var rowStyle = $('mtgRow'+tbgGUCD._mtgId+'_'+i).getStyle("display");
		            if (tbgGUCD.geniisysRows[i].currencyCd != $F("guopCurrencyCd") && rowStyle != "none") {
		            	valid = false;
						break;
		            }
		        }
				return valid;
			} catch (e) {
				showErrorMessage("validCurrency", e);
			}
		}
		
		function validateCollnAmt(){
			try {
				new Ajax.Request(contextPath+"/GIACUploadingController",{
					method : "POST",
					parameters : {
						action : "validateCollnAmtGiacs609",
						sourceCd : guf.sourceCd,
						fileNo : guf.fileNo
					},
					onComplete: function(response) {
						if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
							overlayCollnDtl.close();
							changeTag = 0;
							delAll = "N";
						}
					}
				});	
			} catch (e) {
				showErrorMessage("validateCollnAmt", e);
			}
		}
		
		/* functions: button */
		function saveGiacs609CollnDtl(closeOverlay) {
			try {
				if (changeTag == 0) {
					showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
					return;
				}
					
				if (checkPending()) {
					var msg = "You have changes in collection breakdown. Press " + $F("btnAdd") + " button first to apply changes";
					msg = $F("btnAdd") == "Add" ? msg + "." : msg + " otherwise unselect the record to clear changes.";
					showMessageBox(msg);
					return;
				}
				
				if (!validCurrency()) {
					showMessageBox("The currency of selected OR does not match uploaded currency.");
					return;
				}
					
				var setRows = getAddedAndModifiedJSONObjects(tbgGUCD.geniisysRows);
				var delRows = getDeletedJSONObjects(tbgGUCD.geniisysRows);
				new Ajax.Request(contextPath + "/GIACUploadingController", {
					method : "POST",
					parameters : {
						action : "saveGiacs609CollnDtls",
						setRows : prepareJsonAsParameter(setRows),
						delRows : prepareJsonAsParameter(delRows),
						delAll : delAll,
						sourceCd : guf.sourceCd,
						fileNo : guf.fileNo
					},
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response) {
						hideNotice();
						if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)) {
							changeTagFunc = "";
							showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function() {
								if (closeOverlay) {
									exitOverlay();
								} else {
									$("dspTotLoc").setAttribute("lastValidValue", $F("dspTotLoc"));
									tbgGUCD._refreshList();
								}
							});
							changeTag = 0;
							delAll = "N";
						}
					}
				});
			} catch (e) {
				showErrorMessage("saveGiacs609CollnDtl", e);
			}
		}
		
		function toggleFcBtn() {
			try {
				var colIndexDsp = tbgGUCD.getColumnIndex("dspAmount");
				var mtgId = tbgGUCD._mtgId;
				var colTitle = null;
				var altTitle = null;
				var origText = $('mtgIHC' + mtgId + '_' + colIndexDsp).innerHTML;
				
				if ($F("btnFcDtl") == "FC Details") {
					colTitle = "Foreign Currency Amt";
					altTitle = "Foreign Currency Amount";
					$("btnFcDtl").value = "Hide FC Details";
					$("txtTotAmount").value = formatCurrency($F("dspTotFc"));
					$("inputAmt").value = formatCurrency($F("dspFcNet"));
				} else {
					colTitle = "Local Currency Amt";
					altTitle = "Local Currency Amount";
					$("btnFcDtl").value = "FC Details";
					$("txtTotAmount").value = formatCurrency($F("dspTotLoc"));
					$("inputAmt").value = formatCurrency($F("amount"));
				}
				
				$("inputAmt").setAttribute("lastValidValue", unformatCurrencyValue($F("inputAmt")));
				$('mtgIHC' + mtgId + '_' + colIndexDsp).innerHTML = colTitle + origText.substring(origText.indexOf("&"));
				$('mtgIHC' + mtgId + '_' + colIndexDsp).setAttribute("title", altTitle);
				$('mtgIHC' + mtgId + '_' + colIndexDsp).setAttribute("alt", altTitle);
				$("totAmtLabel").innerHTML = altTitle;
				$("inputAmtLabel").innerHTML = altTitle;
				assignDspAmount();
			} catch (e) {
				showErrorMessage("toggleFcBtn", e);
			}
		}
		
		function exitOverlay() {
			validateCollnAmt();
		}
		
		/* populate */
		populateTableGrid();
		initAll();
		initializeAll();
		initializeChangeAttribute("collectionBreakdownBody");
	} catch (e) {
		showErrorMessage("Page Error", e);
	}
</script>