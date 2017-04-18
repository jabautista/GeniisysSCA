<!-- 
Date       : 11.14.2012
Modified by: Gzelle 
-->
<div id="postingLimitMaintenanceDiv" name="postingLimitMaintenanceDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Posting Limit Maintenance</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div>
</div>
<div class="sectionDiv">
	<div style="margin-left: 40px;" id="headerParamsDiv">
		<table cellspacing="2" border="0" style="margin: 10px;" >	 			
			<tr>
				<td class="rightAligned" style="">User</td>
				<td class="leftAligned" colspan="">
					<span class="lovSpan required"  style="float: left; width: 95px; margin-right: 2px; margin-top: 2px; height: 21px;">
						<input class="required" type="text" id="txtUser" name="txtUser" style="width: 70px; float: left; border: none; height: 15px; margin: 0;" maxlength="8" tabindex="101" lastValidValue="" ignoreDelKey="1"/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgUserLOV" name="imgUserLOV" alt="Go" style="float: right;" tabindex="102"/>
					</span>
					<input id="txtUserName" name="txtUserName" type="text" style="width: 250px;" value="" readonly="readonly" tabindex="103" ignoreDelKey="1"/>
				</td>						
				<td class="rightAligned" style="width: 50px;">Branch</td>
				<td class="leftAligned" colspan="3">
					<span class="lovSpan required" style="float: left; width: 95px; margin-right: 2px; margin-top: 2px; height: 21px;">
						<input class="required" type="text" id="txtIssCd" name="txtIssCd" style="width: 70px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="104" lastValidValue="" ignoreDelKey="1"/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgBranchLOV" name="imgBranchLOV" alt="Go" style="float: right;" tabindex="105"/>
					</span>
					<input id="txtIssName" name="txtIssName" type="text" style="width: 250px;" value="" readonly="readonly" tabindex="106" ignoreDelKey="1"/>
				</td>
			</tr>
		</table>			
	</div>		
</div>	
<div id="postingLimitSectionDiv" class="sectionDiv" style="height: 550px;" masterDetail="true">
	<div id="postingLimitTable" style="height: 330px;">
		<div id="postingLimitTableGridDiv" style= "margin-top:10px; margin-bottom: 10px; margin-left: 50px; margin-right:50px; height: 320px;"></div>
	</div>	
	
	<div id="postingLimitTableMaintenanceFormDiv" style="margin-bottom: 10px;">
		<table align="center">
			<tr>
				<td class="rightAligned" style="">Line</td>
				<td class="leftAligned" colspan="3">
					<span class="lovSpan required"  style="float: left; width: 150px; margin-right: 3px; margin-top: 2px; height: 21px;">
						<input class="required" type="text" id="txtLineCd" name="txtLineCd" style="width: 120px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="101" lastValidValue="" ignoreDelKey="1"/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgLineLOV" name="imgLineLOV" alt="Go" style="float: right;" tabindex="102"/>
					</span>
					<input id="txtLineName" name="txtLineName" type="text" style="width: 250px;" value="" ignoreDelKey="1" readonly="readonly" tabindex="103"/>
					<input id="hidLineName" name="hidLineName" type="hidden" /> 
				</td>			
			</tr>
			<tr>
				<td class="rightAligned">Posting Limit</td>
				<td class="leftAligned"><input type="text" id="txtPostingLimit" name="txtPostingLimit" class="applyDecimalRegExp" hasOwnKeyUp="N" hasOwnBlur="N" hasOwnChange="N" customLabel="Posting Limit" max="999999999.99" min="0.00" regexppatt="pDeci0902" style="width: 145px;" maxlength="12" readonly="readonly" tabindex="203" lastValidValue=""/></td>
				<td colspan="1" class="leftAligned">
					<td class="leftAligned">
						<!-- for insert/update display -->
						<input type="checkbox" id="chkAllAmount" name="chkAllAmount" style="float: left; margin: 0pt; width: 13px; height: 13px;" disabled="disabled" tabindex="204"/> 
						<label for="chkAllAmount" style="float: left; margin-left: 3px;" title="All Amount"> All Amount </label>
					</td>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Endt. Posting Limit</td>
				<td class="leftAligned"><input type="text" id="txtEndtPostingLimit" name="txtEndtPostingLimit" class="applyDecimalRegExp" hasOwnKeyUp="N" hasOwnBlur="N" hasOwnChange="N" customLabel="Endt. Posting Limit" max="999999999.99" min="0.00" regexppatt="pDeci0902" style="width: 145px;" maxlength="12" readonly="readonly" tabindex="205" lastValidValue=""/></td>
				<td colspan="1" class="leftAligned">
					<td class="leftAligned">
						<!-- for insert/update display -->
						<input type="checkbox" id="chkEndtAllAmount" name="chkEndtAllAmount" style="float: left; margin: 0pt; width: 13px; height: 13px;" disabled="disabled" tabindex="206"/>
						<label for="chkEndtAllAmount" style="float: left; margin-left: 3px;" title="Endt. All Amount"> Endt. All Amount </label>
					</td>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">User ID</td>
				<td class="leftAligned"><input type="text" id="txtUserId" name="txtUserId" style="width: 145px;" readonly="readonly" tabindex="207" ignoreDelKey="1"/></td>
				<td class="rightAligned" style="width:88px;">Last Update</td>
				<td class="leftAligned"><input type="text" id="txtLastUpdate" name="txtLastUpdate" style="width: 145px;" readonly="readonly" tabindex="208" ignoreDelKey="1"/></td>
			</tr>
			<tr hidden="hidden">
				<td class="rightAligned">Other Params</td>
				<td>
					<input type="hidden" id="hidPostingUser" name="hidPostingUser"/>
					<input type="hidden" id="hidIssCd" name="hidIssCd"/>
					<input type="hidden" id="hidLineCd" name="hidLineCd"/>
					<input type="hidden" id="hidLastValidPostingLimit" name="hidLastValidPostingLimit"/>
					<input type="hidden" id="hidLastValidEndtPostingLimit" name="hidLastValidEndtPostingLimit"/>
					<!-- stores the value retrieved from tablegrid --> 
					<input type="checkbox" id="chkAllAmountSw" name="chkAllAmountSw" customLabel="endorsement" style="visibility: hidden;" />
					<!-- previous status of checkbox, used to determine if confirmation message box will be shown -->
					<input type="checkbox" id="prevAllAmount" name="prevAllAmount" style="visibility: hidden;"> 
					<!-- stores the value retrieved from tablegrid --> 
					<input type="checkbox" id="chkEndtAllAmountSw" name="chkEndtAllAmountSw" style="visibility: hidden;" />
					<!-- previous status of checkbox, used to determine if confirmation message box will be shown -->
					<input type="checkbox" id="prevEndtAllAmount" name="prevEndtAllAmount" style="visibility: hidden;" />
				</td>
			</tr>
		</table>
		<div style="float:left; width: 100%; margin-bottom: 10px; margin-top: 10px;" align="center">
			<input type="button" class="disabledButton" id="btnAddPostingLimit" name="btnAddPostingLimit" value="Add" disabled="disabled" tabindex="301"/>
			<input type="button" class="disabledButton" id="btnDeletePostingLimit" name="btnDeletePostingLimit" value="Delete" disabled="disabled" tabindex="302"/>
		</div>
		<div class="sectionDiv" style="float:left; padding-top:9px; margin-left:50px; width:820px; margin-bottom:10px; border-bottom: none; border-left: none; border-right: none; border-top-width: thin;" align="center">
			<input type="button" class="disabledButton" id="btnCopyToAnotherUserPostingLimit" name="btnCopyToAnotherUserPostingLimit" value="Copy to Another User" disabled="disabled" tabindex="303"/>
		</div>
	</div>
