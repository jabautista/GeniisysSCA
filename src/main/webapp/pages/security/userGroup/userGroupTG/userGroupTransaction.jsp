<div id="userGrpTranMainDiv">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="btnTranExit">Exit</a></li>
			</ul>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Transaction</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="tranReloadForm" name="tranReloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>

	<div class="sectionDiv">
		<table style="margin: 10px auto;">
			<tr>
				<td class="rightAligned">
					<label style="padding-bottom: 3px;">User Group</label>
				</td>
				<td>
					<input readonly="readonly" type="text" id="txtUserGrp" name="txtUserGrp" style="width: 65px; float: left; height: 13px; margin-left: 2px; text-align: right;" tabindex="201"/>
				</td>
				<td>
					<input id="txtUserGrpDesc" name="txtUserGrpDesc" type="text" style="width: 325px; height: 13px;" readonly="readonly" tabindex="202"/>
				</td>
				<td>
					<input readonly="readonly" type="text" id="txtGrpIssCd" name="txtGrpIssCd" style="width: 65px; height: 13px;" tabindex="203"/>
				</td>
			</tr>
		</table>
	</div>
	
	<div class="sectionDiv">
		<div style="float: right;">
			<input type="button" class="disabledButton" id="btnModules" value="Modules" style="width: 120px; margin: 100px 70px 0 0;" tabindex="206">
		</div>
		
		<div style="padding-top: 10px;">
			<div id="userGrpTranTable" style="height: 185px; margin-left: 215px;"></div>
		</div>
		
		<div id="tranFormDiv" align="center">
			<table style="margin-top: 30px;">	 			
				<tr>
					<td class="rightAligned" width="85px">Transaction</td>
					<td class="leftAligned">
						<span class="lovSpan required" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px; height: 21px;">
							<input class="required integerNoNegativeUnformattedNoComma" type="text" id="tranCd" style="text-align: right; width: 40px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="204" lastValidValue="" ignoreDelKey=""/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchTranCd" alt="Go" style="float: right;" tabindex="102"/>
						</span>
						<input id="tranDesc" type="text" style="width: 280px; height: 15px;" value="" readonly="readonly" tabindex="205"/>
					</td>
				</tr>
			</table>
		</div>
		
		<div align="center">
			<input type="button" class="button" id="btnAddTran" value="Add" style="width: 60px; margin-top: 5px; margin-bottom: 10px;" tabindex="207">
			<input type="button" class="disabledButton" id="btnDeleteTran" value="Delete" style="width: 60px; margin-top: 5px; margin-bottom: 10px;" tabindex="208">
		</div>
	</div>
	
	<div class="sectionDiv">
		<div style="float: right;">
			<input type="button" class="disabledButton" id="btnAllIssCd" value="All Issue Codes" style="width: 120px; margin: 100px 70px 0 0;" tabindex="211">
		</div>
		
		<div style="padding-top: 10px;">
			<div id="userGrpDtlTable" style="height: 185px; margin-left: 215px;"></div>
		</div>
		
		<div id="dtlFormDiv" align="center">
			<table style="margin-top: 30px;">	 			
				<tr>
					<td class="rightAligned" width="85px">Issuing Source</td>
					<td class="leftAligned">
						<span class="lovSpan required" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px; height: 21px;">
							<input class="required upper" type="text" id="dtlIssCd" style="width: 40px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="209" lastValidValue="" ignoreDelKey=""/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIssCd" alt="Go" style="float: right;" tabindex="210"/>
						</span>
						<input id="dtlIssName" type="text" style="width: 280px; height: 15px;" value="" readonly="readonly" tabindex=""/>
					</td>
				</tr>
			</table>
		</div>
		
		<div align="center">
			<input type="button" class="disabledButton" id="btnAddDtl" value="Add" style="width: 60px; margin-top: 5px; margin-bottom: 10px;" tabindex="212">
			<input type="button" class="disabledButton" id="btnDeleteDtl" value="Delete" style="width: 60px; margin-top: 5px; margin-bottom: 10px;" tabindex="213">
		</div>
	</div>
	
	<div class="sectionDiv">
		<div style="float: right;">
			<input type="button" class="disabledButton" id="btnAllLineCd" value="All Line Codes" style="width: 120px; margin: 100px 70px 0 0;" tabindex="219">
		</div>
		
		<div style="padding-top: 10px;">
			<div id="userGrpLineTable" style="height: 185px; margin-left: 215px;"></div>
		</div>
		
		<div id="lineFormDiv" align="center" style="margin-right: 25px;">
			<table style="margin-top: 30px;">	
				<tr>
					<td class="rightAligned" width="85px">Line</td>
					<td class="leftAligned" colspan="3">
						<span class="lovSpan required" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px; height: 21px;">
							<input class="required upper" type="text" id="lineCd" style="width: 40px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="214" lastValidValue="" ignoreDelKey=""/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCd" alt="Go" style="float: right;" tabindex="102"/>
						</span>
						<input id="lineName" type="text" style="width: 360px; height: 15px;" value="" readonly="readonly" tabindex="215"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Remarks</td>
					<td class="leftAligned" colspan="3">
						<div id="lineRemarksDiv" name="lineRemarksDiv" style="float: left; width: 438px; border: 1px solid gray; height: 22px;">
							<textarea style="float: left; height: 16px; width: 408px; margin-top: 0; border: none;" id="lineRemarks" name="lineRemarks" maxlength="4000" onkeyup="limitText(this,4000);" tabindex="216"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editLineRemarks"  tabindex="220"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">User Id</td>
					<td class="leftAligned">
						<input id="lineUserId" type="text" style="width: 160px;" readonly="readonly" tabindex="217">
					</td>
					<td width="89px" class="rightAligned">Last Update</td>
					<td class="leftAligned">
						<input id="lineLastUpdate" type="text" style="width: 160px; margin-left: 3px;" readonly="readonly" tabindex="218">
					</td>
				</tr>
			</table>
		</div>
		
		<div align="center">
			<input type="button" class="disabledButton" id="btnAddLine" value="Add" style="width: 60px; margin-top: 5px; margin-bottom: 10px;" tabindex="220">
			<input type="button" class="disabledButton" id="btnDeleteLine" value="Delete" style="width: 60px; margin-top: 5px; margin-bottom: 10px;" tabindex="221">
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnTranCancel" value="Cancel" tabindex="222">
	<input type="button" class="button" id="btnTranSave" value="Save" tabindex="223">
