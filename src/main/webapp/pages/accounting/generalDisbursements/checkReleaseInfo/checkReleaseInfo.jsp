<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="checkReleaseInfoMainDiv" name="checkReleaseInfoMainDiv" changeTagAttr="true">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Check Release Info</label>
	   		<span class="refreshers" style="margin-top: 0;"> 
		   		<label id="reloadCheckReleaseInfo" name="reloadCheckReleaseInfo">Reload Form</label>
	   		</span>
	   	</div>
	</div>
	
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	
	<div class="sectionDiv">
		<table style="margin: 10px auto;">
			<tr>		
				<td class="rightAligned">Company</td>
				<td class="leftAligned">
					<span class="required lovSpan" style="width: 300px; margin-right: 60px;">
						<input type="text" id="txtFundDesc" name="txtFundDesc" style="width: 275px; float: left; border: none; height: 14px; margin: 0;" class="required" readonly="readonly" ignoreDelKey="1"/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchFund" name="imgSearchFund" alt="Go" style="float: right;"/>
					</span>
				</td>
				<td></td>
				<td class="rightAligned">Branch</td>
				<td class="leftAligned">
					<span class="required lovSpan" style="width: 240px;">
						<input type="text" id="txtBranchName" name="txtBranchName" style="width: 215px; float: left; border: none; height: 14px; margin: 0;" class="required" readonly="readonly" ignoreDelKey="1"/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchBranch" name="imgSearchBranch" alt="Go" style="float: right;"/>
					</span>
				</td>
			</tr>
		</table>		
	</div>
	
	<div class="sectionDiv">
		<div id="checkReleaseInfoDiv" style="padding-top: 15px; padding-top: 15px; padding-left: 90px; padding-bottom: 15px; float: left;">
			<div id="checkReleaseInfoTable" style="height: 250px;"></div>
		</div>
		
		<div>
			<table border="0" style="margin: 10px; float: left;">
				<tbody>
					<tr>
						<td class="rightAligned" style="width: 10%;">Bank Account</td>
						<td class="leftAligned" style="width: 8%;">
							<input id="txtBankSname" type="text" name="txtBankSname" style="width: 100px;" readonly="readonly"/>
						</td>
						<td class="leftAligned" style="width: 40%;" >
							<input id="txtBankAccount" type="text" name="txtBankAccount" style="width: 250px;" readonly="readonly"/>
						</td>
						<td class="leftAligned" style="width: 10%;">Local Amount</td>
						<td class="leftAligned" style="width: 28%;">
							<input id="txtLocalAmount" type="text" class="rightAligned" name="txtLocalAmount" style="width: 120px;" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 20%;">Particulars</td>
						<td class="leftAligned" colspan="5" style="width: 600px;">
							<div class="withIconDiv" style="float: left; width: 672px">
								<textarea type="text" id="txtParticulars" class="withIcon" style="width: 640px; resize:none;" readonly="readonly" name="txtParticulars" onkeyup="limitText(this,4000);" onkeydown="limitText(this,4000);"/></textarea>
								<img id="editTxtParticulars" alt="edit" style="width: 14px; height: 14px; margin: 3px; float: right;" src="/Geniisys/images/misc/edit.png">
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	
	<div class="sectionDiv" id="checkReleaseInfoFormDiv" changeTagAttr="true">
		<div id="" style="padding-top: 15px; padding-left: 80px; float: left;">
			<table style="float: left;">
				<tbody>
					<tr>
						<td class="rightAligned">Release Date</td>
						<td class="leftAligned" style="width: 280px;">
							<div id="txtReleaseDateDiv" class="required" style="border: solid 1px gray; float: left; width: 181px; height: 21px;" name="txtReleaseDateDiv">
								<input id="txtReleaseDate" class="required" type="text" value="" name="txtReleaseDate" style="border: none; width: 155px; height: 12px;" pre-text="" readonly="readonly">
								<img id="hrefReleaseDate" alt="Release Date" src="/Geniisys/images/misc/but_calendar.gif">
							</div>
						</td>
						<td class="rightAligned">Or No</td>
						<td class="leftAligned" style="width: 180px;">
							<input id="txtORNo" type="text" style="width: 150px;" name="txtORNo" maxlength="10">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Release by</td>
						<td class="leftAligned" style="width: 280px;">
							<input id="txtReleaseBy" type="text" class="required" style="width: 175px;" name="txtReleaseBy" maxlength="30">
						</td>
						<td class="rightAligned">Or Date</td>
						<td class="leftAligned" colspan="2" style="width: 180px;">
							<div id="txtORDateDiv" class="withIconDiv" style="float: left; width: 156px;" name="txtORDateDiv">
								<input id="txtORDate" class="withIcon" type="text" value="" name="txtORDate" style="width: 132px;" pre-text="" readonly="readonly">
								<img id="hrefORDate" onclick="scwShow($('txtORDate'),this, null);" alt="OR Date" src="/Geniisys/images/misc/but_calendar.gif">
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Received By</td>
						<td class="leftAligned" style="width: 280px;">
							<input id="txtReceiveBy" class="required"  type="text" style="width: 175px;" name="txtReceiveBy" maxlength="30">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned" style="width: 280px;">
							<input id="txtUserId" type="text" readonly="readonly" style="width: 175px;" name="txtUserId">
						</td>
						<td class="rightAligned">Last Update</td>
						<td class="leftAligned" style="width: 125px;">
							<input id="txtLastUpdate" type="text" readonly="readonly" style="width: 150px;" name="txtLastUpdate">
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="" style="float: right; margin-top: 15px; width: 130px; height: 140px; padding-right: 70px;">
			<table>
				<tbody>
					<tr>
					<td style="padding-top: 10px;">
						<table class="sectionDiv" style="padding-top:15px; padding-bottom:15px; width: 130px;">
							<tbody>
								<tr height="25px">
									<td>
										<input id="unreleased" type="radio" value="Unreleased" checked="" name="status">
									</td>
									<td align="left">Unreleased</td>
								</tr>
								<tr height="25px">
									<td>
										<input id="released" type="radio" value="Released" checked="" name="status">
									</td>
									<td align="left">Released</td>
								</tr>
								<tr height="25px">
									<td>
										<input id="all" type="radio" value="All" checked="checked" name="status">
									</td>
									<td align="left">All</td>
								</tr>
							</tbody>
						</table>
					</td>
				</tbody>
			</table>
		</div>
	</div>
	<div class="sectionDiv" style="height: 90px;">
		<div id="" class="buttonsDiv" changetagattr="true" style="float:left; width: 100%; padding-top: 20px;">
			<input id="btnSave" class="button" type="button" tabindex="112/" value="Save" name="btnSave">
			<input id="btnCancel" class="button" type="button" tabindex="113/" value="Cancel" name="btnCancel">
		</div>
	</div>
	<input type="hidden" id="hidFundCd" name="hidFundCd"/>
	<input type="hidden" id="hidBranchCd" name="hidBranchCd"/>
	<input type="hidden" id="hidStatus" name="hidStatus"/>
	<input type="hidden" id="hidStatusName" name="hidStatusName"/>
	<input type="hidden" id="txtGACCTranId" name="txtGACCTranId"/>
	<input type="hidden" id="txtItemNo" name="txtItemNo"/>
	<input type="hidden" id="txtCheckPrefSuf" name="txtCheckPrefSuf"/>
	<input type="hidden" id="txtCheckNo" name="txtCheckNo"/>
	<input type="hidden" id="hidUserId" name="hidUserId" value="${userId}"/>
