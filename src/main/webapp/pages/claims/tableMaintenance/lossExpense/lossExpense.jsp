<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="gicls104MainDiv" name="gicls104MainDiv" style="">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Loss/Expense Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	
	<div class="sectionDiv" id="searchLineCdDiv" style="height: 80px;">
		<table style="margin: 20px 0 20px 160px; width:800px;">
			<tr>
				<td class="rightAligned">Line</td>
				<td>
					<span class="lovSpan required" style="float: left; width: 130px; margin-right: 5px; margin-top: 2px; height: 21px;">
						<input type="text" id="txtLineCd" name="txtLineCd" lastValidValue="" class="required" ignoreDelKey="" style="width: 105px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="101" />
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osLineCd" name="osLineCd" alt="Go" style="float: right;" />
					</span>
					<input type="text" id="txtLineName" name="txtLineName" style="width: 400px; float: left; height: 15px;" readonly="readonly" maxlength="20" tabindex="102" />
					<input type="hidden" id="hidMenuLineCd" />
				</td>				
			</tr>
		</table>
	</div>
	
	<div id="gicls104" name="gicls104">		
		<div class="sectionDiv">
			<div id="lossExpenseTableDiv" >
				<div id="lossExpenseTable" style="height: 340px; margin: 10px;"></div>
			</div>
			<div align="center" id="lossExpenseFormDiv">
				<table style="margin-top: 10px; width: 700px;" border="0">
					<tr>
						<td class="rightAligned">Code</td>
						<td class="leftAligned">
							<input id="txtLossExpCd" type="text" class="required" readonly="readonly" style="width: 200px;" ignoreDelKey="" tabindex="201" maxlength="5" />
							<input id="hidSublineCd" type="hidden" />
						</td>
						<td width="150px">&nbsp;</td>
						<td id="tdPartSwLpsSw">
							<input type="checkbox" id="chkPartSw" style="float: left; margin-left: 5px;"/>
							<label for="chkPartSw" style="float: left; margin-top: 2px; margin-left: 5px;">Part</label>
							<input type="checkbox" id="chkLpsSw"  style="float: left; margin-left: 65px;" />
							<label for="chkLpsSw" style="float: left; margin-top: 2px; margin-left: 5px;">LPS Switch</label>							
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Description</td>
						<td class="leftAligned" colspan="3"><input id="txtLossExpDesc" class="required" type="text" style="width: 593px;" tabindex="202" maxlength="30"></td>					
					</tr>	
					<tr>
						<td class="rightAligned">Type</td>
						<td class="leftAligned">
							<select id="selType" lastValidValue="" style="width: 210px;" tabindex="203" class="required">
								<option value="L">LOSS</option>
								<option value="E">EXPENSE</option>
							</select>
							<input type="hidden" id="hidOldLossExpType" />
						</td>
						<td class="rightAligned">Computation Switch</td>
						<td class="leftAligned" >
							<select id="selCompSw" style="width: 210px;" lastValidValue="" tabindex="204">
								<option value=""></option>
								<option value="+">+</option>
								<option value="-">-</option>
							</select>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Peril</td>
						<td class="leftAligned" colspan="3">
							<span id="perilCdLovSpan" class="lovSpan" style="float: left; width: 100px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input type="text" id="txtPerilCd" name="txtPerilCd" lastValidValue="" class="integerNoNegativeUnformattedNoComma" ignoreDelKey="" style="width: 75px; float: left; border: none; height: 15px; margin: 0; text-align: right;" maxlength="5" tabindex="205" />
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osPerilCd" name="osPerilCd" alt="Go" style="float: right;" />
							</span>
							<input type="text" id="txtPerilName" name="txtPerilName" style="width: 485px; float: left; height: 15px;" readonly="readonly" tabindex="206" />
						</td>					
					</tr>
					<tr>
						<td class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div name="remarksDiv" style="float: left; width: 598px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 504px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="210"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="211"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="212"></td>
						<td width="110px" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 201px;" readonly="readonly" tabindex="213"></td>
					</tr>			
				</table>
			</div>
			<div class="buttonsDiv" style="margin: 10px;">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="301">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="302">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv" style="margin:10px 0 50px 10px;">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="303">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="304">
