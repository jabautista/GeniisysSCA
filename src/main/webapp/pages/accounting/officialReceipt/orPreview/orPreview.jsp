<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>
<div class="sectionDiv" style="border-top: none;" id="orPreviewMainDiv" name="orPreviewMainDiv">	
	<div id="mytable1" style="position:relative; height: 350px; margin: 10px; margin-top: 0px;"></div>
	<div id="totalDiv" style="width:100%; float:right;">
		<table border="0" align="right">
			<tr>
				<td class="leftAligned">Print Tag Total: </td>
				<td class="leftAligned">
					<input type="text" id="printTotal" name="printTotal" readonly="readonly" class="money"/>
					<input type="text" id="itemTotal" name="itemTotal" readonly="readonly" class="money"/>
					<input type="text" id="fcTotal" name="fcTotal" readonly="readonly" class="money"/>
				</td>
			</tr>
			<tr>
				<td class="leftAligned">Difference: </td>
				<td class="leftAligned">
					<input type="text" id="diffTotal" name="diffTotal" readonly="readonly" class="money"/>
				</td>
			</tr>
		</table>
	</div>
	<div id="infoDiv" name="infoDiv" style="float: right; margin: 10px 180px 10px 0px;">
		<table>
			<tr>
				<td align="right">Item No.</td>
				<td><input id="itemNo" name="itemNo" type="text" class="required" style="margin-right: 50px; width: 150px;" maxlength="5" tabindex="101"></td>
				<td align="right">Bill No.</td>
				<td><input id="billNo" name="billNo" type="text" maxlength="20" tabindex="105" style="width: 150px;"></td>
			</tr>
			<tr>
				<td align="right">Generation Type</td>
				<td><input id="generationType" name="generationType" type="text" style="margin-right: 50px; width: 150px;" readonly="readonly" tabindex="102"></td>
				<td align="right">Local Currency Amount</td>
				<td><input id="locCurAmt" name="locCurAmt" type="text" class="required money" style="text-align: right; width: 150px;" maxlength="16" tabindex="106"></td><!-- added maxlength property to limit amount to be inputted in the field by MAC 06/07/2013 -->
			</tr>
			<tr>
				<td align="right">Line</td>
				<td><input id="line" name="line" class="leftAligned upper" type="text" style="margin-right: 50px; width: 150px;" maxlength="2" tabindex="103"></td>
				<td align="right">Currency</td>
				<td><input id="currency" name="currency" type="text" readonly="readonly" tabindex="107" style="width: 150px;"></td>
			</tr>
			<tr>
				<td align="right">Col No.</td>
				<td><input id="colNo" name="colNo" type="text" style="margin-right: 50px; width: 150px;" maxlength="1" tabindex="104"></td>
				<td align="right">Foreign Currency Amount</td>
				<td><input id="forCurAmt" name="forCurAmt" class="required money" type="text" style="text-align: right; width: 150px;" maxlength="16" tabindex="108"></td> <!-- added maxlength property to limit amount to be inputted in the field by MAC 06/07/2013 -->
			</tr>
			<tr>
				<td align="right">Particulars</td>
				<td colspan="3">
					<div id="particularsDiv" style="border: 1px solid gray; height: 20px; width: 525px;" class="required">
						<textarea id="particulars" name="particulars" style="width: 495px; border: none; height: 13px; margin: 0px; resize: none;" maxlength="500" class="required" tabindex="109"/></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="viewParticulars" />
					</div>
				</td>
			</tr>
		</table>
	</div>
	<div id="infoButtonsDiv" class="buttonsDiv" style="margin: 0 0 15px 0;">
		<input id="btnAdd" name="btnAdd" type="button" class="button" value="Add">
		<input id="btnDelete" name="btnDelete" type="button" class="disabledButton" value="Delete">
	</div>
</div>
<div class="buttonsDiv" style="float:left; width: 100%;">	
	<input type="button" id="btnClearORPreview" name="btnClearORPreview" class="button" value="Clear All Item Nos." />
	<input type="button" id="btnRegenerateORPreview" name="btnRegenerateORPreview"	class="button" value="Regenerate Numbers" />
	<input type="button" id="btnGenParticularsORPreview" name="btnGenParticularsORPreview"	class="button" value="Generate Particulars" />
	<input type="button" id="btnPrintORPreview" name="btnPrintORPreview" class="button" value="Print OR" />
	<input id="btnCancel" name="btnCancel" type="button" class="button" value="Cancel">
	<input id="btnSave" name="btnSave" type="button" class="button" value="Save">
