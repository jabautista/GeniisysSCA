<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss203MainDiv" name="giiss203MainDiv" style="">
	<div id="intermediaryDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="intermediaryExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Intermediary Listing Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss203" name="giiss203">		
		<div class="sectionDiv">
			<div id="intermediaryTableDiv" style="padding-top: 10px;">
				<div id="intermediaryTable" style="height: 332px; margin-left: 5px; float: left;"></div>
					
				<fieldset id="intmTypeDiv" style="width: 230px; height: 315px; margin: 0 0 10px 663px;">
					<label style="font-weight: bold; text-align: center; width: 230px;">Intermediary Type</label>
					
					<div id="intmTypeListDiv" style="width: 100%; height: 279px; margin-top: 6px; overflow-y: auto; border: 1px solid #E0E0E0; float: left; padding: 5px 0;">
						<c:forEach var="i" items="${intmTypeList}">
							<div id="rowIntmType${i.intmType}" name="rowIntmType" class="tableRow" style="margin: 0 5px; padding-top: 5px;">
								<input id="chkIntmType${i.intmType}" name="chkIntmTypes" type="checkbox" value="${i.intmType }" checked="checked" style="float: left; margin: 0 5px 5px 3px;">
								<label for="chkIntmType${i.intmType}" style="margin: 0 4px 7px 2px;"><c:out value="${i.intmDesc}"></c:out> </label>
							</div>							
						</c:forEach>
					</div>
				</fieldset>				
			</div>
			<div align="center" id="intermediaryFormDiv">
				<table style="margin-top: 20px;">
					<tr>
						<td class="rightAligned">Intm No.</td>
						<td class="leftAligned" colspan="3">
							<input id="txtIntmNo" type="text" class="required" readonly="readonly" style="width: 200px; text-align: right;" tabindex="201" maxlength="12">
						</td>
						<td class="leftAligned" colspan="2">
							<input id="chkActiveTag" type="checkbox" style="float: left; margin: 0 7px 0 5px;"><label for="chkActiveTag" style="margin: 0 4px 2px 2px;">Active Tag</label>
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Intermediary Name</td>
						<td class="leftAligned" colspan="4">
							<input id="txtIntmName" type="text" class="required" readonly="readonly" style="width: 533px; float: left; " tabindex="202" maxlength="240">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Intm Type</td>
						<td class="leftAligned" colspan="4">
							<input id="hidIntmType" type="hidden">
							<input id="txtIntmTypeDesc" type="text" class="" readonly="readonly" style="width: 200px; float: left; " tabindex="203" maxlength="20">
							<label style="padding: 5px 7px 0 35px;">Ref Intm Code</label>
							<input id="txtRefIntmCd" type="text" class="" style="width: 200px;" tabindex="204" maxlength="10">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Parent Intermediary</td>
						<td class="leftAligned" colspan="4">
							<input id="hidParentIntmNo" type="hidden">
							<input id="txtParentIntmName" type="text" class="" readonly="readonly" style="width: 533px; float: left; " tabindex="205" maxlength="240">
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="4">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="206"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="207"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned" colspan="2"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="208"></td>
						<td width="" class="rightAligned" style="padding-left: 46px;">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="209"></td>
					</tr>	
				</table>
			</div>
			<div class="buttonsDiv" style="margin: 10px 0 10px 0;">
				<input type="button" class="button" id="btnUpdate" value="Update" tabindex="210">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="211">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="211">