</div>

<script type="text/javascript">
	var objTran = {};
	objTran.tranList = JSON.parse('${userGrpTranJSON}');
	objTran.tranIndex = -1;
	objTran.dtlIndex = -1;
	objTran.lineIndex = -1;
	
	//START hdrtagudin-07232015-SR18661
	var tranChangeTag = 0;
	var issChangeTag = 0;
	var lineChangeTag = 0;
	//END hdrtagudin-07232015-SR18661
	
	var userGrpTranModel = {
		id: 412,
		url: contextPath + "/GIISUserGroupMaintenanceController?action=showUserGrpTransactions&refresh=1&userGrp="+$F("userGrp"),
		options: {
			width: '500px',
			height: '207px',
			pager: {},
			beforeClick: function(){
				if(hasPendingChildRecords("tran")){
					showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
					return false;
				}
			},
			onCellFocus: function(element, value, x, y, id){
				objTran.tranIndex = y;
				setTranValues(userGrpTranTG.geniisysRows[y]);
				userGrpTranTG.keys.removeFocus(userGrpTranTG.keys._nCurrentFocus, true);
				userGrpTranTG.keys.releaseKeys();
			},
			onRemoveRowFocus: function(){
				objTran.tranIndex = -1;
				setTranValues(null);
				userGrpTranTG.keys.removeFocus(userGrpTranTG.keys._nCurrentFocus, true);
				userGrpTranTG.keys.releaseKeys();
			},
			toolbar: {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter: function(){
					userGrpTranTG.onRemoveRowFocus();
				}
			},
			beforeSort : function(){
				if(changeTag == 1){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						$("btnTranSave").focus();
					});
					return false;
				}
			},
			onSort: function(){
				userGrpTranTG.onRemoveRowFocus();
			},
			onRefresh: function(){
				userGrpTranTG.onRemoveRowFocus();
			},				
			prePager: function(){
				if(changeTag == 1){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						$("btnTranSave").focus();
					});
					return false;
				}
				userGrpTranTG.onRemoveRowFocus();
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
			{   id: 'recordStatus',
			    width: '0',				    
			    visible: false			
			},
			{	id: 'divCtrId',
				width: '0',
				visible: false
			},
			{	id: 'tranCd',
				title: 'Tran Code',
				width: '80px',
				align: 'right',
				titleAlign: 'right',
				filterOption: true,
				filterOptionType: 'integerNoNegative'
			},
			{	id: 'tranDesc',
				title: 'Description',
				width: '328px',
				filterOption: true
			},
			{	id: 'incAllTag',
				title: 'Inc. All',
				width: '60px',
				filterOption: true
			}
		],
		rows: objTran.tranList.rows
	};
	userGrpTranTG = new MyTableGrid(userGrpTranModel);
	userGrpTranTG.pager = objTran.tranList;
	userGrpTranTG.render("userGrpTranTable");
	
	var userGrpDtlModel = {
		id: 413,
		url: contextPath + "/GIISUserGroupMaintenanceController?action=getUserGrpDtl",
		options: {
			width: '500px',
			height: '207px',
			pager: {},
			beforeClick: function(){
				if(hasPendingChildRecords("dtl")){
					showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
					return false;
				}
			},
			onCellFocus: function(element, value, x, y, id){
				objTran.dtlIndex = y;
				setDtlValues(userGrpDtlTG.geniisysRows[y]);
				userGrpDtlTG.keys.removeFocus(userGrpDtlTG.keys._nCurrentFocus, true);
				userGrpDtlTG.keys.releaseKeys();
			},
			onRemoveRowFocus: function(){
				objTran.dtlIndex = -1;
				setDtlValues(null);
				userGrpDtlTG.keys.removeFocus(userGrpDtlTG.keys._nCurrentFocus, true);
				userGrpDtlTG.keys.releaseKeys();
			},
			toolbar: {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter: function(){
					userGrpDtlTG.onRemoveRowFocus();
				}
			},
			beforeSort : function(){
				if(changeTag == 1){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						$("btnTranSave").focus();
					});
					return false;
				}
			},
			onSort: function(){
				userGrpDtlTG.onRemoveRowFocus();
			},
			onRefresh: function(){
				userGrpDtlTG.onRemoveRowFocus();
			},				
			prePager: function(){
				if(changeTag == 1){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						$("btnTranSave").focus();
					});
					return false;
				}
				userGrpDtlTG.onRemoveRowFocus();
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
			{   id: 'recordStatus',
			    width: '0',				    
			    visible: false			
			},
			{	id: 'divCtrId',
				width: '0',
				visible: false
			},
			{	id: 'issCd',
				title: 'Issue Code',
				width: '80px',
				filterOption: true
			},
			{	id: 'issName',
				title: 'Description',
				width: '389px',
				filterOption: true
			}
		],
		rows: []
	};
	userGrpDtlTG = new MyTableGrid(userGrpDtlModel);
	userGrpDtlTG.pager = {};
	userGrpDtlTG.render("userGrpDtlTable");
	
	var userGrpLineModel = {
		id: 414,
		url: contextPath + "/GIISUserGroupMaintenanceController?action=getUserGrpLine",
		options: {
			width: '500px',
			height: '207px',
			pager: {},
			onCellFocus: function(element, value, x, y, id){
				objTran.lineIndex = y;
				setLineValues(userGrpLineTG.geniisysRows[y]);
				userGrpLineTG.keys.removeFocus(userGrpLineTG.keys._nCurrentFocus, true);
				userGrpLineTG.keys.releaseKeys();
			},
			onRemoveRowFocus: function(){
				objTran.lineIndex = -1;
				setLineValues(null);
				userGrpLineTG.keys.removeFocus(userGrpLineTG.keys._nCurrentFocus, true);
				userGrpLineTG.keys.releaseKeys();
			},
			toolbar: {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter: function(){
					userGrpLineTG.onRemoveRowFocus();
				}
			},
			beforeSort : function(){
				if(changeTag == 1){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						$("btnTranSave").focus();
					});
					return false;
				}
			},
			onSort: function(){
				userGrpLineTG.onRemoveRowFocus();
			},
			onRefresh: function(){
				userGrpLineTG.onRemoveRowFocus();
			},				
			prePager: function(){
				if(changeTag == 1){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						$("btnTranSave").focus();
					});
					return false;
				}
				userGrpLineTG.onRemoveRowFocus();
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
			{   id: 'recordStatus',
			    width: '0',				    
			    visible: false			
			},
			{	id: 'divCtrId',
				width: '0',
				visible: false
			},
			{	id: 'lineCd',
				title: 'Line Code',
				width: '80px',
				filterOption: true
			},
			{	id: 'lineName',
				title: 'Description',
				width: '389px',
				filterOption: true
			}
		],
		rows: []
	};
	userGrpLineTG = new MyTableGrid(userGrpLineModel);
	userGrpLineTG.pager = {};
	userGrpLineTG.render("userGrpLineTable");
	
	function createNotInParam(table, rows, status){
		var notIn = "";
		var withPrevious = false;

		for(var i=0; i < rows.length; i++){
			if(rows[i].recordStatus == status){
				if(withPrevious){
					notIn += ",";
				}
				
				if(table == "tran"){
					notIn += rows[i].tranCd;
				}else if(table == "detail"){
					notIn += "'" + unescapeHTML2(rows[i].issCd).replace(/'/g, "''") + "'";
				}else if(table == "line"){
					notIn += "'" + unescapeHTML2(rows[i].lineCd).replace(/'/g, "''") + "'";
				}
				
				withPrevious = true;
			}
		}
		
		return (notIn != "" ? "("+notIn+")" : "");
	}
	
	function showTranLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {
				action: "getGiss041TranLOV",
				userGrp: $F("txtUserGrp"),
				notIn: createNotInParam("tran", userGrpTranTG.geniisysRows, 0),
				notInDeleted: createNotInParam("tran", userGrpTranTG.geniisysRows, -1),
				filterText: $F("tranCd") != $("tranCd").getAttribute("lastValidValue") ? nvl($F("tranCd"), "%") : "%"
			},
			title: "List of Transactions per Group",
			width: 365,
			height: 386,
			columnModel:[
							{	id: "tranCd",
								title: "Tran Code",
								width: "100px",
								titleAlign: "right",
								align: "right"
							},
							{	id: "tranDesc",
								title: "Tran Description",
								width: "250px"
							}
						],
			draggable: true,
			showNotice: true,
			autoSelectOneRecord : true,
			filterText: $F("tranCd") != $("tranCd").getAttribute("lastValidValue") ? nvl($F("tranCd"), "%") : "%",
		    noticeMessage: "Getting list, please wait...",
			onSelect : function(row){
				if(row != undefined) {
					$("tranCd").value = unescapeHTML2(row.tranCd);
					$("tranDesc").value = unescapeHTML2(row.tranDesc);
					$("tranCd").setAttribute("lastValidValue", unescapeHTML2(row.tranCd));
				}
			},
			onCancel: function(){
				$("tranCd").value = $("tranCd").getAttribute("lastValidValue");
			},
			onUndefinedRow: function(){
				showMessageBox("No record selected.", "I");
				$("tranCd").value = $("tranCd").getAttribute("lastValidValue");
			},
			onShow: function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		});
	}
	
	function showIssCdLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {
				action: "getGiss041IssueLOV",
				userGrp: $F("userGrp"),
				tranCd: $F("tranCd"),
				grpIssCd: $F("txtGrpIssCd"),
				notIn: createNotInParam("detail", userGrpDtlTG.geniisysRows, 0),
				notInDeleted: createNotInParam("detail", userGrpDtlTG.geniisysRows, -1),
				filterText: $F("dtlIssCd") != $("dtlIssCd").getAttribute("lastValidValue") ? nvl($F("dtlIssCd"), "%") : "%"
			},
			title: "List of Issue Codes per Group",
			width: 365,
			height: 386,
			columnModel:[
							{	id: "issCd",
								title: "Issuing Code",
								width: "100px"
							},
							{	id: "issName",
								title: "Issuing Name",
								width: "250px"
							}
						],
			draggable: true,
			showNotice: true,
			autoSelectOneRecord : true,
			filterText: $F("dtlIssCd") != $("dtlIssCd").getAttribute("lastValidValue") ? nvl($F("dtlIssCd"), "%") : "%",
		    noticeMessage: "Getting list, please wait...",
			onSelect : function(row){
				if(row != undefined) {
					$("dtlIssCd").value = unescapeHTML2(row.issCd);
					$("dtlIssName").value = unescapeHTML2(row.issName);
					$("dtlIssCd").setAttribute("lastValidValue", unescapeHTML2(row.issCd));
				}
			},
			onCancel: function(){
				$("dtlIssCd").value = $("dtlIssCd").getAttribute("lastValidValue");
			},
			onUndefinedRow: function(){
				showMessageBox("No record selected.", "I");
				$("dtlIssCd").value = $("dtlIssCd").getAttribute("lastValidValue");
			},
			onShow: function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		});
	}
	
	function showLineCdLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {
				action: "getGiss041LineLOV",
				userGrp: $F("userGrp"),
				tranCd: $F("tranCd"),
				issCd: $F("dtlIssCd"),
				notIn: createNotInParam("line", userGrpLineTG.geniisysRows, 0),
				notInDeleted: createNotInParam("line", userGrpLineTG.geniisysRows, -1),
				filterText: $F("lineCd") != $("lineCd").getAttribute("lastValidValue") ? nvl($F("lineCd"), "%") : "%"
			},
			title: "List of Lines",
			width: 365,
			height: 386,
			columnModel:[
							{	id: "lineCd",
								title: "Line Code",
								width: "100px"
							},
							{	id: "lineName",
								title: "Line Name",
								width: "250px"
							}
						],
			draggable: true,
			showNotice: true,
			autoSelectOneRecord : true,
			filterText: $F("lineCd") != $("lineCd").getAttribute("lastValidValue") ? nvl($F("lineCd"), "%") : "%",
		    noticeMessage: "Getting list, please wait...",
			onSelect : function(row){
				if(row != undefined) {
					$("lineCd").value = unescapeHTML2(row.lineCd);
					$("lineName").value = unescapeHTML2(row.lineName);
					$("lineCd").setAttribute("lastValidValue", unescapeHTML2(row.lineCd));
				}
			},
			onCancel: function(){
				$("lineCd").value = $("lineCd").getAttribute("lastValidValue");
			},
			onUndefinedRow: function(){
				showMessageBox("No record selected.", "I");
				$("lineCd").value = $("lineCd").getAttribute("lastValidValue");
			},
			onShow: function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		});
	}
	
	function onTransactionLoad(){
		changeTag = 0;
		initializeAll();
		makeInputFieldUpperCase();
		
		disableSearch("searchIssCd");
		disableSearch("searchLineCd");
		
		disableInputField("dtlIssCd");
		disableInputField("lineCd");
		
		$("tranCd").focus();
		$("txtUserGrp").value = $F("userGrp");
		$("txtUserGrpDesc").value = $F("userGrpDesc");
		$("txtGrpIssCd").value = $F("grpIssCd");
	}
	
	/* 
	   Modified by: hdrtagudin 
	   Date: 07232015 
	   SR No: 18661
	   Description: Replaced getDeletedJSONObjects and getAddedAndModifiedJSONObjects
	   with change tags in checking pending child records.
	*/
	function hasPendingChildRecords(table){		
		try{
			var result = false;
			if(table == "tran"){
	//START hdrtagudin-07232015-SR18661
				result = issChangeTag == 1 ||
				   		 lineChangeTag == 1 ? true : false;
			}else{
				result = lineChangeTag == 1 ? true : false;
			}
	//END hdrtagudin-07232015-SR18661
			return result;
		}catch(e){
			showErrorMessage("hasPendingChildRecords", e);
		}
	}
	
	function getUserGrpDtl(tranCd){
		userGrpDtlTG.url = contextPath + "/GIISUserGroupMaintenanceController?action=getUserGrpDtl&refresh=1"+
							"&userGrp="+$F("userGrp")+"&tranCd="+tranCd;
		userGrpDtlTG._refreshList();
	}
	
	function getUserGrpLine(row){
		var tranCd = row == null ? 0 : row.tranCd;
		var issCd = row == null ? "" : unescapeHTML2(row.issCd);
		
		userGrpLineTG.url = contextPath + "/GIISUserGroupMaintenanceController?action=getUserGrpLine&refresh=1"+
							"&userGrp="+$F("userGrp")+"&tranCd="+tranCd+"&issCd="+encodeURIComponent(issCd);
		userGrpLineTG._refreshList();
	}
	
	function setTranValues(rec){
		try{
			$("tranCd").value = (rec == null ? "" : rec.tranCd);
			$("tranCd").setAttribute("lastValidValue", (rec == null ? "" : $F("tranCd")));
			$("tranDesc").value = (rec == null ? "" : unescapeHTML2(rec.tranDesc));
			
			rec == null ? $("tranCd").readOnly = false : $("tranCd").readOnly = true;
			rec == null ? enableSearch("searchTranCd") : disableSearch("searchTranCd");
			rec == null ? disableButton("btnDeleteTran") : enableButton("btnDeleteTran");
			rec == null ? enableButton("btnAddTran") : disableButton("btnAddTran");
			rec == null ? disableButton("btnModules") : enableButton("btnModules");
			rec == null ? disableButton("btnAllIssCd") : enableButton("btnAllIssCd");
			rec == null ? getUserGrpDtl(0) : getUserGrpDtl(rec.tranCd);
			
			objTran.selectedTran = rec;
		}catch(e){
			showErrorMessage("setTranValues", e);
		}
	}
	
	function setDtlValues(rec){
		try{
			$("dtlIssCd").value = (rec == null ? "" : unescapeHTML2(rec.issCd));
			$("dtlIssCd").setAttribute("lastValidValue", (rec == null ? "" : $F("dtlIssCd")));
			$("dtlIssName").value = (rec == null ? "" : unescapeHTML2(rec.issName));
			
			if(objTran.tranIndex == -1){
				$("dtlIssCd").readOnly = true;
				disableSearch("searchIssCd");
				disableButton("btnDeleteDtl");
				disableButton("btnAddDtl");
				getUserGrpLine(null);
			}else{
				rec == null ? $("dtlIssCd").readOnly = false : $("dtlIssCd").readOnly = true;
				rec == null ? enableSearch("searchIssCd") : disableSearch("searchIssCd");
				rec == null ? disableButton("btnDeleteDtl") : enableButton("btnDeleteDtl");
				rec == null ? enableButton("btnAddDtl") : disableButton("btnAddDtl");
				rec == null ? getUserGrpLine(null) : getUserGrpLine(rec);
			}
			
			objTran.selectedDtl = rec;
		}catch(e){
			showErrorMessage("setDtlValues", e);
		}
	}
	
	function setLineValues(rec){
		try{
			$("lineCd").value = (rec == null ? "" : unescapeHTML2(rec.lineCd));
			$("lineCd").setAttribute("lastValidValue", (rec == null ? "" : $F("lineCd")));
			$("lineName").value = (rec == null ? "" : unescapeHTML2(rec.lineName));
			$("lineUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("lineRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("lineLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			
			if(rec == null){
				if(objTran.dtlIndex != -1){
					$("lineCd").readOnly = false;
					enableSearch("searchLineCd");
					disableButton("btnDeleteLine");
					enableButton("btnAddLine");
				}else{
					$("lineCd").readOnly = true;
					disableSearch("searchLineCd");
					disableButton("btnAddLine");
					disableButton("btnDeleteLine");
					disableButton("btnAllLineCd");
				}
				$("btnAddLine").value = "Add";
			}else{
				$("btnAddLine").value = "Update";
				$("lineCd").readOnly = true;
				disableSearch("searchLineCd");
				enableButton("btnDeleteLine");
			}
			
			if(objTran.dtlIndex != -1){
				enableButton("btnAllLineCd");
				$("lineRemarks").readOnly = false;
			}else{
				disableButton("btnAllLineCd");
				$("lineRemarks").readOnly = true;
			}
			
			objTran.selectedLine = rec;
		}catch(e){
			showErrorMessage("setLineValues", e);
		}
	}
	
	function deleteTran(){
		if(hasPendingChildRecords("tran")){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return false;
		}
		
		changeTagFunc = saveTransactions;
		objTran.selectedTran.recordStatus = -1;
		userGrpTranTG.deleteRow(objTran.tranIndex);
		changeTag = 1;
		userGrpTranTG.onRemoveRowFocus();
	}
	
	function setTran(incAll){
		try{
			var obj = {};
			
			obj.userGrp = $F("userGrp");
			obj.tranCd = $F("tranCd");
			obj.tranDesc = $F("tranDesc");
			obj.incAllTag = incAll == "1" ? "Y" : "N";
			obj.incAllModules = incAll;
			obj.userId = userId;
			
			return obj;
		} catch(e){
			showErrorMessage("setTran", e);
		}
	}
	
	function confirmAddTran(){
		if(checkAllRequiredFieldsInDiv("tranFormDiv")){
			showConfirmBox("Confirmation", "Include all modules of the current transaction?", "Yes", "No",
				function(){
					addTran("1");
				}, 
				function(){
					addTran("2");
				}, "1");
		}
	}
	
	function addTran(incAll){
		try{
			changeTagFunc = saveTransactions;
			userGrpTranTG.addBottomRow(setTran(incAll));
			
			changeTag = 1;
			setTranValues(null);
			userGrpTranTG.keys.removeFocus(userGrpTranTG.keys._nCurrentFocus, true);
			userGrpTranTG.keys.releaseKeys();
		}catch(e){
			showErrorMessage("addTran", e);
		}
	}
	
	function valDeleteDtl(){
		try{
			if(hasPendingChildRecords("dtl")){
				showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
				return false;
			}
			
			new Ajax.Request(contextPath + "/GIISUserGroupMaintenanceController", {
				parameters: {
					action: "valAddDeleteDtl",
					userGrp: $F("userGrp"),
					tranCd: $F("tranCd"),
					issCd: $F("dtlIssCd"),
					addDelete: "delete"
				},
				asynchronous: false,
				evalScripts: true,
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						deleteDtl();
					}
				}
			});
		} catch(e){
			showErrorMessage("valDeleteDtl", e);
		}
	}
	
	function deleteDtl(){
		changeTagFunc = saveTransactions;
		userGrpDtlTG.geniisysRows[objTran.dtlIndex].recordStatus = -1;
		userGrpDtlTG.geniisysRows[objTran.dtlIndex].issCd = escapeHTML2($F("dtlIssCd")); 
		userGrpDtlTG.deleteRow(objTran.dtlIndex);
		issChangeTag = 1;	//hdrtagudin 07232015 SR 18661
		changeTag = 1;
		userGrpDtlTG.onRemoveRowFocus();
	}
	
	function setDtl(rec){
		try{
			var obj = {};
			
			obj.userGrp = $F("txtUserGrp");
			obj.issCd = escapeHTML2($F("dtlIssCd"));
			obj.issName = escapeHTML2($F("dtlIssName"));
			obj.tranCd = $F("tranCd");
			obj.userId = userId;
			
			return obj;
		} catch(e){
			showErrorMessage("setDtl", e);
		}
	}
	
	function addDtl(){
		try{
			if(checkAllRequiredFieldsInDiv("dtlFormDiv")){
				changeTagFunc = saveTransactions;
				userGrpDtlTG.addBottomRow(setDtl());
				issChangeTag = 1;	//hdrtagudin 07232015 SR 18661
				changeTag = 1;
				setDtlValues(null);
				userGrpDtlTG.keys.removeFocus(userGrpDtlTG.keys._nCurrentFocus, true);
				userGrpDtlTG.keys.releaseKeys();
			}
		}catch(e){
			showErrorMessage("addDtl", e);
		}
	}
	
	function valDeleteLine(){
		try{
			new Ajax.Request(contextPath + "/GIISUserGroupMaintenanceController", {
				parameters: {
					action: "valDeleteLine",
					userGrp: $F("userGrp"),
					tranCd: $F("tranCd"),
					issCd: $F("dtlIssCd"),
					lineCd: $F("lineCd")
				},
				asynchronous: false,
				evalScripts: true,
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						deleteLine();
					}
				}
			});
		} catch(e){
			showErrorMessage("valDeleteLine", e);
		}
	}
	
	function deleteLine(){
		changeTagFunc = saveTransactions;
		userGrpLineTG.geniisysRows[objTran.lineIndex].recordStatus = -1;
		userGrpLineTG.geniisysRows[objTran.lineIndex].lineCd = escapeHTML2($F("lineCd"));
		userGrpLineTG.geniisysRows[objTran.lineIndex].issCd = escapeHTML2($F("dtlIssCd"));
		userGrpLineTG.deleteRow(objTran.lineIndex);
		lineChangeTag = 1;	//hdrtagudin 07232015 SR 18661
		changeTag = 1;
		userGrpLineTG.onRemoveRowFocus();
	}
	
	function setLine(rec){
		try{
			var obj = (rec == null ? {} : rec);
			
			obj.userGrp = $F("txtUserGrp");
			obj.lineCd = escapeHTML2($F("lineCd"));
			obj.lineName = escapeHTML2($F("lineName"));
			obj.issCd = escapeHTML2($F("dtlIssCd"));
			obj.remarks = escapeHTML2($F("lineRemarks"));
			obj.tranCd = $F("tranCd");
			obj.userId = userId;
			obj.lastUpdate = dateFormat(new Date(), 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setLine", e);
		}
	}
	
	function addLine(){
		try{
			if(checkAllRequiredFieldsInDiv("lineFormDiv")){
				changeTagFunc = saveTransactions;
				var row = setLine(objTran.selectedLine);
				
				if($F("btnAddLine") == "Add"){
					userGrpLineTG.addBottomRow(row);
				} else {
					userGrpLineTG.updateVisibleRowOnly(row, objTran.lineIndex, false);
				}
				lineChangeTag = 1;	//hdrtagudin 07232015 SR 18661
				changeTag = 1;
				setLineValues(null);
				userGrpLineTG.keys.removeFocus(userGrpLineTG.keys._nCurrentFocus, true);
				userGrpLineTG.keys.releaseKeys();
			}
		}catch(e){
			showErrorMessage("addLine", e);
		}
	}
	
	function saveTransactions(){
		var setTranRows = getAddedAndModifiedJSONObjects(userGrpTranTG.geniisysRows);
		var delTranRows = getDeletedJSONObjects(userGrpTranTG.geniisysRows);
		var setDtlRows = getAddedAndModifiedJSONObjects(userGrpDtlTG.geniisysRows);
		var delDtlRows = getDeletedJSONObjects(userGrpDtlTG.geniisysRows);
		var setLineRows = getAddedAndModifiedJSONObjects(userGrpLineTG.geniisysRows);
		var delLineRows = getDeletedJSONObjects(userGrpLineTG.geniisysRows);
		
		new Ajax.Request(contextPath+"/GIISUserGroupMaintenanceController", {
			method: "POST",
			parameters: {
				action: "saveUserGrpTran",
				setTranRows: prepareJsonAsParameter(setTranRows),
				delTranRows: prepareJsonAsParameter(delTranRows),
				setDtlRows: prepareJsonAsParameter(setDtlRows),
				delDtlRows: prepareJsonAsParameter(delDtlRows),
				setLineRows: prepareJsonAsParameter(setLineRows),
				delLineRows: prepareJsonAsParameter(delLineRows)
			},
			asynchronous: false,
			evalScripts: true,
			onCreate : showNotice("Saving, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objTran.exitTransactions != null) {
							objTran.exitTransactions();
						}
						//START hdrtagudin-07232015-SR18661
						/*
						else{
							userGrpTranTG._refreshList();
						}
						*/
						//END hdrtagudin-07232015-SR18661
					});
					changeTag = 0;
					
					//START hdrtagudin-07232015-SR18661
					tranChangeTag = 0;		
					issChangeTag = 0;
					lineChangeTag = 0;
					
					for (var i = 0; i < userGrpTranTG.geniisysRows.length; i++) {
						userGrpTranTG.geniisysRows[i].recordStatus = '';
					}

					for (var i = 0; i < userGrpDtlTG.geniisysRows.length; i++) {
						userGrpDtlTG.geniisysRows[i].recordStatus = '';
					}

					for (var i = 0; i < userGrpLineTG.geniisysRows.length; i++) {
						userGrpLineTG.geniisysRows[i].recordStatus = '';
					}
					//END hdrtagudin-07232015-SR18661
				}
			}
		});
	}
	
	function addIssCodes(rows){
		for(var i = 0; i < rows.length; i++){
			var obj = {};
			obj.userGrp = $F("txtUserGrp");
			obj.issCd = escapeHTML2(rows[i].issCd);
			obj.issName = escapeHTML2(rows[i].issName);
			obj.tranCd = $F("tranCd");
			obj.userId = userId;
			
			userGrpDtlTG.addBottomRow(obj);
		}
		changeTagFunc = saveTransactions;
		changeTag = 1;
		issChangeTag = 1;	//hdrtagudin 07232015 SR 18661
		setDtlValues(null);
		userGrpDtlTG.keys.removeFocus(userGrpDtlTG.keys._nCurrentFocus, true);
		userGrpDtlTG.keys.releaseKeys();
	}
	
	function getAllIssCodes(){
		if(hasPendingChildRecords("dtl")){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return;
		}
		
		new Ajax.Request(contextPath+"/GIISUserGroupMaintenanceController", {
			method: "GET",
			parameters: {
				action: "getAllIssCodes",
				userGrp: $F("userGrp"),
				tranCd: $F("tranCd"),
				grpIssCd: $F("txtGrpIssCd"),
				notIn: createNotInParam("detail", userGrpDtlTG.geniisysRows, 0),
				notInDeleted: createNotInParam("detail", userGrpDtlTG.geniisysRows, -1),
			},
			asynchronous: false,
			evalScripts: true,
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					addIssCodes(eval(response.responseText));
				}
			}
		});
	}
	
	function addLineCodes(rows){
		for(var i = 0; i < rows.length; i++){
			var obj = {};
			obj.userGrp = $F("txtUserGrp");
			obj.lineCd = escapeHTML2(rows[i].lineCd);
			obj.lineName = escapeHTML2(rows[i].lineName);
			obj.issCd = escapeHTML2($F("dtlIssCd"));
			obj.tranCd = $F("tranCd");
			obj.userId = userId;
			obj.lastUpdate = dateFormat(new Date(), 'mm-dd-yyyy hh:MM:ss TT');
			
			userGrpLineTG.addBottomRow(obj);
		}
		changeTagFunc = saveTransactions;
		changeTag = 1;
		lineChangeTag = 1;	//hdrtagudin 07232015 SR 18661
		setLineValues(null);
		userGrpLineTG.keys.removeFocus(userGrpLineTG.keys._nCurrentFocus, true);
		userGrpLineTG.keys.releaseKeys();
	}
	
	function getAllLineCodes(){
		new Ajax.Request(contextPath+"/GIISUserGroupMaintenanceController", {
			method: "GET",
			parameters: {
				action: "getAllLineCodes",
				userGrp: $F("userGrp"),
				tranCd: $F("tranCd"),
				issCd: $F("dtlIssCd"),
				notIn: createNotInParam("line", userGrpLineTG.geniisysRows, 0),
				notInDeleted: createNotInParam("line", userGrpLineTG.geniisysRows, -1)
			},
			asynchronous: false,
			evalScripts: true,
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					addLineCodes(eval(response.responseText));
				}
			}
		});
	}
	
	function showModulesOverlay(){
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return;
		}else{
			moduleOverlay = Overlay.show(contextPath+"/GIISUserGroupMaintenanceController", {
				urlParameters: {
					action: "showModulesOverlay",
					userGrp: $F("txtUserGrp"),
					tranCd: $F("tranCd")
				},
				showNotice: true,
				urlContent: true,
				draggable: true,
			    title: "Modules",
			    height: 555,
			    width: 615
			});
		}
	}
	
	function reloadTransactions(){
		new Ajax.Request(contextPath + "/GIISUserGroupMaintenanceController", {
			parameters: {
				action: "showUserGrpTransactions",
				userGrp: $F("userGrp")
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: showNotice("Retrieving User Group Transactions, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					changeTag = 0;
					$("userGrpTranDiv").update(response.responseText);
				}
			}
		});
	}
	
	function exitTransactions(){
		changeTag = 0;
		$("userGrpTranDiv").innerHTML = "";
		$("giiss041MainDiv").show();
	}
	
	function cancelTransactions(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
				function(){
					objTran.exitTransactions = exitTransactions;
					saveTransactions();
				}, exitTransactions, "");
		} else {
			exitTransactions();
		}
	}
	
	$("tranCd").observe("change", function(){
		if($F("tranCd") != "" && (isNaN($F("tranCd")) || parseInt($F("tranCd")) < 1  || $F("tranCd").include("."))){
			showWaitingMessageBox("Invalid Transaction Code. Valid value should be from 1 to 99.", "E", function(){
				$("tranCd").value = $("tranCd").getAttribute("lastValidValue");
			});
		}else if($F("tranCd") == ""){
			$("tranCd").setAttribute("lastValidValue", "");
			$("tranDesc").value = "";
		}else if($F("tranCd") != ""){
			showTranLOV();
		}
	});
	
	$("dtlIssCd").observe("change", function(){
		if($F("dtlIssCd") == ""){
			$("dtlIssCd").setAttribute("lastValidValue", "");
			$("dtlIssName").value = "";
		}else{
			showIssCdLOV();
		}
	});
	
	$("lineCd").observe("change", function(){
		if($F("lineCd") == ""){
			$("lineCd").setAttribute("lastValidValue", "");
			$("lineName").value = "";
		}else{
			showLineCdLOV();
		}
	});
	
	$("editLineRemarks").observe("click", function(){
		showOverlayEditor("lineRemarks", 4000, $("lineRemarks").hasAttribute("readonly"));
	});
	
	$("searchTranCd").observe("click", showTranLOV);
	$("searchIssCd").observe("click", showIssCdLOV);
	$("searchLineCd").observe("click", showLineCdLOV);	
	$("btnAddTran").observe("click", confirmAddTran);
	$("btnDeleteTran").observe("click", deleteTran);
	$("btnAddDtl").observe("click", addDtl);
	$("btnDeleteDtl").observe("click", valDeleteDtl);
	$("btnAllIssCd").observe("click", getAllIssCodes);
	$("btnAddLine").observe("click", addLine);
	$("btnDeleteLine").observe("click", valDeleteLine);
	$("btnAllLineCd").observe("click", getAllLineCodes);
	$("btnModules").observe("click", showModulesOverlay);
	$("btnTranCancel").observe("click", cancelTransactions);
	$("btnTranExit").observe("click", cancelTransactions);
	
	observeSaveForm("btnTranSave", saveTransactions);
	observeReloadForm("tranReloadForm", reloadTransactions);
	onTransactionLoad();
</script>