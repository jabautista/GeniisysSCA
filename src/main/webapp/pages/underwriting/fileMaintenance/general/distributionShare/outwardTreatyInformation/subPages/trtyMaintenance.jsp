<div id="trtyTableDiv" style="padding-top: 15px;">
	<div id="trtyTable" style="height: 335px; padding: 0 37px 0 37px;"></div>
</div>
<div align="center" id="trtyPanelFormDiv">
	<table style="margin-top: 5px;">
		<tr>
			<td class="rightAligned">Reinsurer</td>
			<td class="leftAligned">
				<span class="lovSpan required" style="width: 205px; height: 21px; margin: 2px 2px 0 0; float: left;">
					<input type="text" id="txtVesselCd" name="txtVesselCd" style="width: 173px; float: left; border: none; height: 13px;" class="required allCaps" maxlength="20" tabindex="202" />
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchAirTypeCd" name="searchAirTypeCd" alt="Go" style="float: right;">
				</span>
			</td>
			<td class="rightAligned">Parent RI</td>
			<td class="leftAligned">
				<span class="lovSpan required" style="width: 205px; height: 21px; margin: 2px 2px 0 0; float: left;">
					<input type="text" id="txtAirType" name="txtAirType" style="width: 173px; float: left; border: none; height: 13px;" class="required allCaps" maxlength="20" tabindex="202" />
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchAirTypeCd" name="searchAirTypeCd" alt="Go" style="float: right;">
				</span> 
			</td>
		</tr>	
		<tr>
			<td width="" class="rightAligned">RI Comm %</td>
			<td class="leftAligned">
				<input id="txtVesselName" type="text" class="required allCaps" style="width: 200px; text-align: left;" tabindex="204" maxlength="15">
			</td>
			<td width="" class="rightAligned">Funds Held %</td>
			<td class="leftAligned">
				<input id="txtVesselName" type="text" class="required allCaps" style="width: 200px; text-align: left;" tabindex="204" maxlength="15">
			</td>
		</tr>	
		<tr>
			<td class="rightAligned">Treaty Share %</td>
			<td class="leftAligned">
				<input id="txtRPCNo" type="text" class="required allCaps" style="width: 200px; text-align: left;" tabindex="204" maxlength="15">
			</td>
			<td class="rightAligned">Treaty Share Amount</td>
			<td class="leftAligned">
				<input id="txtYearBuilt" type="text" class="integerNoNegativeUnformattedNoComma rightAligned"  style="width: 200px;" tabindex="205" maxlength="4">
			</td>
		</tr>
		<tr>
			<td width="" class="rightAligned">Remarks</td>
			<td class="leftAligned" colspan="3">
				<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
					<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="209"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="210"/>
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">User ID</td>
			<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="211"></td>
			<td width="" class="rightAligned">Last Update</td>
			<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="212"></td>
		</tr>			
	</table>
</div>
<div style="margin: 10px;" align="center">
	<input type="button" class="button" id="btnAdd2" value="Add" tabindex="213">
	<input type="button" class="button" id="btnDelete2" value="Delete" tabindex="214">
