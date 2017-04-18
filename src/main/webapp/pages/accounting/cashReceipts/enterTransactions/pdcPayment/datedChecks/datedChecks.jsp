<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giacs091MainDiv" name="giacs091MainDiv" style="">
	<div id="giacs091MainDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="acExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Extract Dated Checks</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	<div id="extractParamFormDiv" align="center" class="sectionDiv" style="padding-top:20px; padding-bottom:20px;">
		<table cellspacing="0" width: 900px;">
			<tr>
				<!-- added by apollo cruz 09.16.2015 sr#20107 -->
				<td class="rightAligned">Company</td>
				<td class="leftAligned" colspan="3">
					<span class="lovSpan required" style="width: 70px; height: 21px; margin: 2px 2px 0 0; float: left;">
						<input type="text" id="txtFundCd" name="txtFundCd" ignoreDelKey="1" style="width: 43px; float: left; border: none; height: 13px;" class="required disableDelKey allCaps" tabindex="1" lastValidValue=""/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgFundCd" name="imgFundCd" alt="Go" style="float: right;">
					</span> 
					<span class="lovSpan " style="border: none; height: 21px; margin: 0 2px 0 2px; float: left;">
						<input type="text" id="txtFundDesc" name="txtFundDesc" ignoreDelKey="1" style="width: 565px; float: left; height: 15px;" class="allCaps required" readonly="readonly" lastValidValue=""/>
					</span>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width:100px;">Check Date</td>
				<td class="leftAligned" style="width:200px;">
					<div id="checkDateDiv" class="required" style="float: left; border: 1px solid gray; width: 205px; height: 20px;">
						<input id="txtCheckDate" name="Check Date" readonly="readonly" type="text" class=" required date" maxlength="10" style="border: none; float: left; width: 180px; height: 13px; margin: 0px;" value="" tabindex="101"/>
						<img id="imgCheckDate" alt="imgCheckDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtCheckDate'),this, null);"/>
					</div>
				</td>
				<td class="rightAligned" style="width:100px;">Branch</td>
				<td class="leftAligned" style="width:350px;">
					<span class="lovSpan required" style="width: 70px; height: 21px; margin: 2px 2px 0 0; float: left;">
						<input type="text" id="txtBranchCd" name="txtBranchCd" ignoreDelKey="1" style="width: 43px; float: left; border: none; height: 13px;" class="required disableDelKey allCaps" maxlength="2" tabindex="102" />
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranch" name="searchBranch" alt="Go" style="float: right;">
					</span> 
					<span class="lovSpan " style="border: none; height: 21px; margin: 0 2px 0 2px; float: left;">
						<input type="text" id="txtBranchName" name="txtBranchName" ignoreDelKey="1" style="width: 250px; float: left; height: 15px;" class="allCaps required" maxlength="" readonly="readonly" tabindex="103" />
					</span>
				</td>
			</tr>
		</table>
		<div style="margin-top: 25px;" align="center">
			<input type="button" class="button" id="btnExtract" value="Extract" tabindex="104" style="width: 100px;">
		</div>
	</div>
	<div class="sectionDiv" align="center">
		<div id="checksTableDiv" style="padding-top: 10px;">
			<div id="checksTable" style="height: 331px; padding-left: 35px;"></div>
		</div>
		<table style="margin-top: 5px;">
			<tr>
				<td width="" class="rightAligned">Remarks</td>
				<td class="leftAligned" colspan="3">
					<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
						<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="2000"  onkeyup="limitText(this,2000);" tabindex="105"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="106"/>
					</div>
				</td>
			</tr>
		</table>
		<div style="margin: 10px;" align="center">
			<input type="button" class="button" id="btnUpdate" value="Update" tabindex="201">
		</div>
		<div align="center" style="padding: 10px 0 10px 0; border-top: 1px solid #E0E0E0;">
			<input type="button" class="button" id="btnOrParticulars" value="OR Particulars" tabindex="301" style="width: 150px; ">
			<input type="button" class="button" id="btnEnterMisc" value="Enter Misc Amt" tabindex="302" style="width: 150px;">
			<input type="button" class="button" id="btnForeignCurrency" value="Foreign Currency" tabindex="303" style="width: 150px;">
			<input type="button" class="button" id="btnDetails" value="Details" tabindex="304" style="width: 150px;">
			<input type="button" class="button" id="btnApply" value="Apply" tabindex="305" style="width: 150px;">
		</div>
	</div>
	<div class="buttonsDiv">
		<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="401">
		<input type="button" class="button" id="btnSave" value="Save" tabindex="402">
	</div>
