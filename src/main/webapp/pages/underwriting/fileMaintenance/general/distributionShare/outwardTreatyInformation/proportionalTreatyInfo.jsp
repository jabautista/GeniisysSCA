<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss031MainDiv" name="giiss031MainDiv" style="">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="btnExit">Exit</a></li>
			</ul>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Outward Treaty Information Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	<div id="giiss031" name="giiss031">		
		<div class="sectionDiv">
			<div align="center" id="mainInfoDiv" style="padding-top: 10px; padding-bottom: 10px;">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Treaty No</td>
						<td class="leftAligned">
							<input id="txtTreatyNo" type="text" class="allCaps" style="width: 100px; text-align: left;" tabindex="101" maxlength="20" readonly="readonly">
							<input id="txtOldTrtySeqNo" type="text" class="allCaps integerNoNegativeUnformattedNoComma" style="width: 70px; text-align: right;" tabindex="102" maxlength="3">
						</td>
						<td class="rightAligned" width="113px">Treaty Limit</td>
						<td class="leftAligned">
							<input id="txtTreatyLimit" type="text" class="rightAligned applyDecimalRegExp2" regExpPatt="pDeci1602" min="0.01" max="99999999999999.99" customLabel="Treaty Limit" style="width: 200px;" tabindex="103" maxlength="">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Treaty Name</td>
						<td class="leftAligned" colspan="3">
							<input id="txtTreatyName" type="text" class="allCaps" style="width: 533px;" tabindex="104" maxlength="30">
						</td>
					</tr>	
					<tr>
						<td class="rightAligned">Portfolio/Natural Expiry</td>
						<td class="leftAligned">
							<table>
								<tr style="height: 10px;">
									<td class="rightAligned" style="padding-top:7px;">
										<input type="radio" name="searchBy" id="rdoNaturalExp" checked="checked" style="float: left; margin: 3px 2px 3px 3px;" tabindex="105" readonly="readonly" />
										<label for="rdoNaturalExp" style="float: left; height: 20px; padding-top: 3px;" title="Natural Expiry">Natural Expiry</label>
									</td>
									<td></td>
									<td class="rightAligned" style="padding-top:7px;">
										<input type="radio" name="searchBy" id="rdoPortfolio" style="float: left; margin: 3px 2px 3px 3px;" tabindex="106" readonly="readonly"/>
										<label for="rdoPortfolio" style="float: left; height: 20px; padding-top: 3px;" title="Portfolio">Portfolio</label>
									</td>
								</tr>
							</table>
						</td>
						<td class="rightAligned" width="113px">Term From</td>
						<td class="leftAligned">
							<div id="endDateDiv" class="required" style="float: left; border: 1px solid gray; width: 205px; height: 20px;">
								<input id="txtEffDate" name="From Date" readonly="readonly" type="text" class="date required" maxlength="10" style="border: none; float: left; width: 180px; height: 13px; margin: 0px;" value="" tabindex="107"/>
								<img id="imgEffDate" alt="imgEffDate" style="margin-top: 1px; margin-left: 1px;" class="hover required" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtEffDate'),this, null);" />
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Acctg. Treaty Type</td>
						<td class="leftAligned">
							<span class="lovSpan required" style="width: 65px; height: 21px; margin: 2px 2px 0 0; float: left;">
								<input type="text" ignoreDelKey="1" id="txtAcctTrtyTypeCd" name="txtAcctTrtyTypeCd" style="width: 40px; float: left; border: none; height: 13px;" class="allCaps required rightAligned integerNoNegativeUnformattedNoComma" maxlength="2" tabindex="108"/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchAcctTrtyType" name="searchAcctTrtyType" alt="Go" style="float: right;"> 
							</span> 
							<input type="text" id="txtAcctTrtyType" name="txtAcctTrtyType" style="height: 15px;" readonly="readonly" class="required"/>
						</td>
						<td class="rightAligned" width="113px">To</td>
						<td class="leftAligned">
							<div id="endDateDiv" class="required" style="float: left; border: 1px solid gray; width: 205px; height: 20px;">
								<input id="txtExpDate" name="Expiry Date." readonly="readonly" type="text" class="date required" maxlength="10" style="border: none; float: left; width: 180px; height: 13px; margin: 0px;" value="" tabindex="109"/>
								<img id="imgExpDate" alt="imgExpDate" style="margin-top: 1px; margin-left: 1px;" class="hover required" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtExpDate'),this, null);" />
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Profit Comm. Type</td>
						<td class="leftAligned">
						    <!-- set Profit Comm. Type as a nonrequired field by robert 12.15.2014 -->
							<span class="lovSpan" style="width: 65px; height: 21px; margin: 2px 2px 0 0; float: left;">
								<input type="text" id="txtProfCommTypeCd" name="txtProfCommTypeCd" style="width: 40px; float: left; border: none; height: 13px;" class="integerNoNegativeUnformattedNoComma allCaps rightAligned" maxlength="2" tabindex="110" />
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchProfCommType" name="searchProfCommType" alt="Go" style="float: right;">
							</span> 
							<input type="text" id="txtProfCommType" name="txtProfCommType" style="height: 15px;" readonly="readonly" />
						</td>
						<td class="rightAligned" width="113px">Funds Held %</td>
						<td class="leftAligned">
							<input id="txtFundsHeld" type="text" class="rightAligned applyDecimalRegExp2" style="width: 200px;" tabindex="111" maxlength="" regExpPatt="pDeci0309" min="0.000000000" max="100.000000000" customLabel="Funds Held %">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Loss Portfolio %</td>
						<td class="leftAligned">
							<input id="txtLossPortfolio" type="text" class="rightAligned applyDecimalRegExp2" style="width: 200px;" tabindex="112" maxlength="" regExpPatt="pDeci0309" min="0.000000000" max="100.000000000" customLabel="Loss Portfolio %">
						</td>
						<td class="rightAligned" width="113px">Prem. Portfolio %</td>
						<td class="leftAligned">
							<input id="txtPremPortfolio" type="text" class="rightAligned applyDecimalRegExp2" style="width: 200px;" tabindex="113" maxlength="" regExpPatt="pDeci0309" min="0.000000000" max="100.000000000" customLabel="Prem. Portfolio %">
						</td>
					</tr>
				</table>
			</div>
			<div align="center" style="padding: 10px 0 10px 0; border-top: 1px solid #E0E0E0;">
				<input type="button" class="button" id="btnTrtyPeril" value="Treaty Peril" tabindex="114" style="width: 150px; ">
			</div>
		</div>
	</div>
	<div id="giiss049" name="giiss049">		
		<div class="sectionDiv">
			<div id="treatyInfoTableDiv" style="padding-top: 15px;">
				<div id="treatyInfoTable" style="height: 335px; padding: 0 37px 0 37px;"></div>
			</div>
			<div align="center">
				<table cellpadding="0">
					<tr>
						<td class="leftAligned">RI Type</td>
						<td class="leftAligned">
							<input id="txtRiType" type="text" class="leftAligned" style="width: 220px;" tabindex="201" readonly="readonly">
						</td>
						<td class="leftAligned">RI Base</td>
						<td class="leftAligned">
							<input id="txtRiBase" type="text" class="leftAligned" style="width: 200px;" tabindex="202" readonly="readonly">
						</td>
						<td class="rightAligned" width="40px">Totals</td>
						<td class="rightAligned">
							<input id="txtTotShrPct" type="text" class="rightAligned" style="width: 110px;" tabindex="203" readonly="readonly">
						</td>
						<td class="rightAligned">
							<input id="txtTotShrAmt" type="text" class="rightAligned" style="width: 110px;" tabindex="204" readonly="readonly">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Reinsurer</td>
						<td class="leftAligned">
							<span class="lovSpan required" style="width: 225px; height: 21px; margin: 2px 2px 0 0; float: left;">
								<input type="text" id="txtReinsurer" name="txtReinsurer" ignoreDelKey="1" style="width: 173px; float: left; border: none; height: 13px;" class="required allCaps" maxlength="15" tabindex="301" />
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchReinsurer" name="searchReinsurer" alt="Go" style="float: right;">
							</span> 
						</td>
					</tr>
				</table>				
			</div>
			<div align="center" id="treatyInfoFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned" width="113px">Interest on Prem</td>
						<td class="leftAligned">
							<input id="txtIntOnPrem" type="text" class="rightAligned required applyDecimalRegExp2" style="width: 200px;" tabindex="302" maxlength="" regExpPatt="pDeci0309" min="0.000000000" max="100.000000000" customLabel="Interest on Prem">
						</td>
						<td class="rightAligned" width="113px">Interest Tax %</td>
						<td class="leftAligned">
							<input id="txtIntTaxRt" type="text" class="rightAligned applyDecimalRegExp2" style="width: 200px;" tabindex="303" maxlength="" regExpPatt="pDeci0309" min="0.000000000" max="100.000000000" customLabel="Interest Tax %">
						</td>
					</tr>	
					<tr>
						<td class="rightAligned">Parent RI</td>
						<td class="leftAligned">
							<span class="lovSpan" style="width: 205px; height: 21px; margin: 2px 2px 0 0; float: left;">
								<input type="text" id="txtParentRi" name="txtParentRi" style="width: 173px; float: left; border: none; height: 13px;" class="allCaps" maxlength="15" tabindex="304" />
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchParentRi" name="searchParentRi" alt="Go" style="float: right;">
							</span> 
						</td>
						<td class="rightAligned">RI Comm %</td>
						<td class="leftAligned">
							<input id="txtRiCommPct" type="text" class="rightAligned applyDecimalRegExp2" style="width: 200px;" tabindex="305" maxlength="" regExpPatt="pDeci0309" min="0.000000000" max="100.000000000" customLabel="RI Comm %">
						</td>
						
					</tr>
					<tr>
						<td class="rightAligned">Treaty Share Amount</td>
						<td class="leftAligned">
							<input id="txtTrtyShareAmt" type="text" class="rightAligned applyDecimalRegExp2" style="width: 200px;" tabindex="306" maxlength="" regExpPatt="pDeci1602" min="0.01" max="99999999999999.99" customLabel="Treaty Share Amount">
						</td>
						<td class="rightAligned" width="113px">Trty Share %</td>
						<td class="leftAligned">
							<input id="txtTrtySharePct" type="text" class="rightAligned required applyDecimalRegExp2"  style="width: 200px;" tabindex="307" maxlength="" regExpPatt="pDeci0309" min="0.000000001" max="100.000000000" customLabel="Treaty Share %">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">WH Tax %</td>
						<td class="leftAligned">
							<input id="txtWhTaxPct" type="text" class="rightAligned applyDecimalRegExp2" style="width: 200px;" tabindex="308" maxlength="" regExpPatt="pDeci0304" min="0.0000" max="100.0000" customLabel="WH Tax %">
						</td>
						<td class="rightAligned" width="113px">Funds Held %</td>
						<td class="leftAligned">
							<input id="txtFundsHeldPct" type="text" class="rightAligned applyDecimalRegExp2" style="width: 200px;" tabindex="309" maxlength="" regExpPatt="pDeci0309" min="0.000000000" max="100.000000000" customLabel="Funds Held %">
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="310"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="311"></td>
						<td width="" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="312"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="313">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="314">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="315">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="316">
