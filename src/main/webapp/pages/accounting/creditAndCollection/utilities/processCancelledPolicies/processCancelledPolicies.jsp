<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="processCancelledPoliciesMainDiv" name="processCancelledPoliciesMainDiv" style="float: left; margin-bottom: 50px; width: 100%">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Payment Processing for Cancelled Policies</label>
		</div>
	</div>
	<div class="sectionDiv" id="processCancelledPoliciesDiv"> <!-- FGIC SR-4266 : shan 05.21.2015 -->
		<div id="processCancelledPoliciesTableDiv" style="padding: 10px 0 0 10px;">
			<div id="processCancelledPoliciesTable" style="height: 340px; padding: 3px 0 0 3px;"></div>
		</div>
		<div class="buttonDiv" id="buttonDiv" align="center" style="float: left; width: 100%; margin: 20px 0 0 0;"> <!-- FGIC SR-4266 : shan 05.21.2015 -->
			<input type="button" class="button" id="btnDetails" name="btnDetails" value="Details" style="width: 100px;"/>
			<input type="button" class="button" id="btnProcess" name="btnProcess" value="Process" style="width: 100px;"/>
			<input type="button" class="button" id="btnCheckAll" name="btnCheckAll" value="Check All" style="width: 100px;"/>
		</div>
		<div class="buttonDiv" id="buttonDiv2" align="center" style="float: left; width: 100%; margin: 5px 0 20px 0;"> <!-- start FGIC SR-4266 : shan 05.21.2015 -->
			<input type="button" class="button" id="btnReverseProcessedPol" name="btnReverseProcessedPol" value="Reverse Processed Policy" style="width: 200px;"/>
		</div>
	</div>
	<div class="sectionDiv" id="reverseCancelledPoliciesDiv">
		<div id="reverseCancelledPoliciesTableDiv" style="padding: 10px 0 0 10px;">
			<div id="reverseCancelledPoliciesTable" style="height: 340px; padding: 3px 0 0 3px;"></div>
		</div>
		<div class="buttonDiv" id="buttonDiv3" align="center" style="float: left; width: 100%; margin: 20px 0 20px 0;">
			<input type="button" class="button" id="btnDetailsReverse" name="btnDetailsReverse" value="Details" style="width: 100px;"/>
			<input type="button" class="button" id="btnReverseRec" name="btnReverseRec" value="Reverse" style="width: 100px;"/>
			<input type="button" class="button" id="btnCheckAllReverse" name="btnCheckAllReverse" value="Check All" style="width: 100px;"/>
			<input type="button" class="button" id="btnReturnReverse" name="btnReturnReverse" value="Return" style="width: 100px;"/>
		</div> <!-- end FGIC SR-4266 : shan 05.21.2015 -->
	</div>
</div>

