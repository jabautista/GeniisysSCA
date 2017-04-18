<!-- <div id="perilClassMaintenanceDetailsDiv"> -->

	<div id="outerDiv" name="outerDiv"
		style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Perils per Peril Class</label> <span class="refreshers"
				style="margin-top: 0;"> <label id="gro" name="gro"
				style="margin-left: 5px;">Hide</label>
			</span>
		</div>
	</div>
<div class="sectionDiv" id="perilClassDetailsSectionDiv" name="perilClassDetailsSectionDiv">	
		<div id="perilClassDetailsDiv" name="perilClassDetailsDiv" >
			<div id="perilClassDetailsTableGrid" style="height: 250px; border-bottom: 0px; position: relative;  padding: 10px 45px; /* margin: auto;  */margin: 15px;">
		</div>	
		<div id="perilClassDetailsInfoDiv" align="center">		
			<table border="0"
				style="margin: auto; margin-top: 10px; margin-bottom: 10px;">
				<tr>
					<%-- <input type="hidden" id="classCd" name="classCd" value="${classCd}"/> --%>
					<td class="rightAligned">Line Name</td>
					<td class="leftAligned"">
						<div style="float: left; border: solid 1px gray; width: 400px; height: 21px; margin-right: 3px;" class="required">
							<input type="hidden" id="lineCd" name="lineCd" value=""/>
							<input type="text" tabindex=202 style="float: left; margin-top: 0px; margin-right: 3px; width: 370px; border: none;" name="txtLineName" id="txtLineName" readonly="readonly" class="required" value=""/>
							<img id="hrefClassLineName" alt="goClassLineName" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Peril Name</td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 400px; height: 21px; margin-right: 3px;" class="required">
							<input type="hidden" id="perilCd" name="perilCd" value="${perilCd}"/>
							<input type="hidden" id="txtPerilSname" name="txtPerilSname" value="${perilSname}"/>
							<input type="text" tabindex=203 style="float: left; margin-top: 0px; margin-right: 3px; width: 370px; border: none;" name="txtPerilName" id="txtPerilName" readonly="readonly" class="required" /> 
							<img id="hrefClassPerilName" alt="goClassPerilName" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 130px;">Remarks</td>
					<td class="leftAligned">
						<div style="float: left; border: solid 1px gray; width: 400px; height: 20px;">
							<%-- <input type="text" tabindex=204 style="height: 13px; float: left; margin-top: 0px; width: 370px; border: none;" name="txtRemarks" id="txtRemarks" maxlength="4000" />  
							<img id="hrefRemarks" alt="goRemarks" style="height: 14px;" class="hover" src="${pageContext.request.contextPath}/images/misc/edit.png" /> --%>
							<textarea id="txtRemarks" name="txtRemarks" style="width: 370px; border: none; height: 13px;" maxlength="4000" tabIndex = "204"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="hrefRemarks" textField="txtRemarks" charLimit="4000" />
									
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 130px;">User ID</td>
					<td class="leftAligned">
							<input type="text" tabindex=204 style="float: left; margin-top: 0px; width: 150px;" name="txtUserId" id="txtUserId" value="${userId}" readonly="readonly" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 130px;">Last Update</td>
					<td class="leftAligned">
							<input type="text" tabindex=204 style="float: left; margin-top: 0px; width: 150px;" name="txtLastUpdate" id="txtLastUpdate" value=""  readonly="readonly"/>
					</td>
				</tr>
			</table>
			<div class="buttonsDiv" style="margin-bottom: 15px">
				<input type="button" id="btnAddPerilClass" name="btnAddPerilClass" class="button" value="Add" tabindex=205 />
				<input type="button" id="btnDeletePerilClass" name="btnDeletePerilClass" class="button" value="Delete" tabindex=206/>
			</div>
		</div>
	</div>
</div>
<script>
	changeTag = 0;
	currPerilClassRec = null;
