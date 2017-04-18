<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="batchCommSlipMainDiv" name="batchCommSlipMainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Commission Slip Batch Printing</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	
	<div class="sectionDiv">
		<div id="batchCommSlipHeaderDiv" align="center">
			<table cellspacing="2" border="0" style="margin: 10px auto;">	 			
				<tr>
					<td class="rightAligned" style="" id="">Company</td>
					<td class="leftAligned" colspan="3">
						<span class="lovSpan required" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px;">
							<input class="required upper" type="text" id="fundCd" name="headerField" style="width: 40px; float: left; border: none; height: 13px; margin: 0;" maxlength="3" tabindex="101" lastValidValue=""/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchFundCd" name="searchFundCd" alt="Go" style="float: right;"/>
						</span>
						<input id="fundDesc" name="headerField" type="text" style="width: 280px;" value="" readonly="readonly" tabindex="102"/>
					</td>
					<td class="rightAligned" style="width: 65px;" id="">Branch</td>
					<td class="leftAligned" colspan="3">
						<span class="lovSpan required" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px;">
							<input class="required upper" type="text" id="branchCd" name="headerField" style="width: 40px; float: left; border: none; height: 13px; margin: 0;" maxlength="2" tabindex="103" lastValidValue=""/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchCd" name="searchBranchCd" alt="Go" style="float: right;"/>
						</span>
						<input id="branchName" name="headerField" type="text" style="width: 280px;" value="" readonly="readonly" tabindex="104"/>
					</td>
				</tr>
			</table>			
		</div>
	</div>
	
	<div id="batchCommSlipDetailsDiv" class="sectionDiv" style="height: 385px;">
		<div id="batchCommSlipTGDiv" style="padding: 10px 0 0 10px; height: 340px;"></div>
		
		<div style="float: left;">
			<label style="margin: 5px 3px 0px 55px;">Intermediary Name</label>
			<input id="intmName" name="intmName" type="text" style="width: 690px; float: left; margin-left: 3px;" readonly="readonly" tabindex="105">
		</div>
	</div>
	
	<div id="batchCommSlipControlDiv" class="sectionDiv" style="padding: 7px 0 12px 0; margin-bottom: 30px;">
		<div id="printerDiv">
			<table style="margin: 10px 30px 0 20px; float: left;">
				<tr>
					<td class="rightAligned">Destination</td>
					<td class="leftAligned">
						<select id="selDestination" style="width: 215px;" disabled="disabled" tabindex="106">
							<option value="screen">Screen</option>
							<option value="printer">Printer</option>
							<option value="local">Local Printer</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Printer Name</td>
					<td class="leftAligned">
						<select id="selPrinter" style="width: 215px;" class="" disabled="disabled" tabindex="107">
							<option></option>
							<c:forEach var="p" items="${printers}">
								<option value="${p.name}">${p.name}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
			</table>
		</div>
		
		<table style="float: left;">
			<tr>
				<td style="padding: 1px;">
					<input title="Untag All" type="radio" id="untagAll" name="tagUntagRG" style="margin: 7px 5px 5px 15px; float: left;" checked="checked" disabled="disabled" tabindex="108">
					<label for="untagAll" style="margin-top: 7px;">Untag All</label>
					<input title="Tag All" type="radio" id="tagAll" name="tagUntagRG" style="margin: 7px 5px 5px 20px; float: left;" disabled="disabled" tabindex="109">
					<label for="tagAll" style="margin-top: 7px;">Tag All</label>
				</td>
				<td class="rightAligned" colspan="2">
					Start With
					<input id="csPref" name="csPref" type="text" style="width: 100px;" maxlength="10" readonly="readonly" tabindex="110">
					<input id="csSeqNo" name="csSeqNo" type="text" style="width: 100px; text-align: right;" maxlength="10" readonly="readonly" tabindex="110">
				</td>
			</tr>
			<tr>
				<td>
					<input id="btnGenerate" name="controlButton" type="button" class="disabledButton" value="Generate CS Number" style="width: 180px; margin-top: 5px;" tabindex="112">
				</td>
				<td>
					<input id="btnPrint" name="controlButton" type="button" class="disabledButton" value="Print Comm Slip" style="width: 180px; margin-top: 5px;" tabindex="113">
				</td>
				<td>
					<input id="btnStop" name="controlButton" type="button" class="disabledButton" value="STOP PRINTING" style="width: 180px; margin-top: 5px;" tabindex="114">
				</td>
			</tr>
		</table>
	</div>