</div> 
<script type="text/javascript">
try{
	objAC.hidObjGIACS025 = {};
	objAC.objORPreviewGIACS025TableGrid = JSON.parse('${giacOpTextTableGrid}'.replace(/\\/g, '\\\\').replace(/\n/g, '\\n'));//added .replace(/\n/g, '\\n') by reymon 10112013
	objAC.objORPreviewGIACS025 = objAC.objORPreviewGIACS025TableGrid.rows || [];
	objAC.hidObjGIACS025.variables = JSON.parse('${variables}'.replace(/\\/g, '\\\\')); 
	objAC.hidObjGIACS025.variables.itemGenType = 'X'; //Nok 04.25.2011 hardcoded nalang daw ito lage.. (objAC.hidObjGIACS025.variables.itemGenType==null?"":objAC.hidObjGIACS025.variables.itemGenType);	            

	setModuleId("GIACS025");
	setDocumentTitle("OR Preview");
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	initializeAccordion();
	makeInputFieldUpperCase();
	hideNotice("");
	
	var access = 1;
	var selectedIndex = -1;
	var objOrPreview = [];
	var exactDiff = 0;
	var printSeqNoList = JSON.parse('${printSeqNoList}');
	var itemSeqNoList = JSON.parse('${itemSeqNoList}');
	var opTextAdjusted = 0;
	//store old value of Local and Foreign Currency by MAC 06/07/2013.
	var oldLocCurAmt;
	var oldForCurAmt;
	
	
	var tableModel = {
		url: contextPath+"/GIACOpTextController?action=refreshORPreview&globalGaccTranId="+objACGlobal.gaccTranId+"&globalGaccBranchCd="+objACGlobal.branchCd+"&globalGaccFundCd="+objACGlobal.fundCd,
		options : {
			querySort: false,				// to sort using existing rows
			addSettingBehavior: false,     	// disable|remove setting icon button
			addDraggingBehavior: false,    	// disable dragging behavior
			pager: { //dummy pagination
				total: 55,
				pages: 5,
				currentPage: 1,
				from: 1,
				to: 10
			},
			postPager: function(){
				computeAllTotal();
			},	
			onCellFocus : function(element, value, x, y, id) {
				//orTableGrid.keys.releaseKeys();
				selectedIndex = y;
				orTableGrid.keys.releaseKeys(); //added releaseKeys function to allow tabbing to other fields by MAC 06/10/2013.
				populateInfo(y, "pop");
				computeAllTotal();
			},
			onRemoveRowFocus : function(){
				selectedIndex = -1;
				orTableGrid.keys.releaseKeys();
				populateInfo(1, "clear");	
				access == 1 ? populateDefaultInfo() : disableInfoFields();
			},
			onCellBlur : function(element, value, x, y, id) {
				//marco - 02.25.2015 - added to update print tag
				orTableGrid.geniisysRows[y].orPrintTag = $("mtgInput"+orTableGrid._mtgId+"_3,"+y).checked ? "Y" : "N";
				objOrPreview[y].orPrintTag = orTableGrid.geniisysRows[y].orPrintTag;
				objOrPreview[y].recordStatus = 1;
				changeTag = 1;
				
				computeAllTotal();
				orTableGrid.keys.releaseKeys();
			},
			onSort: function(){
				populateInfo(1, "clear");	
				access == 1 ? populateDefaultInfo() : null;
				//orTableGrid.keys.releaseKeys();
			},
			toolbar : {
				elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
				onSave: function() {
					var ok = true;
				 	var addedRows 	 = orTableGrid.getNewRowsAdded();
					var modifiedRows = orTableGrid.getModifiedRows();
					var delRows  	 = orTableGrid.getDeletedRows();
					var setRows		 = addedRows.concat(modifiedRows);
					 	
					var objParameters = new Object();
					objParameters.delRows = delRows;
					objParameters.setRows = setRows;
					var strParameters = JSON.stringify(objParameters);
					new Ajax.Request(contextPath+"/GIACOpTextController?action=saveORPreview",{
						method: "POST",
						parameters:{
							globalGaccTranId: objACGlobal.gaccTranId,
							globalGaccBranchCd: objACGlobal.branchCd,
							globalGaccFundCd: objACGlobal.fundCd,
							parameters: strParameters
						},
						asynchronous: false,
						evalScripts: true,
						onCreate: function(){
							showNotice("Saving OR Preview, please wait...");
						},
						onComplete: function(response){
							hideNotice("");
							if(checkErrorOnResponse(response)) {
								if (response.responseText == "SUCCESS"){
									ok = true;
								}
							}else{
								showMessageBox(response.responseText, imgMessage.ERROR);
								ok = false;
							}
						}	 
					});	
					return ok; 	
				},
				postSave: function(){
					hideNotice("");
					orTableGrid.clear();   //to reset the status (useful after performing a save operation)
					orTableGrid.refresh(); //to refresh the table rows (useful after performing a save operation)
					orTableGrid.keys.releaseKeys();
					whenNewFormIns();
					enableDisableParticulars();
					computeAllTotal();
					showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
				},
				onRefresh: function (){
					//computeAllTotal();
					populateInfo(1, "clear");				
					access == 1 ? populateDefaultInfo() : null;
					orTableGrid.keys.releaseKeys();
				},
				onFilter: function(){
					computeAllTotal();
					populateInfo(1, "clear");	
					access == 1 ? populateDefaultInfo() : null;
					orTableGrid.keys.releaseKeys();
				}
			}
		}, 
		
		columnModel : [
			{
				id: 'recordStatus',
				width: '0',
				visible: false
			},
			{
				id: 'divCtrId',
				width: '0',
				visible: false 
			},
			{
				id: 'gaccTranId',
				width: '0',
				visible: false,
				defaultValue: objACGlobal.gaccTranId // for adding only
			},
	        {
	            id: 'orPrintTag',
	            title: 'P',
	            altTitle: 'Print Tag',
	            width: '25px',
	            editable: (objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C"  || objACGlobal.queryOnly == "Y" ? false : true),
	            //changed defaultvalue true to Y - christian 04/10/2013
	            defaultValue: "Y",		//if editor has 'getValueOf' property it will get the default value from getValueOf condition, for newly added row
	            otherValue: "Y",		//for check box mapping of other values
	            editor: new MyTableGrid.CellCheckbox({
		            getValueOf: function(value){
	            		if (value){
							return "Y";
	            		}else{
							return "N";	
	            		}	
	            	},
	            	onClick: function(value, checked) {
						fireEvent($("btnAdd"), "click");
	            	}
	            })
	        },
	        {
	            id: 'printSeqNo',
	            title: 'Item No.',
	            type: 'number',
	            align: 'left',
	            width: '60px',
	            sortable: true,
	            geniisysClass: 'integerNoNegativeUnformattedNoComma',
	            filterOption: true,
	            filterOptionType: 'integerNoNegative'
	        },
	        {
	            id: 'itemGenType',
	            title: 'Gen',
	            width: '50px',
				filterOption: true
	        },
	        {
	            id: 'line',
	            title: 'Line',
	            width: '50px',
	            filterOption: true
	        },
	        {
	            id: 'itemText',
	            title: 'Particulars',
	            width: '180px',
	            filterOption: true
	        },
	        {
	            id: 'columnNo', 
	            title: 'Col #',
	            width: '45px',
	            geniisysClass: 'integerNoNegativeUnformattedNoComma',
	            filterOption: true,
	            filterOptionType: 'integerNoNegative'
	        },
	        {
	            id: 'billNo',
	            title: 'Bill No.',
	            width: '116px',
	            filterOption: true
	        },
	        {
	            id: 'itemAmt',
	            title: 'Local Currency',
	            type : 'number',
	            width : '120px',
	            geniisysClass : 'money',     //added geniisysClass properties by Jerome Orio
	            filterOption: true,
	            filterOptionType: 'number'
	        },
	        {	
	            id: 'dspCurrSname',
	            title: 'Currency',
	            width: '65px',
	            defaultValue: objAC.hidObjGIACS025.variables.currSname,
	            filterOption: true
	        },
	        {
	            id: 'foreignCurrAmt',
	            title: 'Foreign Currency Amount',
	            type: 'number',
	            width: '150px',
	            geniisysClass: 'money',
	            filterOption: true,
	            filterOptionType: 'number'
	        },
		    {
				id: 'itemSeqNo',
				width: "0",
				visible: false 
		    },  
		    {
				id: 'currencyCd',
				width: "0",
				visible: false,
				defaultValue: objAC.hidObjGIACS025.variables.currCd 
		    },   
		    {
				id: 'cpiRecNo',
				width: "0",
				visible: false 
		    },
		    {
				id: 'cpiBranchCd',
				width: "0",
				visible: false 
		    },
	        {
				id: 'userId',
				width: "0",
				visible: false 
		    },
		    {
				id: 'lastUpdate',
				width: "0",
				visible: false
		    }
	    ],
	    rows : objAC.objORPreviewGIACS025
	};
	orTableGrid = new MyTableGrid(tableModel);
	orTableGrid.pager = objAC.objORPreviewGIACS025TableGrid; //to update pager section
	orTableGrid.render('mytable1');  // 'mytable1' div id that will contain the table grid
	orTableGrid.afterRender = function(){
		objOrPreview = orTableGrid.geniisysRows;
		access == 1 ? populateDefaultInfo() : null;
		computeTotalsOnLoad();
	};
	
	function populateDefaultInfo(){
		/* var printSeqNo = 1;
		if(orTableGrid.pager.total > 0){
			for(var i = 0; i < objOrPreview.length; i++){
				$("itemNo").value = objOrPreview[i].printSeqNo > printSeqNo ? parseInt(objOrPreview[i].printSeqNo)+1 : printSeqNo;
			}
		}else{
			$("itemNo").value = 1;
		} */
		var printSeqNo = 0;
		if(printSeqNoList.length > 0){
			printSeqNo = Math.max.apply(Math, printSeqNoList);
		}
		$("itemNo").value = printSeqNo + 1;
		
		$("generationType").value = objAC.hidObjGIACS025.variables.itemGenType;
		$("currency").value = objAC.hidObjGIACS025.variables.currSname;
	}
	
	enableButton('btnPrintORPreview');
	enableButton('btnClearORPreview');
	enableButton('btnGenParticularsORPreview');
	disableButton('btnRegenerateORPreview');
	
	function enableDisableParticulars(){
		//var count = orTableGrid.geniisysRows.length; //marco - 11.02.2014 - replaced with line below
		var count = orTableGrid.geniisysRows.filter(function(row){return nvl(row.recordStatus, 0) != -1;}).length;
		if (count > 0){
			var exist = false;
			for(var i=0; i<orTableGrid.geniisysRows.length; i++){
				if (orTableGrid.geniisysRows[i].itemGenType == objAC.hidObjGIACS025.variables.itemGenTypeGiacs001 && orTableGrid.geniisysRows[i].recordStatus != -1){
					enableButton('btnGenParticularsORPreview');
					$('btnGenParticularsORPreview').value = 'Regenerate Particulars';
					exist = true;
					$break;
				}	
			}	
			if (!exist){
				disableButton('btnGenParticularsORPreview');
				$('btnGenParticularsORPreview').value = 'Generate Particulars';
			}	
		}else{
			enableButton('btnGenParticularsORPreview');
			$('btnGenParticularsORPreview').value = 'Generate Particulars';
		}		
	}
	
	function whenNewFormIns(){	
		if (objAC.hidObjGIACS025.variables.defCurrCd == null || objAC.hidObjGIACS025.variables.defCurrCd == ""){
			showMessageBox('Currency code not found in giac_parameters.' ,imgMessage.ERROR);
			disableInfoButtons();
		}

		if (objAC.hidObjGIACS025.variables.currCd == null || objAC.hidObjGIACS025.variables.currCd == ""){
			showMessageBox('Insert not allowed. Enter collection details first.' ,imgMessage.ERROR);
			disableButton('btnPrintORPreview');
			disableButton('btnClearORPreview');
			disableInfoButtons();
		}else{
			if (objAC.hidObjGIACS025.variables.currSname == null || objAC.hidObjGIACS025.variables.currSname == ""){
				showMessageBox('Currency sname not found in giis_currency.' ,imgMessage.ERROR);
				disableInfoButtons();
			}	
		}
		
		if (objAC.hidObjGIACS025.variables.dummy != null){
			disableButton('btnPrintORPreview');
			disableButton('btnClearORPreview');
			//if(objACGlobal.orTag != "*") { // added by andrew - for manual OR
			  if(objACGlobal.orTag == "*") { // edited by gab 11.26.2015
				disableButton('btnGenParticularsORPreview');
			}
			showMessageBox('Alteration of O.R. Preview is not allowed.' ,imgMessage.ERROR);
			disableInfoButtons();
		}else{
			if (objAC.hidObjGIACS025.variables.unprinted != null){
				enableButton('btnPrintORPreview');
				enableButton('btnClearORPreview');
				enableButton('btnGenParticularsORPreview');
				disableButton('btnRegenerateORPreview');
			}	
		}
	}	
	
	function disableInfoButtons(){
		access = 0;
		disableButton($("btnAdd"));
		disableButton($("btnDelete"));
		disableButton($("btnCancel"));
		disableButton($("btnSave"));
		disableInfoFields();
	}
	
	function disableInfoFields(){
		disableInputField($("itemNo"));
		$("generationType").value = "";
		disableInputField($("line"));
		disableInputField($("colNo"));
		disableInputField($("billNo"));
		disableInputField($("locCurAmt"));
		disableInputField($("currency"));
		disableInputField($("forCurAmt"));
		disableInputField($("particulars"));
	}
	
	//when-new-form-instance trigger
	if((objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR") && objAC.tranFlagState != "C"){ // andrew - 08.17.2012 SR 0010292
		enableDisableParticulars();
	}
	whenNewFormIns();
	
	$("btnClearORPreview").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function(){
				checkPrintSeqNo();
				clearOrPreview();
			}, clearTable, "", "");
		}else{
			clearOrPreview();
		}
	});
	
	function clearTable(){
		orTableGrid.refresh();
		clearOrPreview();
	}
	
	function clearOrPreview(){
		var countClearItem = 0;
		for(var i = 0; i < orTableGrid.rows.length; i++){
			if(orTableGrid.geniisysRows[i].recordStatus != -1 && 
				orTableGrid.geniisysRows[i].itemGenType == objAC.hidObjGIACS025.variables.itemGenType){//allow clearing of Print Sequence Number if record is user generated by MAC 06/04/2013.
				for(var c = 0; c < printSeqNoList.length; c++){ //marco - 11.25.2014
					if(printSeqNoList[c] == orTableGrid.geniisysRows[i].printSeqNo){
						printSeqNoList.splice(c, 1);
					}
				}
				orTableGrid.setValueAt("", orTableGrid.getIndexOf('printSeqNo'), i, true);
				orTableGrid.geniisysRows[i].printSeqNo = "";
				countClearItem++;
			}
		}
		//enable Regenerated Numbers and allow saving if at least one record is modified by MAC 06/04/2013.
		if (countClearItem > 0){
			enableButton('btnRegenerateORPreview');
			populateInfo(1, "clear");
			changeTag = 1;
			regenerate = 1;
		}
	}

	//when-window-activated
	if (!$('btnPrintORPreview').hasClassName('disabledButton')){
		enableDisableParticulars();
	}

	function generateParticulars(){
		orTableGrid.unselectRows();
		//orTableGrid.deleteAnyRows('itemGenType', objAC.hidObjGIACS025.variables.itemGenTypeGiacs001); comment out by MAC 05/30/2013.

		new Ajax.Request(contextPath+"/GIACOpTextController?action=generateParticulars",{
			method: "POST",
			parameters:{
				globalGaccTranId: objACGlobal.gaccTranId,
				globalGaccBranchCd: objACGlobal.branchCd,
				globalGaccFundCd: objACGlobal.fundCd
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				var res = response.responseText.evalJSON();
				var rows = res.rows || [];
				for(var i = 0; i < objOrPreview.length; i++){
					if(objOrPreview[i].itemGenType == objAC.hidObjGIACS025.variables.itemGenTypeGiacs001){
						var newObj = objOrPreview[i];
						newObj.recordStatus = -1;
						objOrPreview.splice(i, 1, newObj);
						for(var c = 0; c < printSeqNoList.length; c++){
							if(printSeqNoList[c] == newObj.printSeqNo){
								printSeqNoList.splice(c, 1);
							}
						}
					}
				}

				if (rows.length > 0){ //delete existing Particular generated by GIACS001 if new particular is retrieved by MAC 05/30/2013.
					orTableGrid.deleteAnyRows('itemGenType', objAC.hidObjGIACS025.variables.itemGenTypeGiacs001);
				}
				
				for(var i = 0; i < rows.length; i++){
					addNewOrPrevRow(rows[i]); 
					changeTag = 1; //allow saving if there is a Collection detail retrieved by MAC 05/30/2013
				}
				if (changeTag == 1){
					saveOrPreview(); //save automatically after generating/regenerating particulars by MAC 06/04/2013.
				}
			}
		});	
		computeAllTotal(); //added by christian 03/18/2013
		orTableGrid.onRemoveRowFocus();
	}	

	$('btnGenParticularsORPreview').observe('click', function(){
		generateParticulars();
	});

	if (objAC.hidObjGIACS025.variables.insertTaxMessage != null){
		disableButton('btnPrintORPreview');
		disableButton('btnClearORPreview');
		disableButton('btnGenParticularsORPreview');
		disableButton('btnRegenerateORPreview');
		showMessageBox(objAC.hidObjGIACS025.variables.insertTaxMessage ,imgMessage.ERROR);
	}

	function computePrintTag2(){
		var printTotal = 0;
		for (var i=0; i<orTableGrid.rows.length; i++){
			if (orTableGrid.rows[i][orTableGrid.getColumnIndex('orPrintTag')] == 'Y' || orTableGrid.rows[i][orTableGrid.getColumnIndex('orPrintTag')] == '' || orTableGrid.rows[i][orTableGrid.getColumnIndex('orPrintTag')] == null){
				if(orTableGrid.geniisysRows[i].recordStatus != 1){
					if (objAC.hidObjGIACS025.variables.currCd != objAC.hidObjGIACS025.variables.defCurrCd){
						/*var val = orTableGrid.rows[i][orTableGrid.getColumnIndex('foreignCurrAmt')] == null || orTableGrid.rows[i][orTableGrid.getColumnIndex('foreignCurrAmt')] == "" ? 0 : unformatCurrencyValue(orTableGrid.rows[i][orTableGrid.getColumnIndex('foreignCurrAmt')]);
						printTotal = parseFloat(printTotal) + parseFloat(val);*/ // replaced by : Nica 09.24.2012 - to handle foreign currency amount
						var val = orTableGrid.rows[i][orTableGrid.getColumnIndex('itemAmt')] == null || orTableGrid.rows[i][orTableGrid.getColumnIndex('itemAmt')] == "" ? 0 : (orTableGrid.rows[i][orTableGrid.getColumnIndex('itemAmt')]); //removed unformatCurrencyValue by robert 10.14.2013
						printTotal = parseFloat(printTotal) + (parseFloat(val) / parseFloat(nvl(objAC.hidObjGIACS025.variables.currRt, 1)));
					}else{
						var val = orTableGrid.rows[i][orTableGrid.getColumnIndex('itemAmt')] == null || orTableGrid.rows[i][orTableGrid.getColumnIndex('itemAmt')] == "" ? 0 : (orTableGrid.rows[i][orTableGrid.getColumnIndex('itemAmt')]); //removed unformatCurrencyValue by robert 10.14.2013
						printTotal = parseFloat(printTotal) + parseFloat(val);
					}
				}
			}
		}
		
		var delArray = new Object();
		delArray = getDeletedJSONObjects(objOrPreview);
		var delTotal = 0;
		for (var i=0; i<delArray.length; i++){
			if (delArray[i].orPrintTag == 'Y' || delArray[i].orPrintTag == '' || delArray[i].orPrintTag == null){
				if (objAC.hidObjGIACS025.variables.currCd != objAC.hidObjGIACS025.variables.defCurrCd){
					/*var val = delArray[i].foreignCurrAmt == null || delArray[i].foreignCurrAmt == "" ? 0 : unformatCurrencyValue(delArray[i].foreignCurrAmt);
					delTotal = parseFloat(delTotal) + parseFloat(val);*/ // replaced by : Nica 09.24.2012 - to handle foreign currency amount
					var val = orTableGrid.rows[i][orTableGrid.getColumnIndex('itemAmt')] == null || orTableGrid.rows[i][orTableGrid.getColumnIndex('itemAmt')] == "" ? 0 : (orTableGrid.rows[i][orTableGrid.getColumnIndex('itemAmt')]); //removed unformatCurrencyValue by robert 10.14.2013
					printTotal = parseFloat(printTotal) + (parseFloat(val) / parseFloat(nvl(objAC.hidObjGIACS025.variables.currRt, 1)));
				}else{
					var val = delArray[i].itemAmt == null || delArray[i].itemAmt == "" ? 0 : unformatCurrencyValue(delArray[i].itemAmt); 
					delTotal = parseFloat(delTotal) + parseFloat(val);
				}		
			}	
		}
		printTotal = parseFloat(printTotal) - parseFloat(delTotal);

		var newRowsAdded = new Object();
		newRowsAdded = getAddedAndModifiedJSONObjects(objOrPreview);
		for (var i=0; i<newRowsAdded.length; i++){
			if (newRowsAdded[i].orPrintTag == 'Y' || newRowsAdded[i].orPrintTag == '' || newRowsAdded[i].orPrintTag == null){
				if (objAC.hidObjGIACS025.variables.currCd != objAC.hidObjGIACS025.variables.defCurrCd){
					/*var val = newRowsAdded[i].foreignCurrAmt == null || newRowsAdded[i].foreignCurrAmt == "" ? 0 : unformatCurrencyValue(newRowsAdded[i].foreignCurrAmt);
					printTotal = parseFloat(printTotal) + parseFloat(val);*/ // replaced by : Nica 09.24.2012 - to handle foreign currency amount
					var val = orTableGrid.rows[i][orTableGrid.getColumnIndex('itemAmt')] == null || orTableGrid.rows[i][orTableGrid.getColumnIndex('itemAmt')] == "" ? 0 : (orTableGrid.rows[i][orTableGrid.getColumnIndex('itemAmt')]); //removed unformatCurrencyValue by robert 10.14.2013
					printTotal = parseFloat(printTotal) + (parseFloat(val) / parseFloat(nvl(objAC.hidObjGIACS025.variables.currRt, 1)));
				}else{
					var val = newRowsAdded[i].itemAmt == null || newRowsAdded[i].itemAmt == "" ? 0 : unformatCurrencyValue(newRowsAdded[i].itemAmt);
					printTotal = parseFloat(printTotal) + parseFloat(val);
				}
			}
		}

		//to include total amounts in other pages
			if (objAC.hidObjGIACS025.variables.currCd != objAC.hidObjGIACS025.variables.defCurrCd){
				printTotal = parseFloat(printTotal) + parseFloat(orTableGrid.pager.sumPrint2);
			}else{
				printTotal = parseFloat(printTotal) + parseFloat(orTableGrid.pager.sumPrint1);
			}
		
		$("printTotal").value = formatCurrency(printTotal);	
		return formatCurrency(printTotal);
	}	 
	
	function computePrintTag(){
		var printTotal = 0;
		for (var i=0; i<orTableGrid.rows.length; i++){
			if (orTableGrid.rows[i][orTableGrid.getColumnIndex('orPrintTag')] == 'Y' || orTableGrid.rows[i][orTableGrid.getColumnIndex('orPrintTag')] == '' || orTableGrid.rows[i][orTableGrid.getColumnIndex('orPrintTag')] == null){
				if(orTableGrid.geniisysRows[i].recordStatus != 1){
					if (objAC.hidObjGIACS025.variables.currCd != objAC.hidObjGIACS025.variables.defCurrCd){
						var val = orTableGrid.rows[i][orTableGrid.getColumnIndex('foreignCurrAmt')] == null || orTableGrid.rows[i][orTableGrid.getColumnIndex('foreignCurrAmt')] == "" ? 0 : (orTableGrid.rows[i][orTableGrid.getColumnIndex('foreignCurrAmt')]); //removed unformatCurrencyValue by robert 10.14.2013
						printTotal = parseFloat(printTotal) + parseFloat(val);
						//printTotal = parseFloat(printTotal) + (parseFloat(val) / parseFloat(nvl(objAC.hidObjGIACS025.variables.currRt, 1)));
					}else{
						var val = orTableGrid.rows[i][orTableGrid.getColumnIndex('foreignCurrAmt')] == null || orTableGrid.rows[i][orTableGrid.getColumnIndex('foreignCurrAmt')] == "" ? 0 : (orTableGrid.rows[i][orTableGrid.getColumnIndex('foreignCurrAmt')]); //removed unformatCurrencyValue by robert 10.14.2013
						printTotal = parseFloat(printTotal) + parseFloat(val);
					}
				}
			}
		}
		
		var delArray = new Object();
		delArray = getDeletedJSONObjects(objOrPreview);
		var delTotal = 0;
		for (var i=0; i<delArray.length; i++){
			if (delArray[i].orPrintTag == 'Y' || delArray[i].orPrintTag == '' || delArray[i].orPrintTag == null){
				if (objAC.hidObjGIACS025.variables.currCd != objAC.hidObjGIACS025.variables.defCurrCd){
					/*var val = delArray[i].foreignCurrAmt == null || delArray[i].foreignCurrAmt == "" ? 0 : unformatCurrencyValue(delArray[i].foreignCurrAmt);
					delTotal = parseFloat(delTotal) + parseFloat(val);*/ // replaced by : Nica 09.24.2012 - to handle foreign currency amount
					var val = orTableGrid.rows[i][orTableGrid.getColumnIndex('foreignCurrAmt')] == null || orTableGrid.rows[i][orTableGrid.getColumnIndex('foreignCurrAmt')] == "" ? 0 : (orTableGrid.rows[i][orTableGrid.getColumnIndex('foreignCurrAmt')]); //removed unformatCurrencyValue by robert 10.14.2013
					printTotal = parseFloat(printTotal) + parseFloat(val);
					//printTotal = parseFloat(printTotal) + (parseFloat(val) / parseFloat(nvl(objAC.hidObjGIACS025.variables.currRt, 1)));
				}else{
					var val = delArray[i].foreignCurrAmt == null || delArray[i].foreignCurrAmt == "" ? 0 : unformatCurrencyValue(delArray[i].foreignCurrAmt); 
					delTotal = parseFloat(delTotal) + parseFloat(val);
				}		
			}	
		}
		printTotal = parseFloat(printTotal) - parseFloat(delTotal);

		var newRowsAdded = new Object();
		newRowsAdded = getAddedAndModifiedJSONObjects(objOrPreview);
		for (var i=0; i<newRowsAdded.length; i++){
			if (newRowsAdded[i].orPrintTag == 'Y' || newRowsAdded[i].orPrintTag == '' || newRowsAdded[i].orPrintTag == null){
				if (objAC.hidObjGIACS025.variables.currCd != objAC.hidObjGIACS025.variables.defCurrCd){
					/*var val = newRowsAdded[i].foreignCurrAmt == null || newRowsAdded[i].foreignCurrAmt == "" ? 0 : unformatCurrencyValue(newRowsAdded[i].foreignCurrAmt);
					printTotal = parseFloat(printTotal) + parseFloat(val);*/ // replaced by : Nica 09.24.2012 - to handle foreign currency amount
					var val = orTableGrid.rows[i][orTableGrid.getColumnIndex('foreignCurrAmt')] == null || orTableGrid.rows[i][orTableGrid.getColumnIndex('foreignCurrAmt')] == "" ? 0 : (orTableGrid.rows[i][orTableGrid.getColumnIndex('foreignCurrAmt')]); //removed unformatCurrencyValue by robert 10.14.2013
					printTotal = parseFloat(printTotal) + parseFloat(val);
					//printTotal = parseFloat(printTotal) + (parseFloat(val) / parseFloat(nvl(objAC.hidObjGIACS025.variables.currRt, 1)));
				}else{
					var val = newRowsAdded[i].foreignCurrAmt == null || newRowsAdded[i].foreignCurrAmt == "" ? 0 : unformatCurrencyValue(newRowsAdded[i].foreignCurrAmt);
					printTotal = parseFloat(printTotal) + parseFloat(val);
				}
			}
		}

		//to include total amounts in other pages
			if (objAC.hidObjGIACS025.variables.currCd != objAC.hidObjGIACS025.variables.defCurrCd){
				printTotal = parseFloat(printTotal) + parseFloat(orTableGrid.pager.sumPrint2);
			}else{
				printTotal = parseFloat(printTotal) + parseFloat(orTableGrid.pager.sumPrint1);
			}
		
		$("printTotal").value = formatCurrency(printTotal);	
		return formatCurrency(printTotal);
	}	

	function computeItemAmt(){
		var itemAmtTotal = 0;
		for (var i=0; i<orTableGrid.rows.length; i++){
			if(orTableGrid.geniisysRows[i].recordStatus != 1){
				var val = orTableGrid.rows[i][orTableGrid.getColumnIndex('itemAmt')] == null || orTableGrid.rows[i][orTableGrid.getColumnIndex('itemAmt')] == "" ? 0 : (orTableGrid.rows[i][orTableGrid.getColumnIndex('itemAmt')]); //removed unformatCurrencyValue by robert 10.14.2013
				itemAmtTotal = parseFloat(itemAmtTotal) + parseFloat(val);
			}
		}

		var delArray = new Object();
		delArray = getDeletedJSONObjects(objOrPreview);
		var delTotal = 0;
		for (var i=0; i<delArray.length; i++){
			var val = delArray[i].itemAmt == null || delArray[i].itemAmt == "" ? 0 : unformatCurrencyValue(delArray[i].itemAmt);
			delTotal = parseFloat(delTotal) + parseFloat(val);
		}
		itemAmtTotal = parseFloat(itemAmtTotal) - parseFloat(delTotal);

		var newRowsAdded = new Object();
		newRowsAdded = getAddedAndModifiedJSONObjects(objOrPreview);
		for (var i=0; i<newRowsAdded.length; i++){
			var val = newRowsAdded[i].itemAmt == null || newRowsAdded[i].itemAmt == "" ? 0 : unformatCurrencyValue(newRowsAdded[i].itemAmt);
			itemAmtTotal = parseFloat(itemAmtTotal) + parseFloat(val);
		}

		//to include total amounts in other pages
		itemAmtTotal = parseFloat(itemAmtTotal) + parseFloat(orTableGrid.pager.sumItemAmt);
		
		$("itemTotal").value = formatCurrency(itemAmtTotal);	
		return formatCurrency(itemAmtTotal);
	}	
	
	function computeFcAmt(){
		var fcTotal = 0;
		for (var i=0; i<orTableGrid.rows.length; i++){
			if(orTableGrid.geniisysRows[i].recordStatus != 1){
				var val = orTableGrid.rows[i][orTableGrid.getColumnIndex('foreignCurrAmt')] == null || orTableGrid.rows[i][orTableGrid.getColumnIndex('foreignCurrAmt')] == "" ? 0 : (orTableGrid.rows[i][orTableGrid.getColumnIndex('foreignCurrAmt')]); //removed unformatCurrencyValue by robert 10.14.2013
				fcTotal = parseFloat(fcTotal) + parseFloat(val);
			}
		}

		var delArray = new Object();
		delArray = getDeletedJSONObjects(objOrPreview);
		var delTotal = 0;
		for (var i=0; i<delArray.length; i++){
			var val = delArray[i].foreignCurrAmt == null || delArray[i].foreignCurrAmt == "" ? 0 : unformatCurrencyValue(delArray[i].foreignCurrAmt);
			delTotal = parseFloat(delTotal) + parseFloat(val);
		}
		fcTotal = parseFloat(fcTotal) - parseFloat(delTotal);

		var newRowsAdded = new Object();
		newRowsAdded = getAddedAndModifiedJSONObjects(objOrPreview);
		for (var i=0; i<newRowsAdded.length; i++){
			var val = newRowsAdded[i].foreignCurrAmt == null || newRowsAdded[i].foreignCurrAmt == "" ? 0 : unformatCurrencyValue(newRowsAdded[i].foreignCurrAmt);
			fcTotal = parseFloat(fcTotal) + parseFloat(val);
		}

		//to include total amounts in other pages
		fcTotal = parseFloat(fcTotal) + parseFloat(orTableGrid.pager.sumFcAmt);
		
		$("fcTotal").value = formatCurrency(fcTotal);	
		return formatCurrency(fcTotal);
	}	
	
	function computeDifference(){
		//var orAmt = objAC.hidObjGIACS025.variables.nbtORAmt;  
		var orAmt = nvl($F("grossAmt") == "" ? objAC.hidObjGIACS025.variables.nbtORAmt : $F("grossAmt"),'0'); //temporary, modified by d.alcantara, 5.23.2011
		var exactAmt = nvl(objAC.hidObjGIACS025.variables.exactAmount,0);
		
		var diff = parseFloat((orAmt).replace(/,/g, "")) - parseFloat((computePrintTag()).replace(/,/g, ""));
		
		exactAmt = Math.abs(exactAmt - parseFloat((computePrintTag()).replace(/,/g, "")));
		
		exactDiff = Math.abs(diff);
		
		$("diffTotal").value = formatCurrency(diff);
		return $F("diffTotal");
	}	

	//compute all total - edited by: john dolon 7.23.2015; SR#19891
	function computeAllTotal(){
		//computePrintTag();
		//computeItemAmt();
		//computeFcAmt();
		//computeDifference();
		populateTotalForeign();
		populateTotalLocal();
		populateTotalPrinted();
		populateDifference();
	}
	
	//added by steven 1/8/2013
	//modified by christian 04/01/2013
	//return true if allowed
	function validateORAcctgEntries() {
		var result = true;
		new Ajax.Request(contextPath+"/GIACOpTextController?",{
			method: "POST",
			parameters:{
				action: "validateORAcctgEntries",
				paramName: "VALIDATE_OR_ACCTG_ENTRIES"
			},
			asynchronous: false,
			evalScripts: true,
			onComplete:function(response){
				if (nvl(response.responseText,"N") == "N"){
					result = true;
				}else{
					if(validateBalanceAcctEntrs()){
						result = true;
					}else{
						showMessageBox("OR Printing is not allowed. Accounting Entries are not yet balanced.", imgMessage.ERROR);
						result = false;
					}
				}
			}
		});
		return result;
	}
	
	//created by christian 04/01/2013
	//check accounting entries if balance
	function validateBalanceAcctEntrs(){
		try{
			var result = true;
			new Ajax.Request(contextPath+"/GIACOpTextController?",{
				method: "POST",
				parameters:{
					action: "validateBalanceAcctgEntrs",
					gaccTranId: objACGlobal.gaccTranId
				},
				asynchronous: false,
				evalScripts: true,
				onComplete:function(response){
					if(checkErrorOnResponse(response)) {
						if (response.responseText == "FALSE"){
							result = false;
						}else{
							result = true;
						}
					}
				}
			});
			return result;
		}catch (e) {
			showErrorMessage("validateBalanceAcctEntrs", e);
		}
	}

	$("btnRegenerateORPreview").observe("click", function(){
		checkPrintSeqNo();
	});

	$("btnPrintORPreview").observe("click", function(){
		orTableGrid._blurCellElement(orTableGrid.keys._nCurrentFocus==null?orTableGrid.keys._nOldFocus:orTableGrid.keys._nCurrentFocus);  //to avoid null input error            
    	if (!orTableGrid.preCommit()){ return false; } //to validate all required field before saving
    	orTableGrid._nCurrentFocus = null;
    	
		function doPrintOP(){
			hideNotice();
			//var orAmt = objAC.hidObjGIACS025.variables.nbtORAmt; 
			var orAmt = $F("grossAmt") == "" ? objAC.hidObjGIACS025.variables.nbtORAmt : $F("grossAmt"); //temporary, modified by d.alcantara, 5.23.2011
			
			//if (parseFloat((orAmt).replace(/,/g, "")) != parseFloat((computePrintTag()).replace(/,/g, ""))){
			if (unformatCurrencyValue($F("diffTotal")) != 0){ //added by steven 1/8/2013 "validateORAcctgEntries()" base on SR 0011812 //removed validateORAcctgEntries() by christian 04/01/2013
				showMessageBox("Print tag total amount must be equal to the O.R. Amount entered.", imgMessage.ERROR);
				return false;
			} else if ($("payor").value.strip() == "-") {
				showConfirmBox("", "Enter the name of the payor first before printing the OR.", 
						"Ok", "Cancel", function(){fireEvent($("directTransac"),"click");}, "");
				return false;
			}else if(validateORAcctgEntries()){ //added by christian 04/01/2013
				new Ajax.Request(contextPath+"/GIACOpTextController?action=validatePrintOP",{
					method: "POST",
					parameters:{
						globalGaccTranId: objACGlobal.gaccTranId,
						globalGaccBranchCd: objACGlobal.branchCd,
						globalGaccFundCd: objACGlobal.fundCd,
						currCd: objAC.hidObjGIACS025.variables.currCd,
						currSname: objAC.hidObjGIACS025.variables.currSname
					},
					asynchronous: false,
					evalScripts: true,
					onComplete: function(response){
						var res = response.responseText.evalJSON();
						function showPrintOR(){
							//orTableGrid.options.toolbar.postSave.call();
							var orPref = "";
							new Ajax.Request(contextPath+"/PrintORController?action=checkVATOR&globalGaccTranId="+
									objACGlobal.gaccTranId+"&globalGaccBranchCd="+objACGlobal.branchCd+
									"&globalGaccFundCd="+objACGlobal.fundCd, {
								method: "GET",
								evalScripts: true,
								asynchronous: false,
								onComplete: function(response){
									hideNotice();
									if(checkErrorOnResponse(response)) {
										orPref = response.responseText;
										
										overlayOR = Overlay.show(contextPath+"/PrintORController", {
											urlContent : true,
											urlParameters: {action : "showPrintOR",
															globalGaccTranId : objACGlobal.gaccTranId, 
															globalGaccBranchCd : objACGlobal.branchCd,
															globalGaccFundCd: objACGlobal.fundCd,
															orPref: orPref},
										    title: "Official Receipt Printing",
										    height: 230,
										    width: 440,
										    draggable: true
										});
										
										/* Modalbox.show(contextPath+"/PrintORController?action=showPrintOR&globalGaccTranId="+
												objACGlobal.gaccTranId+"&globalGaccBranchCd="+objACGlobal.branchCd+
												"&globalGaccFundCd="+objACGlobal.fundCd+"&orPref="+orPref, 
												{title: "Official Receipt Printing",
												 width: 400,
												 overlayClose: false}); //added by steven 3/7/2013 */
									}
								}
							});
						}	
						function showMsg3(){
							if (res.message3 != null){
								showWaitingMessageBox(res.message3, imgMessage.INFO, showPrintOR);
							}else{
								showPrintOR();
							}		
						}
						function showMsg2(){
							if (res.message2 != null){
								showMessageBox(res.message2, imgMessage.ERROR);
								return true;
							}else{
								showMsg3();
							}	
						}
						if (res.message1 != null){
							showWaitingMessageBox(res.message1, imgMessage.INFO, showMsg2);	
						}else{
							showMsg2();
						}		
					}	 
				});
			}	
			return true;
			
		}	
		function save(){
			var ok = true;
        	if (orTableGrid.options.toolbar.onSave) {
        		ok = orTableGrid.options.toolbar.onSave.call();
        	}
        	if (ok || ok==undefined){
        		ok = doPrintOP();
        	}
        	if (ok) orTableGrid.options.toolbar.postSave.call();
		}	
		if (orTableGrid.getModifiedRows().length != 0 || orTableGrid.getNewRowsAdded().length != 0 || orTableGrid.getDeletedRows().length != 0){
    		showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", save, doPrintOP, "");
    	}else{
    		doPrintOP(); 
    	}		
	});
	
	
	function populateInfo(y, func){
		$("itemNo").value = func == "pop" ? orTableGrid.geniisysRows[y].printSeqNo : "";
		$("billNo").value = func == "pop" ? orTableGrid.geniisysRows[y].billNo : "";
		$("generationType").value = func == "pop" ? orTableGrid.geniisysRows[y].itemGenType : "";
		$("locCurAmt").value = func == "pop" ? formatCurrency(orTableGrid.geniisysRows[y].itemAmt) : "";
		$("line").value = func == "pop" ? orTableGrid.geniisysRows[y].line : "";
		$("currency").value = func == "pop" ? orTableGrid.geniisysRows[y].dspCurrSname : "";
		$("colNo").value = func == "pop" ? orTableGrid.geniisysRows[y].columnNo : "";
		$("forCurAmt").value = func == "pop" ? formatCurrency(orTableGrid.geniisysRows[y].foreignCurrAmt) : "";
		$("particulars").value = func == "pop" ? unescapeHTML2(orTableGrid.geniisysRows[y].itemText) : ""; //added unescapeHTML2 by robert 10.26.2013
		func == "pop" && access == 1 && (objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR") && objAC.tranFlagState != "C" ? enableButton("btnDelete") : disableButton("btnDelete");
		enableButton("btnAdd"); //added by reymon 10112013 for proper representation of add/update/delete buttons
		func == "pop" ? $("btnAdd").value = "Update" : $("btnAdd").value = "Add";
		if(func == "pop" || objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y"){ // andrew - 08.16.2012 - added cancelOR condition for SR 0010292
			//store old value of Local/Foreign Currency amount by MAC 06/07/2013.
			oldLocCurAmt = $F("locCurAmt");
			oldForCurAmt = $F("forCurAmt");
			if(objAC.hidObjGIACS025.variables.itemGenType != orTableGrid.geniisysRows[y].itemGenType && orTableGrid.geniisysRows[y].itemGenType != objAC.hidObjGIACS025.variables.itemGenTypeGiacs001){
				$("locCurAmt").readOnly = true;
				//set all other editable fields to readOnly to keep user from editing details of system generated particulars by MAC 05/30/2013.
				$("itemNo").readOnly = true;
				$("line").readOnly = true;
				$("forCurAmt").readOnly = true;
				$("particulars").readOnly = true;
				$("colNo").readOnly = true;
				$("billNo").readOnly = true;
				
				//if(objAC.hidObjGIACS025.variables.itemGenType != objAC.hidObjGIACS025.variables.itemGenTypeGiacs001){ //marco - 12.01.2014 - replaced with line below
				if(orTableGrid.geniisysRows[y].itemGenType != objAC.hidObjGIACS025.variables.itemGenTypeGiacs001){
					disableButton("btnDelete");//added by reymon 10112013 for proper representation of add/update/delete buttons
				}
				disableButton("btnAdd");//added by reymon 10112013 for proper representation of add/update/delete buttons
			}else{
				//disallow update of all fields except Item Number if Clear All Item Nos. button is pressed by MAC 06/10/2013.
				if (objAC.hidObjGIACS025.variables.currCd == null || objAC.hidObjGIACS025.variables.currCd == "" || objAC.hidObjGIACS025.variables.dummy != null){//disallow update of user generated particulars if no collection breakdown found in GIACS001 and if OR is not NEW by MAC 06/07/2013.
					$("locCurAmt").readOnly = true;
					$("forCurAmt").readOnly = true;
					$("itemNo").readOnly = true;
					$("line").readOnly = true;
					$("particulars").readOnly = true;
					$("colNo").readOnly = true;
					$("billNo").readOnly = true;
					disableButton("btnDelete");//added by reymon 10112013 for proper representation of add/update/delete buttons
					disableButton("btnAdd");//added by reymon 10112013 for proper representation of add/update/delete buttons
				}else{
					//$("locCurAmt").readOnly = false;
					//$("forCurAmt").readOnly = false;
					//set all other editable fields to readOnly to keep user from editing details already saved particulars by MAC 05/30/2013.
					/*if ($F("itemNo") != ""){ //disable Print Sequence Number if it is not null by MAC 06/04/2013.
						$("itemNo").readOnly = true;
					})*/
					//$("line").readOnly = true;
					$("locCurAmt").readOnly = false;
					$("forCurAmt").readOnly = false;
					$("itemNo").readOnly = false;
					$("line").readOnly = false;
					$("particulars").readOnly = false;
					$("colNo").readOnly = false;
					$("billNo").readOnly = false;
				}
			}
			/*$("particulars").readOnly = true;
			$("colNo").readOnly = true;
			$("billNo").readOnly = true;*/
		}else{
			//store old value of Local/Foreign Currency amount by MAC 06/07/2013.
			oldLocCurAmt = 0;
			oldForCurAmt = 0;
			$("locCurAmt").readOnly = false;
			$("particulars").readOnly = false;
			$("colNo").readOnly = false;
			$("billNo").readOnly = false;
			//set all other fields to its default by MAC 05/30/2013.
			$("itemNo").readOnly = false;
			$("line").readOnly = false;
			$("forCurAmt").readOnly = false;
		}
	}
	
	$("btnDelete").observe("click", function(){
		if (objAC.hidObjGIACS025.variables.currCd == null || objAC.hidObjGIACS025.variables.currCd == ""){
			showMessageBox('Insert not allowed. Enter collection details first.' ,imgMessage.ERROR);
		}else if(objAC.hidObjGIACS025.variables.itemGenType != orTableGrid.geniisysRows[selectedIndex].itemGenType && 
				 objAC.hidObjGIACS025.variables.itemGenTypeGiacs001 != orTableGrid.geniisysRows[selectedIndex].itemGenType){ //marco - 12.01.2014 - added - FGIC-WEB SR 2592
			showMessageBox('Deletion of generated record is not allowed.' ,imgMessage.ERROR);
		}else{
			if(regenerate == 0){
				deleteOrPreview();
				changeTag = 1;
			}else{
				showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			}
		}
	});
	
	function deleteOrPreview(){
		var delObj = delObjOrPrev();
		for(var i = 0; i < printSeqNoList.length; i++){
			if(printSeqNoList[i] == delObj.printSeqNo){
				printSeqNoList.splice(i, 1);
			}
		}
		for(var i = 0; i < itemSeqNoList.length; i++){
			if(itemSeqNoList[i] == delObj.itemSeqNo && delObj.itemGenType == 'X'){
				itemSeqNoList.splice(i, 1);
			}
		}
		objOrPreview.splice(selectedIndex, 1, delObj);
		orTableGrid.deleteVisibleRowOnly(selectedIndex);
		populateInfo(1, "clear");
		populateDefaultInfo();
		computeAllTotal();
		changeTag = 1;
	}

	$("viewParticulars").observe("click", function(){
		orTableGrid.keys.releaseKeys();
		//showEditor("particulars", 500, access == 1 ? (selectedIndex > -1 ? "true" : "false") : "true");
		showEditor("particulars", 500, access == 1 ? ($("particulars").readOnly == true ? "true" : "false") : "true"); // lara - 11/25/2013
	});
	
	$("locCurAmt").observe(/*"blur"*/ "change", function(){
		var localAmt = parseFloat(this.value.replace(/,/g, ""));
		if(Math.abs(localAmt) > 999999999999.99){//check first if entered amount is within range before proceeding by MAC 06/07/2013.
			showMessageBox("Invalid Local Currency Amount. Value should be from -999,999,999,999.99 to 999,999,999,999.99.", imgMessage.ERROR);
			$("locCurAmt").value = formatCurrency(oldLocCurAmt);
			$("forCurAmt").value = formatCurrency(oldForCurAmt);
			return false;
		}else if(localAmt == 0){
			showMessageBox("Invalid Local Currency Amount.   Value should not be equal to zero.", imgMessage.ERROR);
			$("locCurAmt").value = formatCurrency(oldLocCurAmt);
			$("forCurAmt").value = formatCurrency(oldForCurAmt);
			return false;
		}else{
			$("forCurAmt").value = $F("locCurAmt") == "" ? "" : formatCurrency(parseFloat(unformatCurrencyValue($F("locCurAmt"))) / parseFloat(objAC.hidObjGIACS025.variables.currRt));
		}
	});
	
	$("forCurAmt").observe(/*"blur"*/ "change", function(){
		var foreignAmt = parseFloat(this.value.replace(/,/g, ""));
		if(Math.abs(foreignAmt) > 999999999999.99){//check first if entered amount is within range before proceeding by MAC 06/07/2013.
			showMessageBox("Invalid Foreign Currency Amount. Value should be from -999,999,999,999.99 to 999,999,999,999.99.", imgMessage.ERROR);
			$("forCurAmt").value = formatCurrency(oldForCurAmt);
			$("locCurAmt").value = formatCurrency(oldLocCurAmt);
			return false;
		}else if (Math.abs(parseFloat(unformatCurrencyValue($F("forCurAmt"))) * parseFloat(objAC.hidObjGIACS025.variables.currRt)) > 999999999999.99){//check first if computed local currency amount is within range before proceeding by MAC 06/10/2013.
			showMessageBox("Invalid Foreign Currency Amount. Computed Local Currency amount should be from -999,999,999,999.99 to 999,999,999,999.99.", imgMessage.ERROR);
			$("forCurAmt").value = formatCurrency(oldForCurAmt);
			$("locCurAmt").value = formatCurrency(oldLocCurAmt);
			return false;
		}else if(foreignAmt == 0){
			showMessageBox("Invalid Foreign Currency Amount. Value should not be equal to zero.", imgMessage.ERROR);
			$("forCurAmt").value = formatCurrency(oldForCurAmt);
			$("locCurAmt").value = formatCurrency(oldLocCurAmt);
			return false;
		}else{
			$("locCurAmt").value = $F("forCurAmt") == "" ? "" : formatCurrency(parseFloat(unformatCurrencyValue($F("forCurAmt"))) * parseFloat(objAC.hidObjGIACS025.variables.currRt));
		}
	});
	
	var regenerate = 0;
	$("btnAdd").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("infoDiv")){
			var rowOrPrev = setObjOrPrev($("btnAdd").value);
			if($("btnAdd").value == "Add"){
				if(regenerate == 0 && validateInput()){
					addNewOrPrevRow(rowOrPrev);
					printSeqNoList.push(rowOrPrev.printSeqNo);
					itemSeqNoList.push(rowOrPrev.itemSeqNo);
					changeTag = 1;
					computeAllTotal();
					populateInfo(1, "clear");
					populateDefaultInfo();
				}else{
					showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
				}
			}else if($("btnAdd").value == "Update"){
				//if(regenerate == 0 && validateInput()){ //marco - 11.28.2014 - comment out
				if(validateInput()){
					for(var c = 0; c < printSeqNoList.length; c++){ //marco - 11.28.2014
						if(printSeqNoList[c] == objOrPreview[selectedIndex].printSeqNo){
							printSeqNoList.splice(c, 1, $F("itemNo"));
						}
					}
					objOrPreview.splice(selectedIndex, 1, rowOrPrev);
					orTableGrid.updateVisibleRowOnly(rowOrPrev, selectedIndex);
					changeTag = 1;
					computeAllTotal();
					populateInfo(1, "clear");
					populateDefaultInfo();
				}else{
					//validateItemNo(); replaced and comment out to disallow update of records with invalid input by MAC 07/09/2013.
					showMessageBox(objCommonMessage.SAVE_CHANGES, "I"); //added by MAC 07/09/2013
				}
			}
		}
	});
	
	function validateItemNo(){
		var rowOrPrev = setObjOrPrev($("btnAdd").value);
		var isExist = false;
		for(var i = 0; i < orTableGrid.pager.rows.length; i++){
			if($F("itemNo") == $("mtgIC1_4,"+i).innerHTML){
				isExist = true;
			}
		}
		
		new Ajax.Request(contextPath+"/GIACOpTextController?action=validatePrintSeqNo",{
			method: "POST",
			parameters:{
				globalGaccTranId: objACGlobal.gaccTranId,
				globalGaccBranchCd: objACGlobal.branchCd,
				globalGaccFundCd: objACGlobal.fundCd,
				printSeqNo: $F("itemNo"),
			 	startRow: orTableGrid.pager.from,
				endRow: orTableGrid.pager.to	
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				if (response.responseText == "Y"){
					isExist = true;
				}
			}	 
		});
		
		if(isExist){
			showMessageBox("Item No. already exists.", "E");
		}else{
			objOrPreview.splice(selectedIndex, 1, rowOrPrev);
			orTableGrid.updateVisibleRowOnly(rowOrPrev, selectedIndex);
			changeTag = 1;
			computeAllTotal();
			populateInfo(1, "clear");
			populateDefaultInfo();
			printSeqNoList.push(rowOrPrev.printSeqNo);
		}
	}
	
	function validateInput(){
		var proceed  = true;	
		
		if($("btnAdd").value == "Add"){
			for(var i = 0; i < printSeqNoList.length; i++){
				if($F("itemNo") == printSeqNoList[i]){
					proceed = false;
					showMessageBox("Item No. already exists.", "E");
				}
			}
		}else{
			if($F("itemNo") != orTableGrid.geniisysRows[selectedIndex].printSeqNo){
				for(var i = 0; i < printSeqNoList.length; i++){
					if($F("itemNo") == printSeqNoList[i]){
						proceed = false;
						showMessageBox("Item No. already exists.", "E");
					}
				}
			}
		}
		
		if((parseInt($F("itemNo")*1) > 99999 || parseInt($F("itemNo")*1) <= 0 || isNaN($F("itemNo"))) && $F("itemNo") != ""){
			showMessageBox("Entered item no. is invalid. Valid value is from 1 to 99999.", "E");
			proceed = false;
		}else if(isNaN($F("colNo")) && $F("colNo") != ""){
			showMessageBox("Entered col # is invalid. Valid value is from 0 to 9.", "E");
			proceed = false;
		}else if((parseInt($F("locCurAmt")*1) > 999999999999.99 || parseInt($F("locCurAmt")*1) < -999999999999.99) && $F("locCurAmt") != ""){
			showMessageBox("Entered local currency is invalid. Valid value is from -999,999,999,999.99 to 999,999,999,999.99.", "E");
			proceed = false;
		}else if((parseInt($F("forCurAmt")*1) > 999999999999.99 || parseInt($F("locCurAmt")*1) < -999999999999.99) && $F("forCurAmt") != ""){
			showMessageBox("Entered foreign currency is invalid. Valid value is from -999,999,999,999.99 to 999,999,999,999.99.", "E");
			proceed = false;
		}
		
		return proceed;
	}
	
	function addNewOrPrevRow(rowOrPrev){
		objOrPreview.push(rowOrPrev);
		orTableGrid.addBottomRow(rowOrPrev);
	}
	
	function setObjOrPrev(action){
		var obj = new Object();
		
		obj.lastUpdate = new Date();
		obj.currencyCd = objAC.hidObjGIACS025.variables.currCd;
		obj.gaccTranId = objACGlobal.gaccTranId;
		obj.dspCurrSname = objAC.hidObjGIACS025.variables.currSname;
		obj.itemGenType = $F("generationType");
		obj.printSeqNo = $F("itemNo");
		obj.line = $F("line");
		obj.columnNo  = $F("colNo");
		obj.itemText = $F("particulars");
		obj.billNo = $F("billNo");
		obj.itemAmt = $F("locCurAmt");
		obj.foreignCurrAmt = $F("forCurAmt");
		if(action == "Add"){
			obj.itemSeqNo = getItemSeqNo();
			obj.rowCount = objOrPreview.length == 0 ? 1 : objOrPreview[objOrPreview.length-1].rowCount + 1;
			obj.orPrintTag = "Y";
			obj.recordStatus = 0;
		}else{
			obj.itemSeqNo = objOrPreview[selectedIndex].itemSeqNo;
			obj.rowCount = objOrPreview[selectedIndex].rowCount;
			obj.orPrintTag = objOrPreview[selectedIndex].orPrintTag;
			obj.cpiRecNo = objOrPreview[selectedIndex].cpiRecNo;
			obj.cpiBranchCd = objOrPreview[selectedIndex].cpiBranchCd;
			obj.orPrintTag = $("mtgInput"+orTableGrid._mtgId+"_3,"+selectedIndex).checked ? "Y" : "N";
			obj.recordStatus = 1;
		}
		return obj;
	}
	
	function delObjOrPrev(){
		var obj = new Object();
		
		obj.gaccTranId = objACGlobal.gaccTranId;
		obj.recordStatus = -1;
		obj.itemSeqNo = orTableGrid.geniisysRows[selectedIndex].itemSeqNo;
		obj.itemGenType = orTableGrid.geniisysRows[selectedIndex].itemGenType;
		obj.printSeqNo = orTableGrid.geniisysRows[selectedIndex].printSeqNo;
		obj.orPrintTag = "Y";
		obj.itemAmt = orTableGrid.geniisysRows[selectedIndex].itemAmt;
		obj.foreignCurrAmt = orTableGrid.geniisysRows[selectedIndex].foreignCurrAmt;
		
		return obj;
	}
	
	function saveOrPreview(){
		var objParams = new Object();
		objParams.setRows = getAddedAndModifiedJSONObjects(objOrPreview);
		objParams.delRows = getDeletedJSONObjects(objOrPreview);
		
		new Ajax.Request(contextPath+"/GIACOpTextController?action=saveORPreview",{
			method: "POST",
			parameters:{
				globalGaccTranId: objACGlobal.gaccTranId,
				globalGaccBranchCd: objACGlobal.branchCd,
				globalGaccFundCd: objACGlobal.fundCd,
				parameters: JSON.stringify(objParams)
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				showNotice("Saving OR Preview, please wait...");
			},
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)) {
					if (response.responseText == "SUCCESS"){
						showMessageBox(objCommonMessage.SUCCESS, "S");
						changeTag = 0;
						regenerate = 0;
						enableDisableParticulars();
						updateObjOrPreview();
						orTableGrid.refresh();
					}
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
				populateDefaultInfo();
				disableButton("btnRegenerateORPreview");
			}
		});
	}
	
	function updateObjOrPreview(){
		for(var i = 0; i < objOrPreview.length; i++){
			if(objOrPreview[i].recordStatus == -1){
				objOrPreview[i].recordStatus == null;
				delete objOrPreview[i];
			}else{
				objOrPreview[i].recordStatus == null;
			}
		}
	}
	
	function checkPrintSeqNo(){
		var proceed = true;
		for(var i = 0; i < orTableGrid.rows.length; i++){
			if(orTableGrid.geniisysRows[i].recordStatus != -1 && (orTableGrid.geniisysRows[i].printSeqNo == "" || orTableGrid.geniisysRows[i].printSeqNo == null)){
				proceed = false;
			}
		}
		if(proceed){
			saveOrPreview();
		}else{
			showMessageBox("Item no. is required.", "E");
		}
	}
	
	function getItemSeqNo(){
		var lastItemSeqNo = 0;
		if(itemSeqNoList.length > 0){
			lastItemSeqNo = Math.max.apply(Math, itemSeqNoList);
		}
		return lastItemSeqNo+1;
	}
	
	function adjustOpText() {
		try {
			new Ajax.Request(contextPath+"/GIACOpTextController", {
				method: "POST",
				parameters: {
					action: "adjustOpText",
					globalGaccTranId: objACGlobal.gaccTranId
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)) {
						hideNotice();
						opTextAdjusted = 1;
						orTableGrid._refreshList();
					}
				}
			});
		} catch(e) {
			showErrorMessage("adjustOpText", e);
		}
	}
	
	function adjustOpTextNew() {
		try {
			new Ajax.Request(contextPath+"/GIACOpTextController", {
				method: "POST",
				parameters: {
					action: "recomputeOpText",
					gaccTranId: objACGlobal.gaccTranId
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)) {
						hideNotice();
						opTextAdjusted = 1;
						orTableGrid._refreshList();
					}
				}
			});
		} catch(e) {
			showErrorMessage("adjustOpTextNew", e);
		}
	}
	
	observeSaveForm("btnSave", checkPrintSeqNo);
	observeCancelForm("btnCancel", checkPrintSeqNo, function(){
		editORInformation();
		window.scrollTo(0,0);
	});
	
	function computeTotalsOnLoad() {
		computeAllTotal();
        /* Commented out by reymon 10232013
        ** UCPB 10219
		var orDiff = roundNumber(exactDiff, 2);
		if(opTextAdjusted == 0 && (orDiff > 0 && orDiff <= 0.01)) {
			adjustOpText();
			//orTableGrid.refresh();
		}  */ 
		//if(parseFloat($F("diffTotal")) <= parseFloat('${orDocStampsAdj}') && parseFloat($F("diffTotal")) > 0 && opTextAdjusted == 0){
		if(opTextAdjusted == 0 && objAC.tranFlagState != "P" && objAC.tranFlagState == "O"){
			adjustOpTextNew();
		}
		//}
	}
	
	//computeTotalsOnLoad();
	//computeAllTotal();  //nilipat sa after render
	
	// andrew - 08.15.2012 SR 0010292
	function disableGIACS025(){
		try {
			$("itemNo").removeClassName("required");
			$("itemNo").readOnly = true;
			$("line").readOnly = true;
			$("colNo").readOnly = true;
			$("particulars").removeClassName("required");
			$("particulars").readOnly = true;
			$("particularsDiv").removeClassName("required");
			$("billNo").readOnly = true;
			$("locCurAmt").readOnly = true;
			$("locCurAmt").removeClassName("required");
			$("forCurAmt").readOnly = true;
			$("forCurAmt").removeClassName("required");
			disableButton("btnAdd");
			disableButton("btnClearORPreview");
			disableButton("btnPrintORPreview");
			disableButton("btnSave");
			disableButton('btnGenParticularsORPreview');
		} catch(e){
			showErrorMessage("disableGIACS025", e);
		}
	}
	//added cancelOtherOR by robert 10302013
	if(objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y"){
		disableGIACS025();
	} else {
		initializeChangeTagBehavior(checkPrintSeqNo);
	}

	changeTag = 0;
	
	//added by John Dolon; 7.23.2015; SR#19891
	function populateTotalForeign(){
		var totalForeign = 0;
		for (var i=0; i<orTableGrid.geniisysRows.length; i++){
			if (orTableGrid.geniisysRows[i].recordStatus != -1){
				totalForeign = totalForeign + parseFloat(unformatCurrencyValue(orTableGrid.geniisysRows[i].foreignCurrAmt));
			}
		}
		
		//to include total amounts in other pages
		totalForeign = parseFloat(totalForeign) + parseFloat(unformatCurrencyValue(orTableGrid.pager.sumFcAmt));
		$("fcTotal").value = formatCurrency(totalForeign);	
	}
	
	function populateTotalLocal(){
		var totalLocal = 0;
		for (var i=0; i<orTableGrid.geniisysRows.length; i++){
			if (orTableGrid.geniisysRows[i].recordStatus != -1){
				totalLocal = totalLocal + parseFloat(unformatCurrencyValue(orTableGrid.geniisysRows[i].itemAmt));
			}
		}
		
		//to include total amounts in other pages
		totalLocal = parseFloat(totalLocal) + parseFloat(orTableGrid.pager.sumItemAmt);
		$("itemTotal").value = formatCurrency(totalLocal);	
	}
	
	function populateTotalPrinted(){
		var totalPrinted = 0;
		for (var i=0; i<orTableGrid.geniisysRows.length; i++){
			if (orTableGrid.geniisysRows[i].recordStatus != -1){
				if(nvl(orTableGrid.geniisysRows[i].orPrintTag,"Y") == "Y"){
					totalPrinted = totalPrinted + parseFloat(unformatCurrencyValue(orTableGrid.geniisysRows[i].foreignCurrAmt));					
				}

			}
		}
		
		//to include total amounts in other pages
		if (objAC.hidObjGIACS025.variables.currCd != objAC.hidObjGIACS025.variables.defCurrCd){
			totalPrinted = parseFloat(totalPrinted) + parseFloat(orTableGrid.pager.sumPrint2);
		}else{
			totalPrinted = parseFloat(totalPrinted) + parseFloat(orTableGrid.pager.sumPrint1);
		}
	
		$("printTotal").value = formatCurrency(totalPrinted);	
	}
	
	function populateDifference(){
		var orAmt = nvl($F("grossAmt") == "" ? objAC.hidObjGIACS025.variables.nbtORAmt : $F("grossAmt"),'0');
		var exactAmt = nvl(objAC.hidObjGIACS025.variables.exactAmount,0);
		
		var diff = parseFloat((orAmt).replace(/,/g, "")) - parseFloat(($("printTotal").value).replace(/,/g, ""));
		
		exactAmt = Math.abs(exactAmt - parseFloat(($("printTotal").value).replace(/,/g, "")));
		
		exactDiff = Math.abs(diff);
		
		$("diffTotal").value = formatCurrency(diff);
		return $F("diffTotal");

	}

}catch(e){
	showErrorMessage("Error in OR Preview Main Page", e);
}
</script>