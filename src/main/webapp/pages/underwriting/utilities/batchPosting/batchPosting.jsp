<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="batchPostingMainDiv" style="margin-bottom: 50px; float: left;">
	<div id="batchPostingExitDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="batchPostingExit">Exit</a>
					</li>
				</ul>
			</div>
		</div>
	</div>
	<div style="width: 922px;"></div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Batch Posting</label>
		</div>
	</div>
	
	<div class="sectionDiv" style="padding-bottom: 10px; margin-bottom: 10px;">
		<div id="parTableGrid" style="margin-left: 10px; height: 310px; margin-top: 10px;"></div>
		<div id="radioDiv" style="margin-top: 10px; margin-bottom:10px; margin-left:700px; height:15px;">
			<input type="radio" name="rdo" id="rdoTagAll" value="Tag All" title="Tag All" style="float: left; margin-right: 10px;" tabindex="101"/>
			<label for="rdoTagAll" tabindex="101" style="float: left; height: 20px; padding-top: 3px; padding-right: 10px;">Tag All</label>
			<input type="radio" name="rdo" id="rdoUntagAll" value="Untag All" title="Untag All" style="float: left; margin-right: 10px;" tabindex="102"/>
			<label for="rdoUntagAll" tabindex="101" style="float: left; height: 20px; padding-top: 3px; padding-right: 10px;">Untag All</label>
		</div>
		<div align="center" style="padding: 5px; padding-top: 10px; margin-bottom: 10px;">
			<input type="button" class="button" style="width: 100px;" id="btnParameter" name="btnParameter" value="Parameters" tabindex="201"/>
			<input type="button" class="button" style="width: 100px;" id="btnPost" name="btnPost" value="Post" tabindex="202"/>
			<input type="button" class="button" style="width: 100px;" id="btnLog" name="btnLog" value="Logs" tabindex="203"/>
		</div>
	</div>
</div>