</div>
<script type="text/javascript">	
	setModuleId("GIISS031");
	setDocumentTitle("Maintain Outward Treaty Information");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	params = JSON.parse('${obj}');
	var objGiisDistShareUpdate = {};
	validateATT = 0;
	
	if(checkUserModule("GIRIS007")){
		enableButton("btnTrtyPeril");
	} else {
		disableButton("btnTrtyPeril");
	}
	
	var recompute = "";
	
	trtyLimitLastValidValue = formatToNthDecimal(params.trtyLimit,2);
	
	$("txtTreatyNo").value = unescapeHTML2(params.dspTrtyNo);
	$("txtOldTrtySeqNo").value = unescapeHTML2(params.oldTrtySeqNo);
	$("txtTreatyLimit").value = formatCurrency(params.trtyLimit);
	$("txtTreatyName").value = unescapeHTML2(params.trtyName);
	$("txtEffDate").value = dateFormat(params.effDate,'mm-dd-yyyy');
	$("txtExpDate").value = dateFormat(params.expiryDate,'mm-dd-yyyy');
	$("txtAcctTrtyTypeCd").value = unescapeHTML2(lpad(params.acctTrtyType,2,0)); 
	$("txtAcctTrtyType").value = unescapeHTML2(params.dspAcctType); 
	$("txtProfCommTypeCd").value = unescapeHTML2(lpad(params.profcompType,2,0));
	$("txtProfCommType").value = unescapeHTML2(params.dspProfcompType);
	$("txtFundsHeld").value = formatToNthDecimal(params.fundsHeldPct,9);
	$("txtLossPortfolio").value = formatToNthDecimal(params.lossPrtfolioPct,9);
	$("txtPremPortfolio").value = formatToNthDecimal(params.premPrtfolioPct,9);
	params.prtfolioSw == "P" ? $("rdoPortfolio").checked = true : $("rdoNaturalExp").checked = true;
	objGiisDistShareUpdate.acctTrtyType = params.acctTrtyType;
	objGiisDistShareUpdate.profcompType = params.profcompType;
	params.prtfolioSw == "P" ? $("txtOldTrtySeqNo").addClassName("required") : $("txtOldTrtySeqNo").removeClassName("required");
	
	//set last valid value
	$("txtAcctTrtyTypeCd").setAttribute("lastValidValue",unescapeHTML2(lpad(params.acctTrtyType,2,0)));
	$("txtAcctTrtyType").setAttribute("lastValidValue", unescapeHTML2(params.dspAcctType));
	$("txtProfCommTypeCd").setAttribute("lastValidValue",unescapeHTML2(lpad(params.profcompType,2,0)));
	$("txtProfCommType").setAttribute("lastValidValue", unescapeHTML2(params.dspProfcompType));
	$("txtTreatyName").setAttribute("lastValidValue", unescapeHTML2(params.trtyName));
	$("txtOldTrtySeqNo").setAttribute("lastValidValue", unescapeHTML2(params.oldTrtySeqNo));
	
	function updateTrty(){
		if(checkAllRequiredFieldsInDiv("mainInfoDiv")){
			objGiisDistShareUpdate.lineCd = params.lineCd;
			objGiisDistShareUpdate.shareCd = params.shareCd;
			objGiisDistShareUpdate.trtyLimit = $F("txtTreatyLimit") == "" ? null : parseFloat($("txtTreatyLimit").value.replace(/,/g, ""));
			objGiisDistShareUpdate.trtyName = $("txtTreatyName").value;
			objGiisDistShareUpdate.effDate = $("txtEffDate").value;
			objGiisDistShareUpdate.expiryDate = $("txtExpDate").value;
			objGiisDistShareUpdate.fundsHeldPct = $("txtFundsHeld").value;
			objGiisDistShareUpdate.lossPrtfolioPct = $("txtLossPortfolio").value;
			objGiisDistShareUpdate.premPrtfolioPct = $("txtPremPortfolio").value;
			objGiisDistShareUpdate.prtfolioSw = $("rdoPortfolio").checked == true ? "P" : "N";
			objGiisDistShareUpdate.acctTrtyType = objGiisDistShareUpdate.acctTrtyType;
			objGiisDistShareUpdate.profcompType = objGiisDistShareUpdate.profcompType;
			objGiisDistShareUpdate.oldTrtySeqNo =  $F("txtOldTrtySeqNo");
			
			if(params.prtfolioSw != ($("rdoPortfolio").checked == true ? "P" : "N")){
				changeTag = 1;
			}
			if(tbgTreatyInfo.geniisysRows.length == 0){
				customShowMessageBox("Distribution Share must have at least 1 child record.", "I", "txtReinsurer");
				return;
			} else if(parseFloat($("txtTotShrPct").value.replace(/,/g, "")) < 100) {
				customShowMessageBox("Total treaty share % should be equal to 100.", "I", "txtReinsurer");
			} else {
				saveUpdateTreaty();
			}
		}
	}
	
	function saveRecords(){
		var setRows = getAddedAndModifiedJSONObjects(tbgTreatyInfo.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgTreatyInfo.geniisysRows);
		new Ajax.Request(contextPath+"/GIISTrtyPanelController", {
			method: "POST",
			parameters : {action : "saveGiiss031",
						  recompute : recompute,
						  lineCd: params.lineCd, 
						  trtyYy: params.trtyYy,
						  trtySeqNo: params.shareCd,
						  newTrtyLimit : $F("txtTreatyLimit") == "" ? null : parseFloat($("txtTreatyLimit").value.replace(/,/g, "")),
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS031.exitPage != null) {
							objGIISS031.exitPage();
						} else {
							tbgTreatyInfo._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
		changeTag = 0;
	}
	
	function saveGiiss031(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		updateTrty();
	}
	
	observeReloadForm("reloadForm", showProportionalTreatyInfo);
	
	var objGIISS031 = {};
	var objCurrTrty = null;
	objGIISS031.exitPage = null;
	
	objGIISS031.trtyInfoList = JSON.parse('${jsonTrty}');
	objGIISS031.trtyAllRecList = JSON.parse('${jsonAllRecList}');
	
	treatyInfoTable = {
			url : contextPath + "/GIISTrtyPanelController?action=showGiiss031&refresh=1&lineCd="+params.lineCd+"&shareCd="+params.shareCd+"&trtyYy="+params.trtyYy,
			options : {
				width : '850px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrTrty = tbgTreatyInfo.geniisysRows[y];
					setFieldValues(objCurrTrty);
					tbgTreatyInfo.keys.removeFocus(tbgTreatyInfo.keys._nCurrentFocus, true);
					tbgTreatyInfo.keys.releaseKeys();
					$("txtTrtyShareAmt").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgTreatyInfo.keys.removeFocus(tbgTreatyInfo.keys._nCurrentFocus, true);
					tbgTreatyInfo.keys.releaseKeys();
					$("txtReinsurer").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgTreatyInfo.keys.removeFocus(tbgTreatyInfo.keys._nCurrentFocus, true);
						tbgTreatyInfo.keys.releaseKeys();
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
					tbgTreatyInfo.keys.removeFocus(tbgTreatyInfo.keys._nCurrentFocus, true);
					tbgTreatyInfo.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgTreatyInfo.keys.removeFocus(tbgTreatyInfo.keys._nCurrentFocus, true);
					tbgTreatyInfo.keys.releaseKeys();
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
					tbgTreatyInfo.keys.removeFocus(tbgTreatyInfo.keys._nCurrentFocus, true);
					tbgTreatyInfo.keys.releaseKeys();
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
					id : 'riSname',
					title : "Reinsurer",
					filterOption : true,
					width : '110px'
				},
				{
					id : 'prntRiName',
					filterOption : true,
					title : 'Parent RI',
					width : '110px'				
				},
				{
					id : 'riCommRt',
					title : "RI Comm %",
					filterOption : true,
					width : '90px',
					align: 'right',
					titleAlign: 'right',
					filterOptionType: 'numberNoNegative',
					geniisysClass: 'rate',
		            deciRate: 9
				},
				{
					id : 'fundsHeldPct',
					title : "Funds Held %",
					filterOption : true,
					width : '90px',
					align: 'right',
					titleAlign: 'right',
					filterOptionType: 'numberNoNegative',
					geniisysClass: 'rate',
		            deciRate: 9
				},
				{
					id : 'whTaxRt',
					title : "WHTax %",
					filterOption : true,
					width : '90px',
					align: 'right',
					titleAlign: 'right',
					filterOptionType: 'numberNoNegative',
					geniisysClass: 'rate',
		            deciRate: 4
				},
				{
					id : 'intOnPremRes',
					title : "Interest on Prem",
					filterOption : true,
					width : '100px',
					align: 'right',
					titleAlign: 'right',
					filterOptionType: 'numberNoNegative',
					geniisysClass: 'rate',
		            deciRate: 9
				},
				{ //benjo 08.03.2016 SR-5512
					id : 'intTaxRt',
					title : "Interest Tax %",
					filterOption : false,
					width : '100px',
					align: 'right',
					titleAlign: 'right',
					filterOptionType: 'numberNoNegative',
					geniisysClass: 'rate',
		            deciRate: 9
				},
				{
					id : 'trtyShrPct',
					title : "Trty Share %",
					filterOption : true,
					width : '90px',
					align: 'right',
					titleAlign: 'right',
					filterOptionType: 'numberNoNegative',
					geniisysClass: 'rate',
		            deciRate: 9
				},
				{
					id : 'trtyShrAmt',
					title : "Treaty Share Amt",
					filterOption : true,
					width : '120px',
					align: 'right',
					titleAlign: 'right',
					renderer : function(value){
						return formatCurrency(value);},
					filterOption: true,
					filterOptionType: 'numberNoNegative',
					geniisysClass: 'money'
				}
			],
			rows : objGIISS031.trtyInfoList.rows
		};
	
		tbgTreatyInfo = new MyTableGrid(treatyInfoTable);
		tbgTreatyInfo.pager = objGIISS031.trtyInfoList;
		tbgTreatyInfo.render("treatyInfoTable");
		tbgTreatyInfo.afterRender = function(){
			populateTotal2();
		};
		
	function setFieldValues(rec){
		try{
			$("txtReinsurer").value = 		(rec == null ? "" : unescapeHTML2(rec.riSname));
			$("txtReinsurer").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.riSname)));
			$("txtParentRi").value = 		(rec == null ? "" : unescapeHTML2(rec.prntRiName));
			$("txtTrtyShareAmt").value = 	(rec == null ? "" : formatCurrency(rec.trtyShrAmt));
			$("txtTrtyShareAmt").setAttribute("lastValidValue", (rec == null ? "" : formatCurrency(rec.trtyShrAmt)));
			$("txtTrtySharePct").value = 	(rec == null ? "" : formatToNthDecimal(rec.trtyShrPct,9));
			$("txtTrtySharePct").setAttribute("lastValidValue", (rec == null ? "" : formatToNthDecimal(rec.trtyShrPct,9)));
			$("txtRiCommPct").value = 		(rec == null ? "" : formatToNthDecimal(rec.riCommRt,9));
			$("txtFundsHeldPct").value = 	(rec == null ? "" : formatToNthDecimal(rec.fundsHeldPct,9));
			$("txtWhTaxPct").value = 		(rec == null ? "" : formatToNthDecimal(rec.whTaxRt,4));
			$("txtIntOnPrem").value = 		(rec == null ? "" : formatToNthDecimal(rec.intOnPremRes,9));
			$("txtUserId").value = 			(rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = 		(rec == null ? "" : dateFormat(rec.lastUpdate, 'mm-dd-yyyy hh:MM:ss TT'));
			$("txtRemarks").value = 		(rec == null ? "" : unescapeHTML2(rec.remarks));
			objGIISS031.riCd = 				(rec == null ? "" : unescapeHTML2(rec.riCd));
			objGIISS031.prntRiCd = 			(rec == null ? "" : unescapeHTML2(rec.prntRiCd));
			$("txtRiBase").value = 			(rec == null ? "" : unescapeHTML2(rec.riBase));
			$("txtRiType").value = 			(rec == null ? "" : unescapeHTML2(rec.riTypeDesc));
			$("txtIntTaxRt").value = 		(rec == null ? "" : formatToNthDecimal(rec.intTaxRt,9)); //benjo 08.03.2016 SR-5512
			
			objGIISS031.selectedTrtyShrPct = (rec == null ? 0 : rec.trtyShrPct);
			objGIISS031.selectedTrtyShrAmt = (rec == null ? 0 : rec.trtyShrAmt);
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			parseFloat($F("txtTotShrPct")) == 100  && rec == null ? disableButton("btnAdd") : enableButton("btnAdd");
			rec == null ? $("txtReinsurer").readOnly = false : $("txtReinsurer").readOnly = true;
			rec == null ? enableSearch("searchReinsurer") : disableSearch("searchReinsurer");
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			
			objCurrTrty = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.lineCd = escapeHTML2(params.lineCd);
			obj.trtySeqNo = escapeHTML2(params.shareCd);
			obj.trtyYy = escapeHTML2(params.trtyYy);
			obj.riCd = escapeHTML2(objGIISS031.riCd);
			obj.prntRiCd = escapeHTML2(objGIISS031.prntRiCd);
			obj.riSname = escapeHTML2($F("txtReinsurer"));
			obj.prntRiName = escapeHTML2($F("txtParentRi")); 
			obj.trtyShrAmt = $F("txtTrtyShareAmt").replace(/,/g, "");
			obj.trtyShrPct = $F("txtTrtySharePct");
			obj.riCommRt = roundExpNumber($F("txtRiCommPct"),9);		//Gzelle 02042016 SR21614
			obj.fundsHeldPct = roundExpNumber($F("txtFundsHeldPct"),9);	//Gzelle 02042016 SR21614
			obj.whTaxRt = $F("txtWhTaxPct");
			obj.intOnPremRes = roundExpNumber($F("txtIntOnPrem"),9);	//Gzelle 02042016 SR21614
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			obj.riBase = escapeHTML2($F("txtRiType"));
			obj.riTypeDesc = escapeHTML2($F("txtRiBase"));
			obj.intTaxRt = roundExpNumber($F("txtIntTaxRt"),9); //benjo 08.03.2016 SR-5512
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addAllRecList(obj){
		objGIISS031.trtyAllRecList.rows.push(obj);
	}
	
	function updateAllRecList(obj, sw){
		for (var i = 0; i < objGIISS031.trtyAllRecList.rows.length; i++){
			if(objGIISS031.trtyAllRecList.rows[i].riCd == obj.riCd){
				if(sw == "update"){
					objGIISS031.trtyAllRecList.rows[i].trtyShrAmt = obj.trtyShrAmt;
					objGIISS031.trtyAllRecList.rows[i].trtyShrPct = obj.trtyShrPct;
				} else {
					objGIISS031.trtyAllRecList.rows.splice(i, 1);
				}
				break;
			}
		}
	}
	
	
	function addRec(){
		try {
			var trty = setRec(objCurrTrty);
			changeTagFunc = saveGiiss031;
			if($F("btnAdd") == "Add"){
				tbgTreatyInfo.addBottomRow(trty);
				addAllRecList(trty);
			} else {
				tbgTreatyInfo.updateVisibleRowOnly(trty, rowIndex, false);
				updateAllRecList(trty, "update");
			}
			changeTag = 1;
			setFieldValues(null);
			tbgTreatyInfo.keys.removeFocus(tbgTreatyInfo.keys._nCurrentFocus, true);
			tbgTreatyInfo.keys.releaseKeys();
			populateTotal2();
			//repopulateTotal();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("treatyInfoFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;	
					
					for ( var i = 0; i < tbgTreatyInfo.geniisysRows.length; i++) {
						if (tbgTreatyInfo.geniisysRows[i].recordStatus == 0 || tbgTreatyInfo.geniisysRows[i].recordStatus == 1) {
							if (tbgTreatyInfo.geniisysRows[i].riCd == objGIISS031.riCd) {
								addedSameExists = true;
							}
						} else if (tbgTreatyInfo.geniisysRows[i].recordStatus == -1) {
							if (tbgTreatyInfo.geniisysRows[i].riCd == objGIISS031.riCd) {
								deletedSameExists = true;
							}
						}
					}
					if ((addedSameExists && !deletedSameExists)|| (deletedSameExists && addedSameExists)) {
						showMessageBox("Record already exists with the same ri_cd.", "E");
						return;
					} else if (deletedSameExists && !addedSameExists) {
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIISTrtyPanelController", {
						parameters : {
							action : "valAddRec",
							riCd : objGIISS031.riCd,
							lineCd : params.lineCd,
							trtySeqNo: params.shareCd,
							trtyYy: params.trtyYy
						},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response) {
							hideNotice();
							if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
								addRec();
							}
						}
					});
				} else {
					addRec();
				}
			}
		} catch (e) {
			showErrorMessage("valAddRec", e);
		}
	}

	function deleteRec() {
		changeTagFunc = saveGiiss031;
		objCurrTrty.recordStatus = -1;
		updateAllRecList(objCurrTrty, "delete");
		tbgTreatyInfo.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
		populateTotal2();
	}

	function exitPage() {
		showDistributionShare();
	}

	function cancelGiiss031() {
		 if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objGIISS031.exitPage = exitPage;
						saveGiiss031();
					}, function() {
						exitPage();
					}, "");
		} else {
			exitPage();
		} 
	}

	$("editRemarks").observe(
			"click",
			function() {
				showOverlayEditor("txtRemarks", 4000, $("txtRemarks")
						.hasAttribute("readonly"));
			});

	disableButton("btnDelete");
	
	$("btnSave").observe("click", function(){
		saveGiiss031();
	});
	
	$("btnCancel").observe("click", cancelGiiss031);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	$("btnExit").stopObserving("click");
	$("btnExit").observe("click", cancelGiiss031);
	
	$("txtEffDate").observe("focus", function(){
		var effDate = $F("txtEffDate") != "" ? new Date($F("txtEffDate").replace(/-/g,"/")) :"";
		var expDate = $F("txtExpDate") != "" ? new Date($F("txtExpDate").replace(/-/g,"/")) :"";
		if ((expDate < effDate) && ($F("txtExpDate") != "")){
			customShowMessageBox("Effectivity Date should not be later than Expiry Date.", "I", "txtEffDate");
			$("txtEffDate").clear();
			return false;
		}
		if(dateFormat(params.effDate, "mm-dd-yyyy") != dateFormat(effDate, "mm-dd-yyyy")){
			changeTagFunc = saveGiiss031;
			changeTag = 1;
		} 
	});
	
	$("txtEffDate").observe("change", function(){
		changeTagFunc = saveGiiss031;
		changeTag = 1;
	});
	
	$("txtExpDate").observe("change", function(){
		changeTagFunc = saveGiiss031;
		changeTag = 1;
	});
	
	$("txtExpDate").observe("focus", function(){
		var effDate = $F("txtEffDate") != "" ? new Date($F("txtEffDate").replace(/-/g,"/")) :"";
		var expDate = $F("txtExpDate") != "" ? new Date($F("txtExpDate").replace(/-/g,"/")) :"";
		if ((expDate < effDate) && ($F("txtExpDate") != "")){
			customShowMessageBox("Effectivity Date should not be later than Expiry Date.", "I", "txtExpDate");
			$("txtExpDate").clear();
			return false;
		}
		
		if(dateFormat(params.expiryDate, "mm-dd-yyyy") != dateFormat(expDate, "mm-dd-yyyy")){
			changeTagFunc = saveGiiss031;
			changeTag = 1;
		} 
	});
	
	function saveUpdateTreaty(){
		try{
			new Ajax.Request(contextPath+"/GIISDistributionShareController?action=giiss031UpdateTreaty",{
				method: "POST",
				asynchronous: true,
				parameters:{
					lineCd : objGiisDistShareUpdate.lineCd,
					shareCd : objGiisDistShareUpdate.shareCd,
					trtyLimit : objGiisDistShareUpdate.trtyLimit,
					trtyName : objGiisDistShareUpdate.trtyName,
					effDate : objGiisDistShareUpdate.effDate,
					expiryDate : objGiisDistShareUpdate.expiryDate,
					fundsHeldPct : objGiisDistShareUpdate.fundsHeldPct,
					lossPrtfolioPct : objGiisDistShareUpdate.lossPrtfolioPct,
					premPrtfolioPct : objGiisDistShareUpdate.premPrtfolioPct,
					prtfolioSw : objGiisDistShareUpdate.prtfolioSw,
					acctTrtyType : objGiisDistShareUpdate.acctTrtyType,
					profcompType : objGiisDistShareUpdate.profcompType,
					oldTrtySeqNo : objGiisDistShareUpdate.oldTrtySeqNo
					
				},
				onCreate:function(){
					showNotice("Saving, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						if(response.responseText == "SUCCESS"){
								saveRecords();
						} else{
							showMessageBox(nvl(response.responseText, "An error occured while saving."), imgMessage.ERROR);
						}
					}
				}
			});				
		}catch(e){
			showErrorMessage("saveUpdateTreaty", e);
		}
	}
	
	validateATT = 0;
	
	function showAcctTreatyType(x){
		try{
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					  action : "showAcctTreatyTypeGiiss031LOV",
					  search : x,
						page : 1
				},
				title: "List of Accounting Treaty Type",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'caTrtyType',
						title: 'Code',
						width : '100px',
						align: 'right',
						titleAlign : 'right',
						renderer : function(value){
							return lpad(value, 2, 0);
						}
					},
					{
						id : 'trtySname',
						title: 'Short Name',
					    width: '100px',
					    align: 'left'
					},
					{
						id : 'trtyLname',
						title: 'Treaty Type Name',
					    width: '235px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				filterText: nvl(escapeHTML2(x), "%"), 
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtAcctTrtyType").value = unescapeHTML2(row.trtySname);
						$("txtAcctTrtyTypeCd").value = unescapeHTML2(lpad(row.caTrtyType, 2, 0));
						objGiisDistShareUpdate.acctTrtyType = unescapeHTML2(lpad(row.caTrtyType, 2, 0));
						$("txtAcctTrtyType").setAttribute("lastValidValue", unescapeHTML2(row.trtySname));
						$("txtAcctTrtyTypeCd").setAttribute("lastValidValue", unescapeHTML2(lpad(row.caTrtyType, 2, 0)));
						changeTagFunc = saveGiiss031;
						changeTag = 1;
						validateATT = 0;
					}
				},
				onCancel: function(){
					$("txtAcctTrtyTypeCd").focus();
					$("txtAcctTrtyTypeCd").value = $("txtAcctTrtyTypeCd").getAttribute("lastValidValue");
					$("txtAcctTrtyType").value = $("txtAcctTrtyType").getAttribute("lastValidValue");
					validateATT = 0;
					
		  		},
		  		onUndefinedRow: function(){
		  			customShowMessageBox("No record selected.", imgMessage.INFO, "txtAcctTrtyTypeCd");
		  			$("txtAcctTrtyTypeCd").value = $("txtAcctTrtyTypeCd").getAttribute("lastValidValue");
					$("txtAcctTrtyType").value = $("txtAcctTrtyType").getAttribute("lastValidValue");
					validateATT = 0;
		  		}
			});
		}catch(e){
			showErrorMessage("showAcctTreatyType",e);
		}
	}
	
	$("searchAcctTrtyType").observe("click", function(){
		if(validateATT == 0){
			showAcctTreatyType("%");
		} else {
			validateATT = 0;
		}
	});
	
	validatePCT = 0;
	$("searchProfCommType").observe("click", function(){
		if(validatePCT == 0){
			showProfCommType("%");
		} else {
			validatePCT = 0;
		}
	});
	
	function showProfCommType(x){
		try{
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					  action : "showProfCommTypeGiiss031LOV",
					  search : x,
						page : 1
				},
				title: "List of Profit Commission Type",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'lcfTag',
						title: 'Tag',
						width : '100px',
						align: 'right',
						titleAlign : 'right',
						renderer : function(value){
							return lpad(value, 2, 0);
						}
					},
					{
						id : 'lcfDesc',
						title: 'Profit Commission Type',
					    width: '335px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				filterText: nvl(unescapeHTML2(x),"%"),
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){	
						$("txtProfCommType").value = unescapeHTML2(row.lcfDesc);
						$("txtProfCommTypeCd").value = unescapeHTML2(lpad(row.lcfTag,2,0));
						$("txtProfCommType").setAttribute("lastValidValue", unescapeHTML2(row.lcfDesc));
						$("txtProfCommTypeCd").setAttribute("lastValidValue", unescapeHTML2(lpad(row.lcfTag, 2, 0)));
						objGiisDistShareUpdate.profcompType = unescapeHTML2(row.lcfTag);
						changeTagFunc = saveGiiss031;
						changeTag = 1;
						validatePCT = 0;
						/* if(params.profcompType != $F("txtProfCommTypeCd")){
							changeTag = 1;
						} */
					}
				},
				onCancel: function(){
					$("txtProfCommType").focus();
					$("txtProfCommType").value = $("txtProfCommType").getAttribute("lastValidValue");
					$("txtProfCommTypeCd").value = $("txtProfCommTypeCd").getAttribute("lastValidValue");
					validatePCT = 0;
		  		},
		  		onUndefinedRow: function(){
		  			customShowMessageBox("No record selected.", imgMessage.INFO, "txtProfCommTypeCd");
		  			$("txtProfCommType").value = $("txtProfCommType").getAttribute("lastValidValue");
					$("txtProfCommTypeCd").value = $("txtProfCommTypeCd").getAttribute("lastValidValue");
					validatePCT = 0;
		  		}
			});
		}catch(e){
			showErrorMessage("showProfCommType",e);
		}
	}
	
	function validateAcctTrtyType(){
		new Ajax.Request(contextPath+"/GIISDistributionShareController", {
			method: "POST",
			parameters: {
				action: "validateAcctTrtyType",
				trtyName: $F("txtAcctTrtyType"),
				trtyType: $F("txtAcctTrtyTypeCd")
			},
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(nvl(obj.trtyType, "") == ""){
						showAcctTreatyType($F("txtAcctTrtyTypeCd"));
					} else if(obj.trtyType == "---"){
						showAcctTreatyType($F("txtAcctTrtyTypeCd"));
					} else{
						$("txtAcctTrtyType").value = unescapeHTML2(obj.trtyName);
						$("txtAcctTrtyTypeCd").value = unescapeHTML2(lpad(obj.trtyType, 2, 0));
						objGiisDistShareUpdate.acctTrtyType = unescapeHTML2(obj.trtyType);
						$("txtAcctTrtyType").setAttribute("lastValidValue", unescapeHTML2(obj.trtyName));
						$("txtAcctTrtyTypeCd").setAttribute("lastValidValue", unescapeHTML2(lpad(obj.trtyType, 2, 0)));
						changeTagFunc = saveGiiss031;
						changeTag = 1;
						validateATT = 1;
					}
				}
			}
		});
	}
	
	function validateProfComm(){
		new Ajax.Request(contextPath+"/GIISDistributionShareController", {
			method: "POST",
			parameters: {
				action: "validateProfComm",
				lcfDesc: $F("txtProfCommType"),
				lcfTag : $F("txtProfCommTypeCd")
			},
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(nvl(obj.lcfTag, "") == ""){
						showProfCommType($F("txtProfCommTypeCd"));
					} else if(obj.lcfTag == "---"){
						showProfCommType($F("txtProfCommTypeCd"));
					} else{
						$("txtProfCommType").value = unescapeHTML2(obj.lcfDesc);
						$("txtProfCommTypeCd").value = unescapeHTML2(lpad(obj.lcfTag, 2, 0));
						objGiisDistShareUpdate.profcompType = unescapeHTML2(obj.lcfTag);
						$("txtProfCommType").setAttribute("lastValidValue", unescapeHTML2(obj.lcfDesc));
						$("txtProfCommTypeCd").setAttribute("lastValidValue", unescapeHTML2(lpad(obj.lcfTag, 2, 0)));
						changeTagFunc = saveGiiss031;
						changeTag = 1;
						validatePCT = 1;
					}
				}
			}
		});
	}
	
	$("txtAcctTrtyTypeCd").observe("change", function(){
		if($("txtAcctTrtyTypeCd").value == ""){
			$("txtAcctTrtyTypeCd").setAttribute("lastValidValue", "");
			$("txtAcctTrtyType").setAttribute("lastValidValue", "");
			$("txtAcctTrtyType").value = "";
			objGiisDistShareUpdate.acctTrtyType = "";
		} else {
			validateAcctTrtyType();
		}
		changeTag = 1;
	});
	
	$("txtProfCommTypeCd").observe("change", function(){
		if($("txtProfCommTypeCd").value == ""){
			$("txtProfCommType").value = "";
			objGiisDistShareUpdate.profcompType = "";
			$("txtProfCommType").setAttribute("lastValidValue", "");
			$("txtProfCommTypeCd").setAttribute("lastValidValue", "");
		} else {
			validateProfComm();
		}
		changeTagFunc = saveGiiss031;
		changeTag = 1;
	});
	
	function showProportionalTreatyInfo(){
		try{
			new Ajax.Request(contextPath + "/GIISDistributionShareController", {
				method: "POST",
				parameters : {
					action : "showProportionalTreatyInfo",
					lineCd: params.lineCd,
					shareCd: params.shareCd
				},
				onCreate : showNotice("Loading, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						$("mainContents").update(response.responseText);
						
					}
				}
			});
		}catch(e){
			showErrorMessage("showProportionalTreatyInfo",e);
		}
	}
	
	trtyShareAmtLVV = 0;
	trtySharePctLVV = 0;
	
	$("txtTrtySharePct").observe("focus", function(){
		trtyShareAmtLVV = ($F("txtTrtyShareAmt"));
		trtySharePctLVV = ($F("txtTrtySharePct"));
	});
	
	$("txtTrtySharePct").observe("change", function(){
		if((parseFloat($F("txtTrtySharePct")) + (parseFloat($F("txtTotShrPct")) - nvl(objGIISS031.selectedTrtyShrPct,0))) > 100){
			customShowMessageBox("Total share percent should not exceed 100%.", imgMessage.ERROR, "txtTrtySharePct");
			$("txtTrtySharePct").value = trtySharePctLVV;
			$("txtTrtyShareAmt").value = trtyShareAmtLVV;
		} 
		
		populateTrtyShareAmt();
	});
	
	function populateTrtyShareAmt(){
		if(parseFloat($F("txtTrtySharePct")) != "" && parseFloat($F("txtTrtySharePct")) <= 100){
			var amtShare = 0.00;
			amtShare = (parseFloat($F("txtTrtySharePct").replace(/,/g, "")) / 100) * parseFloat($F("txtTreatyLimit").replace(/,/g, ""));
			$("txtTrtyShareAmt").value = (isNaN(amtShare) ? "" : formatCurrency(amtShare));
			trtyShareAmtLVV = ($F("txtTrtyShareAmt"));
			trtySharePctLVV = ($F("txtTrtySharePct"));
		}
	}
	
	$("txtTrtyShareAmt").observe("focus", function(){
		trtyShareAmtLVV = ($F("txtTrtyShareAmt"));
		trtySharePctLVV = ($F("txtTrtySharePct"));
	});
	
	$("txtTrtyShareAmt").observe("change", function(){
		if((parseFloat($F("txtTrtyShareAmt").replace(/,/g, "")) > parseFloat($F("txtTreatyLimit").replace(/,/g, "")))){
			$("txtTrtyShareAmt").value = formatCurrency(trtyShareAmtLVV);
			customShowMessageBox("Share amount should not exceed Treaty Limit "+formatCurrency($F("txtTreatyLimit"))+".", imgMessage.ERROR, "txtTrtyShareAmt");
			$("txtTrtySharePct").value = trtySharePctLVV;
			$("txtTrtyShareAmt").value = trtyShareAmtLVV;
			return;
		}
		
		if((nvl(parseFloat($F("txtTotShrAmt").replace(/,/g, "")),0)  - nvl(objGIISS031.selectedTrtyShrAmt,0)) + parseFloat($F("txtTrtyShareAmt").replace(/,/g, "")) > parseFloat($F("txtTreatyLimit").replace(/,/g, ""))){
			$("txtTrtyShareAmt").value = formatCurrency(trtyShareAmtLVV);
			customShowMessageBox("Share amount should not exceed Treaty Limit "+formatCurrency($F("txtTreatyLimit"))+".", imgMessage.ERROR, "txtTrtyShareAmt");
			$("txtTrtySharePct").value = trtySharePctLVV;
			$("txtTrtyShareAmt").value = trtyShareAmtLVV;
			return;
		} 
		
		populateTrtySharePct();			
	});
	
	function populateTrtySharePct(){
		var percentShare = 0.00;
		percentShare = (parseFloat($F("txtTrtyShareAmt").replace(/,/g, "")) / parseFloat($F("txtTreatyLimit").replace(/,/g, ""))) * 100;
		$("txtTrtySharePct").value = (isNaN(percentShare) ? "" : formatToNthDecimal(percentShare, 9));
		trtyShareAmtLVV = ($F("txtTrtyShareAmt"));
		trtySharePctLVV = ($F("txtTrtySharePct"));
		
		/* if(parseFloat(percentShare + parseFloat($F("txtTotShrPct"))) > 100){
			customShowMessageBox("Total share percent should not exceed 100%.", imgMessage.ERROR, "txtTrtySharePct");
			$("txtTrtySharePct").value = trtySharePctLVV;
			$("txtTrtyShareAmt").value = trtyShareAmtLVV;
		}	 */
	}
	
	validateRI = 0;
	
	function showRiLOV(x){
		try{
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					  action : "getGiiss031RiLOV",
					  search : x,
						page : 1
				},
				title: "List of Reinsurers",
				width: 400,
				height: 400,
				columnModel: [
					{
						id : 'dspRiSname',
						title: 'RI Short Name',
					    width: '120px',
					    align: 'left'
					},
					{
						id : 'dspRiName',
						title: 'Reinsurer Name',
					    width: '265px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				filterText : nvl(escapeHTML2(x), "%"),
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						objGIISS031.riCd = unescapeHTML2(row.riCd);
						$("txtReinsurer").value = unescapeHTML2(row.dspRiSname);
						$("txtRiBase").value = unescapeHTML2(row.dspLocalForeignSw);	
						$("txtRiType").value = unescapeHTML2(row.dspRiTypeDesc);
						changeTag = 1;
						validateRI = 0;
						$("txtReinsurer").setAttribute("lastValidValue", unescapeHTML2(row.dspRiSname));
						$("txtRiBase").setAttribute("lastValidValue", unescapeHTML2(row.dspLocalForeignSw));
						$("txtRiType").setAttribute("lastValidValue", unescapeHTML2(row.dspRiTypeDesc));
					}
				},
				onCancel: function(){
					validateRI = 0;
					$("txtReinsurer").focus();
					$("txtReinsurer").value = $("txtReinsurer").getAttribute("lastValidValue");
					$("txtRiBase").value = $("txtRiBase").getAttribute("lastValidValue");
					$("txtRiType").value = $("txtRiType").getAttribute("lastValidValue");
					
		  		},
		  		onUndefinedRow: function(){
		  			validateRI = 0;
		  			customShowMessageBox("No record selected.", imgMessage.INFO, "txtReinsurer");
		  			$("txtReinsurer").value = $("txtReinsurer").getAttribute("lastValidValue");
					$("txtRiBase").value = $("txtRiBase").getAttribute("lastValidValue");
					$("txtRiType").value = $("txtRiType").getAttribute("lastValidValue");
		  		}
			});
		}catch(e){
			showErrorMessage("showRiLOV",e);
		}
	}
	
	validatePRI = 0;
	
	function showParentRiLOV(x){
		try{
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					  action : "getGiiss031ParentRiLOV",
					  search : x,
						page : 1
				},
				title: "List of Parent Reinsurers",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'riCd',
						title: 'Code',
						width : '100px',
						align: 'right',
						titleAlign : 'right'
					},
					{
						id : 'riSname',
						title: 'Reinsurer',
					    width: '335',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				filterText: nvl(escapeHTML2(x),"%"),
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtParentRi").value = unescapeHTML2(row.riSname);
						$("txtParentRi").setAttribute("lastValidValue", unescapeHTML2(row.riSname));
						objGIISS031.prntRiCd = unescapeHTML2(row.riCd);
						changeTag = 1;
						validatePRI = 0;
					}
				},
				onCancel: function(){
					validatePRI = 0;
					$("txtParentRi").focus();
					$("txtParentRi").value = $("txtParentRi").getAttribute("lastValidValue");
		  		},
		  		onUndefinedRow: function(){
		  			validatePRI = 0;
		  			customShowMessageBox("No record selected.", imgMessage.INFO, "txtParentRi");
		  			$("txtParentRi").value = $("txtParentRi").getAttribute("lastValidValue");
		  		}
			});
		}catch(e){
			showErrorMessage("showParentRiLOV",e);
		}
	}
	
	$("searchReinsurer").observe("click", function(){
		if(validateRI == 0){
			showRiLOV("%");
		} else {
			validateRI = 0;
		}
	});
	$("searchParentRi").observe("click", function(){
		if(validatePRI == 0){
			showParentRiLOV("%");
		} else {
			validatePRI = 0;
		}
	});
	
	function validateReinsurer(){
		new Ajax.Request(contextPath+"/GIISTrtyPanelController", {
			method: "POST",
			parameters: {
				action: "validateGiiss031Reinsurer",
				riSname: $F("txtReinsurer")
			},
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(nvl(obj.riCd, "") == ""){
						showRiLOV($("txtReinsurer").value);
					} else if (obj.riCd == "---"){
						showRiLOV($("txtReinsurer").value);
					} else{
						$("txtReinsurer").value = unescapeHTML2(obj.riSname);
						$("txtRiType").value = unescapeHTML2(obj.riTypeDesc);
						$("txtRiBase").value = unescapeHTML2(obj.riLocalForeignSw);
						changeTag = 1;
						objGIISS031.riCd = obj.riCd;
						$("txtReinsurer").setAttribute("lastValidValue", unescapeHTML2(obj.riSname));
						$("txtRiBase").setAttribute("lastValidValue", unescapeHTML2(obj.riLocalForeignSw));
						$("txtRiType").setAttribute("lastValidValue", unescapeHTML2(obj.riTypeDesc));
					}
				}
			}
		});
	}
	
	function validateParentRi(){
		new Ajax.Request(contextPath+"/GIISTrtyPanelController", {
			method: "POST",
			parameters: {
				action: "validateGiiss031ParentRi",
				prntSname: $F("txtParentRi")
			},
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(nvl(obj.prntRiCd, "") == ""){
						showParentRiLOV($("txtParentRi").value);
					} else if(obj.prntRiCd == "---"){
						showParentRiLOV($("txtParentRi").value);
					} else {
						$("txtParentRi").value = unescapeHTML2(obj.prntSname);
						$("txtParentRi").setAttribute("lastValidValue", unescapeHTML2(obj.prntSname));
						objGIISS031.prntRiCd = obj.prntRiCd;
						changeTag = 1;
					}
				}
			}
		});
	}
	
	$("txtParentRi").observe("change",function(){
		if($("txtParentRi").value == ""){
			objGIISS031.prntRiCd  = "";
			$("txtParentRi").setAttribute("lastValidValue", "");
		} else {
			validatePRI = 1;
			showParentRiLOV($("txtParentRi").value);
		}
	});
	
	$("txtReinsurer").observe("change",function(){
		if($("txtReinsurer").value == ""){
			$("txtRiType").value = "";
			$("txtRiBase").value = "";
			objGIISS031.riCd  = "";
			$("txtReinsurer").setAttribute("lastValidValue", "");
			$("txtRiBase").setAttribute("lastValidValue", "");
			$("txtRiType").setAttribute("lastValidValue", "");
		} else {
			validateRI = 1;
			showRiLOV($("txtReinsurer").value);
		}
	});
	
	function populateTotal2(){
		trtySharePctTot = 0;
		trtyShareAmtTot = 0;

		for(var i = 0; i < objGIISS031.trtyAllRecList.rows.length; i++){
			trtySharePctTot = parseFloat(trtySharePctTot) + parseFloat(objGIISS031.trtyAllRecList.rows[i].trtyShrPct);
			trtyShareAmtTot = parseFloat(trtyShareAmtTot) + parseFloat(objGIISS031.trtyAllRecList.rows[i].trtyShrAmt);
		}
		
		$("txtTotShrPct").value = (trtySharePctTot == 0 || isNaN(trtySharePctTot) ? "" : formatToNthDecimal(trtySharePctTot,9));
		$("txtTotShrAmt").value = (trtyShareAmtTot == 0 || isNaN(trtyShareAmtTot) ? "" : formatCurrency(trtyShareAmtTot));
		
		if(trtySharePctTot == 100){
			disableButton("btnAdd");
		} else if(trtySharePctTot != 100){
			enableButton("btnAdd");
		}
	}
	
	$("btnTrtyPeril").observe("click", function(){
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objGIISS031.exitPage = showTrtyPeril;
						saveGiiss031();
					}, function() {
						showTrtyPeril();
					}, "");
		} else {
			showTrtyPeril();
		} 
	}); 
	
	function showTrtyPeril(){
		objUWGlobal.module = "GIISS031";
		objGiris007.proportionalTreaty = "Y";
		objGiris007.shareType = 2;
		objGiris007.lineCd =  params.lineCd;
		objGiris007.trtyYy = params.trtyYy;
		objGiris007.shareCd = params.shareCd;
		
		showGiris007();
	} 
	var trtyLimitHold = 0;
	//observe main info changes
	$("txtTreatyLimit").observe("change", function(){
		/* removed by robert
		if($("txtTreatyLimit").value == ""){
			$("txtTreatyLimit").value = trtyLimitLastValidValue;
			customShowMessageBox("Treaty limit is required.", "I", "txtTreatyLimit");
		} */
		
		if(parseFloat($("txtTreatyLimit").value.replace(/,/g, "")) < parseFloat($("txtTotShrAmt").value.replace(/,/g, ""))){
			$("txtTreatyLimit").value = trtyLimitLastValidValue;
			customShowMessageBox("Treaty limit should not be less than the total of treaty share amount.", "I", "txtTreatyLimit");
		} 

		//if(parseFloat($("txtTreatyLimit").value.replace(/,/g, "")) > parseFloat(params.trtyLimit)){
		if(parseFloat($("txtTreatyLimit").value.replace(/,/g, "")) > parseFloat(trtyLimitLastValidValue)){
			trtyLimitHold = trtyLimitLastValidValue;
			showConfirmBox("Confirmation", "The treaty limit has been increased. Treaty share amounts will be recomputed. Do you want to proceed?", "Yes", "No",
					function(){
						recomputeTrty();
					},
					function(){
						$("txtTreatyLimit").value = trtyLimitHold;
					}, "1");
		} else {
			recomputeTrty();
		}
		
		if($("txtTrtyShareAmt").value != "" || $("txtTrtySharePct").value != ""){
			if($("txtTrtySharePct").value != ""){
				var amtValue = (parseFloat($("txtTrtySharePct").value.replace(/,/g, "")) / 100) * parseFloat($("txtTreatyLimit").value.replace(/,/g, ""));
				$("txtTrtyShareAmt").value = formatCurrency(amtValue);
			} else if($("txtTrtyShareAmt").value != ""){
				var pctValue = (parseFloat($("txtTrtyShareAmt").value.replace(/,/g, "")) / parseFloat($("txtTreatyLimit").value.replace(/,/g, ""))) * 100;
				$("txtTrtySharePct").value = formatToNthDecimal(pctValue,9);
			} 
		}
		
		changeTag = 1;
		changeTagFunc = saveGiiss031;
		trtyLimitLastValidValue = $("txtTreatyLimit").value;
	});
	
	function recomputeTrty(){
		var newTrtyLimit = parseFloat($("txtTreatyLimit").value.replace(/,/g, ""));
		recompute = 1;
		
		//for display
		for (var i = 0; i < tbgTreatyInfo.geniisysRows.length; i++){
			if (tbgTreatyInfo.geniisysRows[i].recordStatus != -1){
				obj = tbgTreatyInfo.geniisysRows[i];
				newVal = (parseFloat(obj.trtyShrPct) / 100) * newTrtyLimit;
				obj.trtyShrAmt = formatCurrency(newVal);
				obj.trtyShrPct = formatToNthDecimal(obj.trtyShrPct,9);
				obj.riCommRt = formatToNthDecimal(obj.riCommRt,9);
				obj.fundsHeldPct = formatToNthDecimal(obj.fundsHeldPct,9);
				obj.whTaxRt = formatToNthDecimal(obj.whTaxRt,4);
				obj.intOnPremRes = formatToNthDecimal(obj.intOnPremRes,9);
				obj.intTaxRt = formatToNthDecimal(obj.intTaxRt,9); //benjo 08.03.2016 SR-5512
				
				tbgTreatyInfo.updateVisibleRowOnly(obj, i, false);
			}
		}
		
		for (var i = 0; i < objGIISS031.trtyAllRecList.rows.length; i++){
			objGIISS031.trtyAllRecList.rows[i].trtyShrAmt = (parseFloat(objGIISS031.trtyAllRecList.rows[i].trtyShrPct)  / 100 ) * newTrtyLimit;
		}
		if(tbgTreatyInfo.geniisysRows.length != 0){
			repopulateTotal();		
		}
	}
	
	function repopulateTotal(){
		var amtValue = (parseFloat($("txtTreatyLimit").value.replace(/,/g, "")) * (parseFloat($("txtTotShrPct").value.replace(/,/g, "")) / 100));
		$("txtTotShrAmt").value = (amtValue == 0 ? "" : formatCurrency(amtValue));
	}
	
	$("txtFundsHeld").observe("change", function(){
		changeTagFunc = saveGiiss031;
		changeTag = 1;
	});
	
	$("txtLossPortfolio").observe("change", function(){
		changeTag = 1;
		changeTagFunc = saveGiiss031;
	});
	
	$("txtPremPortfolio").observe("change", function(){
		changeTag = 1;
		changeTagFunc = saveGiiss031;
	});
	
	$("rdoPortfolio").observe("change", function(){
		changeTag = 1;
		changeTagFunc = saveGiiss031;
		$("txtOldTrtySeqNo").addClassName("required");
	});
	
	$("rdoNaturalExp").observe("click", function(){
		changeTag = 1;
		changeTagFunc = saveGiiss031;
		$("txtOldTrtySeqNo").removeClassName("required");
	});
	
	$("txtTreatyName").observe("change", function(){
		new Ajax.Request(contextPath + "/GIISDistributionShareController", {
			parameters : {
				action: "validateGiiss031TrtyName",
				trtyName: $F("txtTreatyName"),
				lineCd: params.lineCd,
				shareType: 2
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete : function(response) {
				hideNotice();
				if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
					$("txtTreatyName").setAttribute("lastValidValue", $("txtTreatyName").value);
				} else {
					$("txtTreatyName").value = $("txtTreatyName").getAttribute("lastValidValue");
				}
				/* if(unescapeHTML2(params.trtyName) != $("txtTreatyName").value){
					changeTag = 1;
				} */
				changeTagFunc = saveGiiss031;
				changeTag = 1;
			}
		});
	});
	
	$("txtOldTrtySeqNo").observe("change", function(){
		if($F("txtOldTrtySeqNo")!= ""){
			new Ajax.Request(contextPath + "/GIISDistributionShareController", {
				parameters : {
					action: "validateGiiss031OldTrtySeq",
					lineCd: params.lineCd,
					shareCd: params.shareCd,
					oldTrtySeqNo: $F("txtOldTrtySeqNo"),
					shareType: 2,
					acctTrtyType: $F("txtAcctTrtyTypeCd")
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
						$("txtOldTrtySeqNo").setAttribute("lastValidValue", $("txtOldTrtySeqNo").value);
					} else {
						$("txtOldTrtySeqNo").value = $("txtOldTrtySeqNo").getAttribute("lastValidValue");
					}
					/* if(unescapeHTML2(params.oldTrtySeqNo) != $("txtOldTrtySeqNo").value){
						changeTag = 1;
					} */
					changeTagFunc = saveGiiss031;
					changeTag = 1;
				}
			});
		}
	});
	
	function valDeleteRec() {
		try {
			new Ajax.Request(contextPath + "/GIISTrtyPanelController", {
				parameters  : {
					action  : "valDeleteRec",
					lineCd  : params.lineCd,
					trtySeqNo : params.shareCd,
					trtyYy  : params.trtyYy,
					riCd    : objGIISS031.riCd
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
	
	/* start - Gzelle 02032016 SR21614 */
	function roundExpNumber(number, decimals) {
		var newnumber = new Number(number+'').toFixed(parseInt(decimals));
		return parseFloat(newnumber);
	}
	/* end - Gzelle 02032016 SR21614 */
	
	objGiris007.shareType = null;
	objGiris007.lineCd = "";
	objGiris007.trtyYy = "";
	objGiris007.shareCd = "";
	objGiris007.layerNo = "";
	objGiris007.proportionalTreaty = "";
</script>