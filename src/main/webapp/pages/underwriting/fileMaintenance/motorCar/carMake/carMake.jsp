<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="giiss103MainDiv" name="giiss103MainDiv">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="btnExit">Exit</a></li>
			</ul>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Car Make Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	
	<div id="giiss005" name="giiss005">
		<div class="sectionDiv">
			<div style="padding-top: 10px;">
				<div id="makeTable" style="height: 340px; margin-left: 95px;"></div>
			</div>
			
			<div align="center" id="makeFormDiv" style="margin-right: 30px;">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Code</td>
						<td class="leftAligned"><input id="makeCd" type="text" class="" style="width: 200px; text-align: right;" lastValidValue="" maxlength="12" tabindex="101" readonly="readonly"></td>
						<td class="rightAligned">No. of Pass</td>
						<td class="leftAligned"><input id="noOfPass" type="text" class="integerNoNegativeUnformattedNoComma" style="width: 200px; text-align: right;" lastValidValue="" maxlength="3" tabindex="102"></td>
					</tr>
					<tr>
						<td class="rightAligned">Make</td>
						<td class="leftAligned" colspan="3">
							<input id="make" type="text" class="required" style="width: 533px;" tabindex="103" maxlength="50" lastValidValue="">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Subline</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan" style="width: 100px; height: 21px; margin: 0; float: left;">
								<input id="sublineCd" type="text" class="upper" style="width: 70px; height: 13px; float: left; border: none;" lastValidValue="" maxlength="7" tabindex="104" ignoreDelKey="true">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSubline" name="searchSubline" alt="Go" style="float: right;">
							</span>
							<input id="sublineName" type="text" style="width: 428px; margin: 0 0 3px 3px; height: 15px;" tabindex="105" readonly="readonly">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Car Company</td>
						<td class="leftAligned" colspan="3">
							<span class="required lovSpan" style="width: 100px; height: 21px; margin: 0; float: left;">
								<input id="carCompanyCd" type="text" class="required integerNoNegativeUnformattedNoComma" style="width: 73px; height: 13px; float: left; border: none; text-align: right;" lastValidValue="" maxlength="6" tabindex="106" ignoreDelKey="true">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchCarCompany" name="searchCarCompany" alt="Go" style="float: right;">
							</span>
							<input id="carCompany" type="text" style="width: 428px; margin: 0 0 3px 3px; height: 15px;" tabindex="107" readonly="readonly">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="remarks" name="remarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="108" ignoreDelKey="true"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User Id</td>
						<td class="leftAligned"><input id="userId" type="text" class="" style="width: 200px; margin-right: 46px;" readonly="readonly" tabindex="109"></td>
						<td class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="lastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="110"></td>
					</tr>
				</table>
			</div>
			
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="111">
				<input type="button" class="disabledButton" id="btnDelete" value="Delete" tabindex="112">
			</div>
			
			<div style="margin: 10px; padding: 10px; border-top: 1px solid #E0E0E0; margin-bottom: 0;" align="center">
				<input type="button" class="disabledButton" id="btnEngine" value="Engine Series" style="width: 150px;" tabindex="113">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="114">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="115">
</div>

