<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="fileSourceMainDiv" name="fileSourceMainDiv" style="float: left; width: 100%;">
	<div id="fileSourceGridDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="fileSourceExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>File Source Maintenance</label>
			<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label>
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div>
	<div id="showDetails">	
		<div class="sectionDiv" style="padding-bottom: 10px; margin-bottom: 10px;">
			<div id="fileSourceTableGrid" style="margin-left: 10px; height: 310px; margin-top: 10px;"></div>
			<div align="center" style="padding: 5px; padding-top: 30px;">
				<div id="fileSourceInfo" align="center">
					<table align="center">	
						<tr>
							<td class="rightAligned">Code</td>
							<td class="leftAligned"><input type="text" id="txtCode" value="" style="width: 150px;" class="required upper" maxlength="4" tabindex="101"/></td>
							<td style="padding-left: 20px;">
								<input id="chkAtm" type="checkbox" style="float: left; padding-left: 40px; width: 13px; height: 13px; overflow: hidden;" name="chkAtm" tabindex="102"/>
								<label for="chkAtm" style="float: left; padding-left: 3px; padding-right: 30px;" title="ATM" tabindex="103">ATM</label>
								<input id="chkUtility" type="checkbox" style="float: left; padding: 0pt; width: 13px; height: 13px; overflow: hidden;" name="chkUtility" tabindex="104"/>
								<label for="chkUtility" style="float: left; padding-left: 3px; padding-right: 70px;" title="Utility" tabindex="105">Utility</label>
							</td>
							<td class="rightAligned">Address</td>
							<td class="leftAligned"><input type="text" id="txtAddress1" value="" style="width: 300px;" maxlength="50" tabindex="106"/></td>
						</tr>
						<tr>
							<td class="rightAligned">Source</td>
							<td class="leftAligned" colspan="2"><input type="text" id="txtSource" value="" style="width: 300px;" class="required upper" maxlength="100" tabindex="107"/></td>
							<td class="rightAligned"></td>
							<td class="leftAligned"><input type="text" id="txtAddress2" value="" style="width: 300px;" maxlength="50" tabindex="108"/></td>
						</tr>
						<tr>
							<td class="rightAligned">OR Tag</td>
							<td class="leftAligned" colspan="2">
								<select id="dDnOrTag" name="dDnOrTag" style="width: 308px;" tabindex="109"/>
									<option value="I">Individual</option>
									<option value="G">Group</option>
		 						</select>
				 			</td>
							<td class="rightAligned"></td>
							<td class="leftAligned"><input type="text" id="txtAddress3" value="" style="width: 300px;" maxlength="50" tabindex="110"/></td>
						</tr>
						<tr>
							<td class="rightAligned">TIN</td>
							<td class="leftAligned" colspan="2"><input type="text" id="txtTin" value="" style="width: 300px;" maxlength="30" tabindex="111"/></td>
							<td class="rightAligned">Remarks</td>
							<td colspan="3" class="leftAligned">
								<div style="border: 1px solid gray; height: 21px; width: 306px">
									<textarea id="txtRemarks" name="txtRemarks" style="border: none; height: 13px; resize: none; width: 276px" maxlength="4000" tabindex="112"></textarea>
									<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="EditRemark" id="editRemarksText"/>
								</div>
							</td>
						</tr>
						<tr>
							<td class="rightAligned">User ID</td>
							<td class="leftAligned" colspan="2"><input type="text" id="txtUserId" value="" readonly="readonly" style="width: 150px;" readonly="readonly" tabindex="113"/></td>
							<td class="rightAligned">Last Update</td>
							<td class="leftAligned"><input type="text" id="txtLastUpdate" value="" style="width: 150px;" readonly="readonly" tabindex="114"/></td>
						</tr>
					</table>
				</div>
				<div align="center" style="margin-top: 15px;">
					<input type="button" class="button" id="btnAdd" name="btnAdd" value="Add" style="width: 90px;" tabindex="115"/>
					<input type="button" class="button" id="btnDelete" name="btnDelete" value="Delete" style="width: 90px;" tabindex="116"/>
				</div>
			</div>
		</div>	
	</div>
	<div class="buttonsDiv" align="center" style="width: 100%; margin-top: 5px;">
		<input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel" style="width: 125px;" tabindex="117"/>
		<input type="button" class="button" id="btnSave" name="btnSave" value="Save" style="width: 125px;" tabindex="118"/>
	</div>