</div>
<script type="text/javascript">	
	setModuleId("GIISS203");
	setDocumentTitle("Intermediary Listing Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	
	var rowIndex = -1;
	
	var ctrlSw1 = 0;
	var ctrlSw2 = 0;	

	objUW.GIISS203.intmTypes = "";
	//objUW.GIISS203.setWhere = "";
	objUW.GIISS076.recordStatus = null;
	
	function getDefaultWhere(){
		objUW.GIISS203.setWhere = "AND intm_type IN (";
		
		$$("input[name='chkIntmTypes']").each(function(chk){
			objUW.GIISS203.setWhere = objUW.GIISS203.setWhere + "'" + chk.value + "',";
		});
			
		objUW.GIISS203.setWhere = objUW.GIISS203.setWhere.substr(0, objUW.GIISS203.setWhere.length - 1) + ")";	
	}
	
	getDefaultWhere();
	
	
	function saveGiiss203(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgIntermediary.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgIntermediary.geniisysRows);
		new Ajax.Request(contextPath+"/GIISIntermediaryController", {
			method: "POST",
			parameters : {action : "saveGiiss203",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS203.afterSave != null) {
							objGIISS203.afterSave();
							objGIISS203.afterSave = null;
						} else {
							tbgIntermediary._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss203);
	
	var objGIISS203 = {};
	var objIntermediary = null;
	objGIISS203.intermediaryList = JSON.parse('${jsonIntermediaryList}');
	objGIISS203.afterSave = null;
	
	
	var intermediaryTableModel = {
			url : contextPath + "/GIISIntermediaryController?action=showGiiss203&refresh=1&setWhere="+encodeURIComponent(objUW.GIISS203.setWhere), 
			options : {
				width : '643px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objIntermediary = tbgIntermediary.geniisysRows[y];
					tbgIntermediary.keys.removeFocus(tbgIntermediary.keys._nCurrentFocus, true);
					tbgIntermediary.keys.releaseKeys();
					observeChangeTagInTableGrid(tbgIntermediary);
					setFieldValues(objIntermediary);
					$("txtIntmName").focus();
					observeChangeTagInTableGrid(tbgIntermediary);
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					tbgIntermediary.keys.removeFocus(tbgIntermediary.keys._nCurrentFocus, true);
					tbgIntermediary.keys.releaseKeys();
					setFieldValues(null);
				},
				onRowDoubleClick: function(y){
					//tbgIntermediary.keys.removeFocus(tbgIntermediary.keys._nCurrentFocus, true);
					tbgIntermediary.keys.releaseKeys();
					ctrlSw1 = 1;
					observeChangeTagInTableGrid(tbgIntermediary);
					var row = tbgIntermediary.geniisysRows[y];
					if (changeTag == 1){
						showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
								function(){
									exitPage = function(){
										if (checkGiiss076Access()){
											showGiiss076(row.intmNo, "EDIT");
										}else{
											showMessageBox("You are not allowed to access this module.", "E");
											return false;
										}
									};
									saveGiiss203();
								}, 
								function(){
									if (checkGiiss076Access()){
										showGiiss076(row.intmNo, "EDIT");
									}else{
										showMessageBox("You are not allowed to access this module.", "E");
										return false;
									}
									changeTag = 0;
								}, "");
					}else{
						changeTag = 0;
						if (checkGiiss076Access()){
							showGiiss076(row.intmNo, "EDIT");
						}else{
							showMessageBox("You are not allowed to access this module.", "E");
							return false;
						}
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
					tbgIntermediary.keys.removeFocus(tbgIntermediary.keys._nCurrentFocus, true);
					tbgIntermediary.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgIntermediary.keys.removeFocus(tbgIntermediary.keys._nCurrentFocus, true);
					tbgIntermediary.keys.releaseKeys();
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
					tbgIntermediary.keys.removeFocus(tbgIntermediary.keys._nCurrentFocus, true);
					tbgIntermediary.keys.releaseKeys();
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
					elements: [MyTableGrid.ADD_BTN, MyTableGrid.EDIT_BTN, MyTableGrid.DEL_BTN, MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgIntermediary.keys.removeFocus(tbgIntermediary.keys._nCurrentFocus, true);
						tbgIntermediary.keys.releaseKeys();
					}, 
					onDelete:function(){
						if(rowIndex >= 0){
							var row = tbgIntermediary.geniisysRows[rowIndex];
							valDeleteRec(row);
						}else{
							showMessageBox("Please select a record.", imgMessage.ERROR);
							return false;
						}
					},
					onAdd: function(){
						ctrlSw1 = 0;
						ctrlSw2 = 1;
						tbgIntermediary.keys.releaseKeys();
						if (checkGiiss076Access()){
							showGiiss076(null, "ADD");
						}else{
							showMessageBox("You are not allowed to access this module.", "E");
							return false;
						}
					},
					onEdit: function(){
						tbgIntermediary.keys.removeFocus(tbgIntermediary.keys._nCurrentFocus, true);
						tbgIntermediary.keys.releaseKeys();
						observeChangeTagInTableGrid(tbgIntermediary);
						if(rowIndex >= 0){
							var row = tbgIntermediary.geniisysRows[rowIndex];
							if (changeTag == 1){
								showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
										function(){
											exitPage = function(){
												if (checkGiiss076Access()){
													showGiiss076(row.intmNo, "EDIT");
												}else{
													showMessageBox("You are not allowed to access this module.", "E");
													return false;
												}
											};
											saveGiiss203();
										}, 
										function(){
											if (checkGiiss076Access()){
												showGiiss076(row.intmNo, "EDIT");
											}else{
												showMessageBox("You are not allowed to access this module.", "E");
												return false;
											}
											changeTag = 0;
										}, "");
							}else{
								changeTag = 0;
								if (checkGiiss076Access()){
									showGiiss076(row.intmNo, "EDIT");
								}else{
									showMessageBox("You are not allowed to access this module.", "E");
									return false;
								}
							}
						}else{
							showMessageBox("Please select a record.", imgMessage.ERROR);
							return false;
						}
					}
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
				{ 	id:			'activeTag',
					sortable:	false,
					align:		'center',
					title:		'&#160;&#160;A',
					altTitle:   'Active Tag',
					titleAlign:	'center',
					width:		'25px',
				    sortable: true,
			   		editable: false,
			   		filterOption: true,
			   		filterOptionType : 'checkbox',
				    hideSelectAllBox: true,
				    editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
		            		if (value){
								return "A";
		            		}else{
								return "I";
		            		}
		            	}
				    })
				},
				{
					id : 'intmNo',
					filterOption : true,
					filterOptionType: 'integerNoNegative',
					title : 'Intm No.',
					titleAlign: 'right',
					align: 'right',
					width : '120px',
					renderer: function(value){
						 return formatNumberDigits(value, 12);
					}
				},
				{
					id : 'intmName',
					filterOption : true,
					title : 'Intermediary Name',
					width : '350px',
					/*renderer : function(value){ 
						return escapeHTML2(value);
					}	*/			
				},	
				{
					id : 'refIntmCd',
					filterOption : true,
					title : 'Ref Intm Code',
					width : '120px'				
				},	
				{
					id : 'intmTypeDesc',
					width : '0', 
					visible: false
				},	
				{
					id : 'parentIntmName',
					width : '0', 
					visible: false
				},		
				{	id: 'remarks',
					width: '0',
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
				},
				{
					id : 'parentIntmNo',
					width : '0',
					visible: false				
				},
				{
					id : 'intmType',
					width : '0',
					visible: false				
				}
			],
			rows : objGIISS203.intermediaryList.rows,
			resetChangeTag : true
		};

		tbgIntermediary = new MyTableGrid(intermediaryTableModel);
		tbgIntermediary.pager = objGIISS203.intermediaryList;
		tbgIntermediary.render("intermediaryTable");
		
		function setFieldValues(rec){
			try{
				$("txtIntmNo").value = (rec == null ? "" : formatNumberDigits(rec.intmNo, 12));
				$("txtIntmNo").setAttribute("lastValidValue", (rec == null ? "" : rec.intmNo));
				$("txtIntmName").value = (rec == null ? "" : unescapeHTML2(rec.intmName));
				$("txtRefIntmCd").value = (rec == null ? "" : unescapeHTML2(rec.refIntmCd));
				$("chkActiveTag").checked = (rec == null ? false : rec.activeTag == "A" ? true : false);
				$("hidIntmType").value = (rec == null ? "" : unescapeHTML2(rec.intmType));
				$("txtIntmTypeDesc").value = (rec == null ? "" : unescapeHTML2(rec.intmTypeDesc));
				$("hidParentIntmNo").value = (rec == null ? "" : rec.parentIntmNo);
				$("txtParentIntmName").value = (rec == null ? "" : unescapeHTML2(rec.parentIntmName));
				$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
				$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
				$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
				
				rec == null ? $("chkActiveTag").disabled = true : $("chkActiveTag").disabled = false;
				rec == null ? $("txtIntmName").readOnly = true : $("txtIntmName").readOnly = false;
				rec == null ? $("txtRefIntmCd").readOnly = true : $("txtRefIntmCd").readOnly = false;
				rec == null ? $("txtRemarks").readOnly = true : $("txtRemarks").readOnly = false;
				rec == null ? disableButton("btnUpdate") : enableButton("btnUpdate");
				objIntermediary = rec;
			} catch(e){
				showErrorMessage("setFieldValues", e);
			}
		}
		
		function setRec(rec){
			try {
				var obj = (rec == null ? {} : rec);
				obj.intmNo = $F("txtIntmNo");
				obj.intmName =  escapeHTML2($F("txtIntmName"));
				obj.refIntmCd = escapeHTML2($F("txtRefIntmCd"));
				obj.activeTag = $("chkActiveTag").checked ? "A" : "I";
				obj.intmType = $F("hidIntmType");
				obj.intmTypeDesc = escapeHTML2($F("txtIntmTypeDesc"));
				obj.parentIntmNo = $F("hidParentIntmNo");
				obj.parentIntmName = escapeHTML2($F("txtParentIntmName"));
				obj.remarks = escapeHTML2($F("txtRemarks"));
				obj.userId = userId;
				var lastUpdate = new Date();
				obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
				
				return obj;
			} catch(e){
				showErrorMessage("setRec", e);
			}
		}
		
		function updateRec(){
			try {
				if (checkAllRequiredFieldsInDiv('intermediaryFormDiv')){
					changeTagFunc = saveGiiss203;
					var dept = setRec(objIntermediary);
					tbgIntermediary.updateVisibleRowOnly(dept, rowIndex, false);
					changeTag = 1;
					setFieldValues(null);
					tbgIntermediary.keys.removeFocus(tbgIntermediary.keys._nCurrentFocus, true);
					tbgIntermediary.keys.releaseKeys();
				}				
			} catch(e){
				showErrorMessage("updateRec", e);
			}
		}	
		
		function valDeleteRec(row){
			try{
				new Ajax.Request(contextPath + "/GIISIntermediaryController", {
					parameters : {action : "valDeleteRec",
								  intmNo : row.intmNo},
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response){
						hideNotice();
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
							var json = JSON.parse(response.responseText);
							
							ctrlSw1 = json.ctrlSw1;
							if (json.msg != null || json.msg != ""){
								var msgType = ctrlSw1 == 1? "I" : "E";
								showWaitingMessageBox(json.msg, msgType, function(){
									if (ctrlSw1 == 1){
										if (checkGiiss076Access()){
											showGiiss076(row.intmNo, "EDIT");
										}else{
											showMessageBox("You are not allowed to access this module.", "E");
											return false;
										}
									}
								});
							}
							
						}
					}
				});
			} catch(e){
				showErrorMessage("valDeleteRec", e);
			}
		}
	
	function exitPage(){
		objUW.GIISS203.intmTypes = "";
		objUW.GIISS203.setWhere = "";
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}	
	
	function cancelGiiss203(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS203.afterSave = exitPage;
						saveGiiss203();
					}, function(){
						exitPage();
					}, "");
		} else {
			exitPage();
		}
	}
	
	
	function chkIntmTypesChanged(intmType, checked){
		try{
			/*if (checked){
				search1 = ", '" + intmType + "'";
				search2 = "'" + intmType + "',";
				var oldWhere = objUW.GIISS203.setWhere.indexOf('AND') == -1 ? objUW.GIISS203.setWhere : objUW.GIISS203.setWhere.substring(3, objUW.GIISS203.setWhere.length);
				var val2 = objUW.GIISS203.intmTypes.replace(search1, "").replace(search2, "");
				objUW.GIISS203.intmTypes = val2;
				objUW.GIISS203.setWhere = "AND intm_type IN ('" + intmType + (oldWhere == null || oldWhere == "" ? "')" : "') OR " + oldWhere);
			}else{
				objUW.GIISS203.intmTypes = objUW.GIISS203.intmTypes == "" || objUW.GIISS203.intmTypes == undefined ? "'" + intmType + "'" : "'" + intmType + "', " + objUW.GIISS203.intmTypes; 
				objUW.GIISS203.setWhere = "AND intm_type NOT IN (" + objUW.GIISS203.intmTypes + ")";				
			}*/
			var chkIntm = "";
			var unchkIntm = "";
			
			$$("input[name='chkIntmTypes']").each(function(chk){
				if (chk.checked){
					chkIntm = chkIntm + "'" + chk.value + "',";
				}else{
					unchkIntm = unchkIntm + "'" + chk.value + "',"; 
				}
			});
			
			if (chkIntm != "") chkIntm = (" AND intm_type IN (" + chkIntm.substring(0, chkIntm.length - 1) + ")");
			if (unchkIntm != "") unchkIntm = (" OR intm_type NOT IN (" + unchkIntm.substring(0, unchkIntm.length - 1) + ")");
			
			objUW.GIISS203.setWhere = chkIntm + unchkIntm;
			
			tbgIntermediary.url = contextPath + "/GIISIntermediaryController?action=showGiiss203&refresh=1&setWhere="+encodeURIComponent(objUW.GIISS203.setWhere);
			tbgIntermediary.refresh();
		}catch(e){
			showErrorMessage("chkIntmTypesChanged", e);
		}
	}
	
	
	function checkGiiss076Access(){
		var isAccessible = false
		new Ajax.Request(contextPath+"/GIISUserController",{
			parameters: {
				action : "checkUserAccess2Gipis",
				moduleId : "GIISS076"
			},
			evalScripts: true,
			asynchronous: false,
			onComplete: function(response) {				
				if(response.responseText == "1"){
					isAccessible = true;
				}
			}
		});
		
		return isAccessible;
	}
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$$("input[name='chkIntmTypes']").each(function(chk){
		chk.observe("click", function(){
			var intmType = chk.value;
			if (changeTag == 1){
				showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
								function(){
									objGIISS203.afterSave = function(){
										chkIntmTypesChanged(intmType, chk.checked);
									};
									saveGiiss203();
								},
								function(){
									changeTag = 0;
									chkIntmTypesChanged(intmType, chk.checked);	
								},
								""
				);
			}else{
				chkIntmTypesChanged(intmType, chk.checked);	
			}
		});
	});
	
	
	
	observeSaveForm("btnSave", saveGiiss203);
	$("btnCancel").observe("click", cancelGiiss203);
	$("btnUpdate").observe("click", updateRec);
	
	$("intermediaryExit").stopObserving("click");
	$("intermediaryExit").observe("click", function(){
		cancelGiiss203();
	});
	
	setFieldValues(null);
</script>