<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="spoilORMainDiv" style="margin-bottom: 50px; float: left; width: 100%;">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Spoil Official Receipt</label>
	   		<span class="refreshers" style="margin-top: 0;">
	   			<label id="lblShowSpoilOR" name="gro" style="margin-left: 5px;">Hide</label>
	   			<label id="lblReloadForm" name="reloadForm">Reload Form</label>
	   		</span>
	   	</div>
	</div>	
	<div id="spoilORHeaderDiv" style="float: left; width: 100%">
		<div id="headerDtlsDiv" class="sectionDiv" style="float: left;" align="center">
			<table style="margin: 10px;">
				<tr>
					<td class="rightAligned">Company</td>
					<td class="leftAligned"><input type="text" id="companyName" name="companyName" style="float: left; margin-left: 5px; width: 300px;" readonly="readonly" value="${branchDetails.gfunFundCd} - ${branchDetails.fundDesc}" /></td>
					<td class="rightAligned" width="80px;">Branch</td>
					<td class="leftAligned">
						<div style="margin-left: 9px; border: 1px solid gray; width: 300px; height: 19px; float: left;">
							<input type="text" id="branchName" name="branchName" style="border: none; padding: 1px 0 0 2px; float: left; width: 278px;" readonly="readonly" value="${branchDetails.branchCd} - ${branchDetails.branchName}" /> 
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranch" name="searchBranch" alt="Go" />
						</div>
				</tr>
			</table>
		</div>
		<div id="spoilOrListMainDiv" class="sectionDiv" style="float: left; padding-bottom: 10px; width: 100%;">
			<div id="spoilORTableDiv" style="padding: 20px 0 10px 0; margin-left: 140px;">
				<div id="spoilORTable" style="width: 670px; height: 335px"></div>
			</div>
			<div>
				<input type="button" class="button" id="btnReinstateOR" value="Reinstate OR">
				<input type="button" class="button" id="btnPrint" value="Print" style="width: 97px;">
			</div>
		</div>
	</div>
	<div id="buttonsDiv" class="buttonsDiv">		
		<input type="button" class="button" id="btnCancel" value="Cancel">
		<input type="button" class="button" id="btnSave" value="Save">
	</div>	
