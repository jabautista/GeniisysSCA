<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>
<!-- hidden divs needed for View Policy information -->
<div id="claimInfoDiv" style="display: none;"></div>
<div id="claimViewPolicyInformationDiv" style="display:none;"> </div>

<div id="generatePLAFLAMainDiv" name="generatePLAFLAMainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
   			<label>Generate PLA/FLA</label>
   			<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	
	<div id="moduleDiv" name="moduleDiv" class="sectionDiv" style="margin: 0 0 20px 0;">
			<div id="lineCdDiv" name="lineCdDiv" style="height:40px; margin: 20px 0 0 230px;">
				<label id="lblLine" for="txtLineCd" style="margin:4px 4px 2px 2px; ">Line</label>
				<span class="lovSpan" style="width: 76px; margin-right: 2px;">
					<input type="text" id="txtLineCd" name="txtLineCd" lastValidValue="" style="width: 50px; float: left; border: none; height: 14px; margin: 0;" class="upper" maxlength="2" tabindex="101"/>  
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osLineCd" name="osLineCd" alt="Go" style="float: right;" tabindex="102"/>
				</span>
				<input type="text" id="txtLineName" name="txtLineName" style="width: 400px;  margin: 0 0 0 5px; float: left; height: 14px;" readonly="readonly" maxlength="20" tabindex="103" />
			</div> <!-- end: lineCdDiv -->
		
		
			<div id="mainTabsMenu" name="subMenuDiv" align="center" style="width: 100%; margin-bottom: 0px; float: left;">
				<div id="tabComponentsDiv1" class="tabComponents1" style="float: left;">
					<ul>
						<li class="tab1 selectedTab1"><a id="tabUngeneratedPLA">List of Claims with Ungenerated PLA</a></li>
						<li class="tab1"><a id="tabUngeneratedFLA">List of Claims with Ungenerated FLA</a></li>
					</ul>
				</div>
				<div class="tabBorderBottom1"></div>		
			</div> <!-- end: mainTabsMenu -->
			
			<div id="tgMainDiv" name="tgMainDiv" style="float: left; height: 345px;">
				<div id="generatePLATableGrid" name="generatePLATableGrid" style="height: 290px; width: 900px; padding: 10px;">					
				</div> <!-- end: generatePLATableGrid -->
			</div> <!-- end: tgMainDiv -->
			
			<div id="btnDiv" name="btnDiv" class="buttonsDiv" style="float:left; margin:0 0 20px 0;">
				<input type="button" class="button" id="btnGenerate" name="btnGenerate" value="Generate" style="width:120px;" />
			</div>
		
	</div> <!-- end: moduleDiv -->
	
</div>