</div>
	
<div class="buttonsDiv" style="float:left; width: 100%; top: 10px; bottom: 10px;" align="center">
	<input type="button" class="button" id="btnCancelPostingLimitMaintenance" name="btnCancelPostingLimitMaintenance" value="Cancel" tabindex="401" />
	<input type="button" class="button" id="btnSavePostingLimitMaintenance" name="btnSavePostingLimitMaintenance" value="Save" tabindex="402"/>
</div>

<script type="text/javascript">

	setDocumentTitle("Posting Limit Maintenance");
	setModuleId("GIISS207");
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	changeCounter = 0;
	unsavedStatus = 0;
	changeTag = 0;
	var postLimitObj;
	var postingLimitRowValue = null;
	var postingLimit = null;
	objGiiss207.selectedIndex = null;
	objGiiss207.exitPage = null;

// 	try {
	//save posting limit record to db
 	function savePostingLimits(){
 		try {
 			var setRows = getAddedAndModifiedJSONObjects(postingLimitTableGrid.geniisysRows);
 			var delRows = getDeletedJSONObjects(postingLimitTableGrid.geniisysRows);

			new Ajax.Request(contextPath + "/GIISPostingLimitController", {
				method : "POST",
				parameters : {action : "savePostingLimits",
							  setRows : prepareJsonAsParameter(setRows),
							  delRows : prepareJsonAsParameter(delRows)},
				asynchronous: false,
				evalScripts: true,
				onComplete : function (response){
					if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)) {
						changeTagFunc = "";
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function() {
							if (objGiiss207.exitPage != null) {
								objGiiss207.exitPage();
							} else {
								postingLimitTableGrid.url = contextPath + "/GIISPostingLimitController?action=getPostingLimits&refresh=1&postingUser="+unescapeHTML2($F("txtUser"))+"&issCd="+unescapeHTML2($F("txtIssCd"));
								postingLimitTableGrid._refreshList();
							}
						});
						changeTag = 0;
					}
				}
			});
 		} catch (e) {
 			showErrorMessage("savePostingLimits", e);
 		} 
 	}
	 	
	try{
		var row = 0;
		objPostingLimitMain = [];
		var jsonPostingLimit = JSON.parse('${postingLimits}');
		
		var postingLimitTable = {
				url: contextPath + "/GIISPostingLimitController?action=getPostingLimits&refresh=1",
				options: {
					height: '300px',
					width: '816px',
					hideColumnChildTitle: true,
					onCellFocus: function(element, value, x, y, id){
						objGiiss207.selectedIndex = y;
						postingLimitRowValue = postingLimitTableGrid.geniisysRows[y];
						populatePostingLimitMaintenance(postingLimitRowValue);
						toggleFieldClass();
						postingLimitTableGrid.keys.removeFocus(postingLimitTableGrid.keys._nCurrentFocus, true);
						postingLimitTableGrid.keys.releaseKeys();
					},
				 	onRemoveRowFocus: function(){
				 		rowIndex = -1;
						populatePostingLimitMaintenance(null);
						postingLimitTableGrid.keys.removeFocus(postingLimitTableGrid.keys._nCurrentFocus, true);
						postingLimitTableGrid.keys.releaseKeys();
						$("txtLineCd").focus();
	            	},
	            	beforeSort: function(){
	            		if (changeTag == 1) {
							showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function() {
								$("btnSavePostingLimitMaintenance").focus();
							});
							return false;
						}
	            	},
	            	onSort: function(){
	            		rowIndex = -1;
						populatePostingLimitMaintenance(null);
						postingLimitTableGrid.keys.removeFocus(postingLimitTableGrid.keys._nCurrentFocus, true);
						postingLimitTableGrid.keys.releaseKeys();
	            	},
	            	onRefresh: function(){
						rowIndex = -1;
						populatePostingLimitMaintenance(null);
						postingLimitTableGrid.keys.removeFocus(postingLimitTableGrid.keys._nCurrentFocus, true);
						postingLimitTableGrid.keys.releaseKeys();
					},
	            	prePager: function(){
	            		if (changeTag == 1) {
							showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function() {
								$("btnSavePostingLimitMaintenance").focus();
							});
							return false;
						}
	            		rowIndex = -1;
						populatePostingLimitMaintenance(null);
						postingLimitTableGrid.keys.removeFocus(postingLimitTableGrid.keys._nCurrentFocus, true);
						postingLimitTableGrid.keys.releaseKeys();
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
					},
					toolbar: {
						elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
						onFilter: function(){
							rowIndex = -1;
							populatePostingLimitMaintenance(null);
							postingLimitTableGrid.keys.removeFocus(postingLimitTableGrid.keys._nCurrentFocus, true);
							postingLimitTableGrid.keys.releaseKeys();
						}
					}
				},
				columnModel: [
					{   
						id: 'recordStatus',
						title: '',
					    width: '0',
					    visible: false,
					    editor: 'checkbox' 			
					},
					{	
						id: 'divCtrId',
						width: '0',
						visible: false
					},
					{	
						id: 'lineCd lineName',
		    		    title: 'Line',
		    		    sortable: true,
		    		    width : '190px',
		    		    children : [
		    	            {
		    	                id : 'lineCd',
		    	                title: 'Line Code',
				            	filterOption: true,
		    	                width: 50
		    	            },
		    	            {
		    	                id : 'lineName', 
		    	                title: 'Line Name',
				            	filterOption: true,
		    	                width: 140
		    	            }
		    	        ]
					},
					{	
						id: 'postLimit',
						title: 'Posting Limit',
						titleAlign: 'right',
						width: '130px',
						align: 'right',
						visible: true,
						filterOption: true,
						sortable: true,
						filterOptionType: 'numberNoNegative',
						geniisysClass: 'money'
					},
				 	{
					   	id: 'allAmtSw',
				    	title: 'A',
				    	width: '25px',
						titleAlign: 'center',
		            	align: 'center',
		            	altTitle: "All Amount",
		            	sortable: true,
		            	filterOption: true,
						filterOptionType: 'checkbox',
				    	defaultValue: false,
						otherValue: false,
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
						id: 'endtPostLimit',
						title: 'Endt. Posting Limit',
						titleAlign: 'right',
						width: '130px',
						align: 'right',
						visible: true,
						sortable: true,
						filterOption: true,
						filterOptionType: 'numberNoNegative',
						geniisysClass: 'money'
					},
				 	{
					   	id: 'endtAllAmtSw',
				    	title: 'E',
				    	width: '25px',
						titleAlign: 'center',
		            	align: 'center',
		            	altTitle: "Endt. All Amount",
		            	sortable: true,
		            	filterOption: true,
						filterOptionType: 'checkbox',
				    	defaultValue: false,
						otherValue: false,
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
						id: 'userId',
						title: 'User ID',
						width: '120px',
						sortable: true,
						filterOption: true,
						visible: true
					},
					{	
						id: 'lastUpdate',
						title: 'Last Update',
						width: '150px',
						sortable: true,
						filterOption: true,
						visible: true
					}
			   ],
			   rows: jsonPostingLimit.rows
			   
		};
		postingLimitTableGrid = new MyTableGrid(postingLimitTable);
		postingLimitTableGrid.pager = jsonPostingLimit;
		postingLimitTableGrid.render('postingLimitTableGridDiv');
		postingLimitTableGrid.afterRender = function(){
			objPostingLimitMain = postingLimitTableGrid.geniisysRows;
		};
	
	}catch (e) {
		showErrorMessage("Posting Limit Table Grid", e);
	}
		
	function populatePostingLimitMaintenance(obj){
		try {
			$("hidIssCd").value 					= (obj == null ? "" : unescapeHTML2($F("txtIssCd")));
			$("hidPostingUser").value 				= (obj == null ? "" : unescapeHTML2($F("txtUser")));
			$("hidLastValidPostingLimit").value 	= (obj == null ? "" : obj.postLimit);
			$("hidLastValidEndtPostingLimit").value = (obj == null ? "" : obj.endtPostLimit);
			$("hidLineCd").value 					= (obj == null ? "" : unescapeHTML2(obj.lineCd));
			$("hidLineName").value 					= (obj == null ? "" : unescapeHTML2(obj.lineName));
			$("txtLineCd").value 					= (obj == null ? "" : unescapeHTML2(obj.lineCd));
			$("txtLineName").value 					= (obj == null ? "" : unescapeHTML2(obj.lineName));
			$("txtPostingLimit").value 				= (obj == null ? "" : nvl(obj.postLimit,"") == "" ? "" : formatCurrency(obj.postLimit));
			$("txtPostingLimit").setAttribute("lastValidValue", (obj == null ? "" : nvl(obj.postLimit,"") == "" ? "" : formatCurrency(obj.postLimit)));
			$("chkAllAmountSw").checked 			= (obj == null ? false : (obj.allAmtSw == 'Y' ? true : false));
			$("chkAllAmount").checked 				= (obj == null ? false : (obj.allAmtSw == 'Y' ? true : false));
			$("txtEndtPostingLimit").value 			= (obj == null ? "" : nvl(obj.endtPostLimit,"") == "" ? "" : formatCurrency(obj.endtPostLimit));
			$("txtEndtPostingLimit").setAttribute("lastValidValue", (obj == null ? "" : nvl(obj.endtPostLimit,"") == "" ? "" : formatCurrency(obj.endtPostLimit)));
			$("chkEndtAllAmountSw").checked 		= (obj == null ? false : (obj.endtAllAmtSw == 'Y' ? true : false));
			$("chkEndtAllAmount").checked 			= (obj == null ? false : (obj.endtAllAmtSw == 'Y' ? true : false));
			$("txtUserId").value 					= (obj == null ? "" : unescapeHTML2(obj.userId));			
			$("txtLastUpdate").value 				= (obj == null ? "" : obj.lastUpdate);
			
			obj == null ? $("btnAddPostingLimit").value = "Add" : $("btnAddPostingLimit").value = "Update";
			obj == null ? disableButton("btnDeletePostingLimit") : enableButton("btnDeletePostingLimit");
			obj == null ? $("txtLineCd").readOnly = false : $("txtLineCd").readOnly = true;
			obj == null ? enableSearch("imgLineLOV") : disableSearch("imgLineLOV");
			obj == null ? toggleFieldClass() : toggleFieldClass();
		} catch (e) {
			showErrorMessage("Populate Posting Limit Maintenance", e);
		}
	}
		
	function createPostLimitObj(func){
 	    try {
 	       var limit = new Object();
 	       limit.postingUser 	= escapeHTML2($F("txtUser"));
 	       limit.issCd 			= escapeHTML2($F("txtIssCd"));
 	       limit.lineCd 		= escapeHTML2($F("txtLineCd"));
 	       limit.lineName 		= escapeHTML2($F("txtLineName"));
 	       limit.postLimit 		= $F("txtPostingLimit");
 	       limit.allAmtSw 		= $("chkAllAmount").checked ? "Y" : "N";
 	       limit.endtPostLimit 	= $("txtEndtPostingLimit").value; 	       
 	       limit.endtAllAmtSw 	= $("chkEndtAllAmount").checked ? "Y" : "N"; 
 	       limit.userId 		= escapeHTML2("${PARAMETERS['USER'].userId}");
 	       var lastUpdate 		= new Date();
 	       limit.lastUpdate 	= dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
 	       limit.recordStatus   = func == "Delete" ? -1 : func == "Add" ? 0 : 1;
 	       return limit;
 	     } catch (e) {
 	       showErrorMessage("createPostLimitObj", e);
 	     }
 	}
 	
	//add or update posting limit record in table grid
	function addUpdatePostingLimit(){ 
 		postLimitObj = createPostLimitObj($("btnAddPostingLimit").value);
 		if (checkAllRequiredFieldsInDiv("postingLimitTableMaintenanceFormDiv")) {
 	 		if ($("btnAddPostingLimit").value != "Add") {
 	 			objPostingLimitMain.splice(objGiiss207.selectedIndex, 1, postLimitObj);
 	 		 	postingLimitTableGrid.updateVisibleRowOnly(postLimitObj, objGiiss207.selectedIndex);
 	 		 	postingLimitTableGrid.onRemoveRowFocus();
 	 		 	changeTag = 1;
 	 		 	changeCounter++;
 			} else {
 				unsavedStatus = 1;
 				objPostingLimitMain.push(postLimitObj);
 		 	 	postingLimitTableGrid.addBottomRow(postLimitObj);
 		 		postingLimitTableGrid.onRemoveRowFocus();
 		 		changeTag = 1;
 		 		changeCounter++;
 			}
		}
 	}

	//delete posting limit record in table grid
 	function deletePostingLimit(){
 		delObj = createPostLimitObj($("btnDeletePostingLimit").value);
 		if (objGiiss207.selectedIndex != null){
 			objPostingLimitMain.splice(objGiiss207.selectedIndex, 1, delObj);
 			postingLimitTableGrid.deleteVisibleRowOnly(objGiiss207.selectedIndex);
 			postingLimitTableGrid.geniisysRows[objGiiss207.selectedIndex].postingUser = escapeHTML2($F("txtUser"));
 			postingLimitTableGrid.geniisysRows[objGiiss207.selectedIndex].issCd = escapeHTML2($F("txtIssCd"));
 			postingLimitTableGrid.geniisysRows[objGiiss207.selectedIndex].lineCd = escapeHTML2($F("txtLineCd"));
 			postingLimitTableGrid.onRemoveRowFocus();
			if(changeCounter == 1 && delObj.unsavedStatus == 1){
				changeTag = 0;
				changeCounter = 0;
			}else{
				changeCounter++;
				changeTag=1;
			}
 		}
 	}
	
	function showUserLOV(search) {
		try {
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGiiss207UserLOV",
					search : search,
					page: 1
				},
				title : "List of Users",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "userId",
					title : "User ID",
					width : '120px'
				}, {
					id : "username",
					title : "User Name",
					width : '345px'
				} ],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : search,
				onSelect : function(row) {
					if (row != null || row != undefined) {
						$("txtUser").value = unescapeHTML2(row.userId);
						$("txtUser").setAttribute("lastValidValue", unescapeHTML2(row.userId));
						$("txtUserName").value = unescapeHTML2(row.username);
						$("txtUserName").setAttribute("lastValidValue", unescapeHTML2(row.username));
						$("txtIssCd").focus();
						$("txtIssCd").value = "";
						$("txtIssCd").setAttribute("lastValidValue", "");
						$("txtIssName").value = "";
						$("txtIssName").setAttribute("lastValidValue", "");
						enableToolbarButton("btnToolbarEnterQuery");
						disableToolbarButton("btnToolbarExecuteQuery");
						enableSearch("imgBranchLOV");
						enableInputField("txtIssCd");
					}
				},
				onCancel : function() {
					$("txtUser").focus();
					$("txtUser").value = $("txtUser").readAttribute("lastValidValue");
					$("txtUserName").value = $("txtUserName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function() {
					$("txtUser").value = $("txtUser").readAttribute("lastValidValue");
					$("txtUserName").value = $("txtUserName").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtUser");
				}
			});
		} catch (e) {
			showErrorMessage("showUserLOV", e);
		}
	}
	
	function showBranchLOV(search) {
		try {
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGiiss207IssueSourceLOV",
					userId : unescapeHTML2($F("txtUser")),
					search : search,
					page: 1
				},
				title : "List of Branches",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "issCd",
					title : "Branch Code",
					width : '120px'
				}, {
					id : "issName",
					title : "Branch Name",
					width : '345px'
				} ],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : search,
				onSelect : function(row) {
					if (row != null || row != undefined) {
						$("txtIssCd").value = unescapeHTML2(row.issCd);
						$("txtIssCd").setAttribute("lastValidValue", unescapeHTML2(row.issCd));
						$("txtIssName").value = unescapeHTML2(row.issName);
						$("txtIssName").setAttribute("lastValidValue", unescapeHTML2(row.issName));
						enableToolbarButton("btnToolbarExecuteQuery");
					}
				},
				onCancel : function() {
					$("txtIssCd").focus();
					$("txtIssCd").value = $("txtIssCd").readAttribute("lastValidValue");
					$("txtIssName").value = $("txtIssName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function() {
					$("txtIssCd").value = $("txtIssCd").readAttribute("lastValidValue");
					$("txtIssName").value = $("txtIssName").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtIssCd");
				}
			});
		} catch (e) {
			showErrorMessage("showUserLOV", e);
		}
	}

	function showLineLOV(search){
		
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGiisPostingLimitLOV",
				            userId : $F("txtUser"),
							 issCd : $F("txtIssCd"),
							 search : search,
							  page : 1
			},
			title: "List of Lines",
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
			filterText : search,
			onSelect : function(row) {
				if (row != null || row != undefined) {
					$("txtLineCd").value = unescapeHTML2(row.lineCd);
					$("txtLineCd").setAttribute("lastValidValue", unescapeHTML2(row.lineCd));
					$("txtLineName").value = unescapeHTML2(row.lineName);
					$("txtLineName").setAttribute("lastValidValue", unescapeHTML2(row.lineName));
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
	}

	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("postingLimitTableMaintenanceFormDiv")){
				if($F("btnAddPostingLimit") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i=0; i<postingLimitTableGrid.geniisysRows.length; i++){
						if(postingLimitTableGrid.geniisysRows[i].recordStatus == 0 || postingLimitTableGrid.geniisysRows[i].recordStatus == 1){								
							if(postingLimitTableGrid.geniisysRows[i].lineCd == $F("txtLineCd")){
								addedSameExists = true;								
							}							
						} else if(postingLimitTableGrid.geniisysRows[i].recordStatus == -1){
							if(postingLimitTableGrid.geniisysRows[i].lineCd == $F("txtLineCd")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same posting_user, iss_cd and line_cd.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addUpdatePostingLimit();
						return;
					}
					addUpdatePostingLimit();
// 					new Ajax.Request(contextPath + "/GICLRepairTypeController", {
// 						parameters : {action : "valAddRec",
// 									  repairCode : $F("txtRepairCode")},
// 						onCreate : showNotice("Processing, please wait..."),
// 						onComplete : function(response){
// 							hideNotice();
// 							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
// 								addRec();
// 							}
// 						}
// 					});
				} else {
					addUpdatePostingLimit();
				}
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}	

  	function resetForm() {
  		$("txtLineCd").focus();
		$("prevAllAmount").checked = false;
		$("chkAllAmount").checked = false;
		$("prevEndtAllAmount").checked = false;
		$("chkEndtAllAmount").checked = false;
		$("txtPostingLimit").addClassName("required");
		$("txtEndtPostingLimit").addClassName("required");
		$("hidLastValidEndtPostingLimit").value = "";
		$("hidLastValidPostingLimit").value = "";
		enableInputField("txtPostingLimit");
		enableInputField("txtEndtPostingLimit");
	} 
 	
 	function formatAppearance() {
		$("btnAddPostingLimit").value = "Add";
		disableButton("btnDeletePostingLimit");
		enableSearch("imgLineLOV");
		postingLimitTableGrid.keys.releaseKeys();
		populatePostingLimitMaintenance(null);
	} 
		
	function disableEdit() {
		$("txtPostingLimit").value = addSeparatorToNumber2(formatNumberByRegExpPattern($("txtPostingLimit")), ",");
		$("txtEndtPostingLimit").value = addSeparatorToNumber2(formatNumberByRegExpPattern($("txtEndtPostingLimit")), ",");
		postingLimitTableGrid.keys.releaseKeys();
		$("btnAddPostingLimit").value = "Update";
		$("txtLineCd").focus();
		enableButton("btnDeletePostingLimit");
		toggleFieldClass($("chkAllAmountSw"), $("txtPostingLimit"));
		toggleFieldClass($("chkEndtAllAmountSw"), $("txtEndtPostingLimit"));
	}
   	
	//display last update and userid
	function displayValue() {
		$("txtLastUpdate").value = dateFormat(new Date(), 'mm-dd-yyyy hh:MM:ss TT');
		$("txtUserId").value = "${PARAMETERS['USER'].userId}";
	}displayValue();
	
	//for posting limit and endt. posting limit fields
	function toggleFieldClass() {
		if ($("chkAllAmountSw").checked == true) {
			$("txtPostingLimit").removeClassName("required");
			$("txtPostingLimit").setAttribute("readonly","readonly");
		} else {
			$("txtPostingLimit").addClassName("required");
			$("txtPostingLimit").removeAttribute("readonly");
		}
		
		if ($("chkEndtAllAmountSw").checked == true) {
			$("txtEndtPostingLimit").removeClassName("required");
			$("txtEndtPostingLimit").setAttribute("readonly","readonly");
		} else {
			$("txtEndtPostingLimit").addClassName("required");
			$("txtEndtPostingLimit").removeAttribute("readonly");
		}
	}
	
	/**
	 * params:	chkAmtSw - hidden checkbox that stores value from db
	 * 			prevAmtSw - hidden checkbox that stores the previous state of checkbox
	 *			customLabel - dynamic label for confirm box
	 *			txtLimit - textfield 
	 *			onNoFunc - function called on click of <No>
	 *			onYesFunc - function called on click of <Yes> 
	 */
	 
	//called on confirm message box
	function onYesFunc(chkSw, chkAmt, txtLimit, prevAmt) {
		chkAmt.checked = true;
		chkSw.checked = true;
		txtLimit.value = "";
		txtLimit.removeClassName("required");
		txtLimit.setAttribute("readonly","readonly");
		prevAmt.checked = true;
	}
	
	//called on confirm message box
	function onNoFunc(chkSw, chkAmt, txtLimit) {
		chkSw.checked == false ? chkAmt.checked = false : chkAmt.checked = true;
		if (chkSw.checked != true) { 
			txtLimit.addClassName("required");	
			if (txtLimit.contains("Endt")) {
				txtLimit.value = $("txtEndtPostingLimit").readAttribute("lastValidValue");
			}else {
				txtLimit.value = $("txtPostingLimit").readAttribute("lastValidValue");
			}
		}else {
			txtLimit.value = "";
			txtLimit.removeAttribute("readonly");
			txtLimit.addClassName("required");	
		}
	}
		
	//checkbox validation - confirm on switch to check
	function validateCheckbox(chkAmtSw, prevAmtSw, label, onNoFunc, onYesFunc) {
		objGiiss207.onNoFunc = onNoFunc;
		objGiiss207.onYesFunc = onYesFunc;
		if (chkAmtSw.checked == true) {
			prevAmtSw.checked = true;
		}
		if (prevAmtSw.checked == false) {
			showConfirmBox("Confirm", "Tagging this field will allow " + $F("txtUser") + " to issue " +  label + " with no Sum Insured Limit." 
										+ " Do you want to continue?", "Yes", "No", onYesFunc, onNoFunc);
		}else if (prevAmtSw.checked == true) {
			onNoFunc();
			prevAmtSw.checked = false;
		}
	}
	
	//validate posting limit
	function validatePostingLimit(limit, lastValidValue, focus){
		if (isNaN(limit.value)) {
			limit.value = lastValidValue.value;
		} else if ((limit.value < (parseInt(limit.getAttribute("min")))) || (limit.value > 999999999.99)) {
			customShowMessageBox("Invalid " + limit.getAttribute("customLabel") + ". Valid value should be from 0.00 to 999,999,999.99.", imgMessage.INFO, focus);
			limit.value = lastValidValue.value;
		} else if ((limit.value).include("-")) {
			customShowMessageBox("Invalid " + limit.getAttribute("customLabel") + ". Valid value should be from 0.00 to 999,999,999.99.", imgMessage.INFO, focus);
			limit.value = lastValidValue.value;
		} 
		else {
			limit.value = addSeparatorToNumber2(formatNumberByRegExpPattern(limit), ",");
			var decimalLimit = ((limit.value).include(".") ? limit.value : (limit.value)).split(".");
			if(decimalLimit[1].length > 2){				
				customShowMessageBox("Invalid " + limit.getAttribute("customLabel") + ". Valid value should be from 0.00 to 999,999,999.99.", imgMessage.INFO, focus);
				limit.value = lastValidValue.value;
			}else{				
				lastValidValue.value = limit.value;
			}
		}
	}
	
	function togglePostingLimitParam(enable) {
		try {
			if (enable) {
				$("txtUser").readOnly = true;
				$("txtIssCd").readOnly = true;
				disableSearch("imgUserLOV");
				disableSearch("imgBranchLOV");
			} else {
				$("txtUser").readOnly = false;
				$("txtIssCd").readOnly = false;
				enableSearch("imgUserLOV");
				disableSearch("imgBranchLOV");
			}
		} catch (e) {
			showErrorMessage("togglePostingLimitParam", e);
		}
	}

	function enableForm() {
		enableInputField("txtLineCd");
		enableInputField("txtPostingLimit");
		enableInputField("txtEndtPostingLimit");
		enableSearch("imgLineLOV");
		disableButton("btnDeletePostingLimit");
		enableButton("btnAddPostingLimit");
		enableButton("btnCopyToAnotherUserPostingLimit");
		$("chkAllAmount").disabled = false;
		$("chkEndtAllAmount").disabled = false;
		$("txtLineCd").focus();
		displayValue();
	}
	
	function enterQuery() {
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		postingLimitTableGrid.url = contextPath + "/GIISPostingLimitController?action=getPostingLimits&refresh=1";
		postingLimitTableGrid._refreshList();
		disableSearch("imgLineLOV");
		disableInputField("txtIssCd");
		disableInputField("txtLineCd");
		disableButton("btnCopyToAnotherUserPostingLimit");
		disableButton("btnAddPostingLimit");
		togglePostingLimitParam(false);
		$("txtUser").clear();
		$("txtUserName").clear();
		$("txtIssCd").clear();
		$("txtIssName").clear();
		$("txtUser").focus();
		$("txtUser").setAttribute("lastValidValue", "");
		$("txtUserName").setAttribute("lastValidValue", "");
		$("txtIssCd").setAttribute("lastValidValue", "");
		$("txtIssName").setAttribute("lastValidValue", "");
		$("txtPostingLimit").addClassName("required");
		$("txtEndtPostingLimit").addClassName("required");
		$("chkEndtAllAmount").disabled = true;
		$("chkAllAmount").disabled = true;
		changeTag = 0;
	}
	
	function exitPage() {
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}
	
	function cancelGiiss207() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function() {
				objGiiss207.exitPage = exitPage;
				savePostingLimits();
			}, function() {
				goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
			}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}
	
	$("imgUserLOV").observe("click", function() {
		showUserLOV("%");
	});

	$("txtUser").observe("change", function() {
		if (this.value != "") {
			showUserLOV($("txtUser").value);
		} else {
			$("txtUser").value = "";
			$("txtUser").setAttribute("lastValidValue", "");
			$("txtUserName").value = "";
			$("txtUserName").setAttribute("lastValidValue", "");
			$("txtIssCd").value = "";
			$("txtIssCd").setAttribute("lastValidValue", "");
			$("txtIssName").value = "";
			$("txtIssName").setAttribute("lastValidValue", "");
			disableToolbarButton("btnToolbarExecuteQuery");
			disableToolbarButton("btnToolbarEnterQuery");
			disableSearch("imgBranchLOV");
			disableInputField("txtIssCd");
		}
	});	
	
	$("imgBranchLOV").observe("click", function() {
		showBranchLOV("%");
	});

	$("txtIssCd").observe("change", function() {
		if (this.value != "") {
			showBranchLOV($("txtIssCd").value);
		} else {
			$("txtIssCd").value = "";
			$("txtIssCd").setAttribute("lastValidValue", "");
			$("txtIssName").value = "";
			$("txtIssName").setAttribute("lastValidValue", "");
			disableToolbarButton("btnToolbarExecuteQuery");
		}
	});	

	$("imgLineLOV").observe("click", function() {
		showLineLOV("%");
	});

	$("txtLineCd").observe("change", function() {
		if (this.value != "") {
			showLineLOV($F("txtLineCd"));
		} else {
			$("txtLineCd").value = "";
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtLineName").value = "";
			$("txtLineName").setAttribute("lastValidValue", "");
		}
	});	
		
	//show copy user overlay
	$("btnCopyToAnotherUserPostingLimit").observe("click", function() {
		objGiiss207.userId = unescapeHTML2($F("txtUser"));
		objGiiss207.userName = unescapeHTML2($F("txtUserName"));
		objGiiss207.issCd = unescapeHTML2($F("txtIssCd"));
		objGiiss207.issName = unescapeHTML2($F("txtIssName"));
 		overlayCopyToAnotherUser = Overlay.show(contextPath+"/GIISPostingLimitController", {
	 		urlContent: true,
	 		urlParameters: {action : "showCopyToAnotherUser"},
	 		title: "Copy To Another User",
	 		height: 250,
	 		width: 380,
	 		draggable: true
	 		});
	});

	//all amount switch observer
	$("chkAllAmount").observe("click", function(){
		if ($("chkAllAmount").checked == true) {
			showConfirmBox("Confirm", "Tagging this field will allow " + $F("txtUser") + " to issue policy with no Sum Insured Limit." 
					+ " Do you want to continue?", "Yes", "No", function() {
						$("txtPostingLimit").removeClassName("required");
						$("txtPostingLimit").clear();
						disableInputField("txtPostingLimit");
					}, function() {
						$("chkAllAmount").checked = false;
					});
		}else {
			$("txtPostingLimit").addClassName("required");
			enableInputField("txtPostingLimit");
		}
 	});
	
	//endt. all amount switch observer
	$("chkEndtAllAmount").observe("click", function(){
		if ($("chkEndtAllAmount").checked == true) {
			showConfirmBox("Confirm", "Tagging this field will allow " + $F("txtUser") + " to issue endorsement with no Sum Insured Limit." 
					+ " Do you want to continue?", "Yes", "No", function() {
						$("txtEndtPostingLimit").removeClassName("required");
						$("txtEndtPostingLimit").clear();
						disableInputField("txtEndtPostingLimit");
					}, function() {
						$("chkEndtAllAmount").checked = false;
					});
		}else {
			$("txtEndtPostingLimit").addClassName("required");
			enableInputField("txtEndtPostingLimit");
		}
 	});	
	
	//add and delete button observers
	$("btnAddPostingLimit").observe("click", valAddRec);
	
	$("btnDeletePostingLimit").observe("click", function() {
		deletePostingLimit();
	});
	
	//save observer
	observeSaveForm("btnSavePostingLimitMaintenance", savePostingLimits);
	observeSaveForm("btnToolbarSave", savePostingLimits);
	
	$("btnToolbarEnterQuery").observe("click", function() {
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function() {
				objGiiss207.exitPage = enterQuery;
				savePostingLimits();
			}, function() {
				enterQuery();
			}, "");
		} else {
			enterQuery();
		}
	});

	$("btnToolbarExecuteQuery").observe("click", function() {
		if (checkAllRequiredFieldsInDiv("headerParamsDiv")) {
			disableToolbarButton(this.id);
			enableToolbarButton("btnToolbarEnterQuery");
			postingLimitTableGrid.url = contextPath + "/GIISPostingLimitController?action=getPostingLimits&refresh=1&postingUser="+unescapeHTML2($F("txtUser"))+"&issCd="+unescapeHTML2($F("txtIssCd"));
			postingLimitTableGrid._refreshList();
			togglePostingLimitParam(true);
			enableForm();
		}
	});
	
	$("btnCancelPostingLimitMaintenance").observe("click", cancelGiiss207);
	
	$("btnToolbarExit").stopObserving("click");
	$("btnToolbarExit").observe("click", function(){
		fireEvent($("btnCancelPostingLimitMaintenance"), "click");
	});
	
		
		//reload form observer
	observeReloadForm("reloadForm", function() {
		showPostingLimitMaintenance();
	});
	
	//set field
	togglePostingLimitParam(false);
	$("txtUser").focus();
	$("txtPostingLimit").addClassName("required");
	$("txtEndtPostingLimit").addClassName("required");
	disableSearch("imgLineLOV");
	disableInputField("txtLineCd");
	showToolbarButton("btnToolbarSave");
	hideToolbarButton("btnToolbarPrint");
	disableToolbarButton("btnToolbarEnterQuery");
	disableToolbarButton("btnToolbarExecuteQuery");

</script>