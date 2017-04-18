<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="mainNav" name="mainNav">
	<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
		<ul>
			<li><a id="acExit">Exit</a></li>
		</ul>
	</div>
</div>
<div id="giacs032MainDiv" name="giacs032MainDiv" style="height: 770px;">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Post Dated Checks Inquiry Screen</label>
	   	</div>
	</div>	
	<div id="giacs032" name="giacs032">
		<div id="queryFormDiv" align="center" class="sectionDiv" style="padding-top:20px; padding-bottom: 20px;">
			<table cellspacing="0" style="width: 900px;">
				<tr>
					<td class="rightAligned" style="width:60px;">Fund</td>
					<td class="leftAligned" style="width:350px;">
						<span class="lovSpan required" style="width: 70px; height: 21px; margin: 2px 2px 0 0; float: left;">
							<input type="text" id="txtFundCdPdc" name="txtFundCdPdc" ignoreDelKey="1" style="width: 43px; float: left; border: none; height: 13px;" class="disableDelKey allCaps required" maxlength="3" tabindex="101" />
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchFund" name="searchFund" alt="Go" style="float: right;">
						</span> 
						<span class="lovSpan " style="border: none; height: 21px; margin: 0 2px 0 2px; float: left;">
							<input type="text" id="txtFundDesc" name="txtFundDesc" ignoreDelKey="1" style="width: 250px; float: left; height: 15px;" class="allCaps required" maxlength="50" readonly="readonly" tabindex="102" />
						</span>
					</td>
					<td class="rightAligned" style="width:60px;">Branch</td>
					<td class="leftAligned" style="width:350px;">
						<span class="lovSpan required" style="width: 70px; height: 21px; margin: 2px 2px 0 0; float: left;">
							<input type="text" id="txtBranchCdPdc" name="txtBranchCdPdc" ignoreDelKey="1" style="width: 43px; float: left; border: none; height: 13px;" class="required disableDelKey allCaps" maxlength="2" tabindex="103" />
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranch" name="searchBranch" alt="Go" style="float: right;">
						</span> 
						<span class="lovSpan " style="border: none; height: 21px; margin: 0 2px 0 2px; float: left;">
							<input type="text" id="txtBranchName" name="txtBranchName" ignoreDelKey="1" style="width: 250px; float: left; height: 15px;" class="allCaps required" maxlength="20" readonly="readonly" tabindex="104" />
						</span>
					</td>
				</tr>
			</table>
		</div>		
	</div>
	<div class="sectionDiv" style="margin-bottom: 20px;">
		<div id="postDatedChecksTableDiv" style="padding-top: 10px;">
			<div id="postDatedChecksTable" style="height: 331px; padding-left: 10px;"></div>
		</div>
		<div align="center" id="postDatedChecksFormDiv" style="float: left;">
			<table style="margin-top: 20px; margin-left: 70px;">
				<tr>
					<td width="" class="rightAligned">Particulars</td>
					<td class="leftAligned" colspan="3">
						<input id="txtParticulars" type="text" class="required allCaps" style="width: 533px;" tabindex="201" readonly="readonly">
					</td>
				</tr>				
				<tr>
					<td class="rightAligned">Transaction No.</td>
					<td class="leftAligned">
						<input id="txtTranYear" type="text" class="rightAligned" style="width: 50px;" readonly="readonly" tabindex="202">
						<input id="txtTranMonth" type="text" class="rightAligned" style="width: 60px;" readonly="readonly" tabindex="203">
						<input id="txtTranSeqNo" type="text" class="rightAligned" style="width: 66px;" readonly="readonly" tabindex="204">
					</td>
					<td width="" class="rightAligned" style="width: 113px;">DCB Date</td>
					<td class="leftAligned"><input id="txtDcbDate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="205"></td>
				</tr>	
				<tr>
					<td class="rightAligned">User</td>
					<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="206"></td>
					<td width="" class="rightAligned" style="width: 113px;">Last Update</td>
					<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="207"></td>
				</tr>
				<tr>
					<td colspan="4">
						<div style="margin-top: 25px;" align="right">
							<input type="button" class="button" id="btnForDeposit" value="For Deposit" tabindex="301" style="width: 100px;">
							<input type="button" class="button" id="btnReplace" value="Replace" tabindex="302" style="width: 100px;">
							<input type="button" class="button" id="btnPrint" value="Print" tabindex="303" style="width: 100px;">
							<input type="button" class="button" id="btnApply" value="Apply" tabindex="304" style="width: 100px;">
							<input type="button" class="button" id="btnReplacementHistory" value="Replacement History" tabindex="305" style="width: 138px;">
						</div>
					</td>
				</tr>		
			</table>
		</div>
		<div align="center" style="margin-bottom: 20px; margin-top: 20px;">
			<fieldset style="width: 120px;">
				<table>
					<tr>
						<td>
							<input type="radio" name="checkFlag" id="rdoOnHold" style="float: left; margin: 0px 2px 3px 3px;" tabindex="301" checked="checked"/>
							<label for="rdoOnHold" style="float: left; width: 96px;" title="On Hold">On Hold</label>
						</td>
					</tr>
					<tr>
						<td>
							<input type="radio" name="checkFlag" id="rdoForDeposit" style="float: left; margin: 0px 2px 3px 3px;" tabindex="302" />
							<label for="rdoForDeposit" style="float: left; width: 96px;" title="For Deposit">For Deposit</label>
						</td>
					</tr>
					<tr>
						<td>
							<input type="radio" name="checkFlag" id="rdoWithDetails" style="float: left; margin: 0px 2px 3px 3px;" tabindex="303" />
							<label for="rdoWithDetails" style="float: left; width: 96px;" title="With Details">With Details</label>
						</td>
					</tr>
					<tr>
						<td>
							<input type="radio" name="checkFlag" id="rdoApplied" style="float: left; margin: 0px 2px 3px 3px;" tabindex="304" />
							<label for="rdoApplied" style="float: left; width: 96px;" title="Applied">Applied</label>
						</td>
					</tr>
					<tr>
						<td>
							<input type="radio" name="checkFlag" id="rdopReplaced" style="float: left; margin: 0px 2px 3px 3px;" tabindex="305" />
							<label for="rdopReplaced" style="float: left; width: 96px;" title="Replaced">Replaced</label>
						</td>
					</tr>
					<tr>
						<td>
							<input type="radio" name="checkFlag" id="rdoCancelled" style="float: left; margin: 0px 2px 3px 3px;" tabindex="306" />
							<label for="rdoCancelled" style="float: left; width: 96px;" title="Cancelled">Cancelled</label>
						</td>
					</tr>
					<tr>
						<td>
							<input type="radio" name="checkFlag" id="rdoAll" style="float: left; margin: 0px 2px 3px 3px;" tabindex="307" />
							<label for="rdoAll" style="float: left; width: 96px;" title="All">All</label>
						</td>
					</tr>
				</table>
			</fieldset>
		</div>
	</div>
