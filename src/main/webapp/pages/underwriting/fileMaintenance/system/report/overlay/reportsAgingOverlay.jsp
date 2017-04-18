<div id="reportsAgingMainDiv">
	<div>
		<div class="sectionDiv" style="width: 700px; margin: 10px 10px 2px 10px;">
			<table align="center" style="margin-top:15px; margin-bottom: 15px; width: 500px;">
				<tr>
					<td class="rightAligned">Report ID</td>
					<td class="leftAligned">
						<input type="text" id="txtReportIdAging" readonly="readonly" style="width: 100px; margin-left: 5px;" tabindex="101" />
						<input type="text" id="txtReportTitleAging" readonly="readonly" style="width: 300px;" tabindex="102" />
					</td>					
				</tr>
			</table>
		</div>
		
		<div class="sectionDiv" style="width: 700px; margin: 0 10px 2px 10px;">
			<div id="reportsAgingTableDiv" name="reportsAgingTableDiv">
				<div id="reportsAgingTable"  style="height: 210px; margin: 10px 10px 10px 10px;"></div>
				<div id="reportAgingFields">
					<table style="width: 680px; margin: 10px 10px 0 10px;">
						<tr>
							<td class="rightAligned">Branch Code</td>
							<td class="leftAligned" colspan="3">
								<span class="lovSpan required" style="float: left; width: 100px; margin-right: 5px; margin-top: 2px; margin-left: 5px;height: 21px;">
									<input class="required" type="text" id="txtBranchCd" name="txtBranchCd" style="width: 75px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="103" lastValidValue=""/>
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchBranchCd" name="imgSearchBranchCd" alt="Go" style="float: right;" tabindex="104"/>
								</span>
								<input id="txtBranchName" name="txtBranchName" type="text" style="width: 410px;" value="" readonly="readonly" tabindex="105" />
							</td>
						</tr>
						<tr>
							<td class="rightAligned">Column No</td>
							<td class="leftAligned"><input type="text" id="txtColumnNo" class="required integerNoNegativeUnformatted" maxlength="2" tabindex="106" style="margin-left: 5px; width: 170px; text-align: right;" />
							<td class="rightAligned">Column Title</td>
							<td class="leftAligned"><input type="text" id="txtColumnTitle" class="required" maxlength="20" tabindex="107" style="width: 170px; margin-left: 5px;" />
						</tr>
						<tr>
							<td class="rightAligned">Min. No. of Days</td>
							<td class="leftAligned"><input type="text" id="txtMinDays" class="required integerNoNegativeUnformatted" maxlength="5" tabindex="108" style="width: 170px; text-align: right; margin-left: 5px;" />
							<td class="rightAligned">Max. No. of Days</td>
							<td class="leftAligned"><input type="text" id="txtMaxDays" class="required integerNoNegativeUnformatted" maxlength="5" tabindex="109" style="width: 170px; text-align: right; margin-left: 5px;" />
						</tr>
						<tr>
							<td class="rightAligned">User ID</td>
							<td class="leftAligned"><input type="text" id="txtUserIdAging" readonly="readonly" style="width: 170px; margin-left: 5px;" tabindex="110" />
							<td class="rightAligned">Last Update</td>
							<td class="leftAligned"><input type="text" id="txtLastUpdateAging" readonly="readonly" style="width: 170px; margin-left: 5px;" tabindex="111" />
						</tr>
					</table>
				</div>
				<div class="buttonsDiv" style="width: 700px; margin: 10px 0 10px 0;">
					<input type="button" class="button" id="btnReportAgingAdd" value="Add" tabindex="201" />
					<input type="button" class="button" id="btnReportAgingDelete" value="Delete" tabindex="202" />					
				</div>
			</div>
		</div>
	</div>
	<div class="buttonsDiv" style="width: 700px; margin: 10px 10px 2px 10px;">
		<input type="button" class="button" id="btnReportAgingReturn" value="Cancel" tabindex="203" />
		<input type="button" class="button" id="btnReportAgingSave" value="Save" tabindex="204" />
	</div>
</div>

