<div id="giacs510GiacBudgetDtlMainDiv" style="width: 99.5%; margin-top: 5px; height: 440px; margin-bottom: 20px;" class="sectionDiv">
	<div>
		<div align="center" style="padding-top: 10px;">
			<table>
				<tr>
					<td align="rightAligned">Account Name</td>	
					<td class="leftAligned">
						<input id="txtMasterGlAcctName" type="text" readonly="readonly" value="${nbtGlAcctNameMaster}" style="width: 387px;" tabindex="501" maxlength="100">
					</td>
				</tr>
			</table>
		</div>
		<div style="padding:10px;">
			<div id="giacBudgetDtlGlAcctNoTable" style="height: 280px; width: 98%;" align="center">
				Table Grid Space
			</div>
			<div align="center" id="dtlGlAccountFormDiv" style="width: 98%; float: left;">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">GL Account No</td>
						<td class="leftAligned" style="padding-left: 5px;">
							<input id="txtDtlGlAcctCat"  type="text" class="integerNoNegativeUnformattedNoComma rightAligned required" maxlength="1" style="width: 20px; padding-right: 3px;" tabindex="205"> 
							<input id="txtDtlGlControlAcct" type="text" class="integerNoNegativeUnformattedNoComma rightAligned required" maxlength="2" style="width: 20px; padding-right: 3px;" tabindex="206" > 
							<input id="txtDtlGlSubAcct1" type="text" class="integerNoNegativeUnformattedNoComma rightAligned required" maxlength="2" style="width: 20px; padding-right: 3px;" tabindex="207" > 
							<input id="txtDtlGlSubAcct2" type="text" class="integerNoNegativeUnformattedNoComma rightAligned required" maxlength="2" style="width: 20px; padding-right: 3px;" tabindex="208" > 
							<input id="txtDtlGlSubAcct3" type="text" class="integerNoNegativeUnformattedNoComma rightAligned required" maxlength="2" style="width: 20px; padding-right: 3px;" tabindex="209" > 
							<input id="txtDtlGlSubAcct4" type="text" class="integerNoNegativeUnformattedNoComma rightAligned required" maxlength="2" style="width: 20px; padding-right: 3px;" tabindex="210" > 
							<input id="txtDtlGlSubAcct5" type="text" class="integerNoNegativeUnformattedNoComma rightAligned required" maxlength="2" style="width: 20px; padding-right: 3px;" tabindex="211" > 
							<input id="txtDtlGlSubAcct6" type="text" class="integerNoNegativeUnformattedNoComma rightAligned required" maxlength="2" style="width: 20px; padding-right: 3px;" tabindex="212" > 
							<input id="txtDtlGlSubAcct7" type="text" class="integerNoNegativeUnformattedNoComma rightAligned required" maxlength="2" style="width: 20px; padding-right: 3px;" tabindex="213">	
							<img id="searchDtlGLAcctLOV" alt="GL Account No" style="height: 17px; cursor: pointer;" class="" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />
						</td>
					</tr>
					<tr>
						<td class="rightAligned">GL Account Name</td>
						<td class="leftAligned" style="padding-left: 5px;">
							<input id="txtDtlGlAcctName" type="text" readonly="readonly" style="width: 387px;" tabindex="214" maxlength="100">
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="buttonsDiv" style="height: 30px;">
			<input type="button" class="button" id="btnAddDtl" value="Add" tabindex="502">
			<input type="button" class="button" id="btnDeleteDtl" value="Delete" tabindex="503">
		</div>
	</div>
</div>
<div align="center">
	<input type="button" class="button" id="btnReturn" value="Return" style="width: 100px;" tabindex="504">
	<input type="button" class="button" id="btnSaveDtl" value="Save" style="width: 100px;" tabindex="505">
