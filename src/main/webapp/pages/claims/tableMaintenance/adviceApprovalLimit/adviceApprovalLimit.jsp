<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="gicls182MainDiv" name="gicls182MainDiv" style="">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Reserve/Advice Approval Limit Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="gicls182" name="gicls182">		
		<div class="sectionDiv">
			<div style="" align="center" id="paramDiv">
				<table cellspacing="2" border="0" style="margin: 10px auto;">	 			
					<tr>
						<td class="rightAligned" style="" id="">User ID</td>
						<td class="leftAligned" colspan="3">
							<div class="required" style="float: left; width: 105px; height: 21px; margin-right: 5px; margin-top: 2px; border: solid gray 1px;">
								<input class="required allCaps" type="text" id="txtUserId1" name="txtUserId1" style="width: 80px; float: left; border: none; height: 13px; margin: 0;" maxlength="8" tabindex="101" lastValidValue="" ignoreDelKey="1"/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchUserLOV" name="searchUserLOV" alt="Go" style="float: right;" tabindex="102"/>
							</div>
							<input id="txtUserName" name="txtUserName" type="text" style="width: 250px; height: 15px;" value="" readonly="readonly" tabindex="103"/>
						</td>
						<td class="rightAligned" style="padding-left: 40px;" id="">Branch</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan required" style="float: left; width: 55px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required allCaps" type="text" id="txtIssCd" name="txtIssCd" style="width: 30px; float: left; border: none; height: 13px; margin: 0;" maxlength="2" tabindex="103" lastValidValue="" ignoreDelKey="1"/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIssLOV" name="searchIssLOV" alt="Go" style="float: right;" tabindex="104"/>
							</span>
							<input id="txtIssName" name="txtIssName" type="text" style="width: 250px; height: 15px;" value="" readonly="readonly" tabindex="103"/>
						</td>						
					</tr>
				</table>			
			</div>		
		</div>
		<div class="sectionDiv">
			<div id="advLineAmtTableDiv" style="padding-top: 10px;">
				<div id="advLineAmtTable" style="height: 340px; margin-left: 150px;"></div>
			</div>
			<div align="center" id="advLineAmtFormDiv">
				<table style="margin-top: 10px;">
					<tr>
						<td class="rightAligned">Line</td>
						<td class="leftAligned" colspan="3">
							<input id="txtLineCd" type="text" class="" readonly="readonly" style="width: 50px; " tabindex="201" maxlength="3">
							<input id="txtLineName" type="text" class="" readonly="readonly" style="width: 400px;" tabindex="202" maxlength="20">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Advice Approval Limit</td>
						<td class="leftAligned"><input id="txtRangeTo" type="text" class="applyDecimalRegExp2" regExpPatt="pDeci1602" style="width: 180px;" maxlength="17" customLabel="Advice Approve Limit" min="0.00" max="99999999999999.99" hideErrMsg="Y" tabindex="203"></td>						
						<td></td>
						<td class="leftAligned">
							<input id="chkAllAmtSw" type="checkbox" style="float: left; margin: 0 7px 0 0px;"><label for="chkAllAmtSw" style="margin: 0 4px 2px 2px;">Advice All Amount</label>
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned" style="padding-left: 15px;">Reserve Approval Limit</td>
						<td class="leftAligned"><input id="txtResRangeTo" type="text" class="applyDecimalRegExp2" regExpPatt="pDeci1602" style="width: 180px;" maxlength="17" customLabel="Reserve Approve Limit" min="0.00" max="99999999999999.99" hideErrMsg="Y" tabindex="204"></td>
						<td></td>
						<td class="leftAligned">
							<input id="chkAllResAmtSw" type="checkbox" style="float: left; margin: 0 7px 0 0px;"><label for="chkAllResAmtSw" style="margin: 0 4px 2px 2px;">Reserve All Amount</label>
						</td>
					</tr>	
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 180px;" readonly="readonly" tabindex="205"></td>
						<td width="" class="rightAligned" style="padding-left: 15px;">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 180px;" readonly="readonly" tabindex="206"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px 0 10px 0;" class="buttonsDiv">
				<input type="button" class="button" id="btnUpdate" value="Update" tabindex="207">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="208">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="209">