<script type="text/javascript">

	function saveGiiss090Aging(){
		if(changeTag == 0) {
			//changeTag = objGIISS090.parentChangeTag;
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgReportsAging.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgReportsAging.geniisysRows);
		new Ajax.Request(contextPath+"/GIISReportsAgingController", {
			method: "POST",
			parameters : {action : "saveGiiss090Aging",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS090.exitPage != null) {
							//added to save changes to parent details
							if(objGIISS090.parentChangeTag == 1){
								changeTag = 1;
								objGIISS090.parentSaveFunc();
							}// end
							objGIISS090.exitPage();
						} else {
							//added to save changes to parent details
							if(objGIISS090.parentChangeTag == 1){
								changeTag = 1;
								objGIISS090.parentSaveFunc();
							}// end
							
							tbgReportsAging._refreshList();
						}
					});
					changeTag = 0;					
				}
			}
		});
	}
	
	initializeAll();
	changeTag = 0;
	$("txtReportIdAging").value = unescapeHTML2(objGIISS090.reportId);
	$("txtReportTitleAging").value = unescapeHTML2(objGIISS090.reportTitle);
	
	//var objGIISS090 = {};
	var objCurrReportAging = null;
	objGIISS090.reportsAgingList = JSON.parse('${jsonReportsAgingList}');
	
	var reportsAgingTable = {
			url : contextPath + "/GIISReportsAgingController?action=showReportAging&refresh=1&reportId="+encodeURIComponent($F("txtReportIdAging")),
			options : {
				width : '680px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrReportAging = tbgReportsAging.geniisysRows[y];
					setFieldValues(objCurrReportAging);
					tbgReportsAging.keys.removeFocus(tbgReportsAging.keys._nCurrentFocus, true);
					tbgReportsAging.keys.releaseKeys();
					$("txtBranchCd").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgReportsAging.keys.removeFocus(tbgReportsAging.keys._nCurrentFocus, true);
					tbgReportsAging.keys.releaseKeys();
					$("txtBranchCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgReportsAging.keys.removeFocus(tbgReportsAging.keys._nCurrentFocus, true);
						tbgReportsAging.keys.releaseKeys();
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
					tbgReportsAging.keys.removeFocus(tbgReportsAging.keys._nCurrentFocus, true);
					tbgReportsAging.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgReportsAging.keys.removeFocus(tbgReportsAging.keys._nCurrentFocus, true);
					tbgReportsAging.keys.releaseKeys();
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
					tbgReportsAging.keys.removeFocus(tbgReportsAging.keys._nCurrentFocus, true);
					tbgReportsAging.keys.releaseKeys();
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
					id : "reportId",
					width : '0',
					visible : false
				},{
					id : 'branchCd',
					title: 'Branch',
					width : '80px',
					filterOption: true				
				},{
					id : 'columnNo',
					title: 'Column No.',
					titleAlign: 'right',
					align: 'right',
					width : '80px',
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},{
					id : 'columnTitle',
					title: 'Column Title',
					width : '280px',
					filterOption: true
				},{
					id : 'minDays',
					title: 'Min. No. of Days',
					titleAlign: 'right',
					align: 'right',
					width : '100px',
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},{
					id : 'maxDays',
					title: 'Max. No. of Days',
					titleAlign: 'right',
					align: 'right',
					width : '100px',
					filterOption: true,
					filterOptionType: 'integerNoNegative'				
				},{
					id : 'userId',
					width : '0',
					visible: false
				},{
					id : 'lastUpdate',
					width : '0',
					visible: false				
				}
			],
			rows : objGIISS090.reportsAgingList.rows || []
		};

		tbgReportsAging = new MyTableGrid(reportsAgingTable);
		tbgReportsAging.pager = objGIISS090.reportsAgingList;
		tbgReportsAging.render("reportsAgingTable");
	
	function setFieldValues(rec){
		try{
			$("txtBranchCd").value = (rec == null ? "" : unescapeHTML2(rec.branchCd));
			$("txtBranchCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.branchCd)));
			$("txtBranchName").value = (rec == null ? "" : unescapeHTML2(rec.branchName));
			$("txtColumnNo").value = (rec == null ? "" : rec.columnNo);
			$("txtColumnTitle").value = (rec == null ? "" : unescapeHTML2(rec.columnTitle));
			$("txtMinDays").value = (rec == null ? "" : rec.minDays);
			$("txtMaxDays").value = (rec == null ? "" : rec.maxDays);
			
			$("txtUserIdAging").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdateAging").value = (rec == null ? "" : rec.lastUpdate);
			
			rec == null ? $("btnReportAgingAdd").value = "Add" : $("btnReportAgingAdd").value = "Update";
			rec == null ? $("txtBranchCd").readOnly = false : $("txtBranchCd").readOnly = true;
			rec == null ? enableSearch("imgSearchBranchCd") : disableSearch("imgSearchBranchCd");
			rec == null ? $("txtColumnNo").readOnly = false : $("txtColumnNo").readOnly = true;
			rec == null ? disableButton("btnReportAgingDelete") : enableButton("btnReportAgingDelete");
			objCurrReportAging = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	function showIssCdLOV(){
		LOV.show({
			controller: "UnderwritingLOVController", //"AccountingLOVController",
			urlParameters: {action : "getIssCdNameLOV", //"getAllIssourceLOV", 
							moduleId :  "GIISS090",
							filterText : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : "%"),
							page : 1},
			title: "List of Branches",
			width: 440,
			height: 400,
			columnModel : [
							{
								id : "issCd",
								title: "Code",
								width: '100px',
								filterOption: true
							},
							{
								id : "issName",
								title: "Branch",
								width: '325px'
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : "%"),
				onSelect: function(row) {
					$("txtBranchCd").value = row.issCd;
					$("txtBranchName").value = row.issName;
					$("txtBranchCd").setAttribute("lastValidValue", row.issCd);								
				},
				onCancel: function (){
					$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	function exitPage(){
		returnToMain();
	}
	
	function cancelGiiss090Aging(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS090.exitPage = exitPage;
						saveGiiss090Aging();
					}, function(){
						returnToMain();
					}, "");
		} else {
			returnToMain();
		}
	}
	
	function returnToMain(){
		if(objGIISS090.parentChangeTag == 1){
			changeTag = 1;
		}
		reportAgingOverlay.close();
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.reportId = escapeHTML2($F("txtReportIdAging"));
			obj.branchCd = escapeHTML2($F("txtBranchCd"));
			obj.branchName = escapeHTML2($F("txtBranchName"));
			obj.columnNo = escapeHTML2($F("txtColumnNo"));
			obj.columnTitle = escapeHTML2($F("txtColumnTitle"));
			obj.minDays = escapeHTML2($F("txtMinDays"));
			obj.maxDays = escapeHTML2($F("txtMaxDays"));
			
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	function addRec(){
		try {
			changeTagFunc = saveGiiss090Aging;
			var dept = setRec(objCurrReportAging);
			if($F("btnReportAgingAdd") == "Add"){
				tbgReportsAging.addBottomRow(dept);
			} else {
				tbgReportsAging.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgReportsAging.keys.removeFocus(tbgReportsAging.keys._nCurrentFocus, true);
			tbgReportsAging.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("reportAgingFields")){
				if($F("btnReportAgingAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;
					
					for(var i=0; i<tbgReportsAging.geniisysRows.length; i++){
						if(tbgReportsAging.geniisysRows[i].recordStatus == 0 || tbgReportsAging.geniisysRows[i].recordStatus == 1){	
							if(tbgReportsAging.geniisysRows[i].reportId == $F("txtReportIdAging") 
									&& tbgReportsAging.geniisysRows[i].branchCd == $F("txtBranchCd")
									&& tbgReportsAging.geniisysRows[i].columnNo == $F("txtColumnNo")){
								addedSameExists = true;
							}
						} else if(tbgReportsAging.geniisysRows[i].recordStatus == -1){
							if(tbgReportsAging.geniisysRows[i].reportId == $F("txtReportIdAging")
									&& tbgReportsAging.geniisysRows[i].branchCd == $F("txtBranchCd")
									&& tbgReportsAging.geniisysRows[i].columnNo == $F("txtColumnNo")){
								deletedSameExists = true;
							}
						}
					}
					// in cs, no validation for duplicate records. This is for SA Checking.
					// As per Ma'am Jhing, report_id, branch_cd, and column_no will be treated as primary keys in this module.
					// So, validate records if there are duplicate records based on the primary keys.
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same report_id, branch_cd, and column_no.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIISReportsAgingController", {
						parameters : {action : "valAddRec",
									  reportId : $F("txtReportIdAging"),
									  branchCd: $F("txtBranchCd"),
									  columnNo: $F("txtColumnNo")},
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
	
	function deleteRec(){
		changeTagFunc = saveGiiss090Aging;
		objCurrReportAging.recordStatus = -1;
		tbgReportsAging.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISReportsAgingController", {
				parameters : {action : "valDeleteRec",
							  reportId : $F("txtReportIdAging"),
							  branchCd: $F("txtBranchCd"),
							  columnNo: $F("txtColumnNo"),
							  columnTitle: $F("txtColumnTitle"),
							  minDays: $F("txtMinDays"),
							  maxDays: $F("txtMaxDays")},
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
	
	function validateMinMaxDays(elemId){
		if($F("txtMinDays") != "" && $F("txtMaxDays") != ""){
			var minDays = parseInt($F("txtMinDays"));
			var maxDays = parseInt($F("txtMaxDays"));
			
			if(maxDays < minDays){
				customShowMessageBox("Minimum no. of days should not be greater than Maximum no. of days.", "I", elemId);
				$(elemId).clear();				
			}
		}
	}
		
	$("imgSearchBranchCd").observe("click", showIssCdLOV);
	
	disableButton("btnReportAgingDelete");
	$("txtBranchCd").focus();
	
	$("txtBranchCd").observe("change", function() {
		if($F("txtBranchCd").trim() == "") {
			$("txtBranchCd").value = "";
			$("txtBranchCd").setAttribute("lastValidValue", "");
			$("txtBranchName").value = "";
		} else {
			if($F("txtBranchCd").trim() != "" && $F("txtBranchCd") != $("txtBranchCd").readAttribute("lastValidValue")) {
				showIssCdLOV();
			}
		}
	});
	$("txtBranchCd").observe("keyup", function() {
		$("txtBranchCd").value = $F("txtBranchCd").toUpperCase();
	});
	
	$("txtColumnTitle").observe("keyup", function() {
		$("txtColumnTitle").value = $F("txtColumnTitle").toUpperCase();
	});
	
	$("txtMinDays").observe("change", function(){validateMinMaxDays('txtMinDays');});
	$("txtMaxDays").observe("change", function(){validateMinMaxDays('txtMaxDays');});
	
	observeSaveForm("btnReportAgingSave", saveGiiss090Aging);
	$("btnReportAgingReturn").observe("click", cancelGiiss090Aging);
	$("btnReportAgingAdd").observe("click", valAddRec);
	$("btnReportAgingDelete").observe("click", valDeleteRec);
</script>