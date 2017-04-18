<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss114MainDiv" name="giiss114MainDiv" style="">
	<div id="mCColorExitDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="uwExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="giiss114" name="giiss114">	
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
	   			<label>Basic Color</label>
	   			<span class="refreshers" style="margin-top: 0;">
	   				<label id="showHideBasicColor" name="showHideBasicColor" style="margin-left: 5px;">Hide</label>
					<label id="reloadForm" name="reloadForm">Reload Form</label>
				</span>
	   		</div>
		</div>		
		<div id="basicColorDiv" class="sectionDiv">
			<div id="basicColorTableDiv" style="padding-top: 10px;">
				<div id="basicColorTable" style="height: 230px; margin-left: 165px;"></div>
			</div>
			<div align="center" style="margin: 5px 0 5px 0">
				<table>
					<tr>
						<td align="right">Basic Color Code</td>
						<td>						
							<input class="required" id="txtBasicColorCd" type="text" maxlength="7" style="width:150px" tabindex="201">
						</td>	
					</tr>
					<tr>
						<td align="right" width="100px">Basic Color</td>
						<td>
							<input class="required" id="txtBasicColor" type="text" style="width:420px;" maxlength="50" tabindex="202">
						</td>	
					</tr>
				</table>
			</div>
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAddBasicColor" value="Add">
				<input type="button" class="button" id="btnDeleteBasicColor" value="Delete">
			</div>
		</div>
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
		   		<label>Color</label>
		   		<span class="refreshers" style="margin-top: 0;">
		   		<label id="showHideColor" name="showHideColor" style="margin-left: 5px;">Hide</label>
				</span>
		   	</div>
		</div>
		<div id="colorDiv" class="sectionDiv">
			<div id="colorTableDiv" style="padding-top: 10px;">
				<div id="colorTable" style="height: 340px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="mCColorFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned" width="100px">Code</td>
						<td class="leftAligned" colspan="3">
							<input id="txtColorCd" type="text" style="width: 200px; text-align: right;" disabled="disabled" maxlength="12" tabindex="203">
						</td>					
					</tr>	
					<tr>
						<td width="" class="rightAligned">Color</td>
						<td class="leftAligned" colspan="3">
							<input id="txtColor" type="text" class="required" style="width: 533px;" maxlength="50" tabindex="204">
						</td>
					</tr>				
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="205"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="206"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly"></td>
						<td width="113px" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAddColor" value="Add" tabindex="207">
				<input type="button" class="button" id="btnDeleteColor" value="Delete" tabindex="208">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="209">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="210">
