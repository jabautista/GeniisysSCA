<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="collnDtlDiv" >
	<div class="sectionDiv" id="collnDtlDiv" changeTagAttr="true" style="margin-top: 3px; width: 898px;">
		<div id="gucdTableGrid" style="margin: 25px; height: 160px;" ></div>
		<div id="collectionBreakdownBody" style="margin-top: 5px; " align="center">		
			<table width="100%" cellspacing="1" border="0" style="padding-right: 5px;">
				<tr>
					<td class="rightAligned" style="width:150px; padding-right: 3px;">Payment Mode</td>
					<td class="leftAligned">
						<input type="hidden" id="nextItemNo" name="nextItemNo" value=""/>
						<input type="hidden" id="itemNo" name="itemNo" value=""/>
						<select id="payMode" name="collnDtlSelect" style="width: 177px; margin-bottom: 0px;" class="required list">
							<option value="">Select..</option>
							<!--<c:forEach var="payModeCode" items="${payModeCodes}">
								<option value="${payModeCode.rvLowValue}">${payModeCode.rvMeaning}</option>
							</c:forEach>-->
							<option value="CA">CA</option>
							<option value="CC">CC</option>
							<option value="CHK">CHK</option>
							<option value="CM">CM</option>
							<option value="CW">CW</option>
							<option value="WT">WT</option>
						</select>
					</td>
					<td class="rightAligned" style="width:150px; padding-right: 3px;">Bank</td>
					<td class="leftAligned">
						<div id="bankDiv" style="border: 1px solid gray; width: 175px; height: 21px; float: left;" class="withIconDiv">
							<input style="width: 145px; border: none; height: 13px; float: left;" id="nbtBankSname" name="nbtBankSname" type="text" class="withIcon" ignoreDelKey="1" maxLength="25"/>
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovBank" name="collnDtlLov" alt="Go" />
							<input type="hidden" id="bankCd" name="bankCd" value=""/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width:150px; padding-right: 3px;">Check Class</td>
					<td class="leftAligned">
						<select id="checkClass" name="collnDtlSelect" style="width: 177px; margin-bottom: 0px;" class="list dcbEvent">
							<option value="">Select..</option>
								<c:forEach var="checkClassDetail" items="${checkClassDetails}">
									<option checkDesc="${checkClassDetail.rvMeaning}" value="${checkClassDetail.rvLowValue}">${checkClassDetail.rvMeaning}</option>
								</c:forEach>	
						</select>
					</td>
					<td class="rightAligned" style="width:150px; padding-right: 3px;">Check/Credit Card No.</td>
					<td class="leftAligned"><input id="checkNo" type="text" style="width: 170px;" /></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width:150px; padding-right: 3px;">Check Date</td>
					<td class="leftAligned">
						<span id="checkDateBack" style="float: left; height: 22px; border: 1px solid gray;">
					    	<input style="width: 153px; border: none; height: 13px;" id="checkDate" name="checkDate" type="text" class="withIcon" ignoreDelKey="1"/>
					    	<img id="hrefCheckDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Check Date" style="padding-right: 1px;"/>
					    </span>
					</td>
					<td class="rightAligned" style="width:150px; padding-right: 3px;">Gross Amount</td>
					<td class="leftAligned"><input id="fcGrossAmt" type="text" style="width: 170px;" class="money" /></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width:150px; padding-right: 3px;">Currency</td>
					<td class="leftAligned">
						<div id="currencyDiv" style="border: 1px solid gray; width: 176px; height: 21px; float: left;" class="withIconDiv"> 
							<input style="width: 150px; border: none; height: 13px; float: left;" id="nbtShortName" name="nbtShortName" type="text" class="withIcon" ignoreDelKey="1" maxLength="3"/>
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovCurrency" name="collnDtlLov" alt="Go" />
							<input type="hidden" id="currencyCd" name="currencyCd" value=""/>
						</div>
					</td>
					<td class="rightAligned" style="width:120px; padding-right: 3px;">Currency Rate</td>
					<td class="leftAligned"><input id="currencyRt" type="text" style="width: 170px; text-align: right;"  value="" class="dcbEvent" readonly="readonly"/></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width:150px; padding-right: 3px;">Particulars</td>
					<td colspan=3 class="leftAligned" > 
						<div style="border: 1px solid gray; height: 20px; width: 623px; margin-top: 3px; background-color: transparent">
							<textarea id="particulars" style="width: 597px; border: none; height: 13px; float: left; resize:none;" class="list dcbEvent" maxlength="500" onkeyup="limitText(this,500)"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right; background-color: transparent; " alt="Edit" id="editParticulars" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width:150px; padding-right: 3px;">DCB Bank Account</td>
					<td class="leftAligned" colspan="3">
						<div id="dcbBankNameDiv" style="border: 1px solid gray; width: 228px; height: 21px; float: left;" class="withIconDiv">
							<input style="width: 198px; border: none; height: 13px; float: left;" id="nbtDcbBankName" name="nbtDcbBankName" type="text" class="withIcon" ignoreDelKey="1" maxLength="25"/>
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovDcvBankName" name="collnDtlLov" alt="Go" />
							<input type="hidden" id="dcbBankCd" name="dcbBankCd" value=""/>
						</div>
						<label style="padding: 3px 5px 0 5px;">/</label>
						<div id="dcbBankAcctDiv" style="border: 1px solid gray; width: 215px; height: 21px; float: left;" class="withIconDiv">
							<input style="width: 185px; border: none; height: 13px; float: left;" id="nbtDcbBankAcctNo" name="nbtDcbBankAcctNo" type="text" class="withIcon" ignoreDelKey="1" maxLength="25"/>
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovDcbBankAcctNo" name="collnDtlLov" alt="Go" />
							<input type="hidden" id="dcbBankAcctCd" name="dcbBankAcctCd" value=""/>
						</div>
					</td>
				</tr>
			</table>
		</div>
			
		<div class="buttonsDiv" style="margin: 10px 0 5px 0;">
			<input type="button" id="btnAdd" class="button" value="Add" style="width: 90px;" tabIndex = "116"/>
			<input type="button" id="btnDelete" class="button" value="Delete" style="width: 90px;" tabIndex = "116"/>
		</div>	
	</div>
	
	<div class="buttonsDiv" style="margin: 5px 0 0 0;">
		<input type="button" id="btnSave" class="button" value="Save" style="width: 90px;" tabIndex = "117"/>
		<input type="button" id="btnReturn" class="button" value="Return" style="width: 90px;" tabIndex = "118"/>
	</div>
