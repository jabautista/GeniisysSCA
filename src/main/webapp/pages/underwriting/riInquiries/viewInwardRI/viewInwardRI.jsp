<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="viewInwardRIMainDiv" name="viewInwardRIMainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
   			<label>Outstanding Balances Due From Ceding Co.</label>
	   	</div>
	</div>
	
	<div id="riDiv" name="riDiv" class="sectionDiv" >
		<table align="center"  style="margin-bottom: 10px; margin-top: 10px;">
			<tr>
				<td class="rightAligned">Ceding Company</td>
				<td>
					<span class="required lovSpan" style="width: 90px; margin-right: 2px;">
						<input type="text" id="txtRiCd" name="txtRiCd" style="width: 65px; float: left; border: none; height: 14px; margin: 0; text-align:right;" class="required integerNoNegativeUnformattedNoComma" tabindex="101" maxlength="5"  lastValidValue="" ignoreDelKey = "true" />  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchRiCd" name="searchRiCd" alt="Go" style="float: right;" />
					</span>
					<input type="text" id="txtRiSname" name="txtRiSname" value="" class="required" style="width:340px; float: left; height: 14px; margin: 0;" class="allCaps" tabindex="102" maxlength="50" readonly="readonly" />
				</td>
			</tr>
		</table>
	</div>
	
	<div class="sectionDiv" style="margin-bottom: 10px;">
		<div id="InwardRITGDiv" name="InwardRITGDiv" style="height: 330px; margin: 15px 15px 15px 15px;"></div>
		<div id="InwardRIDtlDiv">
			<table align="center" style="margin-bottom: 10px; margin-top: 10px; width: 90%;">
				<tr>
					<td class="rightAligned">Total Amount</td>
					<td><input type="text" id="txtTotalAmt" name="txtTotalAmt" style="margin-left: 5px; width:230px; text-align: right;" tabindex="103" readonly="readonly" /></td>
					<td class="rightAligned">Currency</td>
					<td><input type="text" id="txtCurrencyDesc" name="txtCurrencyDesc" style="margin-left: 5px; width:230px; text-align: right;" tabindex="105" readonly="readonly" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Commission Amount</td>
					<td><input type="text" id="txtCommAmt" name="txtCommAmt" style="margin-left: 5px; width:230px; text-align: right;" tabindex="104" readonly="readonly" /></td>
					<td class="rightAligned">RI Comm VAT</td>
					<td><input type="text" id="txtRiCommVat" name="txtRiCommVat" style="margin-left: 5px; width:230px; text-align: right;" tabindex="106" readonly="readonly" /></td>
				</tr>
			</table>
		</div>
		<div id="InwardRIBodyDiv" class="sectionDiv" style="margin: 10px 10px 10px 10px; width: 897px;">
			<table border="0" style="margin: 10px 10px 10px 0;">
				<tr>
					<td class="rightAligned" style="width:100px;">Policy No</td>
					<td><input type="text" id="txtPolicyNo" name="txtPolicyNo" style="margin-left: 5px; width:380px;" tabindex="107" readonly="readonly" /></td>
					<td class="rightAligned" style="width:130px;">RI Policy No</td>
					<td><input type="text" id="txtRiPolicyNo" name="txtRiPolicyNo" style="margin-left: 5px; width:230px;" tabindex="111" readonly="readonly" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Assured</td>
					<td><input type="text" id="txtAssdName" name="txtAssdName" style="margin-left: 5px; width:380px;" tabindex="108" readonly="readonly" /></td>
					<td class="rightAligned">RI Endt No</td>
					<td><input type="text" id="txtRiEndtNo" name="txtRiEndtNo" style="margin-left: 5px; width:230px;" tabindex="112" readonly="readonly" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Endt No</td>
					<td><input type="text" id="txtEndtNo" name="txtEndtNo" style="margin-left: 5px; width:200px;" tabindex="109" readonly="readonly" /></td>
					<td class="rightAligned">RI Binder No</td>
					<td><input type="text" id="txtRiBinderNo" name="txtRiBinderNo" style="margin-left: 5px; width:230px;" tabindex="113" readonly="readonly" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Effectivity Date</td>
					<td><input type="text" id="txtEffDate" name="txtEffDate" style="margin-left: 5px; width:200px;" tabindex="110" readonly="readonly" /></td>
					<td class="rightAligned">Expiry Date</td>
					<td><input type="text" id="txtExpDate" name="txtExpDate" style="margin-left: 5px; width:230px;" tabindex="114" readonly="readonly" /></td>
				</tr>
			</table>
		</div>
	</div>