</div>
<div id="giacs031MainDiv" name="giacs031MainDiv"">
</div>
<script type="text/javascript">	
	$("giacs031MainDiv").hide();
	$("mainNav").hide();
	setModuleId("GIACS032");
	setDocumentTitle("Post Dated Checks Inquiry Screen");
	initializeAll();
	initializeAccordion();
	disableToolbarButton("btnToolbarEnterQuery");
	disableToolbarButton("btnToolbarExecuteQuery");
	disableToolbarButton("btnToolbarPrint");
	disableButton("btnForDeposit");
	disableButton("btnReplace");
	disableButton("btnPrint");
	disableButton("btnApply");
	disableButton("btnReplacementHistory");
	onQuery = false;
	onClickButtonEnable = false;
	
	//groupSw
	selectCheck = "";
	checkboxVal = "";
	group = [];
	currY = 0;
	var objCurrPostDatedCheck = null;
	
	function tableCheckBox(sw, checkRec){
		if(sw == "Y"){
			checkStatus(checkRec);
		} else if (sw == "N"){
			removeToGroup(checkRec.itemId);
		}
	}
	
	function removeToGroup(check){
		for (var i = 0; i < group.length; i++) {
			if(group[i] == check){
				group.splice(i, 1);
			}
		}
	}
	
	function insertToGroup(check){
		var notExist = true;
		if(group.length == 0){
			group.push(check);
			notExist = false;
		} else {
			for ( var i = 0; i < group.length; i++) {
				if(group[i] == check){
					notExist = false;
					break;
				}
			}
		}
		if(notExist){
			group.push(check);
		}
	}
	
	function checkStatus(checkRec){
		if(checkRec.checkFlag == "A"){
			showWaitingMessageBox("Check has already been applied.", "I", function(){
				tbgPostDatedChecks.setValueAt(false, tbgPostDatedChecks.getColumnIndex('sw'), currY, true);
			});
			changeTag = 0;
		} else if(checkRec.checkFlag == "C"){
			showWaitingMessageBox("Check has already been cancelled.", "I", function(){
				tbgPostDatedChecks.setValueAt(false, tbgPostDatedChecks.getColumnIndex('sw'), currY, true);
			});
			changeTag = 0;
		} else {
			insertToGroup(checkRec.itemId);
		}
	}
	
	var postDatedChecks = {
			url : contextPath + "/GIACPdcChecksController?action=showGiacs032&refresh=1",
			id: "postDatedChecks",
			options : {
				width : '900px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					currY = y;
					checkboxVal = tbgPostDatedChecks.rows[y][tbgPostDatedChecks.getColumnIndex('sw')];
					tableCheckBox(checkboxVal , tbgPostDatedChecks.geniisysRows[y]);
					setFieldValues(tbgPostDatedChecks.geniisysRows[y]);
					tbgPostDatedChecks.keys.removeFocus(tbgPostDatedChecks.keys._nCurrentFocus, true);
					tbgPostDatedChecks.keys.releaseKeys();
				},
				onRemoveRowFocus : function(){
					selectCheck = "";
					checkboxVal = "";
					setFieldValues(null);
					tbgPostDatedChecks.keys.removeFocus(tbgPostDatedChecks.keys._nCurrentFocus, true);
					tbgPostDatedChecks.keys.releaseKeys();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						group = [];
						selectCheck = "";
						checkboxVal = "";
						setFieldValues(null);
						tbgPostDatedChecks.keys.removeFocus(tbgPostDatedChecks.keys._nCurrentFocus, true);
						tbgPostDatedChecks.keys.releaseKeys();
					}
				},
				onSort: function(){
					group = [];
					selectCheck = "";
					checkboxVal = "";
					setFieldValues(null);
					tbgPostDatedChecks.keys.removeFocus(tbgPostDatedChecks.keys._nCurrentFocus, true);
					tbgPostDatedChecks.keys.releaseKeys();
				},
				onRefresh: function(){
					group = [];
					selectCheck = "";
					checkboxVal = "";
					setFieldValues(null);
					tbgPostDatedChecks.keys.removeFocus(tbgPostDatedChecks.keys._nCurrentFocus, true);
					tbgPostDatedChecks.keys.releaseKeys();
				},
				checkChanges: function(){
					return false;
				},
				masterDetailRequireSaving: function(){
					return false;
				},
				masterDetailValidation: function(){
					return false;
				},
				masterDetail: function(){
					return false;
				},
				masterDetailSaveFunc: function() {
					return false;
				},
				masterDetailNoFunc: function(){
					return false;
				}
			},
			columnModel : [
				{ 								
				    id: 'recordStatus',
				    width: '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},
				{
					id: 'sw',
	          		altTitle: "Valid",
	              	width: '25px',
	              	filterOption : false,
	              	sortable: false,
	              	editable: true,
	              	editor: new MyTableGrid.CellCheckbox({
		            	getValueOf : function(value) {
							if (value) {
								return "Y";
							} else {
								return "N";
							}
						}
	              	})
              	},
				{
					id : 'refNo',
					title : "Reference No.",
					filterOption : true,
					width : '120px'
				},
				{
					id : 'bankSname',
					title : 'Bank',
					filterOption : true,
					width : '130px'				
				},
				{
					id : 'checkNo',
					title : 'Check No.',
					filterOption : true,
					width : '150px'				
				},
				{
					id : 'checkDate',
					title : 'Check Date',
					filterOption : true,
					width : '130px',
					filterOptionType : 'formattedDate',
					renderer: function (value){
						var dateTemp;
						if(value=="" || value==null){
							dateTemp = "";
						}else{
							dateTemp = dateFormat(value,"mm-dd-yyyy");
						}
						return dateTemp;
					},
					align: "center",
					titleAlign: "center"
				},
				{
					id : 'amount',
					title : 'Amount',
					align: "right",
					titleAlign: "right",
					filterOption : true,
					filterOptionType : 'number',
					width : '150px',
					geniisysClass : 'money'
				},
				{
					id : 'status',
					title : 'Status',
					filterOption : true,
					width : '150px'				
				},
				{
					id : 'userId',
					width : '0',
					visible: false
				},
				{
					id : 'lastUpdate',
					width : '0',
					visible: false				
				},
				{
					id : 'itemId',
					width : '0',
					visible: false				
				}
			],
			rows : []
		};

		tbgPostDatedChecks = new MyTableGrid(postDatedChecks);
		tbgPostDatedChecks.render("postDatedChecksTable");
		
		$("searchFund").observe("click",function(){
			showFundLOV();
		});
		
		function showFundLOV(){
			try{
				LOV.show({
					controller : "AccountingLOVController",
					urlParameters : {
						  action : "getGiacs032FundCdLOV",
						  filterText: $F("txtFundCdPdc") != $("txtFundCdPdc").getAttribute("lastValidValue") ? nvl(($F("txtFundCdPdc")), "%") : "%",  
							page : 1
					},
					title: "List of Fund Codes",
					width: 470,
					height: 400,
					columnModel: [
			 			{
							id : 'fundCd',
							title: 'Code',
							width : '100px',
							align: 'left'
						},
						{
							id : 'fundDesc',
							title: 'Desc',
						    width: '335px',
						    align: 'left'
						}
					],
					autoSelectOneRecord : true,
					filterText: $F("txtFundCdPdc") != $("txtFundCdPdc").getAttribute("lastValidValue") ? nvl(($F("txtFundCdPdc")), "%") : "%",  
					draggable: true,
					onSelect: function(row) {
						if(row != undefined){
							$("txtFundCdPdc").value = unescapeHTML2(row.fundCd);
							$("txtFundDesc").value = unescapeHTML2(row.fundDesc);
							enableToolbarButton("btnToolbarEnterQuery");
							enableToolbarButton("btnToolbarExecuteQuery");
						}
					},
					onCancel: function(){
						$("txtFundCdPdc").value = $("txtFundCdPdc").getAttribute("lastValidValue");
						$("txtFundDesc").value = $("txtFundDesc").getAttribute("lastValidValue");
						$("txtFundCdPdc").focus();
			  		},
			  		onUndefinedRow: function(){
			  			$("txtFundCdPdc").value = $("txtFundCdPdc").getAttribute("lastValidValue");
						$("txtFundDesc").value = $("txtFundDesc").getAttribute("lastValidValue");
						customShowMessageBox("No record selected.", imgMessage.INFO, "txtFundCdPdc");
			  		}
				});
			}catch(e){
				showErrorMessage("showFundLOV",e);
			}
		}
		
		$("searchBranch").observe("click",function(){
			showBranchLOV();
		});
		
		function showBranchLOV(){
			try{
				LOV.show({
					controller : "AccountingLOVController",
					urlParameters : {
						  action : "getGiacs032BranchCdLOV",
						  fundCd : $F("txtFundCdPdc"),
						  filterText: $F("txtBranchCdPdc") != $("txtBranchCdPdc").getAttribute("lastValidValue") ? nvl(($F("txtBranchCdPdc")), "%") : "%",  
							page : 1
					},
					title: "List of Branches",
					width: 470,
					height: 400,
					columnModel: [
			 			{
							id : 'branchCd',
							title: 'Code',
							width : '100px',
							align: 'left'
						},
						{
							id : 'branchName',
							title: 'Desc',
						    width: '335px',
						    align: 'left'
						}
					],
					autoSelectOneRecord : true,
					filterText: $F("txtBranchCdPdc") != $("txtBranchCdPdc").getAttribute("lastValidValue") ? nvl(($F("txtBranchCdPdc")), "%") : "%",  
					draggable: true,
					onSelect: function(row) {
						if(row != undefined){
							$("txtBranchCdPdc").value = unescapeHTML2(row.branchCd);
							$("txtBranchName").value = unescapeHTML2(row.branchName);
							enableToolbarButton("btnToolbarEnterQuery");
							enableToolbarButton("btnToolbarExecuteQuery");
						}
					},
					onCancel: function(){
						$("txtBranchCdPdc").value = $("txtBranchCdPdc").getAttribute("lastValidValue");
						$("txtBranchName").value = $("txtBranchName").getAttribute("lastValidValue");
						$("txtBranchCdPdc").focus();
			  		},
			  		onUndefinedRow: function(){
			  			$("txtBranchCdPdc").value = $("txtBranchCdPdc").getAttribute("lastValidValue");
						$("txtBranchName").value = $("txtBranchName").getAttribute("lastValidValue");
						customShowMessageBox("No record selected.", imgMessage.INFO, "txtBranchCdPdc");
			  		}
				});
			}catch(e){
				showErrorMessage("showBranchLOV",e);
			}
		}
		
		$("txtFundCdPdc").observe("change", function(){
			if($F("txtFundCdPdc") != ""){
				showFundLOV();
			} else {
				$("txtFundDesc").value = "";
				$("txtBranchCdPdc").value = "";
				$("txtBranchName").value = "";
				disableToolbarButton("btnToolbarEnterQuery");
				disableToolbarButton("btnToolbarExecuteQuery");
			}
		});
		
		$("txtBranchCdPdc").observe("change", function(){
			if($F("txtBranchCdPdc") != ""){
				showBranchLOV();
			}  else {
				$("txtBranchName").value = "";
			}
		});
		
		$("btnToolbarExit").observe("click", function(){
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		});
		
		$("acExit").observe("click", function(){
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		});
		
		$("btnToolbarEnterQuery").observe("click", showGiacs032);
		
		$("btnToolbarExecuteQuery").observe("click", function() {
			if (checkAllRequiredFieldsInDiv("queryFormDiv")) {
				onQuery = true;
				enableButton("btnPrint");
				enableToolbarButton("btnToolbarEnterQuery");
				disableQueryFields();
				tbgPostDatedChecks.url = contextPath +"/GIACPdcChecksController?action=showGiacs032&refresh=1&fundCd="+$F("txtFundCdPdc")+"&branchCd="+ $F("txtBranchCdPdc")+"&checkFlag="+getcheckFlagValue();
				tbgPostDatedChecks._refreshList();
				setButton();
			}
		});
		function disableQueryFields(){
			disableToolbarButton("btnToolbarExecuteQuery");
			$("txtFundCdPdc").readOnly = true;
			$("txtBranchCdPdc").readOnly = true;
			disableSearch("searchFund");
			disableSearch("searchBranch");
		}
		
		function getcheckFlagValue(){
			if($("rdoOnHold").checked == true){
				return "N";
			} else if($("rdoForDeposit").checked == true){
				return "F";
			} else if($("rdoWithDetails").checked == true){
				return "W";
			} else if($("rdoApplied").checked == true){
				return "A";
			} else if($("rdopReplaced").checked == true){
				return "R";
			} else if($("rdoCancelled").checked == true){
				return "C";
			} else {
				return "";
			}
		}
		
		function setFieldValues(rec){
			try{
				$("txtParticulars").value = 	(rec == null ? "" : unescapeHTML2(rec.particulars));
				$("txtTranYear").value = 		(rec == null ? "" : unescapeHTML2(rec.tranYear));
				$("txtTranMonth").value = 		(rec == null ? "" : lpad(rec.tranMonth,2,0));
				$("txtTranSeqNo").value = 		(rec == null ? "" : lpad(rec.tranSeqNo,6,0));
				$("txtDcbDate").value = 		(rec == null ? "" : dateFormat(rec.dcbDate,"mm-dd-yyyy"));
				$("txtUserId").value = 			(rec == null ? "" : unescapeHTML2(rec.userId));
				$("txtLastUpdate").value = 		(rec == null ? "" : rec.lastUpdate);
				objGIAC032 = (rec == null ? "" : rec);
				objCurrPostDatedCheck = rec;
				
				if(rec != null){
					if(onClickButtonEnable){
						if($(rec.checkFlag == "N")){
							enableButton("btnForDeposit");
							enableButton("btnReplace");
							disableButton("btnApply");
							disableButton("btnReplacementHistory");
						} else if(rec.checkFlag == "F"){
							disableButton("btnForDeposit");
							enableButton("btnReplace");
							enableButton("btnApply");
							disableButton("btnReplacementHistory");
						} else if(rec.checkFlag == "W"){
							disableButton("btnForDeposit");
							disableButton("btnReplace");
							enableButton("btnApply");
							disableButton("btnReplacementHistory");
						} else if(rec.checkFlag == "A"){
							disableButton("btnForDeposit");
							disableButton("btnReplace");
							disableButton("btnApply");
							disableButton("btnReplacementHistory");
						} else if(rec.checkFlag == "R"){
							disableButton("btnForDeposit");
							disableButton("btnReplace");
							enableButton("btnApply");
							enableButton("btnReplacementHistory");
						} else if(rec.checkFlag == "C"){
							disableButton("btnForDeposit");
							disableButton("btnReplace");
							disableButton("btnApply");
							disableButton("btnReplacementHistory");
						} 
					}
				} else {
					disableButton("btnForDeposit");
					disableButton("btnReplace");
					disableButton("btnApply");
					disableButton("btnReplacementHistory");
				}
			} catch(e){
				showErrorMessage("setFieldValues", e);
			}
		}
		
		$$("input[name='checkFlag']").each(function(btn) {
			btn.observe("click", function() {
				if (onQuery) {
					tbgPostDatedChecks.url = contextPath +"/GIACPdcChecksController?action=showGiacs032&refresh=1&fundCd="+$F("txtFundCdPdc")+"&branchCd="+ $F("txtBranchCdPdc")+"&checkFlag="+getcheckFlagValue();
					tbgPostDatedChecks._refreshList();
					setButton();
				}
			});
		}); 
		
		function setButton(){
			if($("rdoOnHold").checked == true){
				//enableButton("btnForDeposit");
				//enableButton("btnReplace");
				onClickButtonEnable = true;
				disableButton("btnApply");
				disableButton("btnReplacementHistory");
				$$("input[type='checkbox']").each(function(x) {
					x.disabled = false;
		        });
			} else if($("rdoForDeposit").checked == true){
				disableButton("btnForDeposit");
				onClickButtonEnable = true;
				disableButton("btnReplacementHistory");
				$$("input[type='checkbox']").each(function(x) {
					x.disabled = false;
		        });
			} else if($("rdoWithDetails").checked == true){
				disableButton("btnForDeposit");
				disableButton("btnReplace");
				onClickButtonEnable = true;
				disableButton("btnReplacementHistory");
				$$("input[type='checkbox']").each(function(x) {
					x.disabled = true;
		        });
			} else if($("rdoApplied").checked == true){
				disableButton("btnForDeposit");
				disableButton("btnReplace");
				disableButton("btnApply");
				disableButton("btnReplacementHistory");
				$$("input[type='checkbox']").each(function(x) {
					x.disabled = true;
		        });
			} else if($("rdopReplaced").checked == true){
				disableButton("btnForDeposit");
				disableButton("btnReplace");
				onClickButtonEnable = true;
				$$("input[type='checkbox']").each(function(x) {
					x.disabled = true;
		        });
			} else if($("rdoCancelled").checked == true){
				disableButton("btnForDeposit");
				disableButton("btnReplace");
				disableButton("btnApply");
				disableButton("btnReplacementHistory");
				$$("input[type='checkbox']").each(function(x) {
					x.disabled = true;
		        });
			} else {
				onClickButtonEnable = true;
				$$("input[type='checkbox']").each(function(x) {
					x.disabled = false;
		        });
			}
		}
		
		$("btnForDeposit").observe("click", function(){
			showForDeposit();
		});
		
		function showForDeposit() {
			try {
				overlayForDeposit = Overlay.show(contextPath
						+ "/GIACPdcChecksController", {
					urlContent : true,
					urlParameters : {
						action : "showForDeposit",
						ajax : "1",
						fundCd : $F("txtFundCdPdc"),
						branchCd : $F("txtBranchCdPdc"),
						itemId : objCurrPostDatedCheck.itemId,
						checkNo : objCurrPostDatedCheck.checkNo,
						checkDate : objCurrPostDatedCheck.checkDate,
						refNo : objCurrPostDatedCheck.refNo,
						itemNo : objCurrPostDatedCheck.itemNo,
						gaccTranId : objCurrPostDatedCheck.gaccTranId
						},
					title : "DCB",
					 height: 120,
					 width: 258,
					draggable : true
				});   
			} catch (e) {
				showErrorMessage("showForDeposit", e);
			}
		}
		
		$("btnReplacementHistory").observe("click", function(){
			showReplacementHistory();
		});
		
		function showReplacementHistory() {
			try {
				overlayReplacementHistory= Overlay.show(contextPath
						+ "/GIACPdcChecksController", {
					urlContent : true,
					urlParameters : {
						action : "showReplacementHistory",
						ajax : "1",
						fundCd : $F("txtFundCdPdc"),
						branchCd : $F("txtBranchCdPdc"),
						gaccTranId : objCurrPostDatedCheck.gaccTranId,
						itemNo : objCurrPostDatedCheck.itemNo
						},
					title : "Replacement History",
					 height: 380,
					 width: 603,
					draggable : true
				});   
			} catch (e) {
				showErrorMessage("showReplacementHistory", e);
			}
		}
		
		$("btnPrint").observe("click", function(){
			showPrintPostDatedChecks();
		});
		
		function showReplacePostDatedChecks() {
			try {
				overlayReplace= Overlay.show(contextPath
						+ "/GIACPdcChecksController", {
					urlContent : true,
					urlParameters : {
						action : "showReplacePostDatedChecks",
						ajax : "1",
						itemId : objCurrPostDatedCheck.itemId,
						checkNo : objCurrPostDatedCheck.checkNo,
						bankSname : objCurrPostDatedCheck.bankSname,
						amount : objCurrPostDatedCheck.amount,
						gaccTranId : objCurrPostDatedCheck.gaccTranId,
						itemNo : objCurrPostDatedCheck.itemNo,
						fundCd : $F("txtFundCdPdc"),
						branchCd : $F("txtBranchCdPdc")
						},
					title : "Replace",
					 height: 550,
					 width: 603,
					draggable : true
				});   
			} catch (e) {
				showErrorMessage("showReplacePostDatedChecks", e);
			}
		}
		
		$("btnReplace").observe("click", function(){
			showReplacePostDatedChecks();
		});
		
		$("btnApply").observe("click", function(){
			applyPdc();
		});
		
		function applyPdc(){
			new Ajax.Request(contextPath + "/GIACPdcChecksController", {
				method : "POST",
				parameters : {
					action : "applyPDC",
					itemId : objCurrPostDatedCheck.itemId,
					gaccTranId : objCurrPostDatedCheck.gaccTranId,
					fundCd : objCurrPostDatedCheck.gfunFundCd,
					branchCd : objCurrPostDatedCheck.gibrBranchCd
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : function() {
					showNotice("Loading, please wait...");
				},
				onComplete : function(response) {
					hideNotice();
					if (checkErrorOnResponse(response)) {
						var obj = JSON.parse(response.responseText);
						objACGlobal.gaccTranId = obj.newTranId; //objCurrPostDatedCheck.gaccTranId;
						objACGlobal.groupNo = obj.groupNo;
						objACGlobal.fundCd = $F("txtFundCdPdc");
						objACGlobal.branchCd = $F("txtBranchCdPdc");
						objACGlobal.tranSource = "PDC";
						objACGlobal.callingForm = "DETAILS";
						objACGlobal.withPdc = "Y";
						objACGlobal.previousModule = "GIACS032";
						showGiacs004();
					}
				}
			});
		}
		
		
		function showGiacs004() {
			new Ajax.Request(contextPath + "/GIACOrderOfPaymentController", {
				method : "POST",
				parameters : {
					action : "showORDetails",
					gaccTranId : objACGlobal.gaccTranId
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : function() {
					showNotice("Loading, please wait...");
				},
				onComplete : function(response) {
					hideNotice();
					if (checkErrorOnResponse(response)) {
						$("giacs031MainDiv").update(response.responseText);
						$("giacs031MainDiv").show();
						$("giacs032MainDiv").hide();
						$("mainNav").show();
					}
				}
			});
		}
</script>