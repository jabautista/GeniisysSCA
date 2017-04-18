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
	   			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss031" name="giiss031">	
		<div class="sectionDiv" align="center">
			<table cellspacing="0" style="margin-bottom:10px; margin-top: 10px;">
				<tr>
					<td class="rightAligned">XOL Treaty</td>
					<td class="leftAligned" colspan="3">
						<input id="txtDspXolTreatyNo" type="text" class="leftAligned" style="width: 150px;" tabindex="101" readonly="readonly">
						<input id="txtXolTrtyName" type="text" class="leftAligned" style="width: 428px;" tabindex="102" readonly="readonly">
					</td>
				</tr>
			</table>
		</div>	
		<div name="div" class="sectionDiv">
			<div id="nonPropTrtyTableDiv" style="padding-top: 15px;">
				<div id="nonPropTrtyTable" style="height: 335px; padding: 0 165px 0 165px;"></div>
			</div>
			<div align="center" id="nonPropTrtyFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Layer</td>
						<td class="leftAligned" colspan="3">
							<input id="txtLayerNo" type="text" class="required allCaps integerNoNegativeUnformattedNoComma" style="width: 150px; text-align: right;" tabindex="201" maxlength="2" lpad="2">
							<input id="txtTrtyName" type="text" class="required allCaps" style="width: 250px; text-align: left;" tabindex="202" maxlength="30">
							<input id="txtShareCd" type="text" class="allCaps" style="width: 115px; text-align: right;" tabindex="203" maxlength="3" readonly="readonly">
						</td>
					</tr>	
					<tr>
						<td class="rightAligned">Term From</td>
						<td class="leftAligned">
							<div id="endDateDiv" class="required" style="float: left; border: 1px solid gray; width: 205px; height: 20px;">
								<input id="txtTermFrom" name="From Date" readonly="readonly" type="text" class="date required" maxlength="10" style="border: none; float: left; width: 180px; height: 13px; margin: 0px;" value="" tabindex="204"/>
								<img id="imgEffDate" alt="imgEffDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtTermFrom'),this, null);" />
							</div>
						</td>
						<td class="rightAligned">To</td>
						<td class="leftAligned">
							<div id="endDateDiv" class="required" style="float: left; border: 1px solid gray; width: 205px; height: 20px;">
								<input id="txtTermTo" name="To Date" readonly="readonly" type="text" class="date required" maxlength="10" style="border: none; float: left; width: 180px; height: 13px; margin: 0px;" value="" tabindex="205"/>
								<img id="imgEffDate" alt="imgEffDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtTermTo'),this, null);" />
							</div>
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">XOL Limit</td>
						<td class="leftAligned">
							<input id="txtXolLimit" type="text" class="allCaps rightAligned required applyDecimalRegExp2" regExpPatt="pDeci1602" min="0.01" max="99999999999999.99" customLabel="XOL Limit" style="width: 200px;" tabindex="206" maxlength="">
						</td>
						<td class="rightAligned">In Excess of</td>
						<td class="leftAligned">
							<input id="txtInExcessOf" type="text" class="rightAligned applyDecimalRegExp2" regExpPatt="pDeci1602" min="0.00" max="99999999999999.99" customLabel="In Excess Of" style="width: 199px;" tabindex="207" maxlength="">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Aggregate Sum</td>
						<td class="leftAligned">
							<input id="txtAggregateSum" type="text" class="rightAligned applyDecimalRegExp2" regExpPatt="pDeci1602" min="0.00" max="99999999999999.99" customLabel="Aggregate Sum" style="width: 200px;" tabindex="208" maxlength="">
						</td>
						<td class="rightAligned">No. of Reinstatement</td>
						<td class="leftAligned">
							<input id="txtNoOfReinstatement" type="text" class="integerNoNegativeUnformattedNoComma rightAligned" style="width: 199px;" tabindex="209" maxlength="3">
						</td>
					</tr>	
					<tr>
						<td class="rightAligned">Minimum Deposit</td>
						<td class="leftAligned">
							<input id="txtMinDeposit" type="text" class="rightAligned applyDecimalRegExp2" regExpPatt="pDeci1602" min="0.00" max="99999999999999.99" customLabel="Minimum Deposit" style="width: 200px;" tabindex="210" maxlength="">
						</td>
						<td class="rightAligned">Reserve Claim Amt.</td>
						<td class="leftAligned">
							<input id="txtResClaimAmt" type="text" class="rightAligned applyDecimalRegExp2" regExpPatt="pDeci1602" min="0.00" max="99999999999999.99" customLabel="Reserve Claim Amt." style="width: 199px;" tabindex="211" maxlength="" readonly="readonly">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Premium Take-up Rate</td>
						<td class="leftAligned">
							<input id="txtPremRate" type="text" class="rightAligned applyDecimalRegExp2" style="width: 200px;" tabindex="212" maxlength="" regExpPatt="pDeci0309" min="0.000000000" max="100.000000000" customLabel="Premium Take-up Rate">
						</td>
						<td class="rightAligned">Paid Claim Amount</td>
						<td class="leftAligned">
							<input id="txtPaidClaimAmt" type="text" class="rightAligned applyDecimalRegExp2" regExpPatt="pDeci1602" min="0.00" max="99999999999999.99" customLabel="Reserve Claim Amt."" style="width: 199px;" tabindex="213" maxlength="" readonly="readonly">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">XOL Deductible</td>
						<td class="leftAligned">
							<input id="txtXolDed" type="text" class="rightAligned applyDecimalRegExp2" regExpPatt="pDeci1602" min="0.00" max="99999999999999.99" customLabel="XOL Deductible" style="width: 200px;" tabindex="214" maxlength="">
						</td>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 205px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 179px; margin-top: 0; border: none;" id="txtRemarksMain" name="txtRemarksMain" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="215"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarksMain"  tabindex="216"/>
							</div>
						</td>
					</tr>
				</table>
			</div>
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="217">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="218">
			</div>
			<div align="center" style="padding: 10px 0 10px 0; border-top: 1px solid #E0E0E0;">
				<input type="button" class="button" id="btnTrtyPeril" value="Treaty Peril" tabindex="301" style="width: 150px; ">
			</div>
		</div>
	</div>