</div>
<script>
	objACGlobal.fundCd = "${branchDetails.gfunFundCd}";
	objACGlobal.branchCd = "${branchDetails.branchCd}";
	objAC.yValue = "";
	objAC.editedDate = "";
	setModuleId("GIACS037");
	setDocumentTitle("Spoil Official Receipt");
	initializeAccordion();
	initializeReinstateVars();

	objAC.modifiedRows = null;
	objAC.addedRows = null;
	objAC.dateToday = new Date();
	var delAccess = '${deleteAccess}';
	var loopCtr = 0;

	if (delAccess == 'FALSE'){
		disableButton("btnReinstateOR");
	}
	
	function saveSpoiledOrDtls(){
		try {
			if (validateEntries()) {
				new Ajax.Request(contextPath + "/GIACSpoiledOrController?action=saveSpoiledOrDtls", {
					method: "POST",
					parameters: {
						parameter: prepareParameters()
					} ,
					evalScripts: true,
					asynchronous: false,
					onComplete: function (response){
						var result = response.responseText;
						if (result == "SUCCESS") {
							showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
							changeTag = 0;
						}
					}
				});
			}else {
				showMessageBox("Please complete required fields.", imgMessage.ERROR);
			}
		}catch (e){
			showErrorMessage("saveSpoiledOrDtls", e);
		}
	}

	function prepareParameters(){
		var modifiedSpoiledOrDtls	= getAddedModifiedJSONObject(objAC.modifiedRows);
		var addedSpoiledOrDtls = getAddedModifiedJSONObject(objAC.addedRows);
		
		var objParameters = new Object();
		objParameters.addedSpoiledOr = addedSpoiledOrDtls;
		objParameters.modifiedSpoiledOr = modifiedSpoiledOrDtls;

		return JSON.stringify(objParameters);
	}

	function getAddedModifiedJSONObject(obj){
		var tempObjArray = new Array();
		if (obj != null) {
			for(var i=0; i<obj.length; i++) {	
				if (tbgSpoilOR.geniisysRows[obj[i].divCtrId] != null) {
					if (obj[i].divCtrId == tbgSpoilOR.geniisysRows[obj[i].divCtrId].divCtrId) {
						obj[i].origOrNo = tbgSpoilOR.geniisysRows[obj[i].divCtrId].orNo;
						obj[i].origOrPref = tbgSpoilOR.geniisysRows[obj[i].divCtrId].orPref;
					}
				}else {	
					obj[i].origOrNo = null;
					obj[i].origOrPref = null;
					obj[i].fundCd = objACGlobal.fundCd;
					obj[i].branchCd = objACGlobal.branchCd;
					obj[i].spoilTag = 'M';
				}
				tempObjArray.push(obj[i]);
			}
		}
		
		return tempObjArray;
	}

	var objGIACSpoiledOr = JSON.parse('${spoiledOrListing}'.replace(/\\/g, "\\\\"));
	var spoilORTable = {
			url: contextPath+"/GIACSpoiledOrController?action=refreshSpoiledOR&fundCd="+objACGlobal.fundCd+"&branchCd="+objACGlobal.branchCd,
			options: {
				hideColumnChildTitle: true,
				width: '660px',
				pager: {
				},
				toolbar: {
					elements: [MyTableGrid.ADD_BTN, MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onAdd: function(){
						tbgSpoilOR.keys.releaseKeys();
					},
					onEdit: function(){
						tbgSpoilOR.keys.releaseKeys();
					}
				},
				onCellFocus : function(element, value, x, y, id) {
					var spoilTag = tbgSpoilOR.getRow(y).spoilTag;
					loopCtr = 0;
					objAC.yValue = y;
					objAC.prevTranId = tbgSpoilOR.getRow(y).tranId;
					objAC.orPref = tbgSpoilOR.getRow(y).orPref;
					objAC.orNo = tbgSpoilOR.getRow(y).orNo;
					objAC.fundCd = tbgSpoilOR.getRow(y).fundCd;
					objAC.branchCd = tbgSpoilOR.getRow(y).branchCd;
					objAC.spoilDate = tbgSpoilOR.getRow(y).spoilDate;
					objAC.prevOrDate = tbgSpoilOR.getRow(y).orDate;
					objAC.origOrPref = tbgSpoilOR.getRow(y).origOrPref;
					objAC.origOrNo = tbgSpoilOR.getRow(y).origOrNo;
					
					if (spoilTag == 'M') {
						$("mtgIC" + this._mtgId + '_' + x +','+y).setAttribute("editableDiv", "true");
					}else if (spoilTag == 'S') {
						$("mtgIC" + this._mtgId + '_' + x +','+y).setAttribute("editableDiv", "false");
					}else if (spoilTag == null){
						//tbgSpoilOR.getRow(y).spoilTag = "M";
					}
				},
				onCellBlur: function (element, value, x, y, id) {
					objAC.modifiedRows = tbgSpoilOR.getModifiedRows();
					objAC.addedRows = tbgSpoilOR.getNewRowsAdded();
					if (objAC.modifiedRows.length > 0 || objAC.addedRows.length > 0) {
						changeTag = 1;
						if (tbgSpoilOR.getRow(y).orPref != "" && tbgSpoilOR.getRow(y).orNo != ""){
							if (tbgSpoilOR.geniisysRows[y] != null){
								if  (tbgSpoilOR.geniisysRows[y].origOrPref != tbgSpoilOR.getRow(y).orPref || tbgSpoilOR.geniisysRows[y].origOrNo != tbgSpoilOR.getRow(y).orNo){
									validateSpoiledOr(y);
								}
							}else {
								validateSpoiledOr(y);
							}
						}
					}
					loopCtr = loopCtr + 1;
					if (loopCtr < 2){
						fireEvent($("mtgIC1_11," + y), "click");
					}
				},	
				rowPostQuery: function (y) {	
					setOrigKeys();
				}	
			},								
			columnModel: [
				{
				    id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false
				},
				{
					id: 'divCtrId',
					width: '0',
					visible: false 
				},
				{
					id: 'spoilTag',
					width: '0',
					visible: false 
				},
				{
					id: 'tranId',
					width: '0',
					visible: false 
				},
				{
					id: 'fundCd',
					width: '0',
					visible: false 
				},
				{
					id: 'branchCd',
					width: '0',
					visible: false 
				},
				{
					id: 'origOrNo',
					width: '0',
					visible: false 
				},
				{
					id: 'origOrPref',
					width: '0',
					visible: false 
				},
				{	id: 'orPref orNo',
					title: 'O.R. Number',
					children : 
					[
						{			
							id : "orPref",
							title: "OR Pref Suf",
							width: 70,
							filterOption: true,
							editable: true,
							align: 'right',
							editor: new MyTableGrid.CellInput({
								validate: function(value, input) {
									setColumnValues();
									return true;
								}
							})
						},
						{
						id : "orNo",
						title: "OR Number",
						width: 92,
						filterOption: true,
						editable: true,
						align: 'right',
						editor: new MyTableGrid.CellInput({
							validate: function(value, input) {
								setColumnValues(value);
								return true;
							}
						})
						}
					]
				},	
				{
					id : "orDate",
					title: "O.R. Date",
					width: '120px',
					filterOption: true,
					editable: true,
					editor: new MyTableGrid.CellInput({
						validate: function(value, input) {
						var inputDate = Date.parse(value);
						var coords = tbgSpoilOR.getCurrentPosition();
	                    var x = coords[0]*1;
	                    var y = coords[1]*1;
							if (inputDate != null){
			                    tbgSpoilOR.setValueAt(inputDate.format("mm-dd-yyyy"), tbgSpoilOR.getColumnIndex('orDate'), y);
			                    setColumnValues();
			                    return true;
							}else if (inputDate == null && tbgSpoilOR.getRow(y).orDate != ""){
								showMessageBox("Date must be entered in a format like MM-DD-RRRR.", imgMessage.INFO);
								tbgSpoilOR.setValueAt("", tbgSpoilOR.getColumnIndex('orDate'), y);
								return false;
							}
						}
					})
				},
				{	
					id : "spoilDate",
					title: "Spoil Date",
					width: '170px'
				},
				{	
					id : "spoilTagDesc",
					title: "Spoil Tag",
					width: '180px'
				}
			],
			rows: objGIACSpoiledOr.rows
		};

	tbgSpoilOR = new MyTableGrid(spoilORTable);
	tbgSpoilOR.pager = objGIACSpoiledOr;
	tbgSpoilOR.render('spoilORTable');

	function validateSpoiledOr(y){
	    new Ajax.Request(contextPath + "/GIACSpoiledOrController?action=validateSpoiledOr",  {
	        method: "POST",
	        parameters: {
	        	orPref: tbgSpoilOR.getRow(y).orPref,
	            orNo: tbgSpoilOR.getRow(y).orNo,
	            fundCd: objACGlobal.fundCd,
	            branchCd:  objACGlobal.branchCd    
	    	},
	    	asynchronous: false,
	    	evalScripts: true,
	    	onComplete: function (response){
	        	var result = response.responseText;
	        	if (result.length > 0) {
	        		tbgSpoilOR.setValueAt("", tbgSpoilOR.getColumnIndex('orNo'), y);
					showMessageBox(result, imgMessage.ERROR);				
				}
	    	}
	    	
	    });
	}
	
	function setColumnValues(){
		var coords = tbgSpoilOR.getCurrentPosition();
        var y = coords[1]*1;
        if (y < 0) {
			tbgSpoilOR.setValueAt(objAC.dateToday.format("mm-dd-yyyy hh:MM:ss TT"), tbgSpoilOR.getColumnIndex('spoilDate'), y);
			tbgSpoilOR.setValueAt("M - MANUALLY SPOILED", tbgSpoilOR.getColumnIndex('spoilTagDesc'), y);
        }
	}
	
	function reinstateOr(){
		new Ajax.Request(contextPath + "/GIACSpoiledOrController?action=reinstateOr", {
			method: "POST",
			parameters: {
				orPref: objAC.orPref,
				orNo:	objAC.orNo,
				fundCd: objAC.fundCd,
				branchCd: objAC.branchCd,
				spoilDate: objAC.spoilDate,
				prevOrDate: objAC.prevOrDate,
				prevTranId: objAC.prevTranId,
				moduleId: "GIACS037"
			},
			evalScripts: true,
			asynchronous: false,
			onComplete: function (response) {
				var result = response.responseText;
				if (result.length > 0) {
					showMessageBox(result, imgMessage.ERROR);
				}else{
					showMessageBox("SUCCESS", imgMessage.SUCCESS);
					fireEvent($("mtgRefreshBtn1"), "click");
				}
			}
		});
	}

	function initializeReinstateVars(){
		objAC.orPref = "";
		objAC.orNo = "";
		objAC.fundCd = "";
		objAC.branchCd = "";
		objAC.spoilDate = "";
		objAC.prevOrDate = "";
		objAC.prevTranId = "";
	}

	function setOrigKeys(){
		for (var i=0; i<tbgSpoilOR.geniisysRows.length; i++){
			tbgSpoilOR.geniisysRows[i].origOrPref = tbgSpoilOR.geniisysRows[i].orPref;
			tbgSpoilOR.geniisysRows[i].origOrNo = tbgSpoilOR.geniisysRows[i].orNo;
		}
	}

	function validateEntries(){
		var isValid = false;
		if (objAC.modifiedRows != null) {
			if (objAC.modifiedRows.length > 0) {
				isValid = true;
				for (var i=0; i<objAC.modifiedRows.length; i++){
					if (objAC.modifiedRows[i].orPref == "") {
						isValid = false;
					}else if (objAC.modifiedRows[i].orNo == "") {
						isValid = false;
					}
				}
			}
		}
		if (objAC.addedRows != null) {
			if (objAC.addedRows.length > 0) {
				isValid = true;
				for (var i=0; i<objAC.addedRows.length; i++){
					if (objAC.addedRows[i].orPref == "") {
						isValid = false;
					}else if (objAC.addedRows[i].orNo == "") {
						isValid = false;
					}
				}
			}
		}
		return isValid;
	}

	/////////////////////OBSERVE ITEMS//////////////////////////////
	
	$("btnSave").observe("click", function () {
		if(changeTag == 0){showMessageBox(objCommonMessage.NO_CHANGES ,imgMessage.INFO); return;}
		if (validateEntries()) {
			saveSpoiledOrDtls();
		}else {
			showMessageBox("Please complete required fields.", imgMessage.ERROR);
		}
	});
	
	$("btnReinstateOR").observe("click", function () {
		showConfirmBox("Confirm O.R reinstatement", "Are you sure you want to reinstate " + objAC.orPref + "- " + parseInt(objAC.orNo).toPaddedString(10) + "?", "Yes", "No", reinstateOr, "");
	});

	$("btnPrint").observe("click", function() {
		showOverlayContent2(contextPath+"/GIACSpoiledOrController?action=printReinstated", "Print Spoiled O.R", 380, "");
	});
	
	$("lblReloadForm").observe("click", function(){
		showEnterSpoiledOR();
	});
	
	$("btnCancel").observe("click", function () {
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});

	function onSelectBranch(row){
		$("branchName").value = row.branchCd +" - "+ row.branchName;
		objACGlobal.branchCd = row.branchCd;
		refreshSpoilOrListing();
	}
	
	$("searchBranch").observe("click", function(){
		showGIACBranchLOV(onSelectBranch);		
	}); 

	initializeChangeTagBehavior(saveSpoiledOrDtls); 
</script>