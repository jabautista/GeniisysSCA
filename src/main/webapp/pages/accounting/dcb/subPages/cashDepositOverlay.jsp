<div id="cashDepositMainDiv" style="width: 99.5%; margin-top: 5px;">
	<div class="sectionDiv" style="height: 500px;">
		<div id="giacBankDepSlipsDiv"">
			<div id="giacBankDepSlipsTable" style="height: 150px; margin-left: 50px; margin-top: 10px;">
				GIAC BANK DEP SLIPS TABLE GRID
			</div>
			<div align="center" id="totalsDiv">
				<table style="margin-top: 0px; margin-left: 107px;">
					<tr>
						<td class="leftAligned">
							<input id="gbds2DspTotLoc" type="text" class="" style="width: 130px; text-align: right;" tabindex="" maxlength="" readonly="readonly">
						</td>
						<td class="leftAligned">
							<input id="gbds2DspTotFor" type="text" class="" style="width: 135px; text-align: right;" tabindex="" maxlength="" readonly="readonly">
						</td>
					</tr>
				</table>
			</div>
			<div align="center" id="gbds2FormDiv">
				<table cellspacing="2" border="0" style="margin: 10px auto;">
					<tr>
						<td class="rightAligned">Dep No</td>
						<td class="leftAligned" style="padding-left: 5px;">
							<input id="txtDepNo" type="text" class="" readonly="readonly" style="width: 200px; text-align: right;" tabindex="" maxlength="">
						</td>
						<td class="rightAligned" style="padding-left: 10px;">Validation Date</td>
						<td class="leftAligned" style="padding-left: 5px;">
							<span class="lovSpan" style="width: 206px; height: 22px; margin: 0px 0px 0 0; float: left;">
								<input id="txtValidationDt" type="text" class="" style="width: 180px; text-align: left; height: 13px; float: left; border: none;" tabindex="" maxlength="" readonly="readonly">
								<img src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" id="imgValidationDt" name="imgValidationDt" alt="Go" class="hover" style="float: right;">
							</span>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Currency</td>
						<td class="leftAligned" style="padding-left: 5px;">
							<span class="lovSpan" style="width: 206px; height: 22px; margin: 0px 0px 0 0; float: left;">
								<input id="txtCurrencyShortName" type="text" class="" style="width: 180px; text-align: left; height: 13px; float: left; border: none;" tabindex="" maxlength="3">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchCurrency" name="imgSearchCurrency" alt="Go" style="float: right;">
							</span>
						</td>
						<td class="rightAligned" style="padding-left: 10px;">Currency Rate</td>
						<td class="leftAligned" style="padding-left: 5px;">
							<input id="txtCurrencyRt" type="text" class="" readonly="readonly" style="width: 200px; text-align: right;" tabindex="" maxlength="">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Local Currency Amt</td>
						<td class="leftAligned" style="padding-left: 5px;">
							<input id="txtAmount" type="text" class="money2" maxlength="17" style="width: 200px; text-align: right;"">
						</td>
						<td class="rightAligned" style="padding-left: 10px;">Foreign Currency Amt</td>
						<td class="leftAligned" style="padding-left: 5px;">
							<input id="txtForeignCurrAmt" type="text" class="money2" maxlength="17" style="width: 200px; text-align: right;"">
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div align="center" style="margin: 10px;">
			<input type="button" class="button" id="btnAdd" value="Add" style="width: 100px;">
			<input type="button" class="button" id="btnDelete" value="Delete" style="width: 100px;">
		</div>
		<div id="giacCashDepDtlTable" style="height: 100px; margin-left: 50px; margin-top: 10px;">
			GIAC CASH DEP DTL TABLE GRID
		</div>
		<div align="center" id="remarksDiv">
			<table style="margin-top: 10px; margin-left: 0px;">
				<tr>
					<td width="" class="rightAligned">Remarks</td>
					<td class="leftAligned" colspan="3">
						<div id="remarksDiv" name="remarksDiv" style="float: left; width: 531px; border: 1px solid gray; height: 22px;">
							<textarea style="float: left; height: 16px; width: 500px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">User ID</td>
					<td class="leftAligned" style="width: 254px;"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly"></td>
					<td width="" class="rightAligned">Last Update</td>
					<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly"></td>
				</tr>
			</table>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnReturn" value="Return" style="width: 120px;">
	<input type="button" class="button" id="btnSave" value="Save" style="width: 120px;">