// 	var objPerilClass = [];
	var allPerilsPerClassDetailsObj = [];
	var lineCdOrig = "";
	var perilCdOrig = "";
	objUWGlobal.giiss062Obj = {};
	remarksReadOnly = 'false';
	initializeChangeTagBehavior(savePerilClass);
	
	$("txtLastUpdate").value = dateFormat(new Date(),'mm-dd-yyyy hh:MM:ss TT');
	disableButton("btnDeletePerilClass");
	try {

		var objPerilClassDetail = new Object();
		objPerilClassDetail.perilClassDetailGrid = {};
		objPerilClassDetail.objPerilClassRecords = objPerilClassDetail.perilClassDetailGrid.rows
				|| [];

		var perilClassDetailModel = {
			url : contextPath + "/GIISPerilsPerPerilClassController?action=getPerilsPerClassDetails",
			options : {
				title : '',
				width : '800px',
				onCellFocus : function(element, value, x, y, id) {
					currPerilClassRec = perilClassDetailGrid.geniisysRows[y];
					populatePerilDetails(currPerilClassRec);
					enableButton("btnDeletePerilClass");
					perilClassDetailGrid.keys.removeFocus(perilClassDetailGrid.keys._nCurrentFocus, true);
					perilClassDetailGrid.keys.releaseKeys();
				},
				onRemoveRowFocus : function() {
					currPerilClassRec = null;
					populatePerilDetails(null);
					perilClassDetailGrid.keys.removeFocus(perilClassDetailGrid.keys._nCurrentFocus, true);
					perilClassDetailGrid.keys.releaseKeys();
				},
				beforeSort: function(){
					return validateChanges(perilClassDetailGrid);
					perilClassDetailGrid.keys.removeFocus(perilClassDetailGrid.keys._nCurrentFocus, true);
					perilClassDetailGrid.keys.releaseKeys();
				},
				postPager: function () {
					populatePerilDetails(null);
					perilClassDetailGrid.keys.releaseKeys();
				},
				pager:{},
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN,MyTableGrid.REFRESH_BTN],
					onRefresh: function(){
						populatePerilDetails(null);
						perilClassDetailGrid.keys.releaseKeys();
					},
					onFilter: function(){
						populatePerilDetails(null);
						perilClassDetailGrid.keys.releaseKeys();
					}
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
				}, 
				{
					id : 'classCd',
					title : '',
					width : '0',
					filterOption : false,
					visible : false
				}, 
				{
					id : 'classDesc',
					title : '',
					width : '0',
					filterOption : false,
					visible : false
				}, 
				{
					id : 'lineCd',
					title : 'Line Code',
					width : '70px',
					filterOption : true
				}, 
				{
					id : 'lineName',
					title : 'Line Name',
					width : '130px',
					filterOption : true
				}, 
				{
					id : 'perilCd',
					title : '',
					width : '0px',
					filterOption : false,
					visible : false
				}, 
				{
					id : 'perilSname',
					title : 'Peril Short Name',
					width : '130px',
					filterOption : true
				}, 
				{
					id : 'perilName',
					title : 'Peril Name',
					width : '180px',
					filterOption : true
				}, 
				{
					id : 'userId',
					title : '',
					width : '0',
					visible : false
				}, 
				{
					id : 'lastUpdate',
					title : '',
					width : '0',
					visible : false
				}, 
				{
					id : 'remarks',
					title : 'Remarks',
					width : '250px',
				}, 
				{
					id : 'cpiRecNo',
					title : '',
					width : '0',
					visible : false
				}, 
				{
					id : 'cpiBranchCd',
					title : '',
					width : '0',
					visible : false
				}
			],
			rows : objPerilClassDetail.objPerilClassRecords
		};
		perilClassDetailGrid = new MyTableGrid(perilClassDetailModel);
		perilClassDetailGrid.render('perilClassDetailsTableGrid');
		perilClassDetailGrid.pager = objPerilClassDetail.perilClassDetailGrid;
		perilClassDetailGrid.afterRender = function(){
// 														objPerilClass=perilClassDetailGrid.geniisysRows;
														getAllPerilsPerClassDetails();
		};
	} catch (e) {
		showErrorMessage("perilClassDetailModel", e);
	}

	$("hrefClassLineName").observe("click", function() {
		showGiisLineCdWithUserAccessLOV("GIISS062");
	});

	try {
		$("hrefClassPerilName").observe("click", function() {
			if ($F("txtLineName").trim() == "") {
				showMessageBox("Please enter Line Code first.","I");
			} else {
				showGiisPerilNameLOV($F("lineCd"));
			}
		});
	} catch (e) {
		showErrorMessage("Show GIIS Peril LOV", e);
	}

	function showGiisPerilNameLOV(lineCd) {
		try {
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGiisPerilCdNameLOV",
					lineCd : lineCd,
					page : 1
				},
				title : "",
				width : 405,
				height : 386,
				columnModel : [ {
					id : "perilCd",
					title : "Peril Code",
					width : '80px',
					align: 'right',
					titleAlign: 'right'
				}, {
					id : "perilSname",
					title : "Peril Short Name",
					width : '100px'
				}, {
					id : "perilName",
					title : "Peril Name",
					width : '200px'
				} ],
				draggable : true,
				onSelect : function(row) {
					$("perilCd").value = unescapeHTML2(row.perilCd);
					$("txtPerilSname").value = unescapeHTML2(row.perilSname);
					$("txtPerilName").value = unescapeHTML2(row.perilName);
				}
			});
		} catch (e) {
			showErrorMessage("Show GIIS Peril LOV func", e);
		}
	}

	function populatePerilDetails(obj) {
		try {
			$("txtLineName").value 			= obj == null ? "" 													: unescapeHTML2(obj.lineName);
			$("txtPerilName").value 		= obj == null ? "" 													: unescapeHTML2(obj.perilName);
			$("txtRemarks").value 			= obj == null ? "" 													: unescapeHTML2(obj.remarks);
			$("txtUserId").value 			= obj == null ? "${userId}"     									: unescapeHTML2(obj.userId);
			$("txtLastUpdate").value	    = obj == null ? dateFormat(new Date(),'mm-dd-yyyy hh:MM:ss TT') 	: nvl(obj.sdfLastUpdate,obj.lastUpdate);
			$("lineCd").value 				= obj == null ? "" 													: unescapeHTML2(obj.lineCd);
			$("perilCd").value 				= obj == null ? "" 													: unescapeHTML2(obj.perilCd);
			$("txtPerilSname").value 		= obj == null ? "" 													: unescapeHTML2(obj.perilSname);
			lineCdOrig 						= obj == null ? "" 													: unescapeHTML2(obj.lineCd);
			perilCdOrig 					= obj == null ? "" 													: unescapeHTML2(obj.perilCd);
			
			if (obj != null && obj.recordStatus === "") {
				$("txtRemarks").readOnly = true;
				disableSearch("hrefClassLineName");
				disableSearch("hrefClassPerilName");
				remarksReadOnly = 'true';
				disableButton("btnAddPerilClass");
				$("btnAddPerilClass").value = "Add";
				
			}else if(obj != null && obj.recordStatus !== ""){
				$("txtRemarks").readOnly = false;
				enableSearch("hrefClassLineName");
				enableSearch("hrefClassPerilName");
				remarksReadOnly = 'false';
				enableButton("btnAddPerilClass");
				$("btnAddPerilClass").value = "Update";
			}else{
				$("txtRemarks").readOnly = false;
				enableSearch("hrefClassLineName");
				enableSearch("hrefClassPerilName");
				remarksReadOnly = 'false';
				enableButton("btnAddPerilClass");
				$("btnAddPerilClass").value = "Add";
				disableButton("btnDeletePerilClass");
			}
		} catch (e) {
			showErrorMessage("populatePerilDetails", e);
		}
	}
	objUWGlobal.giiss062Obj.populatePerilDetails = populatePerilDetails;
	
	function createNewPerilClass(obj) {
		try {
			var pcObject = new Object();
			pcObject.classCd = $F("hidClassCd");
			pcObject.lineCd = $F("lineCd");
			pcObject.lineName = escapeHTML2($F("txtLineName"));
			pcObject.perilCd = $F("perilCd");
			pcObject.perilSname = escapeHTML2($F("txtPerilSname"));
			pcObject.perilName = escapeHTML2($F("txtPerilName"));
			pcObject.remarks = escapeHTML2($F("txtRemarks"));
			pcObject.userId = escapeHTML2($F("txtUserId"));
			pcObject.lastUpdate = $F("txtLastUpdate");
			
			pcObject.lineCdOrig = lineCdOrig;
			pcObject.perilCdOrig = perilCdOrig;
			return pcObject;
		} catch (e) {
			showErrorMessage("createNewPerilClass", e);
		}
	}

	function addPerilClass() {
		try {
			if(isValid($("hidClassCd").value)){
				var newObj  = createNewPerilClass();
				if(checkAllRequiredFieldsInDiv("perilClassDetailsInfoDiv")){
					if ($F("btnAddPerilClass") == "Update"){
						//on UPDATE records
						if(newObj.lineCdOrig == newObj.lineCd && newObj.perilCdOrig == newObj.perilCd){
							for(var i = 0; i<allPerilsPerClassDetailsObj.length; i++){
								if ((allPerilsPerClassDetailsObj[i].classCd == newObj.classCd)
										&&(allPerilsPerClassDetailsObj[i].lineCd == newObj.lineCdOrig)
										&&(allPerilsPerClassDetailsObj[i].perilCd == newObj.perilCdOrig)
										&&(allPerilsPerClassDetailsObj[i].recordStatus != -1)){
									newObj.recordStatus = 1;
									allPerilsPerClassDetailsObj.splice(i, 1, newObj);
									perilClassDetailGrid.updateVisibleRowOnly(newObj, perilClassDetailGrid.getCurrentPosition()[1]);
									populatePerilDetails(null);
									changeTag = 1;
								}
							}
						}else if (validateRecordBeforeAdding(newObj)) {
							for(var i = 0; i<allPerilsPerClassDetailsObj.length; i++){
								if ((allPerilsPerClassDetailsObj[i].classCd == newObj.classCd)
										&&(allPerilsPerClassDetailsObj[i].lineCd == newObj.lineCdOrig)
										&&(allPerilsPerClassDetailsObj[i].perilCd == newObj.perilCdOrig)
										&&(allPerilsPerClassDetailsObj[i].recordStatus != -1)){
									newObj.recordStatus = 1;
									allPerilsPerClassDetailsObj.splice(i, 1, newObj);
									perilClassDetailGrid.updateVisibleRowOnly(newObj, perilClassDetailGrid.getCurrentPosition()[1]);
									populatePerilDetails(null);
									changeTag = 1;
								}
							}
						}
					}else{
						//on ADD records
						if (validateRecordBeforeAdding(newObj)) {
							newObj.recordStatus = 0;
							allPerilsPerClassDetailsObj.push(newObj);
							perilClassDetailGrid.addBottomRow(newObj);
							populatePerilDetails(null);
							changeTag = 1;
						}
						
					}
					perilClassDetailGrid.keys.releaseKeys();
				}
			}
		} catch (e) {
			showErrorMessage("addPerilClass", e);
		}
	}
	
	function validateRecordBeforeAdding(obj) {
		var notExist = true;
		for(var i = 0; i<allPerilsPerClassDetailsObj.length; i++){
			if ((allPerilsPerClassDetailsObj[i].classCd == obj.classCd)
					&&(allPerilsPerClassDetailsObj[i].lineCd == obj.lineCd)
					&&(allPerilsPerClassDetailsObj[i].perilCd == obj.perilCd)
					&&(allPerilsPerClassDetailsObj[i].recordStatus != -1)){
				notExist = false;
				showMessageBox("Peril class must be unique.","E");
				break;
			}
		}
		return notExist;
	}
	
	function isValid() {
		var isValid = false;
		if ($("hidClassCd").value == "" || $("hidClassCd").value == null) {
			showMessageBox('Please select a peril class.', "I");
			isValid = false;
		} else {
			isValid = true;
		}
		return isValid;
	}
	
	function validateChanges(tbgName) {
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",savePerilClass,
					function(){
						tbgName.onRemoveRowFocus();
						tbgName._refreshList();
						changeTag = 0;
					}, "");
			return false;
		}else{
			return true;
		}
	}
	
	objUWGlobal.giiss062Obj.validateChanges = validateChanges;

	function delPerilClass() {
		try {
			for(var i = 0; i<allPerilsPerClassDetailsObj.length; i++){
				if ((allPerilsPerClassDetailsObj[i].classCd == currPerilClassRec.classCd)
						&&(allPerilsPerClassDetailsObj[i].lineCd == currPerilClassRec.lineCd)
						&&(allPerilsPerClassDetailsObj[i].perilCd == currPerilClassRec.perilCd)
						&&(allPerilsPerClassDetailsObj[i].recordStatus != -1)){
					currPerilClassRec.recordStatus = -1;
					allPerilsPerClassDetailsObj.splice(i, 1, currPerilClassRec);
	 				perilClassDetailGrid.deleteRow(perilClassDetailGrid.getCurrentPosition()[1]);
	 				changeTag = 1;
	 				populatePerilDetails(null);
	 				perilClassDetailGrid.keys.removeFocus(perilClassDetailGrid.keys._nCurrentFocus, true);
	 				perilClassDetailGrid.keys.releaseKeys();
				}
			}
		} catch (e) {
			showErrorMessage("delPerilClas", e);
		}
	}

	function savePerilClass() {
		try {
			var setRows = getAddedAndModifiedJSONObjects(allPerilsPerClassDetailsObj);
			var delRows = getDeletedJSONObjects(allPerilsPerClassDetailsObj); 

			new Ajax.Request(
					contextPath + "/GIISPerilsPerPerilClassController", {
						method : "POST",
						parameters : {
							action : "savePerilClass",
							setRows : prepareJsonAsParameter(setRows),
							delRows : prepareJsonAsParameter(delRows)
						},
						onCreate:function(){
							showNotice("Saving Perils per Peril Class, please wait...");
						},
						onComplete : function(response) {
							hideNotice();
							if (checkErrorOnResponse(response)) {
								if ("SUCCESS" == response.responseText) {
									showMessageBox(objCommonMessage.SUCCESS,imgMessage.SUCCESS);
// 									tbgEventMaintenance.refresh();
									perilClassDetailGrid.refresh();
									populatePerilDetails(null);
									changeTag = 0;
								}
							}
						}
					});

		} catch (e) {
			showErrorMessage("savePerilClass", e);
		}
	}
	objUWGlobal.giiss062Obj.savePerilClass = savePerilClass;
	
	function getAllPerilsPerClassDetails() {
		try {
			new Ajax.Request(contextPath+"/GIISPerilsPerPerilClassController",{
				parameters:{
							action : "getAllPerilsPerClassDetails",
							classCd : $F("hidClassCd"),
							moduleId : "GIISS062"
						   },
				asynchronous: false,
				evalScripts: true,
				onComplete: function (response){
					if (checkErrorOnResponse(response)){
						allPerilsPerClassDetailsObj = eval(response.responseText);
					}
				}
			});
		} catch (e){
			showErrorMessage("getAllPerilsPerClassDetails", e);
		}
	}

	
	$("hrefRemarks").observe("click", function(){
		showEditor("txtRemarks", 4000,remarksReadOnly);
	});
	$("btnDeletePerilClass").observe("click", delPerilClass);
	$("btnAddPerilClass").observe("click", addPerilClass);
	$("btnSavePerilClass").observe("click", function() {
		if (changeTag == 1) {
			savePerilClass();
		} else {
			showMessageBox(objCommonMessage.NO_CHANGES,"I");
		}
	});
</script>