</div>

<script type="text/javascript">
	setModuleId("GIACS046");
	setDocumentTitle("Check Release Info");
	initializeAll();
	initializeAccordion();
	initializeAllMoneyFields();
	var selectedObjRow = null;
	var jsonCheckReleaseInfo = JSON.parse('${jsonCheckReleaseInfo}');
	var changeTag = 0;
	var dateReleaseBy = 0;
	var dateToday = ignoreDateTime(new Date());
	checkUserAccess();
	
	function checkUserAccess(){
		try{
			new Ajax.Request(contextPath+"/GIACAccTransController?action=checkUserAccess2", {
				method: "POST",
				parameters: {
					moduleName: "GIACS046"
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(response.responseText == 0){
						showWaitingMessageBox('You are not allowed to access this module.', imgMessage.ERROR, 
								function(){
							goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
						});  
						
					}
				}
			});
		}catch(e){
			showErrorMessage('checkUserAccess', e);
		}
	}
	
	var loadingCond = false;
	function initGiacs046() {//added by steven 05.05.2014 
		try {
			var url = null;
			if (objACGlobal.callingForm == "GIACS047") { 
				loadingCond = true;
				var objFilter = "{\"gaccTranId\":"+objACGlobal.gaccTranId+"}";
				url = "/GIACInquiryController?action=showCheckReleaseInfo&refresh=1&fundCd=" + objACGlobal.fundCd
																			    + "&branchCd=" + objACGlobal.branchCd 
																				+ "&statusFilter="
																				+ "&objFilter=" + objFilter;
				disableInputField("txtFundDesc");
				disableInputField("txtBranchName");
				disableSearch("imgSearchFund");
				disableSearch("imgSearchBranch");
				enableToolbarButton("btnToolbarEnterQuery"); 
				$("txtFundDesc").value = objACGlobal.fundCd +" - "+objACGlobal.fundName;
				$("txtBranchName").value = objACGlobal.branchCd +" - "+objACGlobal.branchName;
				$("hidFundCd").value = objACGlobal.fundCd;
				$("hidBranchCd").value = objACGlobal.branchCd;
			}else{
				loadingCond = false;
				url = "/GIACInquiryController?action=showCheckReleaseInfo&refresh=1";
			}
			return url;
		} catch (e) {
			showErrorMessage('initGiacs046',e);
		}
	}
	checkReleaseInfoTableModel = {
			url : contextPath + initGiacs046(),
			options : {
				hideColumnChildTitle : true,
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
					onFilter : function() {
						setDetailsForm(null);
						tbgAccCheckReleaseInfo.keys.removeFocus(tbgAccCheckReleaseInfo.keys._nCurrentFocus, true);
						tbgAccCheckReleaseInfo.keys.releaseKeys();
						disableFormButton();
					}
				},
				width : '750px', 
				height : '250px',
				onCellFocus : function(element, value, x, y, id) {
					tbgAccCheckReleaseInfo.keys.removeFocus(tbgAccCheckReleaseInfo.keys._nCurrentFocus, true);
					tbgAccCheckReleaseInfo.keys.releaseKeys();
					setDetailsForm(tbgAccCheckReleaseInfo.geniisysRows[y]);
					dateReleaseBy = 0;
					enableFields();
				},
				prePager : function() {
					setDetailsForm(null);
					tbgAccCheckReleaseInfo.keys.removeFocus(tbgAccCheckReleaseInfo.keys._nCurrentFocus, true);
					tbgAccCheckReleaseInfo.keys.releaseKeys();
					disableFormButton();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					setDetailsForm(null);
					tbgAccCheckReleaseInfo.keys.removeFocus(tbgAccCheckReleaseInfo.keys._nCurrentFocus, true);
					tbgAccCheckReleaseInfo.keys.releaseKeys();
					disableFormButton();
					disableFields();
				},
				afterRender : function() {
					setDetailsForm(null);
					tbgAccCheckReleaseInfo.keys.removeFocus(tbgAccCheckReleaseInfo.keys._nCurrentFocus, true);
					tbgAccCheckReleaseInfo.keys.releaseKeys();
					disableFormButton();
				},
				onSort : function() {
					setDetailsForm(null);
					tbgAccCheckReleaseInfo.keys.removeFocus(tbgAccCheckReleaseInfo.keys._nCurrentFocus, true);
					tbgAccCheckReleaseInfo.keys.releaseKeys();
					disableFormButton();
				}
			},
			columnModel : [ {
				id : 'recordStatus',
				title : '',
				width : '0',
				visible : false
			}, {
				id : 'divCtrId',
				width : '0',
				visible : false
			}, {
				id : "checkNumber",
				title : "Check No.",
				width : '120px',
				titleAlign : 'left',
				align : 'left'
			}, {				
				id : "checkNo",
				title : "Check No.",
				width : '0px',
				visible : false,
				filterOption : true,
			}, {
				id : "checkDate",
				title : "Check Date",
				titleAlign : 'right',
				filterOption : true,
				align : 'center',
				renderer: function(value){
					return dateFormat(value, "mm-dd-yyyy");
				},
				filterOptionType : 'formattedDate'
			},{							//SR19642 Lara 07092015
				id : "chkStatus",
				title : "Check Status",
				titleAlign : 'left',
				width : '80px',
				filterOption : true,
				align : 'left'
			},{							//end
				id : "dvNumber",
				title : "DV No.",
				titleAlign : 'left',
				width : '120px',
				filterOption : false,
				align : 'left'
			},{
				id : "dvNo",
				title : "DV No.",
				width : '0px',
				visible : false,
				filterOption : true,
			},{						//SR19642 Lara 07092015
				id : "dvStatus",		
				title : "DV Status",
				titleAlign : 'left',
				width : '120px',
				filterOption : true,
				align : 'left'
			},{						//end
				id : "payee",
				title : "Payee",
				titleAlign : 'left',
				width : '248px',
				filterOption : true,
				align : 'left',
			}, {
		    	id:'fCurrencyAmt',
		    	title: 'Check Amount',
		    	titleAlign: 'right',
		    	width : '200px',
		    	children: [
		    	   	    {	id: 'shortName',
		    	   	    	width : 40,
					    	align: 'center',
					    },
					    {	id: 'fCurrencyAmt',
					    	align: 'right',
					    	width : 100,
					    	geniisysClass: 'money',
					    }
		    		]
		    }],
			rows : jsonCheckReleaseInfo.rows
		};
	
	tbgAccCheckReleaseInfo = new MyTableGrid(checkReleaseInfoTableModel);
	tbgAccCheckReleaseInfo.pager = jsonCheckReleaseInfo;
	tbgAccCheckReleaseInfo.render('checkReleaseInfoTable');
	tbgAccCheckReleaseInfo.afterRender = function () {
		if (loadingCond) { //added by steven 05.05.2014
			loadingCond = false;
			tbgAccCheckReleaseInfo.refresh();
		}
	};
	
	$("btnToolbarExit").observe("click", function() { //added by steven 05.05.2014
		if (objACGlobal.callingForm == "GIACS047") {
			tbgAccCheckReleaseInfo.keys.releaseKeys();
			$("customContents").update("");
			$("customContents").hide();
			$("updateCheckStatusMainDiv").show();
			setModuleId("GIACS047");
		}else{
			resetGlobal();
		}
	});
	
	$("btnCancel").observe("click", function() {
		if (objACGlobal.callingForm == "GIACS047") { //added by steven 05.05.2014
			tbgAccCheckReleaseInfo.keys.releaseKeys();
			tbgAccCheckReleaseInfo.keys.releaseKeys();
			$("customContents").update("");
			$("customContents").hide();
			$("updateCheckStatusMainDiv").show();
			setModuleId("GIACS047");
		}else{
			resetGlobal();
		}
	});
	
	function setDetailsForm(rec) {
		try {
			$("txtBankSname").value = rec == null ? "" : rec.bankSname;
			$("txtBankAccount").value = rec == null ? "" : rec.bankAcctNo;
			$("txtParticulars").value = rec == null ? "" : unescapeHTML2(rec.particulars);
			$("txtLocalAmount").value = rec == null ? "" : formatCurrency(rec.amount);
			$("txtReleaseDate").value = rec == null ? "" : rec.checkReleaseDate == null ? "" : dateFormat(rec.checkReleaseDate, "mm-dd-yyyy");
			$("txtORNo").value = rec == null ? "" : unescapeHTML2(rec.orNo);
			$("txtORDate").value = rec == null ? "" : rec.orDate == null ? "" : dateFormat(rec.orDate, "mm-dd-yyyy");
			$("txtReleaseBy").value = rec == null ? "" : unescapeHTML2(rec.checkReleasedBy);
			$("txtReceiveBy").value = rec == null ? "" : unescapeHTML2(rec.checkReceivedBy);
			$("txtUserId").value = rec == null ? "" : rec.userID;
			$("txtLastUpdate").value = rec == null ? "" : rec.lastUpdate == null ? "" : rec.lastUpdate;
			
			
			/* Hidden fields set for saving purposes */
			$("txtGACCTranId").value = rec == null ? "" : rec.gaccTranId;
			$("txtItemNo").value = rec == null ? "" : rec.itemNo;
			$("txtCheckPrefSuf").value = rec == null ? "" : rec.checkPrefSuf;
			$("txtCheckNo").value = rec == null ? "" : rec.checkNo;
		} catch (e) {
			showErrorMessage("setDetailsForm", e);
		}
	}
	
	function resetGlobal(){
		objACGlobal.gaccTranId = null;
		objACGlobal.branchCd = null;
		objACGlobal.fundCd = null;
		objAC.fromMenu = null;
		objAC.showOrDetailsTag = null;
		objAC.butLabel = null;
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
	}
	
	observeReloadForm("reloadCheckReleaseInfo", function() {
		if (objACGlobal.callingForm == "GIACS047") { //added by steven 05.05.2014
			$("btnCheckReleaseInfo").click();
		} else {
			new Ajax.Request(contextPath + "/GIACInquiryController", {
				parameters : {
					action : "showCheckReleaseInfo"
				},
				onCreate : showNotice("Loading, please wait..."),
				onComplete : function(response) {
					hideNotice();
					try {
						if (checkErrorOnResponse(response)) {
							$("mainContents").update(response.responseText);
							exec = false;
						}
					} catch (e) {
						showErrorMessage("showCheckReleaseInfo - onComplete : ", e);
					}
				}
			});
		}
	});
	
	function disableFormButton(){
		disableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarPrint");
	}
	
	$("btnToolbarEnterQuery").observe("click", function() {
		fireEvent($("reloadCheckReleaseInfo"), "click");
	});
	
	$("btnToolbarExecuteQuery").observe("click", function() {
		if ($("txtFundDesc").value != "" && $("txtBranchName").value != "") {
			exec = true;
			execute();
		}
	});
	
	$$("input[name='status']").each(function(btn) {
		btn.observe("click", function() {
			$("hidStatus").value = $F(btn).substring(0,1);
			$("hidStatusName").value = $F(btn);
			if ($("txtFundDesc").value != null && $("txtBranchName").value != "" && exec == true) {
				execute();
			}
		});
	});
	
	function execute() {
		if (objACGlobal.callingForm == "GIACS047") { //added by steven 05.05.2014
			var objFilter = "{\"gaccTranId\":"+objACGlobal.gaccTranId+"}";
			tbgAccCheckReleaseInfo.url = contextPath + "/GIACInquiryController?action=showCheckReleaseInfo&refresh=1&fundCd=" + objACGlobal.fundCd
																											     + "&branchCd=" + objACGlobal.branchCd 
																											 	 + "&statusFilter="
																												 + "&objFilter=" + objFilter;
			tbgAccCheckReleaseInfo._refreshList();
			disableInputField("txtFundDesc");
			disableInputField("txtBranchName");
			disableSearch("imgSearchFund");
			disableSearch("imgSearchBranch");
			disableToolbarButton("btnToolbarEnterQuery");
		}else{
			tbgAccCheckReleaseInfo.url = contextPath + "/GIACInquiryController?action=showCheckReleaseInfo&refresh=1&fundCd=" + $F("hidFundCd")
																												 + "&branchCd=" + $F("hidBranchCd") + "&statusFilter=" + $F("hidStatus");
			tbgAccCheckReleaseInfo._refreshList();
			disableInputField("txtFundDesc");
			disableInputField("txtBranchName");
			disableSearch("imgSearchFund");
			disableSearch("imgSearchBranch");
			enableToolbarButton("btnToolbarEnterQuery");
			// added by shan 09.24.2014
			disableToolbarButton("btnToolbarExecuteQuery");
			if(tbgAccCheckReleaseInfo.geniisysRows.length == 0){
				showMessageBox("Query caused no records to be retrieved. Re-enter.", "I");
			}
			// end 09.24.2014
		}
	};
	
	$("imgSearchFund").observe("click", function() {
		enableToolbarButton("btnToolbarEnterQuery");
		showGIACSInquiryFundLOV("getGIACSInquiryFundLOV", $("txtFundDesc"), "Code", "Description", $("hidFundCd"), $("txtBranchName"), "txtFundDesc");
	});
	
	$("txtFundDesc").observe("change", function() {
		enableToolbarButton("btnToolbarEnterQuery");
		$("hidFundCd").value = null;
		disableToolbarButton("btnToolbarExecuteQuery");
		showGIACSInquiryFundLOV("getGIACSInquiryFundLOV", $("txtFundDesc"), "Code", "Description", $("hidFundCd"), $("txtBranchName"), "txtFundDesc");
	});
	
	/* $("imgSearchBranch").observe("click", function() {
		enableToolbarButton("btnToolbarEnterQuery");
		showGIACSInquiryBranchLOV("GIACS046", "getGIACSInquiryBranchLOV", $("hidFundCd"), $("txtBranchName"), "Code", "Description", $("hidBranchCd"), $F("txtFundDesc"), "txtBranchName");
	});
	
	$("txtBranchName").observe("change", function() {
		enableToolbarButton("btnToolbarEnterQuery");
		$("hidBranchCd").value = null;
		disableToolbarButton("btnToolbarExecuteQuery");
		showGIACSInquiryBranchLOV("GIACS046", "getGIACSInquiryBranchLOV", $("hidFundCd"), $("txtBranchName"), "Code", "Description", $("hidBranchCd"), $F("txtFundDesc"), "txtBranchName");
	}); */
	
	$("txtBranchName").setAttribute("lastValidValue", "");
	$("imgSearchBranch").observe("click", showGiacs046BranchLov);
	
	function showGiacs046BranchLov(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "getGiacs046BranchLov",
							moduleId :  "GIACS046",
							filterText : ($("txtBranchName").readAttribute("lastValidValue").trim() != $F("txtBranchName").trim() ? $F("txtBranchName").trim() : ""),
							page : 1},
			title: "List of Branches",
			width: 500,
			height: 400,
			columnModel : [
							{
								id : "branchCd",
								title: "Code",
								width: '100px',
								filterOption: true
							},
							{
								id : "branchName",
								title: "Branch",
								width: '325px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtBranchName").readAttribute("lastValidValue").trim() != $F("txtBranchName").trim() ? $F("txtBranchName").trim() : ""),
				onSelect: function(row) {
					enableToolbarButton("btnToolbarEnterQuery");
					if($F("txtFundDesc") != ""){
						$("hidBranchCd").value = row.branchCd;
						$("txtBranchName").value = row.branchName;
						$("txtBranchName").setAttribute("lastValidValue", row.branchName);
						enableToolbarButton("btnToolbarExecuteQuery");
					}else{
						$("hidBranchCd").value = row.branchCd;
						$("txtBranchName").value = row.branchName;
						$("txtBranchName").setAttribute("lastValidValue", row.branchName);
						disableToolbarButton("btnToolbarExecuteQuery");
					}
				},
				onCancel: function (){
					$("txtBranchName").value = $("txtBranchName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtBranchName").value = $("txtBranchName").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	$("btnSave").observe("click", function() {
		if(changeTag == 0){
			showMessageBox("No changes to save." ,imgMessage.INFO);
		} else {
			if($("txtCheckNo").value == "" || $("txtReleaseDate").value == "" || $("txtReleaseBy").value == "" || $("txtReceiveBy").value == ""){
				showMessageBox("Required fields must be entered.", imgMessage.ERROR);
			} else {
				saveCheckReleaseInfo();	
				changeTag = 0;	
			}
		}
	});
	
	function saveCheckReleaseInfo()	{
		try{
			var gaccTranId = $F("txtGACCTranId");
			var itemNo = $F("txtItemNo");
			var checkPrefSuf = $F("txtCheckPrefSuf");
			var checkNo = $F("txtCheckNo");
			var checkReleaseDate = $F("txtReleaseDate");
			var orNo = $F("txtORNo");
			var releaseBy = $F("txtReleaseBy");
			var orDate = $F("txtORDate");
			var receiveBy = $F("txtReceiveBy");
			
			new Ajax.Request(contextPath
					+ "/GIACInquiryController", {
				method : "POST",
				parameters : {
					action : "saveCheckReleaseInfo",
					gaccTranId : gaccTranId,
					itemNo : itemNo,
					checkPrefSuf : checkPrefSuf,
					checkNo : checkNo,
					checkReleaseDate : checkReleaseDate,
					orNo : orNo,
					releaseBy : releaseBy,
					orDate : orDate,
					receiveBy : receiveBy
				},
				onCreate : function() {
					showNotice("Saving, please wait...");
				},
				onComplete : function(response) {
					hideNotice("");
					showMessageBox("Saving successful.", imgMessage.SUCCESS);
					exec = true;
					//execute();	// replaced with codes below, tablegrid should not refresh as per Albert : shan 09.24.2014
					$("txtUserId").value = userId;
					$("txtLastUpdate").value = dateFormat(new Date(), 'mm-dd-yyyy hh:MM:ss TT');
					
					if (objACGlobal.callingForm == "GIACS047"){	// added by shan 10.08.2014
						for (var i=0; i<tbgChkDisbursement.geniisysRows.length; i++){
							if (tbgChkDisbursement.geniisysRows[i].gaccTranId == gaccTranId 
									&& tbgChkDisbursement.geniisysRows[i].itemNo == itemNo){
								tbgChkDisbursement.geniisysRows[i].checkReleaseDate = checkReleaseDate;
								//tbgChkDisbursement.updateVisibleRowOnly(tbgChkDisbursement.geniisysRows[i], i, false);	
								tbgChkDisbursement.setValueAt(checkReleaseDate, tbgChkDisbursement.getColumnIndex("checkReleaseDate"), i);
								
								if (objGIACS047.objChkDisbursement.gaccTranId == gaccTranId && objGIACS047.objChkDisbursement.itemNo == itemNo){
									$("txtCheckReleaseDate").value = checkReleaseDate;
								}
							}							
						}						
					}
				}
			});
		}catch(e){
			showErrorMessage("saveCheckReleaseInfo",e);
		}
	}
	
	$("txtReleaseDate").observe("change", function(){
		changeTag = 1;
		var inputDate = Date.parse($F("txtReleaseDate"));
		if($F("txtReleaseDate") == ""){
			return true;
		}else {
			if(validateInputDate($F("txtReleaseDate"), "releaseDate")){
				if (inputDate != null){
					$("txtReleaseDate").value = inputDate.format("mm-dd-yyyy");			
				}
			}else{
				customShowMessageBox("Date must be entered in a format like MM-DD-RRRR.", imgMessage.INFO, "releaseDate");
				$("txtReleaseDate").value = "";
				return false;
			}
		}
	});
	
	$("txtORDate").observe("change", function(){
		changeTag = 1;
		var inputDate = Date.parse($F("txtORDate"));
		if($F("txtORDate") == ""){
			return true;
		}else {
			if(validateInputDate($F("txtORDate"), "orDate")){
				if (inputDate != null){
					$("txtORDate").value = inputDate.format("mm-dd-yyyy");			
				}
			}else{
				customShowMessageBox("Date must be entered in a format like MM-DD-RRRR.", imgMessage.INFO, "orDate");
				$("txtORDate").value = "";
				return false;
			}
		}
	});
	
	// Originally in CS this kind of process is done, will remove this because QA filed an SR for this. :D Joms
	$("txtReleaseDate").observe("change", function(){
		changeTag = 1;
		dateReleaseBy = 1;
	});
	
	$("txtReleaseDate").observe("focus", function(){
		/* if(dateReleaseBy == 0){
			$("txtReleaseDate").value = dateFormat(dateToday, "mm-dd-yyyy");
			$("txtReleaseBy").value = $F("hidUserId");	
		} */
		if($F("txtReleaseDate") == ""){
			$("txtReleaseDate").value = dateFormat(dateToday, "mm-dd-yyyy");
			$("txtReleaseBy").value = $F("hidUserId");	
		}
	});
	
	$("txtORNo").observe("focus", function(){
		/* if(dateReleaseBy == 0){
			$("txtReleaseDate").value = dateFormat(dateToday, "mm-dd-yyyy");
			$("txtReleaseBy").value = $F("hidUserId");	
		} */
		if($F("txtReleaseDate") == ""){
			$("txtReleaseDate").value = dateFormat(dateToday, "mm-dd-yyyy");
			$("txtReleaseBy").value = $F("hidUserId");	
		}
	});
	
	$("txtORDate").observe("focus", function(){
		/* if(dateReleaseBy == 0){
			$("txtReleaseDate").value = dateFormat(dateToday, "mm-dd-yyyy");
			$("txtReleaseBy").value = $F("hidUserId");	
		} */
		if($F("txtReleaseDate") == ""){
			$("txtReleaseDate").value = dateFormat(dateToday, "mm-dd-yyyy");
			$("txtReleaseBy").value = $F("hidUserId");	
		}
	});
	
	$("txtReleaseBy").observe("focus", function(){
		/* if(dateReleaseBy == 0){
			$("txtReleaseDate").value = dateFormat(dateToday, "mm-dd-yyyy");
			$("txtReleaseBy").value = $F("hidUserId");	
		} */
		if($F("txtReleaseDate") == ""){
			$("txtReleaseDate").value = dateFormat(dateToday, "mm-dd-yyyy");
			$("txtReleaseBy").value = $F("hidUserId");	
		}
	});
	
	$("txtReceiveBy").observe("focus", function(){
		/* if(dateReleaseBy == 0){
			$("txtReleaseDate").value = dateFormat(dateToday, "mm-dd-yyyy");
			$("txtReleaseBy").value = $F("hidUserId");	
		} */
		if($F("txtReleaseDate") == ""){
			$("txtReleaseDate").value = dateFormat(dateToday, "mm-dd-yyyy");
			$("txtReleaseBy").value = $F("hidUserId");	
		}
	});
	// End of undecided process
	
	$("txtORNo").observe("change", function(){
		changeTag = 1;
	});
	
	$("txtORDate").observe("change", function(){
		changeTag = 1;
	});
	
	$("txtORDate").observe("blur", function(){
		changeTag = 1;
	});
	
	$("txtReleaseDate").observe("blur", function(){
		changeTag = 1;
	});
	
	$("txtReleaseBy").observe("change", function(){
		changeTag = 1;
		dateReleaseBy = 1;
	});
	
	$("txtReceiveBy").observe("change", function(){
		changeTag = 1;
	});
	
	$("editTxtParticulars").observe("click", function() {
		showOverlayEditor("txtParticulars", 4000, $("txtParticulars").hasAttribute("readonly"));
	});
	
	$("hrefReleaseDate").observe("click", function(){
		scwNextAction = function(){
							if (compareDatesIgnoreTime(Date.parse($F("txtReleaseDate")), new Date()) == -1){
								showMessageBox("Release Date should not be later than the current date.", "I");
								$("txtReleaseDate").clear();
							}
						}.runsAfterSCW(this, null);
		
		scwShow($('txtReleaseDate'),this, null);
	});
	
	function validateInputDate(str, elemName){
		var text = str; 
		var comp = text.split('-');
		var m = parseInt(comp[0], 10);
		var d = parseInt(comp[1], 10);
		var y = parseInt(comp[2], 10);
		var status = true;
		var isMatch = text.match(/^(\d{1,2})-(\d{1,2})-(\d{4})$/);
		var date = new Date(y,m-1,d);
		
		if(isNaN(y) || isNaN(m) || isNaN(d) || y.toString().length < 4 || !isMatch ){
			customShowMessageBox("Date must be entered in a format like MM-DD-RRRR.", imgMessage.INFO, elemName);
			status = false;
		}
		if(0 >= m || 13 <= m){
			customShowMessageBox("Month must be between 1 and 12.", imgMessage.INFO, elemName);	
			status = false; 
		}
		if(date.getDate() != d){				
			customShowMessageBox("Day must be between 1 and the last of the month.", imgMessage.INFO, elemName);	
			status = false;
		}
		return status;
	}
	
	function disableFields(){
		$("txtORNo").disabled = true;
		$("txtReleaseBy").disabled = true;
		$("txtReceiveBy").disabled = true;
		disableDate("hrefReleaseDate");
		disableDate("hrefORDate");
	}
	
	function enableFields(){
		$("txtORNo").disabled = false;
		$("txtReleaseBy").disabled = false;
		$("txtReceiveBy").disabled = false;
		enableDate("hrefReleaseDate");
		enableDate("hrefORDate");
	}
	
	
	$("txtFundDesc").focus();
	initializeAll();
	disableFormButton();
	disableFields();
	disableToolbarButton("btnToolbarEnterQuery");
	hideToolbarButton("btnToolbarPrint");
</script>