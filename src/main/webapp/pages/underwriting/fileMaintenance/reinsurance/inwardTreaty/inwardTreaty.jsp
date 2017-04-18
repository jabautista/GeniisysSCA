<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss032MainDiv" name="giiss032MainDiv" style="">
	<div id="giiss032MenuDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="menuFileMaintenanceExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Inward Treaty Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	<div id="giiss032" name="giiss032">
		<div class="sectionDiv">
			<div id="giisIntreatyListTGDiv" style="padding-top: 10px;">
				<div id="giisIntreatyListTable" style="height: 340px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="giiss032FormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Treaty No.</td>
						<td class="leftAligned">
							<span class="lovSpan required" style="width: 78px; height: 21px; margin: 2px 3px 0 0; float: left;">
								<input id="txtLineCd" type="text" class="required" style="width: 53px; text-align: left; height: 12px; float: left; border: none;" tabindex="201" maxlength="2">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchLine" name="imgSearchLine" alt="Go" style="float: right;">
							</span>
							<input id="txtTrtyYy" type="text" class="required integerNoNegativeUnformatted" style="width: 50px; text-align: right;" tabindex="202" maxlength="3">
							<input id="txtTrtySeqNo" type="text" class="required integerNoNegativeUnformatted" style="width: 70px; text-align: right;" tabindex="203" maxlength="2">
						</td>
						<td class="rightAligned">Prop. / Non-Prop.</td>
						<td>
							<input type="radio" id="rdoProp" name="uwTreatyType" value="P" tabindex="204" style="margin-left: 15px; float: left;" checked="checked"/>
							<label for="rdoProp" style="margin-top: 3px;">Proportional</label>
						</td>
						<td>
							<input type="radio" id="rdoNonProp" name="uwTreatyType" value="N" tabindex="205" style="margin-left: 15px; float: left;"/>
							<label for="rdoNonProp" style="margin-top: 3px;">Non-proportional</label>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Treaty Name</td>
						<td class="leftAligned">
							<input id="txtTrtyName" type="text" style="width: 215px;" tabindex="206" maxlength="30">
						</td>
						<td class="rightAligned">Portfolio / Nat. Exp.</td>
						<td>
							<input type="radio" id="rdoPortfolio" name="prtFolioSw" value="P" tabindex="207" style="margin-left: 15px; float: left;"/>
							<label for="rdoPortfolio" style="margin-top: 3px;">Portfolio</label>
						</td>
						<td>
							<input type="radio" id="rdoNatExp" name="prtFolioSw" value="N" tabindex="208" style="margin-left: 15px; float: left;" checked="checked"/>
							<label for="rdoNatExp" style="margin-top: 3px;">Natural Expiry</label>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Cedant</td>
						<td class="leftAligned">
							<span class="lovSpan required" style="width: 221px; height: 22px; margin: 0px 0px 0 0; float: left;">
								<input id="txtDspRiSname" type="text" class="required" style="width: 196px; text-align: left; height: 13px; float: left; border: none;" tabindex="209" maxlength="15">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchCedant" name="imgSearchCedant" alt="Go" style="float: right;">
								<input type="hidden" id="txtRiCd">
							</span>
						</td>
						<td class="rightAligned">Currency</td>
						<td class="leftAligned" colspan="2">
							<span class="lovSpan" style="width: 227px; height: 22px; margin: 0px 0px 0 0; float: left;">
								<input id="txtDspCurrencyName" type="text" style="width: 202px; text-align: left; height: 13px; float: left; border: none;" tabindex="210" maxlength="20">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchCurrency" name="imgSearchCurrency" alt="Go" style="float: right;">
								<input type="hidden" id="txtCurrencyCd">
							</span>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Limit</td>
						<td class="leftAligned" style="width: 254px;">
							<input class="money4" id="txtTrtyLimit" type="text" style="width: 215px; text-align: right;" tabindex="211" maxlength="18" errorMsg = "Invalid Limit. Valid value should be from -99,999,999,999,999.99 to 99,999,999,999,999.99." min="-99999999999999.99" max="99999999999999.99">
						</td>
						<td class="rightAligned">Acctg Type</td>
						<td class="leftAligned" colspan="2">
							<span class="lovSpan" style="width: 227px; height: 22px; margin: 0px 0px 0 0; float: left;">
								<input id="txtDspAcTypeSname" type="text" style="width: 202px; text-align: left; height: 13px; float: left; border: none;" tabindex="212" maxlength="30">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchAcctgType" name="imgSearchAcctgType" alt="Go" style="float: right;">
								<input type="hidden" id="txtCaTrtyType">
							</span>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Share %</td>
						<td class="leftAligned" style="width: 254px;">
							<input id="txtTrtyShrPct" class="nthDecimal2" type="text" style="width: 215px; text-align: right;" tabindex="213" maxlength="14" errorMsg = "Invalid Share %. Valid value should be from -999.999999999 to 999.999999999." min="-999.999999999" max="999.999999999">
						</td>
						<td width="" class="rightAligned">Share Amt.</td>
						<td class="leftAligned" colspan="2">
							<input class="money4" id="txtTrtyShrAmt" type="text" style="width: 221px; text-align: right;" tabindex="214" maxlength="18" errorMsg = "Invalid Share Amt. Valid value should be from -99,999,999,999,999.99 to 99,999,999,999,999.99." min="-99999999999999.99" max="99999999999999.99">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Inception</td>
						<td class="leftAligned">
							<span class="lovSpan required" style="width: 221px; height: 22px; margin: 0px 0px 0 0; float: left;">
								<input id="txtEffDate" type="text" class="required" style="width: 196px; text-align: left; height: 13px; float: left; border: none;" tabindex="215">
								<img id="imgEffDate" alt="imgEffDate" style="margin-top: 2px; margin-left: 1px; margin-right: 2px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"/>
							</span>
						</td>
						<td class="rightAligned">Expiration</td>
						<td class="leftAligned" colspan="2">
							<span class="lovSpan required" style="width: 227px; height: 22px; margin: 0px 0px 0 0; float: left;">
								<input id="txtExpiryDate" class="required" type="text" style="width: 202px; text-align: left; height: 13px; float: left; border: none;" tabindex="216" maxlength="20">
								<img id="imgExpiryDate" alt="imgExpiryDate" style="margin-top: 2px; margin-left: 1px; margin-right: 2px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"/>
							</span>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">No. of Lines</td>
						<td class="leftAligned" style="width: 254px;">
							<input class="integerNoNegativeUnformatted" id="txtNoOfLines" type="text" style="width: 215px; text-align: right;" tabindex="217" maxlength="4">
						</td>
						<td width="" class="rightAligned">Exc. Loss Rate</td>
						<td class="leftAligned" colspan="2">
							<input id="txtExcLossRt" type="text" style="width: 221px; text-align: right;" tabindex="218" class="nthDecimal2" maxlength="14" errorMsg = "Invalid Exc. Loss Rate. Valid value should be from -999.999999999 to 999.999999999." min="-999.999999999" max="999.999999999">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Cash Call Limit</td>
						<td class="leftAligned" style="width: 254px;">
							<input class="money4" id="txtCcallLimit" type="text" style="width: 215px; text-align: right;" tabindex="219" maxlength="18" errorMsg = "Invalid Cash Call Limit. Valid value should be from -99,999,999,999,999.99 to 99,999,999,999,999.99." min="-99999999999999.99" max="99999999999999.99">
						</td>
						<td width="" class="rightAligned">Est. Prem. Inc</td>
						<td class="leftAligned" colspan="2">
							<input class="money4" id="txtEstPremInc" type="text" style="width: 221px; text-align: right;" tabindex="220" maxlength="14" errorMsg = "Invalid Est. Prem. Inc. Valid value should be from -9,999,999,999.99 to 9,999,999,999.99." min="-9999999999.99" max="9999999999.99">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">In Excess Amt.</td>
						<td class="leftAligned" style="width: 254px;">
							<input class="money4" id="txtInxsAmt" type="text" style="width: 215px; text-align: right;" tabindex="221" maxlength="18" errorMsg = "Invalid In Excess Amt. Valid value should be from -99,999,999,999,999.99 to 99,999,999,999,999.99." min="-99999999999999.99" max="99999999999999.99">
						</td>
						<td width="" class="rightAligned">Prem. Deposit</td>
						<td class="leftAligned" colspan="2">
							<input class="money4" id="txtDepPrem" type="text" style="width: 221px; text-align: right;" tabindex="222" maxlength="14" errorMsg = "Invalid Prem. Deposit. Valid value should be from -9,999,999,999.99 to 9,999,999,999.99." min="-9999999999.99" max="9999999999.99">
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="4">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 605px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 579px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="223"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="224"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned" style="width: 254px;"><input id="txtUserId" type="text" class="" style="width: 215px;" readonly="readonly" tabindex="225"></td>
						<td width="" class="rightAligned">Last Update</td>
						<td class="leftAligned" colspan="2"><input id="txtLastUpdate" type="text" class="" style="width: 221px;" readonly="readonly" tabindex="226"></td>
					</tr>
				</table>
			</div>
			<div align="center" style="margin: 10px;">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="227">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="228">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="229">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="210">