</div>

<script type="text/javascript">
	var selectedRow = null;
	var selectedIndex = -1;
	var stopPrinting = false;

	try{
		var batchCommSlipTGModel = {
			url: contextPath+"/GIACCommSlipExtController?action=getBatchCommSlip&refresh=1",
			options: {
	          	height: '306px',
	          	width: '900px',
	          	hideColumnChildTitle: true,
	          	onCellFocus: function(element, value, x, y, id){
	          		selectedIndex = y;
	          		selectedRow = batchCommSlipTG.geniisysRows[selectedIndex];
	          		$("intmName").value = unescapeHTML2(selectedRow.intmName);
	          		batchCommSlipTG.releaseKeys();
	            },
	            onRemoveRowFocus: function(){
	            	selectedIndex = -1;
	            	selectedRow = null;
	            	$("intmName").value = "";
	            	batchCommSlipTG.releaseKeys();
	            },
	            onSort: function(){
	            	batchCommSlipTG.onRemoveRowFocus();
	            },
	            toolbar: {
	            	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
	            	onRefresh: function(){
	            		batchCommSlipTG.onRemoveRowFocus();
	            		untagAll();
	            	},
	            	onFilter: function(){
	            		batchCommSlipTG.onRemoveRowFocus();
	            	},
	            	onSave: function(){
	            		saveGenerateFlag("N");
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
						{
							id: 'generateFlag',
							title: '&#160;G',
			            	width: '23px',
			            	altTitle: 'Generate',
			            	titleAlign: 'center',
			            	sortable: false,
			            	editable: true,
			            	hideSelectAllBox: true,
			            	editor: new MyTableGrid.CellCheckbox({
					            getValueOf: function(value){
					            	return value ? "Y" : "N";
				            	}
			            	})
						},
						{
							id: 'printedFlag',
							title: '&#160;P',
			            	width: '23px',
			            	altTitle: 'Printed',
			            	titleAlign: 'center',
			            	sortable: false,
			            	editable: false,
			            	hideSelectAllBox: true,
			            	editor: new MyTableGrid.CellCheckbox({
					            getValueOf: function(value){
					            	return value ? "P" : "N";
				            	}
			            	})
						},
						{	id: 'orPref orNo',
							title: 'OR No',
							width: '138px',
							children: [
								{	id: 'orPref',
									title: 'OR Pref',
									width: 58,							
									sortable: false,
									filterOption: true
								},
								{	id: 'orNo',
									title: 'OR No',
									width: 75,
									align: 'right',
									sortable: false,
									filterOption: true,
									filterOptionType: 'integerNoNegative'
								}
							]
						},
						{	id: 'commSlipPref commSlipNo',
							title: 'Commission Slip No',
							width: '152px',
							children: [
								{	id: 'commSlipPref',							
									width: 58,							
									sortable: false
								},
								{	id: 'commSlipNo',
									width: 89,
									align: 'right',
									sortable: false,
									renderer : function(value){
										return nvl(value, "") == "" ? "" : lpad(value, 12, "0");
									}
								}
							]
						},
						{	id: 'intmNo',
							title: 'Intm No',
							align: 'right',
							width: '65px',
							filterOption: true,
							filterOptionType: 'integerNoNegative'
						},
						{	id: 'commAmt',
							title: 'Commission Amt',
							titleAlign: 'right',
							align: 'right',
							width: '120px',
							geniisysClass: 'money',
							filterOption: true,
							filterOptionType: 'numberNoNegative'
						},
						{	id: 'wtaxAmt',
							title: 'Wtax Amt',
							titleAlign: 'right',
							align: 'right',
							width: '120px',
							geniisysClass: 'money',
							filterOption: true,
							filterOptionType: 'numberNoNegative'
						},
						{	id: 'inputVatAmt',
							title: 'Input VAT Amt',
							titleAlign: 'right',
							align: 'right',
							width: '120px',
							geniisysClass: 'money',
							filterOption: true,
							filterOptionType: 'numberNoNegative'
						},
						{	id: 'netAmt',
							title: 'Net Amt',
							titleAlign: 'right',
							align: 'right',
							width: '120px',
							geniisysClass: 'money',
							filterOption: true,
							filterOptionType: 'numberNoNegative'
						}
						],
			rows: []
		};
		batchCommSlipTG = new MyTableGrid(batchCommSlipTGModel);
		batchCommSlipTG.pager = {};
		batchCommSlipTG.render('batchCommSlipTGDiv');
		batchCommSlipTG.afterRender = function(){
			batchCommSlipTG.onRemoveRowFocus();
			observeGenerateCheckbox();
		};
	}catch(e){
		showMessageBox("Error in Batch Commission Slip TableGrid: " + e, imgMessage.ERROR);
	}

	function newFormInstance(){
		resetForm();
		initializeAll();
		makeInputFieldUpperCase();
		setModuleId("GIACS250");
		setDocumentTitle("Commission Slip Batch Printing");
		hideToolbarButton("btnToolbarPrint");
	}
	
	function resetForm(){
		$("fundCd").focus();
		$$("input[name='headerField']").each(function(i){
			i.value = "";
			i.setAttribute("lastValidValue", "");
		});
		
		$("csPref").value = "";
		$("csSeqNo").value = "";
		
		$("untagAll").checked = true;
		$("fundCd").readOnly = false;
		$("branchCd").readOnly = true;
		enableSearch("searchFundCd");
		disableSearch("searchBranchCd");
		
		disableButton("btnGenerate");
		disableButton("btnPrint");
		disableButton("btnStop");
		
		toggleToolbars();
		toggleControls(false);
	}
	
	function toggleControls(toggle){
		toggle ? $("selDestination").enable() : $("selDestination").disable();
		toggle ? null : $("selPrinter").disable();
		toggle ? $("untagAll").enable() : $("untagAll").disable();
		toggle ? $("tagAll").enable() : $("tagAll").disable();
		
		$("selDestination").value = "screen";
		$("selPrinter").value = "";
		$("selPrinter").removeClassName("required");
	}
	
	function toggleToolbars(){
		if($F("fundCd") == "" && $F("branchCd") == ""){
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		}else if($F("fundCd") == "" || $F("branchCd") == ""){
			enableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		}else if($F("fundCd") != "" && $F("branchCd") != ""){
			enableToolbarButton("btnToolbarEnterQuery");
			enableToolbarButton("btnToolbarExecuteQuery");
		}
	}
	
	function toggleOnPrint(toggle){
		$w("untagAll tagAll selDestination selPrinter").each(function(i){
			toggle ? $(i).enable() : $(i).disable();
		});
		
		if(toggle && ($F("selDestination") == "local") || $F("selDestination") == "screen"){
			$("selPrinter").disable();
		}
		
		toggle ? enableButton("btnPrint") : disableButton("btnPrint");
		toggle ? disableButton("btnStop") : enableButton("btnStop");
	}
	
	function showFundLOV(){
		try{
			LOV.show({
				controller: "AccountingLOVController",
				urlParameters: {
					action: "getGiacs250FundLOV",
					filterText: $F("fundCd") != $("fundCd").getAttribute("lastValidValue") ? nvl($F("fundCd"), "%") : "%"
				},
				title: "Valid values for company",
				width: 365,
				height: 386,
				columnModel:[
								{	id: "fundCd",
									title: "Company",
									width: "100px"
								},
								{	id: "fundDesc",
									title: "Company Description",
									width: "250px"
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				filterText: $F("fundCd") != $("fundCd").getAttribute("lastValidValue") ? nvl($F("fundCd"), "%") : "%",
			    noticeMessage: "Getting list, please wait...",
				onSelect : function(row){
					if(row != undefined) {
						$("fundCd").value = row.fundCd;
						$("fundDesc").value = unescapeHTML2(row.fundDesc);
						$("fundCd").setAttribute("lastValidValue", row.fundCd);
						$("branchCd").focus();
						enableInputField("branchCd");
						enableSearch("searchBranchCd");
						toggleToolbars();
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
			showErrorMessage("showFundLOV", e);
		}
	}
	
	function showBranchLOV(){
		try{
			LOV.show({
				controller: "AccountingLOVController",
				urlParameters: {
					action: "getGiacs250BranchLOV",
					filterText: $F("branchCd") != $("branchCd").getAttribute("lastValidValue") ? nvl($F("branchCd"), "%") : "%"
				},
				title: "Valid values for branch",
				width: 382,
				height: 386,
				columnModel:[
								{	id: "branchCd",
									title: "Branch",
									width: "100px"
								},
								{	id: "branchName",
									title: "Branch Name",
									width: "250px"
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				filterText: $F("branchCd") != $("branchCd").getAttribute("lastValidValue") ? nvl($F("branchCd"), "%") : "%",
			    noticeMessage: "Getting list, please wait...",
				onSelect : function(row){
					if(row != undefined) {
						$("branchCd").value = row.branchCd;
						$("branchName").value = unescapeHTML2(row.branchName);
						$("branchCd").setAttribute("lastValidValue", row.branchCd);
						toggleToolbars();
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
			showErrorMessage("showBranchLOV", e);
		}
	}
	
	function getCommSlipNo(){
		new Ajax.Request(contextPath+"/GIACCommSlipExtController", {
			parameters: {
				action: "getCommSlipNo",
				fundCd: $F("fundCd"),
				branchCd: $F("branchCd")
			},
			asynchronous : false,
			evalScripts : true,
			onCreate: showNotice("Loading, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					$("csPref").value = nvl(obj.defCsPref, "");
					$("csSeqNo").value = nvl(obj.defCsSeqNo, 0);
					executeQuery();
				}
			}
		});
	}
	
	function executeQuery(){
		batchCommSlipTG.url = contextPath +"/GIACCommSlipExtController?action=getBatchCommSlip"+
											"&fundCd="+$F("fundCd")+"&branchCd="+$F("branchCd")+"&orNo=&orPref=";
		batchCommSlipTG._refreshList();
		batchCommSlipTG.url = batchCommSlipTG.url + "&refresh=1";
		
		enableButton("btnGenerate");
		
		$("fundCd").readOnly = true;
		$("branchCd").readOnly = true;
		disableSearch("searchFundCd");
		disableSearch("searchBranchCd");
		$("fundCd").focus();
		
		$("tagAll").enable();
		$("untagAll").enable();
		
		toggleControls(true);
		enableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
	}
	
	function clearTG(){
		batchCommSlipTG.url = contextPath +"/GIACCommSlipExtController?action=getBatchCommSlip";
		batchCommSlipTG._refreshList();
	}
	
	function observeGenerateCheckbox(){
		var checkboxList = "";
		$$("input[type='checkbox']").each(function(c){
			if(!c.disabled && c.id != "mtgSelectAll"+batchCommSlipTG._mtgId &&
				parseInt((c.id.split(",")[0]).substr(c.id.split(",")[0].length-1)) == 2){
				checkboxList += c.id + " ";
			}
		});
		
		$w(checkboxList).each(function(c){
			$(c).observe("click", function(){
				var index = c.split(",")[1];
				
				if(nvl(batchCommSlipTG.geniisysRows[index].printedFlag, "") == "Y"){
					$(c).checked = true;
				}
				
				disableButton("btnPrint");
				batchCommSlipTG.geniisysRows[index].generateFlag = $("mtgInput"+batchCommSlipTG._mtgId+"_2," + index).checked ? "Y" : "N";
				batchCommSlipTG.updateVisibleRowOnly(batchCommSlipTG.geniisysRows[index], index);

				if(nvl(batchCommSlipTG.geniisysRows[index].commSlipNo, "") != ""){
					showWaitingMessageBox("The commission slip number sequence generated for the tagged ORs has been changed. " +
							"Click the Generate CS Number button to retrieve another commission slip sequence." , "I", function(){
						disableButton("btnPrint");
						batchCommSlipTG.geniisysRows[index].commSlipNo = "";
						batchCommSlipTG.geniisysRows[index].commSlipPref = "";
						batchCommSlipTG.updateVisibleRowOnly(batchCommSlipTG.geniisysRows[index], index);
						saveGenerateFlag("N");
					});
				}
			});
		});
	}
	
	function tagAll(){
		new Ajax.Request(contextPath+"/GIACCommSlipExtController", {
			parameters: {
				action: "tagAll",
				params: JSON.stringify(batchCommSlipTG.objFilter) 
			},
			asynchronous : false,
			evalScripts : true,
			onCreate: showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					batchCommSlipTG.url = contextPath +"/GIACCommSlipExtController?action=getBatchCommSlip&refresh=1";
					batchCommSlipTG._refreshList();
				}
			}
		});
	}
	
	function untagAll(){
		new Ajax.Request(contextPath+"/GIACCommSlipExtController", {
			parameters: {
				action: "untagAll"
			},
			asynchronous : false,
			evalScripts : true,
			onCreate: showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					batchCommSlipTG.url = contextPath +"/GIACCommSlipExtController?action=getBatchCommSlip"+
														"&fundCd="+$F("fundCd")+"&branchCd="+$F("branchCd");
					batchCommSlipTG._refreshList();
					disableButton("btnPrint");
				}
			}
		});
	}
	
	function generateCommSlipNo(){
		new Ajax.Request(contextPath+"/GIACCommSlipExtController", {
			parameters: {
				action: "generateCommSlipNo",
				commSlipPref: $F("csPref"),
				commSlipSeq: $F("csSeqNo")
			},
			asynchronous : false,
			evalScripts : true,
			onCreate: showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(parseInt(nvl(obj.count, 0)) > 0){
						batchCommSlipTG.url = contextPath +"/GIACCommSlipExtController?action=getBatchCommSlip&refresh=1"+
												"&fundCd="+$F("fundCd")+"&branchCd="+$F("branchCd");
						batchCommSlipTG._refreshList();
						enableButton("btnPrint");
					}else{
						showMessageBox("No commission slip number was generated. Tag the Generate checkbox of the OR you want to print.", "I");
					}
				}
			}
		});
	}
	
	function saveGenerateFlag(postFunc){
		var objParams = new Object();
		objParams.setRows = getAddedAndModifiedJSONObjects(batchCommSlipTG.geniisysRows);
		
		if(objParams.setRows.length > 0){
			new Ajax.Request(contextPath+"/GIACCommSlipExtController", {
				method: "POST",
				parameters: {
					action : "saveGenerateFlag",
					parameters : JSON.stringify(objParams)
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						if(postFunc == "Y"){
							generateCommSlipNo();
						}
					}
				}
			});
		}else{
			if(postFunc == "Y"){
				generateCommSlipNo();
			}
		}
	}
	
	function printBatchCommSlip(){
		if($F("selDestination") == "screen"){
			disableButton("btnStop");
		}else{
			enableButton("btnStop");
		}
		getBatchCommSlipReports(null);
	}
	
	function getBatchCommSlipReports(index){
		new Ajax.Request(contextPath+"/GIACCommSlipExtController", {
			parameters: {
				action: "getBatchCommSlipReports"
			},
			asynchronous : false,
			evalScripts : true,
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					var rows = JSON.parse(response.responseText);
					if($F("selDestination") == "screen"){
						printBatchToScreen(rows, nvl(index, 0));
					}else if($F("selDestination") == "printer"){
						toggleOnPrint(false);
						printBatchToPrinter(rows, nvl(index, 0));
					}else if($F("selDestination") == "local"){
						toggleOnPrint(false);
						printBatchToLocal(rows, nvl(index, 0));
					}
				}
			}
		});
	}
	
	function printBatchToScreen(rows, i){
		var commSlipDate = dateFormat(new Date(), 'mm-dd-yyyy');
		var content = contextPath+"/BatchCommSlipPrintController?action=printCommSlip&gaccTranId="+rows[i].gaccTranId+
						"&recId="+i+"&commSlipPref="+rows[i].csPref+"&commSlipNo="+rows[i].csNo+
						"&intmNo="+rows[i].intmNo+"&gaccBranchCd="+rows[i].branchCd+
						"&commSlipDate="+commSlipDate+"&reportId=GIACR250&reportTitle=Commission Slip"+
						"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination");
		
		new Ajax.Request(contextPath + "/GIISUserController", {
			action: "POST",
			asynchronous : false,
			parameters : {
				action: "setReportParamsToSession",
				reportUrl: content,
				reportTitle: "Commission Slip"
			},
			onComplete: function(response){
				window.open('pages/report.jsp', '', 'location=0, toolbar=0, menubar=0, fullscreen=1');
				validatePrinting(rows, i, printBatchToScreen);
			}
		});
	}
	
	function printBatchToPrinter(rows, i){
		hideNotice();
		var commSlipDate = dateFormat(new Date(), 'mm-dd-yyyy');
		
		var content = contextPath+"/BatchCommSlipPrintController?action=printCommSlip&gaccTranId="+rows[i].gaccTranId+
						"&recId="+i+"&commSlipPref="+rows[i].csPref+"&commSlipNo="+rows[i].csNo+
						"&intmNo="+rows[i].intmNo+"&gaccBranchCd="+rows[i].branchCd+
						"&commSlipDate="+commSlipDate+"&reportId=GIACR250&reportTitle=Commission Slip"+
						"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination");
		
		if(!nvl(stopPrinting, false)){
			new Ajax.Request(content, {
				asynchronous: false,
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						validatePrinting(rows, i, printBatchToPrinter);
					}
				}
			});
		}else{
			toggleOnPrint(true);
		}
	}
	
	function printBatchToLocal(rows, i){
		if(nvl($("geniisysAppletUtil"), null) == null || nvl($("geniisysAppletUtil").printJRPrintFileToPrinter, null) == null){
			showWaitingMessageBox("Local printer applet is not configured properly. Please verify if you have accepted to run the Geniisys Utility Applet and if the java plugin in your browser is enabled.", "E", function(){
				toggleOnPrint(true);
				stopPrinting = false;
			});
			return;
		}
		
		var commSlipDate = dateFormat(new Date(), 'mm-dd-yyyy');
		var content = contextPath+"/BatchCommSlipPrintController?action=printCommSlip&gaccTranId="+rows[i].gaccTranId+
									"&recId="+i+"&commSlipPref="+rows[i].csPref+"&commSlipNo="+rows[i].csNo+
									"&intmNo="+rows[i].intmNo+"&gaccBranchCd="+rows[i].branchCd+
									"&commSlipDate="+commSlipDate+"&reportId=GIACR250&reportTitle=Commission Slip"+
									"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination");
		
		if(!nvl(stopPrinting, false)){
			new Ajax.Request(content, {
				evalScripts: true,
				asynchronous: false,
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						var message = printToLocalPrinter(response.responseText);
						if(message != "SUCCESS"){
							showMessageBox(message, imgMessage.ERROR);
							return false;
						}else{
							validatePrinting(rows, i, printBatchToLocal);
						}
					}
				}
			});
		}else{
			toggleOnPrint(true);
		}
	}
	
	function updateCommSlip(rows, i, func){
		new Ajax.Request(contextPath+"/GIACCommSlipExtController", {
			method: "POST",
			parameters: {
				action: "updateCommSlip",
				fundCd: $F("fundCd"),
				branchCd: $F("branchCd"),
				gaccTranId: rows[i].gaccTranId,
				intmNo: rows[i].intmNo,
				commSlipPref: rows[i].csPref,
				commSlipSeq: rows[i].csNo
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					$("csSeqNo").value = nvl(obj.commSlipSeq, "");
					
					batchCommSlipTG.url = contextPath +"/GIACCommSlipExtController?action=getBatchCommSlip&refresh=1"+
														"&fundCd="+$F("fundCd")+"&branchCd="+$F("branchCd");
					batchCommSlipTG._refreshList();
					
					if((i+1) < rows.length){
						func(rows, ++i);
					}else{
						toggleOnPrint(true);
					}
				}
			}
		});
	}
	
	function regenerateCommSlipNo(rows, i){
		new Ajax.Request(contextPath+"/GIACCommSlipExtController", {
			parameters: {
				action: "generateCommSlipNo",
				commSlipPref: $F("csPref"),
				commSlipSeq: $F("csSeqNo")
			},
			asynchronous : false,
			evalScripts : true,
			onCreate: showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					batchCommSlipTG.url = contextPath +"/GIACCommSlipExtController?action=getBatchCommSlip&refresh=1"+
										"&fundCd="+$F("fundCd")+"&branchCd="+$F("branchCd");
					batchCommSlipTG._refreshList();
					
					if(!((parseInt(i) + 1) == rows.length)){
						getBatchCommSlipReports(i+1);
					}else{
						toggleOnPrint(true);
					}
				}
			}
		});
	}
	
	function clearCommSlipNo(rows, i, func){
		new Ajax.Request(contextPath+"/GIACCommSlipExtController", {
			method: "POST",
			parameters: {
				action: "clearCommSlipNo",
				gaccTranId: rows[i].gaccTranId,
				intmNo: rows[i].intmNo
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					regenerateCommSlipNo(rows, i);
				}
			}
		});
	}
	
	function validatePrinting(rows, i, func){
		showConfirmBox("Confirmation", "Was the commission slip printed correctly?", "Yes", "No",
			function(){
				updateCommSlip(rows, i, func);
			},
			function(){
				showPrintingOptions(rows, i, func);
			}, "1");
	}
	
	function showPrintingOptions(rows, i, func){
		showConfirmBox4("", "Pressing 'Print' will print the record again. Pressing 'Continue' will print the next record (if there is).",
			"Print", "Continue", "Stop Printing",
			function(){
				func(rows, i);
			},
			function(){
				clearCommSlipNo(rows, i, func);
			},
			function(){
				toggleOnPrint(true);
			}, "1");
	}
	
	$("btnToolbarEnterQuery").observe("click", function(){
		resetForm();
		clearTG();
	});
	
	$("btnToolbarExit").observe("click", function(){
		if(nvl(objACGlobal.previousModule, "") == "GIACS053"){
			showBatchORPrinting();
		}else{
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	});
	
	$("fundCd").observe("change", function(){
		if($F("fundCd") == ""){
			$("fundCd").setAttribute("lastValidValue", "");
			$("branchCd").setAttribute("lastValidValue", "");
			$("fundDesc").value = "";
			$("branchCd").value = "";
			$("branchName").value = "";
			disableInputField("branchCd");
			disableSearch("searchBranchCd");
		}else{
			showFundLOV();
		}
		toggleToolbars();
	});
	
	$("branchCd").observe("change", function(){
		if($F("branchCd") == ""){
			$("branchCd").setAttribute("lastValidValue", "");
			$("branchName").value = "";
		}else{
			showBranchLOV();
		}
		toggleToolbars();
	});
	
	$("selDestination").observe("change", function(){
		$("selPrinter").value = "";
		
		if($F("selDestination") == "printer"){
			$("selPrinter").disabled = false;
			$("selPrinter").addClassName("required");
		}else{
			$("selPrinter").disabled = true;
			$("selPrinter").removeClassName("required");
		}
	});
	
	$("btnGenerate").observe("click", function(){
		saveGenerateFlag("Y");
	});
	
	$("btnStop").observe("click", function(){
		stopPrinting = true;
	});
	
	$("tagAll").observe("click", tagAll);
	$("untagAll").observe("click", untagAll);
	$("reloadForm").observe("click", showGIACS250);
	$("searchFundCd").observe("click", showFundLOV);
	$("searchBranchCd").observe("click", showBranchLOV);
	$("btnPrint").observe("click", printBatchCommSlip);
	$("btnToolbarExecuteQuery").observe("click", getCommSlipNo);
	
	newFormInstance();
</script>