</div>
<script type="text/javascript">	
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiiss031(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgTreaty.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgTreaty.geniisysRows);
		new Ajax.Request(contextPath+"/GIISTrtyPanelController", {
			method: "POST",
			parameters : {action : "saveGiiss031",
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
							tbgTreaty._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGIISS049);
	
	var objGIISS031 = {};
	var objCurrTrty = null;
	//objGIISS031.trtyList = JSON.parse('${jsonTrty}');
	objGIISS031.exitPage = null;
	
	var trtyTable = {
			url : contextPath + "/GIISTrtyPanelController?action=showGiiss031Np&refresh=1&lineCd="+'${lineCd}'+"&trtyYy="+'${trtyYy}'+"&shareCd="+'${shareCd}',
			options : {
				width : '850px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrTrty = tbgTreaty.geniisysRows[y];
					setFieldValues(objCurrTrty);
					tbgTreaty.keys.removeFocus(tbgTreaty.keys._nCurrentFocus, true);
					tbgTreaty.keys.releaseKeys();
					$("txtVesselName").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgTreaty.keys.removeFocus(tbgTreaty.keys._nCurrentFocus, true);
					tbgTreaty.keys.releaseKeys();
					$("txtVesselCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
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
					rowIndex = -1;
					setFieldValues(null);
					tbgTreaty.keys.removeFocus(tbgTreaty.keys._nCurrentFocus, true);
					tbgTreaty.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
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
					rowIndex = -1;
					setFieldValues(null);
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
					title : "Aircraft Code",
					filterOption : true,
					width : '120px'
				},
				{
					id : 'vesselName',
					filterOption : true,
					title : 'Aircraft Name',
					width : '460px'				
				},
				{
					id : 'airDesc',
					title : "Air Type",
					filterOption : true,
					width : '130px'
				},
				{
					id : 'rpcNo',
					title : "RPC No.",
					filterOption : true,
					width : '120px'
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
			rows : []//objGIISS031.trtyList.rows
		};

		tbgTreaty = new MyTableGrid(trtyTable);
		//tbgTreaty.pager = objGIISS031.trtyList;
		tbgTreaty.render("trtyTable");
	
	function setFieldValues(rec){
		try{
			$("txtVesselCd").value = 		(rec == null ? "" : rec.vesselCd);
			$("txtVesselCd").setAttribute("lastValidValue", (rec == null ? "" : rec.vesselCd));
			$("txtAirType").value = 		(rec == null ? "" : unescapeHTML2(rec.airDesc));
			$("txtVesselName").value = 		(rec == null ? "" : unescapeHTML2(rec.vesselName));
			$("txtRPCNo").value = 			(rec == null ? "" : unescapeHTML2(rec.rpcNo));
			$("txtYearBuilt").value = 		(rec == null ? "" : rec.yearBuilt);
			$("txtUserId").value = 			(rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = 		(rec == null ? "" : dateFormat(rec.lastUpdate, 'mm-dd-yyyy hh:MM:ss TT'));
			$("txtRemarks").value = 		(rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtVesselCd").readOnly = false : $("txtVesselCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			
			objCurrTrty = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.vesselCd = $F("txtVesselCd");
			obj.airTypeCd = objGIISS031.airTypeCd; 
			obj.airDesc = $F("txtAirType");
			obj.vesselName = $F("txtVesselName");
			obj.rpcNo = $F("txtRPCNo");
			obj.yearBuilt = $F("txtYearBuilt");
			obj.remarks = $F("txtRemarks");
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
			changeTagFunc = saveGiiss031;
			var dept = setRec(objCurrTrty);
			if($F("btnAdd") == "Add"){
				tbgTreaty.addBottomRow(dept);
			} else {
				tbgTreaty.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgTreaty.keys.removeFocus(tbgTreaty.keys._nCurrentFocus, true);
			tbgTreaty.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("trtyPanelFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;	
					
					for ( var i = 0; i < tbgTreaty.geniisysRows.length; i++) {
						if (tbgTreaty.geniisysRows[i].recordStatus == 0 || tbgTreaty.geniisysRows[i].recordStatus == 1) {
							if (tbgTreaty.geniisysRows[i].vesselCd == $F("txtVesselCd")) {
								addedSameExists = true;
							}
						} else if (tbgTreaty.geniisysRows[i].recordStatus == -1) {
							if (tbgTreaty.geniisysRows[i].vesselCd == $F("txtVesselCd")) {
								deletedSameExists = true;
							}
						}
					}
					if ((addedSameExists && !deletedSameExists)|| (deletedSameExists && addedSameExists)) {
						showMessageBox("Record already exists with the same vessel_cd.", "E");
						return;
					} else if (deletedSameExists && !addedSameExists) {
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIISTrtyPanelController", {
						parameters : {
							action : "valAddRec",
							vesselCd : $F("txtVesselCd")
						},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response) {
							hideNotice();
							if (checkErrorOnResponse(response)
									&& checkCustomErrorOnResponse(response)) {
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
		tbgTreaty.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}

	function exitPage() {
		if (objMKGlobal.callingForm == "GIIMM009") {
			showQuotationCarrierInfoPage();  //added by steven 12.09.2013
			$("mainNav").show();
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}

	function cancelGiiss049() {
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
	
	observeSaveForm("btnSave", saveGiiss031);
	$("btnCancel").observe("click", cancelGiiss049);
	//$("btnAdd").observe("click", valAddRec);
	$("btnDelete2").observe("click", deleteRec);
</script>