</div>
<script type="text/javascript">
	setModuleId("GIISS032");
	setDocumentTitle("Inward Treaty Maintenance");
	initializeAll();
	initializeAccordion();
	initializeAllMoneyFields();
	changeTag = 0;
	var rowIndex = -1;
	
	var objGIISS032 = {};
	var objCurrIntreaty = null;
	objGIISS032.intreatyList = JSON.parse('${jsonIntreatyList}');
	objGIISS032.exitPage = null;
	
	var giisIntreatyTable = {
			url : contextPath + "/GIISIntreatyController?action=showGiiss032&refresh=1",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrIntreaty = tbgIntreaty.geniisysRows[y];
					setFieldValues(objCurrIntreaty);
					tbgIntreaty.keys.removeFocus(tbgIntreaty.keys._nCurrentFocus, true);
					tbgIntreaty.keys.releaseKeys();
					$("txtLineCd").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgIntreaty.keys.removeFocus(tbgIntreaty.keys._nCurrentFocus, true);
					tbgIntreaty.keys.releaseKeys();
					$("txtLineCd").focus();
				},
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgIntreaty.keys.removeFocus(tbgIntreaty.keys._nCurrentFocus, true);
						tbgIntreaty.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
				onSort: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgIntreaty.keys.removeFocus(tbgIntreaty.keys._nCurrentFocus, true);
					tbgIntreaty.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgIntreaty.keys.removeFocus(tbgIntreaty.keys._nCurrentFocus, true);
					tbgIntreaty.keys.releaseKeys();
				},
				prePager: function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
					rowIndex = -1;
					setFieldValues(null);
					tbgIntreaty.keys.removeFocus(tbgIntreaty.keys._nCurrentFocus, true);
					tbgIntreaty.keys.releaseKeys();
				},
				checkChanges: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetail: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTag == 1 ? true : false);
				}
			},
			columnModel : [
				{ 								// this column will only use for deletion
				    id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
				    width: '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},
				{
					id: 'lineCd trtyYy trtySeqNo',
					title: 'Treaty No.',
				    width : '120px',
				    children : [
						{
							id : "lineCd",
							title : 'Line Code',
							width : 45,
							align : "left",
							filterOption: true,
							renderer: function(value){
								return unescapeHTML2(value);	
							}
						},
						{
							id : "trtyYy",
							title : 'Treaty Year',
							width : 30,
							align : "right",
							filterOption: true,
							filterOptionType : 'integerNoNegative'
						},
						{
							id : "trtySeqNo",
							title : 'Treaty Seq. No.',
							width : 45,
							align : "right",
							filterOption: true,
							filterOptionType : 'integerNoNegative'
						}
				    ]
				},
				{
					id : 'trtyName',
					align : "left",
					title : 'Treaty Name',
					width : '260px',			
					filterOption : true
				},
				{
					id : 'dspRiSname',
					align : "left",
					title : 'Cedant',
					width : '260px'
				},
				{
					id : 'uwTrtyType',
					width : '0',
					visible : false
				},
				{
					id : 'effDate',
					width : '0',
					visible : false
				},
				{
					id : 'expiryDate',
					width : '0',
					visible : false
				},
				{
					id : 'riCd',
					width : '0',
					visible : false
				},
				{
					id : 'acTrtyType',
					width : '0',
					visible : false
				},
				{
					id : 'trtyLimit',
					width : '0',
					visible : false
				},
				{
					id : 'trtyShrPct',
					width : '0',
					visible : false
				},
				{
					id : 'trtyShrAmt',
					width : '0',
					visible : false
				},
				{
					id : 'estPremInc',
					width : '0',
					visible : false
				},
				{
					id : 'prtfolioSw',
					width : '0',
					visible : false
				},
				{
					id : 'noOfLines',
					width : '0',
					visible : false
				},
				{
					id : 'inxsAmt',
					width : '0',
					visible : false
				},
				{
					id : 'excLossRt',
					width : '0',
					visible : false
				},
				{
					id : 'ccallLimit',
					width : '0',
					visible : false
				},
				{
					id : 'depPrem',
					width : '0',
					visible : false
				},
				{
					id : 'currencyCd',
					width : '0',
					visible : false
				},
				{
					id : 'remarks',
					width : '0',
					visible: false				
				},
				{
					id : 'userId',
					width : '0',
					visible: false
				},
				{
					id : 'lastUpdate',
					width : '0',
					visible: false				
				}
			],
			rows : objGIISS032.intreatyList.rows
	};
	tbgIntreaty = new MyTableGrid(giisIntreatyTable);
	tbgIntreaty.pager = objGIISS032.intreatyList;
	tbgIntreaty.render("giisIntreatyListTable");
	
	function setFieldValues(rec){
		try{
			$("txtLineCd").value = (rec == null ? "" : rec.lineCd);
			$("txtTrtyYy").value = (rec == null ? "" : rec.trtyYy);
			$("txtTrtySeqNo").value = (rec == null ? "" : formatNumberDigits(rec.trtySeqNo, 3));
			rec == null ? $("rdoProp").checked = true : rec.uwTrtyType == "P" ?  $("rdoProp").checked = true : rec.uwTrtyType == "N" ? $("rdoNonProp").checked = true : $("rdoProp").checked = true;
			$("txtTrtyName").value = (rec == null ? "" : unescapeHTML2(rec.trtyName));
			rec == null ? $("rdoNatExp").checked = true : rec.prtfolioSw == "P" ?  $("rdoPortfolio").checked = true : rec.prtfolioSw == "N" ? $("rdoNatExp").checked = true : $("rdoNatExp").checked = true;
			$("txtDspRiSname").value = (rec == null ? "" : unescapeHTML2(rec.dspRiSname));
			$("txtRiCd").value = (rec == null ? "" : rec.riCd);
			$("txtDspCurrencyName").value = (rec == null ? "" : unescapeHTML2(rec.dspCurrencyName));
			$("txtCurrencyCd").value = (rec == null ? "" : rec.currencyCd);
			$("txtTrtyLimit").value = (rec == null ? "" : formatCurrency(rec.trtyLimit));
			$("txtDspAcTypeSname").value = (rec == null ? "" : unescapeHTML2(rec.dspAcTypeSname));
			$("txtCaTrtyType").value = (rec == null ? "" : rec.acTrtyType);
			$("txtTrtyShrPct").value = (rec == null ? "" : formatToNthDecimal(rec.trtyShrPct, 9));
			$("txtTrtyShrAmt").value = (rec == null ? "" : formatCurrency(rec.trtyShrAmt));
			$("txtEffDate").value = (rec == null ? "" : rec.effDate);
			$("txtExpiryDate").value = (rec == null ? "" : rec.expiryDate);
			$("txtNoOfLines").value = (rec == null ? "" : rec.noOfLines == null ? "" : formatNumberDigits(rec.noOfLines, 4));
			$("txtExcLossRt").value = (rec == null ? "" : formatToNthDecimal(rec.excLossRt, 9));
			$("txtCcallLimit").value = (rec == null ? "" : formatCurrency(rec.ccallLimit));
			$("txtEstPremInc").value = (rec == null ? "" : formatCurrency(rec.estPremInc));
			$("txtInxsAmt").value = (rec == null ? "" : formatCurrency(rec.inxsAmt));
			$("txtDepPrem").value = (rec == null ? "" : formatCurrency(rec.depPrem));
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtLineCd").readOnly = false : $("txtLineCd").readOnly = true;
			rec == null ? enableSearch("imgSearchLine") : disableSearch("imgSearchLine");
			rec == null ? $("txtTrtyYy").readOnly = false : $("txtTrtyYy").readOnly = true;
			rec == null ? $("txtTrtySeqNo").readOnly = false : $("txtTrtySeqNo").readOnly = true;
			rec == null ? $("txtDspRiSname").readOnly = false : $("txtDspRiSname").readOnly = true;
			rec == null ? enableSearch("imgSearchCedant") : disableSearch("imgSearchCedant");
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrIntreaty = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	$("txtTrtyName").observe("keyup", function(){
		$("txtTrtyName").value = $F("txtTrtyName").toUpperCase();
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtLineCd").setAttribute("lastValidValue", "");
	$("txtLineCd").observe("keyup", function(){
		$("txtLineCd").value = $F("txtLineCd").toUpperCase();
	});
	
	$("imgSearchLine").observe("click", showGiiss032LineLov);
	
	$("txtLineCd").observe("change", function() {		
		if($F("txtLineCd").trim() == "") {
			$("txtLineCd").value = "";
			$("txtLineCd").setAttribute("lastValidValue", "");
		} else {
			if($F("txtLineCd").trim() != "" && $F("txtLineCd") != $("txtLineCd").readAttribute("lastValidValue")) {
				showGiiss032LineLov();
			}
		}
	});
	
	function showGiiss032LineLov(){
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters: {
				action : "getGiiss032LineLov",
				filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
				page : 1
			},
			title: "List of Lines",
			width: 500,
			height: 400,
			columnModel : [
					{
						id : "lineCd",
						title: "Line Code",
						width: '100px',
						filterOption: true
					},
					{
						id : "lineName",
						title: "Line Name",
						width: '325px',
						renderer: function(value) {
							return unescapeHTML2(value);
						}
					}
			],
			autoSelectOneRecord: true,
			filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
			onSelect: function(row) {
				$("txtLineCd").value = row.lineCd;
				$("txtLineCd").setAttribute("lastValidValue", row.lineCd);	
			},
			onCancel: function (){
				$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
			},
			onShow : function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		  });
	}

	$("txtDspRiSname").setAttribute("lastValidValue", "");
	$("txtRiCd").setAttribute("lastValidValue", "");
	$("txtDspRiSname").observe("keyup", function(){
		$("txtDspRiSname").value = $F("txtDspRiSname").toUpperCase();
	});
	
	$("imgSearchCedant").observe("click", showGiiss032CedantLov);
	
	$("txtDspRiSname").observe("change", function() {		
		if($F("txtDspRiSname").trim() == "") {
			$("txtDspRiSname").value = "";
			$("txtDspRiSname").setAttribute("lastValidValue", "");
			$("txtRiCd").setAttribute("lastValidValue", "");
		} else {
			if($F("txtDspRiSname").trim() != "" && $("txtDspRiSname") != $("txtDspRiSname").readAttribute("lastValidValue")) {
				showGiiss032CedantLov();
			}
		}
	});
	
	function showGiiss032CedantLov(){
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters: {
				action : "getGiiss032CedantLov",
				filterText : ($("txtDspRiSname").readAttribute("lastValidValue").trim() != $F("txtDspRiSname").trim() ? $F("txtDspRiSname").trim() : ""),
				page : 1
			},
			title: "List of Reinsurers",
			width: 500,
			height: 400,
			columnModel : [
					{
						id : "riSname",
						title: "RI Short Name",
						width: '100px',
						filterOption: true
					},
					{
						id : "riName",
						title: "RI Name",
						width: '325px',
						renderer: function(value) {
							return unescapeHTML2(value);
						}
					}
			],
			autoSelectOneRecord: true,
			filterText : ($("txtDspRiSname").readAttribute("lastValidValue").trim() != $F("txtDspRiSname").trim() ? $F("txtDspRiSname").trim() : ""),
			onSelect: function(row) {
				$("txtDspRiSname").value = row.riSname;
				$("txtDspRiSname").setAttribute("lastValidValue", row.riSname);
				$("txtRiCd").value = row.riCd;
				$("txtRiCd").setAttribute("lastValidValue", row.riCd);
			},
			onCancel: function (){
				$("txtDspRiSname").value = $("txtDspRiSname").readAttribute("lastValidValue");
				$("txtRiCd").value = $("txtRiCd").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtDspRiSname").value = $("txtDspRiSname").readAttribute("lastValidValue");
				$("txtRiCd").value = $("txtRiCd").readAttribute("lastValidValue");
			},
			onShow : function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		  });
	}

	$("txtDspCurrencyName").setAttribute("lastValidValue", "");
	$("txtCurrencyCd").setAttribute("lastValidValue", "");
	$("txtDspCurrencyName").observe("keyup", function(){
		$("txtDspCurrencyName").value = $F("txtDspCurrencyName").toUpperCase();
	});
	
	$("imgSearchCurrency").observe("click", showGiiss032CurrencyLov);
	
	$("txtDspCurrencyName").observe("change", function() {		
		if($F("txtDspCurrencyName").trim() == "") {
			$("txtDspCurrencyName").value = "";
			$("txtDspCurrencyName").setAttribute("lastValidValue", "");
			$("txtCurrencyCd").setAttribute("lastValidValue", "");
		} else {
			if($F("txtDspCurrencyName").trim() != "" && $("txtDspCurrencyName") != $("txtDspCurrencyName").readAttribute("lastValidValue")) {
				showGiiss032CurrencyLov();
			}
		}
	});
	
	function showGiiss032CurrencyLov(){
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters: {
				action : "getGiiss032CurrencyLov",
				filterText : ($("txtDspCurrencyName").readAttribute("lastValidValue").trim() != $F("txtDspCurrencyName").trim() ? $F("txtDspCurrencyName").trim() : ""),
				page : 1
			},
			title: "List of Currencies",
			width: 500,
			height: 400,
			columnModel : [
					{
						id : "shortName",
						title: "Name",
						width: '100px',
						filterOption: true
					},
					{
						id : "currencyDesc",
						title: "Description",
						width: '325px',
						renderer: function(value) {
							return unescapeHTML2(value);
						}
					}
			],
			autoSelectOneRecord: true,
			filterText : ($("txtDspCurrencyName").readAttribute("lastValidValue").trim() != $F("txtDspCurrencyName").trim() ? $F("txtDspCurrencyName").trim() : ""),
			onSelect: function(row) {
				$("txtDspCurrencyName").value = row.currencyDesc;
				$("txtDspCurrencyName").setAttribute("lastValidValue", row.currencyDesc);
				$("txtCurrencyCd").value = row.mainCurrencyCd;
				$("txtCurrencyCd").setAttribute("lastValidValue", row.mainCurrencyCd);
			},
			onCancel: function (){
				$("txtDspCurrencyName").value = $("txtDspCurrencyName").readAttribute("lastValidValue");
				$("txtCurrencyCd").value = $("txtCurrencyCd").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtDspCurrencyName").value = $("txtDspCurrencyName").readAttribute("lastValidValue");
				$("txtCurrencyCd").value = $("txtCurrencyCd").readAttribute("lastValidValue");
			},
			onShow : function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		  });
	}

	$("txtDspAcTypeSname").setAttribute("lastValidValue", "");
	$("txtCaTrtyType").setAttribute("lastValidValue", "");
	$("txtDspAcTypeSname").observe("keyup", function(){
		$("txtDspAcTypeSname").value = $F("txtDspAcTypeSname").toUpperCase();
	});
	
	$("imgSearchAcctgType").observe("click", showGiiss032AcctgTypeLov);
	
	$("txtDspAcTypeSname").observe("change", function() {		
		if($F("txtDspAcTypeSname").trim() == "") {
			$("txtDspAcTypeSname").value = "";
			$("txtDspAcTypeSname").setAttribute("lastValidValue", "");
			$("txtCaTrtyType").value = "";
			$("txtCaTrtyType").setAttribute("lastValidValue", "");
		} else {
			if($F("txtDspAcTypeSname").trim() != "" && $("txtDspAcTypeSname") != $("txtDspAcTypeSname").readAttribute("lastValidValue")) {
				showGiiss032AcctgTypeLov();
			}
		}
	});
	
	function showGiiss032AcctgTypeLov(){
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters: {
				action : "getGiiss032AcctgTypeLov",
				filterText : ($("txtDspAcTypeSname").readAttribute("lastValidValue").trim() != $F("txtDspAcTypeSname").trim() ? $F("txtDspAcTypeSname").trim() : ""),
				lineCd : $F("txtLineCd"),
				page : 1
			},
			title: "List of Acctg. Treaty Type",
			width: 500,
			height: 400,
			columnModel : [
					{
						id : "trtySname",
						title: "Name",
						width: '100px',
						filterOption: true
					},
					{
						id : "trtyLname",
						title: "Description",
						width: '325px',
						renderer: function(value) {
							return unescapeHTML2(value);
						}
					}
			],
			autoSelectOneRecord: true,
			filterText : ($("txtDspAcTypeSname").readAttribute("lastValidValue").trim() != $F("txtDspAcTypeSname").trim() ? $F("txtDspAcTypeSname").trim() : ""),
			onSelect: function(row) {
				$("txtDspAcTypeSname").value = row.trtySname;
				$("txtDspAcTypeSname").setAttribute("lastValidValue", row.trtySname);
				$("txtCaTrtyType").value = row.caTrtyType;
				$("txtCaTrtyType").setAttribute("lastValidValue", row.caTrtyType);
			},
			onCancel: function (){
				$("txtDspAcTypeSname").value = $("txtDspAcTypeSname").readAttribute("lastValidValue");
				$("txtCaTrtyType").value = $("txtCaTrtyType").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtDspAcTypeSname").value = $("txtDspAcTypeSname").readAttribute("lastValidValue");
				$("txtCaTrtyType").value = $("txtCaTrtyType").readAttribute("lastValidValue");
			},
			onShow : function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		  });
	}
	
	/* $("txtTrtyLimit").observe("blur", function() {
		if(parseFloat(($F("txtTrtyLimit")).replace(/,/g, "")) > 99999999999990.99) {
			showMessageBox("Maximum value for Treaty Limit is 99,999,999,999,990.99");
			$("txtTrtyLimit").clear();
			$("txtTrtyLimit").focus();
		} else if(isNaN(parseFloat($F("txtTrtyLimit")))) {
			showMessageBox("Field must be of form 99,999,999,999,990.99.");
			$("txtTrtyLimit").clear();
			$("txtTrtyLimit").focus();
		}
	});*/
	
	$("txtTrtyLimit").observe("change", function(){
		if (this.value >= -99999999999999.99  && this.value <= 99999999999999.99){
			if (this.value.trim() != "" && $F("txtTrtyShrPct").trim() != "") {
				$("txtTrtyShrAmt").value = (parseFloat(nvl($F("txtTrtyShrPct"),"0")) / 100) * parseFloat(unformatCurrencyValue(nvl($F("txtTrtyLimit"),"0")));
				$("txtTrtyShrAmt").value = formatCurrency($F("txtTrtyShrAmt"));
			}else if(this.value.trim() != "" && $F("txtTrtyShrAmt").trim() != "") {
				$("txtTrtyShrPct").value = (parseFloat(unformatCurrencyValue(nvl($F("txtTrtyShrAmt"),"0"))) / parseFloat(unformatCurrencyValue(nvl($F("txtTrtyLimit"),"0"))))*100;
				$("txtTrtyShrPct").value = formatToNthDecimal($("txtTrtyShrPct").value,9);
			}
		}
	}); 
	
	$("txtTrtyShrPct").observe("change", function(){
		if (this.value >= -999.999999999  && this.value <= 999.999999999){
			if (this.value.trim() != "" && $F("txtTrtyLimit").trim() != "") {
				$("txtTrtyShrAmt").value = (parseFloat(nvl($F("txtTrtyShrPct"),"0")) / 100) * parseFloat(unformatCurrencyValue(nvl($F("txtTrtyLimit"),"0")));
				$("txtTrtyShrAmt").value = formatCurrency($F("txtTrtyShrAmt"));
			}else if(this.value.trim() != "" && $F("txtTrtyShrAmt").trim() != "") {
				$("txtTrtyLimit").value = parseFloat(unformatCurrencyValue(nvl($F("txtTrtyShrAmt"),"0"))) / (parseFloat(nvl($F("txtTrtyShrPct"),"0")) / 100);
				$("txtTrtyLimit").value = formatCurrency($F("txtTrtyLimit"));
			}
		}
	}); 
	
	$("txtTrtyShrAmt").observe("change", function(){
		if (this.value >= -99999999999999.99  && this.value <= 99999999999999.99){
			if (this.value.trim() != "" && $F("txtTrtyShrPct").trim() != "") {
				$("txtTrtyLimit").value = parseFloat(unformatCurrencyValue(nvl($F("txtTrtyShrAmt"),"0"))) / (parseFloat(nvl($F("txtTrtyShrPct"),"0")) / 100);
				$("txtTrtyLimit").value = formatCurrency($F("txtTrtyLimit"));
			}else if(this.value.trim() != "" && $F("txtTrtyLimit").trim() != "") {
				$("txtTrtyShrPct").value = (parseFloat(unformatCurrencyValue(nvl($F("txtTrtyShrAmt"),"0"))) / parseFloat(unformatCurrencyValue(nvl($F("txtTrtyLimit"),"0"))))*100;
				$("txtTrtyShrPct").value = formatToNthDecimal($("txtTrtyShrPct").value,9);
			}
		}
	}); 
	
	$("imgEffDate").observe("click", function(){
		scwShow($('txtEffDate'),this, null);
	});	
	
	$("imgExpiryDate").observe("click", function(){
		scwShow($('txtExpiryDate'),this, null);
	});	
	
	$("txtEffDate").observe("blur", function(){
		if(this.value != ""){
			validateDateFormat($F("txtEffDate"), "txtEffDate");	
		}
	});
	
	$("txtExpiryDate").observe("blur", function(){
		if(this.value != ""){
			validateDateFormat($F("txtExpiryDate"), "txtExpiryDate");	
		}
	});
	
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
			$(elemName).focus();
		}
		return status;
	}
	
	$("txtNoOfLines").observe("change", function(){
		if (this.value.trim() != ""){
			this.value = formatNumberDigits($("txtNoOfLines").value, 4); 
		}
	});
	
	/* $("txtExcLossRt").observe("blur", function(){
		if (isNaN($F("txtExcLossRt")) || $F("txtExcLossRt") < 0 || $F("txtExcLossRt") > 1000){
			customShowMessageBox("Field must be of form 990.999999999.", imgMessage.INFO, "txtExcLossRt");
		}
		
		$("txtExcLossRt").value = formatToNthDecimal($("txtExcLossRt").value,9); 
	}); */
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("giiss032FormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i=0; i<tbgIntreaty.geniisysRows.length; i++){
						if(tbgIntreaty.geniisysRows[i].recordStatus == 0 || tbgIntreaty.geniisysRows[i].recordStatus == 1){
							if(tbgIntreaty.geniisysRows[i].lineCd == $F("txtLineCd") && tbgIntreaty.geniisysRows[i].trtySeqNo == $F("txtTrtySeqNo") &&
						       tbgIntreaty.geniisysRows[i].trtyYy == $F("txtTrtyYy") && tbgIntreaty.geniisysRows[i].riCd == $F("txtRiCd")){
								addedSameExists = true;								
							}							
						} else if(tbgIntreaty.geniisysRows[i].recordStatus == -1){
							if(tbgIntreaty.geniisysRows[i].lineCd == $F("txtLineCd") && tbgIntreaty.geniisysRows[i].trtySeqNo == $F("txtTrtySeqNo") &&
							   tbgIntreaty.geniisysRows[i].trtyYy == $F("txtTrtyYy") && tbgIntreaty.geniisysRows[i].riCd == $F("txtRiCd")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Inward treaty must be unique", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIISIntreatyController", {
						parameters : {action : "valAddRec",
									  lineCd : $F("txtLineCd"),
									  trtyYy : $F("txtTrtyYy"),
									  trtySeqNo : $F("txtTrtySeqNo"),
									  riCd : $F("txtRiCd")
						},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addRec();
							}
						}
					});
				} else {
					addRec();
				}
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiiss032;
			var intreaty = setRec(objCurrIntreaty);
			if($F("btnAdd") == "Add"){
				tbgIntreaty.addBottomRow(intreaty);
			} else {
				tbgIntreaty.updateVisibleRowOnly(intreaty, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgIntreaty.keys.removeFocus(tbgIntreaty.keys._nCurrentFocus, true);
			tbgIntreaty.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.lineCd = escapeHTML2($F("txtLineCd"));
			obj.trtySeqNo = $F("txtTrtySeqNo");
			obj.trtyYy = $F("txtTrtyYy");
			obj.uwTrtyType = $("rdoProp").checked ? "P" : "N";
			obj.trtyName = escapeHTML2($F("txtTrtyName"));
			obj.prtfolioSw = $("rdoPortfolio").checked ? "P" : "N";
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.dspRiSname = escapeHTML2($F("txtDspRiSname"));
			obj.riCd = $F("txtRiCd");
			obj.effDate = $F("txtEffDate");
			obj.expiryDate = $F("txtExpiryDate");
			obj.trtyLimit = $F("txtTrtyLimit");
			obj.trtyShrPct = $F("txtTrtyShrPct");
			obj.trtyShrAmt = $F("txtTrtyShrAmt");
			obj.estPremInc = $F("txtEstPremInc");
			obj.acTrtyType = $F("txtCaTrtyType");
			obj.noOfLines = $F("txtNoOfLines");
			obj.inxsAmt = $F("txtInxsAmt");
			obj.inxsAmt = $F("txtInxsAmt");
			obj.excLossRt = $F("txtExcLossRt");
			obj.ccallLimit = $F("txtCcallLimit");
			obj.depPrem = $F("txtDepPrem");
			obj.currencyCd = $F("txtCurrencyCd");
			obj.dspCurrencyName = $F("txtDspCurrencyName");
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISIntreatyController", {
				parameters : {
					action : "valDeleteRec",
					lineCd : $F("txtLineCd"),
					trtyYy : $F("txtTrtyYy"),
					trtySeqNo : $F("txtTrtySeqNo"),
					riCd : $F("txtRiCd")
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						deleteRec();
					}
				}
			});
		} catch(e){
			showErrorMessage("valDeleteRec", e);
		}
	}
	
	function deleteRec(){
		changeTagFunc = saveGiiss032;
		objCurrIntreaty.recordStatus = -1;
		tbgIntreaty.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function saveGiiss032(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgIntreaty.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgIntreaty.geniisysRows);

		new Ajax.Request(contextPath+"/GIISIntreatyController", {
			method: "POST",
			parameters : {
				action : "saveGiiss032",
				setRows : prepareJsonAsParameter(setRows),
				delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS032.exitPage != null) {
							objGIISS032.exitPage();
						} else {
							tbgIntreaty._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}
	
	function cancelGiiss032(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS032.exitPage = exitPage;
						saveGiiss032();
					}, function(){
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}
	
	observeReloadForm("reloadForm", showGiiss032);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	observeSaveForm("btnSave", saveGiiss032);
	$("btnCancel").observe("click", cancelGiiss032);
	
	$("menuFileMaintenanceExit").stopObserving("click");
	$("menuFileMaintenanceExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$("txtLineCd").focus();	
	disableButton("btnDelete");
</script>