<script type="text/javascript">
	var rowIndex = -1;
	var objGIISS103 = {};
	var selectedRow = null;
	objGIISS103.makeList = JSON.parse('${makeJSON}');
	objGIISS103.exitPage = null;

	var makeModel = {
		url: contextPath + "/GIISMcMakeController?action=showGIISS103&refresh=1",
		options: {
			width: '760px',
			height: '332px',
			pager: {},
			onCellFocus: function(element, value, x, y, id){
				rowIndex = y;
				selectedRow = makeTG.geniisysRows[y];
				setFieldValues(selectedRow);
				makeTG.keys.removeFocus(makeTG.keys._nCurrentFocus, true);
				makeTG.keys.releaseKeys();
				$("makeCd").focus();
			},
			onRemoveRowFocus: function(){
				rowIndex = -1;
				setFieldValues(null);
				makeTG.keys.removeFocus(makeTG.keys._nCurrentFocus, true);
				makeTG.keys.releaseKeys();
				$("makeCd").focus();
			},
			toolbar: {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter: function(){
					rowIndex = -1;
					setFieldValues(null);
					makeTG.keys.removeFocus(makeTG.keys._nCurrentFocus, true);
					makeTG.keys.releaseKeys();
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
				makeTG.keys.removeFocus(makeTG.keys._nCurrentFocus, true);
				makeTG.keys.releaseKeys();
			},
			onRefresh: function(){
				rowIndex = -1;
				setFieldValues(null);
				makeTG.keys.removeFocus(makeTG.keys._nCurrentFocus, true);
				makeTG.keys.releaseKeys();
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
				makeTG.keys.removeFocus(makeTG.keys._nCurrentFocus, true);
				makeTG.keys.releaseKeys();
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
			{   id: 'recordStatus',
			    width: '0',				    
			    visible: false			
			},
			{	id: 'divCtrId',
				width: '0',
				visible: false
			},
			{	id: 'makeCd',
				title: 'Code',
				width: '78px',
				align: 'right',
				titleAlign: 'right',
				filterOption: true,
				filterOptionType: 'integerNoNegative'
			},
			{	id: 'make',
				title: 'Make',
				width: '350px',
				filterOption: true
			},
			{	id: 'noOfPass',
				title: 'No. of Pass',
				width: '100px',
				align: 'right',
				titleAlign: 'right',
				filterOption: true,
				filterOptionType: 'integerNoNegative'
			},
			{	id: 'sublineCd',
				title: 'Subline Code',
				width: '97px',
				filterOption: true
			},
			{	id: 'carCompanyCd',
				title: 'Car Co. Code',
				width: '100px',
				align: 'right',
				titleAlign: 'right',
				filterOption: true,
				filterOptionType: 'integerNoNegative'
			}
		],
		rows : objGIISS103.makeList.rows
	};
	makeTG = new MyTableGrid(makeModel);
	makeTG.pager = objGIISS103.makeList;
	makeTG.render("makeTable");
	
	function newFormInstance(){
		$("noOfPass").focus();
		setModuleId("GIISS103");
		setDocumentTitle("Car Make Maintenance");
		initializeAll();
		makeInputFieldUpperCase();
		changeTag = 0;
	}
	
	function setFieldValues(rec){
		try{
			$("makeCd").value = (rec == null ? "" : rec.makeCd);
			$("make").value = (rec == null ? "" : unescapeHTML2(rec.make));
			$("noOfPass").value = (rec == null ? "" : rec.noOfPass);
			$("sublineCd").value = (rec == null ? "" : unescapeHTML2(rec.sublineCd));
			$("sublineCd").setAttribute("lastValidValue", $F("sublineCd"));
			$("sublineName").value = (rec == null ? "" : unescapeHTML2(rec.sublineName));
			$("carCompanyCd").value = (rec == null ? "" : rec.carCompanyCd);
			$("carCompanyCd").setAttribute("lastValidValue", $F("carCompanyCd"));
			$("carCompany").value = (rec == null ? "" : unescapeHTML2(rec.carCompany));
			$("remarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("userId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("lastUpdate").value = (rec == null ? "" : rec.dspLastUpdate);
			$("make").setAttribute("lastValidValue", unescapeHTML2($F("make")));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("carCompanyCd").readOnly = false : $("carCompanyCd").readOnly = true;
			rec == null ? enableSearch("searchCarCompany") : disableSearch("searchCarCompany");
			rec == null ? disableButton("btnEngine") : enableButton("btnEngine");
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			
			enableInputField("make");
			
			selectedRow = rec;
		}catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			var lastUpdate = new Date();
			
			obj.makeCd = $F("makeCd");
			obj.make = escapeHTML2($F("make"));
			obj.noOfPass = $F("noOfPass");
			obj.sublineCd = $F("sublineCd");
			obj.sublineName = escapeHTML2($F("sublineName"));
			obj.carCompanyCd = $F("carCompanyCd");
			obj.carCompany = escapeHTML2($F("carCompany"));
			obj.remarks = escapeHTML2($F("remarks"));
			obj.userId = userId;
			obj.dspLastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISMcMakeController", {
				parameters: {
					action: "valDeleteRec",
					makeCd: $F("makeCd"),
					carCompanyCd: $F("carCompanyCd")
				},
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
	
	function deleteRec(){
		changeTagFunc = saveGIISS103;
		selectedRow.recordStatus = -1;
		makeTG.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valAddRec(){
		try{
			var proceed = false;
			if(checkAllRequiredFieldsInDiv("makeFormDiv")){
				for(var i = 0; i < makeTG.geniisysRows.length; i++){
					var row = makeTG.geniisysRows[i];
					
					if(row.recordStatus != -1 && i != rowIndex){
						if(row.makeCd == $F("makeCd") && row.carCompanyCd == $F("carCompanyCd")){
							showMessageBox("Record already exists with the same make_cd and car_company_cd.", "E");
							return;
						}
					}
					if(row.recordStatus == -1 && row.makeCd == $F("makeCd") && row.carCompanyCd == $F("carCompanyCd")){
						proceed = true;
					}
				}
				if(proceed){
					addRec();
					return;
				}
				
				//if($F("btnAdd") == "Add") { // andrew - 08052015 - SR 19241
					new Ajax.Request(contextPath + "/GIISMcMakeController", {
						parameters: {
							action: "valAddRec",
							makeCd: $F("makeCd"),
							carCompanyCd: $F("carCompanyCd"),
							make: $F("make"),
							sublineCd: $F("sublineCd"),
							noOfPass : $F("noOfPass"),
							valAction : $F("btnAdd").toUpperCase() 
						},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addRec();
							}
						}
					});
				/* andrew - 08052015 - SR 19241 
				} else {
					if(selectedRow.make != $F("make")){
						new Ajax.Request(contextPath + "/GIISMcMakeController", {
							parameters: {
								action: "valAddRec",
								make: selectedRow.make
							},
							onCreate : showNotice("Processing, please wait..."),
							onComplete : function(response){
								hideNotice();
								if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
									addRec();
								}else{
									$("make").value = selectedRow.make;
								}
							}
						});
					}else{
						addRec();
					}
				} */
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGIISS103;
			var row = setRec(selectedRow);
			
			if($F("btnAdd") == "Add"){
				makeTG.addBottomRow(row);
			} else {
				makeTG.updateVisibleRowOnly(row, rowIndex, false);
			}
			
			changeTag = 1;
			setFieldValues(null);
			makeTG.keys.removeFocus(makeTG.keys._nCurrentFocus, true);
			makeTG.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}
	
	function saveGIISS103(){
		var setRows = getAddedAndModifiedJSONObjects(makeTG.geniisysRows);
		var delRows = getDeletedJSONObjects(makeTG.geniisysRows);
		
		new Ajax.Request(contextPath+"/GIISMcMakeController", {
			method: "POST",
			parameters: {
				action: "saveGIISS103",
				setRows: prepareJsonAsParameter(setRows),
				delRows: prepareJsonAsParameter(delRows)
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS103.exitPage != null) {
							objGIISS103.exitPage();
						} else {
							makeTG._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	function exitPage(){
		if(nvl(objUWGlobal.callingForm, "") == "GIPIS010"){
			objUWGlobal.callingForm = "";
			$("parInfoMenu").show();
			showItemInfoTG();
		}else{
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}
	
	function cancelGIISS103(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
				function(){
					objGIISS103.exitPage = exitPage;
					saveGIISS103();
				}, exitPage, "");
		} else {
			exitPage();
		}
	}
	
	function showEngineSeries(){
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			engineOverlay = Overlay.show(contextPath+"/GIISMcMakeController", {
				urlParameters: {
					action: "showEngineOverlay",
					makeCd: $F("makeCd"),
					make: $F("make"),
					carCompanyCd: $F("carCompanyCd"),
					carCompany: $F("carCompany")
				},
				urlContent : true,
				draggable: true,
			    title: "Engine Series",
			    height: 495,
			    width: 650
			});
		}
	}
	
	function showSublineLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {
				action: "getGIISS103SublineLov",
				filterText: $F("sublineCd") != $("sublineCd").getAttribute("lastValidValue") ? nvl($F("sublineCd"), "%") : "%"
			},
			title: "List of Sublines",
			width: 395,
			height: 386,
			columnModel:[
							{	id: "sublineCd",
								title: "Code",
								width: "100px"
							},
							{	id: "sublineName",
								title: "Subline",
								width: "280px"
							}
						],
			draggable: true,
			showNotice: true,
			autoSelectOneRecord : true,
			filterText: $F("sublineCd") != $("sublineCd").getAttribute("lastValidValue") ? nvl($F("sublineCd"), "%") : "%",
		    noticeMessage: "Getting list, please wait...",
			onSelect : function(row){
				if(row != undefined) {
					$("sublineCd").value = unescapeHTML2(row.sublineCd);
					$("sublineName").value = unescapeHTML2(row.sublineName);
					$("sublineCd").setAttribute("lastValidValue", unescapeHTML2(row.sublineCd));
				}
			},
			onCancel: function(){
				$("sublineCd").value = $("sublineCd").getAttribute("lastValidValue");
			},
			onUndefinedRow: function(){
				showMessageBox("No record selected.", "I");
				$("sublineCd").value = $("sublineCd").getAttribute("lastValidValue");
			},
			onShow: function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		});
	}
	
	function showCompanyLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {
				action: "getGIISS103CompanyLov",
				filterText: $F("carCompanyCd") != $("carCompanyCd").getAttribute("lastValidValue") ? nvl($F("carCompanyCd"), "%") : "%"
			},
			title: "List of Car Companies",
			width: 395,
			height: 386,
			columnModel:[
							{	id: "carCompanyCd",
								title: "Code",
								width: "100px",
								align: 'right',
								titleAlign: 'right'
							},
							{	id: "carCompany",
								title: "Car Company",
								width: "280px"
							}
						],
			draggable: true,
			showNotice: true,
			autoSelectOneRecord : true,
			filterText: $F("carCompanyCd") != $("carCompanyCd").getAttribute("lastValidValue") ? nvl($F("carCompanyCd"), "%") : "%",
		    noticeMessage: "Getting list, please wait...",
			onSelect : function(row){
				if(row != undefined) {
					$("carCompanyCd").value = row.carCompanyCd;
					$("carCompany").value = unescapeHTML2(row.carCompany);
					$("carCompanyCd").setAttribute("lastValidValue", row.carCompanyCd);
				}
			},
			onCancel: function(){
				$("carCompanyCd").value = $("carCompanyCd").getAttribute("lastValidValue");
			},
			onUndefinedRow: function(){
				showMessageBox("No record selected.", "I");
				$("carCompanyCd").value = $("carCompanyCd").getAttribute("lastValidValue");
			},
			onShow: function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		});
	}
	
	$w("makeCd noOfPass sublineCd carCompanyCd").each(function(e){
		$(e).observe("focus", function(){
			$(e).setAttribute("lastValidValue", $F(e));
		});
	});
	
	$("noOfPass").observe("change", function(){
		if($F("noOfPass") != "" && (isNaN($F("noOfPass")) || parseInt($F("noOfPass")) < 1  || $F("noOfPass").include("."))){
			showWaitingMessageBox("Invalid No. of Pass. Valid value should be from 1 to 999.", "E", function(){
				$("noOfPass").value = $("noOfPass").getAttribute("lastValidValue");
			});
		}
	});
	
	$("sublineCd").observe("change", function(){
		if($F("sublineCd") == ""){
			$("sublineCd").setAttribute("lastValidValue", "");
			$("sublineName").value = "";
		}else{
			showSublineLOV();
		}
	});
	
	$("carCompanyCd").observe("change", function(){
		if($F("carCompanyCd") == ""){
			$("carCompanyCd").setAttribute("lastValidValue", "");
			$("carCompany").value = "";
		}else if(isNaN($F("carCompanyCd")) || parseInt($F("carCompanyCd")) < 1 || $F("carCompanyCd").include(".")){
			showWaitingMessageBox("Invalid Car Company Code. Valid value should be from 1 to 999999.", "E", function(){
				$("carCompanyCd").value = $("carCompanyCd").getAttribute("lastValidValue");
			});
		}else{
			showCompanyLOV();
		}
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("remarks", 4000, $("remarks").hasAttribute("readonly"));
	});
	
	$("btnExit").stopObserving("click");
	$("btnExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$("searchSubline").observe("click", showSublineLOV);
	$("searchCarCompany").observe("click", showCompanyLOV);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	$("btnEngine").observe("click", showEngineSeries);
	$("btnCancel").observe("click", cancelGIISS103);
	
	observeSaveForm("btnSave", saveGIISS103);
	observeReloadForm("reloadForm", showGIISS103);
	newFormInstance();
</script>