</div>
<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
   		<label>Outward Treaty Maintenance</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
		</span>
   	</div>
</div>
<div id="trtyMaintenanceDiv" class="sectionDiv">
	<div id="trtyTableDiv" style="padding-top: 15px;">
		<div id="trtyTable" style="height: 335px; padding: 0 137px 0 137px;"></div>
	</div>
	<div align="center">
		<table cellpadding="0">
			<tr>
				<td class="leftAligned">RI Type</td>
				<td class="leftAligned">
					<input id="txtRiType" type="text" class="leftAligned" style="width: 220px;" tabindex="302" readonly="readonly">
				</td>
				<td class="rightAligned" width="130px">Totals</td>
				<td class="rightAligned">
					<input id="txtTotShrPct" type="text" class="rightAligned" style="width: 110px;" tabindex="304" readonly="readonly">
				</td>
				<td class="rightAligned">
					<input id="txtTotShrAmt" type="text" class="rightAligned" style="width: 110px;" tabindex="305" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="leftAligned">RI Base</td>
				<td class="leftAligned">
					<input id="txtRiBase" type="text" class="leftAligned" style="width: 220px;" tabindex="303" readonly="readonly">
				</td>
			</tr>
		</table>				
	</div>
	<div align="center" id="trtyPanelFormDiv">
		<table style="margin-top: 5px;">
			<tr>
				<td class="rightAligned">Reinsurer</td>
				<td class="leftAligned">
					<span class="lovSpan required" style="width: 205px; height: 21px; margin: 2px 2px 0 0; float: left;">
						<input type="text" id="txtReinsurer" name="txtReinsurer" ignoreDelKey="1"  style="width: 173px; float: left; border: none; height: 13px;" class="required allCaps" maxlength="15" tabindex="401" />
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchReinsurer" name="searchReinsurer" alt="Go" style="float: right;">
					</span>
				</td>
				<td class="rightAligned">Parent RI</td>
				<td class="leftAligned">
					<span class="lovSpan" style="width: 205px; height: 21px; margin: 2px 2px 0 0; float: left;">
						<input type="text" id="txtPrntRi" name="txtPrntRi" ignoreDelKey="1" style="width: 173px; float: left; border: none; height: 13px;" class="allCaps" maxlength="15" tabindex="402" />
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchPrntRi" name="searchPrntRi" alt="Go" style="float: right;">
					</span> 
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Trty Share %</td>
				<td class="leftAligned">
					<input id="txtTrtySharePct" type="text" class="rightAligned applyDecimalRegExp2" regExpPatt="pDeci0309" min="0.000000001" max="100.000000000" customLabel="Treaty Share %" style="width: 200px;" tabindex="403" maxlength="">
				</td>
				<td class="rightAligned">Treaty Share Amount</td>
				<td class="leftAligned">
					<input id="txtTrtyShareAmt" type="text" class="rightAligned applyDecimalRegExp2" regExpPatt="pDeci1602" min="0.00" max="99999999999999.99" customLabel="Treaty Share Amount" style="width: 200px;" tabindex="405" maxlength="">
				</td>
			</tr>
			<tr>
				<td width="" class="rightAligned">RI Comm %</td>
				<td class="leftAligned">
					<input id="txtRiComm" type="text" class="rightAligned applyDecimalRegExp2" regExpPatt="pDeci0309" min="0.000000000" max="100.000000000" customLabel="RI Comm %" style="width: 200px;" tabindex="404" maxlength="">
				</td>
				<td width="" class="rightAligned">Funds Held %</td>
				<td class="leftAligned">
					<input id="txtFundsHeld" type="text" class="rightAligned applyDecimalRegExp2" regExpPatt="pDeci0309" min="0.000000000" max="100.000000000" customLabel="Funds Held %" style="width: 200px;" tabindex="406" maxlength="">
				</td>
			</tr>	
			<tr>
				<td width="" class="rightAligned">Remarks</td>
				<td class="leftAligned" colspan="3">
					<div id="remarksDiv" name="remarksDiv" style="float: left; width: 550px; border: 1px solid gray; height: 22px;">
						<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="407"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"/>
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">User ID</td>
				<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="408"></td>
				<td width="" class="rightAligned">Last Update</td>
				<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="409"></td>
			</tr>			
		</table>
	</div>
	<div style="margin: 10px;" align="center">
		<input type="button" class="button" id="btnAdd2" value="Add" tabindex="410">
		<input type="button" class="button" id="btnDelete2" value="Delete" tabindex="411">
	</div>
