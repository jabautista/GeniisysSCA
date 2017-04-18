<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div class="sectionDiv">
	<div id="inwFaculPremCollnsTableGridSectionDiv" class="sectionDiv" style="height: 285px; border: none; margin-bottom: 20px">
		<div id="inwFaculPremCollnsTableGridDiv" style="padding: 10px;">
			<div id="inwFaculPremCollnsTableGrid" style="height: 270px; width: 900px;"></div>
		</div>
	</div>
	<div id="inwFaculPremCollnsTotalAmtMainDiv"  class="sectionDiv" style="margin:10px; margin-top:10px; margin-left: 35%; width:900px; border:none;">
					<div id="inwFaculPremCollnsTotalAmtsDiv" style="width:100%; padding-left: 2%;">
						<table id = "totalAmtsTable" name = "totalAmtsTable">
							<tr>
								<td class="rightAligned">Total Collection Amt </td>
								<td class="leftAligned"><input type="text" id="txtTotalCollAmt" name="txtTotalCollAmt" readonly="readonly" value="" class="money" tabindex=201/></td>
								<td class="rightAligned">Total Premium Amt</td>
								<td class="leftAligned"><input type="text" id="txtTotalPremAmt" name="txtTotalPremAmt" readonly="readonly" value="" class="money" tabindex=203/></td>
							</tr>
							<tr>
								<td class="rightAligned">Total Tax Amt</td>
								<td class="leftAligned"><input type="text" id="txtTotalTaxAmt" name="txtTotalTaxAmt" readonly="readonly" value="" class="money" tabindex=202 style="margin-right: 10%;"/></td>
								<td class="rightAligned">Total Comm Amt</td>
								<td class="leftAligned"><input type="text" id="txtTotalCommAmt" name="txtTotalCommAmt" readonly="readonly" value="" class="money" tabindex=204/></td>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td class="rightAligned">Total Comm VAT Amt </td>
								<td class="leftAligned"><input type="text" id="txtTotalCommVat" name="txtTotalCommVat" readonly="readonly" value="" class="money" tabindex=205/></td>
							</tr>
						</table>
					</div>
	</div>
	<div class="sectionDiv" style="border: none;" id="inwardFaculPremCollnsDiv" name="inwardFaculPremCollnsDiv">
		<div id="inwardFaculTop" name="inwardFaculTop" style="margin: 10px;">
			<input type="hidden" id="savedItemInw" 		name="savedItemInw" 		value="" />
			<input type="hidden" id="taxAllocation" 	name="taxAllocation" 		value="${empty taxAllocation ? 'Y' :taxAllocation}" />
			<input type="hidden" id="b140IssCdInw"  	name="b140IssCdInw" 		value="RI" />
			<input type="hidden" id="wholdingTaxInw"  	name="wholdingTaxInw" 		value="" />
			<input type="hidden" id="orPrintTagInw"  	name="orPrintTagInw" 		value="" />
			<input type="hidden" id="cpiRecNoInw"  		name="cpiRecNoInw" 			value="" />
			<input type="hidden" id="cpiBranchCdInw"  	name="cpiBranchCdInw" 		value="" />
			<input type="hidden" id="assdNoInw"  		name="assdNoInw" 			value="" />
			<input type="hidden" id="riPolicyNoInw"  	name="riPolicyNoInw" 		value="" />
			<input type="hidden" id="defCollnAmtInw"  	name="defCollnAmtInw" 		value="" />
			<input type="hidden" id="premiumTaxInw"  	name="premiumTaxInw" 		value="" />
			<input type="hidden" id="inwCurrencyCd" 	name="inwCurrencyCd" 		value=""/>
			
			<input type="hidden" id="inwConvertRate" 	name="inwConvertRate" 		value=""/>
			<input type="hidden" id="inwUserId" 		name="inwUserId"			value=""/>
			<input type="hidden" id="inwLastUpdate" 	name="inwLastUpdate" 		value=""/>
			
			<input type="hidden" id="inwTransactionTypeDesc" name="inwTransactionTypeDesc"  value=""/>
			<input type="hidden" id="inwAssdName" 			 name="inwAssdName" 			value=""/>
			<input type="hidden" id="inwDrvPolicyNo" 		 name="inwDrvPolicyNo" 			value=""/>
			<input type="hidden" id="inwCurrencyDesc" 		 name="inwCurrencyDesc" 		value=""/>
			<input type="hidden" id="inwDefCollAmt" 		 name="inwDefCollAmt" 			value=""/>
			<input type="hidden" id="inwPremiumTax" 		 name="inwPremiumTax" 			value=""/>
			
			<input type="hidden" id="variableSoaCollectionAmtInw"  	name="variableSoaCollectionAmtInw"  	value="" />
			<input type="hidden" id="variableSoaPremiumAmtInw"  	name="variableSoaPremiumAmtInw" 		value="" />
			<input type="hidden" id="variableSoaPremiumTaxInw"  	name="variableSoaPremiumTaxInw" 		value="" />
			<input type="hidden" id="variableSoaWholdingTaxInw"  	name="variableSoaWholdingTaxInw" 		value="" />
			<input type="hidden" id="variableSoaCommAmtInw"  		name="variableSoaCommAmtInw" 			value="" />
			<input type="hidden" id="variableSoaTaxAmountInw"  		name="variableSoaTaxAmountInw" 			value="" />
			<input type="hidden" id="variableSoaCommVatInw"  		name="variableSoaCommVatInw" 			value="" />
			<input type="hidden" id="defForgnCurAmtInw"  			name="defForgnCurAmtInw" 					value="" />
			<input type="hidden" id="hasClaim"  					name="hasClaim" 						value="" /> <!-- Deo [01.20.2017]: SR-5909 -->
			<input type="hidden" id="daysOverDue"  					name="daysOverDue" 						value="" /> <!-- Deo [01.20.2017]: SR-5909 -->
			<input type="hidden" id="vldtInstNoMsg"  				name="vldtInstNoMsg" 					value="" /> <!-- Deo [01.20.2017]: SR-5909 -->
			
			<table align="center" border="0" style="margin:40px; margin-top:10px; margin-bottom:10px;">
				<tr>
					<td class="rightAligned" style="width: 20%;">Transaction Type</td>
					<td class="leftAligned" style="width: 32%;">
						<select id="transactionTypeInw" name="transactionTypeInw" style="width: 198px; " class="required" tabindex=206>
							<option value=""></option>
							<c:forEach var="transactionType" items="${transactionTypeList }" varStatus="ctr">
								<option value="${transactionType.rvLowValue }" typeDesc="${transactionType.rvMeaning }">${transactionType.rvLowValue } - ${transactionType.rvMeaning }</option>
							</c:forEach>
						</select>
						<input type="text" style="width: 190px;" id="transactionTypeInwReadOnly" name="transactionTypeInwReadOnly" class="required" value="" readonly="readonly" style="display:none;" tabindex=206/>
					</td>
					<td class="leftAligned" width="48%" style="font-size: 11px;">Assured Name</td>
				</tr>
				<tr>
					<td class="rightAligned">Cedant</td>
					<td class="leftAligned">
						<select id="a180RiCdInw" name="a180RiCdInw" style="width: 198px;" class="required" tabindex=207>
							<option value=""></option>
						</select>
						<select id="a180RiCd2Inw" name="a180RiCd2Inw" style="width:198px;" class="required" tabindex=207>
							<option value=""></option>
							<c:forEach var="reinsurerList2" items="${reinsurerList2 }" varStatus="ctr">
								<option value="${reinsurerList2.riCd }">${reinsurerList2.riName }</option>
							</c:forEach>
						</select>
						<input type="text" style="width: 190px;" id="cedantInwReadOnly" name="cedantInwReadOnly" class="required" value="" readonly="readonly" style="display:none;" tabindex=207/>
					</td>
					<td class="leftAligned"><input type="text" style="width:300px; margin-right:70px;" id="assuredNameInw" name="assuredNameInw" value="" readonly="readonly" tabindex=215/></td>
				</tr>
				<tr>
					<td class="rightAligned">Invoice No.</td>
					<td class="leftAligned">
						<div style="width: 196px;" class="required withIconDiv" id="invNoDiv">
							<input type="text" style="width: 170px;" id="b140PremSeqNoInw" name="b140PremSeqNoInw" class="integerNoNegativeUnformattedNoComma required withIcon" value="" maxlength="8" errorMsg="Entered Invoice No. is invalid. Valid value is from 00000001 to 99999999." tabindex=208 lastValidValue=""/>
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="invoiceInwDate" class="cancelORSearch" name="invoiceInwDate" alt="Go"  tabindex=209/>
						</div>
					</td>
					<td class="leftAligned" style="font-size: 11px;";>Policy No.</td>
				</tr>
				<tr>
					<td class="rightAligned">Installment No.</td>
					<td class="leftAligned">
						<div style="width: 196px;" class="required withIconDiv" id="insNoDiv">
							<input style="width:170px;" type="text" id="instNoInw" name="instNoInw" class="required withIcon" value="" maxlength="2" tabindex=210 lastValidValue=""/>
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="instNoInwDate" class="cancelORSearch" name="instNoInwDate" alt="Go" tabindex=211/> 
						</div>
					</td>
					<td class="leftAligned">
						<input type="text" style="width: 300px; margin-right: 70px;" id="policyNoInw" name="policyNoInw" value="" readonly="readonly" tabindex=217/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Collection Amount</td>
					<td class="leftAligned"><input type="text" style="width: 190px; text-align: right;" id="collectionAmtInw" name="collectionAmtInw" class="required money4" maxlength="14" value="" tabindex=212 /></td>
					<td class="leftAligned" style="font-size: 11px;">Particulars</td>
				</tr>
				<tr>
					<td colspan="2" style="margin:auto;" align="right"> <!-- Deo [01.20.2017]: change align from center to right (SR-5909) -->
						<div style="width: 110px; float: left;"> <!-- Deo [01.20.2017]: SR-5909 -->
							<input type="button" style="width: 13px; height: 13px; float: left; margin-left: 40px;" id="btnUpdate" class="button" value=""  tabindex="212" />
							<label style="margin-left: 4px; float: left;" id="lblUpdate">Update</label>
						</div>
						<input type="button" style="width: 80px;" id="btnAddInw" 	class="button noChangeTagAttr cancelORBtn" value="Add" tabindex=213/>
						<input type="button" style="width: 80px;" id="btnDeleteInw" class="button noChangeTagAttr cancelORBtn" value="Delete" tabindex=214/>
						<input type="button" style="width: 80px; margin-right: 57px;" id="btnInvoiceInw" class="button noChangeTagAttr cancelORBtn" value="Invoice" tabindex=215/> <!-- Deo [01.20.2017]: added margin (SR-5909)-->
					</td>
					<td class="leftAligned" width="50%"><input type="text" style="width: 300px; margin-right: 70px;" id="particularsInw" class="txtReadOnly" name="particularsInw" maxlength="500" value="" tabIndex=218/></td>
				</tr>
				<tr>
					<td colspan="2"></td>
					<td colspan="2">
						<input type="button" style="width: 150px;" id="btnCurrencyInfoInw"  class="button noChangeTagAttr" value="Currency Information" tabindex=219/>
						<input type="button" style="width: 80px;"  id="btnBreakDownInw" 	 class="button noChangeTagAttr" value="Breakdown" tabindex=225/>
					</td>
				</tr>
			</table>
		</div>
		<div id="currencyInwDiv" style="display: none;">
			<table border="0" align="center" style="margin:10px auto;">
				<tr>
					<td class="rightAligned" style="width: 123px;">Currency Code</td>
					<td class="leftAligned"  ><input type="text" style="width: 50px; text-align: left" id="currencyCdInw" name="currencyCdInw" value="" readonly="readonly" tabindex=220/></td>
					<td class="rightAligned" style="width: 180px;">Conversion Rate</td>
					<td class="leftAligned"  ><input type="text" style="width: 100px; text-align: right" class="moneyRate" id="convertRateInw" name="convertRateInw" value="" readonly="readonly" tabindex=222/></td>
				</tr>
				<tr>
					<td class="rightAligned" >Currency Description</td>
					<td class="leftAligned"  ><input type="text" style="width: 170px; text-align: left" id="currencyDescInw" name="currencyDescInw" value="" readonly="readonly" tabindex=221/></td>
					<td class="rightAligned" >Foreign Currency Amount</td>
					<td class="leftAligned"  ><input type="text" style="width: 170px; text-align: right" class="money required" id="foreignCurrAmtInw" name="foreignCurrAmtInw" value="" maxlength="14" tabindex=223/></td>
				</tr> 
					<td width="100%" style="text-align: center;" colspan="4">
						<input type="button" style="width: 80px;" id="btnHideCurrInwDiv" 	   class="button noChangeTagAttr" value="Return" tabindex=223/>
					</td>
				</tr>
			</table>
		</div>	
		<div id="breakdownInwDiv" style="display: none;">
			<table border="0" align="center" style="margin:10px auto;">
				<tr>
					<td class="rightAligned" style="width: 123px;">Premium Amount</td>
					<td class="leftAligned"  ><input type="text" style="width:170px;" id="premiumAmtInw" name="premiumAmtInw" value="" class="money" readonly="readonly" tabindex=226/></td>
					<td class="rightAligned" style="width: 180px;">Tax Amount</td>
					<td class="leftAligned"  ><input type="text" style="width:170px;" id="taxAmountInw" name="taxAmountInw" value="" class="money" readonly="readonly" tabindex=228/></td>
				</tr>
				<tr>
					<td class="rightAligned" >Commission Amount</td>
					<td class="leftAligned"  ><input type="text" style="width:170px;" id="commAmtInw" name="commAmtInw" value="" class="money" readonly="readonly" tabindex=227/></td>
					<td class="rightAligned" >Commission VAT Amount</td>
					<td class="leftAligned"  ><input type="text" style="width:170px;" id="commVatInw" name="commVatInw" value="" class="money" readonly="readonly" tabindex=229/></td>
				</tr>
				<tr>
					<td width="100%" style="text-align: center;" colspan="4">
						<input type="button" style="width: 80px;" id="btnHideBreakdownInwDiv" 	   class="button noChangeTagAttr" value="Return" tabindex=230/>
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>
<div id="inwardFaculButtonsDiv" class="buttonsDiv" style="float:left; width: 100%;">			
	<input type="button" style="width: 80px;" id="btnCancelInwFacul" name="btnCancelInwFacul"	class="button" value="Cancel" tabindex=231/>
	<input type="button" style="width: 80px;" id="btnSaveInwFacul" 	 name="btnSaveInwFacul"		class="disabledButton cancelORButton" value="Save" tabindex=232/>