</div>
<script type="text/javascript">	
	setModuleId("GICLS182");
	setDocumentTitle("Reserve/Advice Approval Limit Maintenance");
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGicls182(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgAdvLineAmt.geniisysRows);
		//var delRows = getDeletedJSONObjects(tbgAdvLineAmt.geniisysRows);
		new Ajax.Request(contextPath+"/GICLAdvLineAmtController", {
			method: "POST",
			parameters : {action : "saveGicls182",
					 	  setRows : prepareJsonAsParameter(setRows)
					 	  //delRows : prepareJsonAsParameter(delRows)
					 	  },
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGICLS182.afterSave != null) {
							objGICLS182.afterSave();
							objGICLS182.afterSave = null;
						} else {
							tbgAdvLineAmt._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGICLS182);
	
	var objGICLS182 = {};
	var objAdvLineAmt = null;
	objGICLS182.advLineAmtList = JSON.parse('${jsonAdvLineAmtList}');
	objGICLS182.afterSave = null;
	
	var advLineAmtTable = {
			url : contextPath + "/GICLAdvLineAmtController?action=showGICLS182&refresh=1&advUser="+$F("txtUserId1")+"&issCd="+$F("txtIssCd"),
			options : {
				width : '650px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objAdvLineAmt = tbgAdvLineAmt.geniisysRows[y];
					setFieldValues(objAdvLineAmt);
					tbgAdvLineAmt.keys.removeFocus(tbgAdvLineAmt.keys._nCurrentFocus, true);
					tbgAdvLineAmt.keys.releaseKeys();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgAdvLineAmt.keys.removeFocus(tbgAdvLineAmt.keys._nCurrentFocus, true);
					tbgAdvLineAmt.keys.releaseKeys();
					$("txtLineCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgAdvLineAmt.keys.removeFocus(tbgAdvLineAmt.keys._nCurrentFocus, true);
						tbgAdvLineAmt.keys.releaseKeys();
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
					tbgAdvLineAmt.keys.removeFocus(tbgAdvLineAmt.keys._nCurrentFocus, true);
					tbgAdvLineAmt.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgAdvLineAmt.keys.removeFocus(tbgAdvLineAmt.keys._nCurrentFocus, true);
					tbgAdvLineAmt.keys.releaseKeys();
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
					tbgAdvLineAmt.keys.removeFocus(tbgAdvLineAmt.keys._nCurrentFocus, true);
					tbgAdvLineAmt.keys.releaseKeys();
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
					id : "lineCd lineName",
					title: 'Line',
					filterOption : true,
					sortable: true,
					width : '120px',
					children: [
							{
								id: 'lineCd',
								title: 'Line Cd',
								width: 50,
								filterOption: true
							} ,
							{
								id: 'lineName',
								title: 'Line Name',
								width: 150,
								filterOption: true
							} 
					]
				},
				{ 	id:			'allAmtSw',
					align:		'center',
					title:		'&#160;&#160;A',
					altTitle:   'Advice All Amount',
					titleAlign:	'center',
					width:		'35px',
				    //sortable: false,
			   		editable: false,
			   		filterOption: true,
			   		filterOptionType : 'checkbox',
				    editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}else{
								return "N";
		            		}
		            	}
				    })
				},	
				{
					id : 'rangeTo',
					title : 'Advice Approval Limit',
					titleAlign: 'right',
					align: 'right',
					width : '170px',
					filterOption : true,	
					filterOptionType: 'number',
					renderer: function(value){
						return formatCurrency(value);
					}
				},				
				{ 	id:			'allResAmtSw',
					align:		'center',
					title:		'&#160;&#160;R',
					altTitle:   'Reserve All Amount',
					titleAlign:	'center',
					width:		'35px',
				    //sortable: false,
			   		editable: false,
			   		filterOption: true,
			   		filterOptionType : 'checkbox',
				    editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}else{
								return "N";
		            		}
		            	}
				    })
				},
				{
					id : 'resRangeTo',
					title : 'Reserve Approval Limit',
					titleAlign: 'right',
					align: 'right',
					width : '170px',
					filterOption : true,	
					filterOptionType: 'number',
					renderer: function(value){
						return formatCurrency(value);
					}
				},	
				{
					id : 'userId',
					title: 'User',
					width : '0px',
					visible: false
				},
				{
					id : 'lastUpdate',
					title: 'Last Update',
					width : '0px',
					visible: false
				}
			],
			rows : objGICLS182.advLineAmtList.rows
		};

		tbgAdvLineAmt = new MyTableGrid(advLineAmtTable);
		tbgAdvLineAmt.pager = objGICLS182.advLineAmtList;
		tbgAdvLineAmt.render("advLineAmtTable");
	
	function setFieldValues(rec){
		try{
			$("txtLineCd").value = (rec == null ? "" : unescapeHTML2(rec.lineCd));
			$("txtLineName").value = (rec == null ? "" : unescapeHTML2(rec.lineName));
			$("chkAllAmtSw").checked = (rec == null ? false : rec.allAmtSw == "Y" ? true : false);
			$("txtRangeTo").value = (rec == null ? "" : formatCurrency(rec.rangeTo));
			$("chkAllResAmtSw").checked = (rec == null ? false : rec.allResAmtSw == "Y" ? true : false);
			$("txtResRangeTo").value = (rec == null ? "" : formatCurrency(rec.resRangeTo));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			
			objAdvLineAmt = rec;
			
			rec == null ? toggleAdvLineAmtFields(false) : toggleAdvLineAmtFields(true);
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.advUser = escapeHTML2($F("txtUserId1"));
			obj.issCd = escapeHTML2($F("txtIssCd"));
			obj.lineCd = escapeHTML2($F("txtLineCd"));
			obj.lineName = escapeHTML2($F("txtLineName"));
			obj.allAmtSw = $("chkAllAmtSw").checked ? "Y" : "N";
			obj.rangeTo = $F("txtRangeTo");
			obj.allResAmtSw = $("chkAllResAmtSw").checked ? "Y" : "N";
			obj.resRangeTo = $F("txtResRangeTo");
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
			changeTagFunc = saveGicls182;
			var adv = setRec(objAdvLineAmt);
			
			tbgAdvLineAmt.updateVisibleRowOnly(adv, rowIndex, false);
			changeTag = 1;
			setFieldValues(null);
			tbgAdvLineAmt.keys.removeFocus(tbgAdvLineAmt.keys._nCurrentFocus, true);
			tbgAdvLineAmt.keys.releaseKeys();
		} catch(e){
			showErrorMessage("updateRec", e);
		}
	}		
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
	}	
	
	function cancelGicls182(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGICLS182.afterSave = exitPage;
						saveGicls182();
					}, function(){
						goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
		}
	}
	
	function showUserLOV(isIconClicked){
		try{
			var searchString = isIconClicked ? "%" : ($F("txtUserId1").trim() == "" ? "%" : $F("txtUserId1"));	
			
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getGICLS182UserLOV",
					searchString : searchString,
					moduleId: 'GICLS182',
					page : 1
				},
				title : "List of Users",
				width : 385,
				height : 386,
				columnModel : [ {
					id : "userId",
					title : "User ID",
					width : '120px',
				}, {
					id : "userName",
					title : "User Name",
					width : '250px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("txtUserId1").value = unescapeHTML2(row.userId);
						$("txtUserId1").setAttribute("lastValidValue", $F("txtUserId1"));
						$("txtUserName").value = unescapeHTML2(row.userName);
						$("txtIssCd").clear();
						$("txtIssCd").setAttribute("lastValidValue", "");
						$("txtIssCd").readOnly = false;
						$("txtIssCd").focus();
						$("txtIssName").clear();
						enableSearch("searchIssLOV");
						enableToolbarButton("btnToolbarExecuteQuery");
						enableToolbarButton("btnToolbarEnterQuery");
					}
				},
				onCancel: function(){
					$("txtUserId1").focus();
					$("txtUserId1").value = $("txtUserId1").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtUserId1").value = $("txtUserId1").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtUserId1");
				} 
			});
		}catch(e){
			showErrorMessage("showUserLOV", e);
		}		
	}
	
	function showIssLOV(isIconClicked){
		try{
			var searchString = isIconClicked ? "%" : ($F("txtIssCd").trim() == "" ? "%" : $F("txtIssCd"));	
			
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getGICLS182IssLOV",
					userId:	$F("txtUserId1"),
					searchString : searchString,
					moduleId: 'GICLS182',
					page : 1
				},
				title : "List of Branches",
				width : 375,
				height : 386,
				columnModel : [ {
					id : "issCd",
					title : "Branch Code",
					width : '90px',
				}, {
					id : "issName",
					title : "Branch Name",
					width : '270px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("txtIssCd").value = unescapeHTML2(row.issCd);
						$("txtIssCd").setAttribute("lastValidValue", $F("txtIssCd"));
						$("txtIssName").value = unescapeHTML2(row.issName);
						enableToolbarButton("btnToolbarExecuteQuery");
						enableToolbarButton("btnToolbarEnterQuery");
					}
				},
				onCancel: function(){
					$("txtIssCd").focus();
					$("txtIssCd").value = $("txtIssCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtIssCd").value = $("txtIssCd").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtIssCd");
				} 
			});
		}catch(e){
			showErrorMessage("showIssLOV", e);
		}		
	}
	
	function toggleAdvLineAmtFields(enable){
		try{
			if (enable){
				$("chkAllAmtSw").disabled = false;
				$("txtRangeTo").readOnly = false;
				$("chkAllResAmtSw").disabled = false;
				$("txtResRangeTo").readOnly = false;
				enableButton("btnUpdate");		
			}else{				
				$("chkAllAmtSw").disabled = true;
				$("txtRangeTo").readOnly = true;
				$("chkAllResAmtSw").disabled = true;
				$("txtResRangeTo").readOnly = true;
				disableButton("btnUpdate");
			}
		}catch(e){
			showErrorMessage("toggleAdvLineAmtFields", e);
		}
	}
	
	function toggleParamFields(enable){
		try{
			if (enable){
				$("txtUserId1").readOnly = false;
				//$("txtIssCd").readOnly = false;
				enableSearch("searchUserLOV");
				//enableSearch("searchIssLOV");
			}else{				
				$("txtUserId1").readOnly = true;
				$("txtIssCd").readOnly = true;
				disableSearch("searchUserLOV");
				disableSearch("searchIssLOV");
			}
		}catch(e){
			showErrorMessage("toggleParamFields", e);
		}
	}
	
	function enterQuery(){
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		tbgAdvLineAmt.url = contextPath+"/GICLAdvLineAmtController?action=showGICLS182&refresh=1";
		tbgAdvLineAmt._refreshList();
		$("txtUserId1").setAttribute("lastValidValue", "");
		$("txtUserId1").clear();
		$("txtUserName").clear();
		$("txtIssCd").setAttribute("lastValidValue", "");
		$("txtIssCd").readOnly = true;
		$("txtIssCd").clear();
		$("txtIssName").clear();
		disableSearch("searchIssLOV");
		toggleAdvLineAmtFields(false);
		toggleParamFields(true);
		$("txtUserId1").focus();
		changeTag = 0;
	}
	
	$("searchUserLOV").observe("click", function(){
		showUserLOV(true);
	});
	
	$("txtUserId1").observe("change", function(){
		if (this.value != ""){
			showUserLOV(false);
		}else{
			this.setAttribute("lastValidValue", "");
			$("txtUserName").clear();
			$("txtIssCd").clear();
			$("txtIssName").clear();
			$("txtIssCd").readOnly = true;
			disableSearch("searchIssLOV");
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		}
	});
	
	$("searchIssLOV").observe("click", function(){
		showIssLOV(true);
	});
	
	$("txtIssCd").observe("change", function(){
		if (this.value != ""){
			showIssLOV(false);
		}else{
			this.setAttribute("lastValidValue", "");
			$("txtIssName").clear();
			disableToolbarButton("btnToolbarExecuteQuery");
		}
	});
		
	$("chkAllAmtSw").observe("click", function(){
		if (this.checked){
			showConfirmBox("CONFIRMATION", "Tagging this item will allow " + $F("txtUserId") + " to issue advice with no amount limit. " +
							"Do you want to continue?", "Yes", "No",
							function(){
								$("txtRangeTo").clear();
								$("txtRangeTo").setAttribute("lastValidValue", "");
							},
							function(){
								$("chkAllAmtSw").checked = false;
							}
			);
		}
	});
	
	$("chkAllResAmtSw").observe("click", function(){
		if (this.checked){
			showConfirmBox("CONFIRMATION", "Tagging this item will allow " + $F("txtUserId") + " to set reserve with no amount limit. " +
							"Do you want to continue?", "Yes", "No",
							function(){
								$("txtResRangeTo").clear();
								$("txtResRangeTo").setAttribute("lastValidValue", "");
							},
							function(){
								$("chkAllResAmtSw").checked = false;
							}
			);
		}
	});
	
	$("txtRangeTo").observe("blur", function(){
		if ($("chkAllAmtSw").checked && this.value != ""){
			showConfirmBox("CONFIRMATION", "You cannot input an amount unless advice all amount switch is disabled. " +
							"Would you like to disable advice all amount switch?", "Yes", "No",
							function(){
								$("chkAllAmtSw").checked = false;								
							},
							function(){
								$("txtRangeTo").clear();
								$("txtRangeTo").setAttribute("lastValidValue", "");
							}
			);
		}
	});
	
	$("txtResRangeTo").observe("focus", function(){
		if ($("chkAllResAmtSw").checked && this.value != ""){
			showConfirmBox("CONFIRMATION", "You cannot input an amount unless reserve all amount switch is disabled. " +
							"Would you like to disable reserve all amount switch?", "Yes", "No",
							function(){
								$("chkAllResAmtSw").checked = false;								
							},
							function(){
								$("txtResRangeTo").clear();
								$("txtResRangeTo").setAttribute("lastValidValue", "");
							}
			);
		}
	});
	
	$("txtResRangeTo").observe("change", function(){
		if ($("chkAllResAmtSw").checked && this.value != ""){
			showConfirmBox("CONFIRMATION", "You cannot input an amount unless reserve all amount switch is disabled. " +
							"Would you like to disable reserve all amount switch?", "Yes", "No",
							function(){
								$("chkAllResAmtSw").checked = false;								
							},
							function(){
								$("txtResRangeTo").clear();
								$("txtResRangeTo").setAttribute("lastValidValue", "");
							}
			);
		}
	});
	
	$("btnToolbarEnterQuery").observe("click", function(){
		if (changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
					function(){
						objGICLS182.afterSave = enterQuery;
						saveGicls182();
					},
					function(){
						enterQuery();
					},
					""
			); 
		}else{
			enterQuery();
		}
	});
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		if (checkAllRequiredFieldsInDiv('paramDiv')){
			disableToolbarButton(this.id);
			enableToolbarButton("btnToolbarEnterQuery");
			tbgAdvLineAmt.url = contextPath+"/GICLAdvLineAmtController?action=showGICLS182&refresh=1&advUser="
								+encodeURIComponent($F("txtUserId1"))+"&issCd="+encodeURIComponent($F("txtIssCd"));
			tbgAdvLineAmt._refreshList();
			toggleAdvLineAmtFields(false);
			toggleParamFields(false);
		}
	});
	
	showToolbarButton("btnToolbarSave");
	hideToolbarButton("btnToolbarPrint");
	disableToolbarButton("btnToolbarEnterQuery");
	disableToolbarButton("btnToolbarExecuteQuery");
	
	observeSaveForm("btnSave", saveGicls182);
	observeSaveForm("btnToolbarSave", saveGicls182);
	$("btnCancel").observe("click", cancelGicls182);
	$("btnUpdate").observe("click", updateRec);

	$("btnToolbarExit").stopObserving("click");
	$("btnToolbarExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
		
	toggleAdvLineAmtFields(false);
	initializeAll();
	$("txtUserId1").focus();	
	$("txtIssCd").readOnly = true;
	disableSearch("searchIssLOV");
</script>