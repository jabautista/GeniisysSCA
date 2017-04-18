<div id="warrClaDiv" name="warrClaDiv" style="width: 660px; font-size: 11px;">
	<div class="sectionDiv" style="width: 640px; margin: 10px; margin-bottom: 0px; height:50px;">
		<div style="margin: 10px;"" align="center" id="lineDiv">
			<table cellspacing="2" border="0">	 			
				<tr>
					<td class="rightAligned" style="" id="">Group Code</td>
					<td class="leftAligned" colspan="3">
						<input id="txtGroup" name="txtGroup" type="text" style="width: 60px; text-align: right;" value="" readonly="readonly" tabindex="300"/>
						<input id="txtGroupName" name="txtGroupName" type="text" style="width: 280px;" value="" readonly="readonly" tabindex="301"/>
					</td>						
				</tr>
			</table>			
		</div>	
	</div>
	<div class="sectionDiv" style="width: 640px; margin: 10px; height:380px; margin-top: 2px;">
		<div id="perilTable" style="height: 230px; margin: 10px;"></div>
		<div id="perilDivForm" name="perilDivForm" style="width: 640px;" align="center">
			<table>	 			
				<tr>
					<td class="rightAligned">Peril Code</td>
					<td class="leftAligned" colspan="3">
						<span class="lovSpan required" style="float: left; width: 85px; margin-right: 5px; margin-top: 2px; height: 21px;">
							<input class="required integerNoNegativeUnformattedNoComma" type="text" id="txtPerilCode" name="txtPerilCode" style="width: 60px; float: left; border: none; height: 15px; margin: 0; text-align: right;" maxlength="5" tabindex="302" lastValidValue=""/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchPerilLOV" name="searchPerilLOV" alt="Go" style="float: right;" tabindex="303"/>
						</span>
						<input id="txtPerilName" name="txtPerilName" type="text" style="width: 357px; height: 15px;" value="" readonly="readonly" tabindex="304" lastValidValue=""/>
					</td>						
				</tr>
				<tr>
					<td class="rightAligned">Remarks</td>
					<td class="leftAligned" colspan="3">
						<div id="remarksDiv" name="remarksDiv" style="width: 455px; border: 1px solid gray; height: 22px;">
							<textarea style="float: left; height: 16px; width: 429px; margin-top: 0; border: none; resize: none;" id="txtDtlRemarks" name="txtPerilRemarks" maxlength="2000" onkeyup="limitText(this,2000);" tabindex="305"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editPerilRemarks"  tabindex="306"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">User ID</td>
					<td class="leftAligned"><input id="txtDtlUserId" type="text" class="" style="width: 185px;" readonly="readonly" tabindex="307"></td>
					<td width="" class="rightAligned">Last Update</td>
					<td class="leftAligned"><input id="txtDtlLastUpdate" type="text" class="" style="width: 185px;" readonly="readonly" tabindex="308"></td>
				</tr>	
			</table>		
			<div align="center">
				<table width="580px">
					<td class="rightAligned"><input type="button" class="button" style="width: 80px; margin-top: 10px;" id="btnAddPeril" name="btnAddPeril" value="Add" tabindex="309"/></td>
					<td><input type="button" class="button" style="width: 80px; margin-top: 10px;" id="btnDeletePeril" name="btnDeletePeril" value="Delete" tabindex="310"/></td>
				</table>
			</div>
		</div>
		<div style="margin-top: 5px;" align="center">
			<table width="580px">
				<td class="rightAligned"><input type="button" class="button" style="width: 100px; margin-top: 10px;" id="btnCancelPeril" name="btnCancelPeril" value="Cancel" tabindex="311"/></td>
				<td><input type="button" class="button" style="width: 100px; margin-top: 10px;" id="btnSavePeril" name="btnSavePeril" value="Save" tabindex="312"/></td>
			</table>
		</div>
	</div>
</div>

