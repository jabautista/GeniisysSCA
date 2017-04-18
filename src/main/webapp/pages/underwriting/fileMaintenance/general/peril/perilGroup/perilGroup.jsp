<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss213MainDiv" name="giiss213MainDiv" style="">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Peril Group Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="gicls213" name="gicls213">		
		<div class="sectionDiv">
			<div style="" align="center" id="lineDiv">
				<table cellspacing="2" border="0" style="margin: 10px auto;">	 			
					<tr>
						<td class="rightAligned" style="" id="">Line</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan required" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required allCaps" type="text" id="txtLineCd" name="txtLineCd" style="width: 40px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="101" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineLOV" name="searchLineLOV" alt="Go" style="float: right;" tabindex="102"/>
							</span>
							<input id="txtLineName" name="txtLineName" type="text" style="width: 280px;" value="" readonly="readonly" tabindex="103" lastValidValue=""/>
						</td>						
					</tr>
				</table>			
			</div>		
		</div>
		<div id="gicls213SubDiv" name="gicls213SubDiv">		
			<div class="sectionDiv">
				<div id="perilGroupDiv" style="padding-top: 10px;">
					<div id="perilGroupTable" style="height: 340px; margin-left: 115px;"></div>
				</div>
				<div align="center" id="perilGroupFormDiv">
					<table style="margin-top: 5px;">
						<tr>
							<td class="rightAligned">Group Code</td>
							<td class="leftAligned">
								<input id="txtGroupCode" type="text" class="required integerNoNegativeUnformattedNoComma" style="width: 200px; text-align: right;" tabindex="201" maxlength="2">
							</td>
						</tr>	
						<tr>
							<td width="" class="rightAligned">Group Description</td>
							<td class="leftAligned" colspan="3">
								<input id="txtGroupDesc" type="text" class="required" style="width: 533px;" tabindex="202" maxlength="100">
							</td>
						</tr>				
						<tr>
							<td width="" class="rightAligned">Remarks</td>
							<td class="leftAligned" colspan="3">
								<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
									<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="2000"  onkeyup="limitText(this,2000);" tabindex="203"></textarea>
									<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="204"/>
								</div>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">User ID</td>
							<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="205"></td>
							<td width="" class="rightAligned">Last Update</td>
							<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 245px;" readonly="readonly" tabindex="206"></td>
						</tr>			
					</table>
				</div>
				<div style="margin: 10px;" align="center">
					<table>
						<tr>
							<td>
								<input type="button" class="button" id="btnAdd" value="Add" tabindex="207">
							</td>
							<td>
								<input type="button" class="button" id="btnDelete" value="Delete" tabindex="208">
							</td>
						</tr>
					</table>
				</div>
				<div style="margin: 10px; padding: 10px; border-top: 1px solid #E0E0E0; margin-bottom: 0;" align="center">
					<input type="button" class="button" id="btnAttachedPeril" value="Attached Peril/s" tabindex="209">
				</div>
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="210">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="211">
</div>
<script type="text/javascript">
	setModuleId("GIISS213");
	setDocumentTitle("Peril Group Maintenance");
	initializeAll();
	initializeAccordion();
	makeInputFieldUpperCase();
	changeTag = 0;
	var rowIndex = -1;

	function saveGiiss213() {
		if (changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgPerilGroup.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgPerilGroup.geniisysRows);
		new Ajax.Request(contextPath + "/GIISPerilGroupController", {
			method : "POST",
			parameters : {
				action : "saveGiiss213",
				setRows : prepareJsonAsParameter(setRows),
				delRows : prepareJsonAsParameter(delRows)
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete : function(response) {
				hideNotice();
				if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)) {
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function() {
						if (objGIISS213.exitPage != null) {
							objGIISS213.exitPage();
							objGIISS213.exitPage = null;
						} else {
							tbgPerilGroup._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}

	observeReloadForm("reloadForm", showGIISS213);

	objGIISS213 = {};
	var objPerilGroup = null;
	objGIISS213.perilGroupList = JSON.parse('${jsonPerilGroupList}');
	objGIISS213.exitPage = null;

	var perilGroupTable = {
		url : contextPath + "/GIISPerilGroupController?action=showGIISS213&refresh=1",
		options : {
			width : '700px',
			hideColumnChildTitle : true,
			pager : {},
			onCellFocus : function(element, value, x, y, id) {
				rowIndex = y;
				objPerilGroup = tbgPerilGroup.geniisysRows[y];
				setFieldValues(objPerilGroup);
				tbgPerilGroup.keys.removeFocus(tbgPerilGroup.keys._nCurrentFocus, true);
				tbgPerilGroup.keys.releaseKeys();
				$("txtGroupDesc").focus();
			},
			onRemoveRowFocus : function() {
				rowIndex = -1;
				setFieldValues(null);
				tbgPerilGroup.keys.removeFocus(tbgPerilGroup.keys._nCurrentFocus, true);
				tbgPerilGroup.keys.releaseKeys();
				$("txtGroupCode").focus();
			},
			toolbar : {
				elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
				onFilter : function() {
					rowIndex = -1;
					setFieldValues(null);
					tbgPerilGroup.keys.removeFocus(tbgPerilGroup.keys._nCurrentFocus, true);
					tbgPerilGroup.keys.releaseKeys();
				}
			},
			beforeSort : function() {
				if (changeTag == 1) {
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function() {
						$("btnSave").focus();
					});
					return false;
				}
			},
			onSort : function() {
				rowIndex = -1;
				setFieldValues(null);
				tbgPerilGroup.keys.removeFocus(tbgPerilGroup.keys._nCurrentFocus, true);
				tbgPerilGroup.keys.releaseKeys();
			},
			onRefresh : function() {
				rowIndex = -1;
				setFieldValues(null);
				tbgPerilGroup.keys.removeFocus(tbgPerilGroup.keys._nCurrentFocus, true);
				tbgPerilGroup.keys.releaseKeys();
			},
			prePager : function() {
				if (changeTag == 1) {
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function() {
						$("btnSave").focus();
					});
					return false;
				}
				rowIndex = -1;
				setFieldValues(null);
				tbgPerilGroup.keys.removeFocus(tbgPerilGroup.keys._nCurrentFocus, true);
				tbgPerilGroup.keys.releaseKeys();
			},
			checkChanges : function() {
				return (changeTag == 1 ? true : false);
			},
			masterDetailRequireSaving : function() {
				return (changeTag == 1 ? true : false);
			},
			masterDetailValidation : function() {
				return (changeTag == 1 ? true : false);
			},
			masterDetail : function() {
				return (changeTag == 1 ? true : false);
			},
			masterDetailSaveFunc : function() {
				return (changeTag == 1 ? true : false);
			},
			masterDetailNoFunc : function() {
				return (changeTag == 1 ? true : false);
			}
		},
		columnModel : [ { // this column will only use for deletion
			id : 'recordStatus', // 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
			width : '0',
			visible : false
		}, {
			id : 'divCtrId',
			width : '0',
			visible : false
		}, {
			id : 'lineCd',
			width : '0',
			visible : false
		}, {
			id : "perilGrpCd",
			title : "Group Code",
			filterOption : true,
			filterOptionType : 'integerNoNegative',
			align : 'right',
			titleAlign : 'right',
			width : '100px'
		}, {
			id : 'perilGrpDesc',
			filterOption : true,
			title : 'Group Description',
			width : '560px'
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
		} ],
		rows : objGIISS213.perilGroupList.rows
	};

	tbgPerilGroup = new MyTableGrid(perilGroupTable);
	tbgPerilGroup.pager = objGIISS213.perilGroupList;
	tbgPerilGroup.render("perilGroupTable");

	function setFieldValues(rec) {
		try {
			$("txtGroupCode").value = (rec == null ? "" : rec.perilGrpCd);
			$("txtGroupDesc").value = (rec == null ? "" : unescapeHTML2(rec.perilGrpDesc));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));

			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtGroupCode").readOnly = false : $("txtGroupCode").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			rec == null ? disableButton("btnAttachedPeril") : enableButton("btnAttachedPeril");
			objPerilGroup = rec;
		} catch (e) {
			showErrorMessage("setFieldValues", e);
		}
	}

	function setRec(rec) {
		try {
			var obj = (rec == null ? {} : rec);
			obj.lineCd = $F("txtLineCd");
			obj.perilGrpCd = $F("txtGroupCode");
			obj.perilGrpDesc = escapeHTML2($F("txtGroupDesc"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');

			return obj;
		} catch (e) {
			showErrorMessage("setRec", e);
		}
	}

	function addRec() {
		try {
			changeTagFunc = saveGiiss213;
			var dept = setRec(objPerilGroup);
			if ($F("btnAdd") == "Add") {
				tbgPerilGroup.addBottomRow(dept);
			} else {
				tbgPerilGroup.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgPerilGroup.keys.removeFocus(tbgPerilGroup.keys._nCurrentFocus, true);
			tbgPerilGroup.keys.releaseKeys();
		} catch (e) {
			showErrorMessage("addRec", e);
		}
	}

	function valAddRec() {
		try {
			if (checkAllRequiredFieldsInDiv("gicls213SubDiv")) {
				if ($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;

					for ( var i = 0; i < tbgPerilGroup.geniisysRows.length; i++) {
						if (tbgPerilGroup.geniisysRows[i].recordStatus == 0 || tbgPerilGroup.geniisysRows[i].recordStatus == 1) {
							if (tbgPerilGroup.geniisysRows[i].perilGrpCd == $F("txtGroupCode")) {
								addedSameExists = true;
							}
						} else if (tbgPerilGroup.geniisysRows[i].recordStatus == -1) {
							if (tbgPerilGroup.geniisysRows[i].perilGrpCd == $F("txtGroupCode")) {
								deletedSameExists = true;
							}
						}
					}

					if ((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)) {
						showMessageBox("Record already exists with the same peril_grp_cd.", "E");
						return;
					} else if (deletedSameExists && !addedSameExists) {
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIISPerilGroupController", {
						parameters : {
							action : "valAddRec",
							lineCd : $F("txtLineCd"),
							perilGrpCd : $F("txtGroupCode")
						},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response) {
							hideNotice();
							if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
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
		changeTagFunc = saveGiiss213;
		objPerilGroup.recordStatus = -1;
		tbgPerilGroup.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}

	function valDeleteRec() {
		try {
			new Ajax.Request(contextPath + "/GIISPerilGroupController", {
				parameters : {
					action : "valDeleteRec",
					lineCd : $F("txtLineCd"),
					perilGrpCd : $F("txtGroupCode")
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
						deleteRec();
					}
				}
			});
		} catch (e) {
			showErrorMessage("valDeleteRec", e);
		}
	}

	function exitPage() {
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}

	function cancelGiiss213() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function() {
				objGIISS213.exitPage = exitPage;
				saveGiiss213();
			}, function() {
				goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
			}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}

	function showLineLOV(isIconClicked) {
		try {
			var searchString = isIconClicked ? "%" : ($F("txtLineCd").trim() == "" ? "%" : $F("txtLineCd"));

			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGiiss213LineLOV",
					searchString : searchString + "%",
					page : 1
				},
				title : "List of Lines",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "lineCd",
					title : "Line Code",
					width : '120px'
				}, {
					id : "lineName",
					title : "Line Name",
					width : '345px'
				} ],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : escapeHTML2(searchString),
				onSelect : function(row) {
					if (row != null || row != undefined) {
						$("txtLineCd").value = row.lineCd;
						$("txtLineCd").setAttribute("lastValidValue", row.lineCd);
						$("txtLineName").value = unescapeHTML2(row.lineName);
						$("txtLineName").setAttribute("lastValidValue", unescapeHTML2(row.lineName));
						enableToolbarButton("btnToolbarExecuteQuery");
						enableToolbarButton("btnToolbarEnterQuery");
					}
				},
				onCancel : function() {
					$("txtLineCd").focus();
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
					$("txtLineName").value = $("txtLineName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function() {
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
					$("txtLineName").value = $("txtLineName").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtLineCd");
				}
			});
		} catch (e) {
			showErrorMessage("showLineLOV", e);
		}
	}

	function togglePerilGroupFields(enable) {
		try {
			if (enable) {
				$("txtGroupCode").readOnly = false;
				$("txtGroupDesc").readOnly = false;
				$("txtRemarks").readOnly = false;
				$("txtLineCd").readOnly = true;
				disableSearch("searchLineLOV");
				enableButton("btnAdd");
				disableButton("btnAttachedPeril");
				$("editRemarks").disabled = false;
			} else {
				$("txtGroupCode").readOnly = true;
				$("txtGroupDesc").readOnly = true;
				$("txtRemarks").readOnly = true;
				$("txtLineCd").readOnly = false;
				enableSearch("searchLineLOV");
				disableButton("btnAdd");
				disableButton("btnAttachedPeril");
				$("editRemarks").disabled = true;
			}
		} catch (e) {
			showErrorMessage("togglePerilGroupFields", e);
		}
	}

	function enterQuery() {
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		tbgPerilGroup.url = contextPath + "/GIISPerilGroupController?action=showGIISS213&refresh=1";
		tbgPerilGroup._refreshList();
		$("txtLineCd").clear();
		$("txtLineName").clear();
		togglePerilGroupFields(false);
		$("txtLineCd").focus();
		$("txtLineCd").setAttribute("lastValidValue", "");
		$("txtLineName").setAttribute("lastValidValue", "");
	}

	$("searchLineLOV").observe("click", function() {
		showLineLOV(true);
	});

	$("txtLineCd").observe("change", function() {
		if (this.value != "") {
			showLineLOV(false);
		} else {
			$("txtLineCd").value = "";
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtLineName").value = "";
			$("txtLineName").setAttribute("lastValidValue", "");
			disableToolbarButton("btnToolbarExecuteQuery");
		}
	});

	$("editRemarks").observe("click", function() {
		showOverlayEditor("txtRemarks", 2000, $("txtRemarks").hasAttribute("readonly"));
	});

	$("btnToolbarEnterQuery").observe("click", function() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function() {
				objGIISS213.exitPage = enterQuery;
				saveGiiss213();
			}, function() {
				enterQuery();
			}, "");
		} else {
			enterQuery();
		}
	});

	$("btnToolbarExecuteQuery").observe("click", function() {
		disableToolbarButton(this.id);
		enableToolbarButton("btnToolbarEnterQuery");
		tbgPerilGroup.url = contextPath + "/GIISPerilGroupController?action=showGIISS213&refresh=1&lineCd=" + $F("txtLineCd");
		tbgPerilGroup._refreshList();
		togglePerilGroupFields(true);
	});

	disableButton("btnDelete");
	showToolbarButton("btnToolbarSave");
	hideToolbarButton("btnToolbarPrint");
	disableToolbarButton("btnToolbarEnterQuery");
	disableToolbarButton("btnToolbarExecuteQuery");

	observeSaveForm("btnSave", saveGiiss213);
	observeSaveForm("btnToolbarSave", saveGiiss213);
	$("btnCancel").observe("click", cancelGiiss213);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("btnToolbarExit").stopObserving("click");
	$("btnToolbarExit").observe("click", function() {
		fireEvent($("btnCancel"), "click");
	});

	$("txtLineCd").focus();

	togglePerilGroupFields(false);
	
	function showOverlay(action, title, error){
		try{
			overlayPeril = Overlay.show(contextPath+"/GIISPerilGroupController?" + "&lineCd=" + $F("txtLineCd") + "&perilGrpCd=" + $F("txtGroupCode"), {
				urlContent: true,
				urlParameters: {action : action},
			    title: title,
			    height: 485,
			    width: 660,
			    draggable: true
			});
		}catch(e){
			showErrorMessage(error, e);
		}		
	}
	
	$("btnAttachedPeril").observe("click", function() {
		if (changeTag == 1){
    		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			showOverlay("getAttachedPerils", "Peril Maintenance", "showAttachedPerilsOverlay");
		}
	});
</script>