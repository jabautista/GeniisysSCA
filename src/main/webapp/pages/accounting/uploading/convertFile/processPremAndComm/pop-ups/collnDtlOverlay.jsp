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
		<div id="gucdTableGrid" style="margin: 5px; height: 160px;"></div>
		
		<fieldset class="sectionDiv" style="width:887px; margin:0 5px 10px 5px;">
			<legend style="font-weight: bold; font-size: 11px;">Totals</legend>
			<div id="totalsDiv" class="" style="padding:4px 8px 4px 5px">
				<table>
					<tr>
						<td class="rightAligned" style="width:150px; padding-right: 4px;">Local Currency Amount</td>
						<td class="leftAligned"><input type="text" id="txtTotAmount" style="width: 100px; text-align: right;" readonly="readonly"/></td>
						<td class="rightAligned" style="width:120px; padding-right: 4px;">Gross Amount</td>
						<td class="leftAligned"><input type="text" id="txtTotGrossAmt" style="width: 100px; text-align: right;" readonly="readonly"/></td>
						<td class="rightAligned" style="width:100px; padding-right: 4px;">Deduction / Commission</td>
						<td class="leftAligned"><input type="text" id="txtTotCommissionAmt" style="width: 100px; text-align: right;" readonly="readonly"/></td>
						<td class="rightAligned" style="width:120px; padding-right: 4px;">VAT Amount</td>
						<td class="leftAligned"><input type="text" id="txtTotVATAmt" style="width: 100px; text-align: right;" readonly="readonly"/></td>
					</tr>	
				</table>
			</div>
		</fieldset>
		
		<div id="collectionBreakdownBody" style="margin-top: 5px;">		
			<table width="100%" align="left" cellspacing="1" border="0" style="padding-right: 5px;">
				<tr hidden="hidden">
					<td></td>
					<td id="collnDtlDummyTD" colspan="5">
						<div>
							<input type="radio" id="rdoGross" name="rdoGrossTag" title="Gross" value="G" style="float: left; margin: 0 0 15px 13px;"/>
							<label for="rdoGross"> Gross</label>
							<input type="radio" id="rdoNet"  name="rdoGrossTag" title="Net" value="N" style="float: left; margin: 0 0 15px 30px;" />
							<label for="rdoNet"> Net</label>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width:120px; padding-right: 3px;">Payment Mode</td>
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
					<td class="rightAligned" style="width:120px; padding-right: 3px;">Local Currency Amount</td>
					<td class="leftAligned"><input id="amount" type="text" style="width: 150px;" class="required money dcbEvent" value="" /></td>
					<td class="rightAligned" style="width:120px; padding-right: 3px;">VAT Amount</td>
					<td class="leftAligned"><input id="vatAmt" type="text" style="width: 150px;" class="money dcbEvent" /></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width:120px; padding-right: 3px;">Bank</td>
					<td class="leftAligned">
						<div id="bankDiv" style="border: 1px solid gray; width: 175px; height: 21px; float: left;" class="withIconDiv">
							<input style="width: 145px; border: none; height: 13px; float: left;" id="nbtBankSname" name="nbtBankSname" type="text" class="withIcon" ignoreDelKey="1" maxLength="25"/>
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovBank" name="collnDtlLov" alt="Go" />
							<input type="hidden" id="bankCd" name="bankCd" value=""/>
						</div>
					</td>
					<td class="rightAligned" style="width:120px; padding-right: 3px;">Currency</td>
					<td class="leftAligned">
						<div id="currencyDiv" style="border: 1px solid gray; width: 157px; height: 21px; float: left;" class="withIconDiv"> 
							<input style="width: 127px; border: none; height: 13px; float: left;" id="nbtShortName" name="nbtShortName" type="text" class="withIcon" ignoreDelKey="1" maxLength="3"/>
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovCurrency" name="collnDtlLov" alt="Go" />
							<input type="hidden" id="currencyCd" name="currencyCd" value=""/>
						</div>
					</td>
					<td class="rightAligned" style="width:120px; padding-right: 3px;">FC Gross Amount</td>
					<td class="leftAligned"><input id="fcGrossAmt" type="text" style="width: 150px;" class="money" /></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width:120px; padding-right: 3px;">Check Class</td>
					<td class="leftAligned">
						<select id="checkClass" name="collnDtlSelect" style="width: 177px; margin-bottom: 0px;" class="list dcbEvent">
							<option value="">Select..</option>
								<c:forEach var="checkClassDetail" items="${checkClassDetails}">
									<option checkDesc="${checkClassDetail.rvMeaning}" value="${checkClassDetail.rvLowValue}">${checkClassDetail.rvMeaning}</option>
								</c:forEach>	
						</select>
					</td>
					<td class="rightAligned" style="width:120px; padding-right: 3px;">Currency Rate</td>
					<td class="leftAligned"><input id="currencyRt" type="text" style="width: 150px; text-align: right;"  value="" class="dcbEvent" readonly="readonly"/></td>
					<td class="rightAligned" style="width:120px; padding-right: 3px;">FC Comm Amount</td>
					<td class="leftAligned"><input id="fcCommAmt" type="text" style="width: 150px;" class="money dcbEvent" /></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width:120px; padding-right: 3px;">Check/Credit Card No.</td>
					<td class="leftAligned"><input id="checkNo" type="text" style="width: 170px;" /></td>
					<td class="rightAligned" style="width:120px; padding-right: 3px;">Gross Amount</td>
					<td class="leftAligned"><input id="grossAmt" type="text" style="width: 150px;" class="money" /></td> 
					<td class="rightAligned" style="width:120px; padding-right: 3px;">FC VAT Amount</td>
					<td class="leftAligned"><input id="fcVatAmt" type="text" style="width: 150px;" class="money dcbEvent" /></td>
				</tr>	
				<tr>
					<td class="rightAligned" style="width:120px; padding-right: 3px;">Check Date</td>
					<td class="leftAligned">
						<span id="checkDateBack" style="float: left; height: 22px; border: 1px solid gray;">
					    	<input style="width: 153px; border: none; height: 13px;" id="checkDate" name="checkDate" type="text" class="withIcon" ignoreDelKey="1"/>
					    	<img id="hrefCheckDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Check Date" style="padding-right: 1px;"/>
					    </span>
					</td>
					<td class="rightAligned" style="width:120px; padding-right: 3px;">Deduction / Commission</td>
					<td class="leftAligned"><input id="commissionAmt" type="text" style="width: 150px;" class="money dcbEvent"/></td>
					<td class="rightAligned" style="width:120px; padding-right: 3px;">FC Net Amount</td>
					<td class="leftAligned"><input id="nbtFcNetAmt" type="text" style="width: 150px;" class="money dcbEvent" readonly="readonly" /></td>
				</tr>			
				<tr>
					<td class="rightAligned" style="width:150px; padding-right: 3px;">DCB Bank Account</td>
					<td class="leftAligned" colspan="4">
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
				<tr>
					<td class="rightAligned" style="width:120px; padding-right: 3px;">Particulars</td>
					<td colspan=5 class="leftAligned" > 
						<div style="border: 1px solid gray; height: 20px; width: 755px; margin-top: 3px; background-color: transparent">
							<textarea id="particulars" style="width: 720px; border: none; height: 13px; float: left; resize:none;" class="list dcbEvent" maxlength="500" onkeyup="limitText(this,500)"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right; background-color: transparent; " alt="Edit" id="editParticulars" />
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
try{
	var objGUCDList = JSON.parse('${jsonGUCD}');
	
	var rowIndex = -1;
	var objGUCD = null;
	
	try{
		var gucdTableModel = {
				url : contextPath + "/GIACUploadingController?action=showGIACS607CollnDtlOverlay&refresh=1&sourceCd="+guf.sourceCd+"&fileNo="+guf.fileNo,
				options : {
					width : '891px',
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
						id : 'nbtBankSname',
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
						id : "amount",
						title : "Local Currency Amount",
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
						id : 'nbtShortName',
						title : 'Currency',
						width : '65px',
						filterOption : true
					},
					{
						id: 'nbtDcbBankName nbtDcbBankAcctNo',
						title:'DCB Bank Acct.',
						align: 'left',
						children: [
					    	   	    {	id: 'nbtDcbBankName',
								    	width: 145,
										title:'DCB Bank Name'
								    },
								    {	id: 'nbtDcbBankAcctNo',
								    	width: 125,
										title:'DCB Bank Acct No.'
								    }
					   	]
					},
					{
						id : "grossAmt",
						title : "Gross Amount",
						align : "right",
						titleAlign: "right",
						width : '115px',
						filterOptionType: 'number',
						filterOption : true,
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					},
					{
						id : "commissionAmt",
						title : "Deduction/Commission",
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
						id : "vatAmt",
						title : "VAT Amount",
						align : "right",
						titleAlign: "right",
						width : '115px',
						filterOptionType: 'number',
						filterOption : true,
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					}
				],
				rows : objGUCDList.rows
			};

			tbgGUCD = new MyTableGrid(gucdTableModel);
			tbgGUCD.pager = objGUCDList;
			tbgGUCD.render("gucdTableGrid");
			tbgGUCD.afterRender = function(){
				var row = tbgGUCD.geniisysRows.length > 0 ? tbgGUCD.geniisysRows[0] : [];

				$("txtTotAmount").value = formatCurrency(nvl(row.totAmount, 0));
				$("txtTotGrossAmt").value = formatCurrency(nvl(row.totGrossAmt, 0));
				$("txtTotCommissionAmt").value = formatCurrency(nvl(row.totCommAmt, 0));
				$("txtTotVATAmt").value = formatCurrency(nvl(row.totVATAmt, 0));
				$("nextItemNo").value = nvl(row.nextItemNo, 1);
				
				tbgGUCD.onRemoveRowFocus();
			};
			
	}catch(e){
		showErrorMessage("GUPC tablegrid error", e);
	}
	
	function initAll(){
		//guf.nbtOrTag == "I" ? $("collnDtlDummyTD").hide() : $("collnDtlDummyTD").show();
		guf.nbtGrossTag == "Y" ? $("rdoGross").checked = true : $("rdoNet").checked = true;
		
		if (guf.tranClass != "" && guf.tranClass != null){
			$$("div#collnDtlDiv input[type='text'], div#collnDtlDiv textarea").each(function (o) {
				$(o).readOnly = true;
			});
			
			$$("div#collnDtlDiv img[name='collnDtlLov']").each(function (o) {
				disableSearch($(o));
			});
			
			$$("div#collnDtlDiv select[name='collnDtlSelect']").each(function (o) {
				$(o).disabled = true;
			});
			
			$("rdoGross").disabled = true;
			$("rdoNet").disabled = true;
			disableDate("hrefCheckDate");

			disableButton("btnAdd");
			disableButton("btnSave");
		}else{
			$("nbtShortName").value = nvl(unescapeHTML2(parameters.dfltCurrencySname), "");
			$("nbtShortName").setAttribute("lastValidValue", $F("nbtShortName"));
			$("currencyRt").value = nvl(formatToNineDecimal(parameters.dfltCurrencyRt), "");
			$("currencyCd").value = parameters.dfltCurrencyCd;
			$("dcbBankCd").value = nvl(unescapeHTML2(parameters.dfltDcbBankCd), "");
			$("nbtDcbBankName").value = nvl(unescapeHTML2(parameters.dfltDcbBankName), "");
			$("nbtDcbBankName").setAttribute("lastValidValue", $F("nbtDcbBankName"));
			$("dcbBankAcctCd").value = nvl(unescapeHTML2(parameters.dfltDcbBankAcctCd), "");
			$("nbtDcbBankAcctNo").value = nvl(unescapeHTML2(parameters.dfltDcbBankAcctNo), "");
			$("nbtDcbBankAcctNo").setAttribute("lastValidValue", $F("nbtDcbBankAcctNo"));
			
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
			/*$("nbtShortName").readOnly = true;
			disableSearch("lovCurrency");*/
			$("particulars").readOnly = false;
			$("payMode").disabled = false;
		}

		disableButton("btnDelete");
		validatePayMode();
		initializeAllMoneyFields();
	}
	
	function setFieldValues(row){
		try{
			$("itemNo").value = (row != null) ? row.itemNo : $F("nextItemNo");
			$("payMode").value = (row != null) ? unescapeHTML2(row.payMode) : "";
			$("bankCd").value = (row != null) ? row.bankCd : "";
			$("nbtBankSname").value = (row != null) ? unescapeHTML2(row.nbtBankSname) : "";
			$("nbtBankSname").setAttribute("lastValidValue", unescapeHTML2($F("nbtBankSname")));
			$("checkClass").value = (row != null) ? unescapeHTML2(row.checkClass) : "";
			$("checkNo").value = (row != null) ? unescapeHTML2(row.checkNo) : "";
			$("checkDate").value = (row != null) ? dateFormat(row.checkDate, "mm-dd-yyyy") : "";
			$("dcbBankCd").value = (row != null) ? row.dcbBankCd : "";
			$("nbtDcbBankName").value = (row != null) ? unescapeHTML2(row.nbtDcbBankName) : "";
			$("nbtDcbBankName").setAttribute("lastValidValue", unescapeHTML2($F("nbtDcbBankName")));
			$("dcbBankAcctCd").value = (row != null) ? row.dcbBankAcctCd : "";
			$("nbtDcbBankAcctNo").value = (row != null) ? unescapeHTML2(row.nbtDcbBankAcctNo) : "";
			$("nbtDcbBankAcctNo").setAttribute("lastValidValue", unescapeHTML2($F("nbtDcbBankAcctNo")));
	
			$("amount").value = (row != null) ? formatCurrency(row.amount) : formatCurrency(0);
			$("nbtShortName").value = (row != null) ? unescapeHTML2(row.nbtShortName) : "";
			$("nbtShortName").setAttribute("lastValidValue", unescapeHTML2($F("nbtShortName")));
			$("currencyCd").value = (row != null) ? row.currencyCd : "";
			$("currencyRt").value = (row != null) ? formatToNineDecimal(row.currencyRt) : formatToNineDecimal(0);
			$("grossAmt").value = (row != null) ? formatCurrency(row.grossAmt) : formatCurrency(0);
			$("commissionAmt").value = (row != null) ? formatCurrency(row.commissionAmt) : formatCurrency(0);
	
			$("vatAmt").value = (row != null) ? formatCurrency(row.vatAmt) : formatCurrency(0);
			$("fcGrossAmt").value = (row != null) ? formatCurrency(row.fcGrossAmt) : formatCurrency(0);
			$("fcCommAmt").value = (row != null) ? formatCurrency(row.fcCommAmt) : formatCurrency(0);
			$("fcVatAmt").value = (row != null) ? formatCurrency(row.fcVatAmt) : formatCurrency(0);
			$("nbtFcNetAmt").value = (row != null) ? formatCurrency(row.nbtFcNetAmt) : formatCurrency(0);
	
			$("particulars").value = (row != null) ? unescapeHTML2(row.particulars) : "";
			
			if (row == null){
				disableButton("btnDelete");
				$("btnAdd").value = "Add";
				initAll();
			}else{
				if (guf.tranClass != "" && guf.tranClass != null){
					disableButton("btnDelete");
					
					//nieko Accounting Uploading
					$$("div#collnDtlDiv input[type='text']").each(function (o) {
						if ($(o).hasClassName("money")){
							$(o).readOnly = true;
						}
					});
					$("particulars").readOnly = true;
				}
				else {
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
						
						//computing amounts based on new currency rate
						$("grossAmt").value = formatCurrency(nvl(unformatCurrencyValue($F("fcGrossAmt")) * row.currencyRt,0));
						$("commissionAmt").value = formatCurrency(nvl(unformatCurrencyValue($F("fcCommAmt")) * row.currencyRt,0));
						$("vatAmt").value = formatCurrency(nvl(unformatCurrencyValue($F("fcVatAmt")) * row.currencyRt,0));
						  
						$("amount").value = formatCurrency(unformatCurrencyValue($F("grossAmt")) - unformatCurrencyValue($F("commissionAmt")) 
																- unformatCurrencyValue($F("vatAmt")));
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
			$("checkClass").removeClassName("required");
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
			$("checkClass").addClassName("required");
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
			$("checkClass").removeClassName("required");
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
			$("checkClass").removeClassName("required");
		}else{
			$("nbtBankSname").removeClassName("required");
			$("bankDiv").removeClassName("required");
			$("checkNo").removeClassName("required");
			$("checkDate").removeClassName("required");
			$("checkDateBack").removeClassName("required");
			$("checkClass").removeClassName("required");
		}		
	}
	
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
	
	function recomputeTotals(add, row){
		if (add){
			$("txtTotAmount").value = formatCurrency(parseFloat(unformatCurrencyValue($F("txtTotAmount"))) + nvl(row.amount, 0));
			$("txtTotGrossAmt").value = formatCurrency(parseFloat(unformatCurrencyValue($F("txtTotGrossAmt"))) + nvl(row.grossAmt, 0));
			$("txtTotCommissionAmt").value = formatCurrency(parseFloat(unformatCurrencyValue($F("txtTotCommissionAmt"))) + nvl(row.commissionAmt, 0));
			$("txtTotVATAmt").value = formatCurrency(parseFloat(unformatCurrencyValue($F("txtTotVATAmt"))) + nvl(row.vatAmt, 0));
		}else{
			$("txtTotAmount").value = formatCurrency(parseFloat(unformatCurrencyValue($F("txtTotAmount"))) - nvl(row.amount, 0));
			$("txtTotGrossAmt").value = formatCurrency(parseFloat(unformatCurrencyValue($F("txtTotGrossAmt"))) - nvl(row.grossAmt, 0));
			$("txtTotCommissionAmt").value = formatCurrency(parseFloat(unformatCurrencyValue($F("txtTotCommissionAmt"))) - nvl(row.commissionAmt, 0));
			$("txtTotVATAmt").value = formatCurrency(parseFloat(unformatCurrencyValue($F("txtTotVATAmt"))) - nvl(row.vatAmt, 0));
		}
	}
	
	function setRec(rec){
		try{
			var obj = (rec == null ? {} : rec);
			
			obj.sourceCd = guf.sourceCd;
			obj.fileNo = guf.fileNo;
			obj.itemNo = $F("itemNo");
			obj.payMode = $F("payMode");
			obj.bankCd = $F("bankCd");
			obj.nbtBankSname = escapeHTML2($F("nbtBankSname"));
			obj.checkClass = escapeHTML2($F("checkClass"));
			obj.checkNo = escapeHTML2($F("checkNo"));
			obj.checkDate = $F("checkDate");
			obj.dcbBankCd = $F("dcbBankCd");
			obj.nbtDcbBankName = escapeHTML2($F("nbtDcbBankName"));
			obj.dcbBankAcctCd = $F("dcbBankAcctCd");
			obj.nbtDcbBankAcctNo = escapeHTML2($F("nbtDcbBankAcctNo"));
			
			obj.amount = unformatCurrencyValue($F("amount"));
			obj.nbtShortName = escapeHTML2($F("nbtShortName"));
			obj.currencyCd = $F("currencyCd");
			obj.currencyRt = $F("currencyRt");
			obj.grossAmt = unformatCurrencyValue($F("grossAmt"));
			obj.commissionAmt = unformatCurrencyValue($F("commissionAmt"));

			obj.vatAmt = unformatCurrencyValue($F("vatAmt"));
			obj.fcGrossAmt = unformatCurrencyValue($F("fcGrossAmt"));
			obj.fcCommAmt = unformatCurrencyValue($F("fcCommAmt"));
			obj.fcVatAmt = unformatCurrencyValue($F("fcVatAmt"));
			obj.nbtFcNetAmt = unformatCurrencyValue($F("nbtFcNetAmt"));

			obj.particulars = escapeHTML2($F("particulars"));
			
			return obj;
		}catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			if (checkAllRequiredFieldsInDiv("collnDtlDiv")){
				if ($F("nbtDcbBankName") != "" && $F("nbtDcbBankAcctNo") == ""){
					customShowMessageBox("Please enter DCB bank account code.", "I", "nbtDcbBankAcctNo");
					return false;
				}
				if (nvl($F("amount"), 0) == 0){
					customShowMessageBox("Net amount cannot be zero.", "I", "amount");
					return false;
				}
				
				changeTagFunc = saveGiacs607CollnDtl;
				var gucd = setRec(objGUCD);
				
				if($F("btnAdd") == "Add"){
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
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function saveGiacs607CollnDtl(closeOverlay){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgGUCD.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgGUCD.geniisysRows);
		new Ajax.Request(contextPath+"/GIACUploadingController", {
			method: "POST",
			parameters : {action : "saveGIACS607CollnDtl",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(closeOverlay) {
							exitOverlay();
						} else {
							tbgGUCD._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	function exitOverlay(){
		var selGrossTag = $("rdoGross").checked ? "Y" : "N";
		
		if (guf.nbtGrossTag != selGrossTag){
			new Ajax.Request(contextPath+"/GIACUploadingController",{
				method: "POST",
				parameters: {
					action:		"updateGIACS607GrossTag",
					sourceCd:	guf.sourceCd,
					fileNo:		guf.fileNo,
					grossTag:	selGrossTag
				},
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						checkNetColln();
					}
				}
			});
		}else{
			checkNetColln();
		}		
	}
	
	function checkNetColln(){
		new Ajax.Request(contextPath+"/GIACUploadingController",{
			method: "POST",
			parameters: {
				action:		"checkNetCollnGIACS607",
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
	
	$("payMode").observe("change", function(){
		validatePayMode();
	});
	
	$("checkClass").observe("change", function(){
		if ($F("checkDate") != ""){
			validateCheckDate();
		}
	});
	
	$("hrefCheckDate").observe("click", function() {
		scwNextAction = validateCheckDate.runsAfterSCW(this, null);
		
		scwShow($("checkDate"),this, null);
	});
	
	$("lovBank").observe("click", function(){
		showBankCdLOV(true);
	});
	
	$("nbtBankSname").observe("change", function(){
		if (this.value != ""){
			showBankCdLOV(false);
		}else{
			$("nbtBankSname").setAttribute("lastValidValue", "");
			$("bankCd").clear();
		}
	});
	
	$("lovDcvBankName").observe("click", function(){
		showDcbBankCdLOV(true);
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
	
	$("lovDcbBankAcctNo").observe("click", function(){
		showDcbBankAcctCdLOV(true);
	});
	
	$("nbtDcbBankAcctNo").observe("change", function(){
		if (this.value != ""){
			showDcbBankAcctCdLOV(false);
		}else{
			$("nbtDcbBankAcctNo").setAttribute("lastValidValue", "");
			$("dcbBankAcctCd").clear();
		}
	});
	
	$("lovCurrency").observe("click", function(){
		showCurrencyCdLOV(true);
	});
	
	$("nbtShortName").observe("change", function(){
		if (this.value != ""){
			showCurrencyCdLOV(false);
		}else{
			$("nbtShortName").setAttribute("lastValidValue", "");
			$("currencyCd").clear();
			$("currencyRt").clear();
		}
	});
	
	$("amount").observe("focus", function(){
		this.setAttribute("lastValidValue", unformatCurrencyValue(this.value));
	});
	
	$("amount").observe("change", function(){
		var amt = nvl(unformatCurrencyValue(this.value),0);
		
		if (amt < 0){
			this.value = formatCurrency(this.readAttribute("lastValidValue"));
			customShowMessageBox("Invalid amount.", imgMessage.INFO, "amount");
		}else if (amt == 0){
			this.value = formatCurrency(this.readAttribute("lastValidValue"));
			customShowMessageBox("Net amount cannot be zero.", imgMessage.INFO, "amount");
		}else{
			this.setAttribute("lastValidValue", unformatCurrencyValue(this.value));
			
			var commissionAmt = nvl(unformatCurrencyValue($F("commissionAmt")),0);
			var vatAmt = nvl(unformatCurrencyValue($F("vatAmt")),0);
			$("grossAmt").value = formatCurrency(amt + commissionAmt + vatAmt);
			$("fcGrossAmt").value = formatCurrency((amt + commissionAmt + vatAmt) / nvl($F("currencyRt"),1));
			$("nbtFcNetAmt").value = formatCurrency(nvl(unformatCurrencyValue($F("fcGrossAmt")),0) 
									- nvl(unformatCurrencyValue($F("fcCommAmt")),0) 
									- nvl(unformatCurrencyValue($F("fcVatAmt")),0));
		}
	});

	$("grossAmt").observe("focus", function(){
		this.setAttribute("lastValidValue", unformatCurrencyValue(this.value));
	});
	
	$("grossAmt").observe("change", function(){
		var grossAmt = nvl(unformatCurrencyValue(this.value),0);
		var amt = nvl(unformatCurrencyValue($F("amount")),0);
		
		if (amt > 0 && grossAmt <= 0){
			this.value = formatCurrency(this.readAttribute("lastValidValue"));
			customShowMessageBox("Gross amount should be greater than zero.", imgMessage.INFO, "grossAmt");
		}else if (grossAmt < amt){
			this.value = formatCurrency(this.readAttribute("lastValidValue"));
			customShowMessageBox("Gross amount should be larger than net amount.", imgMessage.INFO, "grossAmt");
		}else{
			this.setAttribute("lastValidValue", unformatCurrencyValue(this.value));
			
			var commissionAmt = nvl(unformatCurrencyValue($F("commissionAmt")),0);
			var vatAmt = nvl(unformatCurrencyValue($F("vatAmt")),0);
			$("amount").value = formatCurrency(grossAmt - vatAmt - commissionAmt);
			$("fcGrossAmt").value = formatCurrency(grossAmt / nvl(parseFloat($F("currencyRt")),1));
			$("nbtFcNetAmt").value = formatCurrency(nvl(unformatCurrencyValue($F("fcGrossAmt")),0) 
										- nvl(unformatCurrencyValue($F("fcCommAmt")),0) 
										- nvl(unformatCurrencyValue($F("fcVatAmt")),0));
		}
	});

	$("commissionAmt").observe("focus", function(){
		this.setAttribute("lastValidValue", unformatCurrencyValue(this.value));
	});
		
	$("commissionAmt").observe("change", function(){
		var commissionAmt = nvl(unformatCurrencyValue(this.value),0);
		var grossAmt = nvl(unformatCurrencyValue($F("grossAmt")),0);
		
		if (commissionAmt < 0){
			this.value = formatCurrency(this.readAttribute("lastValidValue"));
			customShowMessageBox("Commission amount should be positive.", imgMessage.INFO, "commissionAmt");
		}else if (commissionAmt != 0 && commissionAmt > grossAmt){
			this.value = formatCurrency(this.readAttribute("lastValidValue"));
			customShowMessageBox("Commission amount should be smaller than gross amount.", imgMessage.INFO, "commissionAmt");
		}else{
			this.setAttribute("lastValidValue", unformatCurrencyValue(this.value));
			
			var vatAmt = nvl(unformatCurrencyValue($F("vatAmt")),0);
			$("amount").value = formatCurrency(grossAmt - commissionAmt - vatAmt);
			$("fcCommAmt").value = formatCurrency(commissionAmt / nvl(parseFloat($F("currencyRt")),1));
			$("nbtFcNetAmt").value = formatCurrency(nvl(unformatCurrencyValue($F("fcGrossAmt")),0) 
									- nvl(unformatCurrencyValue($F("fcCommAmt")),0) 
									- nvl(unformatCurrencyValue($F("fcVatAmt")),0));
		}
	});

	$("vatAmt").observe("focus", function(){
		this.setAttribute("lastValidValue", unformatCurrencyValue(this.value));
	});
		
	$("vatAmt").observe("change", function(){
		var vatAmt = nvl(unformatCurrencyValue(this.value),0);
		var commissionAmt = nvl(unformatCurrencyValue($F("commissionAmt")),0);
		
		if (vatAmt < 0){
			this.value = formatCurrency(this.readAttribute("lastValidValue"));
			customShowMessageBox("V.A.T. amount should be positive.", imgMessage.INFO, "vatAmt");
		}else if (vatAmt != 0 && vatAmt > commissionAmt){
			this.value = formatCurrency(this.readAttribute("lastValidValue"));
			customShowMessageBox("V.A.T. amount should be smaller than commission amount.", imgMessage.INFO, "vatAmt");
		}else{
			var commissionAmt = nvl(unformatCurrencyValue($F("commissionAmt")),0);
			var grossAmt = nvl(unformatCurrencyValue($F("grossAmt")),0);
			
			var varGucdAmt = grossAmt - commissionAmt - vatAmt;
			
			if (varGucdAmt < 0){
				this.value = formatCurrency(this.readAttribute("lastValidValue"));
				customShowMessageBox("Net amount should not be negative.", imgMessage.INFO, "vatAmt");
			}else{
				this.setAttribute("lastValidValue", unformatCurrencyValue(this.value));
				
				$("amount").value = formatCurrency(grossAmt - commissionAmt - vatAmt);
				$("fcVatAmt").value = formatCurrency(vatAmt / nvl(parseFloat($F("currencyRt")),1));
				$("nbtFcNetAmt").value = formatCurrency(nvl(unformatCurrencyValue($F("fcGrossAmt")),0) 
											- nvl(unformatCurrencyValue($F("fcCommAmt")),0) 
											- nvl(unformatCurrencyValue($F("fcVatAmt")),0));
			}
		}
	});

	$("fcGrossAmt").observe("focus", function(){
		this.setAttribute("lastValidValue", unformatCurrencyValue(this.value));
	});
		
	$("fcGrossAmt").observe("change", function(){
		var grossAmt = nvl(unformatCurrencyValue($F("grossAmt")),0);
		var amount = nvl(unformatCurrencyValue($F("amount")),0);
		
		if (amount > 0 && grossAmt <= 0){
			this.value = formatCurrency(this.readAttribute("lastValidValue"));
			customShowMessageBox("Gross amount should be greater than zero.", imgMessage.INFO, "fcGrossAmt");
		}else if (grossAmt < amount){
			this.value = formatCurrency(this.readAttribute("lastValidValue"));
			customShowMessageBox("Gross amount should be larger than net amount.", imgMessage.INFO, "fcGrossAmt");
		}else{
			var commissionAmt = nvl(unformatCurrencyValue($F("commissionAmt")),0);
			var vatAmt = nvl(unformatCurrencyValue($F("vatAmt")),0);
		
			this.setAttribute("lastValidValue", unformatCurrencyValue(this.value));

			$("grossAmt").value = formatCurrency(nvl(unformatCurrencyValue(this.value),0) * nvl(parseFloat($F("currencyRt")),1));
			$("amount").value = formatCurrency(grossAmt - vatAmt - commissionAmt);
			$("nbtFcNetAmt").value = formatCurrency(nvl(unformatCurrencyValue($F("fcGrossAmt")),0) 
										- nvl(unformatCurrencyValue($F("fcCommAmt")),0) 
										- nvl(unformatCurrencyValue($F("fcVatAmt")),0));		
		}
	});

	$("fcCommAmt").observe("focus", function(){
		this.setAttribute("lastValidValue", unformatCurrencyValue(this.value));
	});
		
	$("fcCommAmt").observe("change", function(){
		var grossAmt = nvl(unformatCurrencyValue($F("grossAmt")),0);
		var amount = nvl(unformatCurrencyValue($F("amount")),0);
		
		if (amount > 0 && grossAmt <= 0){
			this.value = formatCurrency(this.readAttribute("lastValidValue"));
			customShowMessageBox("Gross amount should be greater than zero.", imgMessage.INFO, "fcGrossAmt");
		}else if (grossAmt < amount){
			this.value = formatCurrency(this.readAttribute("lastValidValue"));
			customShowMessageBox("Gross amount should be larger than net amount.", imgMessage.INFO, "fcGrossAmt");
		}else{
			var commissionAmt = nvl(unformatCurrencyValue($F("commissionAmt")),0);
			var vatAmt = nvl(unformatCurrencyValue($F("vatAmt")),0);
		
			this.setAttribute("lastValidValue", unformatCurrencyValue(this.value));

			$("commissionAmt").value = formatCurrency(nvl(unformatCurrencyValue(this.value),0) * nvl(parseFloat($F("currencyRt")),1));
			$("amount").value = formatCurrency(grossAmt - vatAmt - commissionAmt);
			$("nbtFcNetAmt").value = formatCurrency(nvl(unformatCurrencyValue($F("fcGrossAmt")),0) 
										- nvl(unformatCurrencyValue($F("fcCommAmt")),0) 
										- nvl(unformatCurrencyValue($F("fcVatAmt")),0));		
		}
	});

	$("fcVatAmt").observe("focus", function(){
		this.setAttribute("lastValidValue", unformatCurrencyValue(this.value));
	});
		
	$("fcVatAmt").observe("change", function(){
		var grossAmt = nvl(unformatCurrencyValue($F("grossAmt")),0);
		var amount = nvl(unformatCurrencyValue($F("amount")),0);
		
		if (amount > 0 && grossAmt <= 0){
			this.value = formatCurrency(this.readAttribute("lastValidValue"));
			customShowMessageBox("Gross amount should be greater than zero.", imgMessage.INFO, "fcGrossAmt");
		}else if (grossAmt < amount){
			this.value = formatCurrency(this.readAttribute("lastValidValue"));
			customShowMessageBox("Gross amount should be larger than net amount.", imgMessage.INFO, "fcGrossAmt");
		}else{
			var commissionAmt = nvl(unformatCurrencyValue($F("commissionAmt")),0);
			var vatAmt = nvl(unformatCurrencyValue($F("vatAmt")),0);
		
			this.setAttribute("lastValidValue", unformatCurrencyValue(this.value));

			$("vatAmt").value = formatCurrency(nvl(unformatCurrencyValue(this.value),0) * nvl(parseFloat($F("currencyRt")),1));
			$("amount").value = formatCurrency(grossAmt - vatAmt - commissionAmt);
			$("nbtFcNetAmt").value = formatCurrency(nvl(unformatCurrencyValue($F("fcGrossAmt")),0) 
										- nvl(unformatCurrencyValue($F("fcCommAmt")),0) 
										- nvl(unformatCurrencyValue($F("fcVatAmt")),0));		
		}
	});	

	$("nbtFcNetAmt").observe("focus", function(){
		this.setAttribute("lastValidValue", unformatCurrencyValue(this.value));
	});
		
	$("nbtFcNetAmt").observe("change", function(){
		var grossAmt = nvl(unformatCurrencyValue($F("grossAmt")),0);
		var amount = nvl(unformatCurrencyValue($F("amount")),0);
		
		if (amount > 0 && grossAmt <= 0){
			this.value = formatCurrency(this.readAttribute("lastValidValue"));
			customShowMessageBox("Gross amount should be greater than zero.", imgMessage.INFO, "fcGrossAmt");
		}else if (grossAmt < amount){
			this.value = formatCurrency(this.readAttribute("lastValidValue"));
			customShowMessageBox("Gross amount should be larger than net amount.", imgMessage.INFO, "fcGrossAmt");
		}else{
			var commissionAmt = nvl(unformatCurrencyValue($F("commissionAmt")),0);
			var vatAmt = nvl(unformatCurrencyValue($F("vatAmt")),0);
		
			this.setAttribute("lastValidValue", unformatCurrencyValue(this.value));

			$("amount").value = formatCurrency(grossAmt - vatAmt - commissionAmt);	
		}
	});
	
	$("editParticulars").observe("click", function(){
		showOverlayEditor("particulars", 500, $("particulars").hasAttribute("readonly"));
	});

	
	$("btnAdd").observe("click", addRec);
	
	$("btnDelete").observe("click", function(){
		changeTagFunc = saveGiacs607CollnDtl;
		objGUCD.recordStatus = -1;
		tbgGUCD.deleteRow(rowIndex);
		changeTag = 1;
		recomputeTotals(false, objGUCD);
		var next = parseInt($F("nextItemNo")) - 1;
		if (next > parseInt($F("nextItemNo"))){
			$("nextItemNo").value = next;
		}
		setFieldValues(null);	
	});
	
	observeSaveForm("btnSave", saveGiacs607CollnDtl);
	
	$("btnReturn").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveGiacs607CollnDtl(true);
					}, 
					exitOverlay, "");
		} else {
			exitOverlay();
		}
		
	});
	
	initAll();
}catch(e){
	showErrorMessage("Page Error", e);
}
</script>