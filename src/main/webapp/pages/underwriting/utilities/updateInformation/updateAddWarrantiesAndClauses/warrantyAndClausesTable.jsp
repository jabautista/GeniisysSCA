<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-cache");
	response.setHeader("Pragma", "No-cache");
%>
<div id="wcDiv" name="wcDiv" style="margin: 10px; margin-bottom: 30px;"">
	<div id="warrClaTableGrid" style="height: 205px;"></div>
</div>

<script>
	setDocumentTitle("Update/Add Warranties and Clauses");
	setModuleId("GIPIS171");
	var pageActions = {
		none : 0,
		save : 1,
		reload : 2,
		cancel : 3
	};
	var pAction = pageActions.none;
	var maxDb = 0;
	var totalRecords = 0;
	addStyleToInputs();
	initializeAll();
	changeTag = 0;
	initializeChangeAttribute();
	hideNotice();
	objGipis171 = new Object(); //gzelle 12.14.2012 global variable
	objGipis171.saveGIPIPolWC = saveGIPIPolWC;
	var notIn = "";
	var maxPrintSeqNo = 0;
	var selectedRow = null;
	objGipis171.printSeqNoList = [];
	
	/*
	* var currentRow = -1;
	* var changeTextSw = "N";
	* var lastRowNo = 0;
	* var cond2 = true; gzelle 12.14.2012 comment out, unused 
	*/
	
	//show Warranties And Clauses of Policy in Table Grid
	try {
		var row = 0;
		var objUpdateAddWarrCla = [];
		var objWarrCla = new Object();
		objWarrCla.objUpdateAddWarrClaList = []; 
		objWarrCla.objUpdateAddWarrClaUtil = objWarrCla.objUpdateAddWarrClaList.rows || [];
		var updateAddWarrClaTG = {
			url : contextPath + "/UpdateUtilitiesController?action=getWarrClaTableGrid",
			options : {
				width : '900px',
				height : '200px',
				hideColumnChildTitle : true,
				masterDetail : true,  //gzelle 12.17.2012
				masterDetailRequireSaving: true,  //gzelle 12.17.2012
				onCellFocus : function(element, value, x, y, id) {
					row = y;
					objWarrClaUtil = objGipis171.warrClaUtilTableGrid.geniisysRows[y];
					var obj = objGipis171.warrClaUtilTableGrid.geniisysRows[y];
					$("btnAdd").value = "Update";
					enableButton("btnDelete");
					
					selectedRow = objGipis171.warrClaUtilTableGrid.geniisysRows[y];
					disableSearch("searchWarrantyTitle");
					$("txtWarrantyTitle").disabled = true;
					
					//commented out by Kris 05.27.2013
					/*if (obj.recordStatus === "") {
						disableSearch("searchWarrantyTitle");
						disableInputField("txtWarrantyTitle");
					} else {
						enableSearch("searchWarrantyTitle");
						enableInputField("txtWarrantyTitle");
					}*/
					populateWarrantyAndClauseDetails(obj);
					objGipis171.warrClaUtilTableGrid.keys.releaseKeys();
					$("hidWcTitle").value = $("txtWarrantyTitle").value;
				},
				checkChanges: function(){  //gzelle 12.17.2012 - requires saving if there are changes
					return (changeTag == 1 ? true : false);
				},
				masterDetailValidation: function(){  //gzelle 12.17.2012
					return (changeTag == 1 ? true : false);
				},
				masterDetailNoFunc: function(){  //gzelle 12.17.2012
					return (changeTag == 1 ? true : false);
				},
				onCellBlur : function(element, value, x, y, id) {
					observeChangeTagInTableGrid(warrClaTableGrid);
				},
				onRemoveRowFocus : function() {
					selectedRow = null;
					formatAppearance();
				},
				beforeSort : function() {
					if (changeTag == 1) {
						/* showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
							function() {
								pAction = pageActions.reload;
								saveGIPIPolWC();
							}, function() {
								showUpdateAddWarrantiesAndClauses();
								changeTag = 0;
							}, ""); */
						showMessageBox("Please save changes first.", "I");	
						return false;
					} else {
						return true;
					}
				},
				prePager: function(){
					if (changeTag == 1) {
						showMessageBox("Please save changes first.", "I");						
						return false;
					} else {
						return true;
					}
				},
				onSort : function() {
					objGipis171.warrClaUtilTableGrid.onRemoveRowFocus();
				},
				onRefresh : function() {
					formatAppearance();
				},
				toolbar : {
					elements : [ MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN ],
					onFilter : function() {
						formatAppearance();
					},
				}
			},
			columnModel : [ 
			{
				id : 'recordStatus',
				width : '0',
				visible : false,
				editor : 'checkbox'
			}, {
				id : 'divCtrId',
				width : '0',
				visible : false
			}, {
				id : 'policyId',
				width : '0',
				title : 'Policy Id',
				visible : false
			}, {
				id : 'lineCd',
				width : '0',
				visible : false
			}, 
			{
				id: 'wcTitle wcTitle2',
				title:'Warranty Title',
				width: 270,
				align: 'left',
				children: [
			    	   	    {	id: 'wcTitle',
						    	width: 170,
						    	align: 'right',
						    	filterOption: true,	
								title:'Warranty Title'
						    },
						    {	id: 'wcTitle2',
						    	width: 100
						    }
			   	]
			},
			{
				id : 'wcSw',
				title : 'Type',
				width : '90px',
				visible : true,
			}, {
				id : 'printSeqNo',
				title : 'Prt Seq.',
				filterOption : true,
				filterOptionType: 'integerNoNegative',
				width : '73px',
				visible : true,
				align : 'right',
				titleAlign: 'right'
			}, {
				id : 'wcText',
				title : 'Warranty Text',
				width : '338px'
			}, {
				id : 'wcText01',
				width : '0',
				visible : false
			}, {
				id : 'wcText02',
				width : '0',
				visible : false
			}, {
				id : 'wcText03',
				width : '0',
				visible : false
			}, {
				id : 'wcText04',
				width : '0',
				visible : false
			}, {
				id : 'wcText05',
				width : '0',
				visible : false
			}, {
				id : 'wcText06',
				width : '0',
				visible : false
			}, {
				id : 'wcText07',
				width : '0',
				visible : false
			}, {
				id : 'wcText08',
				width : '0',
				visible : false
			}, {
				id : 'wcText09',
				width : '0',
				visible : false
			}, {
				id : 'wcText10',
				width : '0',
				visible : false
			}, {
				id : 'wcText11',
				width : '0',
				visible : false
			}, {
				id : 'wcText12',
				width : '0',
				visible : false
			}, {
				id : 'wcText13',
				width : '0',
				visible : false
			}, {
				id : 'wcText14',
				width : '0',
				visible : false
			}, {
				id : 'wcText15',
				width : '0',
				visible : false
			}, {
				id : 'wcText16',
				width : '0',
				visible : false
			}, {
				id : 'wcText17',
				width : '0',
				visible : false
			}, {
				id : 'wcCd',
				width : '0',
				visible : false
			}, {
				id : 'printSw',
				title : 'P',
				width : '25px',
				alt : 'Print Switch',
				align : 'center',
				titleAlign : 'center',
				sortable : false,
				defaultValue : false,
				otherValue : false,
				editor : new MyTableGrid.CellCheckbox({
					getValueOf : function(value) {
						if (value) {
							return "Y";
						} else {
							return "N";
						}
					}
				})
			}, {
				id : 'changeTag',
				title : 'C',
				width : '25px',
				titleAlign : 'center',
				visible : true,
				sortable : false,
				alt : 'Change Tag',
				defaultValue : false,
				otherValue : false,
				editor : new MyTableGrid.CellCheckbox({
					getValueOf : function(value) {
						if (value) {
							return "Y";
						} else {
							return "N";
						}
					}
				})
			} ],
			onSelect : function(row) {
				$("hidPolicyId").value = row.policyNo;
				$("hidLineCd").value = row.lineCd;
			},
			rows : []
		};
		objGipis171.warrClaUtilTableGrid = new MyTableGrid(updateAddWarrClaTG);
		objGipis171.warrClaUtilTableGrid.pager =  objWarrCla.objUpdateAddWarrClaList; 
		objGipis171.warrClaUtilTableGrid.render("warrClaTableGrid");
		objGipis171.warrClaUtilTableGrid.afterRender = function() {
			objUpdateAddWarrCla = objGipis171.warrClaUtilTableGrid.geniisysRows;
			getCurrentList();
			getPrintSeqNoList();
		};

	} catch (e) {
		showErrorMessage("Update Add Warranties And Clauses Table Grid", e);
	}
	
	// kris 05.21.2013: gets the current list in tablegrid and save into global var for use when navigating to other page
	function getCurrentList(){
		var isExisting = false;
		if(objGipis171.warrClaList == null || objGipis171.warrClaList.length == 0){
			objGipis171.warrClaList = [];
			getWcCdList();
		} else {
			for(var z=0; z<objUpdateAddWarrCla.length; z++){
				for(var y=0; y<objGipis171.warrClaList.length; y++){
					if(objGipis171.warrClaList[y] == objUpdateAddWarrCla[z].wcCd){
						isExisting = true;						
						break;
					}					
				}
				if(!isExisting){
					objGipis171.warrClaList.push(objUpdateAddWarrCla[z].wcCd);
				}
			}
		}
		//showMessageBox("currList: "+objGipis171.warrClaList, "I");
	}
	
	function getWcCdList(){
		try{
			new Ajax.Request(contextPath + "/UpdateUtilitiesController", {
				method: "POST",
				parameters: {
					action : "getCurrentWcCdList",
					policyId : $F("hidPolicyId") 
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response) {
					if (response.responseText != "" && response.responseText != "{}") {
						var tempArr = eval(response.responseText);
						for(var i=0; i<tempArr.length; i++){
							objGipis171.warrClaList.push(tempArr[i]);
						}
					}
				}
			});		
		}catch(e){
			showErrorMessage("getWcCdList", e);
		}
	}
	
	function getPrintSeqNoList(){
		try{
			new Ajax.Request(contextPath + "/UpdateUtilitiesController", {
				method: "POST",
				parameters: {
					action : "getWarrClaPrintSeqNoList",
					policyId : $F("hidPolicyId") 
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response) {
					if (response.responseText != "" && response.responseText != "{}") {
						var tempArr = eval(response.responseText);
						for(var i=0; i<tempArr.length; i++){
							objGipis171.printSeqNoList.push(tempArr[i]);
						}
					}
				}
			});		
		}catch(e){
			showErrorMessage("getPrintSeqNoList", e);
		}		
	}

	//set the details of Warranties and Clauses to input types
	function populateWarrantyAndClauseDetails(obj) {
		try {
			$("hidWcCd").value 				= obj == null ? "" : nvl(obj.wcCd, "");
			$("hidWcCd2").value 			= obj == null ? "" : nvl(obj.wcCd, "");
			$("txtWarrantyTitle").value 	= obj == null ? "" : unescapeHTML2(nvl(obj.wcTitle, ""));
			$("inputWarrantyTitle2").value 	= obj == null ? "" : unescapeHTML2(nvl(obj.wcTitle2, ""));
			$("inputWarrantyType").value 	= obj == null ? "" : unescapeHTML2(nvl(obj.wcSw, ""));
			$("inputPrintSeqNo").value 		= obj == null ? "" : nvl(obj.printSeqNo,"");
			$("inputPrintSwitch").checked 	= obj == null ? "" : (nvl(obj.printSw, "") == 'Y' ? true : false);
			$("inputChangeTag").checked 	= obj == null ? "" : (nvl(obj.changeTag, "") == 'Y' ? true : false);
			$("inputWarrantyText").value 	= obj == null ? "" : unescapeHTML2(nvl(obj.wcText, "")); 
			$("inputWcRemarks").value 		= obj == null ? "" : unescapeHTML2(nvl(obj.wcRemarks, ""));
			$("hidOrigWarrantyText").value 	= obj == null ? "" : unescapeHTML2(nvl(obj.wcText, ""));
		} catch (e) {
			showErrorMessage("populateWarrantyAndClauseDetails", e);
		}
	}

	//set warranties and clauses object
	function setWarrClaObject() {
		try {
			var objWarrClauses = new Object();
			var wcText = $("inputChangeTag").checked ? $F("inputWarrantyText") : $F("hidOrigWarrantyText");
			
			objWarrClauses.policyId		= escapeHTML2($F("hidPolicyId"));
			objWarrClauses.wcCd 		= $F("hidWcCd"); //escapeHTML2($F("hidWcCd")); removed escapeHTML2 by robert SR 5155 11.04.15
			objWarrClauses.wcCd2 		= $F("hidWcCd2"); //escapeHTML2($F("hidWcCd")); removed escapeHTML2 by robert SR 5155 11.04.15
			objWarrClauses.lineCd 		= escapeHTML2($F("hidLineCd"));
			objWarrClauses.wcSw 		= escapeHTML2($("inputWarrantyType").value);
			objWarrClauses.wcTitle 		= escapeHTML2($F("txtWarrantyTitle"));
			objWarrClauses.wcTitle2 	= escapeHTML2($F("inputWarrantyTitle2"));
			objWarrClauses.wcRemarks 	= escapeHTML2($F("inputWcRemarks"));
			objWarrClauses.wcText 		= escapeHTML2(wcText);
			objWarrClauses.wcText01 	= escapeHTML2(wcText.substring(0, 2000));
			objWarrClauses.wcText02 	= escapeHTML2(wcText.substring(2001, 4000));
			objWarrClauses.wcText03		= escapeHTML2(wcText.substring(4001, 6000));
			objWarrClauses.wcText04 	= escapeHTML2(wcText.substring(6001, 8000));
			objWarrClauses.wcText05 	= escapeHTML2(wcText.substring(8001, 10000));
			objWarrClauses.wcText06 	= escapeHTML2(wcText.substring(10001, 12000));
			objWarrClauses.wcText07 	= escapeHTML2(wcText.substring(12001, 14000));
			objWarrClauses.wcText08 	= escapeHTML2(wcText.substring(14001, 16000));
			objWarrClauses.wcText09 	= escapeHTML2(wcText.substring(16001, 18000));
			objWarrClauses.wcText10 	= escapeHTML2(wcText.substring(18001, 20000));
			objWarrClauses.wcText11 	= escapeHTML2(wcText.substring(20001, 22000));
			objWarrClauses.wcText12 	= escapeHTML2(wcText.substring(22001, 24000));
			objWarrClauses.wcText13 	= escapeHTML2(wcText.substring(24001, 26000));
			objWarrClauses.wcText14 	= escapeHTML2(wcText.substring(26001, 28000));
			objWarrClauses.wcText15 	= escapeHTML2(wcText.substring(28001, 30000));
			objWarrClauses.wcText16 	= escapeHTML2(wcText.substring(30001, 32000));
			objWarrClauses.wcText17 	= escapeHTML2(wcText.substring(32001, 34000));
			objWarrClauses.changeTag 	= $("inputChangeTag").checked ? "Y" : "N";
			objWarrClauses.printSw 		= $("inputPrintSwitch").checked ? "Y" : "N";
			objWarrClauses.tbgChangeTag = $("inputChangeTag").checked ? true : false;
			objWarrClauses.tbgPrintSw 	= $("inputPrintSwitch").checked ? true : false;
			objWarrClauses.printSeqNo 	= $("inputPrintSeqNo").value;
			objWarrClauses.userId 		= userId;
			objWarrClauses.recordStatus = "";

			return objWarrClauses;
		} catch (e) {
			showErrorMessage("setWCObject", e);
		}
	}

	//function to add or update warranties and clauses in table grid
	function addWarrCla() {		
		try {
			var newObj = setWarrClaObject();
			if (checkWCRequiredFields() && checkRemarksLength() && checkWarrantyTextLength()) {
				//button = Update
				if ($F("btnAdd") == "Update") {
					for ( var i = 0; i < objUpdateAddWarrCla.length; i++) {
						if ((objUpdateAddWarrCla[i].wcCd == newObj.wcCd2) && (objUpdateAddWarrCla[i].recordStatus != -1)) {
							newObj.recordStatus = 1;
							objUpdateAddWarrCla.splice(i, 1, newObj);
							objGipis171.warrClaUtilTableGrid.updateVisibleRowOnly(newObj,objGipis171.warrClaUtilTableGrid.getCurrentPosition()[1]);
							$("hidWcCd3").value = $("hidWcCd").value;
							$("hidWcText").value = $("inputWarrantyText").value;
							updatePrintSeqnoList("Update", selectedRow.printSeqNo, newObj.printSeqNo);								
						}
					}
				} else { //button = Add
					$("hidWcCd3").value = $("hidWcCd").value;
					newObj.recordStatus = 0;
					objUpdateAddWarrCla.push(newObj);
					objGipis171.warrClaUtilTableGrid.addBottomRow(newObj);
					updatePrintSeqnoList("Update", null, newObj.printSeqNo);						
				}
				changeTag = 1;
				formatAppearance();
			}
		} catch (e) {
			showErrorMessage("addWarrCla", e);
		}
	}

	//set the values of warranties and clauses details to default
	function formatAppearance() {
		try {
			$("btnAdd").value = "Add";
			disableButton("btnDelete");
			enableSearch("searchWarrantyTitle");
			populateWarrantyAndClauseDetails(null);
			objGipis171.warrClaUtilTableGrid.keys.releaseKeys();
		} catch (e) {
			showErrorMessage("formatAppearance", e);
		}
	}

	//reset the warranty text if the user decided to not update the warranty text
	function resetText() {
		try {
			var defaultText = "";
			if ($F("inputWarrantyText") != "") {
				defaultText = $F("hidOrigWarrantyText");
			}
			$("inputWarrantyText").value = defaultText;
			$("inputChangeTag").checked = false;
		} catch (e) {
			showErrorMessage("resetText", e);
		}
	}

	//set value of input type change tag to true
	function checkChangeTag() {
		$("inputChangeTag").checked = true;
	}

	//set the value of input type change tag if the user updated the warranty text
	//set the warranty text to default value when user decided not to update warranty text
	/*$("inputWarrantyText").observe("change", function() {
		if (!$("inputChangeTag").checked) {
			showConfirmBox("Confirm", "Do you really want to change this text?", "Yes", "No", 
					function() {
						$("inputChangeTag").checked = true;
						limitText($("inputWarrantyText"), 32767);}, //gzelle 12.14.2012 changed charLimit
					function() {
						$("inputWarrantyText").value = $F("hidOrigWarrantyText");
						limitText($("inputWarrantyText"), 32767);  //gzelle 12.14.2012
					});
		} else {
			limitText($("inputWarrantyText"), 32767);  //gzelle 12.14.2012
		}
	});*/

	//validation for print sequence number
	$("inputPrintSeqNo").observe("change", function() {
		var wcPrintSeqNo = this.value;
		if (parseInt(wcPrintSeqNo) > 99 || parseInt(wcPrintSeqNo) < 1 || wcPrintSeqNo.include(".") || isNaN(parseFloat(wcPrintSeqNo))) {
			showMessageBox("Invalid Print Sequence No. Valid value should be from 1 to 99.");
			$("inputPrintSeqNo").clear();
			$("inputPrintSeqNo").focus();
		} else if (checkIfPrintSeqNoExist(wcPrintSeqNo)) {
			showMessageBox("Print Sequence No. must be unique.", imgMessage.INFO);
			$("inputPrintSeqNo").clear();
			$("inputPrintSeqNo").focus();
		}
		$("inputPrintSeqNo").value = parseInt(this.value);
	});

	//check if printseqno already exists
	function checkIfPrintSeqNoExist(printSeqNo) {
		try {
			var exist = false;
			/* for ( var i = 0; i < objUpdateAddWarrCla.length; i++) {
				if (printSeqNo == objUpdateAddWarrCla[i].printSeqNo && objUpdateAddWarrCla[i].recordStatus != -1) {
					exist = true;					
				}
			} */
			for(var x=0; x<objGipis171.printSeqNoList.length; x++){
				for ( var i = 0; i < objUpdateAddWarrCla.length; i++) {
					if (objUpdateAddWarrCla[i].printSeqNo == objGipis171.printSeqNoList[x] && printSeqNo == objUpdateAddWarrCla[i].printSeqNo && objUpdateAddWarrCla[i].recordStatus != -1) {
						exist = true;	
						break;
					}
				}
				if(!exist){
					if(printSeqNo == objGipis171.printSeqNoList[x]){
						exist = true;	
						break;
					}
				}
			}
			if(exist){
				if(selectedRow == null){
					exist = true;
				}else if(selectedRow != null && selectedRow.printSeqNo == printSeqNo){
					exist = false;	
				}
			}
			return exist;
		} catch (e) {
			showErrorMessage("checkIfPrintSeqNoExist", e);
		}
	}

	// val1  the value to delete when func == delete || update
	// val2 the value to add when func == update || add
	function updatePrintSeqnoList(func, toDelete, toAdd){
		if(func == "Delete" || func == "Update"){
			for(var d=0; d<objGipis171.printSeqNoList.length; d++){
				if(toDelete == objGipis171.printSeqNoList[d]){
					objGipis171.printSeqNoList.splice(d, 1);
					break;
				}				
			}
		} 

		if(func == "Add" || func == "Update"){
			objGipis171.printSeqNoList.push(toAdd);
		}
	}
	
	//function to delete warranty and clauses in table grid
	function deleteWarrCla() {
		try {
			var delNo = 0;
			var delObj = setWarrClaObject();
			for ( var i = 0; i < objUpdateAddWarrCla.length; i++) {
				if ((objUpdateAddWarrCla[i].wcCd == delObj.wcCd2) && (objUpdateAddWarrCla[i].recordStatus != -1)) {
					delObj.recordStatus = -1;
					objUpdateAddWarrCla.splice(i, 1, delObj);
					objGipis171.warrClaUtilTableGrid.deleteRow(objGipis171.warrClaUtilTableGrid.getCurrentPosition()[1]);
					changeTag = 1;
					$("hidWcCd3").value = $("hidWcCd").value;
					delNo = parseInt(delObj.printSeqNo);					
				}
			}
			updatePrintSeqnoList("Delete", delNo, null);
			formatAppearance();
		} catch (e) {
			showErrorMessage("deleteWarrCla()", e);
		}
	}

	//to generate the print seq number when adding new warranty and clauses
	function generatePrintSeqNo() {
		var max = parseInt(0);
		for(var x=0; x<objGipis171.printSeqNoList.length; x++){
			if(objGipis171.printSeqNoList[x] > max){
				max = parseInt(objGipis171.printSeqNoList[x]);
			}
		}
		max = parseInt(max)+1;
		return 	max;
		
		//commented out by Kris 05.27.2013
		/*var max = 0;
		for ( var i = 0; i < objUpdateAddWarrCla.length; i++) {
			if (parseInt(objUpdateAddWarrCla[i].printSeqNo) > max && objUpdateAddWarrCla[i].recordStatus != -1) {
				max = parseInt(objUpdateAddWarrCla[i].printSeqNo);
			}
		}
		if (totalRecords > 10) {
			if (parseInt(maxDb) > parseInt(max)) {
				max = parseInt(maxDb);
			}
		}
		return (parseInt(max) + 1);*/
	}

	//check the required fields if they already have a value
	function checkWCRequiredFields() {
		try {
			var isOk = true;
			var fields = [ "txtWarrantyTitle", "inputPrintSeqNo", "txtPolLineCd", "txtParLineCd" ];

			for ( var i = 0; i < fields.length; i++) {
				if ($(fields[i]).value.blank()) {
					showMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR);
					isOk = false;
				}
			}
			return isOk;
		} catch (e) {
			showErrorMessage("checkWCRequiredFields", e);
		}
	}

	//check the length of remarks if it exceeded the allowed number of characters
	function checkRemarksLength() {
		try {
			var isNotLimit = true;
			if ($("inputWcRemarks").value.length > 2000) {  //gzelle 12.14.2012 changed charLimit
				showMessageBox('You have exceeded the maximum number of allowed characters (2000) for Remarks field.',imgMessage.ERROR);
				isNotLimit = false;
			}
			return isNotLimit;
		} catch (e) {
			showErrorMessage("checkRemarksLength", e);
		}
	}

	//check the length of warranty text if it exceeded the allowed number of characters
	function checkWarrantyTextLength() {
		try {
			var isNotLimit = true;
			if ($("inputWarrantyText").value.length > 32767) { //gzelle 12.14.2012 changed charLimit
				showMessageBox('You have exceeded the maximum number of allowed characters (32767) for Warranty Text field.',imgMessage.ERROR);
				isNotLimit = false;
			}
			return isNotLimit;
		} catch (e) {
			showErrorMessage("checkWarrantyTextLength", e);
		}
	}
	
	//call the LOV of warranties and clauses
	$("searchWarrantyTitle").observe("click", function(){
		var notIn = "";
		var withPrevious = false;
		var isExisting = false;
		
		/*for ( var i = 0; i < objUpdateAddWarrCla.length; i++) {
			if (objUpdateAddWarrCla[i].recordStatus != -1) {
				if(withPrevious) notIn += ",";
				notIn += "'"+(objUpdateAddWarrCla[i].wcCd).replace(/&#38;/g,'&')+"'";
				withPrevious = true;
			} 
		}*/ 
		
		// begin:: previous for loop commented out by Kris 05.21.2013 and added the following blocks of code
		
		// (1) traverse the table grid to get newly added warranties/clauses
		for ( var i = 0; i < objUpdateAddWarrCla.length; i++) {
			isExisting = false;
			for(var y=0; y<objGipis171.warrClaList.length; y++){
				if(objUpdateAddWarrCla[i].wcCd == objGipis171.warrClaList[y] && objUpdateAddWarrCla[i].recordStatus != -1){
					isExisting = true;
					break;
				} else if(objUpdateAddWarrCla[i].wcCd == objGipis171.warrClaList[y] && objUpdateAddWarrCla[i].recordStatus == -1){
					objGipis171.warrClaList.splice(y, 1);
					//isExisting = true;
					//break;
				}
			}
			if(!isExisting){
				if (objUpdateAddWarrCla[i].recordStatus != -1) {
					if(withPrevious) notIn += ",";
					notIn += "'"+(objUpdateAddWarrCla[i].wcCd).replace(/&#38;/g,'&')+"'";
					withPrevious = true;
				} 
			}			
		}
		
		// (2) traverse first the global list and add into notIn
		for(var y=0; y<objGipis171.warrClaList.length; y++){
			if(withPrevious) notIn += ",";
			notIn += "'"+(objGipis171.warrClaList[y]).replace(/&#38;/g,'&')+"'";
			withPrevious = true;
		}
		// end:: Kris 05.21.2013
		
		notIn = (notIn != "" ? "("+notIn+")" : "");
		showWarrantyAndClauseLOV2($("hidLineCd").value, notIn, $("btnAdd").value==="Update"?$F("inputPrintSeqNo") : generatePrintSeqNo(), $("txtWarrantyTitle").value);
	});
	
	/*
	*validation for warrcla lov
	*gzelle 12.27.2012
	*/
	function validateWarrCla(wcTitle) {
		new Ajax.Request(contextPath + "/UpdateUtilitiesController", {
			method: "POST",
			parameters: {
				action : "validateWarrCla",
				wcTitle : wcTitle
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (response.responseText == '0') {
					showWarrantyAndClauseLOV2("", "", "", wcTitle);
				} else if(response.responseText == '1') {
					$("hidWcTitle").value = $("txtWarrantyTitle").value;
				} else if (response.responseText.include("Sql")) {
					showWarrantyAndClauseLOV2($("hidLineCd").value, notIn, $("btnAdd").value=="Update"?$F("inputPrintSeqNo") : generatePrintSeqNo(), wcTitle);
				}
			}
		});			
	}

	//function to save the warranties and clauses to database
	function saveGIPIPolWC() {
		try {
			var setRows = getAddedAndModifiedJSONObjects(objGipis171.warrClaUtilTableGrid.geniisysRows);
			var delRows = objGipis171.warrClaUtilTableGrid.getDeletedRows();

			new Ajax.Request(contextPath + "/UpdateUtilitiesController", {
				method : "POST",
				parameters : {
					action : "saveGIPIPolWCTableGrid",
					setRows : prepareJsonAsParameter2(setRows), //Modified by Jerome Bautista 09.08.2015 SR 4918
					delRows : prepareJsonAsParameter2(delRows) //Modified by Jerome Bautista 09.08.2015 SR 4918
				},
				onComplete : function(response) {
					if (checkErrorOnResponse(response)) {
						if ("SUCCESS" == response.responseText) {
							showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
							objGipis171.warrClaUtilTableGrid.refresh();
							$("hidWcTitle").value = "";
							
							// added by Kris 05.22.2013
							objGipis171.warrClaList = null;
							getCurrentList();
						}
						changeTag = 0;
						lastAction();
						lastAction = "";
						pAction = pageActions.none;
						clearObjectRecordStatus(objParameters);
						formatAppearance();
					}
				}
			});
			
		} catch (e) {
			showErrorMessage("saveGIPIPolWC", e);
		}
	}
	
	$("editWarrantyText").observe("click", function(){
		//showEditor("inputWarrantyText", 32767,'false');
		
		if (!$("inputChangeTag").checked) {
			showConfirmBox("Confirm", "Do you really want to change this text?", "Yes", "No", 
					function() {
						$("inputChangeTag").checked = true;
						showEditor("inputWarrantyText", 32767,'false');},
					function() {
						$("inputWarrantyText").value = $F("hidOrigWarrantyText");
						//showEditor("inputWarrantyText", 32767,'false');
					});			
		} else {
			showEditor("inputWarrantyText", 32767,'false');
		}
	});

	
	//to show text editors and limit the allowed characters to input
	/*$("editWarrantyText").observe("click", function() {
		showEditor2("inputWarrantyText", 32767, "Confirm", "Do you really want to change this text?", resetText,checkChangeTag);
	});*///gzelle - 12.14.2012 changed charLimit
	
	//gzelle - 12.14.2012 changed to showOverlayEditor
	$("editWcRemarks").observe("click", function() {
		/*showOverlayEditor("inputWcRemarks", 2000, $("inputWcRemarks").hasAttribute("readonly"), function() {
			limitText($("inputWcRemarks"),2000);
		});*/
		
		showEditor("inputWcRemarks", 2000,'false'); // added by Kris 05.21.2013
	});

	$("editWarrantyTitle2").observe("click", function() {
		/*showOverlayEditor("inputWarrantyTitle2", 100, $("inputWarrantyTitle2").hasAttribute("readonly"), function() {
			limitText($("inputWarrantyTitle2"),100);
		});*/
		showEditor("inputWarrantyTitle2", 100,'false'); // added by Kris 06.08.2013
	});

	
	$("inputWarrantyText").observe("keyup", function() {
		//limitText(this, 32767);  //gzelle 12.14.2012 changed charLimit
		
		//modified by Kris 05.21.2013
		if(checkWarrantyTextLength()){
			if (!$("inputChangeTag").checked) {
				showConfirmBox("Confirm", "Do you really want to change this text?", "Yes", "No", 
						function() {
							$("inputChangeTag").checked = true;
							limitText($("inputWarrantyText"), 32767);},
						function() {
							$("inputWarrantyText").value = $F("hidOrigWarrantyText");
						});			
			} else {
				limitText($("inputWarrantyText"), 32767);
			}
		}
	});

	$("inputWcRemarks").observe("keyup", function() {
		limitText($("inputWcRemarks"), 2000); //gzelle 12.14.2012 changed charLimit
	});
	
	$("inputWcRemarks").observe("change", function() {
		limitText($("inputWcRemarks"), 2000); //gzelle 12.14.2012 changed charLimit
	});
	
	//validate warranty title
	$("txtWarrantyTitle").observe("change", function() {
		if ($("txtWarrantyTitle").value != "") {
			validateWarrCla($("txtWarrantyTitle").value);
		}
	});

	//call function addWarrCla() when add button was clicked.
	$("btnAdd")
			.observe(
					"click",
					function() {
						if ($("inputPrintSeqNo").value > 99) { //gzelle 12.18.2012 validation for print seq.
							showMessageBox("Invalid Print Sequence No. Valid value should be from 1 to 99.");
							$("inputPrintSeqNo").clear();
							$("inputPrintSeqNo").focus();
						} else {
							addWarrCla();
							$("hidWcTitle").value = "";
						}						
					});

	//call function deleteWarrCla() when delete button was clicked
	$("btnDelete").observe("click", function() {
		deleteWarrCla();
	});

	//call the function saveGIPIPolWC() when clicking the save button
	observeSaveForm("btnSave", function() {
		pAction = pageActions.save;
		saveGIPIPolWC();
	});

	//go back to underwriting main page when clicking Cancel button
	observeCancelForm("btnCancel", function() {
		pAction = pageActions.save;
		saveGIPIPolWC();
	}, function() {
		changeTag = 0;
		goToModule("/GIISUserController?action=goToUnderwriting",
				"Underwriting Main", null);
	});

	
	/**
	 *$("btnSave").observe("click", function() {
	 *	if (changeTag == 0) {
	 *		showMessageBox(objCommonMessage.NO_CHANGES, "I");
	 *	} else {
	 *		pAction = pageActions.save;
	 *		saveGIPIPolWC();
	 *	}
	 *}); 
	 *
	 *$("btnCancel").observe("click", function() {
	 *	goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	 *}); 
	 */

	/* 
	 *$("editWcRemarks").observe("click", function() { gzelle - 12.14.2012
	 *	showEditor("inputWcRemarks", 2000);
	 *});
	 *
	 *$("editWarrantyTitle2").observe("click", function() {
	 *	showEditor("inputWarrantyTitle2", 100);
	 *});
	 */

	/*
	//this will check if the user still have changes in warranties and clauses
	 *function checkPendingRecord() { gzelle 12.14.2012 - comment out, unused
	 *	var cond = true;
	 *	cond2 = true;
	 *	if ($("btnAdd").value == "Update") {
	 *		var message = "You have changes in Warranties and Clauses portion. Press Update button first to apply changes otherwise unselect the Warranties and Clauses record to clear changes.";
	 *		showMessageBox(message);
	 *		cond = false;
	 *		cond2 = false;
	 *	} else if ($("txtWarrantyTitle").value != ""
	 *			|| $("inputWarrantyTitle2").value != ""
	 *			|| $("inputPrintSeqNo").value != ""
	 *			|| $("inputWarrantyType").value != ""
	 *			|| $("inputWarrantyText").value != ""
	 *			|| $("inputWcRemarks").value != "") {
	 *		var message = "You have changes in Warranties and Clauses portion. Press Add button first to apply changes.";
	 *		showMessageBox(message);
	 *		cond = false;
	 *		cond2 = false;
	 *	}
	 *	return cond;
	 *} 
	 */
	 
</script>