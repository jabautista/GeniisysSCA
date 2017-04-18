<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="billsByIntmMainDiv" name="billsByIntmMainDiv">
	<div id="toolbarDiv" name="toolbarDiv">	
		<div class="toolButton">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/enterQuery.png) left center no-repeat;" id="btnToolbarEnterQuery1">Enter Query</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/enterQueryDisabled.png) left center no-repeat;" id="btnToolbarEnterQuery1Disabled">Enter Query</span>
		</div>
		<div class="toolbarsep" id="btnToolbarEnterQuerySep1">&#160;</div>
		<div class="toolButton">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/executeQuery.png) left center no-repeat;" id="btnToolbarExecuteQuery1">Execute Query</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/executeQueryDisabled.png) left center no-repeat;" id="btnToolbarExecuteQuery1Disabled">Execute Query</span>
		</div>
		<div class="toolButton" style="float: right;">
			<span style="background: url(${pageContext.request.contextPath}/images/toolbar/exit.png) left center no-repeat;" id="btnToolbarExit1">Exit</span>
			<span style="display: none; background: url(${pageContext.request.contextPath}/images/toolbar/exitDisabled.png) left center no-repeat;" id="btnToolbarExit1Disabled">Exit</span>
		</div>
	 </div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Bill Inquiry per Intermediary</label>
		</div>
	</div>
	
	<div id="billsByIntmHeaderDiv" class="sectionDiv">
		<table style="margin: 10px 0 10px 45px;">
			<tr>
				<td>
					<label style="margin: 4px 5px 0 0;">Intermediary</label>
					<span class="lovSpan" style="width: 70px;">
						<input id="intmType" name="headerField" type="text" class="upper" style="float: left; margin-top: 0px; margin-right: 3px; height: 13px; width: 40px; border: none;" maxlength="2" tabindex="101" lastValidValue=""/>
						<img id="searchIntmType" name="searchIntmType" alt="Go" style="height: 18px; margin-top: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png"/>
					</span>
				</td>
				<td>
					<span class="required lovSpan" style="width: 70px;">
						<input id="intmNo" name="headerField" type="text" class="required upper integerNoNegativeUnformatted" style="float: left; margin-top: 0px; margin-right: 3px; height: 13px; width: 40px; border: none;" maxlength="13" tabindex="102" lastValidValue=""/>
						<img id="searchIntmNo" name="searchIntmNo" alt="Go" style="height: 18px; margin-top: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png"/>
					</span>
				</td>
				<td>
					<input id="refIntmCd" name="headerField" type="text" style="float: left; margin-bottom: 3px; margin-right: 3px; height: 14px; width: 90px;" tabindex="103" readonly="readonly"/>
				</td>
				<td>
					<input id="intmName" name="headerField" type="text" style="float: left; margin-bottom: 3px; margin-right: 3px; height: 14px; width: 350px;" tabindex="104" readonly="readonly"/>
				</td>
				<td>
					<input id="issCd" name="headerField" type="text" style="float: left; margin-bottom: 3px; margin-right: 3px; height: 14px; width: 90px;" tabindex="105" readonly="readonly"/>
				</td>
			</tr>
		</table>
	</div>
	
	<div id="billsByIntmDiv" class="sectionDiv" style="height: 445px; margin-bottom: 30px;">
		<div id="billsTGDiv" style="height: 320px; margin: 10px 0 35px 11px;">
		
		</div>
		
		<div id="billsTotalDiv" style="float: left; width: 100%; margin: 0 0 10px 370px;">
			<label class="rightAligned" style="margin-top: 8px;">Totals</label>
    		<table>
				<tr>
					<td><input id="totalPremOs" name="totalPremOs" type="text"  readonly="readonly" style="width: 112px; margin-right:1px; text-align: right;" tabindex="201"></td>
					<td><input id="totalPremPd" name="totalPremPd" type="text" readonly="readonly" style="width: 112px; margin-right:1px; text-align: right;" tabindex="202"></td>
					<td><input id="totalCommOs" name="totalCommOs" type="text"  readonly="readonly" style="width: 112px; margin-right:1px; text-align: right;" tabindex="203"></td>
					<td><input id="totalCommPd" name="totalCommPd" type="text"  readonly="readonly" style="width: 112px; margin-right:1px; text-align: right;" tabindex="204"></td>
				</tr>
			</table>
		</div>
		
		<div id="billsButtonsDiv" align="center">
			<input id="btnViewPrem" type="button" class="button" value="Premium" style="width: 120px;" tabindex="205">
			<input id="btnViewComm" type="button" class="button" value="Commission" style="width: 120px;" tabindex="206">
		</div>
	</div>
</div>
<div id="otherModuleDiv"></div>