</div>
<script type="text/javascript">
	setModuleId("GIRIS019");
	setDocumentTitle("Outstanding Balances Due From Ceding Co.");
	initializeAll();
	initializeDefaultValues();
	
	function initializeDefaultValues(){
		disableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarEnterQuery");
		$("btnToolbarPrint").hide();
		$("btnToolbarPrintSep").hide();
		enableSearch("searchRiCd");
		enableInputField("txtRiCd");
		$("txtRiCd").setAttribute("lastValidValue", "");
		$("txtRiCd").clear();
		$("txtRiSname").clear();
		$("txtRiCd").focus();	
	}
	
	try {
		var binderList = JSON.parse('${binderList}');
		binderTableModel = {
				url: contextPath + "/GIRIBinderController?action=showInwardRIMenu&refresh=1&riCd=" + $F("txtRiCd"),
				options: {
					width: '890px',
					height: '310px',
					hideColumnChildTitle: true,
					onCellFocus: function(element, value, x, y, id){
						var obj = binderListingTableGrid.geniisysRows[y];
						populateFields(obj);
						binderListingTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus: function(){
						populateFields(null);	
						binderListingTableGrid.keys.releaseKeys();
					},
					onSort: function(){
						binderListingTableGrid.onRemoveRowFocus();
					},
					postPager : function() {
						binderListingTableGrid.onRemoveRowFocus();
					},
					toolbar: {
						elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
						onRefresh: function(){
							binderListingTableGrid.onRemoveRowFocus();
						},
						onFilter : function() {
							binderListingTableGrid.onRemoveRowFocus();
						}
					}
				},
				columnModel: [
								{
									id: 'recordStatus',
									width: '0px',
									visible: false,
									editor: 'checkbox'
								},
								{
									id: 'divCtrId',
									width: '0px',
									visible: false
								},
								{
									id: 'acceptNo',
									title: 'Accept No.',
									width: '100px',
									titleAlign: 'right',
									align: 'right',
									filterOption: true,
									renderer : function(value){
										return formatNumberDigits(value, 6);
									}
								},
								{
									id: 'drvIssCd',
									title: 'Bill No.',
									width: '200px',
									filterOption: true
								},
								{
									id: 'dspDueDate',
									title: 'Due Date',
									titleAlign: 'center',
									align: 'center',
									width: '100px',
									filterOption: true,
									filterOptionType: 'formattedDate'
								},
								{
									id: 'netDue',
									title: 'Net Due',
									titleAlign: 'right',
									align: 'right',
									width: '150px',
									filterOption: true,
									filterOptionType: 'number',
									geniisysClass: 'money'		
								},
								{
									id: 'totalAmtPaid',
									title: 'Total Amt. Paid',
									titleAlign: 'right',
									align: 'right',
									width: '150px',
									filterOption: true,
									filterOptionType: 'number',
									geniisysClass: 'money'						
								},
								{
									id: 'balance',
									title: 'Balance',
									titleAlign: 'right',
									align: 'right',
									width: '150px',
									filterOption: true,
									filterOptionType: 'number',
									geniisysClass: 'money'						
								}
							],
							rows: binderList.rows
		};
		binderListingTableGrid = new MyTableGrid(binderTableModel);
		binderListingTableGrid.pager = binderList;
		binderListingTableGrid.render('InwardRITGDiv');
	} catch(e){
		showErrorMessage("outward RI table: ", e);
	}
	
	function populateFields(obj){
		$("txtTotalAmt").value 		= obj != null ? formatCurrency(nvl(obj.totalAmt, "0")) 		: "";
		$("txtCommAmt").value 		= obj != null ? formatCurrency(nvl(obj.riCommAmt, "0")) 	: ""; 
		$("txtCurrencyDesc").value	= obj != null ? unescapeHTML2(nvl(obj.currencyDesc,""))		: "";
		$("txtRiCommVat").value 	= obj != null ? formatCurrency(nvl(obj.riCommVat, "0")) 	: "";
		$("txtPolicyNo").value 		= obj != null ? unescapeHTML2(nvl(obj.policyNo, "")) 		: "";
		$("txtAssdName").value 		= obj != null ? unescapeHTML2(nvl(obj.assdName, "")) 		: "";
		$("txtRiPolicyNo").value 	= obj != null ? unescapeHTML2(nvl(obj.riPolicyNo, "")) 		: "";
		$("txtRiEndtNo").value 		= obj != null ? unescapeHTML2(nvl(obj.riEndtNo, "")) 		: "";
		$("txtEndtNo").value 		= obj != null ? unescapeHTML2(nvl(obj.endtNo, "")) 			: "";
		$("txtRiBinderNo").value 	= obj != null ? unescapeHTML2(nvl(obj.riBinderNo, "")) 		: "";
		$("txtEffDate").value 		= obj != null ? unescapeHTML2(nvl(obj.dspEffDate, "")) 		: "";
		$("txtExpDate").value 		= obj != null ? unescapeHTML2(nvl(obj.dspExpiryDate, "")) 		: "";
	}
	
	function validateRiCd(fieldName, fieldId, isIconClicked){
		var findText = ($F(fieldId).trim() == "" ? "%" : $F(fieldId));
		var cond = validateTextFieldLOV("/UnderwritingLOVController?action=getGiris020RiLov" //getGIISReinsurerLOV4"
						+ "&filterText=" + ( $F(fieldId).trim() == "" ? "%" : encodeURIComponent($F(fieldId)) )
						, findText
						, "");
		if (cond > 1) {
			getRiCdLOV(fieldName, fieldId, findText);
		} else if(cond < 1) {
			customShowMessageBox("Reinsurer Code is invalid. Please enter another Reinsurer Code.", "I", fieldId);
			$(fieldId).value = "";
			$(fieldName).value = "";
			disableToolbarButton("btnToolbarExecuteQuery");
		} else if(cond.total == 1 && !isIconClicked){
			getRiCdLOV(fieldName, fieldId, findText);
		} else if(cond.total == 1 && isIconClicked){			
			getRiCdLOV(fieldName, fieldId, "%");
		} else {
			getRiCdLOV(fieldName, fieldId, findText);
		}
	}
	
	function getRiCdLOV(){
		try {
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGiris019RiLOV",
					findText2 : ($("txtRiCd").readAttribute("lastValidValue").trim() != $F("txtRiCd").trim() ? $F("txtRiCd").trim() : "%"),
					page : 1
				},
				title : "List of Ceding Company",
				width : 405,
				height : 388,
				columnModel : [ 
	                {
	                	id: "riCd",
	                	title: "Ri Code",
	                	titleAlign: 'right',
	                	align: 'right',
	                	width: '80px'
	                },
	                {
						id : "riSname",
						title : "Ri Sname",
						width : '310px'
					} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: ($("txtRiCd").readAttribute("lastValidValue").trim() != $F("txtRiCd").trim() ? $F("txtRiCd").trim() : ""),
				onSelect : function(row) {
					$("txtRiCd").value = row.riCd;
					$("txtRiSname").value = unescapeHTML2(row.riSname);
					$("txtRiCd").setAttribute("lastValidValue", row.riCd);	
					enableToolbarButton("btnToolbarEnterQuery");
					enableToolbarButton("btnToolbarExecuteQuery");
				},
				onCancel: function(){
					$("txtRiCd").value = $("txtRiCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtRiCd").value = $("txtRiCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
			});
		} catch (e) {
			showErrorMessage("getRiCdLOV", e);
		}
	}
	
	$("searchRiCd").observe("click", getRiCdLOV);
	
	$("txtRiCd").observe("change", function(){
		if($F("txtRiCd").trim() == "") {
			$("txtRiCd").value = "";
			$("txtRiCd").setAttribute("lastValidValue", "");
			$("txtRiSname").value = "";
		} else {
			if($F("txtRiCd").trim() != "" && $F("txtRiCd") != $("txtRiCd").readAttribute("lastValidValue")) {
				getRiCdLOV();
			}
		}
	});
	
	function executeQuery(riCd){
		binderListingTableGrid.url = contextPath + "/GIRIBinderController?action=showInwardRIMenu&refresh=1&riCd=" +  riCd;
		binderListingTableGrid._refreshList();
	}
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("riDiv")){ 
			disableSearch("searchRiCd");
			disableInputField("txtRiCd");
			disableToolbarButton("btnToolbarExecuteQuery");
			enableToolbarButton("btnToolbarEnterQuery");
			executeQuery($F("txtRiCd"));
			if (binderListingTableGrid.geniisysRows.length < 1) {
				showMessageBox("Query caused no records to be retrieved. Re-enter.", "I");
			}
		} 
	});
	
	$("btnToolbarEnterQuery").observe("click", function(){
		executeQuery("");
		initializeDefaultValues();
		populateFields(null);
	});
	
	$("btnToolbarExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", "");	
	});
</script>