<script type="text/javascript">
	/* $("mainNav").hide(); */
	var userParams = new Object();
	
	var currentView = "P"; 	// variables.curr_view
	
	var a070 = new Object(); 
	a070.genCnt	= null;		//a070.gen_cnt
	a070.genCntAll = null;	//a070.gen_cnt_all
	a070.genFCnt = null;	//a070.gen_fcnt
	a070.genFCntAll = null;	//a070.gen_fcnt_all
	a070.lineCd = null; //a070.line_cd
	a070.lineName = null;
	
	var viewReport = new Object();
	viewReport.genRg = null; //view_report.gen_rg
	viewReport.userId = null; //variables.userId  
	viewReport.printPrsd = "N"; //variables.print_prsd ==> changes to Y when Print button (in viewReport.jsp) is pressed
	
	var onLOV = false;
	var isQueryExecuted = false; 
	var selectedRow = "";
	
	try {
		userParams = JSON.parse('${userParams}');
		
		var objPLAArray = [];
		var objPLA = new Object();
		objPLA.objPLAListTableGrid = JSON.parse('${plaList}');
		objPLA.objPLAList = objPLA.objPLAListTableGrid.rows || [];
		
		var objPLATableModel = {
				url : contextPath + "/GICLGeneratePLAFLAController?action=showGeneratePLAFLAPage&refresh=1"
						+ "&allUserSw=" + encodeURIComponent(userParams.allUserSw)
						+ "&validTag=" + encodeURIComponent(userParams.validTag)
						+ "&lineCd=" + ($F("txtLineCd"))
						+ "&currentView=" + ((currentView == "PP" || currentView == "P") ? "P" : ((currentView == "F" || currentView == "FF") ? "F" : ""))
						+ "&moduleId=GICLS051",
				options : {
					title :'',
					width : '900px',
					hideColumnChildTitle: true,
					onCellFocus: function(elemet, value, x, y, id){
						var mtgId = plaListTableGrid._mtgId;
						
						if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
							selectedRow = plaListTableGrid.geniisysRows[y];
							if(userParams.validTag == "Y"){
								enableButton("btnGenerate");
							} else {
								if(selectedRow.inHouseAdjustment != userParams.userId){
									disableButton("btnGenerate");
								} else {
									enableButton("btnGenerate");
								}
							}
							populateGlobalVars();
						}						
					},
					onRowDoubleClick : function(y){
						selectedRow = plaListTableGrid.geniisysRows[y];
						generateLossAdvice();						
					},
					onRemoveRowFocus: function(){
						plaListTableGrid.keys.releaseKeys();
						disableButton("btnGenerate");
		            },
				},
				columnModel : [
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
								    id: 'claimId',
								    width: '0',
									visible: false
								},								
								{
									id: 'lineCode sublineCd issueCode claimYy claimSequenceNo',
									title: 'Claim Number',
									sortable: true,
									children: [
											{
												id: 'lineCode',
												title: 'Line Cd',
												width: '30'
											},
											{
												id: 'sublineCd',
												title: 'Subline Cd',
												width: '40'
											},
											{
												id: 'issueCode',
												title: 'Iss Cd',
												width: '30'
											},
											{
												id: 'claimYy',
												title: 'Claim Yy',
												width: '30',
												align: 'right'
											},
											{
												id: 'claimSequenceNo',
												title: 'Claim Sequence No',
												width: '60',
												align: 'right',
												renderer: function(value){
													return formatNumberDigits(value, 7);
												}
											}
									]
								},
								{
									id: 'lineCode sublineCd policyIssueCode issueYy policySequenceNo renewNo',
									title: 'Policy Number',
									width: '220',
									sortable: true,
									children: [
											{
												id: 'lineCode',
												title: 'Line Cd',
												width: '30'
											},
											{
												id: 'sublineCd',
												title: 'Subline Cd',
												width: '40'
											},
											{
												id: 'policyIssueCode',
												title: 'Policy Iss Cd',
												width: '30'
											},
											{
												id: 'issueYy',
												title: 'Issue Yy',
												width: '30',
												align: 'right'
											},
											{
												id: 'policySequenceNo',
												title: 'Policy Sequence No',
												width: '60',
												align: 'right',
												renderer: function(value){
													return formatNumberDigits(value, 7);
												}
											},
											{
												id: 'renewNo',
												title: 'Renew No',
												width: '30',
												align: 'right',
												renderer: function(value){
													return formatNumberDigits(value, 2);
												}
											}
									]
								},
								{
									id: 'assuredName',
									title: 'Assured',
									width: '188'
								},
								{
									id: 'inHouseAdjustment',
									title: 'Processor',
									width: '90'
								},
								{
								    id: 'claimStatDesc',
								    title: 'Status',
								    width: '100'
								},
								{
									id: 'lossDateStr',
									title: 'Loss Date',
									width: '80'
								}
					],
				resetChangeTag : true,
				rows : objPLA.objPLAListTableGrid.rows //objPLA.objPLAList
		};
		plaListTableGrid = new MyTableGrid(objPLATableModel);
		plaListTableGrid.pager = objPLA.objPLAList; //objPLA.objPLAListTableGrid;
		plaListTableGrid.render('generatePLATableGrid');
		
	} catch(e){
		showErrorMessage("PLA Table Grid", e);
	}
	
	function initializeDefaultValues(){
		userParams.validTag == "Y" ? enableButton("btnGenerate") : disableButton("btnGenerate");
		
		disableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarPrint");
		enableSearch("osLineCd");
		enableInputField("txtLineCd");
		$("txtLineCd").focus();
		
		if(objGICLS051.currentView != null){
			enableToolbarButton("btnToolbarEnterQuery");
			disableSearch("osLineCd");
			disableInputField("txtLineCd");
			
			$("txtLineCd").value = nvl(objCLMGlobal.lineCd, "");
			$("txtLineName").value = nvl(objCLMGlobal.lineName, "");
			isQueryExecuted = true;
			
			if(objGICLS051.currentView == "P" || objGICLS051.currentView == "PP"){
				$("tabUngeneratedPLA").click();	
			} else if(objGICLS051.currentView == "F" || objGICLS051.currentView == "FF"){
				$("tabUngeneratedFLA").click();
			}
		}
	}
	
	function getGicls051CdLOV(){
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getGicls051CdLOV",
							filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
							moduleId: "GICLS051",
							page : 1},
			title: "Valid Values for Line",
			width: 500,
			height: 400,
			columnModel : [
							{
								id : "lineCd",
								title: "Line Code",
								width: '100px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							},
							{
								id : "lineName",
								title: "Line Name",
								width: '370px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							},
							{
								id : "menuLineCd",
								visble: false,
								width: '0'
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
				onSelect: function(row) {
					enableToolbarButton("btnToolbarEnterQuery");
					enableToolbarButton("btnToolbarExecuteQuery");
					$("txtLineCd").value = row.lineCd;
					$("txtLineCd").setAttribute("lastValidValue", row.lineCd);
					$("txtLineName").value = unescapeHTML2(row.lineName);
					a070.lineCd = row.lineCd;
					a070.lineName = unescapeHTML2(row.lineName);
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
	
	function queryCountUngenerated(){ // executes query_count_ungen procedure
		try {
			new Ajax.Request(contextPath+"/GICLGeneratePLAFLAController",{
				parameters: {
					action		: "queryCountUngenerated",
					allUserSw	: userParams.allUserSw,
					validTag	: userParams.validTag,
					moduleId	: "GICLS051",
					lineCd		: $F("txtLineCd"),
					currentView	: currentView
				},
				ashynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var count = JSON.parse(response.responseText);
						if(currentView == "P" || currentView == "PP"){
							a070.genCnt = count.genCnt;
							a070.genCntAll = count.genCntAll;
						} else if(currentView == "F"|| currentView == "FF"){
							a070.genFCnt = count.genCnt;
							a070.genFCntAll = count.genCntAll;
						}
						refreshTG();
					}
				}
			});
		} catch(e){
			showErrorMessage("queryCountUngenerated",e);
		}
	}
	
	function executeQuery(){
		if(currentView == "P" && a070.genCnt == null){
			queryCountUngenerated();
		} else if(currentView == "F" && a070.genCnt == null){
			queryCountUngenerated();
		}
	}
	
	function refreshTG(){
		plaListTableGrid.url = contextPath + "/GICLGeneratePLAFLAController?action=showGeneratePLAFLAPage&refresh=1"
		   + "&allUserSw=" + encodeURIComponent(userParams.allUserSw)
		   + "&validTag=" + encodeURIComponent(userParams.validTag)
		   + "&lineCd=" + ($F("txtLineCd"))
		   + "&currentView=" + currentView
		   + "&moduleId=GICLS051";
		
		plaListTableGrid._refreshList();
	}
	function setCurrentTab(id){
		$$("div.tabComponents1 a").each(function(a){
			if(a.id == id) {
				$(id).up("li").addClassName("selectedTab1");					
			}else{
				a.up("li").removeClassName("selectedTab1");	
			}	
		});
	}
	
	function generateLossAdvice(){
		var proceed = null;
		if(currentView == "P"){
			if(userParams.validTag == "Y"){
				proceed = true;
			} else {
				if(selectedRow.inHouseAdjustment != userParams.userId){
					showMessageBox("User is not allowed to generate this PLA. However, you may print the List of Ungenerated PLA's.", "I");
					proceed = false;
				} else { proceed = true; }
			}
			
			if(proceed){
				showLossAdvicePage(); 				
			}
		} else {
			if(userParams.validTag == "Y"){
				proceed = true;
			} else {
				if(selectedRow.inHouseAdjustment != userParams.userId){
					showMessageBox("User is not allowed to generate this FLA. However, you may print the List of Ungenerated FLA's.", "I");
					proceed = false;
				} else { proceed = true;}
			}
			
			if(proceed){
				objCLMGlobal.claimId = selectedRow.claimId;
				objCLMGlobal.lineCd = $F("txtLineCd");
				/* $("mainNav").show(); //trial 3
				showGenerateFLAPage();
				$("generatePLAFLAMainDiv").hide(); */
				showLossAdvicePage(); // trial 2
				/*showClaimBasicInformation(); // trial 1
				/*showGenerateFLAPage();*/
				//showGenerateFLAPage2();
			}
		}
	}
	
	function addRadioButtons(){
		var htmlCode = "<table border='0' style='margin: 12px 10px 10px 10px;'><tr><td><input type='radio' id='rdoCurrentUser' name='rdoUser' style='float:left;'/><label for='rdoCurrentUser' id='lblCurrentUser' style='float:left; margin:3px 2px 2px 5px;'>Current User</label></td><td><input type='radio' id='rdoAllUsers' name='rdoUser' style='margin-left:50px; float:left;' /><label for='rdoAllUsers' id='lblAllUsers' style='float:left; margin: 3px 2px 2px 5px;'>All Users</label></td></tr></table>";
		
		$("printDialogFormDiv2").update(htmlCode); 
		$("printDialogFormDiv2").show();
		$("printDialogMainDiv").up("div",1).style.height = "218px";
		$($("printDialogMainDiv").up("div",1).id).up("div",0).style.height = "250px";
		
		initializeDefaultValuesForPrint();		
	}
	
	function validateReportId(reportId, reportTitle){
		try {
			new Ajax.Request(contextPath+"/GICLGeneratePLAFLAController",{
				parameters: {
					action:		"validateReportId",
					reportId:	reportId
				},
				ashynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if (response.responseText == "Y"){
							printReport(reportId, reportTitle);
						}else{
							showMessageBox("No existing records found in GIIS_REPORTS.", "E");
						}
					}
				}
			});
		} catch(e){
			showErrorMessage("validateReportId",e);
		}
	}
	
	function printReport(reportId, reportTitle){
		function displayInfoAfterPrint(){
			showMessageBox("Printing complete.", "S");	
		}
		
		try {
			if(checkAllRequiredFieldsInDiv("printDiv")){
				var fileType = "";
				if($("rdoPdf").disabled == false /* && $("rdoExcel").disabled == false */){
					//fileType = $("rdoPdf").checked ? "PDF" : "XLS";
					fileType = "PDF"; //please revise when csv is available -andrew
				}
				var content = contextPath+"/PrintUngeneratedPLAFLAController?action=printReport"
							+ "&noOfCopies=" + $F("txtNoOfCopies")
							+ "&printerName=" + $F("selPrinter")
							+ "&destination=" + $F("selDestination")
							+ "&reportId=" + reportId
							+ "&reportTitle=" + reportTitle
							+ "&fileType=" + fileType
							+ "&moduleId=" + "GICLS051"
							+ "&lineCd=" + $F("txtLineCd")
							/* + "&userId=" */ + ($("rdoAllUsers").checked ? "" : "&userId=" + objGICLS051.userParams.userId);
				
				var nextFunc = $F("selDestination").toUpperCase() == "PRINTER" ? displayInfoAfterPrint : null;
				printGenericReport(content, reportTitle, nextFunc);
				overlayGenericPrintDialog.close();
			}
		} catch(e){
			showErrorMessage("printReport", e);
		}
	}
	
	function checkReport(){
		objGICLS051.viewReport.printPrsd = "Y";
		
		if(objGICLS051.currentView == "P"){
			validateReportId("GICLR050B", "List of Ungenerated PLAs");
		} else {
			validateReportId("GICLR051B", "List of Ungenerated FLAs");
		}
	}
	
	function initializeDefaultValuesForPrint(){
		if(objGICLS051.currentView == "P"){
			if(objGICLS051.a070.genCntAll > 0 || objGICLS051.a070.genCnt > 0){
				if(objGICLS051.userParams.allUserSw == "N" || objGICLS051.userParams.validTag == "N" || objGICLS051.a070.genCntAll == 0){
					$("rdoAllUsers").disabled = true;
				}
				if(objGICLS051.a070.genCnt == 0){
					$("rdoCurrentUser").disabled = true;
				}
				if(objGICLS051.a070.genCnt > 0){
					$("rdoCurrentUser").checked = true;	//viewReport.genRg = "C";
				} else if(objGICLS051.a070.genCntAll > 0){
					$("rdoAllUsers").checked = true; //viewReport.genRg = "A";
				}
			}
		} else {
			if(objGICLS051.a070.genFCntAll > 0 || objGICLS051.a070.genFCnt > 0){
				if(objGICLS051.userParams.allUserSw == "N" || objGICLS051.userParams.validTag == "N" || objGICLS051.a070.genFCntAll == 0){
					$("rdoAllUsers").disabled = true;
				}
				if(objGICLS051.a070.genFCnt == 0){
					$("rdoCurrentUser").disabled = true;
				}
				if(objGICLS051.a070.genFCnt > 0){
					$("rdoCurrentUser").checked = true;
				} else if(objGICLS051.a070.genFCntAll > 0){
					$("rdoAllUsers").checked = true;
				}
			}
		}
	}
	
	function populateGlobalVars(){
		objCLMGlobal.previousModule = "GICLS051";
		objCLMGlobal.claimId = selectedRow != null ? selectedRow.claimId : "";
		objCLMGlobal.lineCd = selectedRow != null ? $F("txtLineCd") : "";
		objCLMGlobal.lineName = selectedRow != null ? $F("txtLineName") : "";
		objCLMGlobal.lossCatCd = selectedRow != null ? selectedRow.lossCatCd : "";
		objCLMGlobal.dspLossCatDesc = selectedRow != null ? selectedRow.dspLossCatDesc : "";
		
		objGICLS051.userParams = userParams;
		objGICLS051.currentView = currentView;
		objGICLS051.a070 = a070;
		objGICLS051.viewReport = viewReport;
		objGICLS051.previousModule = "GICLS051";
	}
	
	function resetGlobalVars(){
		objCLMGlobal.previousModule = null;
		objCLMGlobal.claimId = null;
		objCLMGlobal.lineCd = null;
		objCLMGlobal.lineName = null;
		objCLMGlobal.lossCatCd = null;
		objCLMGlobal.dspLossCatDesc = null;
		objGICLS051.userParams = null;
		objGICLS051.currentView = null;
		objGICLS051.a070 = null;
		objGICLS051.viewReport = null;
		objGICLS051.previousModule = null;
	}
	
	function showLossAdvicePage(){
		//new Ajax.Updater("dynamicDiv", contextPath + "/GICLClaimsController?action=showClaimBasicInfo", { // andrew - 02.24.2012
		new Ajax.Updater(($("claimInfoDiv") ? "claimInfoDiv" :"dynamicDiv"), contextPath + "/GICLClaimsController?action=showClaimBasicInfo", {
			method: "GET",
			parameters: {
				claimId: objCLMGlobal.claimId,
				lineCd: objCLMGlobal.lineCd
			},
			asynchronous: false,
			evalScripts: true,
			onCreate : function() {
				showNotice("Loading, please wait...");
			},
			onComplete: function (response){
				try {
					hideNotice("");
					$("claimInfoDiv") ? $("claimInfoDiv").show() :null; // andrew - 02.24.2012
					$("claimListingMainDiv") ? $("claimListingMainDiv").hide() :null;  // andrew - 02.24.2012 - hide the listing to retain the filtered records
					$("lossRecoveryListingMainDiv") ? $("lossRecoveryListingMainDiv").hide() :null;
					newFormInstance();					
					$("generatePLAFLAMainDiv").hide();
				} catch(e){
					showErrorMessage("showLossAdvicePage - onComplete", e);
				}
				
			}
		});
	}
	
	observeReloadForm("reloadForm", function(){
		objGICLS051 = new Object();
		showGeneratePLAFLAPage("P", null);
	});
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		isQueryExecuted = true;
		
		disableSearch("osLineCd");
		disableInputField("txtLineCd");
		disableToolbarButton("btnToolbarExecuteQuery");
		enableToolbarButton("btnToolbarEnterQuery");
		executeQuery();
		enableToolbarButton("btnToolbarPrint");
	});
	$("btnToolbarEnterQuery").observe("click", function(){
		isQueryExecuted = false;
		enableSearch("osLineCd");
		enableInputField("txtLineCd");
		disableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarPrint");
		$("txtLineCd").value = "";
		$("txtLineName").value = "";
		a070.genCnt = null;
		a070.genCntAll = null;
		a070.genFCnt = null;
		a070.genFCntAll = null;
		refreshTG();
	});
	$("btnToolbarExit").observe("click", function(){
		resetGlobalVars();
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");	
	});
	$("btnToolbarPrint").observe("click", function(){
		var proceedToViewReport = false;
		viewReport.genRg = "X";
		
		if(currentView == "P"){
			if(a070.genCntAll == 0 && a070.genCnt == 0){
				showMessageBox("There is no list to print for " + $F("txtLineName") +".", "I");
			} else {
				proceedToViewReport = true;
			}
		} else {
			if(a070.genFCntAll == 0 && a070.genFCnt == 0){
				showMessageBox("There is no list to print for " + $F("txtLineName") +".", "I");
			} else {
				proceedToViewReport = true;
			}
		}
		
		if(viewReport.genRg == "A"){
			viewReport.userId = null;
		} else {
			viewReport.userId = userParams.userId;
		}
		
		if(proceedToViewReport){
			populateGlobalVars();
			showGenericPrintDialog("Print", checkReport, addRadioButtons, true);
		}
	});
	
	$("osLineCd").observe("click", getGicls051CdLOV);
	$("txtLineCd").observe("change", function(){
		if($F("txtLineCd").trim() == "") {
			$("txtLineCd").value = "";
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtLineName").value = "";
		} else {
			if($F("txtLineCd").trim() != "" && $F("txtLineCd") != $("txtLineCd").readAttribute("lastValidValue")) {
				getGicls051CdLOV();
			}
		}
	});
	$("txtLineCd").observe("keyup", function() {	
		$("txtLineCd").value = $F("txtLineCd").toUpperCase();
	});
	
	$("tabUngeneratedPLA").observe("click", function(){
		setCurrentTab("tabUngeneratedPLA");
		currentView = "P";
		
		if(a070.genCnt == null && isQueryExecuted){
			queryCountUngenerated();
		} else if(isQueryExecuted){
			refreshTG();
		} 
	});
	
	$("tabUngeneratedFLA").observe("click", function(){
		setCurrentTab("tabUngeneratedFLA");
		currentView = "F";
		
		if(a070.genFCnt == null && isQueryExecuted){
			queryCountUngenerated();
		} else if(isQueryExecuted){
			refreshTG();
		} 
		if(a070.genFCnt == 0 && a070.genFCntAll == 0){
			disableToolbarButton("btnToolbarPrint");
		} else if(a070.genFCnt > 0 || a070.genFCntAll > 0){
			enableToolbarButton("btnToolbarPrint");
		} else if(isQueryExecuted){
			enableToolbarButton("btnToolbarPrint");
		} else {
			disableToolbarButton("btnToolbarPrint");
		}
	});
	
	$("btnGenerate").observe("click", function(){generateLossAdvice();});
	
	setModuleId("GICLS051");
	setDocumentTitle("Generate PLA/FLA");
	initializeAll();
	makeInputFieldUpperCase();
	initializeDefaultValues();
	
</script>