</div>
<input id="gaccTranId"   type="hidden"  value="${gaccTranId}"/>
<input id="itemNo"   type="hidden"  value="${itemNo}"/>
<input id="currencyCd"   type="hidden"/>
<script type="text/javascript">
	initializeAll();
	initializeAllMoneyFields();
	changeTag = 0;
	var _selectedGdbdIndex	   = '${selectedGdbdIndex}';
	var notEqualTag = 'N';
	var currentAmount;
	var currentForeignCurrAmount;
	var gbds2DspTotLocOrig;
	var gbds2DspTotForOrig;
	
	var objGbds2 = {};
	var objCurrGbds2 = null;
	objGbds2.Gbds2List = JSON.parse('${gbds2ListTableGrid}');
	var rowIndex = -1;
	
	var gbds2Table = {
		url : contextPath + "/GIACBankDepSlipsController?action=showCashDepositPage&refresh=1&gaccTranId=" + $F("gaccTranId") + "&itemNo=" + $F("itemNo"),
		options : {
			width : '690px',
			height : '150px',
			hideColumnChildTitle: true,
			pager : {},
			onCellFocus : function(element, value, x, y, id){
				rowIndex = y;
				objCurrGbds2 = tbgGbds2.geniisysRows[y];
				setFieldValues(objCurrGbds2);
				tbgGbds2.keys.removeFocus(tbgGbds2.keys._nCurrentFocus, true);
				tbgGbds2.keys.releaseKeys();
				$("txtValidationDt").focus();
			},
			onRemoveRowFocus : function(){
				rowIndex = -1;
				setFieldValues(null);
				tbgGbds2.keys.removeFocus(tbgGbds2.keys._nCurrentFocus, true);
				tbgGbds2.keys.releaseKeys();
			},
			toolbar : {
				elements: [/* MyTableGrid.REFRESH_BTN */],
				onFilter: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGbds2.keys.removeFocus(tbgGbds2.keys._nCurrentFocus, true);
					tbgGbds2.keys.releaseKeys();
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
				tbgGbds2.keys.removeFocus(tbgGbds2.keys._nCurrentFocus, true);
				tbgGbds2.keys.releaseKeys();
			},
			onRefresh: function(){
				rowIndex = -1;
				setFieldValues(null);
				tbgGbds2.keys.removeFocus(tbgGbds2.keys._nCurrentFocus, true);
				tbgGbds2.keys.releaseKeys();
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
				tbgGbds2.keys.removeFocus(tbgGbds2.keys._nCurrentFocus, true);
				tbgGbds2.keys.releaseKeys();
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
				id: 'depId',
				width: '0',
				visible: false
			},
			{	id: 'gaccTranId',
				width: '0px',
				visible: false
			},
			{	id: 'fundCd',
				width: '0px',
				visible: false
			},
			{	id: 'branchCd',
				width: '0px',
				visible: false
			},
			{	id: 'dcbYear',
				width: '0px',
				visible: false
			},
			{	id: 'checkClass',
				width: '0px',
				visible: false
			},
			{	id: 'dcbNo',
				width: '0px',
				visible: false
			},
			{	id: 'itemNo',
				width: '0px',
				visible: false
			},
			{	id: 'currencyCd',
				width: '0px',
				visible: false
			},
			{
				id: 'depNo',
				title: 'Dep No',
				width: '60px',
				align: 'center',
				titleAlign: 'center'
			},
			{
				id: 'validationDt',
				title: 'Validation Date',
				width: '100px',
				align: 'center',
				titleAlign: 'center',
				type: 'date',
				format: 'mm-dd-yyyy'
			},
			{
				id: 'currencyShortName',
				title: 'Currency',
				width: '80px',
				align: 'left',
				titleAlign: 'left',
			},
			{
				id: 'amount',
				title: 'Local Currency Amt',
				width: '130px',
				align: 'right',
				titleAlign: 'center',
				geniisysClass: 'money'
			},
			{
				id: 'foreignCurrAmt',
				title: 'Foreign Currency Amt',
				width: '140px',
				align: 'right',
				titleAlign: 'center',
				geniisysClass: 'money'
			},
			{
				id: 'currencyRt',
				title: 'Currency Rate',
				width: '130px',
				align: 'right',
				titleAlign: 'center',
				geniisysClass: 'integerNoNegativeUnformattedNoComma',
				renderer : function(value){
					return formatToNthDecimal(value, 9);
				}
			}
		],
		rows : objGbds2.Gbds2List.rows
	};
	tbgGbds2 = new MyTableGrid(gbds2Table);
	tbgGbds2.pager = objGbds2.Gbds2List;
	tbgGbds2.render("giacBankDepSlipsTable");
	tbgGbds2.afterRender = function(){
		tbgGbds2.keys.removeFocus(tbgGbds2.keys._nCurrentFocus, true);
		tbgGbds2.keys.releaseKeys();
		
		if(tbgGbds2.geniisysRows.length > 0){
			computeGbds2Total();
		}
	};
	
	function setFieldValues(rec){
		try{
			$("txtDepNo").value = (rec == null ? "" : rec.depNo);
			$("txtValidationDt").value = (rec == null ? "" : dateFormat(rec.validationDt, 'mm-dd-yyyy'));
			$("txtCurrencyShortName").value = (rec == null ? "" : rec.currencyShortName);
			$("txtCurrencyRt").value = (rec == null ? "" : formatToNthDecimal(rec.currencyRt, 9));
			$("txtAmount").value = (rec == null ? "" : formatCurrency(rec.amount));
			$("txtForeignCurrAmt").value = (rec == null ? "" : formatCurrency(rec.foreignCurrAmt));
			currentAmount = (rec == null ? 0 : rec.amount);
			currentForeignCurrAmount = (rec == null ? 0 : rec.foreignCurrAmt);
			
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrGbds2 = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function computeGbds2Total(){
		var totalGbds2LocalCurrAmt   = 0;
		var totalGbds2ForeignCurrAmt = 0;
		var allIsNull = true;
		var lIndex = tbgGbds2.getColumnIndex('amount');
		var fIndex = tbgGbds2.getColumnIndex('foreignCurrAmt');
		
		for (var i = 0; i < tbgGbds2.rows.length; i++) {
			totalGbds2LocalCurrAmt   = totalGbds2LocalCurrAmt   + parseFloat(tbgGbds2.rows[i][lIndex]);
			totalGbds2ForeignCurrAmt = totalGbds2ForeignCurrAmt + parseFloat(tbgGbds2.rows[i][fIndex]);

			if (!nvl(tbgGbds2.rows[i][lIndex], "").blank()) {
				allIsNull = false;
			}
		}
		
		if (allIsNull) {
			$("gbds2DspTotLoc").value = "";
		} else {
			$("gbds2DspTotLoc").value = formatCurrency(parseFloat(nvl(totalGbds2LocalCurrAmt, "0")));
		}
		
		$("gbds2DspTotFor").value = formatCurrency(parseFloat(nvl(totalGbds2ForeignCurrAmt, "0")));
		
		gbds2DspTotLocOrig = totalGbds2LocalCurrAmt;
		gbds2DspTotForOrig = totalGbds2ForeignCurrAmt;
	}
	
	var objGcdd = {};
	var objCurrGcdd = null;
	objGcdd.gcddList = JSON.parse('${gcddListTableGrid}');
	
	var gcddTable = {
			url : contextPath + "/GIACBankDepSlipsController?action=showCashDepositPage&refresh=1",
			options : {
				width : '690px',
				height : '100px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					objCurrGcdd = tbgGcdd.geniisysRows[y];
					setGcddFields(objCurrGcdd);
					tbgGcdd.keys.removeFocus(tbgGcdd.keys._nCurrentFocus, true);
					tbgGcdd.keys.releaseKeys();
				},
				onRemoveRowFocus : function(){
					
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
				{	id: 'gaccTranId',
					width: '0px',
					visible: false
				},
				{	id: 'fundCd',
					width: '0px',
					visible: false
				},
				{	id: 'branchCd',
					width: '0px',
					visible: false
				},
				{	id: 'dcbYear',
					width: '0px',
					visible: false
				},
				{	id: 'dcbNo',
					width: '0px',
					visible: false
				},
				{	id: 'itemNo',
					width: '0px',
					visible: false
				},
				{	id: 'currencyCd',
					width: '0px',
					visible: false
				},
				{	id: 'remarks',
					width: '0px',
					visible: false
				},
				{
					id: 'bookTag',
					title: 'B',
					width: '20px',
					align: 'center',
					titleAlign: 'center',
					editor: new MyTableGrid.CellCheckbox({
				        getValueOf: function(value){
			            	if (value){
								return "Y";
			            	}else{
								return "N";	
			            	}	
		            	}
		            })
				},
				{
					id: 'amount',
					title: 'Collection Amt',
					width: '110px',
					align: 'right',
					titleAlign: 'right',
					geniisysClass: 'money'
				},
				{
					id: 'currencyShortName',
					title: 'Currency',
					width: '75px',
					align: 'left',
					titleAlign: 'left'
				},
				{
					id: 'foreignCurrAmt',
					title: 'Foreign Currency Amt',
					width: '140px',
					align: 'right',
					titleAlign: 'right',
					geniisysClass: 'money'
				},
				{
					id: 'currencyRt',
					title: 'Currency Rate',
					width: '100px',
					align: 'right',
					titleAlign: 'right',
					geniisysClass: 'integerNoNegativeUnformattedNoComma',
					renderer : function(value){
						return formatToNthDecimal(value, 9);
					}
				},
				{
					id: 'netDeposit',
					title: 'Deposited Amt',
					width: '100px',
					align: 'right',
					titleAlign: 'right',
					geniisysClass: 'money'
				},
				{
					id: 'shortOver',
					title: 'Cash Short/Over',
					width: '100px',
					align: 'right',
					titleAlign: 'right',
					geniisysClass: 'money'
				},
				{	id: 'userId',
					width: '0px',
					visible: false
				},
				{	id: 'lastUpdate',
					width: '0px',
					visible: false
				}
			],
			rows : objGcdd.gcddList.rows
	};
	tbgGcdd = new MyTableGrid(gcddTable);
	tbgGcdd.pager = objGcdd.gcddList;
	tbgGcdd.render("giacCashDepDtlTable");
	tbgGcdd.afterRender = function(){
		tbgGcdd.keys.removeFocus(tbgGcdd.keys._nCurrentFocus, true);
		tbgGcdd.keys.releaseKeys();
		
		if(tbgGcdd.geniisysRows.length > 0){
			var rec = tbgGcdd.geniisysRows[0];
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
		}
	};
	
	function setGcddFields(rec){
		try{
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	$("imgValidationDt").observe("click", function(){
		scwShow($('txtValidationDt'),this, null);
	});
	
	$("txtAmount").observe("blur", function() {
		if($F("txtAmount") != ""){
			if($F("txtCurrencyRt") != ""){
				var amount = unformatCurrencyValue($F("txtAmount"));
				var currRt = unformatCurrencyValue($F("txtCurrencyRt"));
				$("txtForeignCurrAmt").value = (amount * currRt);
			} else {
				var amount = unformatCurrencyValue($F("txtAmount"));
				var currRt = gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('currencyRt'), _selectedGdbdIndex);
				$("txtForeignCurrAmt").value = (amount * currRt);
				$("txtCurrencyShortName").value = gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('dspCurrSname'), _selectedGdbdIndex);
				$("txtCurrencyRt").value = formatToNthDecimal(gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('currencyRt'), _selectedGdbdIndex), 9);
			}	
		}
	});
	
	$("txtCurrencyShortName").setAttribute("lastValidValue", "");
	$("imgSearchCurrency").observe("click", showGiacs035CurrencyLov);
	$("txtCurrencyShortName").observe("change", function() {		
		if($F("txtCurrencyShortName").trim() == "") {
			$("txtCurrencyShortName").value = "";
			$("txtCurrencyShortName").setAttribute("lastValidValue", "");
		} else {
			if($F("txtCurrencyShortName").trim() != "" && $F("txtCurrencyShortName") != $("txtCurrencyShortName").readAttribute("lastValidValue")) {
				showGiacs035CurrencyLov();
			}
		}
	});
	$("txtCurrencyShortName").observe("keyup", function(){
		$("txtCurrencyShortName").value = $F("txtCurrencyShortName").toUpperCase();
	});
	
	function showGiacs035CurrencyLov(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "showGiacs035CurrencyLov",
							moduleId :  "GIACS035",
							shortName : $F("gdbdShortName"),
							filterText : ($("txtCurrencyShortName").readAttribute("lastValidValue").trim() != $F("txtCurrencyShortName").trim() ? $F("txtCurrencyShortName").trim() : ""),
							page : 1},
			title: "List of Currency",
			width: 500,
			height: 400,
			columnModel : [
							{
								id : "shortName",
								title: "Currency Name",
								width: '100px',
								filterOption: true
							},
							{
								id : "currencyRt",
								title: "Currency Rate",
								width: '325px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtCurrencyShortName").readAttribute("lastValidValue").trim() != $F("txtCurrencyShortName").trim() ? $F("txtCurrencyShortName").trim() : ""),
				onSelect: function(row) {
					$("txtCurrencyShortName").value = row.shortName;
					$("txtCurrencyRt").value = formatToNthDecimal(row.currencyRt, 9);
					$("txtCurrencyShortName").setAttribute("lastValidValue", row.shortName);
					$("currencyCd").value = row.currencyCd;
				},
				onCancel: function (){
					$("txtCurrencyShortName").value = $("txtCurrencyShortName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtCurrencyShortName").value = $("txtCurrencyShortName").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	function addGbds2(){
		try {
			if($F("txtAmount") != "" || $F("txtValidationDt") != "" || $F("txtCurrencyShortName") != "" || $F("txtCurrencyRt") != "" || $F("txtForeignCurrAmt") != ""){
				var Gdbs2Obj = setGdbs2(objCurrGbds2);
				if($F("btnAdd") == "Add"){
					tbgGbds2.addBottomRow(Gdbs2Obj);
					addUpdateDeleteNewAmount("A");
				} else {
					tbgGbds2.updateVisibleRowOnly(Gdbs2Obj, rowIndex, false);
					addUpdateDeleteNewAmount("U");
				}
				changeTag = 1;
				setFieldValues(null);
				tbgGbds2.keys.removeFocus(tbgGbds2.keys._nCurrentFocus, true);
				tbgGbds2.keys.releaseKeys();
			} 
			
		} catch(e){
			showErrorMessage("addGbds2", e);
		}
	}	
	
	function setGdbs2(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.gaccTranId = gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('gaccTranId'), _selectedGdbdIndex);
			obj.fundCd = gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('fundCd'), _selectedGdbdIndex);
			obj.branchCd = gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('branchCd'), _selectedGdbdIndex);
			obj.dcbYear = gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('dcbYear'), _selectedGdbdIndex);
			obj.dcbNo = gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('dcbNo'), _selectedGdbdIndex);
			obj.itemNo = gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('itemNo'), _selectedGdbdIndex);
			obj.depNo = getMaxDepNo();
			obj.amount = unformatCurrencyValue($F("txtAmount"));
			obj.currencyCd = $F("currencyCd") == "" ? gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('currencyCd'), _selectedGdbdIndex) : $F("currencyCd");
			obj.currencyRt = unformatCurrencyValue($F("txtCurrencyRt"));
			obj.foreignCurrAmt = unformatCurrencyValue($F("txtForeignCurrAmt"));
			obj.validationDt = $F("txtValidationDt") == "" ? "" : $F("txtValidationDt");
			obj.currencyShortName = $F("txtCurrencyShortName");

			return obj;
		} catch(e){
			showErrorMessage("setGdbs2", e);
		}
	}
	
	function addUpdateDeleteNewAmount(action){
		var newAmount = unformatCurrencyValue($F("txtAmount"));
		var newForeignCurrAmt = unformatCurrencyValue($F("txtForeignCurrAmt"));
		var gbds2DspTotLoc = unformatCurrencyValue($F("gbds2DspTotLoc"));
		var gbds2DspTotFor = unformatCurrencyValue($F("gbds2DspTotFor"));

		if(action == "A"){
			$("gbds2DspTotLoc").value = gbds2DspTotLoc + newAmount;
			$("gbds2DspTotFor").value = gbds2DspTotFor + newForeignCurrAmt;	
		} else if(action == "U"){
			$("gbds2DspTotLoc").value = (gbds2DspTotLoc + newAmount) - currentAmount;
			$("gbds2DspTotFor").value = (gbds2DspTotFor + newForeignCurrAmt) - currentForeignCurrAmount;	
		} else if(action == "D"){
			$("gbds2DspTotLoc").value = gbds2DspTotLoc - currentAmount;
			$("gbds2DspTotFor").value = gbds2DspTotFor- currentForeignCurrAmount;
		}
	}
	
	function getMaxDepNo() {
		var maxDepNo = 0;
		var depNo;
		
		for (var i = 0; i < tbgGbds2.rows.length; i++) {
			depNo = parseInt(nvl(tbgGbds2.rows[i][tbgGbds2.getColumnIndex('depNo')], "0"));
			if (depNo > maxDepNo) {
				maxDepNo = depNo;
			}
		}

		for (var i = 0; i < tbgGbds2.newRowsAdded.length; i++) {
			depNo = parseInt(nvl(tbgGbds2.newRowsAdded[i][tbgGbds2.getColumnIndex('depNo')], "0"));
			if (depNo > maxDepNo) {
				maxDepNo = depNo;
			}
		}

		return (maxDepNo + 1);
	}
	
	function validateBeforeSave(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		
		var gbds2DspTotLoc = unformatCurrencyValue($F("gbds2DspTotLoc"));
		var gdbdAmt = unformatCurrencyValue($F("selectedGdbdAmt"));
		var gbdb2DspTotFor = unformatCurrencyValue($F("gbds2DspTotFor"));
		var gbdbForeignCurrAmt = unformatCurrencyValue($F("selectedGdbdForCurrAmt"));
		var shortOver = (gdbdAmt - gbds2DspTotLoc);
		if(notEqualTag == "Y"){
			if(gbds2DspTotLoc == gdbdAmt || gbdb2DspTotFor == gbdbForeignCurrAmt){
				tbgGcdd.deletedRows.push(tbgGcdd.geniisysRows["0"]);
				tbgGcdd.deleteRow("0");
				saveForm();	
			} else {
				var gcddObj = new Object();
				gcddObj.amount = gdbdAmt;
				gcddObj.currencyCd = gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('currencyCd'), _selectedGdbdIndex);
				gcddObj.currencyShortName = gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('dspCurrSname'), _selectedGdbdIndex);
				gcddObj.currencyRt = gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('currencyRt'), _selectedGdbdIndex);
				gcddObj.netDeposit = gbds2DspTotLoc;
				gcddObj.shortOver = shortOver;
				gcddObj.foreignCurrAmt = gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('foreignCurrAmt'), _selectedGdbdIndex);
				gcddObj.bookTag = "Y";
				gcddObj.fundCd = gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('fundCd'), _selectedGdbdIndex);
				gcddObj.branchCd = gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('branchCd'), _selectedGdbdIndex);
				gcddObj.dcbYear = gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('dcbYear'), _selectedGdbdIndex);
				gcddObj.dcbNo = gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('dcbNo'), _selectedGdbdIndex);
				gcddObj.gaccTranId = gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('gaccTranId'), _selectedGdbdIndex);
				gcddObj.itemNo = gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('itemNo'), _selectedGdbdIndex);
				gcddObj.remarks = $F("txtRemarks");
				gcddObj.userId = userId;
				var lastUpdate = new Date();
				gcddObj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy');
				tbgGcdd.addBottomRow(gcddObj);
				saveForm();	
			}
		} else {
			if(gbds2DspTotLoc != gdbdAmt || gbdb2DspTotFor != gbdbForeignCurrAmt) {
				if(gbds2DspTotLocOrig != gbds2DspTotLoc && gbds2DspTotLoc != 0){
					//showMessageBox("Total deposits should be equal to the amount per item_no in Close DCB.", imgMessage.ERROR);
					var gcddObj = new Object();
					gcddObj.amount = gdbdAmt;
					gcddObj.currencyCd = gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('currencyCd'), _selectedGdbdIndex);
					gcddObj.currencyShortName = gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('dspCurrSname'), _selectedGdbdIndex);
					gcddObj.currencyRt = gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('currencyRt'), _selectedGdbdIndex);
					gcddObj.netDeposit = gbds2DspTotLoc;
					gcddObj.shortOver = shortOver;
					gcddObj.foreignCurrAmt = gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('foreignCurrAmt'), _selectedGdbdIndex);
					gcddObj.bookTag = "Y";
					gcddObj.fundCd = gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('fundCd'), _selectedGdbdIndex);
					gcddObj.branchCd = gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('branchCd'), _selectedGdbdIndex);
					gcddObj.dcbYear = gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('dcbYear'), _selectedGdbdIndex);
					gcddObj.dcbNo = gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('dcbNo'), _selectedGdbdIndex);
					gcddObj.gaccTranId = gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('gaccTranId'), _selectedGdbdIndex);
					gcddObj.itemNo = gdbdListTableGrid.getValueAt(gdbdListTableGrid.getColumnIndex('itemNo'), _selectedGdbdIndex);
					gcddObj.remarks = $F("txtRemarks");
					gcddObj.userId = userId;
					var lastUpdate = new Date();
					gcddObj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy');
					tbgGcdd.addBottomRow(gcddObj);
					tbgGcdd.selectRow('0');
					setGcddFields(gcddObj);
					notEqualTag = "Y";
					showWaitingMessageBox("Total deposits should be equal to the amount per item_no in Close DCB.", imgMessage.ERROR, saveForm); //lara 02/04/2014
				} else {
					saveForm();
				}
			} else {
				saveForm();
			}	
		}
	}
	
	function saveForm(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		
		/* var addedRows = tbgGbds2.getNewRowsAdded();
		var modifiedRows = tbgGbds2.getModifiedRows();
		var delRows = tbgGbds2.getDeletedRows();

		var objParameters = new Object();
		objParameters.delRows = delRows;
		objParameters.setRows = addedRows.concat(modifiedRows); */
		
		//lara 02/03/2014
		var addedRows = getAddedAndModifiedJSONObjects(tbgGbds2.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgGbds2.geniisysRows);
		
		var objParameters = new Object();
		objParameters.delRows = delRows;
		objParameters.setRows = addedRows;
		
		addedRows = tbgGcdd.getNewRowsAdded();
		delRows   = tbgGcdd.getDeletedRows();

		objParameters.delGcddRows = delRows;
		objParameters.setGcddRows = addedRows.concat(tbgGcdd.getModifiedRows());
		
		var strParameters = JSON.stringify(objParameters);
		
		new Ajax.Request(contextPath+"/GIACBankDepSlipsController?action=saveGbdsBlock",{
			method: "POST",
			parameters:{
				parameters: strParameters
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				if(checkErrorOnResponse(response)) {
					if (response.responseText == "SUCCESS"){
						showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
						tbgGbds2._refreshList();
						notEqualTag = "N";
						changeTag = 0;
					}
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}	 
		});
	}
	
	function delGbds2(){
		objCurrGbds2.recordStatus = -1;
		tbgGbds2.deleteRow(rowIndex);
		addUpdateDeleteNewAmount("D");
		setFieldValues(null);
		changeTag = 1;
		for (var i = 0; i < tbgGcdd.rows.length; i++) {
			tbgGcdd.deleteRow(i);
			tbgGcdd.deletedRows.push(tbgGcdd.geniisysRows["0"]);
			$("txtRemarks").value = "";
			$("txtUserId").value = "";
			$("txtLastUpdate").value = "";
		}
	}
	
	$("btnAdd").observe("click", addGbds2);
	$("btnSave").observe("click", validateBeforeSave);
	$("btnDelete").observe("click", delGbds2);
	disableButton("btnDelete");
	$("txtValidationDt").focus();

	$("btnReturn").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						validateBeforeSave();
						if(changeTag == 0){
							cashDepositOverlay.close();
							delete cashDepositOverlay;	
						}
					}, function(){
						cashDepositOverlay.close();
						delete cashDepositOverlay;
					}, "");
		} else {
			cashDepositOverlay.close();
			delete cashDepositOverlay;
		}
	});
</script>