<script>
	initializeAll();
	setModuleId("GIACS412");
	setDocumentTitle("Payment Processing for Cancelled Policies");
	objACGlobal.hidGIACS412Obj = {};
	disableButton("btnDetails");
	var userAccessRP = '${userAccessRP}';	// start FGIC SR-4266 : shan 05.21.2015
	var reversePolCanvas = false;
	taggedPolForReverse = [];
	
	if (userAccessRP == 'TRUE'){
		enableButton("btnReverseProcessedPol");
	}else{
		disableButton("btnReverseProcessedPol");		
	}
	
	$("reverseCancelledPoliciesDiv").hide();
	disableButton("btnDetailsReverse");	// end FGIC SR-4266 : shan 05.21.2015

	try {
		//var objCancelledPol = getAllCancelledPol();
		var objCancelledPol = [];//added by pjsantos 10/27/2016, for optimization GENQA 5753
		//objCancelledPol = getAllCancelledPol();
		var selectedObj = new Object();
		var jsonCancelledPol = JSON.parse('${jsonCancelledPol}');
		cancelledPolTableModel = {
			url : contextPath+ "/GIACCreditAndCollectionUtilitiesController?action=showCancelledPolicies&refresh=1",
			options : {
				width : '894px',
				height : '340px',
				pager : {},
				validateChangesOnPrePager : false,
				onCellFocus : function(element, value, x, y, id) {
					selectedObj = tbgCancelledPol.geniisysRows[y];
					//added by pjsantos 10/27/2016, GENQA 5753
					var checkFound = "N";
					 for ( var i = 0; i < objCancelledPol.length; i++) {
						if (objCancelledPol[i] == selectedObj.policyId) {
							checkFound = "Y";
							break;
						}
					}
					//pjsantos end
					if (checkFound = "N"){
						objCancelledPol.push(selectedObj);
					} 
					populateEndorsement(selectedObj);
				},
				onRowDoubleClick: function(y){
					var obj = tbgCancelledPol.geniisysRows[y];
					populateEndorsement(obj);
					endorsementOverlay();
					tbgCancelledPol.keys.releaseKeys();
				},
				postPager : function() {
					populateEndorsement(null);
					tbgCancelledPol.keys.removeFocus(tbgCancelledPol.keys._nCurrentFocus, true);
					tbgCancelledPol.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					populateEndorsement(null);
					tbgCancelledPol.keys.removeFocus(tbgCancelledPol.keys._nCurrentFocus, true);
					tbgCancelledPol.keys.releaseKeys();
				},
				onSort : function() {
					populateEndorsement(null);
					tbgCancelledPol.keys.removeFocus(tbgCancelledPol.keys._nCurrentFocus, true);
					tbgCancelledPol.keys.releaseKeys();
				},
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
					onFilter : function() {
						populateEndorsement(null);
						tbgCancelledPol.keys.removeFocus(tbgCancelledPol.keys._nCurrentFocus, true);
						tbgCancelledPol.keys.releaseKeys();
					},
					onRefresh : function() {
						populateEndorsement(null);
						tbgCancelledPol.keys.removeFocus(tbgCancelledPol.keys._nCurrentFocus, true);
						tbgCancelledPol.keys.releaseKeys();
					},
				}
			},
			columnModel : [
					{
						id : 'recordStatus',
						title : '',
						width : '0',
						visible : false
					},
					{
						id : 'divCtrId',
						width : '0',
						visible : false
					},
					{	id : 'tag',
				    	title: 'I',
				    	align: 'center',
				    	titleAlign: 'center',
				    	width: '30px',
				    	maxlength: 1, 
				    	sortable: false,
				    	editable: true,
				    	visible: true,
				    	editor: new MyTableGrid.CellCheckbox({ 
				    		getValueOf: function(value){
				    			if (value){
				    				return "Y";
				    			}else{
				    				return "N";	
				    			}	
				    		},
				    		onClick: function(value, checked) {
				    			var checkFound = "N";
								 for ( var i = 0; i < objCancelledPol.length; i++) {
									if (objCancelledPol[i].policyId == selectedObj.policyId) {
										objCancelledPol[i].tag = value;										
										break;
									}
								}								
								tbgCancelledPol.modifiedRows = [];
								tbgCancelledPol.keys.releaseKeys(); 
		 			    	}
				    	}),	
				    },
					{
						id : "policyNo",
						title : "Policy No.",
						width : '170px',
						filterOption: true
					},
					{
						id : "assdName",
						title : "Assured Name",
						width : '230px',
						filterOption: true
					},
					{
						id : "inceptDate",
						title : "Incept Date",
						width : '100px',
						titleAlign : 'center',
						align : 'center',
						filterOption: true,
						filterOptionType : 'formattedDate',
						renderer: function(value){
							return dateFormat(value, "mm-dd-yyyy");
						}
					},
					{
						id : "expiryDate",
						title : "Expiry Date",
						width : '100px',
						titleAlign : 'center',
						align : 'center',
						filterOption: true,
						filterOptionType : 'formattedDate',
						renderer: function(value){
							return dateFormat(value, "mm-dd-yyyy");
						}
					},
					{
						id : "tsiAmt",
						title : "TSI Amount",
						titleAlign : 'right',
						align : 'right',
						filterOptionType : 'number',
						width : '115px',
						geniisysClass: 'money',
						filterOption: true
					},
					{
						id : "premAmt",
						title : "Premium Amount",
						titleAlign : 'right',
						align : 'right',
						filterOptionType : 'number',
						width : '115px',
						geniisysClass: 'money',
						filterOption: true
					}
				],
			rows : jsonCancelledPol.rows
		};
		tbgCancelledPol = new MyTableGrid(cancelledPolTableModel);
		tbgCancelledPol.pager = jsonCancelledPol;
		tbgCancelledPol.render('processCancelledPoliciesTable');
		tbgCancelledPol.afterRender = function(){
													setCheckboxOnTBG();
											    };
	} catch (e) {
		showErrorMessage("cancelledPolTableModel", e);
	}
	
	try {	// start FGIC SR-4266 : shan 05.21.2015
		var selectedReverse = new Object();
		polForReverseTableModel = {
			url : contextPath+ "/GIACCreditAndCollectionUtilitiesController?action=getPoliciesForReverse&refresh=1",
			options : {
				width : '894px',
				height : '340px',
				pager : {},
				validateChangesOnPrePager : false,
				onCellFocus : function(element, value, x, y, id) {
					selectedReverse = tbgPolForReverse.geniisysRows[y];
					populateEndorsement(selectedReverse);
				},
				onRowDoubleClick: function(y){
					var obj = tbgPolForReverse.geniisysRows[y];
					populateEndorsement(obj);
					tbgPolForReverse.keys.releaseKeys();
				},
				postPager : function() {
					populateEndorsement(null);
					tbgPolForReverse.keys.removeFocus(tbgPolForReverse.keys._nCurrentFocus, true);
					tbgPolForReverse.keys.releaseKeys();
					recheckRows();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					populateEndorsement(null);
					tbgPolForReverse.keys.removeFocus(tbgPolForReverse.keys._nCurrentFocus, true);
					tbgPolForReverse.keys.releaseKeys();
				},
				onSort : function() {
					populateEndorsement(null);
					tbgPolForReverse.keys.removeFocus(tbgPolForReverse.keys._nCurrentFocus, true);
					tbgPolForReverse.keys.releaseKeys();
					recheckRows();
				},
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
					onFilter : function() {
						populateEndorsement(null);
						tbgPolForReverse.keys.removeFocus(tbgPolForReverse.keys._nCurrentFocus, true);
						tbgPolForReverse.keys.releaseKeys();
						$("btnCheckAllReverse").value = "Check All";
						taggedPolForReverse = [];
					},
					onRefresh : function() {
						populateEndorsement(null);
						tbgPolForReverse.keys.removeFocus(tbgPolForReverse.keys._nCurrentFocus, true);
						tbgPolForReverse.keys.releaseKeys();
						$("btnCheckAllReverse").value = "Check All";
						taggedPolForReverse = [];
					},
				}
			},
			columnModel : [
					{
						id : 'recordStatus',
						title : '',
						width : '0',
						visible : false
					},
					{
						id : 'divCtrId',
						width : '0',
						visible : false
					},
					{	id : 'tag',
				    	title: 'I',
				    	align: 'center',
				    	titleAlign: 'center',
				    	width: '30px',
				    	maxlength: 1, 
				    	sortable: false,
				    	editable: true,
				    	visible: true,
				    	editor: new MyTableGrid.CellCheckbox({ 
				    		getValueOf: function(value){
				    			if (value){
				    				return "Y";
				    			}else{
				    				return "N";	
				    			}	
				    		}
				    	}),	
				    },
					{
						id : "policyNo",
						title : "Policy No.",
						width : '170px',
						filterOption: true
					},
					{
						id : "assdName",
						title : "Assured Name",
						width : '230px',
						filterOption: true
					},
					{
						id : "inceptDate",
						title : "Incept Date",
						width : '100px',
						titleAlign : 'center',
						align : 'center',
						filterOption: true,
						filterOptionType : 'formattedDate',
						renderer: function(value){
							return dateFormat(value, "mm-dd-yyyy");
						}
					},
					{
						id : "expiryDate",
						title : "Expiry Date",
						width : '100px',
						titleAlign : 'center',
						align : 'center',
						filterOption: true,
						filterOptionType : 'formattedDate',
						renderer: function(value){
							return dateFormat(value, "mm-dd-yyyy");
						}
					},
					{
						id : "tsiAmt",
						title : "TSI Amount",
						titleAlign : 'right',
						align : 'right',
						filterOptionType : 'number',
						width : '115px',
						geniisysClass: 'money',
						filterOption: true
					},
					{
						id : "premAmt",
						title : "Premium Amount",
						titleAlign : 'right',
						align : 'right',
						filterOptionType : 'number',
						width : '115px',
						geniisysClass: 'money',
						filterOption: true
					}
				],
			rows : []
		};
		tbgPolForReverse = new MyTableGrid(polForReverseTableModel);
		tbgPolForReverse.pager = {};
		tbgPolForReverse.render('reverseCancelledPoliciesTable');
		tbgPolForReverse.afterRender = function(){
			observeCheckboxForReversal();
	    };
	} catch (e) {
		showErrorMessage("polForReverseTableModel", e);
	}	// end FGIC SR-4266 : shan 05.21.2015
	
	function setCheckboxOnTBG() {
		try {
			for ( var i = 0; i < objCancelledPol.length; i++) {
				for ( var j = 0; j < tbgCancelledPol.geniisysRows.length; j++) {
					if(objCancelledPol[i].policyId == tbgCancelledPol.geniisysRows[j].policyId){
						tbgCancelledPol.setValueAt(objCancelledPol[i].tag, tbgCancelledPol.getColumnIndex('tag'), j, true);
					}	
				}
			}
			tbgCancelledPol.modifiedRows = []; 
			$$("div.modifiedCell").each(function (a) {
				$(a).removeClassName('modifiedCell');
			});
		} catch (e) {
			showErrorMessage("setCheckboxOnTBG", e); 
		}
	}
	
	function unsetCheckboxOnTBG() {
		try {
			for ( var i = 0; i < objCancelledPol.length; i++) {
				objCancelledPol[i].tag = 'N';
			}
			$("btnCheckAll").value = 'Check All';
		} catch (e) {
			showErrorMessage("unsetCheckboxOnTBG", e); 
		}
	}
	
	function endorsementOverlay() {
		try{
			overlayEndorsement = Overlay.show(contextPath+"/GIACCreditAndCollectionUtilitiesController?action=showEndorsement&lineCd=" + objACGlobal.hidGIACS412Obj.lineCd 
																													      + "&sublineCd=" + objACGlobal.hidGIACS412Obj.sublineCd
																													      + "&issCd=" + objACGlobal.hidGIACS412Obj.issCd
																							  						      +"&issueYy=" + objACGlobal.hidGIACS412Obj.issueYy 
																							  						      +"&polSeqNo=" + objACGlobal.hidGIACS412Obj.polSeqNo
																							  						      +"&renewNo=" + objACGlobal.hidGIACS412Obj.renewNo, 
					{urlContent: true,
					 title: "Endorsement",
					 height: 400,
					 width: 835,
					 draggable: false
					});
		}catch (e) {
			showErrorMessage("endorsementOverlay",e);
		}
	}
	
	function populateEndorsement(obj) {
		try{
			objACGlobal.hidGIACS412Obj.lineCd = (obj) == null ? "" : nvl(obj.lineCd,"");
			objACGlobal.hidGIACS412Obj.sublineCd = (obj) == null ? "" : nvl(obj.sublineCd,"");
			objACGlobal.hidGIACS412Obj.issCd = (obj) == null ? "" : nvl(obj.issCd,"");
			objACGlobal.hidGIACS412Obj.issueYy = (obj) == null ? "" : nvl(obj.issueYy,"");
			objACGlobal.hidGIACS412Obj.polSeqNo = (obj) == null ? "" : nvl(obj.polSeqNo,"");
			objACGlobal.hidGIACS412Obj.renewNo = (obj) == null ? "" : nvl(obj.renewNo,"");
			objACGlobal.hidGIACS412Obj.policyNo = (obj) == null ? "" : nvl(obj.policyNo,"");
			if (obj==null) {
				disableButton("btnDetails");
				disableButton("btnDetailsReverse");	// FGIC SR-4266 : shan 05.21.2015
				
			}else{
				enableButton("btnDetails");
				enableButton("btnDetailsReverse");	// FGIC SR-4266 : shan 05.21.2015
			}
		}catch (e) {
			showErrorMessage("populateEndorsement",e);	// FGIC SR-4266 : shan 05.21.2015
		}
	}
	
	function getAllCancelledPol() {
		try{
			var result = [];
			new Ajax.Request(contextPath + "/GIACCreditAndCollectionUtilitiesController", {
			    parameters : {action : "getAllCancelledPol"},
			    asynchronous: false,
				evalScripts: true,
				onCreate: showNotice("Fetching records, please wait..."),	// FGIC SR-4266 : shan 05.21.2015
				onComplete : function(response){
					hideNotice();	// FGIC SR-4266 : shan 05.21.2015
					if(checkErrorOnResponse(response)){
						result = eval(response.responseText);
					}
				} 
			});
			return result;
		}catch(e){
			showErrorMessage("getAllCancelledPol", e); 
		}	
	}
	
	function processCancelledPol() {
		try{
			var tempArray = [];
			var objParameters = new Object();
			for ( var i = 0; i < objCancelledPol.length; i++) {
				if (objCancelledPol[i].tag == "Y") { 
					tempArray.push(objCancelledPol[i]);
				}
			}
			objParameters.cancelledPol = tempArray;
			new Ajax.Request(contextPath + "/GIACCreditAndCollectionUtilitiesController", {
			    parameters : {action : "processCancelledPol",
			    			  param : JSON.stringify(objParameters)},
			    asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice("Processing Cancelled Policies, please wait...");
				},
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						showWaitingMessageBox('Done. '+ tempArray.length +' record/s processed.', imgMessage.SUCCESS, function(){
							tbgCancelledPol.refresh();
							tbgCancelledPol.keys.releaseKeys();
						});
					}
				} 
			});
		}catch(e){
			showErrorMessage("getAllCancelledPol", e); 
		}	
	}
	
	/* observe */
	$("mtgRefreshBtn"+tbgCancelledPol._mtgId).observe("mousedown",unsetCheckboxOnTBG);
	$("mtgBtnOkFilter"+tbgCancelledPol._mtgId).observe("click",unsetCheckboxOnTBG);
	$("btnProcess").observe("click", function() {
		var exist = false;
		for ( var i = 0; i < objCancelledPol.length; i++) {
			if (objCancelledPol[i].tag == "Y") {
				exist = true;
				break;
			}
		}
		if (!exist) {
			showMessageBox("Please select policies to process.","I");
		} else {
			showConfirmBox("Confirmation", "Payments will be made to all checked policies and its endorsements. Do you want to continue?", "Yes", "No",
					function() {
						processCancelledPol();
					}, 
					"");
		}
	});
	
	$("btnDetails").observe("click", function() {
		endorsementOverlay();
	});
	
	$("btnCheckAll").observe("click", function() {
		objCancelledPol = getAllCancelledPol();
		if (this.value == 'Check All') {
			for ( var i = 0; i < objCancelledPol.length; i++) {
				objCancelledPol[i].tag = 'Y';
			}
			this.value = 'Uncheck All';
		} else {
			for ( var i = 0; i < objCancelledPol.length; i++) {
				objCancelledPol[i].tag = 'N';
			}
			this.value = 'Check All';
		}
		setCheckboxOnTBG();
	});
	
	$("acExit").stopObserving();
	$("acExit").observe("click", function() {
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});
	
	$("btnReverseProcessedPol").observe("click", function(){	// start FGIC SR-4266 : shan 05.21.2015
		reversePolCanvas = true;
		$("reverseCancelledPoliciesDiv").show();
		$("processCancelledPoliciesDiv").hide();
		tbgPolForReverse._refreshList();
	});
	
	$("btnReturnReverse").observe("click", function(){
		reversePolCanvas = false;
		$("reverseCancelledPoliciesDiv").hide();
		$("processCancelledPoliciesDiv").show();
	});
		
	function getPolForReverseByParam(){
		new Ajax.Request(contextPath+"/GIACCreditAndCollectionUtilitiesController", {
			parameters: {
				action: "getPoliciesForReverseByParam",
				filterBy: JSON.stringify(tbgPolForReverse.objFilter)
			},
			asynchronous : false,
			evalScripts : true,
			onCreate: showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					
					taggedPolForReverse = JSON.parse(response.responseText);
					recheckRows();
				}
			}
		});
	}
	
	function observeCheckboxForReversal(){
		var checkboxList = "";
		$$("input[type='checkbox']").each(function(c){
			if(c.id.indexOf("mtgInput"+tbgPolForReverse._mtgId) != -1 && 
				!c.disabled && c.id != "mtgSelectAll"+tbgPolForReverse._mtgId &&
				parseInt((c.id.split(",")[0]).substr(c.id.split(",")[0].length-1)) == 2){
				checkboxList += c.id + " ";
			}
		});
		
		$w(checkboxList).each(function(c){
			$(c).observe("click", function(){
				var index = c.split(",")[1];
				var exists = false;
				
				if($(c).checked){
					tbgPolForReverse.geniisysRows[index].tag = "Y";
					
					for (var i=0; i < taggedPolForReverse.length; i++){
						if (taggedPolForReverse[i].policyId == tbgPolForReverse.geniisysRows[index].policyId){
							exists = true;
							break;
						}
					}
					if (!exists){
						taggedPolForReverse.push(tbgPolForReverse.geniisysRows[index]);
					}
				}else{
					tbgPolForReverse.geniisysRows[index].tag = "N";
					
					for (var i=0; i < taggedPolForReverse.length; i++){
						if (taggedPolForReverse[i].policyId == tbgPolForReverse.geniisysRows[index].policyId){
							taggedPolForReverse.splice(i, 1);
							break;
						}
					}
				}
				
				tbgPolForReverse.updateVisibleRowOnly(tbgPolForReverse.geniisysRows[index], index);
				tbgPolForReverse.modifiedRows = [];
			});
		});
	}
	
	function recheckRows(){
		var g = tbgPolForReverse.getColumnIndex("tag");
		var mtgId = tbgPolForReverse._mtgId;
				
		for (var a = 0; a < tbgPolForReverse.geniisysRows.length; a++){
			for (var b = 0; b < taggedPolForReverse.length; b++){
				if (tbgPolForReverse.geniisysRows[a].lineCd == taggedPolForReverse[b].lineCd 
						&& tbgPolForReverse.geniisysRows[a].sublineCd == taggedPolForReverse[b].sublineCd
						&& tbgPolForReverse.geniisysRows[a].issCd == taggedPolForReverse[b].issCd
						&& tbgPolForReverse.geniisysRows[a].issueYy == taggedPolForReverse[b].issueYy
						&& tbgPolForReverse.geniisysRows[a].polSeqNo == taggedPolForReverse[b].polSeqNo
						&& tbgPolForReverse.geniisysRows[a].renewNo == taggedPolForReverse[b].renewNo){
					$('mtgInput'+mtgId+'_'+g+','+a).checked = true;
					tbgPolForReverse.updateVisibleRowOnly(tbgPolForReverse.geniisysRows[a], a);
				}
			}
			
			if (taggedPolForReverse.length == 0){
				$('mtgInput'+mtgId+'_'+g+','+a).checked = false;
			}
			tbgPolForReverse.modifiedRows = [];
		}
	}
	
	function reverseProcessedPolicies(){
		try{
			new Ajax.Request(contextPath+"/GIACCreditAndCollectionUtilitiesController", {
				parameters: {
					action: "reverseProcessedPolicies",
					taggedRecords: prepareJsonAsParameter(taggedPolForReverse)
				},
				asynchronous : false,
				evalScripts : true,
				onCreate: showNotice("Reversing payments for selected policies, please wait..."),
				onComplete: function(response){
					hideNotice();				
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						showWaitingMessageBox("Applied payments for selected policies have been reversed.", imgMessage.INFO, 
							function(){
								taggedPolForReverse = [];
								tbgPolForReverse.refresh();
							}
						);						
					}
				}
			});
		}catch(e){
			showErrorMessage("reverseCancelledPolicies", e);
		}
	}
	
	$("btnDetailsReverse").observe("click", function() {
		endorsementOverlay();
	});
	
	$("btnCheckAllReverse").observe("click", function() {
		if (this.value == 'Check All') {
			this.value = 'Uncheck All';
			getPolForReverseByParam();
		} else {
			this.value = 'Check All';
			taggedPolForReverse = [];
			recheckRows();
		}
	});
	
	$("btnReverseRec").observe("click", function(){
		if (taggedPolForReverse.length == 0){
			showMessageBox("Please select policies to reverse.", "I");
			return false;
		}else{
			showConfirmBox("Confirmation", "Cancellation of payments for all the checked policies and its endorsements will be reversed. Do you want to continue?", "Yes", "No",
					function() {
						reverseProcessedPolicies();
					}, 
					"");
		}
	});	// end FGIC SR-4266 : shan 05.21.2015
</script>


