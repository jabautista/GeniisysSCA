<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="viewOutwardRIMainDiv" name="viewOutwardRIMainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
   			<label>View Outward RI / Broker Outstanding Accounts</label>
	   	</div>
	</div>
	
	<div id="riDiv" name="riDiv" class="sectionDiv" >
		<table cellpadding="2" cellspacing="2" style="margin: 10px 10px 10px 200px;">
			<tr>
				<td class="rightAligned">Reinsurer</td>
				<td>
					<span class="required lovSpan" style="width: 90px; margin-right: 2px;">
						<input type="text" id="txtRiCd" name="txtRiCd" style="width: 65px; float: left; border: none; height: 14px; margin: 0; text-align:right;" class="required integerNoNegativeUnformattedNoComma" tabindex="101" maxlength="5" />  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osRiCd" name="osRiCd" alt="Go" style="float: right;" />
					</span>
					<input type="text" id="txtRiName" name="txtRiName" value="" class="required" style="width:340px; float: left; height: 14px; margin: 0;" class="upper" tabindex="102" maxlength="50" readonly="readonly" />
				</td>
			</tr>
		</table>
	</div>
	
	<div class="sectionDiv" style="margin-bottom: 10px;">
		<div id="binderTGDiv" name="binderTGDiv" style="height: 330px; margin: 15px 15px 15px 15px;"></div>
		
		<div style="margin: 10px 10px 10px 10px; width: 900px;">
			<table style="margin: 10px 10px 10px 0;">
				<tr>
					<td class="rightAligned" style="width:100px;">Premium</td>
					<td><input type="text" id="txtPremium" name="txtPremium" style="margin-left: 5px; width:290px; text-align: right;" tabindex="201" readonly="readonly" /></td>
					<td class="rightAligned" style="width:160px;">Commission</td>
					<td><input type="text" id="txtCommission" name="txtCommission" style="margin-left: 5px; width:295px; text-align: right;" tabindex="202" readonly="readonly" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Premium VAT</td>
					<td><input type="text" id="txtPremiumVat" name="txtPremiumVat" style="margin-left: 5px; width:290px; text-align: right;" tabindex="203" readonly="readonly" /></td>
					<td class="rightAligned">Commission VAT</td>
					<td><input type="text" id="txtCommissionVat" name="txtCommissionVat" style="margin-left: 5px; width:295px; text-align: right;" tabindex="204" readonly="readonly" /></td>
				</tr>
			</table>
		</div>
		
		<div class="sectionDiv" style="margin: 10px 10px 10px 10px; width: 897px;">
			<table border="0" style="margin: 10px 10px 10px 0;">
				<tr>
					<td class="rightAligned" style="width:100px;">Policy No.</td>
					<td><input type="text" id="txtPolicyNo" name="txtPolicyNo" style="margin-left: 5px; width:360px;" tabindex="301" readonly="readonly" /></td>
					<td class="rightAligned" style="width:130px;">Endt No.</td>
					<td>
						<input type="text" id="txtEndtIssCd" name="txtEndtIssCd" style="margin-left: 5px; width:50px;" tabindex="302" readonly="readonly" />
						<input type="text" id="txtEndtYy" name="txtEndtYy" style="width:50px; text-align: right;" tabindex="303" readonly="readonly" />
						<input type="text" id="txtEndtSeqNo" name="txtEndtSeqNo" style="width:130px; text-align: right;" tabindex="304" readonly="readonly" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Assured Name</td>
					<td><input type="text" id="txtAssdName" name="txtAssdName" style="margin-left: 5px; width:360px;" tabindex="305" readonly="readonly" /></td>
					<td class="rightAligned">FRPS No.</td>
					<td>
						<input type="text" id="txtFrpsLineCd" name="txtFrpsLineCd" style="margin-left: 5px; width:50px;" tabindex="306" readonly="readonly" />
						<input type="text" id="txtFrpsYy" name="txtFrpsYy" style="width:50px; text-align: right;" tabindex="307" readonly="readonly" />
						<input type="text" id="txtFrpsSeqNo" name="txtFrpsSeqNo" style="width:130px; text-align: right;" tabindex="308" readonly="readonly" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Confirm No.</td>
					<td><input type="text" id="txtConfirmNo" name="txtConfirmNo" style="margin-left: 5px; width:360px;" tabindex="309" readonly="readonly" /></td>
					<td class="rightAligned">Confirm Date</td>
					<td><input type="text" id="txtConfirmDate" name="txtConfirmDate" style="margin-left: 5px; width:255px;" tabindex="310" readonly="readonly" /></td>
				</tr>
			</table>
		</div>
	</div>
	
	