</div>	
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="501">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="502">
</div>
<script type="text/javascript">	
	setModuleId("GIISS031");
	setDocumentTitle("Maintain Outward Treaty Information");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	disableButton("btnDelete2");
	setNpTrtyReadOnly(true);
	var newlyAdded = false;
	var childChangeTag = false;
	disableButton("btnTrtyPeril");
	
	function enableTreatyPerilBtn(sw){
		if(sw){
			if(checkUserModule("GIRIS007")){
				enableButton("btnTrtyPeril");
			} else {
				disableButton("btnTrtyPeril");
			}
		} else {
			disableButton("btnTrtyPeril");
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
		objGiris007.proportionalTreaty = "N";
		objGiris007.shareType = 4;
		objGiris007.lineCd =  params.lineCd;
		objGiris007.trtyYy = params.xolYy;
		objGiris007.shareCd = params.xolSeqNo;
		objGiris007.layerNo = objGIISS031.layerNo;
		
		showGiris007();
	} 
	
	params = JSON.parse('${obj}');
	$("txtDspXolTreatyNo").value = unescapeHTML2(params.lineCd) +" - "+params.xolYy +" - "+ lpad(params.xolSeqNo,3,0);
	$("txtXolTrtyName").value = unescapeHTML2(params.xolTrtyName);
	
	function saveGiiss031(){
		var proceedSaveParent = false;
		tbgTreaty.geniisysRows.length - getDeletedJSONObjects(tbgTreaty.geniisysRows).length == 0 ? proceedSaveParent = false : proceedSaveParent = true;
		if(!proceedSaveParent && objTrtyPanel.curr){
			customShowMessageBox("Distribution Share must have at least 1 child record.", imgMessage.INFO, "txtReinsurer");
			return;
		}
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgNonPropTrty.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgNonPropTrty.geniisysRows);
		new Ajax.Request(contextPath+"/GIISDistributionShareController", {
			method: "POST",
			parameters : {action : "saveGiiss031",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					saveTrtyPanel();
				}
			}
		});
	}
	
	function saveTrtyPanel(){
		var setRows = getAddedAndModifiedJSONObjects(tbgTreaty.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgTreaty.geniisysRows);
		new Ajax.Request(contextPath+"/GIISTrtyPanelController", {
			method: "POST",
			parameters : {action : "saveGiiss031Np",
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
							showNonProportionalTreatyInfo();
						}
					});
					changeTag = 0;
					newlyAdded = false;
					childChangeTag = false;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showNonProportionalTreatyInfo);
	
	var objGIISS031 = {};
	var objCurrTrty = null;
	objGIISS031.trtyList = JSON.parse('${jsonNonPropTrty}');
	objGIISS031.exitPage = null;
	var objTrtyPanel = {};
	objTrtyPanel.amtLimit = 0;
	objTrtyPanel.curr = false;
	
	var nonPropTrtyTable = {
			url : contextPath + "/GIISDistributionShareController?action=showNonProportionalTreatyInfo&refresh=1&lineCd="+params.lineCd+"&trtyYy="+params.xolYy+"&xolId="+params.xolId,
			options : {
				width : '600px',
				hideColumnChildTitle: true,
				pager : {},
				beforeClick : function(element, value, x, y, id){				
					if((newlyAdded && changeTag == 1) || childChangeTag){
						showMessageBox("Please save changes first.", imgMessage.INFO);
						return false;						
					}			
				},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrTrty = tbgNonPropTrty.geniisysRows[y];
					setFieldValues(objCurrTrty);
					tbgNonPropTrty.keys.removeFocus(tbgNonPropTrty.keys._nCurrentFocus, true);
					tbgNonPropTrty.keys.releaseKeys();
					$("txtReinsurer").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgNonPropTrty.keys.removeFocus(tbgNonPropTrty.keys._nCurrentFocus, true);
					tbgNonPropTrty.keys.releaseKeys();
					$("txtLayerNo").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgNonPropTrty.keys.removeFocus(tbgNonPropTrty.keys._nCurrentFocus, true);
						tbgNonPropTrty.keys.releaseKeys();
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
					tbgNonPropTrty.keys.removeFocus(tbgNonPropTrty.keys._nCurrentFocus, true);
					tbgNonPropTrty.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgNonPropTrty.keys.removeFocus(tbgNonPropTrty.keys._nCurrentFocus, true);
					tbgNonPropTrty.keys.releaseKeys();
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
					tbgNonPropTrty.keys.removeFocus(tbgNonPropTrty.keys._nCurrentFocus, true);
					tbgNonPropTrty.keys.releaseKeys();
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
					id : 'layerNo',
					title : "Layer No",
					align : "right",
					titleAlign : "right",
					filterOption : true,
					filterOptionType: 'integerNoNegative',
					width : '120px',
					renderer : function(value){
						return lpad(value,2,0);
					}
				},
				{
					id : 'trtyName',
					filterOption : true,
					title : 'Treaty Name',
					width : '320px'				
				},
				{
					id : 'shareCd',
					title : "Share Code",
					align : "right",
					titleAlign : "right",
					filterOption : true,
					filterOptionType: 'integerNoNegative',
					width : '120px'
				}
			],
			rows : objGIISS031.trtyList.rows
		};

		tbgNonPropTrty = new MyTableGrid(nonPropTrtyTable);
		tbgNonPropTrty.pager = objGIISS031.trtyList;
		tbgNonPropTrty.render("nonPropTrtyTable");
	
	function setFieldValues(rec){
		try{
			$("txtLayerNo").value = 		(rec == null ? "" : lpad(rec.layerNo,2,0));
			$("txtLayerNo").setAttribute("lastValidValue", (rec == null ? "" : lpad(rec.layerNo,2,0)));
			$("txtTrtyName").value = 		(rec == null ? "" : unescapeHTML2(rec.trtyName));
			$("txtShareCd").value = 		(rec == null ? "" : unescapeHTML2(rec.shareCd));
			$("txtTermFrom").value = 		(rec == null ? "" : dateFormat(unescapeHTML2(rec.effDate),'mm-dd-yyyy'));
			$("txtTermTo").value = 			(rec == null ? "" : dateFormat(unescapeHTML2(rec.expiryDate),'mm-dd-yyyy'));
			$("txtXolLimit").value = 			(rec == null ? "" : formatCurrency(rec.xolAllowedAmount));
			$("txtXolLimit").setAttribute("lastValidValue", (rec == null ? "" : formatCurrency(rec.xolAllowedAmount)));
			$("txtInExcessOf").value = 			(rec == null ? "" : formatCurrency(rec.xolBaseAmount));
			$("txtAggregateSum").value = 		(rec == null ? "" : formatCurrency(rec.xolAggregateSum));
			$("txtNoOfReinstatement").value = 	(rec == null ? "" : rec.reinstatementLimit);
			$("txtResClaimAmt").value = 		(rec == null ? "" : formatCurrency(rec.xolReserveAmount));
			$("txtMinDeposit").value = 		(rec == null ? "" : formatCurrency(rec.xolPremMindep));
			$("txtPremRate").value = 			(rec == null ? "" : formatToNthDecimal(rec.xolPremRate,9));
			$("txtPaidClaimAmt").value = 	(rec == null ? "" : formatCurrency(rec.xolAllocatedAmount));
			$("txtXolDed").value = 			(rec == null ? "" : formatCurrency(rec.xolDed));
			$("txtRemarksMain").value = 	(rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? enableTreatyPerilBtn(false) : enableTreatyPerilBtn(true);
			
			objTrtyPanel.amtLimit = (rec == null ? "" : formatCurrency(rec.xolAllowedAmount));
			
			objGIISS031.shareCd = (rec == null ? "" : rec.shareCd);
			objGIISS031.layerNo = (rec == null ? "" : rec.layerNo);
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtLayerNo").readOnly = false : $("txtLayerNo").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			rec == null ? executeQuery(false) : executeQuery(true);
			rec == null ? enableTreatyPerilBtn(false) : enableTreatyPerilBtn(true);
			rec == null ? objTrtyPanel.curr = false : objTrtyPanel.curr = true;
			rec == null ? disableButton("btnAdd2") : enableButton("btnAdd2");
			populateTotal();
			
			objCurrTrty = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function executeQuery(sw){
		if(sw){
			tbgTreaty.url = contextPath+"/GIISTrtyPanelController?action=showGiiss031Np&refresh=1&lineCd="+params.lineCd+"&trtyYy="+params.xolYy+"&shareCd="+objCurrTrty.shareCd;
			tbgTreaty._refreshList();
			setNpTrtyReadOnly(false);
		} else {
			tbgTreaty.url = contextPath+"/GIISTrtyPanelController?action=showGiiss031Np&refresh=1";
			tbgTreaty._refreshList();
			setNpTrtyReadOnly(true);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			
			obj.lineCd = escapeHTML2(params.lineCd);
			obj.shareCd = objGIISS031.shareCd;
			obj.xolId = params.xolId;
			obj.trtyYy = params.xolYy;
			obj.layerNo = $F("txtLayerNo");
			obj.shareCd = $F("txtShareCd");
			obj.trtyName = escapeHTML2($F("txtTrtyName"));
			obj.effDate = $F("txtTermFrom");
			obj.expiryDate = $F("txtTermTo");
			obj.xolAllowedAmount = $F("txtXolLimit").replace(/,/g, "");
			obj.xolBaseAmount = $F("txtInExcessOf").replace(/,/g, "");
			obj.xolAggregateSum = $F("txtAggregateSum").replace(/,/g, "");
			obj.reinstatementLimit = $F("txtNoOfReinstatement");
			obj.xolReserveAmount = $F("txtResClaimAmt").replace(/,/g, "");
			obj.xolPremRate = $F("txtPremRate").replace(/,/g, "");
			obj.xolAllocatedAmount = $F("txtPaidClaimAmt").replace(/,/g, "");
			obj.xolPremMindep = $F("txtMinDeposit").replace(/,/g, "");
			obj.xolDed = $F("txtXolDed").replace(/,/g, "");
			obj.remarks = escapeHTML2($F("txtRemarksMain"));
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			newlyAdded = true;
			changeTagFunc = saveGiiss031;
			var trty = setRec(objCurrTrty);
			if($F("btnAdd") == "Add"){
				tbgNonPropTrty.addBottomRow(trty);
				newlyAdded = true;
				rowIndex = tbgNonPropTrty.geniisysRows.length - 1;
			} else {
				tbgNonPropTrty.updateVisibleRowOnly(trty, rowIndex, false);
			}
			changeTag = 1;
			tbgNonPropTrty.selectRow(rowIndex);
			objCurrTrty = tbgNonPropTrty.geniisysRows[rowIndex];
			setFieldValues(objCurrTrty);
			//populateTotal();
			recomputeTable();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		if(checkAllRequiredFieldsInDiv("nonPropTrtyFormDiv")){
			if($F("btnAdd") == "Add") {
				var addedSameExists = false;
				var deletedSameExists = false;	
				
				for ( var i = 0; i < tbgNonPropTrty.geniisysRows.length; i++) {
					if (tbgNonPropTrty.geniisysRows[i].recordStatus == 0 || tbgNonPropTrty.geniisysRows[i].recordStatus == 1) {
						if (tbgNonPropTrty.geniisysRows[i].layerNo == parseInt($F("txtLayerNo"))) {
							addedSameExists = true;
						}
					} else if (tbgNonPropTrty.geniisysRows[i].recordStatus == -1) {
						if (tbgNonPropTrty.geniisysRows[i].layerNo == parseInt($F("txtLayerNo"))) {
							deletedSameExists = true;
						}
					}
				}
				if ((addedSameExists && !deletedSameExists)|| (deletedSameExists && addedSameExists)) {
					showMessageBox("Record already exists with the same layer_no.", "E");
					return;
				} else if (deletedSameExists && !addedSameExists) {
					addRec();
					return;
				}
				new Ajax.Request(contextPath + "/GIISTrtyPanelController", {
					parameters : {
						action : "valAddNpRec",
						xolId : params.xolId,
						layerNo : $F("txtLayerNo")
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
	}

	function deleteRec() {
		changeTagFunc = saveGiiss031;
		objCurrTrty.recordStatus = -1;
		tbgNonPropTrty.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
		newlyAdded = false;
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

	disableButton("btnDelete");
	
	$("btnSave").observe("click", saveGiiss031);
	$("btnCancel").observe("click", cancelGiiss031);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteParentRec);
	$("btnExit").stopObserving("click");
	$("btnExit").observe("click", function() {
		fireEvent($("btnCancel"), "click");
	});
	$("txtLayerNo").focus();
	
	function showNonProportionalTreatyInfo(){
		try{
			new Ajax.Request(contextPath + "/GIISDistributionShareController", {
				method: "POST",
				parameters : {
					action : "showNonProportionalTreatyInfo",
					xolId: objUW.hideGIIS060.xolId
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
			showErrorMessage("showNonProportionalTreatyInfo",e);
		}
	}
	
	observeBackSpaceOnDate("txtTermFrom");
	observeBackSpaceOnDate("txtTermTo");
	
	var objCurrNpTrty = null;
	var rowNpIndex = -1;
	
	var trtyTable = {
			url : contextPath + "/GIISTrtyPanelController?action=showGiiss031Np&refresh=1",
			options : {
				width : '650px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowNpIndex = y;
					objCurrNpTrty = tbgTreaty.geniisysRows[y];
					setTrtyFieldValues(objCurrNpTrty);
					tbgTreaty.keys.removeFocus(tbgTreaty.keys._nCurrentFocus, true);
					tbgTreaty.keys.releaseKeys();
					$("txtTrtyShareAmt").focus();
				},
				onRemoveRowFocus : function(){
					rowNpIndex = -1;
					setTrtyFieldValues(null);
					tbgTreaty.keys.removeFocus(tbgTreaty.keys._nCurrentFocus, true);
					tbgTreaty.keys.releaseKeys();
					$("txtReinsurer").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowNpIndex = -1;
						setTrtyFieldValues(null);
						tbgTreaty.keys.removeFocus(tbgTreaty.keys._nCurrentFocus, true);
						tbgTreaty.keys.releaseKeys();
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
					rowNpIndex = -1;
					setTrtyFieldValues(null);
					tbgTreaty.keys.removeFocus(tbgTreaty.keys._nCurrentFocus, true);
					tbgTreaty.keys.releaseKeys();
				},
				onRefresh: function(){
					rowNpIndex = -1;
					setTrtyFieldValues(null);
					tbgTreaty.keys.removeFocus(tbgTreaty.keys._nCurrentFocus, true);
					tbgTreaty.keys.releaseKeys();
				},				
				prePager: function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
					rowNpIndex = -1;
					setTrtyFieldValues(null);
					tbgTreaty.keys.removeFocus(tbgTreaty.keys._nCurrentFocus, true);
					tbgTreaty.keys.releaseKeys();
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
					width : '95px'
				},
				{
					id : 'prntRiName',
					filterOption : true,
					title : 'Parent RI',
					width : '115px'				
				},
				{
					id : 'riCommRt',
					title : "RI Comm %",
					filterOption : true,
					width : '100px',
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
					width : '100px',
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
					width : '100px',
					align: 'right',
					titleAlign: 'right',
					renderer : function(value){
						return formatCurrency(value);
					},
					filterOption: true,
					filterOptionType: 'numberNoNegative',
					geniisysClass: 'money'
				}
			],
			rows : []
		};

		tbgTreaty = new MyTableGrid(trtyTable);
		tbgTreaty.render("trtyTable");
		
		function setTrtyFieldValues(rec){
			try{
				$("txtReinsurer").value = 		(rec == null ? "" : unescapeHTML2(rec.riSname));
				$("txtReinsurer").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.riSname)));
				$("txtRiComm").value = 		(rec == null ? "" : formatToNthDecimal(rec.riCommRt,9));
				$("txtPrntRi").value = 		(rec == null ? "" : unescapeHTML2(rec.prntRiName));
				$("txtFundsHeld").value = 			(rec == null ? "" : formatToNthDecimal(rec.fundsHeldPct,9));
				$("txtTrtySharePct").value = 		(rec == null ? "" : formatToNthDecimal(rec.trtyShrPct,9));
				$("txtTrtyShareAmt").value = 		(rec == null ? "" : formatToNthDecimal(rec.trtyShrAmt,2));
				$("txtUserId").value = 			(rec == null ? "" : unescapeHTML2(rec.userId));
				$("txtLastUpdate").value = 		(rec == null ? "" : dateFormat(rec.lastUpdate, 'mm-dd-yyyy hh:MM:ss TT'));
				$("txtRemarks").value = 		(rec == null ? "" : unescapeHTML2(rec.remarks));
				$("txtRiType").value = 		(rec == null ? "" : unescapeHTML2(rec.riTypeDesc));
				$("txtRiBase").value = 		(rec == null ? "" : unescapeHTML2(rec.riBase));
				objGIISS031.trtyShrPct = (rec == null ? "" : rec.trtyShrPct);
				objGIISS031.trtyShrAmt = (rec == null ? "" : rec.trtyShrAmt);
				objGIISS031.riCd = (rec == null? "" : rec.riCd);
				objGIISS031.prntRiCd = (rec == null? "" : rec.prntRiCd);
				rec == null ? $("btnAdd2").value = "Add" : $("btnAdd2").value = "Update";
				parseFloat($F("txtTotShrPct")) == 100  && rec == null ? disableButton("btnAdd2") : enableButton("btnAdd2");
				rec == null ? ($F("txtLayerNo") == "" ?  $("txtReinsurer").readOnly = true : $("txtReinsurer").readOnly = false) : $("txtReinsurer").readOnly = true;
				rec == null ? disableButton("btnDelete2") : enableButton("btnDelete2");
				rec == null && objTrtyPanel.curr ? enableSearch("searchReinsurer") : disableSearch("searchReinsurer");
				rec == null ? disableButton("btnAdd2") : enableButton("btnAdd2");
				checkLimit(objCurrNpTrty);
				objCurrNpTrty = rec;
			} catch(e){
				showErrorMessage("setTrtyFieldValues", e);
			}
		}
		
		function checkLimit(rec){
			if (rec == null){
				if(parseFloat($F("txtTotShrPct")) == 100){
					disableButton("btnAdd2");
				} 
			}
		}
		
		function setTrtyRec(rec){
			try {
				var obj = (rec == null ? {} : rec);
				obj.lineCd = escapeHTML2(params.lineCd);
				obj.trtySeqNo = objCurrTrty.shareCd;
				obj.trtyYy = params.xolYy;
				obj.riCd = objGIISS031.riCd;
				obj.prntRiCd = objGIISS031.prntRiCd;
				obj.riSname = escapeHTML2($F("txtReinsurer"));
				obj.prntRiName = escapeHTML2($F("txtPrntRi"));
				obj.riCommRt = $F("txtRiComm").replace(/,/g, "");
				obj.fundsHeldPct = $F("txtFundsHeld").replace(/,/g, "");
				obj.trtyShrPct = $F("txtTrtySharePct").replace(/,/g, "");
				obj.trtyShrAmt = $F("txtTrtyShareAmt").replace(/,/g, "");
				obj.remarks = escapeHTML2($F("txtRemarks"));
				obj.userId = userId;
				obj.riTypeDesc = escapeHTML2($F("txtRiType"));
				obj.riBase = escapeHTML2($F("txtRiBase"));
				var lastUpdate = new Date();
				obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
				
				return obj;
			} catch(e){
				showErrorMessage("setTrtyRec", e);
			}
		}
		
		function addTrtyRec(){
			try {
				childChangeTag = true;
				changeTagFunc = saveGiiss031;
				var dept = setTrtyRec(objCurrNpTrty);
				if($F("btnAdd2") == "Add"){
					tbgTreaty.addBottomRow(dept);
				} else {
					tbgTreaty.updateVisibleRowOnly(dept,rowNpIndex, false);
				}
				changeTag = 1;
				setTrtyFieldValues(null);
				tbgTreaty.keys.removeFocus(tbgTreaty.keys._nCurrentFocus, true);
				tbgTreaty.keys.releaseKeys(); 
				populateTotal();
			} catch(e){
				showErrorMessage("addTrtyRec", e);
			}
		}	
		
		function deleteTrtyRec() {
			childChangeTag = true;
			changeTagFunc = saveGiiss031;
			objCurrNpTrty.recordStatus = -1;
			tbgTreaty.deleteRow(rowNpIndex);
			changeTag = 1;
			setTrtyFieldValues(null);
			populateTotal();
		}
		
		$("btnAdd2").observe("click", valAddTrtyRec);
		$("btnDelete2").observe("click", valDeleteTrtyRec);
		
		$("editRemarks").observe("click",function() {
			showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
		});
		
		$("editRemarksMain").observe("click",function() {
			showOverlayEditor("txtRemarksMain", 4000, $("txtRemarksMain").hasAttribute("readonly"));
		});
	
		function valAddTrtyRec(){
			try{
				if(checkAllRequiredFieldsInDiv("trtyPanelFormDiv")){
					if($F("btnAdd2") == "Add") {
						var addedSameExists = false;
						var deletedSameExists = false;	
						
						for ( var i = 0; i < tbgTreaty.geniisysRows.length; i++) {
							if (tbgTreaty.geniisysRows[i].recordStatus == 0 || tbgTreaty.geniisysRows[i].recordStatus == 1) {
								if (tbgTreaty.geniisysRows[i].riCd == objGIISS031.riCd) {
									addedSameExists = true;
								}
							} else if (tbgTreaty.geniisysRows[i].recordStatus == -1) {
								if (tbgTreaty.geniisysRows[i].riCd == objGIISS031.riCd) {
									deletedSameExists = true;
								}
							}
						}
						if ((addedSameExists && !deletedSameExists)|| (deletedSameExists && addedSameExists)) {
							showMessageBox("Record already exists with the same ri_cd.", "E");
							return;
						} else if (deletedSameExists && !addedSameExists) {
							addTrtyRec();
							return;
						}
						new Ajax.Request(contextPath + "/GIISTrtyPanelController", {
							parameters : {
								action : "valAddRec",
								riCd : objGIISS031.riCd,
								lineCd : params.lineCd,
								trtySeqNo: objCurrTrty.shareCd,
								trtyYy: params.xolYy
							},
							onCreate : showNotice("Processing, please wait..."),
							onComplete : function(response) {
								hideNotice();
								if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
									addTrtyRec();
								}
							}
						});
					} else {
						addTrtyRec();
					}
				}
			} catch (e) {
				showErrorMessage("valAddTrtyRec", e);
			}
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
					width: 470,
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
					draggable: true,
					filterText : nvl(escapeHTML2(x), "%"),
					onSelect: function(row) {
						if(row != undefined){
							validateRI = 0;
							$("txtReinsurer").value = unescapeHTML2(row.dspRiSname);
							objGIISS031.riCd = unescapeHTML2(row.riCd);
							$("txtRiBase").value = unescapeHTML2(row.dspLocalForeignSw);	
							$("txtRiType").value = unescapeHTML2(row.dspRiTypeDesc);
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
					draggable: true,
					filterText: nvl(escapeHTML2(x),"%"),
					onSelect: function(row) {
						if(row != undefined){
							validatePRI = 0;
							$("txtPrntRi").value = unescapeHTML2(row.riSname);
							$("txtPrntRi").setAttribute("lastValidValue", unescapeHTML2(row.riSname));
							objGIISS031.prntRiCd = unescapeHTML2(row.riCd);
						}
					},
					onCancel: function(){
						validatePRI = 0;
						$("txtPrntRi").focus();
						$("txtPrntRi").value = $("txtPrntRi").getAttribute("lastValidValue");
			  		},
			  		onUndefinedRow: function(){
			  			validatePRI = 0;
			  			customShowMessageBox("No record selected.", imgMessage.INFO, "txtPrntRi");
			  			$("txtPrntRi").value = $("txtPrntRi").getAttribute("lastValidValue");
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
		$("searchPrntRi").observe("click", function(){
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
					prntSname: $F("txtPrntRi")
				},
				onCreate: showNotice("Please wait..."),
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);
						if(nvl(obj.prntRiCd, "") == ""){
							showParentRiLOV($("txtPrntRi").value);
						} else if(obj.prntRiCd == "---"){
							showParentRiLOV($("txtPrntRi").value);
						} else {
							$("txtPrntRi").value = unescapeHTML2(obj.prntSname);
							$("txtPrntRi").setAttribute("lastValidValue", unescapeHTML2(obj.prntSname));
							objGIISS031.prntRiCd = obj.prntRiCd;
						}
					}
				}
			});
		}
		
		$("txtPrntRi").observe("change",function(){
			if($("txtPrntRi").value == ""){
				objGIISS031.prntRiCd  = "";
				$("txtPrntRi").setAttribute("lastValidValue", "");
			} else {
				validatePRI = 1;
				showParentRiLOV($("txtPrntRi").value);
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
		
		function setNpTrtyReadOnly(sw){
			if(sw){
				$("txtReinsurer").readOnly = true;
				$("txtPrntRi").readOnly = true;
				$("txtTrtySharePct").readOnly = true;
				$("txtTrtyShareAmt").readOnly = true;
				$("txtRiComm").readOnly = true;
				$("txtFundsHeld").readOnly = true;
				$("txtRemarks").readOnly = true;
				disableSearch("searchReinsurer");
				disableSearch("searchPrntRi");
				disableButton("btnAdd2");
			} else {
				$("txtReinsurer").readOnly = false;
				$("txtPrntRi").readOnly = false;
				$("txtTrtySharePct").readOnly = false;
				$("txtTrtyShareAmt").readOnly = false;
				$("txtRiComm").readOnly = false;
				$("txtFundsHeld").readOnly = false;
				$("txtRemarks").readOnly = false;
				enableSearch("searchReinsurer");
				enableSearch("searchPrntRi");
				enableButton("btnAdd2");
			}
		}
		
		$("txtAggregateSum").observe("change", function(){
			if(parseFloat($("txtAggregateSum").value.replace(/,/g, "")) <= parseFloat($("txtXolLimit").value.replace(/,/g, ""))){
				showMessageBox("Aggregate Sum should be greater than XOL Limit.", "I");
				$("txtAggregateSum").clear();
			}
			if($("txtAggregateSum").value != ""){
				if($("txtXolLimit").value == ""){
					showMessageBox("Please Enter XOL Allowed Amount first.", "I");
					$("txtXolLimit").focus();
					$("txtAggregateSum").clear();	
				} else {
					$("txtNoOfReinstatement").clear();					
				}
			}
		});
		
		$("txtNoOfReinstatement").observe("change", function(){
			if($("txtNoOfReinstatement").value != ""){
				$("txtAggregateSum").clear();
			}
		});
		
		$("txtTermFrom").observe("focus", function(){
			var effDate = $F("txtTermFrom") != "" ? new Date($F("txtTermFrom").replace(/-/g,"/")) :"";
			var expDate = $F("txtTermTo") != "" ? new Date($F("txtTermTo").replace(/-/g,"/")) :"";
			
			if (expDate <= effDate && expDate != "" && effDate !=""){
				customShowMessageBox("Effectivity Date should not be later than or equal to Expiry Date.", "I", "txtTermFrom");
				$("txtTermFrom").clear();
				return false;
			}
		});
		
		$("txtTermTo").observe("focus", function(){
			var effDate = $F("txtTermFrom") != "" ? new Date($F("txtTermFrom").replace(/-/g,"/")) :"";
			var expDate = $F("txtTermTo") != "" ? new Date($F("txtTermTo").replace(/-/g,"/")) :"";
			
			if (expDate <= effDate && expDate != "" && effDate !=""){
				customShowMessageBox("Effectivity Date should not be later than or equal to Expiry Date.", "I", "txtTermTo");
				$("txtTermTo").clear();
				return false;
			}
		});
		
		function valDeleteParentRec() {
			try {
				new Ajax.Request(contextPath + "/GIISDistributionShareController", {
					parameters  : {
						action  : "valDeleteParentRec",
						lineCd  : params.lineCd,
						shareCd : objGIISS031.shareCd,
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
		
		function populateTotal(){
			if(tbgTreaty.geniisysRows.length != 0){
				var trtyShrPctTotal = 0.00;
				var trtyShrAmtTotal = 0.00;
				for(var i = 0; tbgTreaty.geniisysRows.length > i; i++){
					valAmt = ((tbgTreaty.geniisysRows[i].trtyShrAmt != null && tbgTreaty.geniisysRows[i].recordStatus != -1) ? parseFloat(nvl(tbgTreaty.geniisysRows[i].trtyShrAmt.replace(/,/g, ""),0)) : 0);
					valPct = ((tbgTreaty.geniisysRows[i].trtyShrPct != null && tbgTreaty.geniisysRows[i].recordStatus != -1) ? parseFloat(nvl(tbgTreaty.geniisysRows[i].trtyShrPct.replace(/,/g, ""),0)) : 0);
					
					trtyShrPctTotal = parseFloat(trtyShrPctTotal) + parseFloat(valPct);
					trtyShrAmtTotal = parseFloat(trtyShrAmtTotal) + parseFloat(valAmt);
				}
				
				$("txtTotShrPct").value = isNaN(trtyShrPctTotal) || trtyShrPctTotal == 0 ? "" : formatToNthDecimal(parseFloat(trtyShrPctTotal),9);
				$("txtTotShrAmt").value = isNaN(trtyShrAmtTotal) || trtyShrAmtTotal == 0 ? "" : formatCurrency(parseFloat(trtyShrAmtTotal));
			} else {
				$("txtTotShrPct").value = "";
				$("txtTotShrAmt").value = "";
			}	
			
			if(parseFloat($F("txtTotShrPct")) == 100){
				disableButton("btnAdd2");
			} else if(parseFloat($F("txtTotShrPct")) != 100){
				enableButton("btnAdd2");
			}
		}
		
		trtyShrPctLVV = 0;
		trtyShrAmtLVV = 0;
		xolLimitLVV = 0;
		
		$("txtTrtySharePct").observe("focus", function(){
			trtyShrPctLVV = $("txtTrtySharePct").value;
			trtyShrAmtLVV = $("txtTrtyShareAmt").value;
		});
		
		$("txtTrtyShareAmt").observe("focus", function(){
			trtyShrPctLVV = $("txtTrtySharePct").value;
			trtyShrAmtLVV = $("txtTrtyShareAmt").value;
		});
		
		$("txtTrtySharePct").observe("change", function(){
			if((parseFloat($("txtTrtySharePct").value) + (parseFloat($("txtTotShrPct").value) - nvl(objGIISS031.trtyShrPct,0))) > 100){
				customShowMessageBox("Total share percent should not exceed 100%.", imgMessage.ERROR, "txtTrtySharePct");
				$("txtTrtySharePct").value = formatToNthDecimal(trtyShrPctLVV,9);
				$("txtTrtyShareAmt").value = formatCurrency(trtyShrAmtLVV);
				return;
			}
			
			if($("txtTrtySharePct").value != "" && parseFloat($("txtTrtySharePct").value) <= 100){
				amtLimit = parseFloat(objTrtyPanel.amtLimit.replace(/,/g, ""));
				newValue = (parseFloat($F("txtTrtySharePct")) / 100) * parseFloat(amtLimit);
				
				$("txtTrtyShareAmt").value = formatCurrency(newValue);
			} else {
				$("txtTrtyShareAmt").value = formatCurrency(trtyShrAmtLVV);
			}
		});
		
		$("txtTrtyShareAmt").observe("change", function(){
			if((parseFloat($F("txtTrtyShareAmt").replace(/,/g, "")) > parseFloat($F("txtXolLimit").replace(/,/g, "")))){
				customShowMessageBox("Share amount should not exceed Treaty Limit "+formatCurrency($F("txtXolLimit"))+".", imgMessage.ERROR, "txtTrtyShareAmt");
				$("txtTrtySharePct").value = formatToNthDecimal(trtyShrPctLVV,9);
				$("txtTrtyShareAmt").value = formatCurrency(trtyShrAmtLVV);
				return;
			}
			
			if((parseFloat($F("txtTrtyShareAmt").replace(/,/g, "")) + (parseFloat($F("txtTotShrAmt").replace(/,/g, "")) - nvl(objGIISS031.trtyShrAmt,0))) >  parseFloat(objTrtyPanel.amtLimit.replace(/,/g, ""))){
				customShowMessageBox("Share amount should not exceed Treaty Limit "+formatCurrency(objTrtyPanel.amtLimit)+".", imgMessage.ERROR, "txtTrtyShareAmt");
				$("txtTrtySharePct").value = formatToNthDecimal(trtyShrPctLVV,9);
				$("txtTrtyShareAmt").value = formatCurrency(trtyShrAmtLVV);
			}

			if($("txtTrtyShareAmt").value != ""){
				amtLimit = parseFloat(objTrtyPanel.amtLimit.replace(/,/g, ""));
				newValue = (parseFloat($F("txtTrtyShareAmt").replace(/,/g, "")) / parseFloat(amtLimit)) * 100 ;
				
				$("txtTrtySharePct").value = formatToNthDecimal(newValue,9);
			} else {
				$("txtTrtySharePct").value = "";
			}
		});
		
		$("txtXolLimit").observe("focus", function(){
			xolLimitLVV = $F("txtXolLimit").replace(/,/g, "");
		});
		
		$("txtXolLimit").observe("change", function(){
			if(parseFloat($("txtAggregateSum").value.replace(/,/g, "")) <= parseFloat($("txtXolLimit").value.replace(/,/g, ""))){
				showMessageBox("Aggregate Sum should be greater than XOL Limit.", "I");
				$("txtXolLimit").value = formatCurrency(xolLimitLVV);
			}
			if($F("txtXolLimit") == ""){
				customShowMessageBox("XOL Limit is required.", imgMessage.INFO, "txtXolLimit");
				$("txtXolLimit").value = formatCurrency(xolLimitLVV);
			}
			
			if(parseFloat($("txtXolLimit").value.replace(/,/g, "")) < parseFloat($("txtTotShrAmt").value.replace(/,/g, ""))){
				$("txtXolLimit").value = formatCurrency(xolLimitLVV);
				customShowMessageBox("XOL limit should not be less than the total of treaty share amount.", "I", "txtXolLimit");
			} 
			
			xolLimitLVV = $("txtXolLimit").value;
			
		});
		
		function recomputeTable(){
			newLimit = parseFloat($F("txtXolLimit").replace(/,/g, ""));
			
			for(var i = 0; tbgTreaty.geniisysRows.length > i; i++){
				obj = tbgTreaty.geniisysRows[i];
				newVal = (parseFloat(obj.trtyShrPct) / 100) * newLimit;
				obj.trtyShrPct = formatToNthDecimal(obj.trtyShrPct,9);
				obj.trtyShrAmt = (isNaN(newVal) ? "" : formatCurrency(newVal));
				
				tbgTreaty.updateVisibleRowOnly(obj, i, false);
			}
			
			populateTotal();
		}
		
		function valDeleteTrtyRec() {
			try {
				new Ajax.Request(contextPath + "/GIISTrtyPanelController", {
					parameters  : {
						action  : "valDeleteRec",
						lineCd  : params.lineCd,
						trtySeqNo : objCurrTrty.shareCd,
						trtyYy  : params.xolYy,
						riCd    : objGIISS031.riCd
					},
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
							deleteTrtyRec();
						}
					}
				});
			} catch (e) {
				showErrorMessage("valDeleteRec", e);
			}
		}
		
		objGiris007.shareType = null;
		objGiris007.lineCd = "";
		objGiris007.trtyYy = "";
		objGiris007.shareCd = "";
		objGiris007.layerNo = "";
		objGiris007.proportionalTreaty = "";
</script>