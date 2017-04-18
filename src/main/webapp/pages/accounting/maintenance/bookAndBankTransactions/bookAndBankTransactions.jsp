<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<jsp:include page="/pages/toolbar.jsp"></jsp:include>
<div id="giacs324MainDiv" name="giacs324MainDiv">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Equivalent Book Transaction per Bank Transaction</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	<div id="giacs324" name="giacs324">
		<div class="sectionDiv" id="giacs324LovDiv">
			<div style="" align="center" id="lovDiv">
				<table cellspacing="2" border="0" style="margin: 10px auto;">
					<tr>
						<td class="rightAligned">Bank</td>
						<td class="leftAligned">
							<span class="lovSpan required" style="width: 120px; height: 22px; margin: 2px 2px 0 0; float: left;">
								<input id="txtBankSname" name="txtBankSname" type="text" class="required" style="width: 95px; text-align: left; height: 13px; float: left; border: none;" tabindex="201" maxlength="10" lastValidValue="">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchBankCd" name="imgSearchBankCd" alt="Go" style="float: right;">
							</span>
							<input id="txtBankName" name="txtBankName" type="text" style="width: 400px; height: 16px;" readonly="readonly" tabindex="202"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="sectionDiv">
			<div id="giacs324TableDiv" style="padding-top: 10px;">
				<div id="giacs324Table" style="height: 340px; margin-left: 90px;"></div>
			</div>
			<div align="center" id="giacs324FormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Bank Transactions</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan required" style="float: left; width: 85px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required" type="text" id="txtBankTranCd" name="txtBankTranCd" style="width: 79px; float: left; border: none; height: 15px; margin: 0;" maxlength="5" tabindex="203" lastValidValue=""/>
							</span>
							<input id="txtBankTranDesc" name="txtBankTranDesc" type="text" style="width: 440px;" maxlength="40" tabindex="204"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Book Transactions</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan" style="float: left; width: 85px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="" type="text" id="txtBookTranCd" name="txtBookTranCd" style="width: 60px; float: left; border: none; height: 15px; margin: 0;" maxlength="5" tabindex="205" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchBookTranCd" name="imgSearchBookTranCd" alt="Go" style="float: right;" tabindex="206"/>
							</span>
							<input id="txtBookTranDesc" name="txtBookTranDesc" type="text" readonly="readonly" style="width: 440px;" maxlength="40" tabindex="207"/>
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="2000"  onkeyup="limitText(this,2000);" tabindex="208"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="209"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned" style="width: 254px;"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="210"></td>
						<td width="" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="211"></td>
					</tr>
				</table>
			</div>
			<div align="center" style="margin: 10px;">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="212">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="213">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="214">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="215">