</div>

<script type="text/javascript">
	var onLOV = false;
	var isQueryExecuted = false;
	var binderList = JSON.parse('${binderList}');
	var binderRows = binderList.rows || [];
	var selectedRow = null;
	var selectedIndex = -1;
	
	try {
		binderTableModel = {
				url: contextPath + "/GIISReinsurerController?action=getOutwardRiList&refresh=1&riCd=" + $F("txtRiCd"),
				options: {
					width: '890px',
					height: '310px',
					hideColumnChildTitle: true,
					onCellFocus: function(element, value, x, y, id){
						selectedIndex = y;
						selectedRow = binderListingTableGrid.geniisysRows[y];
						populateFields(selectedRow);
						binderListingTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus: function(){
						binderListingTableGrid.keys.releaseKeys();
						selectedIndex = -1;
						selectedRow = null;
						populateFields(selectedRow);						
					},
					onSort: function(){
						binderListingTableGrid.onRemoveRowFocus();
					},
					toolbar: {
						elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
						onRefresh: function(){
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
									id: 'binderNo',
									title: 'Binder No.',
									width: '0px',
									filterOption: true,
									sortable: false,
									visible: false
								},
								{
									id: 'wConfirmation',
									width: '40px',
									title: '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;C',
									titleAlign: 'center',
									align: 'center',
									sortable: false,
								    editable: false,
									defaultValue: false,
									otherValue: false,
								    editor: new MyTableGrid.CellCheckbox({
							            getValueOf: function(value){
						            		if (value){
												return "Y";
						            		} else {
												return "N";	
						            		}	
						            	}
								    })
								},
								{
									id: 'lineCd binderYy binderSeqNo',
									title: 'Binder No.',
									width: 170,
									filterOption: true,
									sortable: true,
									children: [
												{
													id: 'lineCd',
													title: 'Line Cd',
													width: 50					
												},
												{
													id: 'binderYy',
													title: 'Binder Year',
													width: 50,
													align: 'right',
													renderer: function(value){
														return formatNumberDigits(value, 2);
													}									
												},
												{
													id: 'binderSeqNo',
													title: 'Binder Seq No',
													width: 80,
													align: 'right',
													renderer: function(value){
														return formatNumberDigits(value, 6);
													}						
												}
									]
								},
								{
									id: 'binderDateStr',
									title: 'Binder Date',
									width: '105px',
									type: 'date',
									format: 'mm-dd-yyyy',
									filterOption: true,
									filterOptionType: 'formattedDate'									
								},
								{
									id: 'netDue',
									title: 'Net Due',
									titleAlign: 'right',
									align: 'right',
									width: '175px',
									filterOption: true,
									filterOptionType: 'number',
									sortable: true,
									renderer: function(value){
										return formatCurrency(value);
									}
								},
								{
									id: 'payments',
									title: 'Payments',
									titleAlign: 'right',
									align: 'right',
									width: '175px',
									filterOption: true,
									filterOptionType: 'number',
									sortable: true,
									renderer: function(value){
										return formatCurrency(value);
									}
								},
								{
									id: 'balance',
									title: 'Balance',
									titleAlign: 'right',
									align: 'right',
									width: '175px',
									filterOption: true,
									filterOptionType: 'number',
									//geniisysClass: 'money',
									sortable: true,
									renderer: function(value){
										return formatCurrency(value);
									}							
								}
							],
							rows: binderRows
		};
		binderListingTableGrid = new MyTableGrid(binderTableModel);
		binderListingTableGrid.pager = binderList;
		binderListingTableGrid.render('binderTGDiv');
	} catch(e){
		showErrorMessage("outward RI table: ", e);
	}
	
	function initializeDefaultValues(){
		disableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarEnterQuery");
		//disableToolbarButton("btnToolbarPrint");
		$("btnToolbarPrint").hide();
		enableSearch("osRiCd");
		enableInputField("txtRiCd");
		$("txtRiCd").focus();		
	}
	
	function populateFields(row){
		$("txtPremium").value = row != null ? formatCurrency(nvl(row.riPremAmt, "0")) : "";
		$("txtPremiumVat").value = row != null ? formatCurrency(nvl(row.riPremVat, "0")) : ""; 
		$("txtCommission").value = row != null ? formatCurrency(nvl(row.riCommAmt, "0")) : "";
		$("txtCommissionVat").value = row != null ? formatCurrency(nvl(row.riCommVat, "0")) : "";
		
		$("txtPolicyNo").value = row != null ? unescapeHTML2(nvl(row.policyNo, "")) : "";
		$("txtAssdName").value = row != null ? unescapeHTML2(nvl(row.assdName, "")) : "";
		$("txtConfirmNo").value = row != null ? unescapeHTML2(nvl(row.confirmNo, "")) : "";
		$("txtConfirmDate").value = row != null ? unescapeHTML2(nvl(row.confirmDate, "")) : "";
		
		$("txtEndtIssCd").value = row != null ? (row.endtSeqNo > 0 ? unescapeHTML2(row.endtIssCd) : "") : "";
		$("txtEndtYy").value 	= row != null ? (row.endtSeqNo > 0 ? formatNumberDigits(nvl(row.endtYy, ""), 2) : "") : "";
		$("txtEndtSeqNo").value = row != null ? (row.endtSeqNo > 0 ? formatNumberDigits(nvl(row.endtSeqNo, ""), 7) : "") : "";
		
		$("txtFrpsLineCd").value = row != null ? unescapeHTML2(row.lineCd) : "";
		$("txtFrpsYy").value = row != null ? formatNumberDigits(row.frpsYy, 2) : "";
		$("txtFrpsSeqNo").value = row != null ? formatNumberDigits(row.frpsSeqNo, 9) : "";
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
	
	function getRiCdLOV(fieldName, fieldId, myText){
		if(onLOV) return;
		
		var searchString = myText;
		onLOV = true;
		try {
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGiris020RiLov", //"getGIISReinsurerLOV4",
					searchString : searchString,
					page : 1
				},
				title : "Reinsurers",
				width : 405,
				height : 388,
				columnModel : [ 
	                {
	                	id: "riCd",
	                	title: "RI Code",
	                	titleAlign: 'right',
	                	align: 'right',
	                	width: '50px'
	                },
	                {
						id : "riName",
						title : "Reinsurer Name",
						width : '340px'
					} ],
				draggable : true,
				autoSelectOneRecord: true,
				findText: escapeHTML2(searchString),
				onSelect : function(row) {
					onLOV = false;
					if (row != undefined || row != null) {
						$(fieldName).value = unescapeHTML2(row.riName);
						$(fieldId).value = row.riCd;
						enableToolbarButton("btnToolbarExecuteQuery");
					}
				},
				onCancel: function(){
					onLOV = false;
					$(fieldId).focus();
				},
				onUndefinedRow : function(){
					onLOV = false;
					customShowMessageBox("No record selected.", imgMessage.INFO, fieldId);
				} 
			});
		} catch (e) {
			showErrorMessage("getRiCdLOV", e);
		}
	}
	
	function executeQuery(){
		binderListingTableGrid.url = contextPath + "/GIRIBinderController?action=getOutwardRiList&refresh=1&riCd=" + $F("txtRiCd");
		binderListingTableGrid._refreshList();
	}
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("riDiv")){ //checkRequiredFields()
			isQueryExecuted = true;
			
			disableSearch("osRiCd");
			disableInputField("txtRiCd");
			disableToolbarButton("btnToolbarExecuteQuery");
			enableToolbarButton("btnToolbarEnterQuery");
			executeQuery();
		} 
	});
	
	$("btnToolbarEnterQuery").observe("click", function(){
		isQueryExecuted = false;
		
		enableSearch("osRiCd");
		enableInputField("txtRiCd");
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		populateFields(null);
		$("txtRiCd").clear();
		$("txtRiName").clear();
		$("txtRiCd").focus();
		executeQuery();
	});
	
	$("btnToolbarExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", "");	
	});
	
	$("osRiCd").observe("click", function(){
		validateRiCd("txtRiName", "txtRiCd", true);
	});
	
	$("txtRiCd").observe("change", function(){
		if($F("txtRiCd") != ""){
			validateRiCd("txtRiName", "txtRiCd", false);
		} else {
			disableToolbarButton("btnToolbarExecuteQuery");
		}
	});
	$("txtRiCd").observe("keypress", function(event){
		if(!isQueryExecuted){
			if(event.keyCode == objKeyCode.ENTER) {
				validateRiCd("txtRiName", "txtRiCd", false);
			} else if(event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 0) {
				$("txtRiName").clear();
			}
		}
	});	

	setModuleId("GIRIS020");
	setDocumentTitle("View Outward RI / Broker Outstanding Accounts");
	initializeAll();
	makeInputFieldUpperCase();
	initializeDefaultValues();
</script>