<script type="text/JavaScript">
	initializeAll();
	initializeAccordion();
	makeInputFieldUpperCase();
	changeTag = 0;
	var rowIndex = -1;
	objGIISS213.exitPerilPage = null;
	var objPerilMain = null;
	
	$("txtGroup").value = $F("txtGroupCode");
	$("txtGroupName").value = $F("txtGroupDesc");

	function saveGiiss213Dtl() {
		if (changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(perilTableGrid.geniisysRows);
		var delRows = getDeletedJSONObjects(perilTableGrid.geniisysRows);
		new Ajax.Request(contextPath + "/GIISPerilGroupController", {
			method : "POST",
			parameters : {
				action : "saveGiiss213Dtl",
				setRows : prepareJsonAsParameter(setRows),
				delRows : prepareJsonAsParameter(delRows)
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete : function(response) {
				hideNotice();
				if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)) {
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function() {
						if (objGIISS213.exitPerilPage != null) {
							objGIISS213.exitPerilPage();
							objGIISS213.exitPerilPage = null;
						} else {
							perilTableGrid._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	try {
		var row = 0;
		var objPeriDtllMaintenance = [];
		var objPeril = new Object();
		objPeril.objPerilListing = JSON.parse('${jsonAttachedPerilGroupList}'.replace(/\\/g, '\\\\'));
		objPeril.objPerilMaintain = objPeril.objPerilListing.rows || [];

		var periTable = {
			 url : contextPath+"/GIISPerilGroupController?action=getAttachedPerils&refresh=1"
			 					+ "&lineCd=" + $F("txtLineCd") + "&perilGrpCd=" + $F("txtGroupCode"),
			options : {
				width : '620px',
				height : '200px',
				onCellFocus : function(element, value, x, y, id) {
					row = y;
					objPerilMain = perilTableGrid.geniisysRows[y];
					perilTableGrid.keys.releaseKeys();
					populatePerilInfo(objPerilMain);
				},
				onRemoveRowFocus : function() {
					onRemove();
				},
				beforeSort : function() {
					if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
                	}
				},
				onSort : function() {
					onRemove();
				},
				prePager: function(){
	            	if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
                	} else {	          
                		onRemove();
                	}
                },
                onRefresh: function(){
                	onRemove();
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
				},
				toolbar : {
					elements : [ MyTableGrid.REFRESH_BTN,MyTableGrid.FILTER_BTN ],
					onFilter : function() {
						if (changeTag == 1){
	                		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
							return false;
	                	} else {
	                		onRemove();
	                	}
					}
				}
			},
			columnModel : [ {
				id : 'recordStatus',
				title : '',
				width : '0',
				visible : false,
				editor : 'checkbox'
			}, {
				id : 'divCtrId',
				width : '0',
				visible : false
			}, {
				id : 'lineCd',
				width : '0',
				visible : false
			}, {
				id : 'perilCd',
				title : 'Peril Code',
				width : '100px',
				visible : true,
				filterOption : true,
				filterOptionType : 'integerNoNegative',
				align : 'right',
				titleAlign : 'right'
			}, {
				id : 'perilName',
				title : 'Peril Name',
				titleAlign: 'left',
				width : '490px',
				visible : true,
				filterOption : true
			},{
				id : "perilGrpCd",
				width : '0',
				visible : false
			}, {
				id : 'perilGrpDesc',
				width : '0',
				visible : false
			}, {
				id : 'remarks',
				width : '0',
				visible : false
			}, {
				id : 'userId',
				width : '0',
				visible : false
			}, {
				id : 'lastUpdate',
				width : '0',
				visible : false
			}],
			rows : objPeril.objPerilMaintain
		};
		perilTableGrid = new MyTableGrid(periTable);
		perilTableGrid.pager = objPeril.objPerilListing;
		perilTableGrid.render('perilTable');
		perilTableGrid.afterRender = function() {
			objPeriDtllMaintenance = perilTableGrid.geniisysRows;
			changeTag = 0;
		};
	} catch (e) {
		showErrorMessage("Warranty and Clauses Table Grid", e);
	}
	
	function showPerilLOV(isIconClicked) {
		try {
			var notIn = prepareNotInParam();
			var searchString = isIconClicked ? "%" : ($F("txtPerilCode").trim() == "" ? "%" : $F("txtPerilCode"));

			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGiiss213PerilLOV",
					lineCd : $F("txtLineCd"),
					searchString : searchString + "%",
					notIn : nvl(notIn, ""),
					page : 1
				},
				title : "List of Perils",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "perilCd",
					title : "Peril Code",
					width : '120px',
					align : 'right',
					titleAlign : 'right'
				}, {
					id : "perilName",
					title : "Peril Name",
					width : '345px'
				} ],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : searchString,
				onSelect : function(row) {
					if (row != null || row != undefined) {
						$("txtPerilCode").value = row.perilCd;
						$("txtPerilCode").setAttribute("lastValidValue", row.perilCd);
						$("txtPerilName").value = unescapeHTML2(row.perilName);
						$("txtPerilName").setAttribute("lastValidValue", unescapeHTML2(row.perilName));
					}
				},
				onCancel : function() {
					$("txtPerilCode").focus();
					$("txtPerilCode").value = $("txtPerilCode").readAttribute("lastValidValue");
					$("txtPerilName").value = $("txtPerilName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function() {
					$("txtPerilCode").value = $("txtPerilCode").readAttribute("lastValidValue");
					$("txtPerilName").value = $("txtPerilName").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtPerilCode");
				}
			});
		} catch (e) {
			showErrorMessage("showPerilLOV", e);
		}
	}

	function populatePerilInfo(obj){
		try{
			$("txtPerilCode").value			= obj	== null ? "" : obj.perilCd; 
			$("txtPerilName").value 		= obj	== null ? "" : unescapeHTML2(obj.perilName); 
			$("txtDtlRemarks").value		= obj	== null ? "" : unescapeHTML2(obj.remarks); 
			$("txtDtlUserId").value 		= obj	== null ? "" : unescapeHTML2(obj.userId);
			$("txtDtlLastUpdate").value 	= obj	== null ? "" : obj.lastUpdate;
			
			obj == null ? $("btnAddPeril").value = "Add" : $("btnAddPeril").value = "Update";
			obj == null ? $("txtPerilCode").readOnly = false : $("txtPerilCode").readOnly = true;
			obj == null ? $("txtPerilName").readOnly = false : $("txtPerilName").readOnly = true;
			obj == null ? disableButton("btnDeletePeril") : enableButton("btnDeletePeril");
			obj == null ? enableSearch("searchPerilLOV") : disableSearch("searchPerilLOV");
			
		}catch(e){
			showErrorMessage("populatePerilInfo", e);
		}
	}
	
	function setRec(rec) {
		try {
			var obj = (rec == null ? {} : rec);
			obj.lineCd = $F("txtLineCd");
			obj.perilGrpCd = $F("txtGroup");
			obj.perilCd = $F("txtPerilCode");
			obj.perilName = escapeHTML2($F("txtPerilName"));
			obj.remarks = escapeHTML2($F("txtDtlRemarks"));
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');

			return obj;
		} catch (e) {
			showErrorMessage("setRec", e);
		}
	}

	function addPerilRec() {
		try {
			changeTagFunc = saveGiiss213Dtl;
			var dept = setRec(objPerilMain);
			if ($F("btnAddPeril") == "Add") {
				perilTableGrid.addBottomRow(dept);
			} else {
				perilTableGrid.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			populatePerilInfo(null);
			perilTableGrid.keys.removeFocus(perilTableGrid.keys._nCurrentFocus, true);
			perilTableGrid.keys.releaseKeys();
			$("txtPerilCode").value = "";
			$("txtPerilCode").setAttribute("lastValidValue", "");
			$("txtPerilName").value = "";
			$("txtPerilName").setAttribute("lastValidValue", "");
		} catch (e) {
			showErrorMessage("addRec", e);
		}
	}
	
	function deletePerilRec() {
		changeTagFunc = saveGiiss213Dtl;
		objPerilMain.recordStatus = -1;
		perilTableGrid.deleteRow(row);
		changeTag = 1;
		populatePerilInfo(null);
	}
	
	function onRemove(){
		perilTableGrid.keys.releaseKeys();
		populatePerilInfo(null);
		$("txtPerilCode").focus();
	}
	
	function prepareNotInParam(){
		var withPrevious = false;
		var notIn = "";
		for(var i = 0; i < objPeriDtllMaintenance.length; i++){
			if(objPeriDtllMaintenance[i].recordStatus != -1){
				if(withPrevious){
					notIn += ",";
				}
				notIn += "'" + objPeriDtllMaintenance[i].perilCd + "'";
				withPrevious = true;
			}
		}
		return notIn;
	} 
	
	$("searchPerilLOV").observe("click", function() {
		showPerilLOV(true);
	});
	
	$("txtPerilCode").observe("change", function() {
		if (this.value != "") {
			showPerilLOV(false);
		} else {
			$("txtPerilCode").value = "";
			$("txtPerilCode").setAttribute("lastValidValue", "");
			$("txtPerilName").value = "";
			$("txtPerilName").setAttribute("lastValidValue", "");
		}
	});
	
	
	observeSaveForm("btnSavePeril", saveGiiss213Dtl);
	$("btnAddPeril").observe("click", function (){
		if(checkAllRequiredFieldsInDiv("perilDivForm")){
			addPerilRec();
		}
	});
	$("btnDeletePeril").observe("click", deletePerilRec);
	$("btnCancelPeril").observe("click", cancelGiiss213);
	
	$("editPerilRemarks").observe("click", function() {
		showOverlayEditor("txtDtlRemarks", 2000, $("txtDtlRemarks").hasAttribute("readonly"));
	});
	$("txtPerilCode").focus();
	
	
	function exitPage() {
		overlayPeril.close();
	}
	
	function cancelGiiss213() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function() {
				objGIISS213.exitPerilPage = exitPage;
				saveGiiss213Dtl();
			}, function() {
				changeTag = 0;
				exitPage();
			}, "");
		} else {
			exitPage();
		}
	}
	
	disableButton("btnDeletePeril");
</script>