<script type="text/javascript">
	initializeAll();
	initializeAccordion();
	makeInputFieldUpperCase();
	setModuleId("GIACS600");
	setDocumentTitle("File Source Maintenance");
	changeTag = 0;
	var objFileSourceMiantenance = null;
	var sourceCode = "";
	refreshForm();
	var code = "";
	
	try {
		var row = 0;
		objFileSource = [];
		fileSource = new Object();
		fileSource.fileSourceListing = JSON.parse('${objFileSourceTable}'.replace(/\\/g, '\\\\'));
		//fileSource.fileSourceListing = [];
		fileSource.fileSourceRows = fileSource.fileSourceListing.rows || [];

		var fileSourceTableGrid = {
			url : contextPath + "/GIACFileSourceController?action=showFileSource",
			options : {
				width : '900px',
				height : '306px',
				onCellFocus : function(element, value, x, y, id) {
					row = y;
					$("btnAdd").value = "Update";
					enableButton("btnDelete");
					objFileSourceMiantenance = fileSourceMaintenanceTable.geniisysRows[y];
					populateFileSourceForm(objFileSourceMiantenance);
					fileSourceMaintenanceTable.keys.releaseKeys();
				},
				onRemoveRowFocus : function() {
					fileSourceMaintenanceTable.keys.releaseKeys();
					refreshForm();
				},
				beforeSort : function() {
					if (changeTag == 1) {
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}else{
						refreshForm();
					}
				},
				onRefresh : function() {
					if (changeTag == 1) {
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						
						return false;
					}else{
						refreshForm();
					};
				},
				onSort : function() {
					if (changeTag == 1) {
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}else{
						refreshForm();
					}
				},
				prePager : function() {
					if (changeTag == 1) {
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}else{
						refreshForm();
					}
				}
				,toolbar : {
					elements : [ MyTableGrid.REFRESH_BTN,MyTableGrid.FILTER_BTN ],
					onFilter : function() {
						if (changeTag == 1) {
							showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
							return false;
						}else{
							refreshForm();
						}
					}	
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
			columnModel : [
					{
						id : 'recordStatus',
						width : '0',
						visible : false
					},
					{
						id : 'divCtrId',
						width : '0',
						visible : false
					},{
						id : 'atmTag',
						title : 'A',
						altTitle : 'ATM',
						width : '25',
						align : 'center',
						titleAlign : 'center',
						defaultValue : false,
						otherValue : false,
						editor : new MyTableGrid.CellCheckbox({getValueOf : function(value) {
								if (value) {
									return "Y";
								} else {
									return "N";
								}
							}
						})
					}, {
						id : 'utilityTag',
						title : 'U',
						altTitle : 'Utility',
						width : '25',
						align : 'center',
						titleAlign : 'center',
						defaultValue : false,
						otherValue : false,
						editor : new MyTableGrid.CellCheckbox({getValueOf : function(value) {
								if (value) {
									return "Y";
								} else {
									return "N";
								}
							}
						})
					}, {
						id : 'sourceCd',
						title : 'Code',
						width : '100',
						filterOption : true
					}, {
						id : 'sourceName',
						title : 'Source',
						width : '303',
						filterOption : true
					},  {
						id : 'orTagDesc',
						title : 'OR Tag',
						width : '200',
						filterOption : true
					},  {
						id : 'tin',
						title : 'TIN',
						width : '200',
						filterOption : true
					},  {
						id : 'orTag',
						width : '0',
						visible : false
					},  {
						id : 'lastUpdate',
						width : '0',
						visible : false
					},  {
						id : 'address1',
						width : '0',
						visible : false
					}
					,  {
						id : 'address2',
						width : '0',
						visible : false
					}
					,  {
						id : 'address3',
						width : '0',
						visible : false
					}
					,  {
						id : 'remarks',
						width : '0',
						visible : false
					}
					,  {
						id : 'originalSource',
						width : '0',
						visible : false
					}
					,  {
						id : 'addUpdate',
						width : '0',
						visible : false
					}],
			rows : fileSource.fileSourceRows
		};
		fileSourceMaintenanceTable = new MyTableGrid(fileSourceTableGrid);
		fileSourceMaintenanceTable.pager = fileSource.fileSourceListing;
		fileSourceMaintenanceTable.render('fileSourceTableGrid');
		fileSourceMaintenanceTable.afterRender = function() {
			objFileSource = fileSourceMaintenanceTable.geniisysRows;
		};
	} catch (e) {
		showErrorMessage("File Source Maintenance Table", e);
	}
	
	function checkIfDuplicateSourceCd(){
		for(var i=0; i<objFileSource.length; i++){
			if(objFileSource[i].sourceCd == $("txtCode").value){	
				customShowMessageBox("Source Code must be unique.", "I", "txtCode");
				$("txtCode").value = "";
				break;
			}
		}
		sourceCode = $F("txtCode");
	} 
	
	function refreshForm(){
		$("txtCode").focus();
		$("dDnOrTag").value = "I";
		$("txtCode").value = "";
		$("txtSource").value = "";
		$("txtAddress1").value = "";
		$("txtAddress2").value = "";
		$("txtAddress3").value = "";
		$("txtTin").value = "";
		$("chkAtm").checked = false;
		$("chkUtility").checked = false;
		$("btnAdd").value = "Add";
		$("txtRemarks").value = "";
		$("txtUserId").value = "${PARAMETERS['USER'].userId}";
		$("txtLastUpdate").value = dateFormat(new Date(), 'mm-dd-yyyy hh:MM:ss TT');
		disableButton("btnDelete");
		sourceCode = "";
	}
	
	function populateFileSourceForm(obj) {
		try {
			$("txtCode").value 		    = unescapeHTML2(obj.sourceCd);
			sourceCode      		    = unescapeHTML2(obj.sourceCd);
			code						= unescapeHTML2(obj.sourceCd);
			$("txtSource").value 		= unescapeHTML2(obj.sourceName);
			$("txtAddress1").value 		= unescapeHTML2(obj.address1);
			$("txtAddress2").value 		= unescapeHTML2(obj.address2);
			$("txtAddress3").value 		= unescapeHTML2(obj.address3);
			$("dDnOrTag").value 		= unescapeHTML2(obj.orTag);
			$("txtTin").value 			= unescapeHTML2(obj.tin);
			$("txtRemarks").value 		= unescapeHTML2(obj.remarks);
			$("txtUserId").value 		= unescapeHTML2(obj.userId);
			$("txtLastUpdate").value 	= unescapeHTML2(obj.lastUpdate);
			$("chkAtm").checked 		= obj.atmTag == 'Y' ? true : false;
			$("chkUtility").checked 	= obj.utilityTag == 'Y' ? true : false;
		} catch (e) {
			showErrorMessage("populateFileSourceForm", e);
		}
	}
	
	function setFileSourceTableValues() {
		var rowObjectFileSource = new Object();

		rowObjectFileSource.sourceCd 	= escapeHTML2($("txtCode").value);
		rowObjectFileSource.sourceName 	= escapeHTML2($("txtSource").value);
		rowObjectFileSource.address1 	= escapeHTML2($("txtAddress1").value);
		rowObjectFileSource.address2 	= escapeHTML2($("txtAddress2").value);
		rowObjectFileSource.address3 	= escapeHTML2($("txtAddress3").value);
		rowObjectFileSource.orTag 		= escapeHTML2($("dDnOrTag").value);
		rowObjectFileSource.orTagDesc   = escapeHTML2($("dDnOrTag").value == "G" ? "Group" : "Individual");
		rowObjectFileSource.tin 		= escapeHTML2($("txtTin").value);
		rowObjectFileSource.remarks 	= escapeHTML2($("txtRemarks").value);
		rowObjectFileSource.userId 		= escapeHTML2($("txtUserId").value);
		rowObjectFileSource.atmTag 		= ($("chkAtm").checked ? "Y" : "N");
		rowObjectFileSource.utilityTag 	= ($("chkUtility").checked ? "Y" : "N");
		rowObjectFileSource.lastUpdate 	= $("txtLastUpdate").value;
		rowObjectFileSource.originalSource 	= code;
		rowObjectFileSource.addUpdate 	= $("btnAdd").value;
		
		return rowObjectFileSource;
	}
	
	function setFileSource(){  
		rowObj  = setFileSourceTableValues($("btnAdd").value);
		if(checkAllRequiredFieldsInDiv("fileSourceInfo")){
			if($("txtAddress1").value == ""){
				customShowMessageBox("Address must be entered.", "I", "txtAddress1");
			}else{
				if($("btnAdd").value != "Add"){
					rowObj.recordStatus = 1;
					objFileSource.splice(row, 1, rowObj);
					fileSourceMaintenanceTable.updateVisibleRowOnly(rowObj, row);
					fileSourceMaintenanceTable.onRemoveRowFocus();
					changeTag = 1;
				}else{
					rowObj.recordStatus = 0;
					objFileSource.push(rowObj);
					fileSourceMaintenanceTable.addBottomRow(rowObj);
					fileSourceMaintenanceTable.onRemoveRowFocus();
					changeTag = 1;
				}
			}
		}
	}
	
	function deleteFileSource() {
			delObj = setFileSourceTableValues($("btnDelete").value);
				delObj.recordStatus = -1;
				objFileSource.splice(row, 1, delObj);
				fileSourceMaintenanceTable.deleteVisibleRowOnly(row);
				fileSourceMaintenanceTable.onRemoveRowFocus();
				changeTag = 1;
	}
	
	function saveFileSource() {
		var objParams = new Object();
		objParams.setRows = getAddedAndModifiedJSONObjects(objFileSource);
		objParams.delRows = getDeletedJSONObjects(objFileSource);

		new Ajax.Request(contextPath
				+ "/GIACFileSourceController?action=saveFileSource", {
			method : "POST",
			parameters : {
				parameters : JSON.stringify(objParams)
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : function() {
				showNotice("Saving File Source, please wait...");
			},
			onComplete : function(response) {
				hideNotice("");
				changeTag = 0;
				if (checkErrorOnResponse(response)) {
					if (response.responseText == "SUCCESS") {
						showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);	
						fileSourceMaintenanceTable.refresh();
					}
				} else {
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});

	}
	
	observeCancelForm("fileSourceExit", saveFileSource, function() {
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
		changeTagFunc = "";
		changeTag = 0;
	});
	
	observeCancelForm("btnCancel", saveFileSource, function() {
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
		changeTagFunc = "";
		changeTag = 0;
	});
	
	 $("btnAdd").observe("click", function() {
		 changeTagFunc = saveFileSource;
		 setFileSource();
	});
	 
	 $("btnDelete").observe("click", function() {
		 changeTagFunc = saveFileSource;
		 deleteFileSource();
	});
	 
	 $("txtCode").observe("change", function() {
		 checkIfDuplicateSourceCd();
	});
	 
	 changeTagFunc = saveFileSource;
	 observeSaveForm("btnSave", saveFileSource);
	 
	$("editRemarksText").observe("click", function() {
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"), function() {
			limitText($("txtRemarks"),4000);
		});
	});

	$("txtRemarks").observe("keyup", function() {
		limitText(this, 4000);
	});

	
	observeReloadForm("reloadForm", showFileSource);
	
</script>