</div>
<input id="year" type="hidden"  value="${year}"/>
<input id="glAcctId" type="hidden"  value="${glAcctId}"/>
<script type="text/javascript">
	initializeAll();
	changeTag = 0;
	var rowIndex = -1;
	var onSelect = "N";
	var dtlAcctIdAdd;
	
	var objGiacsBudgetDtl = {};
	var objCurrBudgetDtl = null;
	objGiacsBudgetDtl.budgetDtlList = JSON.parse('${jsonGiacBudgetDtl}');
	
	var giacBudgetDtlTable = {
			url : contextPath + "/GIACBudgetController?action=showBudgetDtlOverlay&refresh=1&year=" + $F("year") 
					+ "&glAcctId=" + $F("glAcctId"),
			options : {
				width : '626px',
				height : '270px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrBudgetDtl = tbgGiacBudgetDtl.geniisysRows[y];
					setFieldValues(objCurrBudgetDtl);
					tbgGiacBudgetDtl.keys.removeFocus(tbgGiacBudgetDtl.keys._nCurrentFocus, true);
					tbgGiacBudgetDtl.keys.releaseKeys();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGiacBudgetDtl.keys.removeFocus(tbgGiacBudgetDtl.keys._nCurrentFocus, true);
					tbgGiacBudgetDtl.keys.releaseKeys();
				},
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgGiacBudgetDtl.keys.removeFocus(tbgGiacBudgetDtl.keys._nCurrentFocus, true);
						tbgGiacBudgetDtl.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGiacBudgetDtl.keys.removeFocus(tbgGiacBudgetDtl.keys._nCurrentFocus, true);
					tbgGiacBudgetDtl.keys.releaseKeys();
				},
				onSort: function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					} else {
						rowIndex = -1;
						setFieldValues(null);
						tbgGiacBudgetDtl.keys.removeFocus(tbgGiacBudgetDtl.keys._nCurrentFocus, true);
						tbgGiacBudgetDtl.keys.releaseKeys();
					}
				},
				onRefresh: function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					} else {
						rowIndex = -1;
						setFieldValues(null);
						tbgGiacBudgetDtl.keys.removeFocus(tbgGiacBudgetDtl.keys._nCurrentFocus, true);
						tbgGiacBudgetDtl.keys.releaseKeys();
					}
				},
				prePager: function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					} else {
						rowIndex = -1;
						setFieldValues(null);
						tbgGiacBudgetDtl.keys.removeFocus(tbgGiacBudgetDtl.keys._nCurrentFocus, true);
						tbgGiacBudgetDtl.keys.releaseKeys();
					}
				},
				checkChanges: function(){
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
					id : 'glAccountNo',
					filterOption : true,
					title : 'GL Account No',
					width : '150px',
					renderer: function(value){
						return unescapeHTML2(value);	
					}
				},
				{
					id : 'glAcctName',
					filterOption : true,
					title : 'GL Account Name',
					width : '530px',
					renderer: function(value){
						return unescapeHTML2(value);	
					}
				},
				{   id: 'glAcctCategory',
				    width: '0px',
				    visible: false
				},
				{   id: 'glControlAcct',
				    width: '0px',
				    visible: false
				},
				{   id: 'glSubAcct1',
				    width: '0px',
				    visible: false
				},
				{   id: 'glSubAcct2',
				    width: '0px',
				    visible: false
				},
				{   id: 'glSubAcct3',
				    width: '0px',
				    visible: false
				},
				{   id: 'glSubAcct4',
				    width: '0px',
				    visible: false
				},
				{   id: 'glSubAcct5',
				    width: '0px',
				    visible: false
				},
				{   id: 'glSubAcct6',
				    width: '0px',
				    visible: false
				},
				{   id: 'glSubAcct7',
				    width: '0px',
				    visible: false
				},
				{   id: 'dtlAcctId',
				    width: '0px',
				    visible: false
				}, 
				{   id: 'glAcctId',
				    width: '0px',
				    visible: false
				}
			],
			rows : objGiacsBudgetDtl.budgetDtlList.rows
	};
	
	tbgGiacBudgetDtl = new MyTableGrid(giacBudgetDtlTable);
	tbgGiacBudgetDtl.pager = objGiacsBudgetDtl.budgetDtlList;
	tbgGiacBudgetDtl.render("giacBudgetDtlGlAcctNoTable");
	
	function setFieldValues(rec){
		try{
			$("txtDtlGlAcctCat").value = (rec == null ? "" : rec.glAcctCategory);
			$("txtDtlGlControlAcct").value = (rec == null ? "" : formatNumberDigits(rec.glControlAcct, 2));
			$("txtDtlGlSubAcct1").value = (rec == null ? "" : formatNumberDigits(rec.glSubAcct1, 2));
			$("txtDtlGlSubAcct2").value = (rec == null ? "" : formatNumberDigits(rec.glSubAcct2, 2));
			$("txtDtlGlSubAcct3").value = (rec == null ? "" : formatNumberDigits(rec.glSubAcct3, 2));
			$("txtDtlGlSubAcct4").value = (rec == null ? "" : formatNumberDigits(rec.glSubAcct4, 2));
			$("txtDtlGlSubAcct5").value = (rec == null ? "" : formatNumberDigits(rec.glSubAcct5, 2));
			$("txtDtlGlSubAcct6").value = (rec == null ? "" : formatNumberDigits(rec.glSubAcct6, 2));
			$("txtDtlGlSubAcct7").value = (rec == null ? "" : formatNumberDigits(rec.glSubAcct7, 2));
			$("txtDtlGlAcctName").value = (rec == null ? "" : rec.glAcctName);
			
			rec == null ? $("txtGlAcctCat").readOnly = false : $("txtGlAcctCat").readOnly = true;
			rec == null ? $("txtGlControlAcct").readOnly = false : $("txtGlControlAcct").readOnly = true;
			rec == null ? $("txtGlSubAcct1").readOnly = false : $("txtGlSubAcct1").readOnly = true;
			rec == null ? $("txtGlSubAcct2").readOnly = false : $("txtGlSubAcct2").readOnly = true;
			rec == null ? $("txtGlSubAcct3").readOnly = false : $("txtGlSubAcct3").readOnly = true;
			rec == null ? $("txtGlSubAcct4").readOnly = false : $("txtGlSubAcct4").readOnly = true;
			rec == null ? $("txtGlSubAcct5").readOnly = false : $("txtGlSubAcct5").readOnly = true;
			rec == null ? $("txtGlSubAcct6").readOnly = false : $("txtGlSubAcct6").readOnly = true;
			rec == null ? $("txtGlSubAcct7").readOnly = false : $("txtGlSubAcct7").readOnly = true;
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Add";
			rec == null ? disableButton("btnDeleteDtl") : enableButton("btnDeleteDtl");
			onSelect = (rec == null ? "N" : "Y");
			objCurrBudgetDtl = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	$("searchDtlGLAcctLOV").observe("click", function(){
		showGLAcctLOV("GIAC_BUDGET_DTL", $F("year"));
	});
	
	function showGLAcctLOV(table, year){
		try {
			giacBudgetLOVOVerlay = Overlay.show(contextPath+"/GIACBudgetController", {
				urlContent: true,
				urlParameters: {action    : "showGLAcctLOV",																
								ajax      : "1",
								table     : table,
								year      : year,
								glAcctCat : $F("txtGlAcctCat"),
								glAcctControlAcct : $F("txtGlControlAcct"),
								glSubAcct1 : $F("txtGlSubAcct1"),
								glSubAcct2 : $F("txtGlSubAcct2"),
								glSubAcct3 : $F("txtGlSubAcct3"),
								glSubAcct4 : $F("txtGlSubAcct4"),
								glSubAcct5 : $F("txtGlSubAcct5"),
								glSubAcct6 : $F("txtGlSubAcct6"),
								glSubAcct7 : $F("txtGlSubAcct7"),
								glDtlAcctCat : $F("txtDtlGlAcctCat"),
								glDtlAcctControlAcct : $F("txtDtlGlControlAcct"),
								glDtlSubAcct1 : $F("txtDtlGlSubAcct1"),
				},
			    title: "Chart of Accounts",
			    height: 400,
			    width: 600,
			    draggable: true
			});
		} catch (e) {
			showErrorMessage("GIAC_BUDGET_DTL Overlay Error: " , e);
		}
	}
	
	function saveGIACS510Dtl(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var budgetDtl = getAddedAndModifiedJSONObjects(tbgGiacBudgetDtl.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgGiacBudgetDtl.geniisysRows);
		new Ajax.Request(contextPath+"/GIACBudgetController", {
			method: "POST",
			parameters : {action : "saveGIACS510Dtl",
					 	  setRows : prepareJsonAsParameter(budgetDtl),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
					changeTag = 0;
					tbgGiacBudgetDtl._refreshList();
				}
			}
		});
	}
	
	$("txtDtlGlAcctCat").observe("blur", function(){
		whenValidateItemGL($F("year"), $("txtDtlGlAcctCat"), "1");
	});
	
	$("txtDtlGlControlAcct").observe("blur", function(){
		whenValidateItemGL($F("txtYear"), $("txtDtlGlControlAcct"), "2");
	});
	
	$("txtDtlGlSubAcct1").observe("blur", function(){
		whenValidateItemGL($F("txtYear"), $("txtDtlGlSubAcct1"), "2");
	});
	
	$("txtDtlGlSubAcct2").observe("blur", function(){
		whenValidateItemGL($F("txtYear"), $("txtDtlGlSubAcct2"), "2");
	});
	
	$("txtDtlGlSubAcct3").observe("blur", function(){
		whenValidateItemGL($F("txtYear"), $("txtDtlGlSubAcct3"), "2");
	});
	
	$("txtDtlGlSubAcct4").observe("blur", function(){
		whenValidateItemGL($F("txtYear"), $("txtDtlGlSubAcct4"), "2");
	});
	
	$("txtDtlGlSubAcct5").observe("blur", function(){
		whenValidateItemGL($F("txtYear"), $("txtDtlGlSubAcct5"), "2");
	});
	
	$("txtDtlGlSubAcct6").observe("blur", function(){
		whenValidateItemGL($F("txtYear"), $("txtDtlGlSubAcct6"), "2");
	});
	
	$("txtDtlGlSubAcct7").observe("blur", function(){
		whenValidateItemGL($F("txtYear"), $("txtDtlGlSubAcct7"), "2");
	});
	
	function whenValidateItemGL(year, elemName, formatDigitTo){
		if($F("txtDtlGlAcctCat") != "" && $F("txtDtlGlControlAcct") != "" && $F("txtDtlGlSubAcct1") != "" &&
		   $F("txtDtlGlSubAcct2") != "" && $F("txtDtlGlSubAcct3") != "" && $F("txtDtlGlSubAcct4") != "" && 
		   $F("txtDtlGlSubAcct5") != "" && $F("txtDtlGlSubAcct6") != "" && $F("txtDtlGlSubAcct7") != ""){
			validateGLAcctNo(elemName, formatDigitTo);
		} else {
			elemName.value = formatNumberDigits(elemName.value,formatDigitTo);
		}
	}
	
	function validateGLAcctNo(elemName, formatDigitTo){
		new Ajax.Request(contextPath+"/GIACBudgetController?action=validateGLAcctNo",{
			parameters: {
				year : $F("year"),
				table : "GIAC_BUDGET_DTL",
				glAcctCat : $F("txtDtlGlAcctCat"),
				glAcctControlAcct : $F("txtDtlGlControlAcct"),
				glSubAcct1 : $F("txtDtlGlSubAcct1"),
				glSubAcct2 : $F("txtDtlGlSubAcct2"),
				glSubAcct3 : $F("txtDtlGlSubAcct3"),
				glSubAcct4 : $F("txtDtlGlSubAcct4"),
				glSubAcct5 : $F("txtDtlGlSubAcct5"),
				glSubAcct6 : $F("txtDtlGlSubAcct6"),
				glSubAcct7 : $F("txtDtlGlSubAcct7"),
			},
			evalScripts: true,
			asynchronous: true,
			onComplete: function(response){
				if (checkErrorOnResponse(response)){
					var res = JSON.parse(response.responseText);
					if(res.exist == "N"){
						showMessageBox("Invalid GL Account No.", "E");
						elemName.value = "";
						$("txtDtlGlAcctName").value = "";
						return false;
					} else {
						elemName.value = formatNumberDigits(elemName.value, formatDigitTo);
						$("txtDtlGlAcctName").value = res.glAcctName;
						dtlAcctIdAdd = res.glAcctId;
					}
				}
			}
		});
	}
	
	function delGIACS510Dtl(){
		objCurrBudgetDtl.recordStatus = -1;
		tbgGiacBudgetDtl.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function setBudgetDtl(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.year = $F("year");
			obj.glAccountNo = $F("txtDtlGlAcctCat") + "-" + formatNumberDigits($F("txtDtlGlControlAcct"), 2) + "-" +
							  formatNumberDigits($F("txtDtlGlSubAcct1"), 2) + "-" + formatNumberDigits($F("txtDtlGlSubAcct2"), 2) + "-" +
							  formatNumberDigits($F("txtDtlGlSubAcct3"), 2) + "-" + formatNumberDigits($F("txtDtlGlSubAcct4"), 2) + "-" +
							  formatNumberDigits($F("txtDtlGlSubAcct5"), 2) + "-" + formatNumberDigits($F("txtDtlGlSubAcct6"), 2) + "-" +
							  formatNumberDigits($F("txtDtlGlSubAcct7"), 2);
			obj.glAcctId = $F("glAcctId");
			obj.glAcctName = $F("txtGlAcctName");
			obj.dtlAcctId = dtlAcctIdAdd;
			obj.userId = userId;
			return obj;
		} catch(e){
			showErrorMessage("setBudgetDtl", e);
		}
	}
	
	function addGiacBudgetDtl(){
		try {
			if(checkAllRequiredFieldsInDiv("dtlGlAccountFormDiv")){
				var budgetDtl = setBudgetDtl(objCurrBudgetDtl);
				
				tbgGiacBudgetDtl.addBottomRow(budgetDtl);
				changeTag = 1;
				setFieldValues(null);
				tbgGiacBudgetDtl.keys.removeFocus(tbgGiacBudgetDtl.keys._nCurrentFocus, true);
				tbgGiacBudgetDtl.keys.releaseKeys();
			}
		} catch(e){
			showErrorMessage("addGiacBudgetPerYear", e);
		}
	}
	
	$("btnAddDtl").observe("click", addGiacBudgetDtl);
	observeSaveForm("btnSaveDtl", saveGIACS510Dtl);
	$("btnDeleteDtl").observe("click", delGIACS510Dtl);
	disableButton("btnDeleteDtl");
	
	$("btnReturn").observe("click", function(){
		giacBudgetDtlOVerlay.close();
		delete giacBudgetDtlOVerlay;
	});
</script>