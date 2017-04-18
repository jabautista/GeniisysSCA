<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="checkBatchPrintingMainDiv" name="checkBatchPrintingMainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Check Batch Printing</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="reloadFormChk" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div>
	
	<div id="checkBankPrintingHeaderDiv" class="sectionDiv">
		<table style="margin: 10px 0 10px 45px;">
			<tr>
				<td>
					<label style="margin: 4px 5px 0 0;">Company</label>
					<span class="lovSpan required" style="width: 70px;">
						<input id="fundCd" name="searchField" type="text" class="required upper" style="float: left; margin-top: 0px; margin-right: 3px; height: 13px; width: 40px; border: none;" maxlength="3" tabindex="101"/>
						<img id="searchFundCd" name="searchIcon" alt="Go" style="height: 18px; margin-top: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" lastValidValue=""/>
					</span>
				</td>
				<td>
					<input id="fundDesc" name="fundDesc" type="text" style="float: left; margin-bottom: 3px; margin-right: 30px; height: 14px; width: 260px;" tabindex="102" readonly="readonly"/>
				</td>
				<td>
					<label style="margin: 4px 5px 0 0;">Branch</label>
					<span class="lovSpan required" style="width: 70px;">
						<input id="branchCd" name="searchField" type="text" class="upper required" style="float: left; margin-top: 0px; margin-right: 3px; height: 13px; width: 40px; border: none;" maxlength="3" tabindex="103"/>
						<img id="searchBranchCd" name="searchIcon" alt="Go" style="height: 18px; margin-top: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" lastValidValue=""/>
					</span>
				</td>
				<td>
					<input id="branchName" name="branchName" type="text" style="float: left; margin-bottom: 3px; margin-right: 3px; height: 14px; width: 260px;" tabindex="104" readonly="readonly"/>
				</td>
			</tr>
		</table>
	</div>
	
	<div id="checkBankPrintingDetailsDiv" class="sectionDiv">
		<table style="margin: 10px 0 10px 42px;">
			<tr>
				<td>
					<label style="margin: 4px 5px 0 0;">Bank / Bank Account No.</label>
					<span class="lovSpan required" style="width: 70px;">
						<input id="bankSName" name=searchField type="text" class="upper required" style="float: left; margin-top: 0px; margin-right: 3px; height: 13px; width: 40px; border: none;" maxlength="10" tabindex="105"/>
						<img id="searchBankSName" name="searchIcon" alt="Go" style="height: 18px; margin-top: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" lastValidValue=""/>
					</span>
				</td>
				<td>
					<input id="bankAcctNo" name="bankAcctNo" type="text" style="float: left; margin-bottom: 3px; margin-right: 90px; height: 14px; width: 175px;" tabindex="106" readonly="readonly"/>
					<input id="bankCd" name="bankCd" type="hidden">
					<input id="bankAcctCd" name="bankAcctCd" type="hidden">
				</td>
				
				<td>
					<label style="margin: 4px 5px 0 0;">Start With</label>
					<input id="chkPrefix" name="chkPrefix" type="text" class="upper" style="float: left; margin-bottom: 3px; margin-right: 3px; height: 14px; width: 70px;" tabindex="107" readonly="readonly" maxlength="5"/>
				</td>
				<td>
					<input id="checkSeqNo" name="checkSeqNo" type="text" class="integerNoNegativeUnformatted" style="float: left; margin-bottom: 3px; margin-right: 3px; height: 14px; width: 175px;" tabindex="108" readonly="readonly" oldValue="" maxlength="10"/>
				</td>
			</tr>
		</table>
		
		<div id="checkTableGridDiv" style="height: 327px; margin: 0 0 12px 11px;">
		
		</div>
		
		<div id="checkDetailsDiv" style="height: 135px;">
			<table>
				<tr>
					<td>
						<label style="margin: 4px 5px 0 135px;">Payee</label>
						<input id="payee" name="payee" type="text" style="float: left; margin-bottom: 3px; margin-right: 3px; height: 14px; width: 600px;" tabindex="109" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<td>
						<label style="margin: 4px 0 0 111px;">Particulars</label>
						<textarea id="particulars" name="particulars" style="width: 600px; border: 1px solid gray; height: 80px; margin: 0px; resize: none;" maxlength="500" readonly="readonly" tabindex="110"/></textarea>
					</td>
				</tr>
			</table>
		</div>
	</div>
	
	<div id="checkBankPrintingControlDiv" class="sectionDiv" style="padding: 12px 0 12px 0; margin-bottom: 20px;">
		<table style="margin: 5px 30px 0 30px; float: left;">
			<tr>
				<td class="rightAligned">Destination</td>
				<td class="leftAligned">
					<select id="selDestination" style="width: 200px;" tabindex="111">
						<option value="printer">Printer</option>
						<option value="local">Local Printer</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Printer</td>
				<td class="leftAligned">
					<select id="selPrinter" style="width: 200px;" class="required" tabindex="112">
						<option></option>
						<c:forEach var="p" items="${printers}">
							<option value="${p.name}">${p.name}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
		</table>
		<table style="float: left;">
			<tr>
				<td style="padding: 1px;">
					<input title="Untag All" type="radio" id="untagAll" name="tagUntagRG" style="margin: 7px 5px 10px 10px; float: left;" checked="checked" tabindex="113">
					<label for="untagAll" style="margin-top: 7px;">Untag All</label>
					<input title="Tag All" type="radio" id="tagAll" name="tagUntagRG" style="margin: 7px 5px 10px 30px; float: left;" tabindex="113">
					<label for="tagAll" style="margin-top: 7px;">Tag All</label>
				</td>
				<td>
					<input id="btnView" type="button" class="button" value="View DV Details" style="width: 180px;" tabindex="114">
				</td>
				<td>
					<input id="btnPrint" type="button" class="button" value="Print Check" style="width: 180px;" tabindex="115">
				</td>
			</tr>
			<tr>
				<td>
					<input id="btnStop" type="button" class="button" value="STOP PRINTING" style="width: 180px;" tabindex="116">
				</td>
				<td>
					<input id="btnGenerate" type="button" class="button" value="Generate Check Number" style="width: 180px;" tabindex="117">
				</td>
				<td>
					<input id="btnSpoil" type="button" class="button" value="Spoil Check" style="width: 180px;" tabindex="118">
				</td>
			</tr>
		</table>
	</div>