<script type="text/javascript">
	initializeAll();
	setModuleId("GIPIS207");
	setDocumentTitle("Batch Posting");
	
	tagWithoutUser = false;
	tagByParameter = false;	//TRUE - if ginamit ang parameters button
	manualTag	   = false;	//TRUE - if ngcheck manually
	
	objParRecord = []; //stores geniisysRows
	recordsForPostingByParameter = new Array();	//stores records tagged using the parameters button
	recordsForPostingManually = new Array();	//stores records tagged manually
	tempArray = new Array(); //stores final tagged records for posting
	tempSplice = new Array(); //stores records that have been posted
	
	var lineCd    = "";
	var sublineCd = "";
	var issCd     = "";
	var userId    = "";
	var parType   = "";
	
	tempArrayForUntaggedRecords = new Array();	//stores untagged records
	batchPosting = new Object(); //GLOBAL variable for batch posting
	disableButton("btnLog");
	
	credBranchConf = "N";
	backEndt = "";
	
	countPost = 0;
	countUnpost = 0;
	rep = "";
	
	try {
		var row = 0;
		var objBatchPosting = new Object();
		objBatchPosting.jsonParListing = JSON.parse('${jsonBatchPosting}'.replace(/\\/g, '\\\\'));
		objBatchPosting.parListing = objBatchPosting.jsonParListing.rows || [];
		
		var parListTG = {
			url : contextPath + "/BatchPostingController?action=showBatchPosting&lineCd="+objUWGlobal.lineCd,
			options : {
				width : '900px',
				height : '282px',
				hideColumnChildTitle : true,
				validateChangesOnPrePager : false,
				onCellFocus : function(element, value, x, y, id) {
					row = y;
				},
				onSort : function() {
					batchPosting.tagRecordsForPosting();
					parListingTableGrid.keys.releaseKeys();
				},
				prePager : function() {
					parListingTableGrid.keys.releaseKeys();
				},
				postPager : function() {
					batchPosting.tagRecordsForPosting();
					parListingTableGrid.keys.releaseKeys();
				},
				onRefresh : function() {
					resetAllArrays();
				},
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter : function(){
						resetAllArrays();
					}
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
						id : 'postingSw',
						width : '25',
						title : 'P',
						align : 'center',
						altTitle : 'For Posting',
						editable : true,
						sortable : false, 
						//sortable : true,
						editor : new MyTableGrid.CellCheckbox({
									onClick : function(value, checked) {
										manualTag = true;
										if (value == "Y") {
											recordsForPostingManually.push(parListingTableGrid.geniisysRows[row]);
											tempArray.push(parListingTableGrid.geniisysRows[row]);
											for ( var m = 0; m < tempArrayForUntaggedRecords.length; m++) {
												if (tempArrayForUntaggedRecords[m]['parId'] == parListingTableGrid.geniisysRows[row].parId) {
													tempArrayForUntaggedRecords.splice(m,1);
												}
											}
										}else {
											tempArrayForUntaggedRecords.push(parListingTableGrid.geniisysRows[row]);
											for ( var m = 0; m < tempArray.length; m++) {
												if (tempArray[m]['parId'] == parListingTableGrid.geniisysRows[row].parId) {
													tempArray.splice(m,1);
												}
											}
											for ( var m = 0; m < recordsForPostingManually.length; m++) {
												if (recordsForPostingManually[m].parId == parListingTableGrid.geniisysRows[row].parId) {
													recordsForPostingManually.splice(m,1);
												}
											}
										}
									},
									getValueOf : function(value) {
										if (value) {
											return "Y";
										} else {
											return "N";
										}
									}
								})
					}, {
						id : 'parNo',
						title : 'PAR No.',
						width : '197',
						//filterOption : true
					}, {
						id : 'assdName',
						title : 'Assured Name',
						width : '463',
						filterOption : true
					}, {
						id : 'userId',
						//title : 'User ID', Kenneth L. 02.10.2014
						title : 'Underwriter',
						width : '88',
						filterOption : true
					}, {
						id : 'parType',
						title : 'PAR Type',
						width : '80',
						filterOption : true
					}, {
						id : 'issCd',
						title : 'Issue Code',
						width : '0',
						visible : false,
						filterOption : true
					}, {						
						id : 'parYear',
						title : 'PAR Year',
						width : '0',
						visible : false,
						filterOption : true,
						filterOptionType : 'integerNoNegative'
					}, {
						id : 'parSeqNo',
						title : 'PAR Seq No.',
						width : '0',
						visible : false,
						filterOption : true,
						filterOptionType : 'integerNoNegative'
					}, {
						id : 'quoteSeqNo',
						title : 'Quote Seq No.',
						width : '0',
						visible : false,
						filterOption : true,
						filterOptionType : 'integerNoNegative'
					}, {
						id : 'bankRefNo',
						title : 'Bank Ref No.',
						width : '0',
						visible : false,
						filterOption : true
					}],
			rows : objBatchPosting.parListing
		};
		parListingTableGrid = new MyTableGrid(parListTG);
		parListingTableGrid.pager = objBatchPosting.jsonParListing;
		parListingTableGrid.render('parTableGrid');
		parListingTableGrid.afterRender = function() {
			objParRecord = parListingTableGrid.geniisysRows;
		};
	} catch (e) {
		showErrorMessage("parListingTableGrid", e);
	}
	
	function resetAllArrays(){	//added by Kenneth L. 02.12.2014 to reset all used arrays when refreshing
		tagWithoutUser = false;
		tagByParameter = false;
		manualTag	   = false;
		
		lineCd    = "";
		sublineCd = "";
		issCd     = "";
		userId    = "";
		parType   = "";
		
		objParRecord = [];
		recordsForPostingByParameter = [];
		recordsForPostingManually = [];
		tempArray = [];
		tempSplice = [];
		tempArrayForUntaggedRecords = [];
	}
	
	function showParameterOverlay() {	//shows parameters overlay
		try {
			overlayParameter = Overlay.show(contextPath + "/BatchPostingController", {
				urlContent : true,
				urlParameters : {
					action : "showParameterForBatchPosting"
				},
				title : "Parameters",
				//height : 250, changed by kenneth L. 02.17.2014
				height : 220,
				width : 450,
				draggable : true
			});
		} catch (e) {
			showErrorMessage("showParameterOverlay", e);
		}
	}
	
	function showLogOverlay() { 	//shows logs overlay
		try {
			errorLogOverlay = Overlay.show(contextPath + "/BatchPostingController", {
				urlContent : true,
				urlParameters : {action : "showLogForBatchPosting"},
				title : "Logs",
				height : '418px',
				width : '850px',
				draggable : true
			});
		} catch (e) {
			showErrorMessage("showLogOverlay", e);
		}
	}
	
	function getParByParameter() {	
		//gets records(parId, issCd, and postingSw) according to the selected parameter
		//also used in tagAll to get all records regardless of pagesize
		new Ajax.Request(contextPath+"/BatchPostingController?action=getParListByParameter" 
									+ "&paramLineCd="+objUWGlobal.lineCd
									+ "&paramSublineCd="+ paramSublineCd
									+ "&paramIssCd="+ paramIssCd
									+ "&paramUserId="+ paramUserId
									+ "&paramParType="+paramParType,{
			method: "POST",
			onComplete : function (response){
				if(checkErrorOnResponse(response)){
					tempArray = [];
					recordsForPostingByParameter = JSON.parse(response.responseText);
					for ( var b = 0; b < recordsForPostingByParameter.par.length; b++) {
						recordsForPostingByParameter.par[b]['postingSw'] = "Y";
						tempArray.push(recordsForPostingByParameter.par[b]);
					}
					
					for ( var a = 0; a < parListingTableGrid.rows.length; a++) {
						for ( var b = 0; b < recordsForPostingByParameter.par.length; b++) {
							if (parListingTableGrid.geniisysRows[a].parId == recordsForPostingByParameter.par[b]['parId']) {
								$("mtgInput"+parListingTableGrid._mtgId+"_2,"+a).checked = true;
								recordsForPostingByParameter.par[b]['postingSw'] = "Y";
							}
						}
					}
				}
			}							 
		});	
	}batchPosting.getParByParameter = getParByParameter;

	function checkTable() {	//finalize table, checking if there are untagged records
		var check = true;
		if (tempArray.length != 0) {
			for ( var a = 0; a < tempArray.length; a++) {
				for ( var b = 0; b < tempArrayForUntaggedRecords.length; b++) {
					if (tempArrayForUntaggedRecords != null) {
						if (tempArray[a]['parId'] == tempArrayForUntaggedRecords[b]['parId']) {
							//tempArrayForUntaggedRecords.splice(b,1);
							tempArray.splice(a,1);
						}	
					}
				}
			}	
		}else {
			showMessageBox("Select records for posting.", imgMessage.INFO);
			check = false;
		}
		return check;
	}
	
	function checkUntaggedRecords(param) {	//checks untagged records against records tagged manually
		var uncheck = false;				//and against tablegrid
		for ( var b = 0; b < tempArrayForUntaggedRecords.length; b++) {
			if (tempArrayForUntaggedRecords[b]['parId'] == param) {
				uncheck = true;
				/* for ( var m = 0; m < recordsForPostingManually.length; m++) {
					if (recordsForPostingManually[m].parId == tempArrayForUntaggedRecords[b]['parId']) {
						recordsForPostingManually.splice(m,1);
						tempArrayForUntaggedRecords.splice(b,1);
					}
				} */
			}
		}
		return uncheck;
	}
	
	function checkManuallyTaggedRecords(param) {	//checks manually tagged records against tablegrid
		var check = false;
		if (manualTag) {
			for ( var m = 0; m < recordsForPostingManually.length; m++) {
				if (recordsForPostingManually[m].parId == param) {
					check = true;
				}
			}
		}
		return check;
	}
	
	function tagRecordsForPosting() {	//this is used for display of the tagging and untagging of records
		if (tagByParameter) {																//if gumamit ng parameters button
			for ( var i = 0; i < parListingTableGrid.rows.length; i++) {
				lineCd 	  = parListingTableGrid.geniisysRows[i].lineCd;
				sublineCd = parListingTableGrid.geniisysRows[i].sublineCd;
				issCd	  = parListingTableGrid.geniisysRows[i].issCd;
				userId    = parListingTableGrid.geniisysRows[i].userId;
				parType   = parListingTableGrid.geniisysRows[i].parType;

				if (lineCd == nvl(objUWGlobal.lineCd, lineCd) 
						&& sublineCd == nvl(paramSublineCd, sublineCd)
						&& issCd == nvl(paramIssCd, issCd)
						&& parType == nvl(paramParType, parType)) {
				}else{
					$("mtgInput"+parListingTableGrid._mtgId+"_2,"+i).checked = false;			//double check records na iuuntag
				}
				
				for ( var a = 0; a < tempArray.length; a++) {
 					if (parListingTableGrid.geniisysRows[i].parId== tempArray[a]['parId'] ) { 	//tag laht ng ok sa parameters na sinelect
 						$("mtgInput"+parListingTableGrid._mtgId+"_2,"+i).checked = true; 			
 						if (lineCd == nvl(objUWGlobal.lineCd, lineCd) 							//CHECK ULIT
 								&& sublineCd == nvl(paramSublineCd, sublineCd)					//para kapag nagmanual tag, tapos nagparameter
 								&& issCd == nvl(paramIssCd, issCd)								//mauncheck agad ung namanual tag at matira lng na nkacheck ung mga
 								&& parType == nvl(paramParType, parType)) {						//pasok sa parameter
 						}else{
 							$("mtgInput"+parListingTableGrid._mtgId+"_2,"+i).checked = false;	//iuntag ang hnd pasok sa parameter
 						}
 					}
 					
 					for ( var b = 0; b < tempArrayForUntaggedRecords.length; b++) {				//Check sa untagged records sa array ng manually tagged records
 						for ( var c = 0; c < recordsForPostingManually.length; c++) {			//splice na sa manually tagged kpag nsa untagged array
 							if (recordsForPostingManually[c]['parId']  == tempArrayForUntaggedRecords[b]['parId']) {
 								recordsForPostingManually.splice(c, 1);
 							}
						}
 						if (tempArray[a]['parId']  == tempArrayForUntaggedRecords[b]['parId']) {//MANUAL
 							tempArrayForUntaggedRecords.splice(b,1);							//kapag nagtag tapos inuntag tapos tinag ulit
 							tempArray.splice(a,1);												//aalisin sa array ng untagged at sa temp array
						}
 					}
				}
				
				if (checkManuallyTaggedRecords(parListingTableGrid.geniisysRows[i].parId)) {	//CHECK ang mga manually tagged records na array
					$("mtgInput"+parListingTableGrid._mtgId+"_2,"+i).checked = true;			//ichecheck ang record
				}

				if (tempArrayForUntaggedRecords.length != 0) {									//CHECK ang untagged records array
					if (checkUntaggedRecords(parListingTableGrid.geniisysRows[i].parId)) {		//if nsa temparrayforuntaggedrecords
						$("mtgInput"+parListingTableGrid._mtgId+"_2,"+i).checked = false;		//iuuncheck ang record
					}
				}
			}
		}else {
			if ($("rdoTagAll").checked) {														//para sa TAG ALL radio button
				for ( var i = 0; i < parListingTableGrid.rows.length; i++) {
					$("mtgInput"+parListingTableGrid._mtgId+"_2,"+i).checked = true;
					
					if (manualTag) {
						if (checkManuallyTaggedRecords(parListingTableGrid.geniisysRows[i].parId)) {//CHECK lang ulit
							$("mtgInput"+parListingTableGrid._mtgId+"_2,"+i).checked = true;
						}
						
						if (tempArrayForUntaggedRecords.length != 0) {
							if (checkUntaggedRecords(parListingTableGrid.geniisysRows[i].parId)) {//CHECK lang ulit
								$("mtgInput"+parListingTableGrid._mtgId+"_2,"+i).checked = false;
							}
						}
					}
				}
			}else if ($("rdoUntagAll").checked) {												//para sa TAG ALL radio button
				for ( var i = 0; i < parListingTableGrid.rows.length; i++) {
					$("mtgInput"+parListingTableGrid._mtgId+"_2,"+i).checked = false; 
					
					if (checkManuallyTaggedRecords(parListingTableGrid.geniisysRows[i].parId)) {//CHECK lang ulit
						$("mtgInput"+parListingTableGrid._mtgId+"_2,"+i).checked = true;
					}
					
					if (tempArrayForUntaggedRecords.length != 0) {
						if (checkUntaggedRecords(parListingTableGrid.geniisysRows[i].parId)) {//CHECK lang ulit
							$("mtgInput"+parListingTableGrid._mtgId+"_2,"+i).checked = false;
						}
					}
				}
			}	
		}
	}batchPosting.tagRecordsForPosting = tagRecordsForPosting;
	
	function startOfBatchPosting() {
		new Ajax.Request(contextPath+"/BatchPostingController", {
			parameters: {
				action: "deleteLog"
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					/* for ( var a = 0; a < tempArray.length; a++) {
						checkIfBackEndt(tempArray[a]['parId'],tempArray[a]['issCd']);
						if (rep == "Y") {
							countUnpost++;
						}else if (rep == "N") {
							countPost++;
							tempSplice.push(tempArray[a]);
						}
					} */
					
					for ( var a = 0; a < tempArray.length; a++) {
						post(tempArray[a]['parId'],tempArray[a]['issCd'],tempArray[a]['parType']);
						if (rep == "Y") {
							countUnpost++;
						}else if (rep == "N") {
							countPost++;
							tempSplice.push(tempArray[a]);
						}
					} 
				
					if (parseInt(countPost) > parseInt(0)) {
						showWaitingMessageBox("Batch posting finished. Posted " + countPost + " PAR/s. Check Logs screen to view posted PAR/s.", imgMessage.INFO, function() {
							if (parseInt(countUnpost) > parseInt(0)) {
								showMessageBox("Unsuccessful posting of " + countUnpost + " PAR/s. Check Logs screen to view problems encountered during batch posting.", imgMessage.ERROR);
								//enableButton("btnLog");
							}
						});
						enableButton("btnLog");
						parListingTableGrid._refreshList();
						tagRecordsForPosting();
					}
					
					if (parseInt(countUnpost) > parseInt(0)) {
						showMessageBox("Unsuccessful posting of " + countUnpost + " PAR/s. Check Logs screen to view problems encountered during batch posting.", imgMessage.ERROR);
						enableButton("btnLog");
					}
					
					for ( var b = 0; b < tempSplice.length; b++) {		//alisin sa tempArray ang mga napost na records from tempsplice array
						for ( var a = 0; a < tempArray.length; a++) {
							if (tempArray[a]['parId'] == tempSplice[b]['parId']) {
								tempArray.splice(a, 1);
							}
						}
					}
					
				}
			}
		});	
	}

	function checkIfBackEndt(parId,issCd) {
		new Ajax.Request(contextPath+"/BatchPostingController", {
			parameters: {
				action: "checkIfBackEndt",
				parId : parId
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					backEndt = response.responseText;
					/* if (response.responseText == "Y") {
						showConfirmBox("Post All PAR?",
										"All endts with backward endts will be saved with update. Do you want to continue?",
										"Yes", "No", function() {
												post(parId,issCd);}, "", "");
					}else {
						post(parId,issCd);
					} */
				}
			}
		});	
	}
	
	function post(parId,issCd,parType) {
		new Ajax.Request(contextPath+"/BatchPostingController", {
			parameters: {
				action: "batchPost",
				parId : parId,
				lineCd: objUWGlobal.lineCd,
				issCd : issCd,
				backEndt: backEndt,
				credBranchConf : credBranchConf,
				moduleId : "GIPIS207",
				parType : parType
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: showNotice("Posting policy/s. Please wait..."),
			onComplete: function(response) {
				if (checkErrorOnResponse(response)) {
					rep = response.responseText;
				}
			}
		});	
	}
	
	$("btnPost").observe("click", function() {
		countPost = 0;
		countUnpost = 0;
		if (checkTable()) {
			reference = "";
			for ( var a = 0; a < tempArray.length; a++) {
				checkIfBackEndt(tempArray[a]['parId'],tempArray[a]['issCd']);
				reference = reference + backEndt;
			}
		}
		/* if(reference.contains("Y")){
			showConfirmBox("Post All PAR?",
					"All endts with backward endts will be saved with update. Do you want to continue?",
					"Yes", "No", function() {
							startOfBatchPosting();}, "", null);
		}else{
			startOfBatchPosting();
		} */
		startOfBatchPosting();
	});;
	
	$("btnLog").observe("click", function() {
		showLogOverlay();
	});
	
	$("btnParameter").observe("click", function() {
		showParameterOverlay();
	});
	
	$("rdoTagAll").observe("click", function() {
		paramSublineCd = "";
		paramIssCd = "";
		paramUserId = "";
		paramParType = "";
		getParByParameter();
	});
	
	$$("input[name='rdo']").each(function(check) {
		check.observe("click", function() {
			tagByParameter = false;
			manualTag = false;
			tempArrayForUntaggedRecords = [];
			recordsForPostingByParameter = [];
			recordsForPostingManually = [];
			tempArray = [];
			batchPosting.tagRecordsForPosting();
		});
	});
	
	observeCancelForm("batchPostingExit", "", function() {
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		objUWGlobal.module = ""; 
	});
	
	$("rdoUntagAll").checked = true;

</script>