</div>
<script type="text/javaScript">
	setModuleId("GIACS008");
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	initializeAccordion();
	hideNotice("");
	var a180RiCdInwObjLOV = JSON.parse('${reinsurerList}'.replace(/\\/g, '\\\\'));
	objAC.hidObjAC008 = {};
	var objInwFaculPremCollns = null;
	var curRecObj = {}; //Deo [01.20.2017]: SR-5909
	//var otherInwPremCollnsList = '${otherInwPremCollnsList}'; used JSON.parse to be able to read object by MAC 01/18/2013.
	//var otherInwPremCollnsList = JSON.parse('${otherInwPremCollnsList}'); removed by pjsantos 12/12/2016, variable is no longer in use, for optimization GENQA 5891.
	var addedRecord = new Array(); //store all added record by MAC 01/04/2013 
	var originalCollectionAmount = new Array(); //store all newly inserted RI Bill by MAC 05/28/2013.
	showInwFaculPremCollnsTableGrid();
	$("instNoInw").setAttribute("lastValidValue", "");

	//table grid
	function showInwFaculPremCollnsTableGrid(){
		try{
			objInwFaculPremCollns = [];
			var inwFaculPremCollnsObj = new Object();
			inwFaculPremCollnsObj.inwFaculPremCollnsTableGrid = JSON.parse('${giacInwfaculCollns}'.replace(/\\/g, '\\\\'));
			inwFaculPremCollnsObj.inwFaculPremCollnsList = inwFaculPremCollnsObj.inwFaculPremCollnsTableGrid.rows || [];
			
			var inwFaculPremCollnsTableModel = {
					url : contextPath+ "/GIACInwFaculPremCollnsController?action=showInwFaculPremCollnsTableGrid&globalGaccTranId=" + objACGlobal.gaccTranId,
					options : {
						title : '',
						width : '900px',
						onCellFocus : function(element, value, x, y, id) {
							selectedIndex = y;
							inwFaculPremCollnsTableGrid.keys.releaseKeys();
							var obj = inwFaculPremCollnsTableGrid.geniisysRows[y];
							populateCollnsDetails(obj);
							curRecObj = obj; //Deo [01.20.2017]: SR-5909
						},
						onCellBlur : function() {
							if((objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR") && objAC.tranFlagState != "C"){
								observeChangeTagInTableGrid(inwFaculPremCollnsTableGrid);
							}
						},
						onRemoveRowFocus : function() {
							selectedIndex = -1;
							inwFaculPremCollnsTableGrid.keys.releaseKeys();
							populateCollnsDetails(null);
							curRecObj = {}; //Deo [01.20.2017]: SR-5909
						},
						onSort : function(){
							inwFaculPremCollnsTableGrid.keys.releaseKeys();
							populateCollnsDetails(null);
						},
						postPager : function(){
							inwFaculPremCollnsTableGrid.keys.releaseKeys();
							populateCollnsDetails(null);
						},
						toolbar : {
							elements : [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
							postSave : function() {
								inwFaculPremCollnsTableGrid.clear();
								inwFaculPremCollnsTableGrid.refresh();
								inwFaculPremCollnsTableGrid.keys.releaseKeys();
								changeTag = 0;
								selectedIndex = -1;
							},
							onRefresh : function(){
								inwFaculPremCollnsTableGrid.keys.releaseKeys();
								populateCollnsDetails(null);
							},
							onFilter : function(){
								inwFaculPremCollnsTableGrid.keys.releaseKeys();
								populateCollnsDetails(null);
							}
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
		               {
					    	id : 'gaccTranId',
					    	title : '',
					    	width : '0px',
					    	visible : false
					    },
					    {
					    	id : 'transactionTypeAndDesc',
					    	title : 'Tran Type',
					    	width : '100px',
					    	filterOption : true
					    },
					    {
					    	id : 'riName',
					    	title : 'Cedant',
					    	width : '100px',
					    	filterOption : true
					    },
					    {
					    	id : 'b140PremSeqNo',
					    	title : 'Invoice No.',
					    	width : '75px',
					    	filterOption : true,
					    	align : 'right',
					    	titleAlign : 'right',
					    	renderer : function(value){
					    		return formatNumberDigits(value, 8);
					    	}
					    },
					    {
					    	id : 'instNo',
					    	title : 'Inst No.',
					    	width : '65px',
					    	filterOption : true,
					    	align : 'right',
					    	titleAlign : 'right'
					    },
					    {
					    	id : 'collectionAmt',
					    	title : 'Collection Amt',
					    	width : '100px',
					    	filterOption : true,
					    	align : 'right',
					    	titleAlign : 'right',
					    	renderer : function(value){
					    		return formatCurrency(value);
					    	}
					    },
					    {
					    	id : 'premiumAmt',
					    	title : 'Prem Amt',
					    	width : '100px',
					    	filterOption : true,
					    	align : 'right',
					    	titleAlign : 'right',
					    	renderer : function(value){
					    		return formatCurrency(value);
					    	}
					    },
					    {
					    	id : 'taxAmount',
					    	title : 'Tax Amt',
					    	width : '100px',
					    	filterOption : true,
					    	align : 'right',
					    	titleAlign : 'right',
					    	renderer : function(value){
					    		return formatCurrency(value);
					    	}
					    },
					    {
					    	id : 'commAmt',
					    	title : 'Comm Amt',
					    	width : '100px',
					    	filterOption : true,
					    	align : 'right',
					    	titleAlign : 'right',
					    	renderer : function(value){
					    		return formatCurrency(value);
					    	}
					    },
					    {
					    	id : 'commVat',
					    	title : 'Comm VAT Amt',
					    	width : '100px',
					    	filterOption : true,
					    	align : 'right',
					    	titleAlign : 'right',
					    	renderer : function(value){
					    		return formatCurrency(value);
					    	}
					    },
					    {
					    	id : 'a180RiCd',
					    	title : '',
					    	width : '0px',
					    	visible : false
					    },
					    {
					    	id : 'wholdingTax',
					    	title : '',
					    	width : '0px',
					    	visible : false
					    },
					    {
					    	id : 'particulars',
					    	title : '',
					    	width : '0px',
					    	visible : false
					    },
					    {
					    	id : 'currencyCd',
					    	title : '',
					    	width : '0px',
					    	visible : false
					    },
					    {
					    	id : 'convertRate',
					    	title : '',
					    	width : '0px',
					    	visible : false
					    },
					    {
					    	id : 'foreignCurrAmt',
					    	title : '',
					    	width : '0px',
					    	visible : false
					    },
					    {
					    	id : 'orPrintTag',
					    	title : '',
					    	width : '0px',
					    	visible : false
					    },
					    {
					    	id : 'userId',
					    	title : '',
					    	width : '0px',
					    	visible : false
					    },
					    {
					    	id : 'lastUpdate',
					    	title : '',
					    	width : '0px',
					    	visible : false
					    },
					    {
					    	id : 'cpiRecNo',
					    	title : '',
					    	width : '0px',
					    	visible : false
					    },
					    {
					    	id : 'cpiBranchCd',
					    	title : '',
					    	width : '0px',
					    	visible : false
					    },
					    {
					    	id : 'transactionType',
					    	title : '',
					    	width : '0px',
					    	filterOption : true,
					    	visible : false
					    },
					    {
					    	id : 'transactionTypeDesc',
					    	title : '',
					    	width : '0px',
					    	visible : false
					    },
					    {
					    	id : 'assdNo',
					    	title : '',
					    	width : '0px',
					    	visible : false
					    },
					    {
					    	id : 'assdName',
					    	title : '',
					    	width : '0px',
					    	visible : false
					    },
					    {
					    	id : 'riPolicyNo',
					    	title : '',
					    	width : '0px',
					    	visible : false
					    },
					    {
					    	id : 'drvPolicyNo',
					    	title : '',
					    	width : '0px',
					    	visible : false
					    },
					    {
					    	id : 'currencyDesc',
					    	title : '',
					    	width : '0px',
					    	visible : false
					    },
					],
					requiredColumns : '',
					resetChangeTag : true,
					rows : inwFaculPremCollnsObj.inwFaculPremCollnsList
			};
			inwFaculPremCollnsTableGrid = new MyTableGrid(inwFaculPremCollnsTableModel);
			inwFaculPremCollnsTableGrid.pager = inwFaculPremCollnsObj.inwFaculPremCollnsTableGrid;
			inwFaculPremCollnsTableGrid.render('inwFaculPremCollnsTableGrid');
			inwFaculPremCollnsTableGrid.afterRender = function(){
					objInwFaculPremCollns = inwFaculPremCollnsTableGrid.geniisysRows;
					//computeTotalAmountInTable(); //lara 3/21/2014
					var total1 = 0;
					var total2 = 0;
					var total3 = 0;
					var total4 = 0;
					var total5 = 0;
					
					if(objInwFaculPremCollns.length != 0){
						total1 = parseFloat(objInwFaculPremCollns[0].totCollectionAmt);
						total2 = parseFloat(objInwFaculPremCollns[0].totPremiumAmt);
						total3 = parseFloat(objInwFaculPremCollns[0].totTaxAmount);
						total4 = parseFloat(objInwFaculPremCollns[0].totCommAmt);
						total5 = parseFloat(objInwFaculPremCollns[0].totCommVat);

					}	
					$("txtTotalCollAmt").value = formatCurrency(total1).truncate(13, "...");
					$("txtTotalPremAmt").value = formatCurrency(total2).truncate(13, "...");
					$("txtTotalTaxAmt").value = formatCurrency(total3).truncate(13, "...");
					$("txtTotalCommAmt").value = formatCurrency(total4).truncate(13, "...");
					$("txtTotalCommVat").value = formatCurrency(total5).truncate(13, "..."); 
					
					objInwFaculPremCollns.length != 0 ? enableBtnUpd(true) : enableBtnUpd(false); //Deo [01.20.2017]: SR-5909
			};
		}catch(e){
			showErrorMessage("showInwFaculPremCollnsTableGrid", e);
		}
	}
	
	function showGIACS008InstNoLOV(){
		var a180RiCd;
		if ($F("transactionTypeInw") == "2" || $F("transactionTypeInw") == "4") {
			a180RiCd = $("a180RiCdInw").value;
		} else {
			a180RiCd = $("a180RiCd2Inw").value;
		}
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "getGiacs008InstNoLOV",
							filterText : ($("instNoInw").readAttribute("lastValidValue").trim() != $F("instNoInw").trim() ? $F("instNoInw").trim() : ""),
							riCd : a180RiCd,
							issCd : $("b140IssCdInw").value,
							premSeqNo : $("b140PremSeqNoInw").value,
							page : 1},
			title: "List of Funds",
			width: 500,
			height: 400,
			columnModel : [ {
								id: "instNo",
								title: "Installment No.",
								titleAlign: "right",
								align: "right",
								width: '150px',
							}, 
							{
								id : "premSeqNo",
								title: "Bill No.",
								titleAlign: "right",
								align: "right",
								width: '150px'
							},
							{
								id : "issCd",
								title: "Source",
								width: '150px'
							} 
							],
				autoSelectOneRecord: true,
				filterText : ($("instNoInw").readAttribute("lastValidValue").trim() != $F("instNoInw").trim() ? $F("instNoInw").trim() : ""),
				onSelect: function(row) {
					$("instNoInw").value = row.instNo;
					$("instNoInw").setAttribute("lastValidValue", row.instNo);
					var vMsgAlert = "";
					if ($F("instNoInw") != "" && $F("b140PremSeqNoInw") != ""){
					/* 	vMsgAlert = validateInstNoInwFacul($F("instNoInw"),"Y");
					}
					if (vMsgAlert == "" || vMsgAlert == null || vMsgAlert == "null"){
						defInstNo = $F("instNoInw"); 
					}	
					enableOrDisbleItem(); */ //Deo [01.20.2017]: comment out, revise to avoid bypass (SR-5909)
					//Deo [01.20.2017]: add start (SR-5909)
						if (nvl(validateInstNoInwFacul($F("instNoInw"),"Y"), "*") == "*") {
							defInstNo = $F("instNoInw"); 
							checkClaim(row.issCd, row.premSeqNo, row.instNo);
						}
					}
					//Deo [01.20.2017]: add ends (SR-5909)
				},
				onCancel: function (){
					$("instNoInw").value = $("instNoInw").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("instNoInw").value = $("instNoInw").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	//populate record details
	function populateCollnsDetails(obj){
		try{
			$("transactionTypeInw").value = (obj == null ? "" : obj.transactionType);
			$("inwTransactionTypeDesc").value = (obj == null ? "" : obj.transactionTypeDesc);
	 		$("transactionTypeInwReadOnly").value = getListTextValue("transactionTypeInw");
	 		(obj == null ? "" : getReinsurerLOV(obj.a180RiCd));
			$("b140IssCdInw").value = (obj == null? "RI" : obj.b140IssCd);
			$("b140PremSeqNoInw").value = (obj == null?"" : formatNumberDigits(obj.b140PremSeqNo,8));
			$("instNoInw").value = (obj == null?"" : obj.instNo);
			$("premiumAmtInw").value = (obj == null?"" : formatCurrency(obj.premiumAmt));
			$("commAmtInw").value = (obj == null?"" : formatCurrency(obj.commAmt));
			$("wholdingTaxInw").value = (obj == null?"" : obj.wholdingTax);
			$("particularsInw").value = (obj == null ? "" :obj.particulars);
			$("currencyCdInw").value = (obj == null ? "" : obj.currencyCd);
			$("convertRateInw").value = (obj == null ? "" : formatToNineDecimal(obj.convertRate));
			$("foreignCurrAmtInw").value = (obj == null ? "" : formatCurrency(obj.foreignCurrAmt));
			$("collectionAmtInw").value = (obj == null ? "" : formatCurrency(obj.collectionAmt));
			$("orPrintTagInw").value = (obj == null ? "" : obj.orPrintTag == null ? "N" : obj.orPrintTag);
			$("cpiRecNoInw").value = (obj == null ? "" : obj.cpiRecNo);
			$("cpiBranchCdInw").value = (obj == null ? "" : obj.cpiBranchCd);
			$("taxAmountInw").value = (obj == null ? "" : formatCurrency(obj.taxAmount));
			$("commVatInw").value = (obj == null ? "" : obj.commVat);
			$("assuredNameInw").value = (obj == null ? "" : unescapeHTML2(obj.assdName));
			$("assdNoInw").value = (obj == null ? "" : obj.assdNo);
			$("riPolicyNoInw").value = (obj == null ? "" : obj.riPolicyNo);
			$("policyNoInw").value = (obj == null ? "" : unescapeHTML2(obj.drvPolicyNo)); //bertongbully
			$("currencyDescInw").value = (obj == null ? "" : obj.currencyDesc);
			$("savedItemInw").value = (obj == null ? "" : obj.savedItems == null ? "Y" : obj.savedItems);
			$("btnAddInw").value = (obj == null ? "Add" : "Update");
			$("defCollnAmtInw").value = (obj == null ? "" : obj.defCollectionAmt); //added by steve 10.06.2013
			(obj==null ? objAC.hidObjAC008.hidUpdateable = "Y" : "");
			(obj == null ? getReinsurerLOV("") : "");
			//(obj == null ?  computeTotalAmountInTable(): ""); //lara 3/21/2014
			
			(obj == null ? enableButton("btnAddInw"): disableButton("btnAddInw"));
			(obj==null ? disableButton("btnDeleteInw") : enableButton("btnDeleteInw"));
			(obj==null ? disableButton("btnInvoiceInw") : enableButton("btnInvoiceInw"));
			
			if(objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y"){
				disableGIACS008();
			}else{
				enableOrDisbleItem();
			}
		}catch(e){
			showErrorMessage("populateCollnsDetails()", e);
		}
	}
	
	function setCollnObject(){
		try{
			var obj = new Object();
			obj.gaccTranId = '${gaccTranId}';
			if($F("btnAddInw") == "Update"){
				obj.transactionTypeAndDesc = $F("transactionTypeInwReadOnly");
				obj.transactionType = $F("transactionTypeInwReadOnly").split(' - ')[0];
			}else{
				obj.transactionType = $F("transactionTypeInw");
				obj.transactionTypeAndDesc = getListTextValue("transactionTypeInw");
			}
			
			if(obj.transactionType == '2' || obj.transactionType == '4'){
				obj.a180RiCd = $F("a180RiCdInw");
			}else{
				obj.a180RiCd = $F("a180RiCd2Inw");
			}
			obj.transactionTypeDesc = $F("inwTransactionTypeDesc")/* .split(" - ")[1] */;
			obj.b140IssCd = $F("b140IssCdInw");
			obj.b140PremSeqNo = $F("b140PremSeqNoInw")*1;
			obj.instNo = $F("instNoInw");
			obj.premiumAmt = unformatCurrency("premiumAmtInw");
			obj.commAmt = unformatCurrency("commAmtInw");
			obj.wholdingTax = $F("wholdingTaxInw");
			obj.particulars = changeSingleAndDoubleQuotes2($F("particularsInw"));
			obj.currencyCd = $F("currencyCdInw");
			obj.convertRate = $F("convertRateInw");
			obj.foreignCurrAmt = unformatCurrency("foreignCurrAmtInw");
			obj.collectionAmt = unformatCurrency("collectionAmtInw");
			obj.defCollectionAmt = unformatCurrency("defCollnAmtInw");
			obj.orPrintTag = nvl($F("orPrintTagInw"), "N") ;
			obj.taxAmount = unformatCurrency("taxAmountInw");
			obj.commVat = $F("commVatInw");
			obj.riName = (obj.transactionType=="2" || obj.transactionType=="4" ?  getListTextValue("a180RiCdInw"): getListTextValue("a180RiCd2Inw"));
			obj.assdNo = $F("assdNoInw");
			obj.assdName = changeSingleAndDoubleQuotes2($F("assuredNameInw"));
			obj.riPolicyNo = $F("riPolicyNoInw");
			obj.drvPolicyNo = $F("policyNoInw");
			obj.currencyDesc = $F("currencyDescInw");
			obj.savedItems = $F("savedItemInw");
			return obj;
		}catch(e){
			showErrorMessage("setCollnObject()", e);
		}
	}
	
	
	//when transaction type click
	var transactionTypeInw;
	$("transactionTypeInw").observe("click",function(){
		transactionTypeInw = $F("transactionTypeInw");
		$("inwTransactionTypeDesc").value = getListTextValue("transactionTypeInw");
	});	
	$("transactionTypeInw").observe("change",function(){
		enableOrDisbleItem();
	});

	function clear(){
		try{
			$("a180RiCdInw").clear();
			$("a180RiCd2Inw").clear();
			$("b140PremSeqNoInw").clear();
			$("instNoInw").clear();
			$("collectionAmtInw").clear();
			$("assuredNameInw").clear();
			$("policyNoInw").clear();
			//$("particularsInw").clear();
		}catch(e){
			showErrorMessage("clear()", e);
		}
	}
	
	//when transaction type change
	$("transactionTypeInw").observe("change",function(){	
		lastAcceptedInvoiceValue = "";
		defInstNo = "";
		clear();
		if(objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y"){
			disableGIACS008();
		}else{
			if ($F("transactionTypeInw") == "2" || $F("transactionTypeInw") == "4"){
				$("a180RiCdInw").show();
				$("a180RiCd2Inw").hide();
			}else{
				$("a180RiCdInw").hide();
				$("a180RiCd2Inw").show();
			}
			getReinsurerLOV("");
			enableOrDisbleItem();
		}
	});

	//cedant for transaction type in (2,4)
	$("a180RiCdInw").observe("change",function(){
		$("b140PremSeqNoInw").clear();
		$("instNoInw").clear();
		$("collectionAmtInw").clear();
		$("assuredNameInw").clear();
		$("policyNoInw").clear();
		//$("particularsInw").clear();	
		enableOrDisbleItem();	
	});
	
	//cedant for transaction type in (1,3)
	$("a180RiCd2Inw").observe("change",function(){
		$("b140PremSeqNoInw").clear();
		$("instNoInw").clear();
		$("collectionAmtInw").clear();
		$("assuredNameInw").clear();
		$("policyNoInw").clear();
		//$("particularsInw").clear();		
		enableOrDisbleItem();	
	});

	//invoice no
	initPreTextOnField("b140PremSeqNoInw");
	var defInstNo = "";
	var lastAcceptedInvoiceValue = "";
	$("b140PremSeqNoInw").observe("change",function(){
		if ($F("savedItemInw") != "Y"){
			if ($F("b140PremSeqNoInw") != "" && checkIfValueChanged("b140PremSeqNoInw")){
				if (formatNumberDigits($F("b140PremSeqNoInw"),8) == "00000000") {
					$("b140PremSeqNoInw").clear();
					customShowMessageBox("Entered Invoice No. is invalid. Valid value is from 00000001 to 99999999.", "E", "b140PremSeqNoInw");
					$("b140PremSeqNoInw").value = lastAcceptedInvoiceValue; //display default value if entered value is invalid by MAC 01/18/2013.
					return;
				}
				var arrValidate = validateInvoiceInwFacul2($F("b140PremSeqNoInw")); //added by john 2.23.2015
				if (arrValidate[0] == "" || arrValidate[0] == null){
					checkPremPaytForRiSpecial($F("b140PremSeqNoInw"));
				} else {
					showWaitingMessageBox(arrValidate[0], imgMessage.ERROR, function(){
						$("b140PremSeqNoInw").clear();
						$("b140PremSeqNoInw").value = lastAcceptedInvoiceValue == "" ? "" : formatNumberDigits(lastAcceptedInvoiceValue,8);
						return false;
					});
				}
			} else if ($F("b140PremSeqNoInw") == "") {
				$("assuredNameInw").value = "";
				$("policyNoInw").value = "";
				$("particularsInw").value = "";
				$("instNoInw").value = "";
				$("collectionAmtInw").value = "";
			}
		}
		enableOrDisbleItem();
	});
	
	function validateInvoiceInwFacul2(b140PremSeqNoInw){
		try{
			var arr = [];
			var a180RiCd;
			if ($("transactionTypeInw").value == "2" || $("transactionTypeInw").value == "4"){
				a180RiCd = $("a180RiCdInw").value;
			}else{
				a180RiCd = $("a180RiCd2Inw").value;
			}
			new Ajax.Request(contextPath+'/GIACInwFaculPremCollnsController?action=validateInvoice2', {
				parameters: {
					a180RiCd: a180RiCd,
					b140IssCd: $("b140IssCdInw").value,
					transactionType: $("transactionTypeInw").value,
					b140PremSeqNoInw: b140PremSeqNoInw
				},
				asynchronous:false,
				evalScripts:true,
				onCreate: function(){
					showNotice("Validating Invoice, please wait...");	
				},	
				onComplete: function(response){
					hideNotice("");
					var msg = response.responseText;
					arr = msg.split(resultMessageDelimiter);
				}
			});
			return arr;
		}catch(e){
			shhowErrorMessage("validateInvoiceInwFacul2()",e);
		}
	}

	//search icon invoice no
	$("invoiceInwDate").observe("click",function(){
		if ($F("savedItemInw") != "Y"){
			if ($F("transactionTypeInw") == ""){
				customShowMessageBox("Please select a transaction type first.", imgMessage.ERROR, "transactionTypeInw");
				return false;
			}else if ($F("b140IssCdInw") == ""){
				customShowMessageBox("Issue source is null.", imgMessage.ERROR, "b140IssCdInw");
				return false;	
			}else if ($F("transactionTypeInw") == "2" || $F("transactionTypeInw") == "4"){
				if ($F("a180RiCdInw") == ""){
					customShowMessageBox("Please select a cedant first.", imgMessage.ERROR, "a180RiCdInw");
					return false;
				}else{
					//openSearchInvoiceInward();
					openSearchInvoiceInwardOverlay();
				}	
			}else if ($F("transactionTypeInw") == "1" || $F("transactionTypeInw") == "3"){
				if ($F("a180RiCd2Inw") == ""){
					customShowMessageBox("Please select a cedant first.", imgMessage.ERROR, "a180RiCd2Inw");
					return false;
				}else{
					//openSearchInvoiceInward();
					openSearchInvoiceInwardOverlay();
				}
			}		
		}		
	});

	//call modal search invoice
	/* function openSearchInvoiceInward(){
		Modalbox.show(contextPath+"/GIACInwFaculPremCollnsController?action=openSearchInvoiceModal&ajaxModal=1",  
				  {title: "Search Invoice", 
				  width: 915,
				  height: 505,
				  asynchronous: false});
	} */	
	
	//call overlay search invoice
	//added by steven 11.07.2013
	function openSearchInvoiceInwardOverlay(){
		try{
			overlaySearchInvoiceInward = Overlay.show(contextPath+"/GIACInwFaculPremCollnsController",
					{urlContent: true,
					 title: "Search Invoice", 
					 urlParameters: {
		                    action : "openSearchInvoiceModal",
		                    ajaxModal : "1"
		            },
					 height: 430,
					 width: 915,
					 draggable: false
					});
		}catch (e) {
			showErrorMessage("openSearchInvoiceInwardOverlay",e);
		}
	}

	//installment no
	$("instNoInw").observe("change",function(){
		var vMsgAlert = "";
		if(isNaN($F("instNoInw"))){
			vMsgAlert = "Entered Installment No. is invalid. Valid value is from 1 to 99.";
			promptInstNoMsg(vMsgAlert); //Deo [01.20.2017]: SR-5909
		} else if ($F("savedItemInw") != "Y"){
			if ($F("instNoInw") != "" && $F("b140PremSeqNoInw") != ""){
		/* 		vMsgAlert = validateInstNoInwFacul($F("instNoInw"),"Y");
			}
		}
		
		if (vMsgAlert == "" || vMsgAlert == null || vMsgAlert == "null"){
			defInstNo = $F("instNoInw"); //assign default installment number after validation of entered installment number by MAC 01/18/2013.
		}else{
			$("instNoInw").clear();
			$("instNoInw").value = defInstNo;
			customShowMessageBox(vMsgAlert, imgMessage.ERROR, "instNoInw");
			return false;
		}	
		enableOrDisbleItem(); */ //Deo [01.20.2017]: comment out, revise to avoid bypass (SR-5909)
		//Deo [01.20.2017]: add start (SR-5909)
				if (nvl(validateInstNoInwFacul($F("instNoInw"),"Y"), "*") != "*") {
					promptInstNoMsg($F("vldtInstNoMsg"));
				} else {
					checkClaim($F("b140IssCdInw"), $F("b140PremSeqNoInw"), $F("instNoInw"));
				}
			}
		}
		//Deo [01.20.2017]: add ends (SR-5909)
	});
	
	function promptInstNoMsg(vMsgAlert) { //Deo [01.20.2017]: SR-5909
		$("instNoInw").clear();
		$("instNoInw").value = defInstNo;
		customShowMessageBox(vMsgAlert, imgMessage.ERROR, "instNoInw");
	}
	
	//search icon installment no
	$("instNoInwDate").observe("click",function(){
		if ($F("savedItemInw") != "Y"){
			if ($F("transactionTypeInw") == ""){
				customShowMessageBox("Please select a transaction type first.", imgMessage.ERROR, "transactionTypeInw");
				return false;
			}else if ($F("b140IssCdInw") == ""){
				customShowMessageBox("Issue source is null.", imgMessage.ERROR, "b140IssCdInw");
				return false;	
			}else if ($F("transactionTypeInw") == "2" || $F("transactionTypeInw") == "4"){
				if ($F("a180RiCdInw") == ""){
					customShowMessageBox("Please select a cedant first.", imgMessage.ERROR, "a180RiCdInw");
					return false;
				}else if ($F("b140PremSeqNoInw") == ""){
					customShowMessageBox("Please select an invoice first.", imgMessage.ERROR, "b140PremSeqNoInw");
					return false;	
				}else{
					//openSearchInvoiceInward(); //openSearchInstNoInward(); replaced openSearchInstNoInward by openSearchInvoiceInward to show Invoice Overlay if Installment Number icon is pressed by MAC 03/05/2013.
					showGIACS008InstNoLOV(); //added by steve 11.06.2013
				}	
			}else if ($F("transactionTypeInw") == "1" || $F("transactionTypeInw") == "3"){
				if ($F("a180RiCd2Inw") == ""){
					customShowMessageBox("Please select a cedant first.", imgMessage.ERROR, "a180RiCd2Inw");
					return false;
				}else if ($F("b140PremSeqNoInw") == ""){
					customShowMessageBox("Please select an invoice first.", imgMessage.ERROR, "b140PremSeqNoInw");
					return false;
				}else{
					//openSearchInvoiceInward(); //openSearchInstNoInward(); replaced openSearchInstNoInward by openSearchInvoiceInward to show Invoice Overlay if Installment Number icon is pressed by MAC 03/05/2013.
					showGIACS008InstNoLOV();  //added by steve 11.06.2013
				}
			}		
		}			
	});	

	//call modal search installment no
	function openSearchInstNoInward(){
		Modalbox.show(contextPath+"/GIACInwFaculPremCollnsController?action=openSearchInstNoModal&ajaxModal=1",  
				  {title: "Search Installment No.", 
				  width: 400,
				  asynchronous: false});
	};	
	
	//collection amount
	var varCollecntionAmt = 0;
	$("collectionAmtInw").observe("focus", function () {
		varCollecntionAmt = formatCurrency($F("collectionAmtInw"));
		for(var i = 0; i < originalCollectionAmount.length; i++){ //set the correct default Collection amount of the selected bill by MAC 05/28/2013.
			if(originalCollectionAmount[i].a180RiCd == $F("a180RiCd2Inw")
				&& originalCollectionAmount[i].b140PremSeqNo == removeLeadingZero($F("b140PremSeqNoInw"))
				&& originalCollectionAmount[i].instNo == removeLeadingZero($F("instNoInw"))){
				$("defCollnAmtInw").value = originalCollectionAmount[i].defCollectionAmt; //change to defCollectionAmt by steven 11.06.2013
				break;
			}
		}
	});	
	
	$("collectionAmtInw").observe("change", function () {
		if ($F("instNoInw").blank() || $F("savedItemInw") == "Y"){
			return false;
		}	
		 if ($F("collectionAmtInw") == "0"){
			customShowMessageBox("Entered Collection Amount is invalid. Valid value is from -9,999,999,999.99 to 9,999,999,999.99.", imgMessage.ERROR, "collectionAmtInw");
			$("collectionAmtInw").value = varCollecntionAmt;
			return false;
		}else if ($F("transactionTypeInw") == "1" || $F("transactionTypeInw") == "4"){
			if (unformatCurrency("collectionAmtInw") < 0){
				customShowMessageBox("Please enter a positive amount for transaction type "+getListTextValue("transactionTypeInw")+".", imgMessage.ERROR, "collectionAmtInw");
				$("collectionAmtInw").value = varCollecntionAmt;
				return false;
			}	
		}else if ($F("transactionTypeInw") == "2" || $F("transactionTypeInw") == "3"){
			if (unformatCurrency("collectionAmtInw") > 0){
				customShowMessageBox("Please enter a negative amount for transaction type "+getListTextValue("transactionTypeInw")+".", imgMessage.ERROR, "collectionAmtInw");
				$("collectionAmtInw").value = varCollecntionAmt;
				return false;
			}
		}	
		 
		/* check for collection amount greater than default value. */
		if (Math.abs(unformatCurrency("collectionAmtInw")) > Math.abs(unformatCurrency("defCollnAmtInw"))){
			$("collectionAmtInw").value = varCollecntionAmt; 
			if ($F("transactionTypeInw") == "1" || $F("transactionTypeInw") == "4"){
				customShowMessageBox("Collection amount cannot be more than "+formatCurrency($F("defCollnAmtInw"))+".",imgMessage.ERROR, "collectionAmtInw");
			}else if ($F("transactionTypeInw") == "2" || $F("transactionTypeInw") == "3"){
				customShowMessageBox("Collection amount cannot be less than "+formatCurrency($F("defCollnAmtInw"))+".", imgMessage.ERROR, "collectionAmtInw");
			}
		}
		
		var collectionAmt = unformatCurrency("collectionAmtInw");
		var convertRate = unformatCurrency("convertRateInw"); 
		collectionAmt = collectionAmt == "" ? 0 :collectionAmt;
		convertRate = convertRate == "" ? 1 :convertRate;
		$("foreignCurrAmtInw").value = formatCurrency(Math.round((collectionAmt/convertRate)*100)/100);
		if ($F("taxAllocation") == "Y"){
			var vCollnPct = 0;
			vCollnPct = collectionAmt/unformatCurrency("variableSoaCollectionAmtInw");
			$("premiumAmtInw").value = formatCurrency(Math.round((unformatCurrency("variableSoaPremiumAmtInw") * vCollnPct)*100)/100);
			$("taxAmountInw").value  = formatCurrency(Math.round((unformatCurrency("variableSoaTaxAmountInw") * vCollnPct)*100)/100);
			$("commAmtInw").value    = formatCurrency(Math.round((unformatCurrency("variableSoaCommAmtInw") * vCollnPct)*100)/100);
			$("commVatInw").value    = formatCurrency(Math.round((unformatCurrency("variableSoaCommVatInw") * vCollnPct)*100)/100);	
		}else if ($F("taxAllocation") == "N"){
			//replaced unformatCurrency($F("collectionAmtInw")) with unformatCurrency("collectionAmtInw") to prevent error by MAC 01/17/2013.
			if (unformatCurrency("collectionAmtInw") == unformatCurrency("variableSoaCollectionAmtInw")){
				$("premiumAmtInw").value = formatCurrency(unformatCurrency("variableSoaPremiumAmtInw"));
				$("taxAmountInw").value  = formatCurrency(unformatCurrency("variableSoaTaxAmountInw"));
				$("commAmtInw").value    = formatCurrency(unformatCurrency("variableSoaCommAmtInw"));
				$("commVatInw").value    = formatCurrency(unformatCurrency("variableSoaCommVatInw"));	
			}else if (Math.abs(unformatCurrency("collectionAmtInw")) <= Math.abs(unformatCurrency("variableSoaTaxAmountInw"))){
				$("premiumAmtInw").value = "0.00";
				$("taxAmountInw").value  = formatCurrency(unformatCurrency("collectionAmtInw"));
				$("commAmtInw").value    = "0.00";
				$("commVatInw").value    = "0.00";
			}else{
				var vCommRt = 0;
				var vCommVatRt = 0;
				if (unformatCurrency("variableSoaPremiumAmtInw") != 0){
					vCommRt	= unformatCurrency("variableSoaCommAmtInw")/unformatCurrency("variableSoaPremiumAmtInw");
					if (vCommRt != 0){
						vCommVatRt = unformatCurrency("variableSoaCommVatInw")/unformatCurrency("variableSoaCommAmtInw");
					}
				}	
				$("taxAmountInw").value  = formatCurrency(unformatCurrency("variableSoaTaxAmountInw"));
				$("premiumAmtInw").value = formatCurrency(Math.round(((unformatCurrency("collectionAmtInw") - unformatCurrency("taxAmountInw")) / (1-vCommRt-(vCommRt*vCommVatRt)))*100)/100);
				$("commAmtInw").value	 = formatCurrency(Math.round((unformatCurrency("premiumAmtInw") * vCommRt)*100)/100);					          
				$("commVatInw").value	 = formatCurrency(Math.round((unformatCurrency("premiumAmtInw") * vCommRt * vCommVatRt)*100)/100);
			}			
		}
		if ((unformatCurrency("premiumAmtInw") + unformatCurrency("taxAmountInw") - unformatCurrency("commAmtInw") - unformatCurrency("commVatInw")) != unformatCurrency("collectionAmtInw")){
			//If there is a difference of .01 then add or subtract it to the premium_amt
			if (roundNumber(Math.abs(unformatCurrency("collectionAmtInw") - unformatCurrency("premiumAmtInw") - unformatCurrency("taxAmountInw") + unformatCurrency("commAmtInw") + unformatCurrency("commVatInw")),2) == 0.01){
				$("premiumAmtInw").value = formatCurrency(unformatCurrency("premiumAmtInw") + (unformatCurrency("collectionAmtInw") - unformatCurrency("premiumAmtInw") - unformatCurrency("taxAmountInw") + unformatCurrency("commAmtInw") + unformatCurrency("commVatInw")));
			}
		}
		if ($F("collectionAmtInw") != "" && $F("savedItemInw") != "Y"){
			enableButton("btnAddInw");
			if (objACGlobal.tranFlagState != 'O'){
				disableButton("btnAddInw");
			}
		}else{
			disableButton("btnAddInw");
		}		
	});

	//foreign currency amount
	var varForeignCurrAmt = 0;
	$("foreignCurrAmtInw").observe("focus", function () {
		varForeignCurrAmt = formatCurrency($F("foreignCurrAmtInw"));
	});	
	$("foreignCurrAmtInw").observe("change", function () {
		if ($F("instNoInw").blank() || $F("savedItemInw") == "Y"){
			return false;
		}
		if (unformatCurrency("foreignCurrAmtInw") == 0 || $F("foreignCurrAmtInw") == ""){
			customShowMessageBox("Invalid value. Amount cannot be null or equal to zero(0).", imgMessage.ERROR, "foreignCurrAmtInw");
			$("foreignCurrAmtInw").value = varForeignCurrAmt;
			return false;
		}else if (unformatCurrency("foreignCurrAmtInw") > 9999999999.99 || unformatCurrency("foreignCurrAmtInw") < -9999999999.99 || isNaN(parseFloat($F("foreignCurrAmtInw").replace(/,/g, "")))){
			customShowMessageBox("Entered Foreign Currency Amount is invalid. Valid value is from 9,999,999,999.99 to -9,999,999,999.99.", imgMessage.ERROR, "foreignCurrAmtInw");
			$("foreignCurrAmtInw").value = varForeignCurrAmt;
			return false;
		}else if ($F("transactionTypeInw") == "1" || $F("transactionTypeInw") == "4"){
			if (unformatCurrency("foreignCurrAmtInw") < 0){
				customShowMessageBox("Please enter a positive amount for transaction type "+getListTextValue("transactionTypeInw")+".", imgMessage.ERROR, "foreignCurrAmtInw");
				$("foreignCurrAmtInw").value = varForeignCurrAmt;
				return false;
			}	
		}else if ($F("transactionTypeInw") == "2" || $F("transactionTypeInw") == "3"){
			if (unformatCurrency("foreignCurrAmtInw") > 0){
				customShowMessageBox("Please enter a negative amount for transaction type "+getListTextValue("transactionTypeInw")+".", imgMessage.ERROR, "foreignCurrAmtInw");
				$("foreignCurrAmtInw").value = varForeignCurrAmt;
				return false;
			}
		}	

		/* check for collection amount greater than default value. */
		if (Math.abs(unformatCurrency("foreignCurrAmtInw")) > Math.abs(unformatCurrency("defForgnCurAmtInw"))){
			$("foreignCurrAmtInw").value = varForeignCurrAmt; 
			if ($F("transactionTypeInw") == "1" || $F("transactionTypeInw") == "4"){
				customShowMessageBox("Foreign currency amount cannot be more than "+formatCurrency($F("defForgnCurAmtInw"))+"." , imgMessage.ERROR, "foreignCurrAmtInw");
			}else if ($F("transactionTypeInw") == "2" || $F("transactionTypeInw") == "3"){
				customShowMessageBox("Foreign currency amount cannot be less than "+formatCurrency($F("defForgnCurAmtInw"))+"." , imgMessage.ERROR, "foreignCurrAmtInw");
			}
		}
		
		var foreignCurrAmt = unformatCurrency("foreignCurrAmtInw");
		var convertRate = unformatCurrency("convertRateInw"); 
		foreignCurrAmt = foreignCurrAmt == "" ? 0 :foreignCurrAmt;
		convertRate = convertRate == "" ? 1 :convertRate;
		$("collectionAmtInw").value = formatCurrency(Math.round((foreignCurrAmt*convertRate)*100)/100);

		if ($F("taxAllocation") == "Y"){
			var vCollnPct = 0;
			vCollnPct = unformatCurrency("collectionAmtInw")/unformatCurrency("variableSoaCollectionAmtInw");
			$("premiumAmtInw").value = formatCurrency(Math.round((unformatCurrency("variableSoaPremiumAmtInw") * vCollnPct)*100)/100);
			$("taxAmountInw").value  = formatCurrency(Math.round((unformatCurrency("variableSoaTaxAmountInw") * vCollnPct)*100)/100);
			$("commAmtInw").value    = formatCurrency(Math.round((unformatCurrency("variableSoaCommAmtInw") * vCollnPct)*100)/100);
			$("commVatInw").value    = formatCurrency(Math.round((unformatCurrency("variableSoaCommVatInw") * vCollnPct)*100)/100);	
		}else if ($F("taxAllocation") == "N"){
			if (unformatCurrency($F("collectionAmtInw")) == unformatCurrency("variableSoaCollectionAmtInw")){
				$("premiumAmtInw").value = formatCurrency(unformatCurrency("variableSoaPremiumAmtInw"));
				$("taxAmountInw").value  = formatCurrency(unformatCurrency("variableSoaTaxAmountInw"));
				$("commAmtInw").value    = formatCurrency(unformatCurrency("variableSoaCommAmtInw"));
				$("commVatInw").value    = formatCurrency(unformatCurrency("variableSoaCommVatInw"));	
			}else if (Math.abs(unformatCurrency("collectionAmtInw")) <= Math.abs(unformatCurrency("variableSoaTaxAmountInw"))){
				$("premiumAmtInw").value = "0.00";
				$("taxAmountInw").value  = formatCurrency(unformatCurrency("collectionAmtInw"));
				$("commAmtInw").value    = "0.00";
				$("commVatInw").value    = "0.00";
			}else{
				var vCommRt = 0;
				var vCommVatRt = 0;
				if (unformatCurrency("variableSoaPremiumAmtInw") != 0){
					vCommRt	= unformatCurrency("variableSoaCommAmtInw")/unformatCurrency("variableSoaPremiumAmtInw");
					if (vCommRt != 0){
						vCommVatRt = unformatCurrency("variableSoaCommVatInw")/unformatCurrency("variableSoaCommAmtInw");
					}
				}	
				$("taxAmountInw").value  = formatCurrency(unformatCurrency("variableSoaTaxAmountInw"));
				$("premiumAmtInw").value = formatCurrency(Math.round(((unformatCurrency("collectionAmtInw") - unformatCurrency("taxAmountInw")) / (1-vCommRt-(vCommRt*vCommVatRt)))*100)/100);
				$("commAmtInw").value	 = formatCurrency(Math.round((unformatCurrency("premiumAmtInw") * vCommRt)*100)/100);					          
				$("commVatInw").value	 = formatCurrency(Math.round((unformatCurrency("premiumAmtInw") * vCommRt * vCommVatRt)*100)/100);
			}			
		}
		if ((unformatCurrency("premiumAmtInw") + unformatCurrency("taxAmountInw") - unformatCurrency("commAmtInw") - unformatCurrency("commVatInw")) != unformatCurrency("collectionAmtInw")){
			//If there is a difference of .01 then add or subtract it to the premium_amt
			if (Math.abs(unformatCurrency("collectionAmtInw") - unformatCurrency("premiumAmtInw") - unformatCurrency("taxAmountInw") + unformatCurrency("commAmtInw") + unformatCurrency("commVatInw")) == 0.01){
				$("premiumAmtInw").value = formatCurrency(unformatCurrency("premiumAmtInw") + (unformatCurrency("collectionAmtInw") - unformatCurrency("premiumAmtInw") - unformatCurrency("taxAmountInw") + unformatCurrency("commAmtInw") + unformatCurrency("commVatInw")));
			}
		}
		if ($F("collectionAmtInw") != "" && $F("savedItemInw") != "Y"){
			enableButton("btnAddInw");
			if (objACGlobal.tranFlagState != 'O'){
				disableButton("btnAddInw");
			}
		}else{
			disableButton("btnAddInw");
		}		
	});

	//add record observe
	$("btnAddInw").observe("click", function() {
		addInwardFacul();
	});
	

	//add record function
	function addInwardFacul() {	
		try	{
			if (objAC.hidObjAC008.hidUpdateable == "N"){
				return false;
			}
			var exists = false;
			if ($F("instNoInw") != "" && $F("b140PremSeqNoInw") != ""){
				var vMsgAlert = validateInstNoInwFacul($F("instNoInw"),"N");
				if (vMsgAlert == "" || vMsgAlert == null || vMsgAlert == "null"){
					null;
				}else{
					$("instNoInw").clear();
					customShowMessageBox(vMsgAlert, imgMessage.ERROR, "instNoInw");
					exists = true;
					return false;
				}	
			}
			
			var newObj = setCollnObject();
			if (newObj.transactionType == "") {
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR , "transactionTypeInw");
				exists = true;
			}else if (newObj.gaccTranId == "") {
				customShowMessageBox("Transaction Id is null.", imgMessage.ERROR , "transactionTypeInw");
				exists = true;
			}else if (newObj.a180RiCd == "") {
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "a180RiCdInw");
				exists = true;
			}else if (newObj.b140PremSeqNo == "") {
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "b140PremSeqNoInw");
				exists = true;
			}else if (newObj.instNo == "") {
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "instNoInw");
				$("instNoInw").value = defInstNo; //set default value
				exists = true;
			}else if (newObj.collectionAmt == null || newObj.collectionAmt == "") {
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "collectionAmtInw");
				$("collectionAmtInw").value = varCollecntionAmt;
				exists = true;
			//}else if (parseInt(newObj.collectionAmt) == 0 || parseInt(newObj.collectionAmt) > 9999999999.99 || parseInt(newObj.collectionAmt) <  -9999999999.99  ) { 
			}else if (parseFloat(newObj.collectionAmt) == 0 || parseFloat(newObj.collectionAmt) > 9999999999.99 || parseFloat(newObj.collectionAmt) <  -9999999999.99  ) { //lara 3/21/2014	
				customShowMessageBox("Entered Collection Amount is invalid. Valid value is from -9,999,999,999.99 to 9,999,999,999.99.", imgMessage.ERROR, "collectionAmtInw");
				$("collectionAmtInw").value = varCollecntionAmt;
				exists = true;
			}
			
			for(var i = 0; i < objInwFaculPremCollns.length; i++){
				var obj = objInwFaculPremCollns[i];
				if(//obj.transactionType == newObj.transactionType //removed condition for transaction type to disallow entry of same bill number with different tran type by MAC 01/18/2013.
						obj.a180RiCd == newObj.a180RiCd
						&& obj.b140IssCd == newObj.b140IssCd 
						&& obj.b140PremSeqNo == newObj.b140PremSeqNo
						&& obj.instNo == newObj.instNo
						&& $F("btnAddInw") != "Update"
						&& obj.recordStatus != null){ //check only record that is either added, updated, or deleted by MAC 01/04/2012
					exists = true;
					showMessageBox("Record already exists!", imgMessage.ERROR);
					populateCollnsDetails(null);
					
				}
			} 

			if (!exists){
				if ($F("btnAddInw") == "Add") {
					originalCollectionAmount.push(newObj); //collect all newly inserted bill by MAC 05/28/2013.
					newObj.recordStatus = 0;
					newObj.savedItems = "N";
			 		computeTotalAmountInTable(newObj.collectionAmt, newObj.premiumAmt, newObj.taxAmount, newObj.commAmt, unformatCurrencyValue(newObj.commVat)); //lara 3/21/2014
					objInwFaculPremCollns.push(newObj);
					inwFaculPremCollnsTableGrid.addBottomRow(newObj);
					addedRecord.push(newObj.b140PremSeqNo+"-"+newObj.instNo); //collect all added record by MAC 01/04/2013
					
				} else {
					for(var i = 0; i < objInwFaculPremCollns.length; i++){
						if(newObj.b140IssCd == objInwFaculPremCollns[i].b140IssCd
							&& newObj.a180RiCd == objInwFaculPremCollns[i].a180RiCd
							&& newObj.b140PremSeqNo == objInwFaculPremCollns[i].b140PremSeqNo
							&& newObj.transactionType == objInwFaculPremCollns[i].transactionType
							&& newObj.instNo == objInwFaculPremCollns[i].instNo
							&& newObj.recordStatus != -1){
							newObj.recordStatus = 1;
							newObj.savedItems = "N";
							computeTotalAmountInTable(parseFloat(newObj.collectionAmt)-parseFloat(objInwFaculPremCollns[i].collectionAmt), //lara 3/21/2014
									parseFloat(newObj.premiumAmt)-parseFloat(objInwFaculPremCollns[i].premiumAmt),
									parseFloat(newObj.taxAmount)-parseFloat(objInwFaculPremCollns[i].taxAmount),
									parseFloat(newObj.commAmt)-parseFloat(objInwFaculPremCollns[i].commAmt),
									parseFloat(newObj.commVat)-parseFloat(objInwFaculPremCollns[i].commVat));
							objInwFaculPremCollns.splice(i, 1, newObj);
							inwFaculPremCollnsTableGrid.updateVisibleRowOnly(newObj, inwFaculPremCollnsTableGrid.getCurrentPosition()[1]);
						}
					}
				}
				changeTag = 1;
				populateCollnsDetails(null);
				if($("btnSaveInwFacul").disabled = "disabled"){
					enableButton("btnSaveInwFacul");
				}
				enableBtnUpd(true); //Deo [01.20.2017]: SR-5909
			}
		} catch (e)	{
			showErrorMessage("addInwardFacul", e);
		}
	}
	objAC.hidObjAC008.addInwardFaculFunc = addInwardFacul;

	//delete record observe
	$("btnDeleteInw").observe("click", function() {
		deleteInwardFacul();
	});

	//delete record function
	function deleteInwardFacul(){
		var delObj = setCollnObject();
		validateDelete(delObj);
		
		/*try{ //get other records in GIAC_INWFACUL_PREM_COLLNS table based on RI code, Issue Code, Prem Seq No, and Installment Number by MAC 01/18/2013.
			new Ajax.Request(contextPath+"/GIACInwFaculPremCollnsController?action=getOtherInwPremCollnsList", {
				method: "POST",
				asynchronous: true,
				parameters:{
					a180RiCd: $F("a180RiCdInw"),
					b140IssCd: $F("b140IssCdInw"),
					b140PremSeqNo: $F("b140PremSeqNoInw"),
				    instNo: $F("instNoInw")
				},
				asynchronous : false,
				evalScripts : true,
				onComplete: function(response){
					
				}
			});
		} catch(e){
			showErrorMessage("deleteInwardFacul()", e);
		}*/
		
		//for tran type w/ existing refund transaction
		/*for (var a = 0; a < otherInwPremCollnsList.length; a++) {
			if(delObj.transactionType == '1' 
				&& otherInwPremCollnsList[a].transactionType == '2' 
				&& otherInwPremCollnsList[a].b140PremSeqNo == delObj.b140PremSeqNo
				&& otherInwPremCollnsList[a].b140IssCd == delObj.b140IssCd
				&& (otherInwPremCollnsList[a].revGaccTranId == delObj.gaccTranId || nvl(otherInwPremCollnsList[a].revGaccTranId, "") == "")
				){
					 showMessageBox("Delete not allowed. A refund transaction exists for this record.", imgMessage.ERROR);
					 return false;
			} else if(delObj.transactionType == '3' 
				&& otherInwPremCollnsList[a].transactionType == '4' 
				&& otherInwPremCollnsList[a].b140PremSeqNo == delObj.b140PremSeqNo
				&& otherInwPremCollnsList[a].b140IssCd == delObj.b140IssCd
				&& (otherInwPremCollnsList[a].revGaccTranId == delObj.gaccTranId || nvl(otherInwPremCollnsList[a].revGaccTranId, "") == "")
				){
					 showMessageBox("Delete not allowed. A refund transaction exists for this record.", imgMessage.ERROR);
					 return false;
			}
		}
		
		if(delObj.orPrintTag == 'Y'){
			showMessageBox("Delete not allowed. This record was created before the OR was printed.", imgMessage.ERROR);
			return false;
		} else{
			delete confirmation message upon deletion of record by MAC 01/17/2013
			showConfirmBox(
					"Delete Inward Facultative Premium Collection",
					"Are you sure you want to delete record?",
					"OK",
					"Cancel",
					function() {
						for(var i = 0; i < objInwFaculPremCollns.length; i++){
							if(delObj.b140IssCd == objInwFaculPremCollns[i].b140IssCd
								&& delObj.a180RiCd == objInwFaculPremCollns[i].a180RiCd
								&& delObj.b140PremSeqNo == objInwFaculPremCollns[i].b140PremSeqNo
								&& delObj.transactionType == objInwFaculPremCollns[i].transactionType
								&& delObj.instNo == objInwFaculPremCollns[i].instNo
								&& delObj.recordStatus != -1){
								delObj.recordStatus = -1;
								computeTotalAmountInTable(-1*parseFloat(delObj.collectionAmt), //lara 3/21/2014
										-1*parseFloat(delObj.premiumAmt),
										-1*parseFloat(delObj.taxAmount),
										-1*parseFloat(delObj.commAmt),
										-1*parseFloat(delObj.commVat));
								//added checking that will update record status of the deleted object to null when record is not yet saved on the database by MAC 01/04/2013
								for (var ii=0; ii<addedRecord.length; ii++){
									if (delObj.b140PremSeqNo+"-"+delObj.instNo == addedRecord[ii]){
										delObj.recordStatus = null;
									}
								}
								delObj.savedItems = "N";
								objInwFaculPremCollns.splice(i, 1, delObj); 
								inwFaculPremCollnsTableGrid.deleteVisibleRowOnly(inwFaculPremCollnsTableGrid.getCurrentPosition()[1]);
								
								changeTag = 1;
								if($("btnSaveInwFacul").disabled = "disabled"){
									enableButton("btnSaveInwFacul");
								}
							}
						}
					//computeTotalAmountInTable(); //lara 3/21/2014
					//}); comment out by MAC 01/17/2013
		}
		populateCollnsDetails(null);*/
	}
	//get the default value
	function getDefaults()	{
		$("btnAddInw").value = "Update";
		enableButton("btnDeleteInw");
	}

	//to get the correct reinsurer LOV based on the transaction type
	function getReinsurerLOV(riCd){
		if ($F("transactionTypeInw") == "2" || $F("transactionTypeInw") == "4"){
			$("a180RiCdInw").show();
			$("a180RiCd2Inw").hide();
			$("a180RiCdInw").selectedIndex = 0;
			filterReinsurerLOV(riCd);
			$("a180RiCdInw").enable();
			$("cedantInwReadOnly").value = getListTextValue("a180RiCdInw");
		}else{
			$("a180RiCdInw").hide();
			$("a180RiCd2Inw").show();
			$("a180RiCd2Inw").selectedIndex = 0;
			$("a180RiCd2Inw").value = riCd;
			$("a180RiCd2Inw").enable();	
			$("cedantInwReadOnly").value = getListTextValue("a180RiCd2Inw");
		}	
	}	

	//to filter the reinsurer LOV based on the transaction type
	function filterReinsurerLOV(riCd){
		removeAllOptions($("a180RiCdInw"));
		var opt = document.createElement("option");
		opt.value = "";
		opt.text = "";
		opt.setAttribute("transactiontype", ""); 
		$("a180RiCdInw").options.add(opt);
		for(var a=0; a<a180RiCdInwObjLOV.length; a++){
			var globalTrType = $F("transactionTypeInw");
			if ($F("transactionTypeInw") == "2"){
				globalTrType = "1";
			}else if ($F("transactionTypeInw") == "4"){
				globalTrType = "3";
			}		
			if (a180RiCdInwObjLOV[a].transactionType == globalTrType){
				var opt = document.createElement("option");
				opt.value = a180RiCdInwObjLOV[a].riCd;
				opt.text = unescapeHTML2(a180RiCdInwObjLOV[a].riName); //added unescapeHTML2 by robert 11.06.2013
				opt.setAttribute("transactiontype", a180RiCdInwObjLOV[a].transactionType); 
				$("a180RiCdInw").options.add(opt);
			}	
		}	
		$("a180RiCdInw").value = riCd;
	}	

	//enable or disble the item
	function enableOrDisbleItem(){
		if ($F("savedItemInw") == "Y"){
			$("transactionTypeInw").disable();
			$("a180RiCdInw").disable();
			$("a180RiCd2Inw").disable(); 
			$("b140PremSeqNoInw").readOnly = true;
			$("instNoInw").readOnly = true;
			$("collectionAmtInw").readOnly = true;
			$("foreignCurrAmtInw").readOnly = true;
			$("particularsInw").readOnly = true;
			disableButton("btnAddInw");
			$("transactionTypeInwReadOnly").show();
			$("transactionTypeInw").hide();
			$("cedantInwReadOnly").show();
			$("a180RiCdInw").hide();
			$("a180RiCd2Inw").hide(); 
			$("invoiceInwDate").hide();
			$("instNoInwDate").hide();
			objAC.hidObjAC008.hidUpdateable = "N";
		}else{
			$("transactionTypeInw").enable();
			$("transactionTypeInw").show();
			$("transactionTypeInwReadOnly").hide();
			$("cedantInwReadOnly").hide();
			$("invoiceInwDate").show();
			$("instNoInwDate").show();
			objAC.hidObjAC008.hidUpdateable = "Y";
			if ($F("transactionTypeInw").blank()){
				$("a180RiCdInw").disable();
				$("a180RiCd2Inw").disable();
				$("b140PremSeqNoInw").readOnly = true;
				$("instNoInw").readOnly = true;
				$("collectionAmtInw").readOnly = true;
				$("foreignCurrAmtInw").readOnly = true;
				$("particularsInw").readOnly = true; // false before
			}else if ($F("transactionTypeInw") == "1" || $F("transactionTypeInw") == "2" || $F("transactionTypeInw") == "3" || $F("transactionTypeInw") == "4"){
				$("a180RiCdInw").enable();
				$("a180RiCd2Inw").enable(); 
				enableButton("btnAddInw");
				if ($F("transactionTypeInw") == "2" || $F("transactionTypeInw") == "4"){
					if ($F("a180RiCdInw").blank()){ 
						$("b140PremSeqNoInw").readOnly = true;
						$("instNoInw").readOnly = true;
						$("collectionAmtInw").readOnly = true;
						$("foreignCurrAmtInw").readOnly = true;
						$("particularsInw").readOnly = false;
						disableButton("btnInvoiceInw"); //disable Invoice button if Cedant is null by MAC 03/06/2013.
					}else{
						$("b140PremSeqNoInw").readOnly = false;
						enableButton("btnInvoiceInw"); //enable Invoice button if Cedant is not null by MAC 03/06/2013.
					}
	
					if ($F("b140PremSeqNoInw").blank()){
						$("instNoInw").readOnly = true;
						$("collectionAmtInw").readOnly = true;
						$("foreignCurrAmtInw").readOnly = true;
						$("particularsInw").readOnly = false;
					}else{
						$("instNoInw").readOnly = false;
						$("collectionAmtInw").readOnly = false;
						$("foreignCurrAmtInw").readOnly = false;
						$("particularsInw").readOnly = false;
					}
					//set collection amount and foreign currency to uneditable if tran type 2 or 4 regardless of the value of installment number by MAC 03/06/2013.
					//$("collectionAmtInw").readOnly = true; //comment-out by steven 11.06.2013;this is base on the test case.
					$("foreignCurrAmtInw").readOnly = true;
					/*
					if ($F("instNoInw").blank()){
						$("collectionAmtInw").readOnly = true;
						$("foreignCurrAmtInw").readOnly = true;
					}else{
						$("collectionAmtInw").readOnly = false;
						$("foreignCurrAmtInw").readOnly = false;
					}*/
				}else{
					if ($F("a180RiCd2Inw").blank()){ 
						$("b140PremSeqNoInw").readOnly = true;
						$("instNoInw").readOnly = true;
						$("collectionAmtInw").readOnly = true;
						$("foreignCurrAmtInw").readOnly = true;
						$("particularsInw").readOnly = false;
						disableButton("btnInvoiceInw"); //disable Invoice button if Cedant is null by MAC 03/06/2013.
					}else{
						$("b140PremSeqNoInw").readOnly = false;
						enableButton("btnInvoiceInw"); //enable Invoice button if Cedant is not null by MAC 03/06/2013.
					}
	
					if ($F("b140PremSeqNoInw").blank()){
						$("instNoInw").readOnly = true;
						$("collectionAmtInw").readOnly = true;
						$("foreignCurrAmtInw").readOnly = true;
						$("particularsInw").readOnly = false;
					}else{
						$("instNoInw").readOnly = false;
						$("collectionAmtInw").readOnly = false;
						$("foreignCurrAmtInw").readOnly = false;
						$("particularsInw").readOnly = false;
					}

					if ($F("instNoInw").blank()){
						$("collectionAmtInw").readOnly = true;
						$("foreignCurrAmtInw").readOnly = true;
					}else{
						$("collectionAmtInw").readOnly = false;
						$("foreignCurrAmtInw").readOnly = false;
					}		
				}			
			}
		}
		if(objACGlobal.tranFlagState == 'C' || objACGlobal.tranFlagState == 'D'){
			disableButton("btnAddInw");
			disableButton("btnDeleteInw");
			disableButton("btnInvoiceInw"); //disable button is tran flag is either C or D by MAC 03/06/2013.
			$("transactionTypeInw").disable();
			$("invoiceInwDate").hide();
			$("instNoInwDate").hide();
		}
	}	

	//compute the total amount in table		
	function computeTotalAmountInTable(collectionAmt, premiumAmt, taxAmount, commAmt, commVat) {//lara 3/21/2014
		try {
			var tot1=unformatCurrency("txtTotalCollAmt");
			var tot2=unformatCurrency("txtTotalPremAmt");
			var tot3=unformatCurrency("txtTotalTaxAmt");
			var tot4=unformatCurrency("txtTotalCommAmt");
			var tot5=unformatCurrency("txtTotalCommVat");
			
			tot1 =parseFloat(tot1) + (parseFloat(collectionAmt));
			tot2 =parseFloat(tot2) + (parseFloat(premiumAmt));
			tot3 =parseFloat(tot3) + (parseFloat(taxAmount));
			tot4 =parseFloat(tot4) + (parseFloat(commAmt));
			tot5 =parseFloat(tot5) + (parseFloat(commVat));
	
			$("txtTotalCollAmt").value = formatCurrency(tot1).truncate(13, "...");
			$("txtTotalPremAmt").value = formatCurrency(tot2).truncate(13, "...");
			$("txtTotalTaxAmt").value = formatCurrency(tot3).truncate(13, "...");
			$("txtTotalCommAmt").value = formatCurrency(tot4).truncate(13, "...");
			$("txtTotalCommVat").value = formatCurrency(tot5).truncate(13, "...");
		} catch (e) {
			showErrorMessage("computeTotalAmountInTable", e);
		}
	}

	//for currency DIV
	$("btnCurrencyInfoInw").observe("click", function() {
		$("breakdownInwDiv").hide();
		if ($("currencyInwDiv").getStyle("display") == "none"){
			Effect.Appear($("currencyInwDiv"), {
				duration: .2
			});
		}else{
			Effect.Fade($("currencyInwDiv"), {
				duration: .2
			});
		}	
	});
	$("btnHideCurrInwDiv").observe("click", function() {
		Effect.Fade($("currencyInwDiv"), {
			duration: .2
		});
	});

	//for breakdown DIV
	$("btnBreakDownInw").observe("click", function() {
		$("currencyInwDiv").hide();
		if ($("breakdownInwDiv").getStyle("display") == "none"){
			Effect.Appear($("breakdownInwDiv"), {
				duration: .2
			});
		}else{
			Effect.Fade($("breakdownInwDiv"), {
				duration: .2
			});
		}	
	});
	$("btnHideBreakdownInwDiv").observe("click", function() {
		Effect.Fade($("breakdownInwDiv"), {
			duration: .2
		});
	});

	function saveGIPIS008(){
		if(!checkAcctRecordStatus(objACGlobal.gaccTranId, "GIACS008")){ //marco - SR-5720 - 11.04.2016
			return;
		}
		
		var objParameters = new Object();
		objParameters.setParams = getAddedAndModifiedJSONObjects(objInwFaculPremCollns);
		objParameters.delParams  = getDeletedJSONObjects(objInwFaculPremCollns);
		
		try{
			new Ajax.Request(contextPath + "/GIACInwFaculPremCollnsController?action=saveInwardFacul2", {
				method: "POST",
				parameters : {
					params: JSON.stringify(objParameters),
					globalGaccTranId: objACGlobal.gaccTranId,
					globalGaccBranchCd: objACGlobal.branchCd,
					globalGaccFundCd: objACGlobal.fundCd,
					globalTranSource: objACGlobal.tranSource,
					globalOrFlag: objACGlobal.orFlag
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : function() {
					showNotice("Saving. Please wait...");
				},
				onComplete : function(response) {
					hideNotice("");
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						if (response.responseText == "SUCCESS"){
							showMessageBox(objCommonMessage.SUCCESS,imgMessage.SUCCESS);
							updateInwFaculTableRecords();
							populateCollnsDetails(null);
							changeTag = 0;
							addedRecord = []; //reset value of addedRecord after saving by MAC 01/04/2013
							originalCollectionAmount = []; //reset value of originalCollectionAmount after saving by MAC 05/28/2013
							inwFaculPremCollnsTableGrid.refresh(); //refresh tablegrid after saving by MAC 03/06/2013.
							objAC.giacs008AllowClm = "N"; //Deo [01.20.2017]: SR-5909
							objAC.giacs008AllowOvrDue = "N"; //Deo [01.20.2017]: SR-5909
						}else{
							showMessageBox(response.responseText,imgMessage.ERROR);
						} 
					}else{
						showMessageBox(response.responseText,imgMessage.ERROR);
					}	
				}
			});
		}catch(e){
			showErrorMessage("saveGIPIS008()",e);
		}
	}	

	observeCancelForm("btnCancelInwFacul", saveGIPIS008, function(){
		if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
			showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
		}else if(objACGlobal.previousModule == "GIACS002"){
			showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
			objACGlobal.previousModule = null;
		}else if(objACGlobal.previousModule == "GIACS003"){
			if (objACGlobal.hidObjGIACS003.isCancelJV == 'Y'){
				showJournalListing("showJournalEntries","getCancelJV","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
			}else{
				showJournalListing("showJournalEntries","getJournalEntries","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
			}
			objACGlobal.previousModule = null;							
		}else if(objACGlobal.previousModule == "GIACS071"){
			updateMemoInformation(objGIAC071.cancelFlag, objACGlobal.branchCd, objACGlobal.fundCd);
			objACGlobal.previousModule = null;
		}else if(objACGlobal.previousModule == "GIACS149"){	//added by shan 08.08.2013
			showGIACS149Page(objGIACS149.intmNo, objGIACS149.gfunFundCd, objGIACS149.gibrBranchCd, objGIACS149.fromDate, objGIACS149.toDate, null);
			objACGlobal.previousModule = null;
		}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
			showGIACS070Page();
			objACGlobal.previousModule = null;
		}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
			$("giacs031MainDiv").hide();
			$("giacs032MainDiv").show();
			$("mainNav").hide();
		}else{
			editORInformation();	
		}
	});
	
	//on SAVE button click
	observeSaveForm("btnSaveInwFacul", saveGIPIS008);
	
	$("acExit").stopObserving("click"); // copy from quotationCarrierInfo.jsp
	$("acExit").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveGIPIS008();
						if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
							showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
						}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
							showGIACS070Page();
							objACGlobal.previousModule = null;
						}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
							$("giacs031MainDiv").hide();
							$("giacs032MainDiv").show();
							$("mainNav").hide();
						}else{
							editORInformation();	
						}
					}, function(){
						if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
							showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
						}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
							showGIACS070Page();
							objACGlobal.previousModule = null;
						}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
							$("giacs031MainDiv").hide();
							$("giacs032MainDiv").show();
							$("mainNav").hide();
						}else{
							editORInformation();	
							
						}
						changeTag = 0;
					}, "");
		}else{
			if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
				showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
			}else if(objACGlobal.previousModule == "GIACS002"){
				showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS003"){
				if (objACGlobal.hidObjGIACS003.isCancelJV == 'Y'){
					showJournalListing("showJournalEntries","getCancelJV","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
				}else{
					showJournalListing("showJournalEntries","getJournalEntries","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
				}
				objACGlobal.previousModule = null;							
			}else if(objACGlobal.previousModule == "GIACS071"){
				updateMemoInformation(objGIAC071.cancelFlag, objACGlobal.branchCd, objACGlobal.fundCd);
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
				showGIACS070Page();
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
				$("giacs031MainDiv").hide();
				$("giacs032MainDiv").show();
				$("mainNav").hide();
			}else{
				editORInformation();	
			}
		}
	});

	//when save success update the saveitem variable in each record to Y then remove all deleted records
	function updateInwFaculTableRecords(){
		for (var a = 0; a < objInwFaculPremCollns.length; a++) {
			objInwFaculPremCollns[a].savedItems = "Y";
			
			if(objInwFaculPremCollns[a].recordStatus == -1){
				delete objInwFaculPremCollns[a];
			}else{
				objInwFaculPremCollns[a].recordStatus = null;
			}
		}
	}	
	
	populateCollnsDetails(null);
	$("b140PremSeqNoInw").setStyle("text-align:left;");
	$("instNoInw").setStyle("text-align:left;");
	changeTag = 0; 
	setDocumentTitle("Inward Facultative Premium Collections");
	window.scrollTo(0,0); 	
	hideNotice("");
	
	//disable fields if calling form is Cancel OR : 08-14-2012 Christian 
	function disableGIACS008(){
		var divArray = ["inwardFaculButtonsDiv", "inwardFaculPremCollnsDiv"];
		disableCancelORFields(divArray);
		$("insNoDiv").style.backgroundColor = "#ECE9D8";
		$("invNoDiv").style.backgroundColor = "#ECE9D8";
		$("transactionTypeInwReadOnly").show();
		$("transactionTypeInw").hide();
		$("cedantInwReadOnly").show();
		$("a180RiCdInw").hide();
		$("a180RiCd2Inw").hide();
	}
	
	if(objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y"){
		disableGIACS008();
	} else {
		initializeChangeTagBehavior(saveGIPIS008);
		initializeChangeAttribute();
	}
	//display LOV of Invoice Number if Invoice button is clicked by MAC 03/06/2013
	$("btnInvoiceInw").observe("click", function() {
		fireEvent($("invoiceInwDate"),"click");
	});
	
	//added john 11.3.2014
	function checkPremPaytForRiSpecial(b140PremSeqNoInw){
		try{
			var a180RiCd;
			if ($("transactionTypeInw").value == "2" || $("transactionTypeInw").value == "4"){
				a180RiCd = $("a180RiCdInw").value;
			}else{
				a180RiCd = $("a180RiCd2Inw").value;
			}
			new Ajax.Request(contextPath+'/GIACInwFaculPremCollnsController?action=checkPremPaytForRiSpecial', {
				parameters: {
					a180RiCd: a180RiCd,
					b140IssCd: $("b140IssCdInw").value,
					transactionType: $("transactionTypeInw").value,
					b140PremSeqNoInw: b140PremSeqNoInw
				},
				asynchronous:false,
				evalScripts:true,
				onCreate: function(){
					showNotice("Validating Invoice, please wait...");	
				},	
				onComplete: function(response){
					hideNotice("");
					msgAlert = response.responseText;
					if(msgAlert == "") {
						checkPremPaytForCancelled(b140PremSeqNoInw);
					} else if(msgAlert == "This is a Special Policy.") {
						showWaitingMessageBox(msgAlert, imgMessage.INFO, function(){
							checkPremPaytForCancelled(b140PremSeqNoInw);
						});
					} else {
						showWaitingMessageBox(msgAlert, imgMessage.ERROR, function(){
							$("b140PremSeqNoInw").clear();
							$("b140PremSeqNoInw").value = lastAcceptedInvoiceValue == "" ? "" : formatNumberDigits(lastAcceptedInvoiceValue,8);
							return false;
						});
					}
				}
			});
		}catch(e){
			showErrorMessage ("checkPremPaytForRiSpecial",e);
		}
	}
	
	//added john 11.4.2014
	function checkPremPaytForCancelled(b140PremSeqNoInw){
		try{
			var a180RiCd;
			if ($("transactionTypeInw").value == "2" || $("transactionTypeInw").value == "4"){
				a180RiCd = $("a180RiCdInw").value;
			}else{
				a180RiCd = $("a180RiCd2Inw").value;
			}
			new Ajax.Request(contextPath+'/GIACInwFaculPremCollnsController?action=checkPremPaytForCancelled', {
				parameters: {
					a180RiCd: a180RiCd,
					b140IssCd: $("b140IssCdInw").value,
					b140PremSeqNoInw: b140PremSeqNoInw
				},
				asynchronous:false,
				evalScripts:true,
				onCreate: function(){
					showNotice("Validating Invoice, please wait...");	
				},	
				onComplete: function(response){
					hideNotice("");
					msgAlert = response.responseText;
					if(msgAlert == ""){
						var arr = arrValidate;//validateInvoiceInwFacul2($F("b140PremSeqNoInw"));
						vMsgAlert = arr[0];
						hideNotice();
						if (vMsgAlert == "" ||  vMsgAlert == null){
							$("b140PremSeqNoInw").value = $F("b140PremSeqNoInw") == "" ? "" :formatNumberDigits($F("b140PremSeqNoInw"),8);
							$("assuredNameInw").value = arr[1];
							$("policyNoInw").value = arr[4];
							$("assdNoInw").value = arr[3];
							lastAcceptedInvoiceValue = $F("b140PremSeqNoInw");
							$("b140PremSeqNoInw").setAttribute("lastValidValue", lastAcceptedInvoiceValue);
							$("instNoInw").enable();
							$("instNoInw").focus();
							
							defInstNo = ""; //added by steve 11.06.2013
							$("instNoInw").clear();
							$("collectionAmtInw").clear();
						}else{
							$("b140PremSeqNoInw").clear();
							$("b140PremSeqNoInw").value = lastAcceptedInvoiceValue == "" ? "" : formatNumberDigits(lastAcceptedInvoiceValue,8);
							customShowMessageBox(vMsgAlert, imgMessage.ERROR, "b140PremSeqNoInw");
							return false;
						}
					} else if (msgAlert == "N"){
						showMessageBox("This is a cancelled policy.", imgMessage.ERROR);
						$("b140PremSeqNoInw").clear();
						$("b140PremSeqNoInw").value = lastAcceptedInvoiceValue == "" ? "" : formatNumberDigits(lastAcceptedInvoiceValue,8);
						return false;
					} else {
						arr = msgAlert.split(",");
						showConfirmBox("CONFIRMATION", "The policy of " + $("b140IssCdInw").value + "-" + b140PremSeqNoInw + "" +  " is already cancelled. Would you like to continue processing the payment?",
								"Yes", "No",function() {
								if (arr[1] == "N"){
									showConfirmBox("CONFIRMATION", "User is not allowed to process payment of bill with cancelled policy. Would you like to override?",
											"Yes", "No",function() {
													showGenericOverride("GIACS008", "AP",
															function(ovr, userId, result){
																if(result == "FALSE"){
																	showMessageBox(userId + " is not allowed to process payment of bill with cancelled policy.", imgMessage.ERROR);
																	$("txtOverrideUserName").clear();
																	$("txtOverridePassword").clear();
																	return false;
																}else if(result == "TRUE"){
																	ovr.close();
																	delete ovr;
																	var arr = validateInvoiceInwFacul2($F("b140PremSeqNoInw"));
																	vMsgAlert = arr[0];
																	hideNotice();
																	if (vMsgAlert == "" ||  vMsgAlert == null){
																		$("b140PremSeqNoInw").value = $F("b140PremSeqNoInw") == "" ? "" :formatNumberDigits($F("b140PremSeqNoInw"),8);
																		$("assuredNameInw").value = arr[1];
																		$("policyNoInw").value = arr[4];
																		$("assdNoInw").value = arr[3];
																		lastAcceptedInvoiceValue = $F("b140PremSeqNoInw");
																		$("b140PremSeqNoInw").setAttribute("lastValidValue", lastAcceptedInvoiceValue);
																		$("instNoInw").enable();
																		$("instNoInw").focus();
																		
																		defInstNo = ""; //added by steve 11.06.2013
																		$("instNoInw").clear();
																		$("collectionAmtInw").clear();
																	}else{
																		$("b140PremSeqNoInw").clear();
																		$("b140PremSeqNoInw").value = lastAcceptedInvoiceValue == "" ? "" : formatNumberDigits(lastAcceptedInvoiceValue,8);
																		customShowMessageBox(vMsgAlert, imgMessage.ERROR, "b140PremSeqNoInw");
																		return false;
																	}
																}
															},
															function() {
																showMessageBox("This is a cancelled policy.", imgMessage.ERROR);
																$("b140PremSeqNoInw").clear();
																$("b140PremSeqNoInw").value = lastAcceptedInvoiceValue == "" ? "" : formatNumberDigits(lastAcceptedInvoiceValue,8);
																return false;
															});
									}, function(){
										$("b140PremSeqNoInw").clear();
										$("b140PremSeqNoInw").value = lastAcceptedInvoiceValue == "" ? "" : formatNumberDigits(lastAcceptedInvoiceValue,8);
										return false;
									});
								}
						}, function(){
							$("b140PremSeqNoInw").clear();
							$("b140PremSeqNoInw").value = lastAcceptedInvoiceValue == "" ? "" : formatNumberDigits(lastAcceptedInvoiceValue,8);
							return false;
						});
					}
				}
			});
		}catch(e){
			showErrorMessage ("checkPremPaytForCancelled",e);
		}
	}
	
	//added by john 2.24.2015 - to validate deleting of records with refund
	function validateDelete(delObj){
		try{
			new Ajax.Request(contextPath+'/GIACInwFaculPremCollnsController?action=validateDelete', {
				parameters: {
					gaccTranId : delObj.gaccTranId
				},
				asynchronous:false,
				evalScripts:true,
				onCreate: function(){
					showNotice("Validating, please wait...");	
				},	
				onComplete: function(response){
					hideNotice("");
					
					if(response.responseText == "Y"){
						showMessageBox("Delete not allowed. A refund transaction exists for this record.", imgMessage.ERROR);
						 return false;
					}
					
					if(delObj.orPrintTag == 'Y'){
						showMessageBox("Delete not allowed. This record was created before the OR was printed.", imgMessage.ERROR);
						return false;
					} else{
						/*delete confirmation message upon deletion of record by MAC 01/17/2013
						showConfirmBox(
								"Delete Inward Facultative Premium Collection",
								"Are you sure you want to delete record?",
								"OK",
								"Cancel",
								function() {*/
									for(var i = 0; i < objInwFaculPremCollns.length; i++){
										if(delObj.b140IssCd == objInwFaculPremCollns[i].b140IssCd
											&& delObj.a180RiCd == objInwFaculPremCollns[i].a180RiCd
											&& delObj.b140PremSeqNo == objInwFaculPremCollns[i].b140PremSeqNo
											&& delObj.transactionType == objInwFaculPremCollns[i].transactionType
											&& delObj.instNo == objInwFaculPremCollns[i].instNo
											&& delObj.recordStatus != -1){
											delObj.recordStatus = -1;
											computeTotalAmountInTable(-1*parseFloat(delObj.collectionAmt), //lara 3/21/2014
													-1*parseFloat(delObj.premiumAmt),
													-1*parseFloat(delObj.taxAmount),
													-1*parseFloat(delObj.commAmt),
													-1*parseFloat(delObj.commVat));
											//added checking that will update record status of the deleted object to null when record is not yet saved on the database by MAC 01/04/2013
											for (var ii=0; ii<addedRecord.length; ii++){
												if (delObj.b140PremSeqNo+"-"+delObj.instNo == addedRecord[ii]){
													delObj.recordStatus = null;
												}
											}
											delObj.savedItems = "N";
											objInwFaculPremCollns.splice(i, 1, delObj); 
											inwFaculPremCollnsTableGrid.deleteVisibleRowOnly(inwFaculPremCollnsTableGrid.getCurrentPosition()[1]);
											
											changeTag = 1;
											if($("btnSaveInwFacul").disabled = "disabled"){
												enableButton("btnSaveInwFacul");
											}
										}
									}
								//computeTotalAmountInTable(); //lara 3/21/2014
								//}); comment out by MAC 01/17/2013
					}
					populateCollnsDetails(null);
				}
			});
		}catch(e){
			showErrorMessage ("validateDelete",e);
		}
	}
	
	//Deo [01.20.2017]: add start (SR-5909)
	var giacs008UpdBtn = '${giacs008UpdBtn}';
	objAC.hasGiacs008CCFnc = '${hasCCFnc}';
	objAC.hasGiacs008AOFnc = '${hasAOFnc}';
	objAC.chkPremAging = '${chkPremAging}';
	objAC.chkBillDueDate = '${chkBillDueDate}';
	objAC.giacs008AllowClm = "N";
	objAC.giacs008AllowOvrDue = "N";
	
	if (nvl(giacs008UpdBtn, "N") != "Y") {
		$("btnUpdate").hide();
        $("lblUpdate").hide();
	}
	
	function allowEnableBtnUpd() {
		var allow = false;
		if (objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR"
			|| objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y" || objACGlobal.tranSource != 'OR') {
			allow = false;
		} else {
			if (objACGlobal.orTag == 'S') {
				if (objACGlobal.orFlag == 'N') {
					allow = true;
				} else {
					allow = false;
				}
			} else {
				if (objACGlobal.orFlag == 'N' || objACGlobal.orFlag == 'P') {
					allow = true;
				} else {
					allow = false;
				}
			}
		}
		return allow;
	}
	
	function enableBtnUpd(enable) {
		if (enable) {
			if (allowEnableBtnUpd()) {
				enableButton("btnUpdate");
			} else {
				disableButton("btnUpdate");
			}
		} else {
			disableButton("btnUpdate");
		}
	}
	
	function checkClaim(issCd, premSeqNo, instNo) {
		if ($F("hasClaim") != "FALSE") {
			showConfirmBox("Premium Collections", "The policy of " + issCd + "-" + premSeqNo + "-" + instNo + " has existing claim(s): Claim Number(s) "
				+ $F("hasClaim") + ". Would you like to continue with the premium collections?", "Yes", "No",
				function() {
					if (objAC.hasGiacs008CCFnc == "N" && objAC.giacs008AllowClm == "N") {
						showConfirmBox("Premium Collections", "User is not allowed to process policy that has an existing claim. "
							+ "Would you like to override?", "Yes", "No",
							function() {
								callOverride("GIACS008", "CC", " is not allowed to process collections for policies with existing claims.");
							}, function() {
								invalidateOverride();
							});
					} else {
						checkOverDue();
					}
				}, function() {
					invalidateOverride();
				});
		} else {
			checkOverDue();
		}
	}
	
	function checkOverDue() {
		if (nvl(objAC.chkPremAging, "N") == "Y" && ($F("transactionTypeInw") == "1" || $F("transactionTypeInw") == "3")) {
			if (parseFloat($F("daysOverDue")) > parseFloat(nvl(objAC.chkBillDueDate, $F("daysOverDue")))) {
				showConfirmBox("Premium Collections", "This bill is " + $F("daysOverDue") + " days overdue. "
					+ "Would you like to continue with the premium collection?", "Yes", "No",
					function() {
						if (objAC.hasGiacs008AOFnc == "N" && objAC.giacs008AllowOvrDue == "N") {
							showConfirmBox("Premium Collections", "User is not allowed to process premium collections for overdue bill. "
								+ "Would you like to override?", "Yes", "No",
								function() {
									callOverride("GIACS008", "AO", " is not allowed to process collections for overdue bill.");
								}, function() {
									invalidateOverride();
								});
						}
					}, function() {
						invalidateOverride();
					});
			} else {
				enableOrDisbleItem();
			}
		} else {
			enableOrDisbleItem();
		}
	}

	function callOverride(moduleId, functionCd, message) {
		showGenericOverride(moduleId, functionCd,
			function(ovr, userId, res) {
				if (res == "FALSE") {
					showMessageBox(userId + message, imgMessage.ERROR);
					$("txtOverrideUserName").clear();
					$("txtOverridePassword").clear();
					return false;
				} else if (res == "TRUE") {
					if (functionCd == "CC") {
						objAC.giacs008AllowClm = "Y";
						checkOverDue();
					} else {
						objAC.giacs008AllowOvrDue = "Y";
						enableOrDisbleItem();
					}
					ovr.close();
					delete ovr;
				}
			}, function() {
					invalidateOverride();
			}, "Override User");
	}
	
	function invalidateOverride() {
		$("b140PremSeqNoInw").clear();
		$("instNoInw").clear();
		$("collectionAmtInw").clear();
		$("assuredNameInw").clear();
		$("policyNoInw").clear();
		$("defCollnAmtInw").clear();
		$("premiumAmtInw").clear();
		$("premiumTaxInw").clear();
		$("wholdingTaxInw").clear();
		$("commAmtInw").clear();
		$("foreignCurrAmtInw").clear();
		$("defForgnCurAmtInw").clear();
		$("taxAmountInw").clear();
		$("commVatInw").clear();
		$("variableSoaCollectionAmtInw").clear();
		$("variableSoaPremiumAmtInw").clear();
		$("variableSoaPremiumTaxInw").clear();
		$("variableSoaWholdingTaxInw").clear();
		$("variableSoaCommAmtInw").clear();
		$("variableSoaTaxAmountInw").clear();
		$("variableSoaCommVatInw").clear();
		$("convertRateInw").clear();
		$("currencyCdInw").clear();
		$("currencyDescInw").clear();
		$("hasClaim").clear();
		$("daysOverDue").clear();
		enableOrDisbleItem();
	}
	
	$("btnUpdate").observe("click", function() {
		try {
			if (objInwFaculPremCollns.length > 0) {
				if (changeTag != 0) {
					showMessageBox("Please save your changes first before pressing this button.", imgMessage.INFO);
				} else {
					var selected = Object.keys(curRecObj).length == 0 ? false : true;
					var msg;
				 	new Ajax.Request ("GIACInwFaculPremCollnsController?action=updateOrDtls", {
						method : "POST",
						parameters : {
							tranId : selected ? curRecObj.gaccTranId : objInwFaculPremCollns[0].gaccTranId,
							issCd : selected ? curRecObj.b140IssCd : objInwFaculPremCollns[0].b140IssCd,
							premSeqNo : selected ? curRecObj.b140PremSeqNo : objInwFaculPremCollns[0].b140PremSeqNo,
							riCd : selected ? curRecObj.a180RiCd : objInwFaculPremCollns[0].a180RiCd
						},
						evalScripts : true,
						asynchronous : false,
						onComplete : function(response) {
							if (checkErrorOnResponse(response)) {
								var obj = JSON.parse(response.responseText);
								showMessageBox(obj.msg, imgMessage.INFO);
								$("payor").value = unescapeHTML2(obj.payor);
							}
						}
					});
					
				}
			}
		} catch(e) {
			showErrorMessage("btnUpdate", e);
		}
	});
	//Deo [01.20.2017]: add ends (SR-5909)
</script>