</div>
<script type="text/javascript">
	setModuleId("GIACS091");
	setDocumentTitle("Extract Dated Checks");
	initializeAll();
	initializeAccordion();
	enableButtonSw(false);
	changeTag = 0;
	var rowIndex = -1;
	$("txtCheckDate").value = dateFormat(new Date(), 'mm-dd-yyyy');
	
	var objGIACS109 = {};
	var objCurrRecord = null;
	objGIACS109.recList = JSON.parse('${jsonRecList}');
	objGIACS109.exitPage = null;
	objGIACS109.pdcId = "";
	
	group = [];
	
	funds = JSON.parse('${funds}');
	
	if(funds.length == 1) {
		$("txtFundCd").value = unescapeHTML2(funds[0].fundCd);
		$("txtFundDesc").value = unescapeHTML2(funds[0].fundDesc);
		$("txtFundCd").setAttribute("lastValidValue", $F("txtFundCd"));
		$("txtFundDesc").setAttribute("lastValidValue", $F("txtFundDesc"));
		$("txtFundCd").readOnly = true;
		disableSearch("imgFundCd");
	}
	
	$("searchBranch").observe("click",function(){
		showBranchLOV("%");
	});
	
	$("txtBranchCd").observe("change", function(){
		if($F("txtBranchCd") != ""){
			showBranchLOV($F("txtBranchCd"));
		} else {
			$("txtBranchName").value = "";
			$("txtBranchCd").setAttribute("lastValidValue", "");
			$("txtBranchName").setAttribute("lastValidValue", "");
		}
	});
	
	$("btnExtract").observe("click",function(){
		if(checkAllRequiredFieldsInDiv("extractParamFormDiv")){
			tbgChecksTable.url = contextPath + "/GIACApdcPaytDtlController?action=showGiacs091&refresh=1&extractDate="+$F("txtCheckDate")+"&fundCd="+encodeURIComponent($F("txtFundCd"))+"&branchCd="+encodeURIComponent($F("txtBranchCd"));
			tbgChecksTable._refreshList();
			//enableButton("btnApply"); removed by jdiago 08.07.2014 : enabled only if there are records extracted.
			postExtract(); // added by jdiago 08.07.2014 : actions after extraction.
		}
	});
	
	$("imgFundCd").observe("click", function(){
		showFundLov();
	});
	
	$("txtFundCd").observe("change", function(){
		if(this.value.trim() == "") {
			$("txtFundCd").clear();
			$("txtFundDesc").clear();
			$("txtFundCd").setAttribute("lastValidValue", $F("txtFundCd"));
			$("txtFundDesc").setAttribute("lastValidValue", $F("txtFundDesc"));
			
			$("txtBranchCd").clear();
			$("txtBranchName").clear();
			$("txtBranchCd").setAttribute("lastValidValue", $F("txtBranchCd"));
			$("txtBranchName").setAttribute("lastValidValue", $F("txtBranchName"));
		} else {
			showFundLov();
		}
	});
	
	// added by apollo cruz 09.16.2015 sr#20107
	function showFundLov(){
		try{
			LOV.show({
				controller : "AcCashReceiptsTransactionsLOVController",
				urlParameters : {
					  action : "getGiacs091FundLOV",
					  filterText : ($("txtFundCd").readAttribute("lastValidValue") != $F("txtFundCd") ? $F("txtFundCd") : "")
				},
				title: "List of Companies",
				width: 400,
				height: 400,
				columnModel: [
		 			{
						id : "fundCd",
						title: "Company Code",
						width : 90,
						align: "left"
					},
					{
						id : "fundDesc",
						title: "Company Name",
					    width: 275,
					    align: "left"
					}
				],
				autoSelectOneRecord : true,
				draggable: true,
				onSelect: function(row) {
					if(tbgChecksTable.geniisysRows.length > 0){
						confirmChangeOfParams("company", row);
					} else {
						if(row != undefined){
							$("txtFundCd").value = unescapeHTML2(row.fundCd);
							$("txtFundDesc").value = unescapeHTML2(row.fundDesc);
							$("txtFundCd").setAttribute("lastValidValue", $F("txtFundCd"));
							$("txtFundDesc").setAttribute("lastValidValue", $F("txtFundDesc"));
							
							$("txtBranchCd").clear();
							$("txtBranchName").clear();
							$("txtBranchCd").setAttribute("lastValidValue", $F("txtBranchCd"));
							$("txtBranchName").setAttribute("lastValidValue", $F("txtBranchName"));
						}	
					}
				},
				onCancel: function(){
					$("txtFundCd").focus();
					$("txtFundCd").value = $("txtFundCd").getAttribute("lastValidValue");
					$("txtFundDesc").value = $("txtFundDesc").getAttribute("lastValidValue");
		  		},
		  		onUndefinedRow: function(){
		  			$("txtFundCd").value = $("txtFundCd").getAttribute("lastValidValue");
					$("txtFundDesc").value = $("txtFundDesc").getAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtFundCd");
		  		}
			});
		}catch(e){
			showErrorMessage("showBranchLOV",e);
		}
	}
	
	function showBranchLOV(x){
		
		if($F("txtFundCd").trim() == "") {
			customShowMessageBox("Please select Company first.", imgMessage.INFO, "txtFundCd");
			return;
		}
		
		try{
			LOV.show({
				controller : "AcCashReceiptsTransactionsLOVController",
				urlParameters : {
					  action : "getGiacs091BranchLOV",
					  fundCd : $F("txtFundCd"),
					  search : x,
						page : 1
				},
				title: "List of Branches",
				width: 400,
				height: 400,
				columnModel: [
		 			{
						id : 'branchCd',
						title: 'Iss Cd',
						width : '90px',
						align: 'left'
					},
					{
						id : 'branchName',
						title: 'Iss Name',
					    width: '285px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				filterText: nvl(escapeHTML2(x), "%"), 
				draggable: true,
				onSelect: function(row) {
					if(tbgChecksTable.geniisysRows.length > 0){ //added by jdiago 08.07.2014
						confirmChangeOfParams("branch", row);
					} else {
						if(row != undefined){
							$("txtBranchCd").value = unescapeHTML2(row.branchCd);
							$("txtBranchName").value = unescapeHTML2(row.branchName);
							$("txtBranchCd").setAttribute("lastValidValue",unescapeHTML2(row.branchCd));
							$("txtBranchName").setAttribute("lastValidValue",unescapeHTML2(row.branchName));
						}	
					}
				},
				onCancel: function(){
					$("txtBranchCd").focus();
					$("txtBranchCd").value = $("txtBranchCd").getAttribute("lastValidValue");
					$("txtBranchName").value = $("txtBranchName").getAttribute("lastValidValue");
		  		},
		  		onUndefinedRow: function(){
		  			$("txtBranchCd").value = $("txtBranchCd").getAttribute("lastValidValue");
					$("txtBranchName").value = $("txtBranchName").getAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtBranchCd");
		  		}
			});
		}catch(e){
			showErrorMessage("showBranchLOV",e);
		}
	}
	
	var checksTable = {
			url : contextPath + "/GIACApdcPaytDtlController?action=showGiacs091&refresh=1&extractDate="+$F("txtCheckDate")+"&branchCd="+encodeURIComponent($F("txtBranchCd")),
			options : {
				width : '850px',
				hideColumnChildTitle: true,
				id : 1,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrRecord = tbgChecksTable.geniisysRows[y];
					setFieldValues(objCurrRecord);
					checkboxVal = tbgChecksTable.rows[rowIndex][tbgChecksTable.getColumnIndex('grpSw')];
					tableCheckBox(checkboxVal, objCurrRecord.pdcId);
					tbgChecksTable.keys.removeFocus(tbgChecksTable.keys._nCurrentFocus, true);
					tbgChecksTable.keys.releaseKeys();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgChecksTable.keys.removeFocus(tbgChecksTable.keys._nCurrentFocus, true);
					tbgChecksTable.keys.releaseKeys();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						group = [];
						tbgChecksTable.keys.removeFocus(tbgChecksTable.keys._nCurrentFocus, true);
						tbgChecksTable.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(changeTag == 1 || changeTag2 == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
				onSort: function(){
					rowIndex = -1;
					setFieldValues(null);
					group = [];
					tbgChecksTable.keys.removeFocus(tbgChecksTable.keys._nCurrentFocus, true);
					tbgChecksTable.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					group = [];
					changeTag = 0;
					changeTag2 = 0;
					tbgChecksTable.keys.removeFocus(tbgChecksTable.keys._nCurrentFocus, true);
					tbgChecksTable.keys.releaseKeys();
				},				
				//from here onward of this tableGrid, changeTag2 will be removed to allow user to tag other records on other pages of tableGrid : jdiago 08.19.2014
				prePager: function(){
					if(changeTag == 1 /* || changeTag2 == 1 */){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
					rowIndex = -1;
					setFieldValues(null);
					tbgChecksTable.keys.removeFocus(tbgChecksTable.keys._nCurrentFocus, true);
					tbgChecksTable.keys.releaseKeys();
				},
				checkChanges: function(){
					return (changeTag == 1 /* || changeTag2 == 1 */ ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTag == 1 /* || changeTag2 == 1 */ ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTag == 1 /* || changeTag2 == 1 */ ? true : false);
				},
				masterDetail: function(){
					return (changeTag == 1 /* || changeTag2 == 1 */ ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTag == 1 /* || changeTag2 == 1 */ ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTag == 1 /* || changeTag2 == 1 */ ? true : false);
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
					id: 'grpSw',
              		title : ' ',
	              	width: '25px',
	              	sortable: false,
	              	editable: true,
	              	editor: new MyTableGrid.CellCheckbox({
		            	getValueOf : function(value) {
							if (value) {
								return "Y";
							} else {
								return "N";
							}
						}
	              	})
				},
				{
					id : 'bankSname',
					title: "Bank",
					width : '125px',
					filterOption : true
				},
				{
					id : 'bankBranch',
					title: "Bank Branch",
					width : '110px',
					filterOption : true
				},
				{
					id : 'checkClass',
					title : 'C',
					altTitle: "Check Class",
					titleAlign: "center",
					width : '30px',
				},
				{
					id : 'nbtApdcNo',
					title : 'APDC No.',
					width : '80px',
					filterOption : true
				},
				{
					id : 'checkNo',
					title : 'Check No.',
					width : '80px',
					filterOption : true,
					titleAlign: "right",
					align: "right",
					filterOptionType: 'integerNoNegative',
				},
				{
					id : 'checkDate',
					filterOption : true,
					title : 'Check Date',
					width : '80px',
					align : "center",
					titleAlign : "center",
					filterOptionType : 'formattedDate',
					renderer: function (value){
						var dateTemp;
						if(value=="" || value==null){
							dateTemp = "";
						}else{
							dateTemp = dateFormat(value,"mm-dd-yyyy");
						}
						value = dateTemp;
						return value;
					}			
				},
				{
					id : 'checkAmt',
					title : 'Amount',
					width : '90px',
					align : "right",
					titleAlign : "right",
					filterOption : true,
					filterOptionType: 'number',
					renderer : function(value) { //added by jdiago 08.12.2014
				    	return formatCurrency(value);
				    }
				},
				{
					id : 'shortName',
					title : 'Currency',
					width : '70px',
					filterOption : true,
				},
				{
					id : 'nbtStatus',
					title : 'Status',
					width : '110px',
					filterOption : true,
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
			rows : objGIACS109.recList.rows
		};
 
		tbgChecksTable = new MyTableGrid(checksTable);
		tbgChecksTable.pager = objGIACS109.recList;
		tbgChecksTable.render("checksTable");
		tbgChecksTable.afterRender = function(){  //added by jdiago 08.19.2014
			tagPrevTaggedPDCs();
		};
		
	function enableButtonSw(sw){
		if(sw){
			enableButton("btnUpdate");
			enableButton("btnOrParticulars");
			enableButton("btnEnterMisc");
			enableButton("btnForeignCurrency");
			enableButton("btnDetails");
			enableButton("btnApply");
			$("txtRemarks").readOnly = false;
		} else {
			disableButton("btnUpdate");
			disableButton("btnOrParticulars");
			disableButton("btnEnterMisc");
			disableButton("btnForeignCurrency");
			disableButton("btnDetails");
			disableButton("btnApply");
			$("txtRemarks").readOnly = true;
		}
	}
	
	function setFieldValues(rec){
		try{
			objGIACS109.pdcId = (rec == null ? "" : rec.pdcId);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("txtRemarks").readOnly = true : $("txtRemarks").readOnly = false;
			rec == null ? disableButton("btnUpdate") : enableButton("btnUpdate");
			rec == null ? disableButton("btnOrParticulars") : enableButton("btnOrParticulars");
			rec == null ? disableButton("btnEnterMisc") : enableButton("btnEnterMisc");
			rec == null ? disableButton("btnForeignCurrency") : enableButton("btnForeignCurrency");
			rec == null ? disableButton("btnDetails") : enableButton("btnDetails");
			objCurrRecord = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.pdcId = objGIACS109.pdcId;
			obj.remarks = escapeHTML2($F("txtRemarks"));
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function updateRec(){
		try {
			changeTagFunc = saveGiacs091;
			var rec = setRec(objCurrRecord);
			tbgChecksTable.updateVisibleRowOnly(rec, rowIndex, false);
			changeTag = 1;
			setFieldValues(null);
			tbgChecksTable.keys.removeFocus(tbgChecksTable.keys._nCurrentFocus, true);
			tbgChecksTable.keys.releaseKeys();
		} catch(e){
			showErrorMessage("updateRec", e);
		}
	}	
	
	observeReloadForm("reloadForm", showGiacs091);
	observeSaveForm("btnSave", saveGiacs091);
	$("btnCancel").observe("click", cancelGiacs091);
	$("acExit").observe("click", cancelGiacs091);
	$("btnUpdate").observe("click", updateRec);
	
	function saveGiacs091(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgChecksTable.geniisysRows);
		new Ajax.Request(contextPath+"/GIACApdcPaytDtlController", {
			method: "POST",
			parameters : {action : "saveGiacs091",
					 	  setRows : prepareJsonAsParameter(setRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIACS109.exitPage != null) {
							objGIACS109.exitPage();
						} else {
							tbgChecksTable._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		}); 
	}
	
	function cancelGiacs091() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objGIACS109.exitPage = exitPage;
						saveGiacs091();
					}, function() {
						goToModule(
								"/GIISUserController?action=goToAccounting",
								"Claims Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToAccounting",
					"Accounting Main", null);
		}
	}
	
	$("btnOrParticulars").observe("click",function(){
		if (changeTag == 1) {
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		} else {
			showOrParticulars();
		} 
	});
	
	function showOrParticulars() {
		try {
			overlayOrParticulars = Overlay.show(contextPath
					+ "/GIACApdcPaytDtlController", {
				urlContent : true,
				urlParameters : {
					action : "showOrParticulars",
					ajax : "1",
					pdcId : objCurrRecord.pdcId,
					payor: objCurrRecord.payor,
					address1: objCurrRecord.address1,
					address2: objCurrRecord.address2,
					address3: objCurrRecord.address3,
					tin: objCurrRecord.tin,
					intmNo : objCurrRecord.intmNo,
					particulars : objCurrRecord.particulars
					},
				title : "Particulars",
				 height: 220, //modified by jdiago 07.31.2014 : height from 210 to 220
				 width: 552,
				draggable : true
			}); 
		} catch (e) {
			showErrorMessage("showOrParticulars", e);
		}
	}
	
	$("btnEnterMisc").observe("click",function(){
		if (changeTag == 1) {
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		} else {
			showEnterMisc();
		} 
	});
	
	function showEnterMisc() {
		try {
			overlayEnterMisc = Overlay.show(contextPath
					+ "/GIACApdcPaytDtlController", {
				urlContent : true,
				urlParameters : {
					action : "showEnterMisc",
					ajax : "1",
					grossAmt : objCurrRecord.grossAmt,
					commissionAmt: objCurrRecord.commissionAmt,
					vatAmt : objCurrRecord.vatAmt
					},
				title : "Miscellaneous Amount",
				 height: 140,
				 width: 552,
				draggable : true
			});  
		} catch (e) {
			showErrorMessage("showEnterMisc", e);
		}
	}
	
	$("btnForeignCurrency").observe("click",function(){
		if (changeTag == 1) {
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		} else {
			showForeignCurrency();
		} 
	});
	
	function showForeignCurrency() {
		try {
			overlayForeignCurrency = Overlay.show(contextPath
					+ "/GIACApdcPaytDtlController", {
				urlContent : true,
				urlParameters : {
					action : "showForeignCurrency",
					ajax : "1",
					currDesc : objCurrRecord.currencyDesc,
					convertRt: objCurrRecord.convertRt,
					fcurrencyAmt : objCurrRecord.fcurrencyAmt
					},
				title : "Foreign Currency",
				 height: 160,
				 width: 402,
				draggable : true
			});   
		} catch (e) {
			showErrorMessage("showForeignCurrency", e);
		}
	}
	
	$("btnDetails").observe("click",function(){
		if (changeTag == 1) {
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		} else {
			showDetails();
		} 
	});
	
	function showDetails() {
		try {
			overlayDetails = Overlay.show(contextPath
					+ "/GIACApdcPaytDtlController", {
				urlContent : true,
				urlParameters : {
					action : "showDetails",
					ajax : "1",
					pdcId : objCurrRecord.pdcId
					},
				title : "Details",
				 height: 380,
				 width: 423,
				draggable : true
			});   
		} catch (e) {
			showErrorMessage("showDetails", e);
		}
	}
	
	function tableCheckBox(grpSw , pdcId){
		if(grpSw == "Y"){
			insertToGroup(pdcId);
			checkFlag();
		} else if (grpSw == "N"){
			removeToGroup(pdcId);
		}
	}
	
	function insertToGroup(pdcId){
		var notExist = true;
		if(group.length == 0){
			group.push(pdcId);
			notExist = false;
		} else {
			for ( var i = 0; i < group.length; i++) {
				if(group[i] == pdcId){
					notExist = false;
					break;
				}
			}
		}
		if(notExist){
			group.push(pdcId);
		}
		changeTag2 = 1;
	}
	
	function removeToGroup(pdcId){
		for (var i = 0; i < group.length; i++) {
			if(group[i] == pdcId){
				group.splice(i, 1);
				
			}
		}
		if (group.length == 0){
			changeTag2 = 0;
		}
	}
	
	$("btnApply").observe("click",function(){
		if (changeTag == 1) {
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		} else {
			if(group.length == 0){
				customShowMessageBox("Please select PDC to apply.", imgMessage.INFO, "txtBranchCd");
			} else if (group.length == 1){
				if(giacs091ValidateTransactionDate())
					showApplyBank("M");
			} else if (group.length > 1){
				if(giacs091ValidateTransactionDate())
					showConfirmBox("Confirmation", "Do you want to create Multiple OR or Group OR?", "Multiple OR", "Group OR",
							function(){
								showApplyBank("M");
							},
							function(){
								showApplyBank("G");
							}
					);
			}
		} 
	});
	
	function giacs091ValidateTransactionDate () {
		var open = true;
		new Ajax.Request(contextPath + "/GIACApdcPaytDtlController" , {
			method: "POST",
			parameters: {
				action : "giacs091ValidateTransactionDate",
				fundCd : $F("txtFundCd"),
				branchCd : $F("txtBranchCd"),
				checkDate : $F("txtCheckDate")
			},
			asynchronous: false,
			evalScripts: true,
			onCreate : showNotice("Validating transaction date, please wait..."),
			onComplete: function (response) {
				hideNotice();
				if(!checkErrorOnResponse(response)) return;
				var closedTag = response.responseText.trim();
				var d = Date.parse($F("txtCheckDate"));
				
				if(closedTag == "XX") {
					open = false;
					showMessageBox("There is no open transaction month for "
							+ getMonthWordEquivalent(d.getMonth()) + " "
							+ d.getFullYear() + ".", imgMessage.INFO);
				} else if(closedTag != "N") {
					open = false;
					showMessageBox(
							"You are no longer allowed to create a transaction for "
									+ getMonthWordEquivalent(d.getMonth())
									+ " "
									+ d.getFullYear()
									+ ". This Transaction Month is "
									+ (closedTag == "T" ? "temporarily" : "already") + " closed.",
							imgMessage.INFO);
				}
			}
	    });
		return open;
	}
	//added by MarkS SR5881 12/14/2015
	function giacs091CheckSOABalance () {
		new Ajax.Request(contextPath + "/GIACApdcPaytDtlController" , {
			method: "POST",
			parameters: {
				action : "giacs091CheckSOABalance",
				pdcId : objCurrRecord.pdcId
			},
			asynchronous: false,
			evalScripts: true,
			onCreate : showNotice("Checking SOA balance due, please wait..."),
			onComplete: function (response) {
				hideNotice();
				if(!checkErrorOnResponse(response)) return;
				var checkSOAbalance = response.responseText.trim();
				
				if(checkSOAbalance == "N") {
					showWaitingMessageBox(
							"Can not apply this PDC to an OR. Collection amount of bill exceeds outstanding balance.",
							imgMessage.INFO,removeCheckboxOnTBG);
				} 
			}
	    });
	}
	//added by MarkS SR5881 12/14/2015
	function removeCheckboxOnTBG() {
		try {
			
			for ( var j = 0; j < tbgChecksTable.geniisysRows.length; j++) {
				if(objCurrRecord.pdcId == tbgChecksTable.geniisysRows[j].pdcId){
					tbgChecksTable.setValueAt(false, tbgChecksTable.getColumnIndex('grpSw'), j, true);
				}	
			}
				tbgChecksTable.modifiedRows = []; 
				$$("div.modifiedCell").each(function (a) {
				$(a).removeClassName('modifiedCell');
			});
			} catch (e) {
				showErrorMessage("removeCheckboxOnTBG", e); 
			}
	}
	//END 5881
	function showApplyBank(applyMode) {
		try {
			overlayBank = Overlay.show(contextPath
					+ "/GIACApdcPaytDtlController", {
				urlContent : true,
				urlParameters : {
					action : "showApplyBank",
					ajax : "1",
					checkDate: $F("txtCheckDate"),
					applyMode : applyMode,
					group : group,
					},
				title : "Details",
				 height: 170,
				 width: 458,
				draggable : true
			});   
		} catch (e) {
			showErrorMessage("showApplyBank", e);
		}
	}
	
	function checkFlag(){
		if(objCurrRecord.checkFlag == "N"){
			showWaitingMessageBox("This check has no premium collection details yet.", imgMessage.INFO, giacs091CheckSOABalance); //edited by MarkS SR5881 to check if SOA balance due.
		} else if(objCurrRecord.checkFlag == "A"){
			showWaitingMessageBox("PDC is already applied.", "I", function(){
				tbgChecksTable.setValueAt(false, tbgChecksTable.getColumnIndex('grpSw'), rowIndex, true);
				removeToGroup(objCurrRecord.pdcId);
			});
		} else if(objCurrRecord.checkFlag == "W"){ //added by MarkS SR5881 to check if SOA balance due. to check record that has details.
			giacs091CheckSOABalance();
		}
	}
	
	$("txtCheckDate").setAttribute("lastValidValue", $F("txtCheckDate")); //added by jdiago 08.07.2014
	$("txtCheckDate").observe("focus",function(){ //added by jdiago 08.05.2014 : validate checkDate must not be greater than sysdate
		// apollo cruz 09.03.2015 - sr#20107 - allowed selecting of check date greater than current date
		/* var sysdate = dateFormat(new Date(), 'mm-dd-yyyy');
		if($F("txtCheckDate") > sysdate){
			showWaitingMessageBox("Check date must not be later than the current date.",
					imgMessage.WARNING,
					function() {
				 		$("txtCheckDate").value = $("txtCheckDate").readAttribute("lastValidValue");
				 		return false;
					});
		} else */
		if(tbgChecksTable.geniisysRows.length > 0 && this.value != this.readAttribute("lastValidValue")){
			confirmChangeOfParams("check date", null);
		}
	}); 
	
	$("editRemarks").observe("click", function(){ //added by jdiago 08.05.2014 : call remarks overlay
		showOverlayEditor("txtRemarks", 2000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	function postExtract(){ //added by jdiago 08.07.2014 : display no of extracted records.
		var noOfRecords = $("mtgPagerMsg1").down().innerHTML; 
		if(noOfRecords == "No records found"){
			showMessageBox("Extraction finished. No records extracted.","I");
			disableButton("btnApply");
		} else {
			if(noOfRecords == "1"){
				showMessageBox("Extraction finished. " + noOfRecords + " record extracted.","I");	
			} else {
				showMessageBox("Extraction finished. " + noOfRecords + " records extracted.","I");
			}
			enableButton("btnApply");
		}
	}
	
	function confirmChangeOfParams(paramName, row){ //added by jdiago 08.07.2014 : do necessary actions upon changing parameters.
		showConfirmBox("Confirmation", "Changing the " + paramName + " will clear the records currently extracted. Do you still want to continue?", "Yes", "No", 
		        function(){
					if(paramName == "company") {
						$("txtFundCd").value = unescapeHTML2(row.fundCd);
						$("txtFundDesc").value = unescapeHTML2(row.fundDesc);
						$("txtFundCd").setAttribute("lastValidValue", $F("txtFundCd"));
						$("txtFundDesc").setAttribute("lastValidValue", $F("txtFundDesc"));
						
						$("txtBranchCd").clear();
						$("txtBranchName").clear();
						$("txtBranchCd").setAttribute("lastValidValue", $F("txtBranchCd"));
						$("txtBranchName").setAttribute("lastValidValue", $F("txtBranchName"));
						
						tbgChecksTable.url = contextPath + "/GIACApdcPaytDtlController?action=showGiacs091&refresh=1";
						tbgChecksTable._refreshList();
					} else {
						if(row != null){
					   		$("txtBranchCd").value = unescapeHTML2(row.branchCd);
							$("txtBranchName").value = unescapeHTML2(row.branchName);
							$("txtBranchCd").setAttribute("lastValidValue",unescapeHTML2(row.branchCd));
							$("txtBranchName").setAttribute("lastValidValue",unescapeHTML2(row.branchName));							
						}
						$("txtCheckDate").setAttribute("lastValidValue",$F("txtCheckDate"));
						$("btnExtract").click();	
					}
			    }, 
		        function(){
					$("txtFundCd").value = $("txtFundCd").readAttribute("lastValidValue");
			    	$("txtFundDesc").value = $("txtFundDesc").readAttribute("lastValidValue");
			    	$("txtCheckDate").value = $("txtCheckDate").readAttribute("lastValidValue");
					$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
					$("txtBranchName").value = $("txtBranchName").readAttribute("lastValidValue");
			    }
        );
	}
	
	function tagPrevTaggedPDCs(){ //created by jdiago 08.19.2014
		if(group.length != 0){
			for(var i=0; i<tbgChecksTable.geniisysRows.length; i++){
				for(var j=0; j<group.length; j++){
					if(tbgChecksTable.geniisysRows[i].pdcId == group[j]){
						$("mtgInput1_2,"+i).checked = true;	
					}
				}
			}
		}
	}
	
	$("txtFundCd").focus();
</script>