</div>
<script type="text/javascript">	
	setModuleId("GICLS104");
	setDocumentTitle("Loss/Expense Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	var giispLineCdMC = ('${giispLineCdMC}');
	var giispLineNameMC = ('${giispLineNameMC}');
	var varMenuLineCd = "";
	
	var variableCsType = null; //variable.v_cstype
	
	disableToolbarButton("btnToolbarEnterQuery");
	disableToolbarButton("btnToolbarExecuteQuery");
	hideToolbarButton("btnToolbarPrint");
	showToolbarButton("btnToolbarSave");
	setForm(false);
	
	function saveGicls104(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgLossExpense.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgLossExpense.geniisysRows);
		new Ajax.Request(contextPath+"/GIISLossExpController", {
			method: "POST",
			parameters : {action : "saveGicls104",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGICLS104.exitPage != null) {
							objGICLS104.exitPage();
						} else {
							tbgLossExpense._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGicls104);
	
	var objGICLS104 = {};
	var objCurrLossExpense = null;
	var objCurrLossExpenseMC = null;
	objGICLS104.lossExpenseList = [];
	objGICLS104.exitPage = null;
	
	var firstLoad = false;
	var partSw = ""; //Pol 02.27.2014
	initializeTG($F("txtLineCd"));
	$("tdPartSwLpsSw").hide();
	
	function initializeTG(lineCd){		
		
		var lossExpenseTable = {
				url : contextPath + "/GIISLossExpController?action=showGicls104&refresh=1&lineCd="+encodeURIComponent($F("txtLineCd")) + "&partSw=" + partSw,
				id : "tbl",
				options : {
					width : '900px',
					hideColumnChildTitle: true,
					pager : {},
					onCellFocus : function(element, value, x, y, id){
						rowIndex = y;
						objCurrLossExpense = tbgLossExpense.geniisysRows[y];
						setFieldValues(objCurrLossExpense);
						tbgLossExpense.keys.removeFocus(tbgLossExpense.keys._nCurrentFocus, true);
						tbgLossExpense.keys.releaseKeys();
						$("txtLossExpCd").focus();
					},
					onRemoveRowFocus : function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgLossExpense.keys.removeFocus(tbgLossExpense.keys._nCurrentFocus, true);
						tbgLossExpense.keys.releaseKeys();
						$("txtLossExpCd").focus();
					},					
					toolbar : {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
						onFilter: function(){
							rowIndex = -1;
							setFieldValues(null);
							tbgLossExpense.keys.removeFocus(tbgLossExpense.keys._nCurrentFocus, true);
							tbgLossExpense.keys.releaseKeys();
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
						tbgLossExpense.keys.removeFocus(tbgLossExpense.keys._nCurrentFocus, true);
						tbgLossExpense.keys.releaseKeys();
					},
					onRefresh: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgLossExpense.keys.removeFocus(tbgLossExpense.keys._nCurrentFocus, true);
						tbgLossExpense.keys.releaseKeys();
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
						tbgLossExpense.keys.removeFocus(tbgLossExpense.keys._nCurrentFocus, true);
						tbgLossExpense.keys.releaseKeys();
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
						id: 'lineCd',
						width: '0',
						visible: false
					},
					{
						id: 'menuLineCd',
						width: '0',
						visible: false
					},
					{
						id: 'partSw',
	              		title : '&#160;&#160;P',
	              		titleAlign: 'center',
	              		altTitle: 'Part',
		              	width: ((lineCd == giispLineCdMC || varMenuLineCd == giispLineCdMC) ? '25px' : '0'),
		              	align: 'center',
		              	editable: false,
		              	sortable: ((lineCd == giispLineCdMC || varMenuLineCd == giispLineCdMC) ? true : false),
		              	filterOption: ((lineCd == giispLineCdMC || varMenuLineCd == giispLineCdMC) ? true : false),
		              	filterOptionType : 'checkbox',
		              	visible: ((lineCd == giispLineCdMC || varMenuLineCd == giispLineCdMC) ? true : false),
		              	defaultValue: true,
						otherValue:	false,
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
						id: 'lpsSw',
	              		title : '&#160;&#160;L',
	              		titleAlign: 'center',
	              		altTitle: 'LPS Switch',
		              	width: ((lineCd == giispLineCdMC || varMenuLineCd == giispLineCdMC) ? '25px' : '0'),
		              	align: 'center',
		              	editable: false,
		              	sortable: ((lineCd == giispLineCdMC || varMenuLineCd == giispLineCdMC) ? true : false),
		              	filterOption: ((lineCd == giispLineCdMC || varMenuLineCd == giispLineCdMC) ? true : false),
		              	filterOptionType : 'checkbox',
		              	visible: ((lineCd == giispLineCdMC || varMenuLineCd == giispLineCdMC) ? true : false),
		              	defaultValue: false,
						otherValue:	false,
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
						id : "lossExpCd",
						title : "Code",
						width : '80px',
						filterOption : true
					},
					{
						id : 'lossExpDesc',
						title : 'Description',
						filterOption : true,
						width : '280px'				
					},
					{
						id : "lossExpType",
						title: "Type",
						width : '100px',
						filterOption: true,
						renderer: function(value){
							return (value == "L" ? "LOSS" : "EXPENSE");
						}
					},
					{
						id : "perilCd perilName",
						title: "Peril",
						width : '300px',
						filterOption: true,
						children:[
							{
								id : "perilCd",
								title: "Peril Code",
								align: "right",
								filterOption: true,
								filterOptionType: "integerNoNegative",
								width : 80
							},{
								id : "perilName",
								title: "Peril Name",
								width : ((lineCd == giispLineCdMC || varMenuLineCd == giispLineCdMC) ? 220 : 270),
								filterOption: true
							} 
						]
					},
					{
						id : "compSw",
						title: "C.S.",
						altTitle: "Computation Switch",
						align: "center",
						width: "30px",
						filterOption: true
					},
					{
						id : "lossExpType",
						width : '0',
						visible: false
					},
					{
						id : "oldLossExpType",
						width : '0',
						visible: false
					},
					{
						id : "sublineCd",
						width : '0',
						visible: false
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
				rows : objGICLS104.lossExpenseList.rows || []
			};
		
		tbgLossExpense = new MyTableGrid(lossExpenseTable);
		tbgLossExpense.pager = objGICLS104.lossExpenseList;
		tbgLossExpense.render("lossExpenseTable");
		tbgLossExpense.afterRender = function(){
			if(firstLoad){
				firstLoad = false;
				tbgLossExpense._refreshList();
				if(lineCd == "") {
					$("txtLossExpCd").readOnly = true;
				}
			}
		};
	}
	
	function setFieldValues(rec){
		try{
			$("txtLossExpCd").value = (rec == null ? "" : unescapeHTML2(rec.lossExpCd));
			$("txtLossExpDesc").value = (rec == null ? "" : unescapeHTML2(rec.lossExpDesc));
			$("selType").value = (rec == null ? "L" : unescapeHTML2(rec.lossExpType));
			$("selType").setAttribute("lastValidValue", (rec == null ? "" : rec.lossExpType));
			$("hidOldLossExpType").value = (rec == null ? "" : unescapeHTML2(rec.oldLossExpType));
			$("selCompSw").value = (rec == null ? "+" : unescapeHTML2(rec.compSw));
			$("txtPerilCd").value = (rec == null ? "" : rec.perilCd);
			$("txtPerilCd").setAttribute("lastValidValue", (rec == null ? "" : nvl(rec.perilCd, "")));
			$("txtPerilName").value = (rec == null ? "" : unescapeHTML2(rec.perilName));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("hidSublineCd").value = (rec == null ? "" : unescapeHTML2(rec.sublineCd));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			$("txtLossExpCd").readOnly = rec == null ? false : true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			
			$("perilCdLovSpan").removeClassName("required");
			$("txtPerilCd").removeClassName("required");
			
			if($F("txtLineCd") == giispLineCdMC || $F("hidMenuLineCd") == giispLineCdMC){
				$("chkPartSw").checked = (rec == null ? true : (rec.partSw == "Y" ? true : false));
				$("chkLpsSw").checked = (rec == null ? false : (rec.lpsSw == "Y" ? true : false));
				
				$("chkPartSw").disabled = (rec == null ? false : $("chkPartSw").disabled);
				$("chkLpsSw").disabled = (rec == null ? false : $("chkLpsSw").disabled);
			} else if($F("txtLineCd") == "AH"){
				$("perilCdLovSpan").addClassName("required");
				$("txtPerilCd").addClassName("required");
			}
			objCurrLossExpense = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.lineCd = escapeHTML2($F("txtLineCd"));
			obj.lossExpCd = escapeHTML2($F("txtLossExpCd"));
			obj.lossExpDesc = escapeHTML2($F("txtLossExpDesc"));
			obj.lossExpType = escapeHTML2($F("selType"));
			obj.oldLossExpType = escapeHTML2($F("hidOldLossExpType"));
			obj.lossExpTypeSp = ( escapeHTML2($F("selType")) == "L" ? "LOSS" : "EXPENSE" );
			obj.compSw = escapeHTML2($F("selCompSw"));
			obj.perilCd = $F("txtPerilCd");
			obj.perilName = escapeHTML2($F("txtPerilName"));
			obj.sublineCd = escapeHTML2($F("hidSublineCd"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
			
			if($F("txtLineCd") == giispLineCdMC || $F("hidMenuLineCd") == giispLineCdMC){
				obj.partSw = ($("chkPartSw").checked ? "Y" : "N");
				obj.lpsSw = ($("chkLpsSw").checked ? "Y" : "N");
			}
			
			obj.userId = escapeHTML2(userId);
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGicls104;
			var dept = setRec(objCurrLossExpense);
			
			if($F("btnAdd") == "Add"){
				tbgLossExpense.addBottomRow(dept);
			} else {
				tbgLossExpense.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgLossExpense.keys.removeFocus(tbgLossExpense.keys._nCurrentFocus, true);
			tbgLossExpense.keys.releaseKeys();
			rowIndex = -1;
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}
	
	function valAddUpdateRec(mode) {
		try {
			var addedSameExists = false;
			var deletedSameExists = false;	
			var addedSameExists2 = false;
			var deletedSameExists2 = false;
			var updatedSameExists2 = false;
			var ignoreThis = false;
			for(var i=0; i<tbgLossExpense.geniisysRows.length; i++){
				if(tbgLossExpense.geniisysRows[i].recordStatus == 0 || tbgLossExpense.geniisysRows[i].recordStatus == 1){	
					if(unescapeHTML2(tbgLossExpense.geniisysRows[i].lineCd) == $F("txtLineCd") 
							&& unescapeHTML2(tbgLossExpense.geniisysRows[i].lossExpCd) == $F("txtLossExpCd")
							&& unescapeHTML2(tbgLossExpense.geniisysRows[i].lossExpType) == $F("selType")		){
						if(rowIndex != i){
							addedSameExists = true;
						} else { 
							ignoreThis = true;
						}
					} else if(unescapeHTML2(tbgLossExpense.geniisysRows[i].lineCd) == $F("txtLineCd") 
							&& unescapeHTML2(tbgLossExpense.geniisysRows[i].lossExpCd) == $F("txtLossExpCd")
							&& unescapeHTML2(tbgLossExpense.geniisysRows[i].oldLossExpType) == $F("selType")
							&& unescapeHTML2(tbgLossExpense.geniisysRows[i].lossExpType) != $F("selType")){
						if(rowIndex != i && rowIndex > 0){
							addedSameExists2 = true;
						} else { 
							ignoreThis = true;
						}
					}
					/*if(mode == "add" && unescapeHTML2(tbgLossExpense.geniisysRows[i].lineCd) == $F("txtLineCd") 
							&& unescapeHTML2(tbgLossExpense.geniisysRows[i].lossExpCd) == $F("txtLossExpCd")
							&& unescapeHTML2(tbgLossExpense.geniisysRows[i].lossExpType) == $F("selType")		){
						if(rowIndex != i){
							addedSameExists = true;	
						} else { ignoreThis = true;}
					}	
					if($F("hidOldLossExpType") != $F("selType") && unescapeHTML2(tbgLossExpense.geniisysRows[i].lineCd) == $F("txtLineCd") 
							&& unescapeHTML2(tbgLossExpense.geniisysRows[i].lossExpCd) == $F("txtLossExpCd")
							&& unescapeHTML2(tbgLossExpense.geniisysRows[i].lossExpType) == $F("selType")){
						if(rowIndex != i){
							addedSameExists2 = true;	
						} else { ignoreThis = true;}
					}	
					if($F("hidOldLossExpType") != $F("selType") && unescapeHTML2(tbgLossExpense.geniisysRows[i].lineCd) == $F("txtLineCd") 
							&& unescapeHTML2(tbgLossExpense.geniisysRows[i].lossExpCd) == $F("txtLossExpCd")
							&& unescapeHTML2(tbgLossExpense.geniisysRows[i].oldLossExpType) == $F("selType")){
						if(rowIndex != i){
							updatedSameExists2 = true;
						} else { ignoreThis = true;}
					}*/
				} else if(tbgLossExpense.geniisysRows[i].recordStatus == -1){
					if(unescapeHTML2(tbgLossExpense.geniisysRows[i].lineCd) == $F("txtLineCd") 
							&& unescapeHTML2(tbgLossExpense.geniisysRows[i].lossExpCd) == $F("txtLossExpCd")
							&& unescapeHTML2(tbgLossExpense.geniisysRows[i].oldLossExpType) == $F("selType")
							&& unescapeHTML2(tbgLossExpense.geniisysRows[i].lossExpType) != $F("selType")){
						deletedSameExists2 = true;				
					} else if(unescapeHTML2(tbgLossExpense.geniisysRows[i].lineCd) == $F("txtLineCd") 
							&& unescapeHTML2(tbgLossExpense.geniisysRows[i].lossExpCd) == $F("txtLossExpCd")
							&& unescapeHTML2(tbgLossExpense.geniisysRows[i].lossExpType) == $F("selType")){
						deletedSameExists = true;
					}
					
					/*if(mode == "add" && unescapeHTML2(tbgLossExpense.geniisysRows[i].lineCd) == $F("txtLineCd") 
							&& unescapeHTML2(tbgLossExpense.geniisysRows[i].lossExpCd) == $F("txtLossExpCd")
							&& unescapeHTML2(tbgLossExpense.geniisysRows[i].lossExpType) == $F("selType")	){
						deletedSameExists = true;
					}
					if($F("hidOldLossExpType") != $F("selType") && unescapeHTML2(tbgLossExpense.geniisysRows[i].lineCd) == $F("txtLineCd") 
							&& unescapeHTML2(tbgLossExpense.geniisysRows[i].lossExpCd) == $F("txtLossExpCd")
							&& unescapeHTML2(tbgLossExpense.geniisysRows[i].lossExpType) == $F("selType")	){
						deletedSameExists2 = true;								
					}*/	
				}
			}
			if(/*mode == "add" && */(addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
				showMessageBox("Record already exists with the same line_cd, loss_exp_cd, and loss_exp_type.", "E");
				return;
			}else if((addedSameExists2 && !deletedSameExists2) || (deletedSameExists2 && addedSameExists2)){
				showMessageBox("Record already exists with the same line_cd, loss_exp_cd, and loss_exp_type.", "E");
				return;
			} else if(deletedSameExists && !addedSameExists){
				addRec();
				return;
			} else if(deletedSameExists2 && !addedSameExists2){
				addRec();
				return;
			} /*else if(mode == "update" && (deletedSameExists2 || updatedSameExists2) && !addedSameExists2){
				addRec();
				return;
			}*/			
			if(((!addedSameExists && !deletedSameExists) || (!addedSameExists2 && !deletedSameExists2)) && ignoreThis){
				addRec();
				return;
			}
			
			new Ajax.Request(contextPath + "/GIISLossExpController", {
				parameters : {action : "valAddRec",
							  lineCd : $F("txtLineCd"),
							  lossExpCd : $F("txtLossExpCd"),
							  lossExpType : $F("selType")
							},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						addRec();
					}
				}
			});
		} catch (e) {
			showErrorMessage("valAddUpdateRec",e);
		}
	}
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("lossExpenseFormDiv")){
				if($F("btnAdd") == "Add") {
					valAddUpdateRec("add");
				} else {
					valAddUpdateRec("update");
				}
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}	
	
	function fixBackSlash(str){
		var newTemp = "";
		if(str.contains("\\")){
			var temp = str.split("");			
			for(var i=0; i<temp.length; i++){
				newTemp += (temp[i] == "\\" ? escapeHTML2(temp[i]) : temp[i]);
			}
		}
		return newTemp != "" ? newTemp : escapeHTML2(str);
	}
	
	function deleteRec(){
		changeTagFunc = saveGicls104;
		objCurrLossExpense.recordStatus = -1;
		//tbgLossExpense.geniisysRows[rowIndex].lineCd = escapeHTML2(tbgLossExpense.geniisysRows[rowIndex].lineCd);		
		var currLineCd = unescapeHTML2(tbgLossExpense.geniisysRows[rowIndex].lineCd);
		var currLEC = unescapeHTML2(tbgLossExpense.geniisysRows[rowIndex].lossExpCd);
		tbgLossExpense.geniisysRows[rowIndex].lossExpCd = fixBackSlash(currLEC);
		tbgLossExpense.geniisysRows[rowIndex].lineCd = fixBackSlash(currLineCd);
		tbgLossExpense.deleteRow(rowIndex);	
		changeTag = 1;		
		setFieldValues(null);
		rowIndex = -1;
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISLossExpController", {
				parameters : {action : "valDeleteRec",
							  lineCd : $F("txtLineCd"),
					  		  lossExpCd : $F("txtLossExpCd"),
					  		  lossExpType : $F("selType")},
			    asynchronous: false,
			    evalScripts: true,
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
	
	function exitPage(){
		if(objCLMGlobal.previousModule == "GICLS171"){
			objCLMGlobal.previousModule = null;
			objCLMGlobal.lineCd = null;
			objCLMGlobal.partSw = null;
			showGICLS171();
		}			
		else
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
	}	
	
	function cancelGicls104(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGICLS104.exitPage = exitPage;
						saveGicls104();
					}, function(){
						exitPage();
					}, "");
		} else {
			exitPage();
		}
	}
	
	function showGicls104LineCdLOV(){
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getGicls104LineLOV",
							filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
							moduleId: "GICLS104",
							page : 1},
			title: "List of Lines",
			width: 400,
			height: 400,
			columnModel : [
							{
								id : "lineCd",
								title: "Line Code",
								width: '80px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							},
							{
								id : "lineName",
								title: "Line Name",
								width: '303px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							},
							{
								id : "menuLineCd",
								visible: false,
								width: '0'
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
				onSelect: function(row) {
					enableToolbarButton("btnToolbarEnterQuery");
					enableToolbarButton("btnToolbarExecuteQuery");
					$("txtLineCd").value = unescapeHTML2(row.lineCd);
					$("txtLineCd").setAttribute("lastValidValue", unescapeHTML2(row.lineCd));
					$("txtLineName").value = unescapeHTML2(row.lineName);
					$("hidMenuLineCd").value = unescapeHTML2(row.menuLineCd);
					varMenuLineCd = $F("hidMenuLineCd");
				},
				onCancel: function (){
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	function showGicls104PerilLOV(){
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getGicls104PerilLOV",
							lineCd : $F("txtLineCd"),
							filterText : ($("txtPerilCd").readAttribute("lastValidValue").trim() != $F("txtPerilCd").trim() ? $F("txtPerilCd").trim() : ""),
							moduleId: "GICLS104",
							page : 1},
			title: "List of Perils",
			width: 500,
			height: 400,
			columnModel : [
							{
								id : "perilCd",
								title: "Peril Code",
								titleAlign: 'right',
								align: 'right',
								width: '100px'
							},
							{
								id : "perilName",
								title: "Peril Name",
								width: '370px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtPerilCd").readAttribute("lastValidValue").trim() != $F("txtPerilCd").trim() ? $F("txtPerilCd").trim() : ""),
				onSelect: function(row) {
					if(row != null && row != ""){
						$("txtPerilCd").value = row.perilCd;
						$("txtPerilCd").setAttribute("lastValidValue", row.perilCd);
						$("txtPerilName").value = unescapeHTML2(row.perilName);
					}
				},
				onCancel: function (){
					$("txtPerilCd").value = $("txtPerilCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtPerilCd").value = $("txtPerilCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	function setForm(enable){
		$("txtLossExpCd").readOnly = enable ? false : true;
		$("txtLossExpDesc").readOnly = enable ? false : true;
		$("selType").disabled = enable ? false : true;
		$("selCompSw").disabled = enable ? false : true;
		$("txtPerilCd").readOnly = enable ? false : true;
		$("txtRemarks").readOnly = enable ? false : true;
		
		if(enable){			
			enableButton("btnAdd");
			enableSearch("osPerilCd");
		} else {
			disableButton("btnAdd");
			disableButton("btnDelete");
			disableSearch("osPerilCd");
		}
	}
	
	function executeQuery(){
		if(checkAllRequiredFieldsInDiv("searchLineCdDiv")) {
			firstLoad = true;
			initializeTG($F("txtLineCd"));
			
			if($F("txtLineCd") == giispLineCdMC || $F("hidMenuLineCd") == giispLineCdMC){
				$("tdPartSwLpsSw").show();
			} else {
				$("tdPartSwLpsSw").hide();
			}
			setForm(true);
			disableToolbarButton("btnToolbarExecuteQuery");
			$("txtLineCd").readOnly = true;
			disableSearch("osLineCd");
			$("txtLossExpCd").focus();
		}
	}
	
	function enterQuery(){
		function proceedEnterQuery(){
			changeTag = 0;
			if($F("txtLineCd").trim() != "") {
				disableToolbarButton("btnToolbarExecuteQuery");
				$("txtLineCd").value = "";
				$("txtLineCd").setAttribute("lastValidValue", "");
				$("txtLineCd").value = "";
				$("txtLineName").value = "";
				$("hidMenuLineCd").value = "";
				varMenuLineCd = "";
				firstLoad = true;
				initializeTG("");
				$("txtLineCd").readOnly = false;
				enableSearch("osLineCd");
				$("txtLineCd").focus();
				disableToolbarButton("btnToolbarEnterQuery");
				setFieldValues(null);
				setForm(false);
				
				if($F("txtLineCd") == giispLineCdMC || $F("hidMenuLineCd") == giispLineCdMC){
					$("tdPartSwLpsSw").show();
				} else {
					$("tdPartSwLpsSw").hide();
				}				
				
				/*tbgLossExpense.url = contextPath + "/GIISLossExpController?action=showGicls104&refresh=1";
				tbgLossExpense._refreshList();*/					
			}
		}
		
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveGicls104();
						proceedEnterQuery();
					}, proceedEnterQuery
					, "");
		} else {
			proceedEnterQuery();
		}		
	}
	
	function validatePartSw(){
		try{
			new Ajax.Request(contextPath + "/GIISLossExpController", {
				parameters : {action : "validatePartSw",
							  lossExpCd : $F("txtLossExpCd")},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						var resp = JSON.parse(response.responseText);
						if($("chkPartSw").checked == false && resp.partExists == "Y" && nvl(resp.partVar, "") != ""){
							$("chkPartSw").checked = true;
							showMessageBox("Untagging is no longer allowed, for particular loss/expense already exists as motor replacement/maintenance car part.", "I");
							return;
						} else if($("chkPartSw").checked){
							$("chkPartSw").disabled = false;
						}
						
						// prohibits untagging for records existing in gicl_mc_lps
						if($("chkPartSw").checked == false && resp.lpsExists == "Y"){
							$("chkPartSw").checked = true;
							showMessageBox("Untagging is no longer allowed, for particular loss/expense already exists as motor maintenance car part.", "I");
							return;
						} else if($("chkPartSw").checked){
							$("chkPartSw").disabled = false;
						}
						
						// prohibits tagging for expense type
						if($F("selType") == "E"){
							//$("chkLpsSw").disabled = true;
							if($("chkPartSw").checked){
								$("chkPartSw").checked = false;
								showMessageBox("Tagging not allowed for Expense Type.", "I");
							}
						} else {
							$("chkPartSw").disabled = false;
						}
						
						//
						if($F("selCompSw") == "-"){
							$("chkPartSw").checked = false;
							showMessageBox("Part Switch cannot be checked for negative (-) computation.", "I");
							return;
						}
						
						// disallow tagging of lps_sw if part_sw is untagged
						if($("chkPartSw").checked == false && $("chkLpsSw").checked){
							$("chkPartSw").checked = true;
						} else if($("chkPartSw").checked == false && $("chkLpsSw").checked == false){
							$("chkPartSw").checked = false;
							$("chkPartSw").disabled = false;
						}
					}
				}
			});
		} catch(e){
			showErrorMessage("validatePartSw", e);
		}
	}
	
	function validateLpsSw(){
		try{
			new Ajax.Request(contextPath + "/GIISLossExpController", {
				parameters : {action : "validateLpsSw",
							  lossExpCd : $F("txtLossExpCd")},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						if(response.responseText == "Y"){
							$("chkLpsSw").checked = true;
							showMessageBox("Untagging of LPS checkbox is not allowed, part is already used in LPS maintenance.", "I");
						}
					}
				}
			});
		} catch(e){
			showErrorMessage("validateLpsSw", e);
		}
	}
	
	function validateCompSw(){
		try{
			new Ajax.Request(contextPath + "/GIISLossExpController", {
				parameters : {action : "validateCompSw",
							  lineCd : $F("txtLineCd"),
							  lossExpType: $F("selType"),
							  lossExpCd : $F("txtLossExpCd"),
							  lossExpDesc: $F("txtLossExpDesc")},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						var resp = JSON.parse(response.responseText);
						if(resp.variable == "X" && variableCsType != null){
							$("selCompSw").value = variableCsType;
							showMessageBox("This field is protected against updates.", "I");
						} else {
							$("selCompSw").disabled = false;
						}
						
						if($("chkPartSw").checked && $F("selCompSw") == "-"){
							$("selCompSw").value = ""; //$("selCompSw").readAttribute("lastValidValue"); //resp.compSw;
							showMessageBox("Parts cannot be tagged for negative (-) computation.", "I");
						}
					}
				} 
			});
		} catch(e){
			showErrorMessage("validateCompSw", e);
		}
	}
	
	function validateLossExpType(){
		try{
			new Ajax.Request(contextPath + "/GIISLossExpController", {
				parameters : {action : "validateLossExpType",
							  lineCd : $F("txtLineCd"),
							  sublineCd : $F("hidSublineCd"),
					  		  //lossExpType: $F("selType"),
					  		  lossExpType: ($("selType").readAttribute("lastValidValue") == "" ? $F("selType") : $("selType").readAttribute("lastValidValue") ),
					  		  lossExpCd : $F("txtLossExpCd")},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						if(response.responseText == "Y"){
							$("selType").value = $("selType").readAttribute("lastValidValue");
							showMessageBox("Cannot update this record. Loss/Expense code already in use.", "I");
							return;
						} else {
							$("selType").setAttribute("lastValidValue", $F("selType"));
						}
						
						// condition to be added in web. 
						// No checking in CS when part_sw is checked then loss_exp_type is changed to EXPENSE
						if($("chkPartSw").checked && $F("selType") == "E"){
							$("chkPartSw").checked = false;
						} /*else if($F("selType") == "L"){
							$("chkPartSw").checked = true;
						}*/
					}
				}
			});
		} catch(e){
			showErrorMessage("validateLossExpType", e);
		}
	}
	
	/*function getLineNameByLineCd(lineCd){
		var lineName = "";
		try{
			new Ajax.Request(contextPath + "/GIISLineController", {
				parameters : {action : "getGIISLineName",
							  lineCd : lineCd},
				//onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						lineName = response.responseText;	
					}
				}
			});
		} catch(e){
			showErrorMessage("getLineNameByLineCd", e);
		}
		return lineName;
	}*/
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtLossExpCd").observe("keyup", function(){
		$("txtLossExpCd").value = $F("txtLossExpCd").toUpperCase();
	});
		
	$("osLineCd").observe("click", showGicls104LineCdLOV);
	
	$("txtLineCd").observe("keyup", function() {	
		$("txtLineCd").value = $F("txtLineCd").toUpperCase();
	});
	$("txtLineCd").observe("change", function() {		
		if($F("txtLineCd").trim() == "") {
			$("txtLineCd").value = "";
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtLineName").value = "";
			$("hidMenuLineCd").value = "";
			varMenuLineCd = "";
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		} else {
			if($F("txtLineCd").trim() != "" && $F("txtLineCd") != $("txtLineCd").readAttribute("lastValidValue")) {
				showGicls104LineCdLOV();
			}
		}
	});
	
	$("osPerilCd").observe("click", showGicls104PerilLOV);
	$("txtPerilCd").observe("change", function() {		
		if($F("txtPerilCd").trim() == "") {
			$("txtPerilCd").value = "";
			$("txtPerilCd").setAttribute("lastValidValue", "");
			$("txtPerilName").value = "";
		} else {
			if($F("txtPerilCd").trim() != "" && $F("txtPerilCd") != $("txtPerilCd").readAttribute("lastValidValue")) {
				showGicls104PerilLOV();
			}
		}
	});
	
	$("chkPartSw").observe("click", validatePartSw);
	
	$("chkLpsSw").observe("click", function(){
		if($("chkLpsSw").checked && $("chkPartSw").checked == false){
			$("chkLpsSw").checked = false;
		} else if($("chkLpsSw").checked && $("chkPartSw").checked){
			$("chkLpsSw").checked = true;
		} else if($("chkLpsSw").checked == false && $("chkPartSw").checked){
			validateLpsSw();
		}
	});
	
	$("selCompSw").observe("focus", function(){ 
		$("selCompSw").setAttribute("lastValidValue", $F("selCompSw"));
	});
	$("selCompSw").observe("change", validateCompSw);
	$("selType").observe("change", validateLossExpType);
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGicls104);
	observeSaveForm("btnToolbarSave", saveGicls104);
	$("btnCancel").observe("click", cancelGicls104);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	
	$("btnToolbarExecuteQuery").observe("click", executeQuery);
	$("btnToolbarEnterQuery").observe("click", enterQuery);	
	$("btnToolbarExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtLineCd").focus();
	
	//added by pol, used when gicls104 was called via gicls171
	if(objCLMGlobal.previousModule == "GICLS171"){
		$("txtLineCd").value = objCLMGlobal.lineCd;
		$("txtLineName").value = objCLMGlobal.lineCd == giispLineCdMC ? giispLineNameMC : ""; //getLineNameByLineCd(objCLMGlobal.lineCd);
		//showGicls104LineCdLOV();
		partSw = objCLMGlobal.partSw;
		executeQuery();
	}
</script>