</div>

<script type="text/javascript">
	var objGUCDList = JSON.parse('${jsonGUCD}');
	var rowIndex = -1;
	var objGUCD = null;
	validatePayMode();
	initializeAllMoneyFields();
	
	try{
		var gucdTableModel = {
				url : contextPath + "/GIACUploadingController?action=showGIACS608CollnDtlOverlay&refresh=1&sourceCd="+guf.sourceCd+"&fileNo="+guf.fileNo,
				options : {
					width : '841px',
					hideColumnChildTitle: true,
					pager : {},
					onCellFocus : function(element, value, x, y, id){
						rowIndex = y;
						objGUCD = tbgGUCD.geniisysRows[y];
						setFieldValues(objGUCD);
						tbgGUCD.keys.removeFocus(tbgGUCD.keys._nCurrentFocus, true);
						tbgGUCD.keys.releaseKeys();
					},
					onRemoveRowFocus : function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgGUCD.keys.removeFocus(tbgGUCD.keys._nCurrentFocus, true);
						tbgGUCD.keys.releaseKeys();
					},					
					toolbar : {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
						onFilter: function(){
							rowIndex = -1;
							setFieldValues(null);
							tbgGUCD.keys.removeFocus(tbgGUCD.keys._nCurrentFocus, true);
							tbgGUCD.keys.releaseKeys();
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
						tbgGUCD.keys.removeFocus(tbgGUCD.keys._nCurrentFocus, true);
						tbgGUCD.keys.releaseKeys();
					},
					onRefresh: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgGUCD.keys.removeFocus(tbgGUCD.keys._nCurrentFocus, true);
						tbgGUCD.keys.releaseKeys();
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
						tbgGUCD.keys.removeFocus(tbgGUCD.keys._nCurrentFocus, true);
						tbgGUCD.keys.releaseKeys();
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
						id : 'itemNo',
						title : 'Item No.',
						titleAlign: 'right',
						aling: 'right',
						width : '52px',
						filterOption : true,
						filterOptionType: 'integerNoNegative'
					},
					{
						id : 'payMode',
						title : 'Pay Mode',
						filterOption : true,
						width : '60px'				
					},
					{
						id : 'dspBank',
						title : 'Bank',
						width : '95px',
						filterOption : true			
					},
					{
						id : 'checkClass',
						title : 'Check Class',
						width : '80px',
						filterOption : true				
					},
					{
						id : 'checkNo',
						title : 'Check/Credit Card No.',
						width : '135px',
						filterOption : true				
					},
					{
						id : 'checkDate',
						title : 'Check Date',
						width : '75px',
						filterOption : true,
						filterOptionType: 'formattedDate',
						renderer : function(value) {
					    	return (value == "" || value == null) ? "" : dateFormat(value, "mm-dd-yyyy");
					    }
					},
					{
						id : "grossAmt",
						title : "Amount",
						align : "right",
						titleAlign: "right",
						width : '145px',
						filterOptionType: 'number',
						filterOption : true,
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					},
					{
						id : 'dspCurrency',
						title : 'Currency',
						width : '65px',
						filterOption : true
					},
					{
						id: 'dcbBankCd dcbBankAcctCd',
						title:'DCB Bank Acct.',
						align: 'left',
						children: [
					    	   	    {	id: 'dcbBankCd',
								    	width: 45,
										title:'DCB Bank Name'
								    },
								    {	id: 'dcbBankAcctCd',
								    	width: 45,
										title:'DCB Bank Acct No.'
								    }
					   	]
					}
				],
				rows : objGUCDList.rows
			};
	
			tbgGUCD = new MyTableGrid(gucdTableModel);
			tbgGUCD.pager = objGUCDList;
			tbgGUCD.render("gucdTableGrid");
			tbgGUCD.afterRender = function(){
				var row = tbgGUCD.geniisysRows.length > 0 ? tbgGUCD.geniisysRows[0] : [];
				$("nextItemNo").value = nvl(row.nextItemNo, 1);
				
				tbgGUCD.onRemoveRowFocus();
			}; 
			
	}catch(e){
		showErrorMessage("GUPC tablegrid error", e);
	}
	
	//nieko Accounting Uploading
	if (objGIACS608.fileStatus == "C" || objGIACS608.fileStatus != 1){
		disableButton("btnSave");
		disableButton("btnDelete");
		disableButton("btnAdd");
	}else{
		enableButton("btnSave");
		enableButton("btnDelete");
		enableButton("btnAdd");
	}
	//nieko end
	
	function setFieldValues(row){
		try{
			$("itemNo").value = (row != null) ? row.itemNo : $F("nextItemNo");
			$("payMode").value = (row != null) ? unescapeHTML2(row.payMode) : "";
			$("checkClass").value = (row != null) ? unescapeHTML2(row.checkClass) : "";
			$("checkDate").value = (row != null) ? dateFormat(row.checkDate, "mm-dd-yyyy") : "";
			$("fcGrossAmt").value = (row != null) ? row.fcGrossAmt : "";
			$("nbtShortName").value = (row != null) ? unescapeHTML2(row.dspCurrency) : "";
			$("nbtBankSname").value = (row != null) ? unescapeHTML2(row.dspBank) : "";
			$("checkNo").value = (row != null) ? unescapeHTML2(row.checkNo) : "";
			$("fcGrossAmt").value = (row != null) ? formatCurrency(row.grossAmt) : "";
			$("particulars").value = (row != null) ? unescapeHTML2(row.particulars) : "";
			$("nbtDcbBankName").value = (row != null) ? row.dspDcbBankName : "";
			$("nbtDcbBankAcctNo").value = (row != null) ? row.dspDcbBankAcctNo : "";
			$("currencyCd").value = (row != null) ? row.currencyCd : "";
			$("currencyRt").value = (row != null) ? formatToNineDecimal(row.currencyRt) : "";
			$("dcbBankCd").value = (row != null) ? row.dcbBankCd : "";
			$("dcbBankAcctCd").value = (row != null) ? row.dcbBankAcctCd : "";
			
			if (row == null){
				disableButton("btnDelete");
				$("btnAdd").value = "Add";
				initAll();
			}else{
				//nieko Accounting Uploading
				if (objGIACS608.fileStatus == "C" || objGIACS608.fileStatus != 1){
					disableButton("btnDelete");
					
					//nieko Accounting Uploading
					$$("div#collnDtlDiv input[type='text']").each(function (o) {
						if ($(o).hasClassName("money")){
							$(o).readOnly = true;
						}
					});
					$("particulars").readOnly = true;
				}else{
					enableButton("btnDelete");
					
					//nieko Accounting Uploading
					$$("div#collnDtlDiv input[type='text']").each(function (o) {
						if ($(o).hasClassName("money")){
							$(o).readOnly = false;
						}
					});
					$("particulars").readOnly = false;
				}
				
				$("btnAdd").value = "Update";
				validatePayMode();
				$("payMode").disabled = true;
				
				/*$$("div#collnDtlDiv input[type='text']").each(function (o) {
					if ($(o).hasClassName("money")){
						$(o).readOnly = true;
					}
				});*/
				//$("particulars").readOnly = true;
			}
			
			objGUCD = row;
		}catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	$("btnAdd").observe("click", addRec);
	
	function addRec(){
		try {
			if (checkAllRequiredFieldsInDiv("collnDtlDiv")){
				if ($F("nbtDcbBankName") != "" && $F("nbtDcbBankAcctNo") == ""){
					customShowMessageBox("Please enter DCB bank account code.", "I", "nbtDcbBankAcctNo");
					return false;
				}
				if (nvl($F("fcGrossAmt"), 0) == 0){
					customShowMessageBox("Amount cannot be zero.", "I", "fcGrossAmt");
					return false;
				}
				
				changeTagFunc = saveGiacs608CollnDtl;
				var gucd = setRec(objGUCD);
				
				if($F("btnAdd") == "Add"){
					tbgGUCD.addBottomRow(gucd);
					$("nextItemNo").value = parseInt($F("nextItemNo")) + 1;
				} else {
					tbgGUCD.updateVisibleRowOnly(gucd, rowIndex, false);
				}
				changeTag = 1;
				//recomputeTotals(true, gucd);
				setFieldValues(null);
				tbgGUCD.keys.removeFocus(tbgGUCD.keys._nCurrentFocus, true);
				tbgGUCD.keys.releaseKeys();
			}
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}
	
	function setRec(rec){
		try{
			var obj = (rec == null ? {} : rec);
			
			obj.sourceCd = guf.sourceCd;
			obj.fileNo = guf.fileNo;
			obj.itemNo = $F("itemNo");
			obj.payMode = $F("payMode");
			obj.grossAmt = unformatCurrencyValue($F("fcGrossAmt"));
			obj.checkClass = escapeHTML2($F("checkClass"));
			obj.checkDate = $F("checkDate");
			obj.checkNo = escapeHTML2($F("checkNo"));
			obj.particulars = escapeHTML2($F("particulars"));
			obj.bankCd = $F("bankCd");
			obj.currencyCd = $F("currencyCd");
			obj.currencyRt = $F("currencyRt");
			obj.dcbBankCd = $F("dcbBankCd");
			obj.dcbBankAcctCd = $F("dcbBankAcctCd");
			obj.dspCurrency = escapeHTML2($F("nbtShortName"));
			obj.dspDcbBankName = $F("nbtDcbBankName");
			obj.dspDcbBankAcctNo = $F("nbtDcbBankAcctNo");
			obj.dspBank = escapeHTML2($F("nbtBankSname"));
			 
			return obj;
		}catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	$("hrefCheckDate").observe("click", function() {
		scwNextAction = validateCheckDate.runsAfterSCW(this, null);
		
		scwShow($("checkDate"),this, null);
	});
	
	function validateCheckDate(){
		if ($F("payMode") == "CHK"){
			if ($F("checkDate") != ""){
				var orDate = Date.parse(guf.nbtOrDate);
				var checkDate = Date.parse($F("checkDate"));
				var staleDate = Date.parse(guf.nbtOrDate);
				var staleParam = $F("checkClass") == "M" ? parseInt(parameters.staleMgrChk) : parseInt(parameters.staleCheck);
				staleDate = new Date(staleDate.addMonths(staleParam*-1));
				
				if (checkDate > orDate){
					$("checkDate").clear();
					customShowMessageBox("This check is post-dated.", imgMessage.INFO, "checkDate");
					return;
				}
				
				if(checkDate <= staleDate) {
					$("checkDate").clear();
					customShowMessageBox("This is a stale check.", imgMessage.INFO, "checkDate");
					return;
				}
				
				var checkStDate = new Date(checkDate.addMonths(staleParam));
				var staleDaysNo = (checkStDate - orDate)/(1000*60*60*24);
				if(staleDaysNo <= parseInt(parameters.staleDays) && staleDaysNo != 0) {
					if(staleDaysNo == 1) {
						showMessageBox("This check will be stale tomorrow.", imgMessage.INFO);
						return false;
					}else {
						showMessageBox("This check will be stale within "+staleDaysNo+" days.", imgMessage.INFO);
						return false;
					}
				}
			}
		}
	} 
	
	$("lovDcvBankName").observe("click", function(){
		showDcbBankCdLOV(true);
	});
	
	function showDcbBankCdLOV(isIconClicked){
		try{
			var searchString = isIconClicked? "%" : ($F("nbtDcbBankName").trim() == "" ? "%" : $F("nbtDcbBankName"));	
			
			LOV.show({
				controller : "ACUploadingLOVController",
				urlParameters : {
					action : "getGIACS607CollnDcbBankLOV",
					searchString: searchString,
					page : 1
				},
				title : "List of DCB Banks",
				width : 380,
				height : 386,
				columnModel : [ 
					{
						id : "bankCd",
						title : "Bank Code",
						width : '90px',
						renderer: function(value){
							return unescapeHTML2(value);
						}
					}, 
					{
						id : "bankName",
						title : "Bank Name",
						width : '260px',
						renderer: function(value){
							return unescapeHTML2(value);
						}
					}
				],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("dcbBankCd").value = row.bankCd;
						$("nbtDcbBankName").value = unescapeHTML2(row.bankName);
						$("nbtDcbBankName").setAttribute("lastValidValue", unescapeHTML2(row.bankName));

						$("dcbBankAcctCd").clear();
						$("nbtDcbBankAcctNo").clear();
						$("nbtDcbBankAcctNo").readOnly = false;
						enableSearch("lovDcbBankAcctNo");
					}
				},
				onCancel: function(){
					$("nbtDcbBankName").focus();
					$("nbtDcbBankName").value = $("nbtDcbBankName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("nbtDcbBankName").value = $("nbtDcbBankName").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "nbtDcbBankName");
				} 
			});
		}catch(e){
			showErrorMessage("showDcbBankCdLOV", e);
		}
	}
	
	$("lovBank").observe("click", function(){
		showBankCdLOV(true);
	});
	
	function showBankCdLOV(isIconClicked){
		try{
			var searchString = isIconClicked? "%" : ($F("nbtBankSname").trim() == "" ? "%" : $F("nbtBankSname"));	
			
			LOV.show({
				controller : "ACUploadingLOVController",
				urlParameters : {
					action : "getGIACS607CollnBankLOV",
					searchString: searchString,
					page : 1
				},
				title : "List of Banks",
				width : 380,
				height : 386,
				columnModel : [ 
					{
						id : "bankSname",
						title : "Bank",
						width : '120px',
						renderer: function(value){
							return unescapeHTML2(value);
						}
					}, 
					{
						id : "bankName",
						title : "Bank Name",
						width : '230px',
						renderer: function(value){
							return unescapeHTML2(value);
						}
					}
				],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("bankCd").value = row.bankCd;
						$("nbtBankSname").value = unescapeHTML2(row.bankSname);
						$("nbtBankSname").setAttribute("lastValidValue", unescapeHTML2(row.bankSname));
					}
				},
				onCancel: function(){
					$("nbtBankSname").focus();
					$("nbtBankSname").value = $("nbtBankSname").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("nbtBankSname").value = $("nbtBankSname").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "nbtBankSname");
				} 
			});
		}catch(e){
			showErrorMessage("showBankCdLOV", e);
		}
	}
	
	$("lovDcbBankAcctNo").observe("click", function(){
		showDcbBankAcctCdLOV(true);
	});
	
	function showDcbBankAcctCdLOV(isIconClicked){
		try{
			var searchString = isIconClicked? "%" : ($F("nbtDcbBankAcctNo").trim() == "" ? "%" : $F("nbtDcbBankAcctNo"));	
			
			LOV.show({
				controller : "ACUploadingLOVController",
				urlParameters : {
					action : "getGIACS607CollnDcbBankAcctLOV",
					dcbBankCd:	$F("dcbBankCd"),
					searchString: searchString,
					page : 1
				},
				title : "List of DCB Banks",
				width : 380,
				height : 386,
				columnModel : [ 
					{
						id : "bankAcctCd",
						title : "Bank Acct Code",
						width : '100px',
						renderer: function(value){
							return unescapeHTML2(value);
						}
					}, 
					{
						id : "bankAcctNo",
						title : "Acct No.",
						width : '250px',
						renderer: function(value){
							return unescapeHTML2(value);
						}
					}
				],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("dcbBankAcctCd").value = row.bankAcctCd;
						$("nbtDcbBankAcctNo").value = unescapeHTML2(row.bankAcctNo);
						$("nbtDcbBankAcctNo").setAttribute("lastValidValue", unescapeHTML2(row.bankAcctNo));
					}
				},
				onCancel: function(){
					$("nbtDcbBankAcctNo").focus();
					$("nbtDcbBankAcctNo").value = $("nbtDcbBankAcctNo").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("nbtDcbBankAcctNo").value = $("nbtDcbBankAcctNo").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "nbtDcbBankAcctNo");
				} 
			});
		}catch(e){
			showErrorMessage("showDcbBankAcctCdLOV", e);
		}
	}
	
	$("btnReturn").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveGiacs608CollnDtl(true);
					}, 
					exitOverlay, "");
		} else {
			exitOverlay();
		}
	});
	
	function exitOverlay(){
		checkNetColln()	;
	}
	
	function checkNetColln(){
		new Ajax.Request(contextPath+"/GIACUploadingController",{
			method: "POST",
			parameters: {
				action:		"checkNetCollnGIACS608",
				sourceCd:	guf.sourceCd,
				fileNo:		guf.fileNo
			},
			onComplete: function(response){
				if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, overlayCollnDtl.close())){
					overlayCollnDtl.close();
					changeTag = 0;	
				}
			}
		});	
	}
	
	$("lovCurrency").observe("click", function(){
		showCurrencyCdLOV(true);
	});
	
	function showCurrencyCdLOV(isIconClicked){
		try{
			var searchString = isIconClicked? "%" : ($F("nbtShortName").trim() == "" ? "%" : $F("nbtShortName"));	
			
			LOV.show({
				controller : "ACUploadingLOVController",
				urlParameters : {
					action : "getGIACS607CurrencyCdLOV",
					searchString: searchString,
					page : 1
				},
				title : "List of Currency Codes",
				width : 430,
				height : 386,
				columnModel : [ 
					{
						id : "shortName",
						title : "Currency Sname",
						width : '100px',
						renderer: function(value){
							return unescapeHTML2(value);
						}
					}, 
					{
						id : "currencyDesc",
						title : "Description",
						width : '200px',
						renderer: function(value){
							return unescapeHTML2(value);
						}
					}, 
					{
						id : "currencyRt",
						title : "Conversion Rate",
						titleAlign: 'right',
						align: 'right',
						width : '100px',
						renderer: function(value){
							return formatToNineDecimal(value);
						}
					}
				],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("currencyCd").value = row.mainCurrencyCd;
						$("nbtShortName").value = unescapeHTML2(row.shortName);
						$("nbtShortName").setAttribute("lastValidValue", unescapeHTML2(row.shortName));
						$("currencyRt").value = formatToNineDecimal(row.currencyRt);
					}
				},
				onCancel: function(){
					$("nbtShortName").focus();
					$("nbtShortName").value = $("nbtShortName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("nbtShortName").value = $("nbtShortName").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "nbtShortName");
				} 
			});
		}catch(e){
			showErrorMessage("showCurrencyCdLOV", e);
		}
	} 
	
	$("payMode").observe("change", function(){
		validatePayMode();
	});
	
	function validatePayMode(){
		$("checkClass").disabled = true;
		
		if ($F("payMode") == "CA" || $F("payMode") == "CW"){
			$("bankCd").clear();
			$("nbtBankSname").clear();
			$("checkClass").clear();
			$("checkNo").clear();
			$("checkDate").clear();
			
			$("nbtBankSname").readOnly = true;
			disableSearch("lovBank");
			$("checkNo").readOnly = true;
			disableDate("hrefCheckDate");
			
			$("nbtBankSname").removeClassName("required");
			$("bankDiv").removeClassName("required");
			$("checkNo").removeClassName("required");
			$("checkDate").removeClassName("required");
			$("checkDateBack").removeClassName("required");
			
		}else if ($F("payMode") == "CHK"){
			$("checkClass").disabled = false;			
			$("nbtBankSname").readOnly = false;
			enableSearch("lovBank");
			$("checkNo").readOnly = false;
			enableDate("hrefCheckDate");
			
			$("nbtBankSname").addClassName("required");
			$("bankDiv").addClassName("required");
			$("checkNo").addClassName("required");
			$("checkDate").addClassName("required");
			$("checkDateBack").addClassName("required");
		}else if ($F("payMode") == "CM" || $F("payMode") == "WT"){
			$("checkClass").clear();
						
			$("nbtBankSname").readOnly = false;
			enableSearch("lovBank");
			$("checkNo").readOnly = false;
			enableDate("hrefCheckDate");
			
			$("nbtBankSname").addClassName("required");
			$("bankDiv").addClassName("required");
			
			$("checkNo").removeClassName("required");
			$("checkDate").removeClassName("required");
			
		}else if ($F("payMode") == "CC"){
			$("checkClass").clear();
			$("checkDate").clear();
						
			$("nbtBankSname").readOnly = false;
			enableSearch("lovBank");
			$("checkNo").readOnly = false;
			disableDate("hrefCheckDate");
			
			$("nbtBankSname").addClassName("required");
			$("bankDiv").addClassName("required");
			$("checkNo").addClassName("required");
			
			$("checkDate").removeClassName("required");
			$("checkDateBack").removeClassName("required");
		}else{
			$("nbtBankSname").removeClassName("required");
			$("bankDiv").removeClassName("required");
			$("checkNo").removeClassName("required");
			$("checkDate").removeClassName("required");
			$("checkDateBack").removeClassName("required");
		}		
	}
	
	function initAll(){
		//nieko Accounting Uploading, added checking if file is already uploaded
		if (objGIACS608.fileStatus == "C" || objGIACS608.fileStatus != 1){
		//if (guf.tranClass != "" && guf.tranClass != null){
			$$("div#collnDtlDiv input[type='text'], div#collnDtlDiv textarea").each(function (o) {
				$(o).readOnly = true;
			});
			
			$$("div#collnDtlDiv img[name='collnDtlLov']").each(function (o) {
				disableSearch($(o));
			});
			
			$$("div#collnDtlDiv select[name='collnDtlSelect']").each(function (o) {
				$(o).disabled = true;
			});
			
			disableDate("hrefCheckDate");

			disableButton("btnAdd");
			disableButton("btnSave");
		}else{
			$("nbtShortName").value = nvl(unescapeHTML2(parameters.dfltCurrencySname), "");
			$("nbtShortName").setAttribute("lastValidValue", $F("nbtShortName"));
			$("currencyRt").value = nvl(formatToNineDecimal(parameters.dfltCurrencyRt), "");
			$("dcbBankCd").value = nvl(unescapeHTML2(parameters.dfltDcbBankCd), "");
			$("nbtDcbBankName").value = nvl(unescapeHTML2(parameters.dfltDcbBankName), "");
			$("nbtDcbBankName").setAttribute("lastValidValue", $F("nbtDcbBankName"));
			$("dcbBankAcctCd").value = nvl(unescapeHTML2(parameters.dfltDcbBankAcctCd), "");
			$("nbtDcbBankAcctNo").value = nvl(unescapeHTML2(parameters.dfltDcbBankAcctNo), "");
			$("nbtDcbBankAcctNo").setAttribute("lastValidValue", $F("nbtDcbBankAcctNo"));
			
			$("currencyCd").value = nvl(unescapeHTML2(parameters.dfltCurrencyCd), ""); //nieko Accounting Uploading GIACS608
			
			if ($F("dcbBankCd") == ""){
				disableSearch("lovDcbBankAcctNo");
			}
			
			$$("div#collnDtlDiv input[type='text']").each(function (o) {
				if ($(o).hasClassName("money") && $(o).id != "nbtFcNetAmt"){
					$(o).clear();
					$(o).readOnly = false;
				}
			});
			disableDate("hrefCheckDate");
			$("nbtBankSname").readOnly = true;
			disableSearch("lovBank");
			$("checkClass").disabled = true;
			$("particulars").readOnly = false;
			$("payMode").disabled = false;
		
		}
		disableButton("btnDelete");
		validatePayMode();
		initializeAllMoneyFields();
	}
	
	function saveGiacs608CollnDtl(closeOverlay){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgGUCD.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgGUCD.geniisysRows);
		new Ajax.Request(contextPath+"/GIACUploadingController", {
			method: "POST",
			parameters : {action : "saveGIACS608CollnDtl",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(closeOverlay) {
							overlayCollnDtl.close();
						} else {
							tbgGUCD._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	$("btnDelete").observe("click", function(){
		changeTagFunc = saveGiacs608CollnDtl;
		objGUCD.recordStatus = -1;
		tbgGUCD.deleteRow(rowIndex);
		changeTag = 1;
		var next = parseInt($F("nextItemNo")) - 1;
		if (next > parseInt($F("nextItemNo"))){
			$("nextItemNo").value = next;
		}
		setFieldValues(null);	
	});
	
	observeSaveForm("btnSave", saveGiacs608CollnDtl);
	
	$("nbtShortName").observe("change", function(){
		if (this.value != ""){
			showCurrencyCdLOV(false);
		}else{
			$("nbtShortName").setAttribute("lastValidValue", "");
			$("currencyCd").clear();
			$("currencyRt").clear();
		}
	});
	
	$("nbtBankSname").observe("change", function(){
		if (this.value != ""){
			showBankCdLOV(false);
		}else{
			$("nbtBankSname").setAttribute("lastValidValue", "");
			$("bankCd").clear();
		}
	});
	
	$("nbtDcbBankName").observe("change", function(){
		if (this.value != ""){
			showDcbBankCdLOV(false);
		}else{
			$("nbtDcbBankName").setAttribute("lastValidValue", "");
			$("dcbBankCd").clear();
			$("dcbBankAcctCd").clear();
			$("nbtDcbBankAcctNo").clear();
			$("nbtDcbBankAcctNo").readOnly = true;
			disableSearch("lovDcbBankAcctNo");
		}
	});
	
	$("nbtDcbBankAcctNo").observe("change", function(){
		if (this.value != ""){
			showDcbBankAcctCdLOV(false);
		}else{
			$("nbtDcbBankAcctNo").setAttribute("lastValidValue", "");
			$("dcbBankAcctCd").clear();
		}
	});
	
	initAll();
</script>