</div>
<script type="text/javascript">
	hideToolbarButton("btnToolbarPrint");
	showToolbarButton("btnToolbarSave");
	disableToolbarButton("btnToolbarExecuteQuery");
	disableToolbarButton("btnToolbarEnterQuery");
	setForm(false);
	setModuleId("GIACS324");
	setDocumentTitle("Equivalent Book Transaction per Bank Transaction");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	var bankCd;
	
	function setForm(enable){
		if(enable){
			$("txtBankTranCd").readOnly = false;
			$("txtBankTranDesc").readOnly = false;
			$("txtBookTranCd").readOnly = false;
			$("txtRemarks").readOnly = false;
			enableSearch("imgSearchBookTranCd");
			enableButton("btnAdd");
		} else {
			$("txtBankTranCd").readOnly = true;
			$("txtBankTranDesc").readOnly = true;
			$("txtBookTranCd").readOnly = true;
			$("txtRemarks").readOnly = true;
			disableSearch("imgSearchBookTranCd");
			disableButton("btnAdd");
			disableButton("btnDelete");
		}
	}
	
	var objGIACS324 = {};
	var objCurrBankBookTran = null;
	objGIACS324.bankBookTranList = JSON.parse('${jsonBankBookTranList}');
	objGIACS324.exitPage = null;
	
	var bankBookTranTable = {
			url : contextPath + "/GIACBankBookTranController?action=showGiacs324&refresh=1",
			options : {
				width : '750px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrBankBookTran = tbgBankBookTran.geniisysRows[y];
					setFieldValues(objCurrBankBookTran);
					tbgBankBookTran.keys.removeFocus(tbgBankBookTran.keys._nCurrentFocus, true);
					tbgBankBookTran.keys.releaseKeys();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgBankBookTran.keys.removeFocus(tbgBankBookTran.keys._nCurrentFocus, true);
					tbgBankBookTran.keys.releaseKeys();
				},
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgBankBookTran.keys.removeFocus(tbgBankBookTran.keys._nCurrentFocus, true);
						tbgBankBookTran.keys.releaseKeys();
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
					tbgBankBookTran.keys.removeFocus(tbgBankBookTran.keys._nCurrentFocus, true);
					tbgBankBookTran.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgBankBookTran.keys.removeFocus(tbgBankBookTran.keys._nCurrentFocus, true);
					tbgBankBookTran.keys.releaseKeys();
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
					tbgBankBookTran.keys.removeFocus(tbgBankBookTran.keys._nCurrentFocus, true);
					tbgBankBookTran.keys.releaseKeys();
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
					id : 'bankCd',
					width : '0',
					visible: false
				},
				{
					id: 'bankTranCd bankTranDesc',
					title: 'Bank Transactions',
				    width : '300px',
				    children : [
						{
							id : "bankTranCd",
							title : 'Bank Tran Code',
							width : 80,
							align : "left",
							filterOption: true,
							renderer: function(value){
								return unescapeHTML2(value);	
							}
						},
						{
							id : "bankTranDesc",
							title : 'Bank Tran Desc',
							width : 280,
							align : "left",
							filterOption: true,
							renderer: function(value){
								return unescapeHTML2(value);	
							}
						}
				    ]
				},
				{
					id: 'bookTranCd bookTranDesc',
					title: 'Book Transactions',
				    width : '300px',
				    children : [
						{
							id : "bookTranCd",
							title : 'Book Tran Code',
							width : 80,
							align : "left",
							filterOption: true,
							renderer: function(value){
								return unescapeHTML2(value);	
							}
						},
						{
							id : "bookTranDesc",
							title : 'Book Tran Desc',
							width : 270,
							align : "left",
							filterOption: true,
							renderer: function(value){
								return unescapeHTML2(value);	
							}
						}
				    ]
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
			rows : objGIACS324.bankBookTranList.rows
	};
	tbgBankBookTran = new MyTableGrid(bankBookTranTable);
	tbgBankBookTran.pager = objGIACS324.bankBookTranList;
	tbgBankBookTran.render("giacs324Table");
	
	function setFieldValues(rec){
		try{
			$("txtBankTranCd").value = (rec == null ? "" : unescapeHTML2(rec.bankTranCd));
			$("txtBankTranDesc").value = (rec == null ? "" : unescapeHTML2(rec.bankTranDesc));
			$("txtBookTranCd").value = (rec == null ? "" : unescapeHTML2(rec.bookTranCd));
			$("txtBookTranCd").setAttribute("lastValidValue", (rec == null ? "" : rec.bookTranCd == null ? "" : rec.bookTranCd));
			$("txtBookTranDesc").value = (rec == null ? "" : unescapeHTML2(rec.bookTranDesc));
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			rec == null ? $("txtBankTranCd").readOnly = false : $("txtBankTranCd").readOnly = true;
			objCurrBankBookTran = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	$("txtBankSname").setAttribute("lastValidValue", "");
	$("imgSearchBankCd").observe("click", showGiacs324BankCd);
	$("txtBankSname").observe("keyup", function(){
		$("txtBankSname").value = $F("txtBankSname").toUpperCase();
	});
	$("txtBankSname").observe("change", function() {
		if($F("txtBankSname").trim() == "") {
			$("txtBankSname").value = "";
			$("txtBankSname").setAttribute("lastValidValue", "");
			$("txtBankSname").setAttribute("lastValidValue", "");
			$("txtBankName").value = "";
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		} else {
			if($F("txtBankSname").trim() != "" && $F("txtBankSname") != $("txtBankSname").readAttribute("lastValidValue")) {
				showGiacs324BankCd();
			}
		}
	});
	
	function showGiacs324BankCd(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action : "getGiacs324BankCd",
				moduleId :  "GIACS324",
				filterText : ($("txtBankSname").readAttribute("lastValidValue").trim() != $F("txtBankSname").trim() ? $F("txtBankSname").trim() : ""),
				page : 1
			},
			title: "List of Banks",
			width: 500,
			height: 400,
			autoSelectOneRecord: true,
			filterText : ($("txtBankSname").readAttribute("lastValidValue").trim() != $F("txtBankSname").trim() ? $F("txtBankSname").trim() : ""),
			columnModel : [
					{
						id : "bankSname",
						title: "Bank Short Name",
						width: '80',
						filterOption: true,
						renderer: function(value) {
							return unescapeHTML2(value);
						}
					},
					{
						id : "bankName",
						title: "Bank Name",
						width: '370px',
						renderer: function(value) {
							return unescapeHTML2(value);
						}
					}
			],
			onSelect: function(row) {
				enableToolbarButton("btnToolbarEnterQuery");
				enableToolbarButton("btnToolbarExecuteQuery");
				bankCd = row.bankCd;
				$("txtBankSname").value = row.bankSname;
				$("txtBankName").value = row.bankName;
				$("txtBankSname").setAttribute("lastValidValue", row.bankSname);								
			},
			onCancel: function (){
				$("txtBankSname").value = $("txtBankSname").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtBankSname").value = $("txtBankSname").readAttribute("lastValidValue");
			},
			onShow : function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		  });
	}
	
	$("txtBookTranCd").setAttribute("lastValidValue", "");
	$("imgSearchBookTranCd").observe("click", showGiacs324BookTranCd);
	$("txtBookTranCd").observe("keyup", function(){
		$("txtBookTranCd").value = $F("txtBookTranCd").toUpperCase();
	});
	$("txtBookTranCd").observe("change", function() {
		if($F("txtBookTranCd").trim() == "") {
			$("txtBookTranCd").value = "";
			$("txtBookTranCd").setAttribute("lastValidValue", "");
			$("txtBookTranDesc").value = "";
			$("txtBookTranCd").value = "";
			$("txtBookTranCd").setAttribute("lastValidValue", "");
			$("txtBookTranDesc").value = "";
		} else {
			if($F("txtBookTranCd").trim() != "" && $F("txtBookTranCd") != $("txtBookTranCd").readAttribute("lastValidValue")) {
				showGiacs324BookTranCd();
			}
		}
	});
	
	function showGiacs324BookTranCd(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action : "getGiacs324BookTranCd",
				moduleId :  "GIACS324",
				filterText : ($("txtBookTranCd").readAttribute("lastValidValue").trim() != $F("txtBookTranCd").trim() ? $F("txtBookTranCd").trim() : ""),
				page : 1
			},
			title: "List of Book Transactions",
			width: 500,
			height: 400,
			columnModel : [
					{
						id : "tranCode",
						title: "Tran Code",
						width: '100px',
						filterOption: true,
						renderer: function(value) {
							return unescapeHTML2(value);
						}
					},
					{
						id : "bookTransaction",
						title: "Book Transaction",
						width: '370px',
						renderer: function(value) {
							return unescapeHTML2(value);
						}
					}
			],
			autoSelectOneRecord: true,
			filterText : ($("txtBookTranCd").readAttribute("lastValidValue").trim() != $F("txtBookTranCd").trim() ? $F("txtBookTranCd").trim() : ""),
			onSelect: function(row) {
				$("txtBookTranCd").value = row.tranCode;
				$("txtBookTranDesc").value = row.bookTransaction;
				$("txtBookTranCd").setAttribute("lastValidValue", row.tranCode);								
			},
			onCancel: function (){
				$("txtBookTranCd").value = $("txtBookTranCd").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtBookTranCd").value = $("txtBookTranCd").readAttribute("lastValidValue");
			},
			onShow : function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		  });
	}
	
	function executeQuery(){
		if(checkAllRequiredFieldsInDiv("lovDiv")) {			
			tbgBankBookTran.url = contextPath + "/GIACBankBookTranController?action=showGiacs324&refresh=1&bankCd=" + bankCd;
			tbgBankBookTran._refreshList();
			setForm(true);
			disableToolbarButton("btnToolbarExecuteQuery");
			disableSearch("imgSearchBankCd");
		}
	}
	
	function enterQuery(){
		function proceedEnterQuery(){
			if($F("txtBankSname").trim() != ""){
				disableToolbarButton("btnToolbarExecuteQuery");
				bankCd = "";
				$("txtBankSname").value = "";
				$("txtBankSname").setAttribute("lastValidValue", "");
				$("txtBankName").value = "";
				$("txtBankSname").readOnly = false;
				enableSearch("imgSearchBankCd");
				tbgBankBookTran.url = contextPath + "/GIACBankBookTranController?action=showGiacs324&refresh=1&bankCd=" + bankCd;
				tbgBankBookTran._refreshList();
				setFieldValues(null);
				disableToolbarButton("btnToolbarEnterQuery");
				setForm(false);
			}
		}
		
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveGiacs324();
						proceedEnterQuery();
					}, function(){
						proceedEnterQuery();
					}, "");
		} else {
			proceedEnterQuery();
		}	
	}
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("giacs324FormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i = 0; i<tbgBankBookTran.geniisysRows.length; i++){
						if(tbgBankBookTran.geniisysRows[i].recordStatus == 0 || tbgBankBookTran.geniisysRows[i].recordStatus == 1){								
							if(tbgBankBookTran.geniisysRows[i].bankTranCd == $F("txtBankTranCd")){
								addedSameExists = true;								
							}							
						} else if(tbgBankBookTran.geniisysRows[i].recordStatus == -1){
							if(tbgBankBookTran.geniisysRows[i].bankTranCd == $F("txtBankTranCd")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same bank_tran_cd.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIACBankBookTranController", {
						parameters : {action : "valAddRec",
									  bankCd : bankCd,
									  bankTranCd : $F("txtBankTranCd"),
									  bookTranCd : $F("txtBookTranCd")
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
					/* if(objCurrBankBookTran.bankTranCd != $F("txtBankTranCd")){
						var addedSameExists = false;
						var deletedSameExists = false;					
						
						for(var i = 0; i<tbgBankBookTran.geniisysRows.length; i++){
							if(tbgBankBookTran.geniisysRows[i].recordStatus == 0 || tbgBankBookTran.geniisysRows[i].recordStatus == 1){								
								if(tbgBankBookTran.geniisysRows[i].bankTranCd == $F("txtBankTranCd")){
									addedSameExists = true;								
								}							
							} else if(tbgBankBookTran.geniisysRows[i].recordStatus == -1){
								if(tbgBankBookTran.geniisysRows[i].bankTranCd == $F("txtBankTranCd")){
									deletedSameExists = true;
								}
							}
						}
						
						if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
							showMessageBox("Record already exists with the same bank_tran_cd.", "E");
							return;
						} else if(deletedSameExists && !addedSameExists){
							addRec();
							return;
						}
						
						new Ajax.Request(contextPath + "/GIACBankBookTranController", {
							parameters : {action : "valAddRec",
										  bankCd : bankCd,
										  bankTranCd : $F("txtBankTranCd"),
										  bookTranCd : $F("txtBookTranCd")
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
					} */
				}
			} 
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiacs324;
			var bankBookTran = setRec(objCurrBankBookTran);
			if($F("btnAdd") == "Add"){
				tbgBankBookTran.addBottomRow(bankBookTran);
			} else {
				tbgBankBookTran.updateVisibleRowOnly(bankBookTran, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgBankBookTran.keys.removeFocus(tbgBankBookTran.keys._nCurrentFocus, true);
			tbgBankBookTran.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.bankCd = bankCd;
			obj.bankTranCd = escapeHTML2($F("txtBankTranCd"));
			obj.bankTranDesc = escapeHTML2($F("txtBankTranDesc"));
			obj.bookTranCd = escapeHTML2($F("txtBookTranCd"));
			obj.bookTranDesc = escapeHTML2($F("txtBookTranDesc"));
		    obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function deleteRec(){
		changeTagFunc = saveGiacs324;
		objCurrBankBookTran.recordStatus = -1;
		tbgBankBookTran.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function saveGiacs324(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgBankBookTran.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgBankBookTran.geniisysRows);
        
		new Ajax.Request(contextPath+"/GIACBankBookTranController", {
			method: "POST",
			parameters : {action : "saveGiacs324",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIACS324.exitPage != null) {
							objGIACS324.exitPage();
						} else {
							tbgBankBookTran._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	}	
	
	function cancelGiacs324(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIACS324.exitPage = exitPage;
						saveGiacs324();						
					}, function(){
							goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	}
	
	$("btnToolbarExecuteQuery").observe("click", executeQuery);
	$("btnToolbarEnterQuery").observe("click", enterQuery);	
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", deleteRec);
	observeSaveForm("btnSave", saveGiacs324);
	observeSaveForm("btnToolbarSave", saveGiacs324);
	$("btnCancel").observe("click", cancelGiacs324);
	$("btnToolbarExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 2000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtBankTranCd").observe("keyup", function(){
		$("txtBankTranCd").value = $F("txtBankTranCd").toUpperCase();
	});
	
	$("txtBankTranDesc").observe("keyup", function(){
		$("txtBankTranDesc").value = $F("txtBankTranDesc").toUpperCase();
	});
	
	observeReloadForm("reloadForm", showGiacs324);
	
	$("txtBankSname").focus();
</script>