</div>
<script type="text/javascript">	
try {
	setModuleId("GIISS114");
	setDocumentTitle("Car Color Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var changeTagAddParent = 0;
	var changeTagUpdateParent = 0;
	var changeTagDeleteParent = 0;
	var rowIndex = -1;
	var rowIndexBasic = -1;
	observeReloadForm("reloadForm", showGiiss114);	
	var objGIISS114 = {};
	var objCurrMCColor = null;
	var objCurrMCBasicColor = null;
	objGIISS114.basicColorList = JSON.parse('${jsonBasicColorList}');
	objGIISS114.colorList = JSON.parse('${jsonColorList}');
	objGIISS114.exitPage = null;	
	objGIISS114.countRecColor = 0;

	var basicColorTable = {
			url : contextPath + "/GIISMCColorController?action=showGiiss114BasicColor&refresh=1",
			options : {
				width : '600px',
				pager : {},
				beforeClick : function(element, value, x, y, id){				
					if(changeTag == 1 && changeTagDeleteParent == 0 && (changeTagAddParent == 1||changeTagUpdateParent==1||checkChangesInChildTable())){
						showMessageBox("Please save changes first.", imgMessage.INFO);
						return false;						
					}			
				},
				onCellFocus : function(element, value, x, y, id){
					rowIndexBasic = y;
					objCurrMCBasicColor = tbgMCBasicColor.geniisysRows[y];
					setFieldValuesBasicColor(objCurrMCBasicColor);
					setTbgColor(objCurrMCBasicColor);
					enableColorBtnAndFields(objCurrMCBasicColor);
					tbgMCBasicColor.keys.removeFocus(tbgMCBasicColor.keys._nCurrentFocus, true);
					tbgMCBasicColor.keys.releaseKeys();
					$("txtBasicColor").focus();
				},
				onRemoveRowFocus : function(){	
					rowIndexBasic = -1;
					objCurrMCBasicColor = null;
					setFieldValuesBasicColor(null);
					setTbgColor(null);
					enableColorBtnAndFields(null);
					tbgMCBasicColor.keys.removeFocus(tbgMCBasicColor.keys._nCurrentFocus, true);
					tbgMCBasicColor.keys.releaseKeys();
					$("txtBasicColorCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){		
						rowIndexBasic = -1;
						objCurrMCBasicColor = null;
						setFieldValuesBasicColor(null);
						setTbgColor(null);
						enableColorBtnAndFields(null);
						tbgMCBasicColor.keys.removeFocus(tbgMCBasicColor.keys._nCurrentFocus, true);
						tbgMCBasicColor.keys.releaseKeys();
						$("txtBasicColorCd").focus();						
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
					rowIndexBasic = -1;
					objCurrMCBasicColor = null;
					setFieldValuesBasicColor(null);
					setTbgColor(null);
					enableColorBtnAndFields(null);
					tbgMCBasicColor.keys.removeFocus(tbgMCBasicColor.keys._nCurrentFocus, true);
					tbgMCBasicColor.keys.releaseKeys();				
				},
				onRefresh: function(){	
					rowIndexBasic = -1;
					objCurrMCBasicColor = null;
					setFieldValuesBasicColor(null);
					setTbgColor(null);
					enableColorBtnAndFields(null);
					tbgMCBasicColor.keys.removeFocus(tbgMCBasicColor.keys._nCurrentFocus, true);
					tbgMCBasicColor.keys.releaseKeys();					
				},				
				prePager: function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}				
					rowIndexBasic = -1;
					objCurrMCBasicColor = null;
					setFieldValuesBasicColor(null);
					setTbgColor(null);
					enableColorBtnAndFields(null);
					tbgMCBasicColor.keys.removeFocus(tbgMCBasicColor.keys._nCurrentFocus, true);
					tbgMCBasicColor.keys.releaseKeys();					
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
					id : "basicColorCd",
					title : "Basic Color Code",
					filterOption : true,
					width : '130px',
				},
				{
					id : 'basicColor',					
					title : 'Basic Color',
					filterOption : true,
					width : '430px'				
				}	
			],
			rows : objGIISS114.basicColorList.rows
		};

	tbgMCBasicColor = new MyTableGrid(basicColorTable);
	tbgMCBasicColor.pager = objGIISS114.basicColorList;
	tbgMCBasicColor.render("basicColorTable");

	var colorTable = {
			url : contextPath + "/GIISMCColorController?action=showGiiss114&refresh=1",
			options : {
				width : '700px',
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrMCColor = tbgMCColor.geniisysRows[y];
					setFieldValues(objCurrMCColor);
					tbgMCColor.keys.removeFocus(tbgMCColor.keys._nCurrentFocus, true);
					tbgMCColor.keys.releaseKeys();
					$("txtColor").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgMCColor.keys.removeFocus(tbgMCColor.keys._nCurrentFocus, true);
					tbgMCColor.keys.releaseKeys();
					$("txtColor").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgMCColor.keys.removeFocus(tbgMCColor.keys._nCurrentFocus, true);
						tbgMCColor.keys.releaseKeys();
						$("txtColor").focus();
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
					tbgMCColor.keys.removeFocus(tbgMCColor.keys._nCurrentFocus, true);
					tbgMCColor.keys.releaseKeys();				
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgMCColor.keys.removeFocus(tbgMCColor.keys._nCurrentFocus, true);
					tbgMCColor.keys.releaseKeys();					
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
					tbgMCColor.keys.removeFocus(tbgMCColor.keys._nCurrentFocus, true);
					tbgMCColor.keys.releaseKeys();					
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
					id : "colorCd",
					title : "Code",
					filterOption : true,
					width : '130px',
					titleAlign : 'right',
					align : 'right',
					filterOptionType : 'integerNoNegative'
				},
				{
					id : 'color',					
					title : 'Color',
					filterOption : true,
					width : '530px'				
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
				},
				{
					id : 'countRec',
					width : '0',
					visible: false				
				}
			],
			rows : objGIISS114.colorList.rows
		};

	tbgMCColor = new MyTableGrid(colorTable);
	tbgMCColor.pager = objGIISS114.colorList;
	tbgMCColor.render("colorTable");
	
	function saveGiiss114(){
		if((changeTagAddParent==1 && !checkChildNotNull()) || (objGIISS114.countRecColor == 0)){
			customShowMessageBox("Basic Color must have at least 1 child record.", imgMessage.INFO,
			"txtColor");
			return;
		}
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgMCColor.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgMCColor.geniisysRows);
		var delRowsBasic = getDeletedJSONObjects(tbgMCBasicColor.geniisysRows);
		var updateRowsBasic = getModifiedJSONObjects(tbgMCBasicColor.geniisysRows);
		new Ajax.Request(contextPath+"/GIISMCColorController", {
			method: "POST",
			parameters : {action : "saveGiiss114",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows),
					 	  delRowsBasic : prepareJsonAsParameter(delRowsBasic),
					 	  updateRowsBasic : prepareJsonAsParameter(updateRowsBasic)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS114.exitPage != null) {
							objGIISS114.exitPage();
						} else {
							//tbgMCColor.url = contextPath +"/GIISMCColorController?action=showGiiss114&refresh=1&basicColorCd="+encodeURIComponent($F("txtBasicColorCd"));
							tbgMCBasicColor._refreshList();
						}
					});
					changeTag = 0;
					changeTagAddParent = 0;
					changeTagUpdateParent = 0;
					changeTagDeleteParent = 0;
				}
			}
		});
	}
	
	function setFieldValuesBasicColor(rec){
		try{
			$("txtBasicColorCd").value = (rec == null ? "" : unescapeHTML2(rec.basicColorCd));
			$("txtBasicColor").value = (rec == null ? "" : unescapeHTML2(rec.basicColor));			
			$("txtBasicColor").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.basicColor)));
			rec == null ? $("txtBasicColorCd").readOnly = false : $("txtBasicColorCd").readOnly = true;			
			rec == null ? $("btnAddBasicColor").value = "Add" : $("btnAddBasicColor").value = "Update";			
			rec == null ? disableButton("btnDeleteBasicColor") : enableButton("btnDeleteBasicColor");
		} catch(e){
			showErrorMessage("setFieldValuesBasicColor", e);
		}
	}
	
	function setTbgColor(obj){
		if(obj != null){
			tbgMCColor.url = contextPath +"/GIISMCColorController?action=showGiiss114&refresh=1&basicColorCd="+encodeURIComponent($F("txtBasicColorCd"));
			tbgMCColor._refreshList();					
			objGIISS114.countRecColor = parseInt(tbgMCColor.geniisysRows[0].countRec);			
		}else{
			tbgMCColor.url = contextPath +"/GIISMCColorController?action=showGiiss114&refresh=1";
			tbgMCColor._refreshList();
		}	
	}
	
	function setFieldValues(rec){
		try{
			$("txtColorCd").value = (rec == null ? "" : rec.colorCd);
			$("txtColor").value = (rec == null ? "" : unescapeHTML2(rec.color));
			$("txtColor").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.color)));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAddColor").value = "Add" : $("btnAddColor").value = "Update";			
			rec == null ? disableButton("btnDeleteColor") : enableButton("btnDeleteColor");
			objCurrMCColor = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRecBasic(rec){
		try {			
			var obj = (rec == null ? {} : rec);		
			obj.basicColorCd = escapeHTML2($F("txtBasicColorCd"));
			obj.basicColor = escapeHTML2($F("txtBasicColor"));			
			return obj;
		} catch(e){
			showErrorMessage("setRecBasic", e);
		}
	}
	
	function setRec(rec){
		try {			
			var obj = (rec == null ? {} : rec);		
			obj.basicColorCd = objCurrMCBasicColor.basicColorCd;
			obj.basicColor = objCurrMCBasicColor.basicColor;
			obj.colorCd = $F("btnAddColor") == "Add" ? "" : $F("txtColorCd");
			obj.color = escapeHTML2($F("txtColor"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = escapeHTML2(userId);
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRecBasic(){
		try {
			changeTag = 1;
			changeTagDeleteParent = 0;
			changeTagUpdateParent = 1;		
			changeTagFunc = saveGiiss114;
			var rec = setRecBasic(objCurrMCBasicColor);			
			if($F("btnAddBasicColor") == "Add"){
				tbgMCBasicColor.addBottomRow(rec);
				rowIndexBasic = tbgMCBasicColor.geniisysRows.length-1;		
				changeTagAddParent = 1;		
			} else {
				tbgMCBasicColor.updateVisibleRowOnly(rec, rowIndexBasic, false);		
				changeTagUpdateParent = 1;		
			}
			tbgMCBasicColor.selectRow(rowIndexBasic);	
			objCurrMCBasicColor = tbgMCBasicColor.geniisysRows[rowIndexBasic];
			setFieldValuesBasicColor(objCurrMCBasicColor);			
			enableColorBtnAndFields("enable");
			$("txtColor").focus();				
		} catch(e){
			showErrorMessage("addRecBasic", e);
		}
	}			
	
	function addRec(){
		try {	
			changeTagFunc = saveGiiss114;
			changeTagDeleteParent = 0;
			var color = setRec(objCurrMCColor);
			if($F("btnAddColor") == "Add"){
				tbgMCColor.addBottomRow(color);
				objGIISS114.countRecColor = objGIISS114.countRecColor + 1;
			} else {
				tbgMCColor.updateVisibleRowOnly(color, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgMCColor.keys.removeFocus(tbgMCColor.keys._nCurrentFocus, true);
			tbgMCColor.keys.releaseKeys();			
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}			
	
	function valAddRecBasic() {
		try {
			if (checkAllRequiredFieldsInDiv("basicColorDiv")) {
				if ($F("btnAddBasicColor") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;
					var addedSameExists2 = false;
					var deletedSameExists2 = false;
					for ( var i = 0; i < tbgMCBasicColor.geniisysRows.length; i++) {
						if (tbgMCBasicColor.geniisysRows[i].recordStatus == 0
								|| tbgMCBasicColor.geniisysRows[i].recordStatus == 1) {
							if (unescapeHTML2(tbgMCBasicColor.geniisysRows[i].basicColorCd) == $F("txtBasicColorCd")) {
								addedSameExists = true;
							}
							if (unescapeHTML2(tbgMCBasicColor.geniisysRows[i].basicColor) == $F("txtBasicColor")) {
								addedSameExists2 = true;
							}
						} else if (tbgMCBasicColor.geniisysRows[i].recordStatus == -1) {
							if (unescapeHTML2(tbgMCBasicColor.geniisysRows[i].basicColorCd) == $F("txtBasicColorCd")) {
								deletedSameExists = true;
							}
							if (unescapeHTML2(tbgMCBasicColor.geniisysRows[i].basicColor) == $F("txtBasicColor")) {
								deletedSameExists2 = true;
							}
						}
					}
					if ((addedSameExists && !deletedSameExists)
							|| (deletedSameExists && addedSameExists)) {
						showMessageBox(
								"Record already exists with the same basic_color_cd.",
								"E");					
						return;
					} else if ((addedSameExists2 && !deletedSameExists2)
							|| (deletedSameExists2 && addedSameExists2)) {
						showMessageBox(
								"Record already exists with the same basic_color.",
								"E");
						return;
					} else if (deletedSameExists && !addedSameExists) {
						addRecBasic();
						return;
					} else if (deletedSameExists2 && !addedSameExists2) {
						addRecBasic();
						return;
					}
					new Ajax.Request(contextPath + "/GIISMCColorController", {
						parameters : {
							action : "valAddRecBasic",
							basicColorCd : $F("txtBasicColorCd"),
							basicColor : $F("txtBasicColor"),
							valAction : $F("btnAddBasicColor").toUpperCase() // andrew - 08052015 - SR 19241
						},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response) {
							hideNotice();
							if (checkErrorOnResponse(response)
									&& checkCustomErrorOnResponse(response)) {
								addRecBasic();
							}
						}
					});
				} else {
					var addedSameExists2 = false;
					var deletedSameExists2 = false;
					for ( var i = 0; i < tbgMCBasicColor.geniisysRows.length; i++) {
						if (tbgMCBasicColor.geniisysRows[i].recordStatus == 0
								|| tbgMCBasicColor.geniisysRows[i].recordStatus == 1) {					
							if (unescapeHTML2(tbgMCBasicColor.geniisysRows[i].basicColor) == $F("txtBasicColor") && unescapeHTML2(objCurrMCBasicColor.basicColor) != $F("txtBasicColor")) {
								addedSameExists2 = true;
							}
						} else if (tbgMCBasicColor.geniisysRows[i].recordStatus == -1) {				
							if (unescapeHTML2(tbgMCBasicColor.geniisysRows[i].basicColor) == $F("txtBasicColor")) {
								deletedSameExists2 = true;
							}
						}
					}
					if ((addedSameExists2 && !deletedSameExists2)
							|| (deletedSameExists2 && addedSameExists2)) {
						showMessageBox(
								"Record already exists with the same basic_color.",
								"E");
						$("txtBasicColor").value = $("txtBasicColor").readAttribute("lastValidValue");
						return;
					} else if (deletedSameExists2 && !addedSameExists2) {
						addRecBasic();
						return;
					}
					if(unescapeHTML2(objCurrMCBasicColor.basicColor) != $F("txtBasicColor")){
						new Ajax.Request(contextPath + "/GIISMCColorController", {
							parameters : {
								action : "valAddRecBasic",	
								basicColorCd : $F("txtBasicColorCd"),
								basicColor : $F("txtBasicColor"),
								valAction : $F("btnAddBasicColor").toUpperCase() // andrew - 08052015 - SR 19241
							},
							onCreate : showNotice("Processing, please wait..."),
							onComplete : function(response) {
								hideNotice();
								if (checkErrorOnResponse(response)
										&& checkCustomErrorOnResponse(response)) {
									addRecBasic();
								}else{
									$("txtBasicColor").value = $("txtBasicColor").readAttribute("lastValidValue");
								}
							}
						});
					}else{
						addRecBasic();
					}
				
				}
			}
		} catch (e) {
			showErrorMessage("valAddRecBasic", e);
		}
	}
	
	function valAddRec() {
		try {
			if (checkAllRequiredFieldsInDiv("mCColorFormDiv")) {
				if ($F("btnAddColor") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;
					for ( var i = 0; i < tbgMCColor.geniisysRows.length; i++) {
						if (tbgMCColor.geniisysRows[i].recordStatus == 0
								|| tbgMCColor.geniisysRows[i].recordStatus == 1) {
							if (unescapeHTML2(tbgMCColor.geniisysRows[i].color) == $F("txtColor")) {
								addedSameExists = true;
							}
						} else if (tbgMCColor.geniisysRows[i].recordStatus == -1) {
							if (unescapeHTML2(tbgMCColor.geniisysRows[i].color) == $F("txtColor")) {
								deletedSameExists = true;
							}
						}
					}
					if ((addedSameExists && !deletedSameExists)
							|| (deletedSameExists && addedSameExists)) {
						showMessageBox(
								"Record already exists with the same color.",
								"E");
						return;
					} else if (deletedSameExists && !addedSameExists) {
						addRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIISMCColorController", {
						parameters : {
							action : "valAddRec",
							basicColorCd : unescapeHTML2(objCurrMCBasicColor.basicColorCd),
							colorCd : $F("txtColorCd"), // andrew - 08052015 - SR 19241
							color : $F("txtColor"),
							valAction : $F("btnAddColor").toUpperCase() // andrew - 08052015 - SR 19241
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
					var addedSameExists = false;
					var deletedSameExists = false;
					for ( var i = 0; i < tbgMCColor.geniisysRows.length; i++) {
						if (tbgMCColor.geniisysRows[i].recordStatus == 0
								|| tbgMCColor.geniisysRows[i].recordStatus == 1) {
							if (unescapeHTML2(tbgMCColor.geniisysRows[i].color) == $F("txtColor") && unescapeHTML2(objCurrMCColor.color) != $F("txtColor")) {
								addedSameExists = true;
							}
						} else if (tbgMCColor.geniisysRows[i].recordStatus == -1) {
							if (unescapeHTML2(tbgMCColor.geniisysRows[i].color) == $F("txtColor")) {
								deletedSameExists = true;
							}
						}
					}
					if ((addedSameExists && !deletedSameExists)
							|| (deletedSameExists && addedSameExists)) {
						showMessageBox(
								"Record already exists with the same color.",
								"E");
						$("txtColor").value = $("txtColor").readAttribute("lastValidValue");
						return;
					} else if (deletedSameExists && !addedSameExists) {
						addRec();
						return;
					}
					if(unescapeHTML2(objCurrMCColor.color) != $F("txtColor")){
						new Ajax.Request(contextPath + "/GIISMCColorController", {
							parameters : {
								action : "valAddRec",
								basicColorCd : unescapeHTML2(objCurrMCBasicColor.basicColorCd),
								colorCd : $F("txtColorCd"), // andrew - 08052015 - SR 19241
								color : $F("txtColor"),
								valAction : $F("btnAddColor").toUpperCase() // andrew - 08052015 - SR 19241
							},
							onCreate : showNotice("Processing, please wait..."),
							onComplete : function(response) {
								hideNotice();
								if (checkErrorOnResponse(response)
										&& checkCustomErrorOnResponse(response)) {
									addRec();
								}else{
									$("txtColor").value = $("txtColor").readAttribute("lastValidValue");
								}
							}
						});
					}else{
						addRec();
					}
				}
			}
		} catch (e) {
			showErrorMessage("valAddRec", e);
		}
	}
	
	function deleteRecBasic() {
		changeTag = 1;
		changeTagFunc = saveGiiss114;
		changeTagAddParent = 0;
		changeTagUpdateParent = 0;
		changeTagDeleteParent = 1;
		objCurrMCBasicColor.recordStatus = -1;
		tbgMCBasicColor.deleteRow(rowIndexBasic);
		setFieldValuesBasicColor(null);
		setTbgColor(null);
		enableColorBtnAndFields(null);
	}

	function deleteRec() {
		changeTagFunc = saveGiiss114;
		objCurrMCColor.recordStatus = -1;
		tbgMCColor.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
		objGIISS114.countRecColor = objGIISS114.countRecColor - 1;
	}
	
	function valDeleteRecBasic() {
		try {			
			new Ajax.Request(contextPath + "/GIISMCColorController", {
				parameters : {
					action : "valDeleteRecBasic",
					basicColorCd : $F("txtBasicColorCd")
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if (checkErrorOnResponse(response)
							&& checkCustomErrorOnResponse(response)) {
						deleteRecBasic();
					}
				}
			});
		} catch (e) {
			showErrorMessage("valDeleteRecBasic", e);
		}
	}

	function valDeleteRec() {
		try {		
			if($F("txtColorCd") != ""){
				new Ajax.Request(contextPath + "/GIISMCColorController", {
					parameters : {
						action : "valDeleteRec",
						colorCd : $F("txtColorCd")
					},
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)
								&& checkCustomErrorOnResponse(response)) {
							deleteRec();
						}
					}
				});
			}else{
				deleteRec();
			}	
		} catch (e) {
			showErrorMessage("valDeleteRec", e);
		}
	}

	function exitPage() {
		if(objUWGlobal.callingForm == "GIPIS010"){
			showItemInfo();
			$("parInfoMenu").show();	
			objUWGlobal.callingForm = "";
		}else{
			goToModule("/GIISUserController?action=goToUnderwriting",
					"Underwriting Main", null);
		}		
	}

	function cancelGiiss114() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objGIISS114.exitPage = exitPage;
						saveGiiss114();
					}, function() {
						exitPage();
					}, "");
		} else {
			exitPage();
		}
	}
	
	function enableImgEdit(imgId){
		try {		
			if($(imgId).next("img",0) != undefined){
				$(imgId).show();
				$(imgId).next("img",0).remove();
			}
		} catch(e){
			showErrorMessage("enableImg", e);
		}	
	}	

	function disableImgEdit(imgId){
		try {
			if($(imgId).next("img",0) == undefined){
				var alt = new Element("img");
				alt.alt = 'Go';
				alt.src = contextPath + "/images/misc/edit.png";
				alt.setAttribute("style", "height:17px;width:18px;");							
				alt.setStyle({ 
					  float: 'right'
				});
				$(imgId).hide();
				$(imgId).insert({after : alt});	
			}
		}catch (e) {
			showErrorMessage("disableImg", e);			
		}
	};
	
	function enableColorBtnAndFields(obj){
		if(obj!=null){			
			enableInputField("txtColor");		
			enableInputField("txtRemarks");
			enableButton("btnAddColor");
			enableImgEdit("editRemarks");		
		}else{
			disableInputField("txtColor");		
			disableInputField("txtRemarks");
			disableButton("btnAddColor");
			$("txtColor").value="";
			$("txtRemarks").value="";	
			disableImgEdit("editRemarks");
		}
	}	
	
	function showHideDiv(divId,labelId){
		if($(divId).getStyle('display') !='none'){
			Effect.toggle(divId, "blind", {duration: .3});
			$(labelId).innerHTML = "Show";
		}else if($(divId).getStyle('display') =='none'){
			Effect.toggle(divId, "blind", {duration: .3});
			$(labelId).innerHTML = "Hide";
		}		
	}
	
	function checkChildNotNull(){
		if(getAddedAndModifiedJSONObjects(tbgMCColor.geniisysRows)!= ""){
			return true;
		}else{
			return false;
		}
	}
	
	function checkChangesInChildTable(){
		if(getAddedAndModifiedJSONObjects(tbgMCColor.geniisysRows)!= ""||getDeletedJSONObjects(tbgMCColor.geniisysRows)!= ""){
			return true;
		}else{
			return false;
		}
	}
		
	$("editRemarks").observe(
			"click",
			function() {
				showOverlayEditor("txtRemarks", 4000, $("txtRemarks")
						.hasAttribute("readonly"));
			});

	$("txtBasicColor").observe("keyup", function() {
		$("txtBasicColor").value = $F("txtBasicColor").toUpperCase();
	});
	
	$("txtBasicColor").observe("change", function() {			
		if($F("txtBasicColor").trim()!=""){
			$("txtBasicColor").value = $F("txtBasicColor").toUpperCase();			
		}else{
			$("txtBasicColor").value = "";
		}	
	});	
	
	$("txtBasicColorCd").observe("keyup", function() {
		$("txtBasicColorCd").value = $F("txtBasicColorCd").toUpperCase();
	});
	
	$("txtBasicColorCd").observe("change", function() {			
		if($F("txtBasicColorCd").trim()!=""){
			$("txtBasicColorCd").value = $F("txtBasicColorCd").toUpperCase();			
		}else{
			$("txtBasicColorCd").value = "";			
		}		
	});	
	
	$("txtColor").observe("keyup", function() {
		$("txtColor").value = $F("txtColor").toUpperCase();
	});
	
	$("txtColor").observe("change", function() {
		if($F("txtColor").trim()!=""){
			$("txtColor").value = $F("txtColor").toUpperCase();		
		}else{
			$("txtColor").value = "";			
		}				
	});	
		
	$("showHideBasicColor").observe("click", function() {
		showHideDiv("basicColorDiv","showHideBasicColor");		
	});
	
	$("showHideColor").observe("click", function() {
		showHideDiv("colorDiv","showHideColor");
	});
	
	disableButton("btnDeleteColor");
	disableButton("btnDeleteBasicColor");
	observeSaveForm("btnSave", saveGiiss114);
	$("btnCancel").observe("click", cancelGiiss114);
	$("btnAddBasicColor").observe("click", valAddRecBasic);
	$("btnAddColor").observe("click", valAddRec);
	$("btnDeleteBasicColor").observe("click", valDeleteRecBasic);
	$("btnDeleteColor").observe("click", valDeleteRec);

	$("uwExit").stopObserving("click");
	$("uwExit").observe("click", function() {
		fireEvent($("btnCancel"), "click");
	});
	enableColorBtnAndFields(null);		
	//showHideDiv("colorDiv","showHideColor");
	$("txtBasicColorCd").focus();
}catch (e) {
	showErrorMessage("GIISS114", e);		
}
</script>