<script type="text/javascript">
	var reload = nvl('${reload}', "N");
	var onExecuteQuery = "N";

	try{
		billsTableModel = {
			url: contextPath+"/GIACInquiryController?action=showBillsByIntermediary&refresh=1&moduleId=GIACS288",
			options: {
	          	height: '325px',
	          	width: '900px',
	          	hideColumnChildTitle: true,
	          	onCellFocus: function(element, value, x, y, id){
	          		objGIACS288.selectedRow = billsTableGrid.geniisysRows[y];
	          		billsTableGrid.keys.removeFocus(billsTableGrid.keys._nCurrentFocus, true);
	            	billsTableGrid.keys.releaseKeys();
	            },
	            onRemoveRowFocus: function(){
	            	objGIACS288.selectedRow = "";
	            	billsTableGrid.keys.removeFocus(billsTableGrid.keys._nCurrentFocus, true);
	            	billsTableGrid.keys.releaseKeys();
	            },
	            onSort: function(){
	            	billsTableGrid.onRemoveRowFocus();
	            },
	            toolbar: {
	            	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
	            	onRefresh: function(){
	            		billsTableGrid.onRemoveRowFocus();
	            	},
	            	onFilter: function(){
	            		billsTableGrid.onRemoveRowFocus();
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
						{	id: 'billNumber',
							title: 'Bill Number',
							width: '0px',
							filterOption: true,
							visible: false
						},
						{	id: 'issCd premSeqNo',
							title: 'Bill Number',
							width: '125px',
							filterOption: false,
							children: [
								{	id: 'issCd',							
									width: 40,							
									sortable: false
								},
								{	id: 'premSeqNo',							
									width: 85,
									align: 'right',
									sortable: false,
									renderer: function(value){
										return lpad(value, 12, "0");
									}
								}
							]
						},
						{	id: 'policyNumber',
							title: 'Policy Number',
							width: '0px',
							filterOption: true,
							visible: false
						},
						{	id: 'lineCd-sublineCd-issCd-issueYy-polSeqNo-renewNo',
							title: 'Policy Number',
							width: '276px',
							filterOption: false,
							children: [
								{	id: 'lineCd',
									width: 38,
									sortable: false
								},
								{	id: 'sublineCd',
									width: 60,
									sortable: false
								},
								{	id: 'issCd',
									width: 38,
									sortable: false
								},
								{	id: 'issueYy',
									width: 30,
									sortable: false,
									align: 'right'
								},
								{	id: 'polSeqNo',
									width: 60,
									sortable: false,
									align: 'right',
									renderer: function(value){
										return lpad(value, 7, "0");
									}
								},
								{	id: 'renewNo',
									width: 30,
									sortable: false,
									align: 'right',
									renderer: function(value){
										return lpad(value, 2, "0");
									}
								}
							]
						},
						{	id: 'endtNumber',
							title: 'Endorsement Number',
							width: '0px',
							filterOption: true,
							visible: false
						},
						{	id: 'endtIssCd endtYy endtSeqNo endtType',
							title: 'Endorsement Number',
							width: '152px',
							filterOption: false,
							children: [
								{	id: 'endtIssCd',
									width: 38,
									sortable: false
								},
								{	id: 'endtYy',
									width: 38,
									align: 'right',
									sortable: false
								},
								{	id: 'endtSeqNo',
									width: 38,
									align: 'right',
									sortable: false
								},
								{	id: 'endtType',
									width: 38,
									sortable: false
								}
							]
						},
						{	id: 'refPolNo',
							title: 'Ref Pol Number',
							width: '150px',
							filterOption: true
						},
						{	id: 'assured',
							title: 'Assured',
							width: '90px',
							filterOption: true
						},
						{	id: 'premOs',
							title: 'Prem OS',
							width: '105px',
							align: 'right',
							geniisysClass: 'money'
						},
						{	id: 'premPd',
							title: 'Prem Paid',
							width: '105px',
							align: 'right',
							geniisysClass: 'money'
						},
						{	id: 'commOs',
							title: 'Comm OS',
							width: '105px',
							align: 'right',
							geniisysClass: 'money'
						},
						{	id: 'commPd',
							title: 'Comm Paid',
							width: '105px',
							align: 'right',
							geniisysClass: 'money'
						}
						],
			rows: []
		};
		billsTableGrid = new MyTableGrid(billsTableModel);
		billsTableGrid.pager = [];
		billsTableGrid.render('billsTGDiv');
		billsTableGrid.afterRender = function(){
			resizeColumns();
			populateTotals();
			billsTableGrid.onRemoveRowFocus();
			
			if(reload == "Y"){
				reload = "N";
				queryOnLoad();
			}
			
			if(onExecuteQuery == "Y" && billsTableGrid.geniisysRows.length == 0){
				showMessageBox("Query caused no records to be retrieved. Re-enter.", "I");
			}
			onExecuteQuery = "N";
		};
	}catch(e){
		showMessageBox("Error in Bills by Intermediary Table Grid: " + e, imgMessage.ERROR);
	}
	
	function newFormInstance(){
		if(reload != "Y"){
			objGIACS288 = new Object();
		}
		objGIACS288.selectedRow = "";
		
		initializeAll();
		makeInputFieldUpperCase();
		//hideToolbarButton("btnToolbarPrint");
		setModuleId("GIACS288");
		setDocumentTitle("Bill Inquiry per Intermediary");
		$("otherModuleDiv").hide();
		$("billsByIntmMainDiv").show();
	}
	
	function resizeColumns(){
		if(billsTableGrid.geniisysRows.length > 0){
			billsTableGrid._resizeColumn(billsTableGrid.getColumnIndex('assured'), "300");
			billsTableGrid._resizeColumn(billsTableGrid.getColumnIndex('policyNumber'), "155");
		}else{
			billsTableGrid._resizeColumn(billsTableGrid.getColumnIndex('assured'), "90");
			billsTableGrid._resizeColumn(billsTableGrid.getColumnIndex('policyNumber'), "120");
		}
	}
	
	function resetForm(){
		$$("input[name='headerField']").each(function(i){
			i.value = "";
		});
		
		$("intmType").setAttribute("lastValidValue", "");
		$("intmNo").setAttribute("lastValidValue", "");
		
		$("intmType").focus();
		enableInputField("intmType");
		enableInputField("intmNo");
		enableSearch("searchIntmType");
		enableSearch("searchIntmNo");
		disableToolbarButton("btnToolbarExecuteQuery1");
		disableToolbarButton("btnToolbarEnterQuery1");
		disableButton("btnViewPrem");
		disableButton("btnViewComm");
	}
	
	function queryOnLoad(){
		$("intmType").value = objGIACS288.intmType;
		$("intmNo").value = objGIACS288.intmNo;
		$("refIntmCd").value = objGIACS288.refIntmCd;
		$("intmName").value = objGIACS288.intmName;
		$("issCd").value = objGIACS288.issCd;
		
		executeQuery();
		enableToolbarButton("btnToolbarEnterQuery1");
	}
	
	function executeQuery(){
		billsTableGrid.url = contextPath +"/GIACInquiryController?action=showBillsByIntermediary&refresh=1"+
								"&moduleId=GIACS288&intmNo="+$F("intmNo");
		billsTableGrid._refreshList();
		toggleFields();
	}
	
	function toggleToolbars(){
		if($F("intmType") != "" || $F("intmNo") != ""){
			if($F("intmNo") != ""){
				enableToolbarButton("btnToolbarExecuteQuery1");
			}else{
				disableToolbarButton("btnToolbarExecuteQuery1");
			}
			enableToolbarButton("btnToolbarEnterQuery1");
		}else{
			disableToolbarButton("btnToolbarEnterQuery1");
			disableToolbarButton("btnToolbarExecuteQuery1");
		}
	}
	
	function toggleFields(){
		disableInputField("intmType");
		disableInputField("intmNo");
		disableSearch("searchIntmType");
		disableSearch("searchIntmNo");
		enableButton("btnViewPrem");
		enableButton("btnViewComm");
		disableToolbarButton("btnToolbarExecuteQuery1");
	}
	
	function setFormValues(){
		objGIACS288.intmType = $F("intmType");
		objGIACS288.intmNo = $F("intmNo");
		objGIACS288.refIntmCd = $F("refIntmCd");
		objGIACS288.intmName = $F("intmName");
		objGIACS288.issCd = $F("issCd");
		objACGlobal.previousModule = "GIACS288";
	}
	
	function populateTotals(){
		if(billsTableGrid.geniisysRows.length > 0){
			$("totalPremOs").value = formatCurrency(billsTableGrid.geniisysRows[0].totalPremOs);
			$("totalPremPd").value = formatCurrency(billsTableGrid.geniisysRows[0].totalPremPd);
			$("totalCommOs").value = formatCurrency(billsTableGrid.geniisysRows[0].totalCommOs);
			$("totalCommPd").value = formatCurrency(billsTableGrid.geniisysRows[0].totalCommPd);
		}else{
			$("totalPremOs").value = "";
			$("totalPremPd").value = "";
			$("totalCommOs").value = "";
			$("totalCommPd").value = "";
		}
	}
	
	function showIntmTypeLOV(){
		try{
			LOV.show({
				controller: "AccountingLOVController",
				urlParameters: {
					action: "getGIACS288IntmTypeLOV",
					filterText: $F("intmType") != $("intmType").getAttribute("lastValidValue") ? nvl($F("intmType"), "%") : "%"
				},
				title: "Intermediary Type",
				width: 415,
				height: 386,
				columnModel:[
								{	id: "intmType",
									title: "Intm Type",
									width: "75px",
								},
				             	{	id: "intmDesc",
									title: "Description",
									width: "325px"
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				filterText: $F("intmType") != $("intmType").getAttribute("lastValidValue") ? nvl($F("intmType"), "%") : "%",
			    noticeMessage: "Getting list, please wait...",
				onSelect : function(row){
					if(row != undefined) {
						$("intmType").value = row.intmType;
						$("intmType").setAttribute("lastValidValue", row.intmType);
						$("intmNo").focus();
						toggleToolbars();
					}
				},
				onCancel: function(){
					$("intmType").value = $("intmType").getAttribute("lastValidValue");
					toggleToolbars();
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("intmType").value = $("intmType").getAttribute("lastValidValue");
					toggleToolbars();
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showIntmTypeLOV", e);
		}
	}
	
	function showIntmNoLOV(){
		try{
			LOV.show({
				controller: "AccountingLOVController",
				urlParameters: {
					action: "getGIACS288IntmLOV",
					intmType: $F("intmType"),
					moduleId: "GIACS288",
					filterText: $F("intmNo") != $("intmNo").getAttribute("lastValidValue") ? nvl($F("intmNo"), "%") : "%"
				},
				title: "List of Intermediaries",
				width: 500,
				height: 386,
				columnModel:[
								{	id: "intmNo",
									title: "Intm No",
									width: "70px",
								},
				             	{	id: "refIntmCd",
									title: "Ref Intm Code",
									width: "100px"
								},
								{	id: "intmName",
									title: "Intm Name",
									width: "313px",
									renderer : function(value){
										return value.toUpperCase();					
									}
								},
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				filterText: $F("intmNo") != $("intmNo").getAttribute("lastValidValue") ? nvl($F("intmNo"), "%") : "%",
			    noticeMessage: "Getting list, please wait...",
				onSelect : function(row){
					if(row != undefined) {
						$("intmNo").value = row.intmNo;
						$("refIntmCd").value = row.refIntmCd;
						$("intmName").value = unescapeHTML2(row.intmName).toUpperCase();
						$("issCd").value = unescapeHTML2(row.issCd);
						$("intmNo").setAttribute("lastValidValue", row.intmNo);
						toggleToolbars();
					}
				},
				onCancel: function(){
					$("intmNo").value = $("intmNo").getAttribute("lastValidValue");
					toggleToolbars();
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("intmNo").value = $("intmNo").getAttribute("lastValidValue");
					toggleToolbars();
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showIntmNoLOV", e);
		}
	}
	
	$("intmType").observe("change", function(){
		if($F("intmType") != ""){
			showIntmTypeLOV();
		}else{
			$("intmType").setAttribute("lastValidValue", "");
		}
		toggleToolbars();
	});
	
	$("intmNo").observe("change", function(){
		if($F("intmNo") != ""){
			showIntmNoLOV();
		}else{
			$("refIntmCd").value = "";
			$("intmName").value = "";
			$("issCd").value = "";
			$("intmNo").setAttribute("lastValidValue", "");
		}
		toggleToolbars();
	});
	
	$("searchIntmType").observe("click", function(){
		showIntmTypeLOV();
	});
	
	$("searchIntmNo").observe("click", function(){
		showIntmNoLOV();
	});
	
	$("btnViewPrem").observe("click", function(){
		if(objGIACS288.selectedRow == ""){
			showMessageBox("Please select record first.", "I");
		}else{
			if(checkUserModule("GIACS211")){
				setFormValues();
				showBillPayment("GIACS288", objGIACS288.selectedRow.issCd, objGIACS288.selectedRow.premSeqNo);
			}else{
				showMessageBox("You are not allowed to access this module.", "I");
			}
		}
	});
	
	$("btnViewComm").observe("click", function(){
		if(objGIACS288.selectedRow == ""){
			showMessageBox("Please select record first.", "I");
		}else{
			if(checkUserModule("GIACS221")){
				setFormValues();
				showCommissionInquiry("GIACS288", objGIACS288.selectedRow.issCd, objGIACS288.selectedRow.premSeqNo);
			}else{
				showMessageBox("You are not allowed to access this module.", "I");
			}
		}
	});
	
	$("btnToolbarEnterQuery1").observe("click", function(){
		resetForm();
		billsTableGrid.url = contextPath +"/GIACInquiryController?action=showBillsByIntermediary&refresh=1"+
								"&moduleId=GIACS288&intmNo=-1";
		billsTableGrid._refreshList();
	});
	
	$("btnToolbarExecuteQuery1").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("billsByIntmHeaderDiv")){
			onExecuteQuery = "Y";
			executeQuery();
		}
	});
	
	$("btnToolbarExit1").observe("click", function(){
		delete objGIACS288;
		objACGlobal.previousModule = null;
		objACGlobal.callingForm = null;
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	});

	resetForm();
	newFormInstance();
</script>