</div>
<div id="GIACS002Div"></div>

<script type="text/javascript">
	objChkBatch = new Object();
	objChkBatch.sortable = true;
	var editCheckNo = '${editCheckNo}';
	var checkDvPrint = '${checkDvPrint}';
	var printLoop = null;
	var selectedIndex = -1;
	
	objGIACS054.tempTaggedRecords = [];;
	$("GIACS002Div").hide();
	
	try{
		checkDetailsTableModel = {
			url: contextPath +"/GIACChkDisbursementController?action=getCheckBatchList&bankCd=-1&bankAcctCd=-1&branchCd="+$F("branchCd"),	
			options: {
	          	height: '306px',
	          	width: '900px',
				validateChangesOnPrePager: false,
	          	onCellFocus: function(element, value, x, y, id){
	          		objChkBatch.selectedRow = checkDetailsTG.geniisysRows[y];
	          		selectedIndex = y;
	          		populateFields(true);
	          		checkDetailsTG.keys.removeFocus(checkDetailsTG.keys._nCurrentFocus, true);
	          		checkDetailsTG.keys.releaseKeys();
	            },
	            onRemoveRowFocus: function(){
	            	objChkBatch.selectedRow = "";
	            	selectedIndex = -1;
	            	populateFields(false);
	            	checkDetailsTG.keys.removeFocus(checkDetailsTG.keys._nCurrentFocus, true);
	            	checkDetailsTG.keys.releaseKeys();
	            	recheckRows();
	            },
	            beforeSort: function(){
	            	return objChkBatch.sortable;
	            },
	            onSort: function(){
	            	checkDetailsTG.onRemoveRowFocus();
	            	recheckRows();
	            },
	            postPager: function(){
	            	checkDetailsTG.onRemoveRowFocus();
	            	recheckRows();
	            },
	            toolbar: {
	            	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
	            	onRefresh: function(){
	            		$("untagAll").checked = true;	// shan 09.26.2014
	            		objGIACS054.tempTaggedRecords = [];	// shan 09.26.2014
	            		checkDetailsTG.onRemoveRowFocus();
	            	},
	            	onFilter: function(){
	            		$("untagAll").checked = true;	// shan 09.30.2014
	            		fireEvent($("untagAll"), "click");	// shan 09.30.2014
	            		checkDetailsTG.onRemoveRowFocus();
	            	}
	            }
			},
			columnModel:[
						{   id: 'recordStatus',
						    width: '0px',
						    visible: false,
						    editor: 'checkbox'
						},
						{	id: 'divCtrId',
							width: '0px',
							visible: false
						},
						{	id:	'G',
							title: '&nbsp&nbspG',
							tooltip: 'Generate',
							altTitle: 'Generate',
							name: 'Generate',
							sortable: false,
							align: 'center',
							width: '25px',
							editable: true,
							hideSelectAllBox: true,
							editor: 'checkbox'
						},
						{	id:	'batchTag',
							title: '&nbsp&nbspP',
							tooltip: 'Printed',
							altTitle: 'Printed',
							sortable: false,
							align: 'center',
							width: '25px',
							editable: false,
							hideSelectAllBox: true,
							editor: new MyTableGrid.CellCheckbox({
					            getValueOf: function(value){
					            	return value ? "Y" : "N";
				            	}
				            })
						},
						{	id: 'checkDate',
							title: 'Check Date',
							width: '125px',
							filterOption: true,
							filterOptionType: 'formattedDate',
							renderer : function(value){						
								return nvl(value, "") == "" ? "" : dateFormat(value, "mm-dd-yyyy");
							}
						},
						{
							id: 'checkNumber',
							title: 'Check Number',
							width : '193px',
							filterOption: true
						},
						{	id: 'dvDate',
							title: 'DV Date',
							width: '125px',
							filterOption: true,
							filterOptionType: 'formattedDate',
							renderer : function(value){						
								return nvl(value, "") == "" ? "" : dateFormat(value, "mm-dd-yyyy");
							}
						},
						{	id: 'dvNumber',
							title: 'DV Number',
							width: '193px',
							filterOption: true
						},
						{	id: 'requestNumber',
							title: 'Request Number',
							width: '194px',
							filterOption: true
						}
						],
			rows: []
		};
		checkDetailsTG = new MyTableGrid(checkDetailsTableModel);
		checkDetailsTG.pager = [];
		checkDetailsTG.render('checkTableGridDiv');
		checkDetailsTG.afterRender = function(){
			objChkBatch.rows = checkDetailsTG.geniisysRows;
			checkDetailsTG.onRemoveRowFocus();
			observeGenerateCheckbox();
		};
	}catch(e){
		showMessageBox("Error in Check Details Table Grid: " + e, imgMessage.ERROR);
	}
	
	function newFormInstance(){
		initializeAll();
		toggleRequiredFields("printer");
		makeInputFieldUpperCase();
		setModuleId("GIACS054");
		setDocumentTitle("Check Batch Printing");
	}
	
	function resetForm(){
		$("fundCd").focus();
		
		$$("input[type='text']").each(function(i){
			i.value = "";
		});
		
		$("fundCd").setAttribute("lastValidValue", "");
		$("branchCd").setAttribute("lastValidValue", "");
		$("bankSName").setAttribute("lastValidValue", "");
		
		toggleFields(true);
		disableInputField("branchCd");
		disableInputField("bankSName");
		disableInputField("chkPrefix");
		disableInputField("checkSeqNo");
		
		disableSearch("searchBranchCd");
		disableSearch("searchBankSName");
		
		disableToolbarButton("btnToolbarPrint");
		disableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarEnterQuery");
		
		toggleControls(false);
		objChkBatch.sortable = true;
		objGIACS054.tempTaggedRecords = [];
		$("mtgRefreshBtn"+checkDetailsTG._mtgId).show();
		$("mtgFilterBtn"+checkDetailsTG._mtgId).show();
		$("untagAll").checked = true;
	}
	
	function showFundCdLOV(){
		try{
			LOV.show({
				controller: "AccountingLOVController",
				urlParameters: {
					action: "getGIACS092FundLOV",
					searchString: "",
					filterText: $F("fundCd") != $("fundCd").getAttribute("lastValidValue") ? nvl($F("fundCd"), "%") : "%"
				},
				title: "List of Company",
				width: 415,
				height: 386,
				columnModel:[
								{	id: "fundCd",
									title: "Company Code",
									width: "75px"
								},
				             	{	id: "fundDesc",
									title: "Company Name",
									width: "325px"
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				filterText: $F("fundCd") != $("fundCd").getAttribute("lastValidValue") ? nvl($F("fundCd"), "%") : "%",
			    noticeMessage: "Getting list, please wait...",
				onSelect : function(row){
					if(row != undefined) {
						$("fundCd").value = unescapeHTML2(row.fundCd);
						$("fundDesc").value = unescapeHTML2(row.fundDesc);
						$("fundCd").setAttribute("lastValidValue", row.fundCd);
						
						toggleBranch(true);
						enableInputField("branchCd");
						enableSearch("searchBranchCd");
						enableToolbarButton("btnToolbarEnterQuery");
					}
				},
				onCancel: function(){
					$("fundCd").value = $("fundCd").getAttribute("lastValidValue");
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("fundCd").value = $("fundCd").getAttribute("lastValidValue");
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showFundCdLOV", e);
		}
	}
	
	function showBranchCdLOV(){
		try{
			LOV.show({
				controller: "AccountingLOVController",
				urlParameters: {
					action: "getGIACS054BranchLOV",
					gfunFundCd: $F("fundCd"),
					searchString: "",
					moduleId: "GIACS054",
					filterText: $F("branchCd") != $("branchCd").getAttribute("lastValidValue") ? nvl($F("branchCd"), "%") : "%"
				},
				title: "List of Branches",
				width: 415,
				height: 386,
				columnModel:[
								{	id: "branchCd",
									title: "Branch Code",
									width: "75px",
								},
				             	{	id: "branchName",
									title: "Branch Name",
									width: "325px"
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				filterText: $F("branchCd") != $("branchCd").getAttribute("lastValidValue") ? nvl($F("branchCd"), "%") : "%",
			    noticeMessage: "Getting list, please wait...",
				onSelect : function(row){
					if(row != undefined) {
						$("branchCd").value = unescapeHTML2(row.branchCd);
						$("branchName").value = unescapeHTML2(row.branchName);
						$("branchCd").setAttribute("lastValidValue", row.branchCd);
						
						if(nvl(editCheckNo, "N") == "Y"){
							disableInputField("chkPrefix");
							disableInputField("checkSeqNo");
						}
						
						toggleBank(true);
						enableInputField("bankSName");
						enableSearch("searchBankSName");
					}
				},
				onCancel: function(){
					$("branchCd").value = $("branchCd").getAttribute("lastValidValue");
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("branchCd").value = $("branchCd").getAttribute("lastValidValue");
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showBranchCdLOV", e);
		}
	}
	
	function showBankLOV(){
		try{
			LOV.show({
				controller: "AccountingLOVController",
				urlParameters: {
					action: "getGIACS054BankLOV",
					fundCd: $F("fundCd"),
					branchCd: $F("branchCd"),
					filterText: $F("bankSName") != $("bankSName").getAttribute("lastValidValue") ? nvl($F("bankSName"), "%") : "%"
				},
				title: "List of Bank Accounts",
				width: 440,
				height: 386,
				columnModel:[
								{	id: "bankCd",
									title: "Bank Code",
									width: "76px",
								},
				             	{	id: "bankAcctCd",
									title: "Bank Acct Code",
									width: "110px"
								},
								{	id: "bankSName",
									title: "Bank Short Name",
									width: "115px",
								},
								{	id: "bankAcctNo",
									title: "Bank Acct No.",
									width: "120px",
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				filterText: $F("bankSName") != $("bankSName").getAttribute("lastValidValue") ? nvl($F("bankSName"), "%") : "%",
			    noticeMessage: "Getting list, please wait...",
				onSelect : function(row){
					if(row != undefined) {
						if(nvl(editCheckNo, "N") == "Y"){
							enableInputField("chkPrefix");
							enableInputField("checkSeqNo");
						}
						
						$("bankSName").value = unescapeHTML2(row.bankSName);
						$("bankAcctNo").value = unescapeHTML2(row.bankAcctNo);
						$("bankCd").value = row.bankCd;
						$("bankAcctCd").value = row.bankAcctCd;
						$("bankSName").setAttribute("lastValidValue", row.bankSName);
						
						enableToolbarButton("btnToolbarExecuteQuery");
						
						generateCheck();
					}
				},
				onCancel: function(){
					$("bankSName").value = $("bankSName").getAttribute("lastValidValue");
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("bankSName").value = $("bankSName").getAttribute("lastValidValue");
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showBankLOV", e);
		}
	}
	
	function getCheckSeqNo(){
		new Ajax.Request(contextPath+"/GIACChkDisbursementController", {
			method: "GET",
			parameters: {
				action: "getCheckSeqNo",
				fundCd: $F("fundCd"),
				branchCd: $F("branchCd"),
				bankCd: $F("bankCd"),
				bankAcctCd: $F("bankAcctCd"),
				chkPrefix: $F("chkPrefix")
			},
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					$("checkSeqNo").value = response.responseText;
				}
			}
		});
	}
	objChkBatch.getCheckSeqNo = getCheckSeqNo;
	
	function validateCheckSeqNo(){
		new Ajax.Request(contextPath+"/GIACChkDisbursementController", {
			method: "GET",
			parameters: {
				action: "validateCheckSeqNo",
				bankCd: $F("bankCd"),
				bankAcctCd: $F("bankAcctCd"),
				chkPrefix: $F("chkPrefix"),
				checkSeqNo: $F("checkSeqNo"),
				branchCd: $F("branchCd")
			},
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(!(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response))){
					$("checkSeqNo").value = $("checkSeqNo").getAttribute("oldValue");
				}
			}
		});
	}
	
	function populateFields(){
		$("payee").value = unescapeHTML2(objChkBatch.selectedRow.payee);
		$("particulars").value = unescapeHTML2(objChkBatch.selectedRow.particulars);
	}
	
	function tagGenerate(tag){
		$$("input[type='checkbox']").each(function(c){
			if(!c.disabled && c.id != "mtgSelectAll"+checkDetailsTG._mtgId){
				if(!tag && nvl(checkDetailsTG.geniisysRows[c.id.split(",")[1]].checkNumber, "") != ""){
					showWaitingMessageBox("Check numbers were already generated.  Update not allowed.", "E", function(){
						c.checked = true;
					});
				}else{
					c.checked = tag;
				}
			}
		});
		
		if (tag){	// shan 09.26.2014
			var url = checkDetailsTG.url.split("action=getCheckBatchList");
			var filterBy = prepareJsonAsParameter(checkDetailsTG.objFilter);
			new Ajax.Request(url[0] + "action=getCheckBatchListByParam" + url[1], {
				parameters: {
					filterBy: filterBy
				},
				onCreate: showNotice("Tagging all records, please wait..."),
				onComplete: function(response){
					hideNotice();
					var result = JSON.parse(response.responseText);
					objGIACS054.tempTaggedRecords = result;
				}
			});
		}else{
			objGIACS054.tempTaggedRecords = [];
		}
	}
	
	function observeGenerateCheckbox(){
		$$("input[type='checkbox']").each(function(c){
			if(!c.disabled){
				c.observe("click", function(){
					if(!c.checked && nvl(checkDetailsTG.geniisysRows[c.id.split(",")[1]].checkNumber, "") != ""){
						showWaitingMessageBox("Check numbers were already generated.  Update not allowed.", "E", function(){
							c.checked = true;
						});
					}else{	// added by shan 09.26.2014
						var ind = c.id.split(",")[1];
						var exists = false;
						if(c.checked){
							checkDetailsTG.geniisysRows[ind].G = true;
							for (var i=0; i < objGIACS054.tempTaggedRecords.length; i++){
								if (objGIACS054.tempTaggedRecords[i].gaccTranId == checkDetailsTG.geniisysRows[ind].gaccTranId 
										&& objGIACS054.tempTaggedRecords[i].itemNo == checkDetailsTG.geniisysRows[ind].itemNo){
									exists = true;
									break;
								}
							}
							if (!exists){
								objGIACS054.tempTaggedRecords.push(checkDetailsTG.geniisysRows[ind]);
							}
						}else{
							checkDetailsTG.geniisysRows[ind].G = false;
							for (var i=0; i < objGIACS054.tempTaggedRecords.length; i++){
								if (objGIACS054.tempTaggedRecords[i].gaccTranId == checkDetailsTG.geniisysRows[ind].gaccTranId 
										&& objGIACS054.tempTaggedRecords[i].itemNo == checkDetailsTG.geniisysRows[ind].itemNo){
									objGIACS054.tempTaggedRecords.splice(i, 1);
									break;
								}
							}
						}
					}
				});
			}
		});
	}
	
	function recheckRows(){	// shan 09.26.2014
		var g = checkDetailsTG.getColumnIndex("G");
		var batchTag = checkDetailsTG.getColumnIndex("batchTag");
		var mtgId = checkDetailsTG._mtgId;
		
		for (var a = 0; a < checkDetailsTG.geniisysRows.length; a++){
			for (var b = 0; b < objGIACS054.tempTaggedRecords.length; b++){
				if (checkDetailsTG.geniisysRows[a].gaccTranId == objGIACS054.tempTaggedRecords[b].gaccTranId 
						&& checkDetailsTG.geniisysRows[a].itemNo == objGIACS054.tempTaggedRecords[b].itemNo){
					$('mtgInput'+mtgId+'_'+g+','+a).checked = true;
					if (objGIACS054.tempTaggedRecords[b].batchTag == "Y"){
						$('mtgInput'+mtgId+'_'+batchTag+','+a).checked = true;
					}
					
					checkDetailsTG.geniisysRows[a].checkDate = objGIACS054.tempTaggedRecords[b].checkDate;
					checkDetailsTG.geniisysRows[a].checkPrefSuf = objGIACS054.tempTaggedRecords[b].checkPrefSuf;
					checkDetailsTG.geniisysRows[a].checkNo = objGIACS054.tempTaggedRecords[b].checkNo;
					checkDetailsTG.geniisysRows[a].checkNumber = objGIACS054.tempTaggedRecords[b].checkNumber; 
					checkDetailsTG.updateVisibleRowOnly(checkDetailsTG.geniisysRows[a], a);
					/*if (checkDetailsTG.geniisysRows[a].batchTag == "Y"){
						checkDetailsTG.updateVisibleRowOnly(checkDetailsTG.geniisysRows[i], i);
					}*/
				}
			}
		}
	}
	
	function checkTaggedRecords(){
		var result = false;
		for(var i = 0; i < checkDetailsTG.geniisysRows.length; i ++){
			if($("mtgInput"+checkDetailsTG._mtgId+"_2," + i).checked){
				result = true;
			}
		}
		return result;
	}
	
	function generateCheck(){
		new Ajax.Request(contextPath+"/GIACChkDisbursementController", {
			method: "GET",
			parameters: {
				action: "generateCheck",
				fundCd: $F("fundCd"),
				branchCd: $F("branchCd"),
				bankSName: $F("bankSName"),
				bankCd: $F("bankCd"),
				bankAcctCd: $F("bankAcctCd")
			},
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					$("chkPrefix").value = obj.chkPrefix;
					$("checkSeqNo").value = obj.checkSeqNo;
					objChkBatch.maxCheckNo = obj.checkSeqNo;
				}
			}
		});
	}
	
	function toggleControls(toggle, disableGenerate, validateRec){
		toggle ? $("selDestination").enable() : $("selDestination").disable();
		toggle ? $("selPrinter").enable() : $("selPrinter").disable();
		toggle ? $("selPrinter").addClassName("required") : $("selPrinter").removeClassName("required");
		toggle ? $("untagAll").enable() : $("untagAll").disable();
		toggle ? $("tagAll").enable() : $("tagAll").disable();
		
		$("selDestination").value = "printer";
		$("selPrinter").value = "";
		
		$$("input[type='button']").each(function(b){
			toggle ? enableButton(b.id) : disableButton(b.id);
		});
		toggle ? enableToolbarButton("btnToolbarPrint") : disableToolbarButton("btnToolbarPrint"); 
		disableButton("btnStop");
		
		if (disableGenerate) disableButton("btnGenerate");// shan 10.13.2014
		var rows = objGIACS054.tempTaggedRecords.filter(function(obj){return nvl(obj.checkNumber, "") != "" && nvl(obj.batchTag, "N") != "Y";});
		if (validateRec && rows.length == 0) {
			disableButton("btnPrint");
			disableToolbarButton("btnToolbarPrint");
		}
	}
	
	function toggleOnPrint(toggle, disableGenerate, validateRec){
		if(toggle){
			enableToolbarButton("btnToolbarEnterQuery");
			enableToolbarButton("btnToolbarPrint");
			enableToolbarButton("btnToolbarExit");
			
			toggleControls(true, disableGenerate, validateRec);
		}else{
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarPrint");
			disableToolbarButton("btnToolbarExit");
			
			$("selDestination").disable();
			$("selPrinter").disable();
			$("untagAll").disable();
			$("tagAll").disable();
			
			enableButton("btnStop");
			disableButton("btnView");
			disableButton("btnGenerate");
			disableButton("btnPrint");
			disableButton("btnSpoil");
		}
	};
	objChkBatch.toggleOnPrint = toggleOnPrint;
	
	function toggleRequiredFields(dest){
		if(dest == "printer"){			
			$("selPrinter").disabled = false;
			$("selPrinter").addClassName("required");
		}else{
			$("selPrinter").value = "";
			$("selPrinter").disabled = true;
			$("selPrinter").removeClassName("required");
		}
	}
	
	function toggleFields(toggle){
		$$("input[name='searchField']").each(function(o){
			toggle? enableInputField(o.id) : disableInputField(o.id);
		});
		
		disableSearch("searchBranchCd");
		disableSearch("searchBankSName");
		disableToolbarButton("btnToolbarExecuteQuery");
		toggle ? enableSearch("searchFundCd") : disableSearch("searchFundCd");
		
		if(nvl(editCheckNo, "N") == "Y"){
			enableInputField("chkPrefix");
			enableInputField("checkSeqNo");
		}
	}
	
	function toggleBranch(toggle){
		if(nvl(editCheckNo, "N") == "Y"){
			disableInputField("chkPrefix");
			disableInputField("checkSeqNo");
		}
		
		disableInputField("branchCd");
		disableInputField("bankSName");
		disableSearch("searchBranchCd");
		disableSearch("searchBankSName");
		
		$("branchCd").value = "";
		$("branchName").value = "";
		$("bankSName").value = "";
		$("bankAcctNo").value = "";
		$("chkPrefix").value = "";
		$("checkSeqNo").value = "";
		
		if(toggle){
			$("branchCd").focus();
		}
	}
	
	function toggleBank(toggle){
		disableInputField("bankSName");
		disableSearch("searchBankSName");
		
		$("bankSName").value = "";
		$("bankAcctNo").value = "";
		$("chkPrefix").value = "";
		$("checkSeqNo").value = "";
		
		if(toggle){
			$("bankSName").focus();
		}
	}
	
	function clearTG(){
		checkDetailsTG.url = contextPath +"/GIACChkDisbursementController?action=getCheckBatchList"+
								"&bankCd=-1&bankAcctCd=-1&branchCd="+$F("branchCd");
		checkDetailsTG._refreshList();
		checkDetailsTG.onRemoveRowFocus();
	}
	
	function getCheckDvPrint(){
		new Ajax.Request(contextPath + "/GIACChkDisbursementController?action=getCheckDvPrint",{
			parameters: {
				fundCd:		$F("fundCd"),
				branchCd:	$F("branchCd")
			},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					checkDvPrint = response.responseText;
					objChkBatch.checkDvPrint = checkDvPrint;
				}
			}
		});	
	}
	
	function executeQuery(){
		getCheckDvPrint();
		checkDetailsTG.url = contextPath +"/GIACChkDisbursementController?action=getCheckBatchList"+
								"&bankCd="+$F("bankCd")+"&bankAcctCd="+$F("bankAcctCd")+
								"&checking=N&checkTag=N&tranIdGroup=&branchCd="+$F("branchCd");
		checkDetailsTG._refreshList();
		checkDetailsTG.onRemoveRowFocus();
		objChkBatch.sortable = true;
		toggleFields(false);
		toggleControls(true);
		objGIACS054.tempTaggedRecords = [];
	}
	
	function callGIACS002(){
		objACGlobal.gaccTranId = objChkBatch.selectedRow.gaccTranId;
		objACGlobal.callingForm = "GIACS054";
		objGIACS002.prevModule = "GIACS054";
		objGIACS002.queryOnly = "Y";
		objGIACS002.fundCd = $F("fundCd");
		objGIACS002.branchCd = $F("branchCd");
		objGIACS002.dvTag = null;
		objGIACS002.cancelDV = "N";
		objACGlobal.queryOnly = "Y";
		objGIACS002.fromGIACS054 = true;
		
		$("mainNav").show();
		$("generalDisbursements").next().setStyle("display: none");
		$("acExit").show();
		showDisbursementVoucherPage("N", "getDisbVoucherInfo", "Y");
	}
	
	function validateCheckNumbers(){
		/*for(var i = 0; i < objChkBatch.rows.length; i ++){
			if(nvl(objChkBatch.rows[i].checkNumber, "") != ""){
				return true;
			}
		}*/
		for(var i = 0; i < objGIACS054.tempTaggedRecords.length; i ++){
			if(nvl(objGIACS054.tempTaggedRecords[i].checkNumber, "") != ""){
				return true;
			}
		}
		showMessageBox("Please generate Check numbers first.", "I");
		return false;
	}
	
	function validateSpoilCheck(){
		new Ajax.Request(contextPath+"/GIACChkDisbursementController", {
			method: "GET",
			parameters: {
				action: "validateSpoilCheck",
				gaccTranId: objChkBatch.selectedRow.gaccTranId,
				itemNo: objChkBatch.selectedRow.itemNo,
				checkPrefSuf: objChkBatch.selectedRow.checkPrefSuf,
				checkNo: objChkBatch.selectedRow.checkNo
			},
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					var message = "Do you want to spoil check no. " + objChkBatch.selectedRow.checkPrefSuf +
									"-" + lpad(objChkBatch.selectedRow.checkNo, 10, '0') +  "?";					
					showConfirmBox("Spoil Check", message, "Yes", "No", spoilCheck, "", "2");
				}
			}
		});
	}
	
	function spoilCheck(){
		new Ajax.Request(contextPath+"/GIACChkDisbursementController", {
			method: "GET",
			parameters: {
				action: "spoilCheckGIACS054",
				checkDvPrint:	checkDvPrint,	// shan 10.01.2014
				row: JSON.stringify(objChkBatch.selectedRow)
			},
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					var message = "Successfully spoiled Check number " + objChkBatch.selectedRow.checkPrefSuf +
									"-" + objChkBatch.selectedRow.checkNo + ".";
					showWaitingMessageBox(message, "S", function(){
						checkDetailsTG.geniisysRows[selectedIndex].batchTag = "";
						checkDetailsTG.geniisysRows[selectedIndex].checkDate = "";
						checkDetailsTG.geniisysRows[selectedIndex].checkNumber = "";
						checkDetailsTG.updateVisibleRowOnly(checkDetailsTG.geniisysRows[selectedIndex], selectedIndex);
						objChkBatch.rows.splice(selectedIndex, 1, checkDetailsTG.geniisysRows[selectedIndex]);
						
						for (var i=0; i <objGIACS054.tempTaggedRecords.length; i++){
							if (objGIACS054.tempTaggedRecords[i].gaccTranId == checkDetailsTG.geniisysRows[selectedIndex].gaccTranId &&
									objGIACS054.tempTaggedRecords[i].itemNo == checkDetailsTG.geniisysRows[selectedIndex].itemNo){
								objGIACS054.tempTaggedRecords[i].batchTag = "";
								objGIACS054.tempTaggedRecords[i].checkDate = "";
								objGIACS054.tempTaggedRecords[i].checkNumber = "";
							}
						}
						$('mtgInput'+checkDetailsTG._mtgId+'_'+checkDetailsTG.getColumnIndex('batchTag')+','+selectedIndex).checked = false;
						var rows = objGIACS054.tempTaggedRecords.filter(function(obj){return nvl(obj.checkNumber, "") != "" && nvl(obj.batchTag, "N") != "Y";});
						if (rows.length > 0) {	// shan 10.07.2014
							enableButton("btnPrint");
							enableToolbarButton("btnToolbarPrint");
						}else{
							disableButton("btnPrint");
							disableToolbarButton("btnToolbarPrint");
						}
						getCheckSeqNo();
					});
				}
			}
		});
	}
	
	function updateBatchTags(updateAll){
		for(var i = 0; i < checkDetailsTG.geniisysRows.length; i++){
			if(parseInt(nvl(checkDetailsTG.geniisysRows[i].checkNo, 0)) <= parseInt(objChkBatch.lastCheckNo) 
					&& nvl(checkDetailsTG.geniisysRows[i].checkNumber, "") != ""){	// added addtl condition : shan 10.20.2014
				checkDetailsTG.geniisysRows[i].batchTag = "Y";
				checkDetailsTG.updateVisibleRowOnly(checkDetailsTG.geniisysRows[i], i);
				
				for(var m = 0; m < objChkBatch.rows.length; m++){
					if(objChkBatch.rows[m].gaccTranId == checkDetailsTG.geniisysRows[i].gaccTranId &&
						objChkBatch.rows[m].itemNo == checkDetailsTG.geniisysRows[i].itemNo){
						objChkBatch.rows.splice(m, 1, checkDetailsTG.geniisysRows[i]);
					}
				}
			}
		}
		for (var b = 0; b < objGIACS054.tempTaggedRecords.length; b++){
			if (updateAll){
				objGIACS054.tempTaggedRecords[b].batchTag = "Y";
			}else{
				if (parseInt(objGIACS054.tempTaggedRecords[b].checkNo) <= parseInt(objChkBatch.lastCheckNo) &&
						 nvl(objGIACS054.tempTaggedRecords[b].checkNumber, "") != ""){
					objGIACS054.tempTaggedRecords[b].batchTag = "Y";
				}
			}
		}
	}
	objChkBatch.updateBatchTags = updateBatchTags;
	
	function processPrintedChecks(rows){
		var objParams = new Object();
		objParams.rows = rows;
		
		new Ajax.Request(contextPath+"/GIACChkDisbursementController", {
			method: "POST",
			parameters: {
				action: "processPrintedChecks",
				parameters: JSON.stringify(objParams),
				fundCd: $F("fundCd"),
				branchCd: $F("branchCd"),
				bankCd: $F("bankCd"),
				bankAcctCd: $F("bankAcctCd"),
				checkPref: $F("chkPrefix"),
				checkDvPrint:	checkDvPrint
			},
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					objChkBatch.updateBatchTags(true);
					toggleOnPrint(true);
					$("checkSeqNo").value = objChkBatch.lastCheckNo;
					disableButton("btnPrint");
					disableToolbarButton("btnToolbarPrint");
					disableButton("btnGenerate");
					/*var url = checkDetailsTG.url.split("&checking=N");
					checkDetailsTG.url = url[0] + "&checking=Y" + url[1];*/
				}
			}
		});
	}
	
	function printChecks(){
		//var rows = checkDetailsTG.geniisysRows.filter(function(obj){return nvl(obj.checkNumber, "") != "" && nvl(obj.batchTag, "N") != "Y";});	// replaced by code below : shan 09.29.2014
		var rows = objGIACS054.tempTaggedRecords.filter(function(obj){return nvl(obj.checkNumber, "") != "" && nvl(obj.batchTag, "N") != "Y";});
		var reportId = "";
		
		if(checkDvPrint == 1){
			reportId = "GIACR052";
		}else{
			reportId = "GIACR052C";
		}
		
		toggleOnPrint(false);
		
		if($F("selDestination") == "printer"){
			printCheckReport(rows, 0, reportId);
		}else if($F("selDestination") == "local"){
			printBatchCheckReport(rows, reportId);
		}
	}
	
	function printCheckReport(rows, index, reportId){
		hideNotice();
		var content = contextPath+"/GeneralDisbursementPrintController?action=print"+reportId+"&reportId="+reportId+
						"&gaccTranId="+rows[index].gaccTranId+"&checkPrefix="+rows[index].checkPrefSuf+"&checkNo="+rows[index].checkNo+
						"&branchCd="+$F("branchCd")+"&checkDate="+rows[index].checkDate+"&printerName="+$F("selPrinter")+
						"&destination="+$F("selDestination")+"&itemNo="+rows[index].itemNo;
		
		new Ajax.Request(content, {
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					if(printLoop == "Y"){
						if((index + 1) == rows.length){
							validatePrinting(rows);
						}else{
							printCheckReport(rows, ++index, reportId);
						}
					}
				}
			}
		});
	}
	
	function printBatchCheckReport(rows, reportId){
		var printerName = null;
		
		if(nvl($("geniisysAppletUtil"), null) == null || nvl($("geniisysAppletUtil").selectPrinter, null) == null ||
			nvl($("geniisysAppletUtil").printBatchJRPrintFileToPrinter, null) == null){
			showWaitingMessageBox("Local printer applet is not configured properly. Please verify if you have accepted to run the Geniisys Utility Applet and if the java plugin in your browser is enabled.", "E", function(){
				toggleOnPrint(true);
			});
			return;
		}else{
			printerName = $("geniisysAppletUtil").selectPrinter();
		}
		
		if(printerName == "" || printerName == null){
			showWaitingMessageBox("No printer selected.", "I", function(){
				toggleOnPrint(true);
			});
			return;
		}
		
		for(var index = 0; index < rows.length; index++){
			var content = contextPath+"/GeneralDisbursementPrintController?action=print"+reportId+"&reportId="+reportId+
							"&gaccTranId="+rows[index].gaccTranId+"&checkPrefix="+rows[index].checkPrefSuf+"&checkNo="+rows[index].checkNo+
							"&branchCd="+$F("branchCd")+"&checkDate="+rows[index].checkDate+"&printerName="+$F("selPrinter")+
							"&destination="+$F("selDestination")+"&itemNo="+rows[index].itemNo;
			
			if(printLoop == "Y"){
				new Ajax.Request(content, {
					evalScripts: true,
					asynchronous: false,
					parameters: {
						destination: "LOCAL"
					},
					onComplete: function(response){
						if(checkErrorOnResponse(response)){
							printBatchToLocalPrinter(response.responseText, printerName);
						}
					}
				});
			}
		}
		validatePrinting(rows);
	}
	
	function validatePrinting(rows){
		showConfirmBox("Validate Printing", "Were all the checks successfully printed?", "Yes", "No",
				function(){
					objChkBatch.lastCheckNo = objChkBatch.maxCheckNo;
					processPrintedChecks(rows);
				}, showLastCheckNoOverlay, "1");
	}
	
	function showLastCheckNoOverlay(){
		lastCheckNoOverlay = Overlay.show(contextPath+"/GIACChkDisbursementController", {
			urlParameters: {
				action: "showLastCheckNoOverlay"
			},
			urlContent : true,
			draggable: true,
		    title: "Unsuccessful Printing",
		    height: 125,
		    width: 300
		});
	}
	
	$("mtgRefreshBtn" + checkDetailsTG._mtgId).observe("click", function(){
		checkDetailsTG.url = contextPath +"/GIACChkDisbursementController?action=getCheckBatchList"+
								"&bankCd="+$F("bankCd")+"&bankAcctCd="+$F("bankAcctCd")+
								"&checking=N&checkTag=N&tranIdGroup=&branchCd="+$F("branchCd");
		objChkBatch.sortable =  true;
		objGIACS054.tempTaggedRecords = [];
		$("chkPrefix").readOnly = false;
		$("checkSeqNo").readOnly = false;
		enableButton("btnGenerate");
		enableButton("btnPrint");
		enableToolbarButton("btnToolbarPrint");
	});
	
	$("fundCd").observe("change", function(){
		if($F("fundCd") != ""){
			showFundCdLOV();
		}else{
			$("fundDesc").value = "";
			$("fundCd").setAttribute("lastValidValue", "");
			$("branchCd").setAttribute("lastValidValue", "");
			$("bankSName").setAttribute("lastValidValue", "");
			toggleBranch(false);
		}
	});
	
	$("branchCd").observe("change", function(){
		if($F("branchCd") != ""){
			showBranchCdLOV();
		}else{
			$("branchName").value = "";
			$("branchCd").setAttribute("lastValidValue", "");
			$("bankSName").setAttribute("lastValidValue", "");
			toggleBank(false);
		}
	});
	
	$("bankSName").observe("change", function(){
		if($F("bankSName") != ""){
			showBankLOV();
		}else{
			$("bankSName").value = "";
			$("bankAcctNo").value = "";
			$("chkPrefix").value = "";
			$("checkSeqNo").value = "";
			$("bankSName").setAttribute("lastValidValue", "");
		}
	});
	
	$("chkPrefix").observe("change", function(){
		if($F("chkPrefix") != ""){
			getCheckSeqNo();
		}else{
			showMessageBox("Please enter value for check prefix", "I");
			$("chkPrefix").focus();
		}
	});
	
	$("checkSeqNo").observe("change", function(){
		if($F("checkSeqNo") != ""){
			validateCheckSeqNo();
		}else{
			getCheckSeqNo();
		}
	});
	
	$("checkSeqNo").observe("focus", function(){
		$("checkSeqNo").setAttribute("oldValue", $F("checkSeqNo"));
	});
	
	$("searchFundCd").observe("click", function(){
		showFundCdLOV();
	});
	
	$("searchBranchCd").observe("click", function(){
		showBranchCdLOV();
	});
	
	$("searchBankSName").observe("click", function(){
		showBankLOV();
	});
	
	$("selDestination").observe("change", function(){
		toggleRequiredFields($F("selDestination"));
	});
	
	$("tagAll").observe("click", function(){
		tagGenerate(true);
	});
	
	$("untagAll").observe("click", function(){
		tagGenerate(false);
	});

	$("btnView").observe("click", function(){
		if(nvl(objChkBatch.selectedRow, "") == ""){
			showMessageBox("No D.V selected to view.", "I");
		}else{
			callGIACS002();
		}
	});
	
	$("btnGenerate").observe("click", function(){
		if(/*checkTaggedRecords()*/ objGIACS054.tempTaggedRecords.length != 0){
			checkDateOverlay = Overlay.show(contextPath+"/GIACChkDisbursementController", {
				urlParameters: {
					action: "enterCheckDate"
				},
				urlContent : true,
				draggable: true,
			    title: "Check Date",
			    height: 125,
			    width: 300
			});
		}else{
			showMessageBox("No records tagged.", "I");
		}
	});
	
	$("btnPrint").observe("click", function(){
		if(validateCheckNumbers() && checkAllRequiredFieldsInDiv("checkBankPrintingControlDiv")){
			printLoop = "Y";
			printChecks();
		}
	});
	
	$("btnStop").observe("click", function(){
		printLoop = "N";
		toggleOnPrint(true);
		showLastCheckNoOverlay();
	});
	
	$("btnSpoil").observe("click", function(){
		if(nvl(objChkBatch.selectedRow, "") == ""){
			showMessageBox("Please select record first.", "I");
		}else{
			validateSpoilCheck();
		}
	});
	
	$("reloadFormChk").observe("click", function(){
		showBatchCheckPrinting();
	});
	
	$("btnToolbarEnterQuery").observe("click", function(){
		resetForm();
		clearTG();
	});
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		executeQuery();
	});
	
	$("btnToolbarPrint").observe("click", function(){
		fireEvent($("btnPrint"), "click");
	});
	
	$("btnToolbarExit").observe("click", function(){
		delete objChkBatch;
		objGIACS002.fromGIACS054 = false;
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});
	
	newFormInstance();
	resetForm();
</script>