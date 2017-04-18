<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>    
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
	<div id="inputVatsInfoDiv" name="inputVatsInfoDiv" class="sectionDiv" align="center" style="border-top: none;">
		<div id="inputVatTableGridSectionDiv" class="sectionDiv" style="height: 305px; border: none; margin-bottom: 90px;">
			<div id="inputVatTableGridDiv" style="padding: 10px;">
				<div id="inputVatTableGrid" style="height: 250px; width: 900px;"></div>
			</div>
			
			<div id="inputVatTotalAmtMainDiv"  class="sectionDiv" style="margin:10px; margin-top:13px; margin-bottom: 0; width:900px; border:none;">
				<div id="inputVatTotalAmtDiv" style="width:100%; padding-left: 33%;">
					<table id = "totalAmtsTable" name = "totalAmtsTable">
						<tr>
							<td class="rightAligned">Total Disbursement Amount: </td>
							<td class="leftAligned"><input type="text" id="txtTotalDisbAmt" name="txtTotalDisbAmt" readonly="readonly" value="" class="money" tabindex=201 /></td>
						</tr>
						<tr>
							<td class="rightAligned">Total Base Amount: </td>
							<td class="leftAligned"><input type="text" id="txtTotalBaseAmt" name="txtTotalBaseAmt" readonly="readonly" value="" class="money" tabindex=202/></td>
						</tr>
						<tr>
							<td class="rightAligned">Total Input VAT Amount: </td>
							<td class="leftAligned"><input type="text" id="txtTotalInputVatAmt" name="txtTotalInputVatAmt" readonly="readonly" value="" class="money" tabindex=203/></td>
						</tr>
					</table>
				</div>
			</div>
		</div>
		
		<div class="sectionDiv" style="border: none; margin-top: 0;" id="directTransInputVatDiv" name="directTransInputVatDiv">
			<%-- <jsp:include page="subPages/inputVatListingTable.jsp"></jsp:include> --%>
			<table align="center" border="0" style=" margin:0; margin-top:0; margin-bottom:20px;">
					<tr>
						<td class="rightAligned" >Transaction Type</td>
						<td class="leftAligned"  >
							<input type="text" id="readOnlyTransactionTypeInputVat" name="readOnlyTransactionTypeInputVat" value="" class="required" style="width:231px; display:none;" readonly="readonly" tabindex=204/>
							<input type="hidden" id="hidTransTypeDesc" name="hidTransTypeDesc" value=""/>
							<input type="hidden" id="hidTransType" name="hidTransType" value=""/>
							<select id="selTransactionTypeInputVat" name="selTransactionTypeInputVat" style="width:239px;" class="required" tabindex=204>
								<option value=""></option>
								<c:forEach var="transactionType" items="${transactionTypeList }" varStatus="ctr">
									<option value="${transactionType.rvLowValue}" typeDesc="${transactionType.rvMeaning }">${transactionType.rvLowValue } - ${transactionType.rvMeaning }</option>
								</c:forEach>
							</select>
						</td>
						<td class="rightAligned" style="width:130px">Account Code</td>
						<td class="leftAligned"  style="width:262px;">
							<input type="text" style="width:15px" id="txtGlAcctCategoryInputVat"  	name="txtGlAcctCategoryInputVat" value="" maxlength="1" class="required integerNoNegativeUnformattedNoComma" errorMsg="Entered value is invalid. Valid value is from 0 to 9." tabindex=215/>
							<input type="text" style="width:15px" id="txtGlControlAcctInputVat"   	name="txtGlControlAcctInputVat"  value="" maxlength="2" class="required integerNoNegativeUnformattedNoComma" errorMsg="Entered value is invalid. Valid value is from 0 to 99." tabindex=216/>
							<input type="text" style="width:15px" id="txtGlSubAcct1InputVat" 	   	name="txtGlSubAcct1InputVat" value="" maxlength="2" class="required integerNoNegativeUnformattedNoComma" errorMsg="Entered value is invalid. Valid value is from 0 to 99." tabindex=217/>
							<input type="text" style="width:15px" id="txtGlSubAcct2InputVat" 	   	name="txtGlSubAcct2InputVat" value="" maxlength="2" class="required integerNoNegativeUnformattedNoComma" errorMsg="Entered value is invalid. Valid value is from 0 to 99." tabindex=218/>
							<input type="text" style="width:15px" id="txtGlSubAcct3InputVat" 	   	name="txtGlSubAcct3InputVat" value="" maxlength="2" class="required integerNoNegativeUnformattedNoComma" errorMsg="Entered value is invalid. Valid value is from 0 to 99." tabindex=219/>
							<input type="text" style="width:15px" id="txtGlSubAcct4InputVat" 	   	name="txtGlSubAcct4InputVat" value="" maxlength="2" class="required integerNoNegativeUnformattedNoComma" errorMsg="Entered value is invalid. Valid value is from 0 to 99." tabindex=220/>
							<input type="text" style="width:15px" id="txtGlSubAcct5InputVat" 	   	name="txtGlSubAcct5InputVat" value="" maxlength="2" class="required integerNoNegativeUnformattedNoComma" errorMsg="Entered value is invalid. Valid value is from 0 to 99." tabindex=221/>
							<input type="text" style="width:15px" id="txtGlSubAcct6InputVat" 	   	name="txtGlSubAcct6InputVat" value="" maxlength="2" class="required integerNoNegativeUnformattedNoComma" errorMsg="Entered value is invalid. Valid value is from 0 to 99." tabindex=222/>
							<input type="text" style="width:15px" id="txtGlSubAcct7InputVat" 	   	name="txtGlSubAcct7InputVat" value="" maxlength="2" class="required integerNoNegativeUnformattedNoComma" errorMsg="Entered value is invalid. Valid value is from 0 to 99." tabindex=223/>
							<input type="hidden" id="hidGsltSlTypeCdInputVat" name="hidGsltSlTypeCdInputVat" value="" />
							<input type="hidden" id="hidGlAcctIdInputVat" 	name="hidGlAcctIdInputVat" 		value="" />
							<img style="float: right; margin-left:3px;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="acctCodeInputVatDate" name="acctCodeInputVatDate" alt="Go" tabindex=224/>	
						</td>
					</tr>
					<tr>
						<td class="rightAligned" >Payee Class</td>
						<td class="leftAligned"  >
							<input type="text" id="readOnlyPayeeClassCdInputVat" name="readOnlyPayeeClassCdInputVat" value="" class="required" style="width:231px; display:none;" readonly="readonly" tabindex=205/>
							<input type="hidden" id="hidPayeeClassCd" value=""/>
							<select id="selPayeeClassCdInputVat" name="selPayeeClassCdInputVat" style="width:239px;" class="required" tabindex=205>
								<option value=""></option>
								<c:forEach var="payeeClass" items="${payeeClassList }" varStatus="ctr">
									<option value="${payeeClass.payeeClassCd}"><fmt:formatNumber pattern="00">${payeeClass.payeeClassCd }</fmt:formatNumber> - ${payeeClass.classDesc }</option>
								</c:forEach>
							</select>
						</td>
						<td class="rightAligned" >Account Name</td>
						<td class="leftAligned"  >
							<input type="text" id="txtDspAccountName" name="txtDspAccountName" style="width:231px;" value="" readonly="readonly" tabindex=225/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" >Payee</td>
						<td class="leftAligned"  >
							<input type="hidden" id="hidPayeeNoInputVat" name="hidPayeeNoInputVat" value="" maxlength="12"/>
							<div id="payeeNameDiv" style="width: 237px;" class="required withIconDiv">
								<input style="width:210px;" type="text" id="txtPayeeNameInputVat" name="txtPayeeNameInputVat" class="required withIcon" value="" readonly="readonly" tabindex=206/>
								<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="payeeInputVatDate" name="payeeInputVatDate" alt="Go" tabindex=207/>
							</div>
						</td>
						<td class="rightAligned" >SL Name</td>
						<td class="leftAligned"  >
							<input type="hidden" id="hidSlCdInputVat" name="hidSlCdInputVat" value="">
							<div id="txtSlNameInputVatDiv" name="txtSlNameInputVatDiv" style="width: 237px;" class="withIconDiv">
								<input style="width:210px;" type="text" id="txtSlNameInputVat" name="txtSlNameInputVat" value="" readonly="readonly" class="withIcon" tabindex=226/>
								<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="slCdInputVatDate" name="slCdInputVatDate" alt="Go" tabindex=227/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" >Reference No.</td>
						<td class="leftAligned"  >
							<input type="text" id="txtReferenceNoInputVat" name="txtReferenceNoInputVat" value="" class="required" maxlength="15" style="width:231px;" tabindex=208/>
						</td>
						<td class="rightAligned" >Remarks</td>
						<td class="leftAligned"  >
							<div style="width:237px;" class="withIconDiv"> 
								<textarea onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);" id="txtRemarksInputVat" name="txtRemarksInputVat" style="width:210px;" class="withIcon" tabindex=228></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editTxtRemarksInputVat" tabindex=229/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" >VAT GL</td>
						<td class="leftAligned"  >
							<input type="text" id="readOnlyItemNoDescInputVat" name="readOnlyItemNoDescInputVat" value="" class="required" style="width:231px; display:none; text-align:right;" readonly="readonly" tabindex=209/>
							<input type="hidden" id="hidVatGlAcctId" name="hidVatGlAcctId" value="" readonly="readonly" />
							<select id="selItemNoInputVat" name="selItemNoInputVat" style="width:239px;" class="required" tabindex=209>
								<option value="" glAcctId="" gsltSlTypeCd=""></option>
								<c:forEach var="itemNo" items="${itemNoList }" varStatus="ctr">
									<option value="${itemNo.itemNo }" glAcctId="${itemNo.glAcctId }" gsltSlTypeCd="${itemNo.gsltSlTypeCd }">${itemNo.itemNo} - (${itemNo.glAcctCd} / ${itemNo.glAcctName})</option>
								</c:forEach>
							</select>
						</td>
						<td class="rightAligned" >&nbsp;</td>
						<td align="center">
							<input type="button" style="width: 150px;" id="btnPayeeMaintenanceInputVat"  name="btnPayeeMaintenanceInputVat"	class="button" value="Payee Maintenance" tabindex=230/><!-- changed the class since there is no function for button click reymon 10292013 -->
						</td>
					</tr>
					<tr>
						<td class="rightAligned" >SL Name</td>
						<td class="leftAligned"  >
							<input type="text" id="readOnlyVatSlCdDescInputVat" name="readOnlyVatSlCdDescInputVat" value="" class="required" style="width:231px; display:none;" readonly="readonly" tabindex=210/>
							<input type="hidden" id="hidVatSlCd" name="hidVatSlCd" value=""/>
							<!-- commented, changed and added lov by reymon 10292013
							<select id="selVatSlCdInputVat" name="selVatSlCdInputVat" style="width:239px;" tabindex=210>
								<option value="" slName="" itemNo=""></option>
							</select> -->
							<div id="selVatSlCdInputVatDiv" name="selVatSlCdInputVatDiv" style="width: 237px;" class="withIconDiv">
								<input style="width:210px;" type="text" id="selVatSlCdInputVat" name="selVatSlCdInputVat" value="" readonly="readonly" class="withIcon" tabindex=210/>
								<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="selSlCdInputVatDate" name="selSlCdInputVatDate" alt="Go" tabindex=211/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" >Disbursement Amount</td>
						<td class="leftAligned"  >
							<input type="text" id="txtDisbAmtInputVat" name="txtDisbAmtInputVat" value="" class="money required" maxlength="14" style="width:231px;" tabindex=212/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" >Base Amount</td>
						<td class="leftAligned"  >
							<input type="text" id="txtBaseAmtInputVat" name="txtBaseAmtInputVat" value="" class="money required" maxlength="14" style="width:231px;" tabindex=213 readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" >Input VAT Amount</td>
						<td class="leftAligned"  >
							<input type="text" id="txtInputVatAmtInputVat" name="txtInputVatAmtInputVat" value="" class="money" maxlength="14" style="width:231px;" readonly="readonly" tabindex=214/>
						</td>
					</tr>
					<tr>
						<td colspan="2" style="margin:auto;" align="center">
							<input type="button" style="width: 80px;" id="btnAddInputVat" 	 class="button" value="Add" tabindex=231/>
							<input type="button" style="width: 80px;" id="btnDeleteInputVat" class="button" value="Delete" tabindex=232/>
						</td>
					</tr>	
			</table>	
		</div>
	</div>
	
	<div class="buttonsDiv" style="float:left; width: 100%;">			
		<input type="button" style="width: 80px;" id="btnCancelDirectTransInputVat"  name="btnCancelDirectTransInputVat"	class="button" value="Cancel" tabindex=233/>
		<input type="button" style="width: 80px;" id="btnSaveDirectTransInputVat" 	 name="btnSaveDirectTransInputVat"		class="disabledButton" value="Save" tabindex=234/>
	</div> 

<script type="text/javascript">
	var pageActions = {none: 0, save : 1, reload : 2, cancel : 3};
	var pAction = pageActions.none;
	var objValidateAcctCode;
	var hiddenObjGiacInputVat = new Object();
	var hidInputVatRtObj = JSON.parse('${inputVatRt}'.replace(/\\/g, '\\\\'));
	hidInputVatRtObj = parseFloat(hidInputVatRtObj == null || hidInputVatRtObj == "" ? 0 :hidInputVatRtObj);
	//var vatSlListJSON = JSON.parse('${selVatSlCdInputVat}'.replace(/\\/g, '\\\\'));
	objAC.hidObjGIACS039 = {};
	
	setModuleId("GIACS039");
	setDocumentTitle("Input VAT");
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	initializeAccordion();
	
	changeTag = 0;
	
	try{
		var objInputVat = new Object();
		var objInputVatRows = [];
		objInputVat.objInputVatListTableGrid = JSON.parse('${giacInputVatsJSON}'.replace(/\\/g, '\\\\'));
		objInputVat.objInputVatList = objInputVat.objInputVatListTableGrid.rows || [];
		
		var inputVatTableModel = {
				url : contextPath+ "/GIACInputVatController?action=showDirectTransInputVatTableGrid&globalGaccTranId="+objACGlobal.gaccTranId+"&globalGaccFundCd="+objACGlobal.fundCd,
				options : {
					title : '',
					width : '900px',
					onCellFocus : function(element, value, x, y, id) {
						objInputVatTableGrid.keys.releaseKeys();
						selectedIndex = y;
						var obj = objInputVatTableGrid.geniisysRows[y];
						populateInputVatDetails(obj);
					},
					onCellBlur : function() {
						observeChangeTagInTableGrid(objInputVatTableGrid);
					},
					onRemoveRowFocus : function() {
						selectedIndex = -1;						
						clearForm();
					},
					onSort : function(){
						clearForm();
					},
					postPager : function(){
						clearForm();
					},
					toolbar : {
						elements : [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
						onRefresh: function(){
							clearForm();
						},
						onFilter: function(){
							clearForm();
						},
						postSave : function() {
							objInputVatTableGrid.clear();
							objInputVatTableGrid.refresh();
							changeTag = 0;
							selectedIndex = -1;
						} 
					}
				},
				columnModel : [ 
				{
					id : 'recordStatus',
					title : '',
					width : '0',
					visible : false,
					editor : 'checkbox'
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},
				{
					id : 'gaccTranId',
					title : 'Tran ID',
					width : '0px',
					visible : false
				}, 
				{
					id : 'transactionTypeAndDesc',
					title : 'Transaction Type',
					width : '100px',
					filterOption : true
				}, 
				{
					id : 'payeeClassDesc',
					title : 'Payee Class',
					width : '100px',
					filterOption : true
				},
				{
					id : 'dspPayeeName',
					title : 'Payee Name',
					width : '100px',
					filterOption : true
				}, 
				{
					id : 'referenceNo',
					title : 'Reference No.',
					width : '100px',
					filterOption : true
				},
				{
					id : 'itemNo',
					title : 'Item No.',
					width : '50px',
					filterOption : true,
					align : 'right',
					titleAlign : 'right',
					filterOption : true
				},
				{
					id : 'vatSlName',
					title : 'SL Name',
					width : '120px',
					filterOption : true,
					filterOption : true
				},
				{
					id : 'disbAmt',
					title : 'Disbursement Amt',
					width : '106px',
					filterOption : true,
					align : 'right',
					titleAlign : 'right',
					filterOption : true,
					renderer: function(value){
	            		   return formatCurrency(value);
	            	}
				},
				{
					id : 'baseAmt',
					title : 'Base Amt',
					width : '89px',
					filterOption : true,
					align : 'right',
					titleAlign : 'right',
					filterOption : true,
					renderer: function(value){
	            		   return formatCurrency(value);
	            	}
				},
				{
					id : 'inputVatAmt',
					title : 'Input VAT Amt',
					width : '89px',
					filterOption : true,
					align : 'right',
					titleAlign : 'right',
					filterOption : true,
					renderer: function(value){
	            		   return formatCurrency(value);
	            	}
				},
				{
					id : 'slCd',
					title : '',
					width : '0px',
					visible : false
				},
				{
					id : 'payeeNo',
					title : '',
					width : '0px',
					visible : false
				},
				{
					id : 'vatGlAcctId',
					title : '',
					width : '0px',
					visible : false
				},
				{
					id : 'glAcctId',
					title : '',
					width : '0px',
					visible : false
				},				{
					id : 'gsltSlTypeCd',
					title : '',
					width : '0px',
					visible : false
				},
				{
					id : 'alAcctId',
					title : '',
					width : '0px',
					visible : false
				},
				{
					id : 'vatSlCd',
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
				id : 'remarks',
				title : '',
				width : '0px',
				visible : false
				}
				],
				requiredColumns : '',
				resetChangeTag : true,
				rows : objInputVat.objInputVatList
		};
		
		objInputVatTableGrid = new MyTableGrid(inputVatTableModel);
		objInputVatTableGrid.pager = objInputVat.objInputVatListTableGrid ;
		objInputVatTableGrid.render('inputVatTableGrid');
		objInputVatTableGrid.afterRender = function(){
			objInputVatRows = objInputVatTableGrid.geniisysRows;
			computeTotalAmountInTable();
		};
	}catch(e){
		showErrorMessage("inputVatListingTableGrid", e);
	}
	
	//populate selected record details
	function populateInputVatDetails(obj){
		try{
			//remove by steven 09.23.2014
			/* $("selTransactionTypeInputVat").hide();
			$("selPayeeClassCdInputVat").hide();
			$("selItemNoInputVat").hide();
			$("selVatSlCdInputVat").hide();
			$("selVatSlCdInputVatDiv").hide();
			$("selSlCdInputVatDate").hide();
			//icons
			$("payeeInputVatDate").hide();
			$("slCdInputVatDate").hide();
			$("acctCodeInputVatDate").hide();
			$("editTxtRemarksInputVat").hide();
			
			$("readOnlyTransactionTypeInputVat").show();
			$("readOnlyPayeeClassCdInputVat").show();
			$("readOnlyItemNoDescInputVat").show();
			$("readOnlyVatSlCdDescInputVat").show();
			
			$("txtGlAcctCategoryInputVat").readOnly = true;
			$("txtGlControlAcctInputVat").readOnly = true;
			$("txtGlSubAcct1InputVat").readOnly = true;
			$("txtGlSubAcct2InputVat").readOnly = true;
			$("txtGlSubAcct3InputVat").readOnly = true;
			$("txtGlSubAcct4InputVat").readOnly = true;
			$("txtGlSubAcct5InputVat").readOnly = true;
			$("txtGlSubAcct6InputVat").readOnly = true;
			$("txtGlSubAcct7InputVat").readOnly = true;
			$("txtDspAccountName").readOnly = true;
			$("txtPayeeNameInputVat").readOnly = true;
			$("txtSlNameInputVat").readOnly = true;
			$("txtReferenceNoInputVat").readOnly = true;
			$("txtRemarksInputVat").readOnly = true;
			$("txtDisbAmtInputVat").readOnly = true;
			$("txtBaseAmtInputVat").readOnly = true;
			$("txtInputVatAmtInputVat").readOnly = true;  */
			//added by steven 09.23.2014
			$("selTransactionTypeInputVat").hide();
			$("selPayeeClassCdInputVat").hide();
			$("payeeInputVatDate").hide();
			$("readOnlyTransactionTypeInputVat").show();
			$("readOnlyPayeeClassCdInputVat").show();
			$("txtReferenceNoInputVat").readOnly = true;
			enableVatSlName(true);
			$("selTransactionTypeInputVat").value = (obj == null ? "" : (nvl(obj.transactionType, "")));
			$("selPayeeClassCdInputVat").value = (obj == null ? "" : (nvl(obj.payeeClassCd, "")));
			$("selItemNoInputVat").value = (obj == null ? "" : (nvl(obj.itemNo, "")));
			$("selVatSlCdInputVat").value = (obj == null ? "" : unescapeHTML2((nvl(obj.vatSlName, ""))));
			
			$("readOnlyTransactionTypeInputVat").value = (obj == null ? "" : (nvl(obj.transactionTypeAndDesc, "")));
			$("txtGlAcctCategoryInputVat").value = (obj == null ? "" :(nvl(obj.glAcctCategory, "")));
			$("txtGlControlAcctInputVat").value = (obj == null ? "" : (nvl(obj.glControlAcct, "")));
			$("txtGlSubAcct1InputVat").value = (obj == null ? "" : (nvl(obj.glSubAcct1, "")));
			$("txtGlSubAcct2InputVat").value = (obj == null ? "" : (nvl(obj.glSubAcct2, "")));
			$("txtGlSubAcct3InputVat").value = (obj == null ? "" : (nvl(obj.glSubAcct3, "")));
			$("txtGlSubAcct4InputVat").value = (obj == null ? "" : (nvl(obj.glSubAcct4, "")));
			$("txtGlSubAcct5InputVat").value = (obj == null ? "" : (nvl(obj.glSubAcct5, "")));
			$("txtGlSubAcct6InputVat").value = (obj == null ? "" : (nvl(obj.glSubAcct6, "")));
			$("txtGlSubAcct7InputVat").value = (obj == null ? "" : (nvl(obj.glSubAcct7, "")));
			$("readOnlyPayeeClassCdInputVat").value = (obj == null ? "" : unescapeHTML2((nvl(obj.payeeClassDesc, ""))));
			$("hidPayeeClassCd").value = (obj == null ? "" : (nvl(obj.payeeClassCd, "")));
			$("txtDspAccountName").value = (obj == null ? "" : unescapeHTML2((nvl(obj.glAcctName, ""))));
			$("txtPayeeNameInputVat").value = (obj == null ? "" : unescapeHTML2((nvl(obj.dspPayeeName, ""))));
			$("txtSlNameInputVat").value = (obj == null ? "" : unescapeHTML2((nvl(obj.slName, ""))));
			$("txtReferenceNoInputVat").value = (obj == null ? "" : (nvl(obj.referenceNo, "")));
			$("txtRemarksInputVat").value = (obj == null ? "" : unescapeHTML2((nvl(obj.remarks, "")))); 
			$("readOnlyItemNoDescInputVat").value = (obj == null ? "" : (nvl(obj.itemNo, "")));
			//enableVatSlName(obj == null ? false : true);
			//updateSlNameLOV(vatSlListJSON);
			$("readOnlyVatSlCdDescInputVat").value = (obj == null ? "" : unescapeHTML2((nvl(obj.vatSlName, ""))));
			$("txtDisbAmtInputVat").value = (obj == null ? "" : formatCurrency(nvl(obj.disbAmt, "")));
			$("txtBaseAmtInputVat").value = (obj == null ? "" : formatCurrency(nvl(obj.baseAmt, "")));
			$("txtInputVatAmtInputVat").value = (obj == null ? "" : formatCurrency(nvl(obj.inputVatAmt, "")));
			$("hidGlAcctIdInputVat").value = (obj == null ? "" : (nvl(obj.glAcctId, "")));
			$("hidVatGlAcctId").value = (obj == null ? "" : (nvl(obj.vatGlAcctId, "")));
			$("hidSlCdInputVat").value = (obj == null ? "" : (nvl(obj.slCd, "")));
			$("hidGsltSlTypeCdInputVat").value = (obj == null ? "" : (nvl(obj.gsltSlTypeCd, "")));
			$("hidPayeeNoInputVat").value = (obj == null ? "" : (nvl(obj.payeeNo, "")));
			$("hidVatSlCd").value = (obj == null ? "" : (nvl(obj.vatSlCd, "")));
			$("hidTransTypeDesc").value = (obj == null ? "" : (nvl(obj.transactionTypeDesc, "")));
			$("hidTransType").value = (obj == null ? "" : (nvl(obj.transactionType, "")));
			$("btnAddInputVat").value = (obj == null ? "Add" :"Update");
// 			disableButton("btnAddInputVat");//remove by steven 09.23.2014
			if(objACGlobal.tranFlagState == 'O'){
				if ((objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR")  && objAC.tranFlagState != "C"){ // andrew - 08.15.2012 SR 0010292
					(obj == null ? disableButton("btnDeleteInputVat") : enableButton("btnDeleteInputVat"));
				}
			}
			
			//shan 11.15.2013
			if (objACGlobal.queryOnly == "Y"){
				disableButton("btnDeleteInputVat");
			}
			//remove by steven 09.23.2014
			//marco - 06.19.2013
			/* if(!($F("hidGsltSlTypeCdInputVat").blank() && !$F("hidGlAcctIdInputVat").blank())){
				$("txtSlNameInputVat").addClassName("required");
				$("txtSlNameInputVatDiv").addClassName("required");
				$("txtSlNameInputVatDiv").setStyle({backgroundColor: '#FFFACD'});
			} */
			if ($F("readOnlyVatSlCdDescInputVat").blank()){ // added by robert 12.18.2014
				enableVatSlName(false);
				$("selVatSlCdInputVat").clear();
			}else{
				enableVatSlName(true);
			}
			
			if ($F("hidGsltSlTypeCdInputVat").blank() && !$F("hidGlAcctIdInputVat").blank()){
				enableGlstSLName(false);
			}else{
				enableGlstSLName(true);
			}
		} catch(e){
			showErrorMessage("populateInputVatDetails", e);
		}
	}
	
	//onblur transaction type
	$("selTransactionTypeInputVat").observe("change", function(){
		//validateReferenceNo();
		clearForm(false);
	});

	//remarks
	$("editTxtRemarksInputVat").observe("click", function () {
		//showEditor("txtRemarksInputVat", 4000);
		showOverlayEditor("txtRemarksInputVat", 4000, $("txtRemarksInputVat").hasAttribute("readonly")); // andrew - 08.15.2012 SR 0010292
		if (objAC.hidObjGIACS039.hidUpdateable == "N" || objACGlobal.tranFlagState != 'O'){
			disableButton("btnSubmitText");
			$("textarea1").readOnly = true;
		}else{
			enableButton("btnSubmitText");
			$("textarea1").readOnly = false;
		}		
	});

	//search icon for payee
	$("payeeInputVatDate").observe("click", function(){
		if (objAC.hidObjGIACS039.hidUpdateable == "N"){
			return false;
		}
		if ($F("selTransactionTypeInputVat").blank()){
			customShowMessageBox("Please select a transaction type first.", imgMessage.ERROR, "selTransactionTypeInputVat");
			return false;
		}else if($F("selPayeeClassCdInputVat").blank()){
			customShowMessageBox("Please select a payee class first.", imgMessage.ERROR, "selPayeeClassCdInputVat");
			return false;
		}else{
// 			openSearchPayeeInputVat();
			var payeeClassCd = $F("selPayeeClassCdInputVat");
			showPayeeNamesLOV(payeeClassCd);
		}
	});

	//call modal search payee
	function openSearchPayeeInputVat(){
		Modalbox.show(contextPath+"/GIACInputVatController?action=openSearchPayeeInputVat&ajaxModal=1",  
				  {title: "Search Payee", 
				  width: 800,
				  asynchronous: true});
	}

	//search icon for SL name (right side)
	$("slCdInputVatDate").observe("click", function(){
		if (objAC.hidObjGIACS039.hidUpdateable == "N"){
			return false;
		}
		if ($F("hidGsltSlTypeCdInputVat").blank() && $F("hidGlAcctIdInputVat").blank()){
			customShowMessageBox("Please select an account code first.", imgMessage.ERROR, "hidGsltSlTypeCdInputVat");
			return false;
		}else if ($F("hidGsltSlTypeCdInputVat").blank() && !$F("hidGlAcctIdInputVat").blank()){
			customShowMessageBox("There is no sl name existing with this account code.", imgMessage.ERROR, "hidGsltSlTypeCdInputVat");
			return false;	
		}else{	
			//openSearchSlNameInputVat();
			//showSlListLOV($F("hidGsltSlTypeCdInputVat"), "GIACS039");
			showSlNameInputVatListLOV($F("hidGsltSlTypeCdInputVat"), 0);
		}
	});
	
	//added by reymon 10292013
	$("selSlCdInputVatDate").observe("click", function(){
		showSlNameInputVatListLOV($("selItemNoInputVat").options[$("selItemNoInputVat").selectedIndex].getAttribute("gsltSlTypeCd"), 1);
	});
	
	//call modal search SL name (right side)
	function openSearchSlNameInputVat(){
		Modalbox.show(contextPath+"/GIACInputVatController?action=openSearchSlNameInputVat&ajaxModal=1",  
				  {title: "Search SL Name", 
				  width: 800,
				  asynchronous: true});
	}	

	//search icon for Account Code
	$("acctCodeInputVatDate").observe("click", function(){
		if (objAC.hidObjGIACS039.hidUpdateable == "N"){
			return false;
		}
		//openSearchAcctCodeInputVat();
		showAcctCodesChartLOV();
	});

	//call modal search Account Code
	function openSearchAcctCodeInputVat(){
		Modalbox.show(contextPath+"/GIACInputVatController?action=openSearchAcctCodeInputVat&ajaxModal=1",  
				  {title: "Search Account Code", 
				  width: 800,
				  asynchronous: true});
	}	

	//onchange on payee class
	$("selPayeeClassCdInputVat").observe("change",function(){
			$("hidPayeeNoInputVat").clear();
			$("txtPayeeNameInputVat").clear();	
			validateReferenceNo();
	});
	
	//onclick payee class
	$("selPayeeClassCdInputVat").observe("click",function(){
		if($F("selTransactionTypeInputVat").blank()){
			customShowMessageBox("Please select a transaction type first.", imgMessage.ERROR, "selTransactionTypeInputVat");
		}
	});

	//onblur reference no.
	$("txtReferenceNoInputVat").observe("blur", function(){
		validateReferenceNo();
	});	

	//onblur payee name
	$("txtPayeeNameInputVat").observe("blur", function(){
		validateReferenceNo();
	});

	//onchange of item no
	$("selItemNoInputVat").observe("change", function(){
		//updateSlNameLOV(vatSlListJSON);
		$("hidVatGlAcctId").value = $("selItemNoInputVat").options[$("selItemNoInputVat").selectedIndex].getAttribute("glAcctId");
		if ($("selItemNoInputVat").options[$("selItemNoInputVat").selectedIndex].getAttribute("gsltSlTypeCd") != ""){
			enableVatSlName(true);
			$("selVatSlCdInputVat").clear();//added by steven 09.22.2014
		}else{
			enableVatSlName(false);
		}		
	});

	//enable or disable the SL name
	//parameter: true/false
	function enableVatSlName(param){
		if (param){
			$("selVatSlCdInputVat").enable();
			$("selVatSlCdInputVat").addClassName("required");
			$("selVatSlCdInputVatDiv").addClassName("required");
			enableSearch("selSlCdInputVatDate");
		}else{
			//$("selVatSlCdInputVat").selectedIndex = 0; commented out by reymon 10292013
			$("selVatSlCdInputVat").value = "";
			//$("selVatSlCdInputVat").disable(); commented out by reymon 10292013
			$("selVatSlCdInputVat").removeClassName("required");
			$("selVatSlCdInputVatDiv").removeClassName("required");
			disableSearch("selSlCdInputVatDate");
		}		
	}	

	var vPreDisbAmt = 0;
	//onfocus on disbursement amount
	$("txtDisbAmtInputVat").observe("focus", function(){
		vPreDisbAmt = unformatCurrency("txtDisbAmtInputVat") == "" ? 1 :unformatCurrency("txtDisbAmtInputVat");
	});
	
	//onchange on disbursement amount
	$("txtDisbAmtInputVat").observe("change", function(){
		if (vPreDisbAmt == unformatCurrency("txtDisbAmtInputVat") || unformatCurrency("txtDisbAmtInputVat") == ""){
			$("txtBaseAmtInputVat").clear(); //added by steven 09.23.2014
			$("txtInputVatAmtInputVat").clear();
			return;
		}
				
		if ($F("txtDisbAmtInputVat").blank()){
			showMessageBox("Disbursement amount is required.", imgMessage.ERROR);
			return false;
		}else{
			if ($F("txtBaseAmtInputVat").blank() && $F("txtInputVatAmtInputVat").blank()){
				$("txtBaseAmtInputVat").value = formatCurrency(Math.round(((100 * nvl(unformatCurrency("txtDisbAmtInputVat"),0)) / (100 + hidInputVatRtObj))*100)/100);
	  			$("txtInputVatAmtInputVat").value = formatCurrency(unformatCurrency("txtDisbAmtInputVat") - unformatCurrency("txtBaseAmtInputVat"));
			}
		}	
		
		
		if ($F("selTransactionTypeInputVat") == "1"){
			if (unformatCurrency("txtDisbAmtInputVat") < 0){
				customShowMessageBox("Negative transactions are not accepted.", imgMessage.ERROR, "txtDisbAmtInputVat");
				$("txtDisbAmtInputVat").clear();
				$("txtDisbAmtInputVat").focus();
				return false;	
			}

			if (unformatCurrency("txtDisbAmtInputVat") >  9999999999.99 || unformatCurrency("txtDisbAmtInputVat") < 0.01){
				customShowMessageBox("Entered disbursement amount is invalid. Valid value is from 0.01 to 9,999,999,999.99.", imgMessage.ERROR, "txtDisbAmtInputVat");
				$("txtDisbAmtInputVat").clear();
				return false;
			}
		}else if ($F("selTransactionTypeInputVat") == "2"){
			if (unformatCurrency("txtDisbAmtInputVat") > 0){
				customShowMessageBox("Positive transactions are not accepted.", imgMessage.ERROR, "txtDisbAmtInputVat");
				$("txtDisbAmtInputVat").clear();
				$("txtDisbAmtInputVat").focus();
				return false;	
			}
			if (unformatCurrency("txtDisbAmtInputVat") >  -0.01 || unformatCurrency("txtDisbAmtInputVat") < -9999999999.99){
				customShowMessageBox("Entered disbursement amount is invalid. Valid value is from -0.01 to -9,999,999,999.99.", imgMessage.ERROR, "txtDisbAmtInputVat");
				$("txtDisbAmtInputVat").clear();
				return false;
			}
			
		}	

		if (vPreDisbAmt != unformatCurrency("txtDisbAmtInputVat")){
			$("txtBaseAmtInputVat").value = formatCurrency(Math.round(((100 * nvl(unformatCurrency("txtDisbAmtInputVat"),0)) / (100 + hidInputVatRtObj))*100)/100);
  			$("txtInputVatAmtInputVat").value = formatCurrency(Math.round(((hidInputVatRtObj * nvl(unformatCurrency("txtDisbAmtInputVat"),0)) / (100 + hidInputVatRtObj))*100)/100);
		}
		
		// added by shan  02.10.2015
		var computedAmt = nvl(unformatCurrency($("txtBaseAmtInputVat"), 0)) + nvl(unformatCurrency($("txtInputVatAmtInputVat"), 0));
		
		if (unformatCurrency("txtDisbAmtInputVat") != computedAmt){
			$("txtInputVatAmtInputVat").value = formatCurrency(unformatCurrency("txtDisbAmtInputVat") - nvl(unformatCurrency($("txtBaseAmtInputVat"), 0)));
		}		
	});

	var vPreBaseAmt = "";
	//remove by steven 09.23.2014; it will not be used,the field is now readOnly.
	// uncommented : shan 03.31.2015
	 //onfocus on Base Amount
	$("txtBaseAmtInputVat").observe("focus", function(){
		vPreBaseAmt = unformatCurrency("txtBaseAmtInputVat");
	});
	
	//onblur Base Amount
	//$("txtBaseAmtInputVat").observe("blur", function(){
	$("txtBaseAmtInputVat").observe("change", function(){
		if (vPreBaseAmt == unformatCurrency("txtBaseAmtInputVat")) return;
				
// 		if ($F("txtBaseAmtInputVat").blank()){
// 			$("txtBaseAmtInputVat").value = "0.00";
// 		}

		if ($F("txtDisbAmtInputVat") != "" && unformatCurrency("txtBaseAmtInputVat") > unformatCurrency("txtDisbAmtInputVat") && $F("selTransactionTypeInputVat") == "1"){
			customShowMessageBox("Base amount  should not be greater than Disbursement amount.", imgMessage.ERROR, "txtBaseAmtInputVat");
			this.value = formatCurrency(vPreBaseAmt);
			return false;
		}else if ($F("txtDisbAmtInputVat") != "" && unformatCurrency("txtBaseAmtInputVat") < unformatCurrency("txtDisbAmtInputVat") && $F("selTransactionTypeInputVat") == "2"){
			customShowMessageBox("Absolute value of base amount  should not be greater than the absolute value of disbursement amount.", imgMessage.ERROR, "txtBaseAmtInputVat");
			this.value = formatCurrency(vPreBaseAmt);
			return false;
		}
		
		if ($F("selTransactionTypeInputVat") == "1"){
			if (unformatCurrency("txtBaseAmtInputVat") < 0){
				customShowMessageBox("Negative transactions are not accepted.", imgMessage.ERROR, "selTransactionTypeInputVat");
				this.value = formatCurrency(vPreBaseAmt);
				return false;	
			}	
		}else if ($F("selTransactionTypeInputVat") == "2"){
			if (unformatCurrency("txtBaseAmtInputVat") > 0){
				customShowMessageBox("Positive transactions are not accepted.", imgMessage.ERROR, "selTransactionTypeInputVat");
				this.value = formatCurrency(vPreBaseAmt);
				return false;	
			}
		}	
		
		var inputVat = Number(Math.round(nvl(unformatCurrency("txtBaseAmtInputVat")) * hidInputVatRtObj /100 + 'e2') + 'e-2');
		$("txtInputVatAmtInputVat").value = formatCurrency(inputVat);
		$("txtDisbAmtInputVat").value =  formatCurrency(unformatCurrency("txtBaseAmtInputVat") + unformatCurrency("txtInputVatAmtInputVat"));
		
		//$("txtInputVatAmtInputVat").value = formatCurrency(unformatCurrency("txtDisbAmtInputVat") - unformatCurrency("txtBaseAmtInputVat"));
	}); 

	//get the default value
	function getDefaults(){
		$("btnAddInputVat").value = "Update";
		enableButton("btnDeleteInputVat");
	}

	//to clear the form inputs
	function clearForm(clearTranType){
		$("selTransactionTypeInputVat").enable();
		$("selPayeeClassCdInputVat").enable();
		$("txtPayeeNameInputVat").enable = false;
		$("txtReferenceNoInputVat").enable = false;
		
		$("hidTransTypeDesc").clear();
		$("hidTransType").clear();
		$("hidVatSlCd").clear();
		$("hidPayeeClassCd").clear();
		
		if (clearTranType != false) $("selTransactionTypeInputVat").selectedIndex = 0;
		$("selPayeeClassCdInputVat").selectedIndex = 0;
		$("hidPayeeNoInputVat").clear();
		$("txtPayeeNameInputVat").clear();
		$("txtReferenceNoInputVat").clear();
		$("selItemNoInputVat").selectedIndex = 0;
		$("hidVatGlAcctId").clear();
		enableVatSlName(false);
		$("txtDisbAmtInputVat").clear();
		$("txtBaseAmtInputVat").clear();
		$("txtInputVatAmtInputVat").clear();
		$("txtGlAcctCategoryInputVat").clear();
		$("txtGlControlAcctInputVat").clear();
		$("txtGlSubAcct1InputVat").clear();
		$("txtGlSubAcct2InputVat").clear();
		$("txtGlSubAcct3InputVat").clear();
		$("txtGlSubAcct4InputVat").clear();
		$("txtGlSubAcct5InputVat").clear();
		$("txtGlSubAcct6InputVat").clear();
		$("txtGlSubAcct7InputVat").clear();
		$("hidGsltSlTypeCdInputVat").clear();
		$("hidGlAcctIdInputVat").clear();
		$("txtDspAccountName").clear();
		$("hidSlCdInputVat").clear();
		$("txtSlNameInputVat").clear();
		$("txtSlNameInputVat").removeClassName("required");	//uncommented, not required :  shan 11.20.2013
		$("txtSlNameInputVatDiv").removeClassName("required"); //uncommented, not required :  shan 11.20.2013
		$("txtSlNameInputVatDiv").setStyle("background-color:"+$("txtSlNameInputVat").getStyle("background-color")); //uncommented, not required :  shan 11.20.2013
		//$("txtSlNameInputVat").addClassName("required"); //commented, not required :  shan 11.20.2013
		//$("txtSlNameInputVatDiv").addClassName("required"); //commented, not required :  shan 11.20.2013
		$("txtRemarksInputVat").clear();
		hiddenObjGiacInputVat.hidOrPrintTagInputVat 	= "N";
		hiddenObjGiacInputVat.hidCpiRecNoInputVat 		= "";
		hiddenObjGiacInputVat.hidCpiBranchCdInputVat 	= "";
		$("selTransactionTypeInputVat").enable();
		$("selPayeeClassCdInputVat").enable();
		$("txtReferenceNoInputVat").readOnly = false;
		$("payeeInputVatDate").show();
		$("readOnlyTransactionTypeInputVat").hide();
		$("readOnlyPayeeClassCdInputVat").hide();
		$("selTransactionTypeInputVat").show();
		$("selPayeeClassCdInputVat").show();
		$("txtDisbAmtInputVat").readOnly = false;
		$("txtBaseAmtInputVat").readOnly = false; //remove by steven 09.23.2014 : //uncommented by shan 03.21.2015
		$("txtGlAcctCategoryInputVat").readOnly = false;
		$("txtGlControlAcctInputVat").readOnly = false;
		$("txtGlSubAcct1InputVat").readOnly = false;
		$("txtGlSubAcct2InputVat").readOnly = false;
		$("txtGlSubAcct3InputVat").readOnly = false;
		$("txtGlSubAcct4InputVat").readOnly = false;
		$("txtGlSubAcct5InputVat").readOnly = false;
		$("txtGlSubAcct6InputVat").readOnly = false;
		$("txtGlSubAcct7InputVat").readOnly = false;
		$("acctCodeInputVatDate").show();
		$("slCdInputVatDate").show();
		$("txtRemarksInputVat").readOnly = false;
		$("selItemNoInputVat").show();
		$("readOnlyItemNoDescInputVat").value = changeSingleAndDoubleQuotes2(getListTextValue("selItemNoInputVat"));
		$("readOnlyItemNoDescInputVat").hide();
		$("selVatSlCdInputVat").show();
		$("selVatSlCdInputVatDiv").show();
		$("selSlCdInputVatDate").show();
		enableSearch("selSlCdInputVatDate");
		disableSearch("selSlCdInputVatDate");
		$("readOnlyVatSlCdDescInputVat").value = changeSingleAndDoubleQuotes2($F("selVatSlCdInputVat"));//getListTextValue("selVatSlCdInputVat"));  commented out and changed by reymon 10292013
		$("readOnlyVatSlCdDescInputVat").hide();
		objAC.hidObjGIACS039.hidUpdateable		= "Y";
		deselectRows("directTransInputVatTable","rowDirectTransInputVat");
		$("btnAddInputVat").value = "Add";
		enableButton("btnAddInputVat");
		if (objACGlobal.tranFlagState == 'C' || objACGlobal.tranFlagState == 'D'){
			disableButton("btnAddInputVat");
			$("selTransactionTypeInputVat").disable();
			$("selPayeeClassCdInputVat").disable();
			$("payeeInputVatDate").hide();
			$("txtReferenceNoInputVat").readOnly = true;
			$("selItemNoInputVat").disable();
			$("txtDisbAmtInputVat").readOnly = true;
			$("txtBaseAmtInputVat").readOnly = true;
			$("acctCodeInputVatDate").hide();
			$("txtGlSubAcct1InputVat").readOnly = true;
			$("txtGlSubAcct2InputVat").readOnly = true;
			$("txtGlSubAcct3InputVat").readOnly = true;
			$("txtGlSubAcct4InputVat").readOnly = true;
			$("txtGlSubAcct5InputVat").readOnly = true;
			$("txtGlSubAcct6InputVat").readOnly = true;
			$("txtGlSubAcct7InputVat").readOnly = true;
			$("txtGlAcctCategoryInputVat").readOnly = true;
			$("txtGlControlAcctInputVat").readOnly = true;
			$("slCdInputVatDate").hide();
			$("txtRemarksInputVat").readOnly = true;
		}
		disableButton("btnDeleteInputVat");
		computeTotalAmountInTable();
		if (objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y"){ // andrew - 08.15.2012 SR 0010292
			disableGIACS039();
			$("payeeInputVatDate").hide();
			$("acctCodeInputVatDate").hide();
			$("slCdInputVatDate").hide();
		}
		enableSearch("slCdInputVatDate");
		enableGlstSLName(false);
	};
	
	//create new Object to be added on Object Array
	function setInputVatObject() {
		try {
			var newObj = new Object();
			var btnAction = $F("btnAddInputVat");
			newObj.gaccTranId 		= objACGlobal.gaccTranId;
			newObj.transactionType 	= (btnAction == "Add" ? changeSingleAndDoubleQuotes2($F("selTransactionTypeInputVat")) :changeSingleAndDoubleQuotes2($F("hidTransType")));
			newObj.payeeNo 			= changeSingleAndDoubleQuotes2($F("hidPayeeNoInputVat"));
			newObj.payeeClassCd 	= (btnAction == "Add" ? changeSingleAndDoubleQuotes2($F("selPayeeClassCdInputVat")) : changeSingleAndDoubleQuotes2($F("hidPayeeClassCd")));
			newObj.referenceNo 		= changeSingleAndDoubleQuotes2($F("txtReferenceNoInputVat"));
			newObj.baseAmt 			= changeSingleAndDoubleQuotes2($F("txtBaseAmtInputVat").replace(/,/g, ""));
			newObj.inputVatAmt 		= changeSingleAndDoubleQuotes2($F("txtInputVatAmtInputVat").replace(/,/g, ""));
			newObj.glAcctId 		= parseInt(changeSingleAndDoubleQuotes2($F("hidGlAcctIdInputVat")));
			newObj.vatGlAcctId 		= changeSingleAndDoubleQuotes2($F("hidVatGlAcctId"));
			//newObj.itemNo 			= (btnAction == "Add" ? changeSingleAndDoubleQuotes2($F("selItemNoInputVat")) :  changeSingleAndDoubleQuotes2($F("readOnlyItemNoDescInputVat"))); remove by steven 09.23.2014
			newObj.itemNo 			= changeSingleAndDoubleQuotes2($F("selItemNoInputVat")); //added by steven 09.23.2014
			newObj.slCd 			= changeSingleAndDoubleQuotes2($F("hidSlCdInputVat")); 
			newObj.orPrintTag 		= changeSingleAndDoubleQuotes2(hiddenObjGiacInputVat.hidOrPrintTagInputVat.toString());
			newObj.remarks 			= changeSingleAndDoubleQuotes2($F("txtRemarksInputVat"));
			newObj.cpiRecNo 		= changeSingleAndDoubleQuotes2(hiddenObjGiacInputVat.hidCpiRecNoInputVat.toString());
			newObj.cpiBranchCd 		= changeSingleAndDoubleQuotes2(hiddenObjGiacInputVat.hidCpiBranchCdInputVat.toString());
			//newObj.vatSlCd 			= (btnAction == "Add" ? changeSingleAndDoubleQuotes2($F("selVatSlCdInputVat")) : changeSingleAndDoubleQuotes2($F("hidVatSlCd")));  commented out and changed by reymon 10292013
			newObj.vatSlCd 			= (btnAction == "Add" ? changeSingleAndDoubleQuotes2($F("hidVatSlCd")) : changeSingleAndDoubleQuotes2($F("hidVatSlCd")));
			newObj.glAcctCategory 	= changeSingleAndDoubleQuotes2($F("txtGlAcctCategoryInputVat"));
			newObj.glControlAcct 	= changeSingleAndDoubleQuotes2($F("txtGlControlAcctInputVat"));
			newObj.glSubAcct1 		= changeSingleAndDoubleQuotes2($F("txtGlSubAcct1InputVat"));
			newObj.glSubAcct2 		= changeSingleAndDoubleQuotes2($F("txtGlSubAcct2InputVat"));
			newObj.glSubAcct3 		= changeSingleAndDoubleQuotes2($F("txtGlSubAcct3InputVat"));
			newObj.glSubAcct4 		= changeSingleAndDoubleQuotes2($F("txtGlSubAcct4InputVat"));
			newObj.glSubAcct5 		= changeSingleAndDoubleQuotes2($F("txtGlSubAcct5InputVat"));
			newObj.glSubAcct6 		= changeSingleAndDoubleQuotes2($F("txtGlSubAcct6InputVat"));
			newObj.glSubAcct7 		= changeSingleAndDoubleQuotes2($F("txtGlSubAcct7InputVat"));
			newObj.gsltSlTypeCd 	= changeSingleAndDoubleQuotes2($F("hidGsltSlTypeCdInputVat"));
			newObj.glAcctName 		= changeSingleAndDoubleQuotes2($F("txtDspAccountName"));
			newObj.slName 			= changeSingleAndDoubleQuotes2($F("txtSlNameInputVat"));
			//newObj.vatSlName 		= (btnAction == "Add" ? changeSingleAndDoubleQuotes2(getListTextValue("selVatSlCdInputVat")) : changeSingleAndDoubleQuotes2($F("readOnlyVatSlCdDescInputVat")));  commented out and changed by reymon 10292013
			//newObj.vatSlName 		= (btnAction == "Add" ? changeSingleAndDoubleQuotes2($F("selVatSlCdInputVat")) : changeSingleAndDoubleQuotes2($F("readOnlyVatSlCdDescInputVat")));
			newObj.vatSlName 		= changeSingleAndDoubleQuotes2($F("selVatSlCdInputVat")); //added by steven 09.23.2014
			newObj.dspPayeeName 	= changeSingleAndDoubleQuotes2($F("txtPayeeNameInputVat"));
			newObj.transactionTypeDesc = (btnAction == "Add" ? changeSingleAndDoubleQuotes2(getListAttributeValue("selTransactionTypeInputVat","typeDesc")) : changeSingleAndDoubleQuotes2($F("hidTransTypeDesc")));
			newObj.payeeClassDesc 	= (btnAction == "Add" ? changeSingleAndDoubleQuotes2(getListTextValue("selPayeeClassCdInputVat")) : changeSingleAndDoubleQuotes2($F("readOnlyPayeeClassCdInputVat")));
			newObj.transactionTypeAndDesc = newObj.transactionType + " - " + newObj.transactionTypeDesc;
			newObj.disbAmt = changeSingleAndDoubleQuotes2($F("txtDisbAmtInputVat").replace(/,/g, ""));
			return newObj; 
		}catch(e){
			showErrorMessage("setInputVatObject", e);
			//showMessageBox("Error setting input vat, "+e.message ,imgMessage.ERROR);
		}
	}		

	//when Add/Update button click
	$("btnAddInputVat").observe("click", function(){
		addInputVat();
	});

	//function add record
	function addInputVat(){
		try{
			if (objAC.hidObjGIACS039.hidUpdateable == "N"){
				return false;
			}
			//check required fields first
			var exists = false;
			var message = "Required fields must be entered.";
			
			if ($F("selTransactionTypeInputVat").blank()){
				if(!$F("selPayeeClassCdInputVat").blank()){
					message = "Please select a transaction type first.";
				}
				customShowMessageBox(message, imgMessage.ERROR , "selTransactionTypeInputVat");
				exists = true;
			}else if ($F("selPayeeClassCdInputVat").blank()){
				if(!$F("txtPayeeNameInputVat").blank()){
					message =  "Please select a payee class first.";
				}
				customShowMessageBox(message, imgMessage.ERROR , "selPayeeClassCdInputVat");
				exists = true;
			}else if ($F("txtPayeeNameInputVat").blank() || $F("hidPayeeNoInputVat").blank()){
				customShowMessageBox(message, imgMessage.ERROR , "txtPayeeNameInputVat");
				exists = true;
			}else if ($F("txtReferenceNoInputVat").blank()){
				customShowMessageBox(message, imgMessage.ERROR , "txtReferenceNoInputVat");
				exists = true;
			}else if ($F("selItemNoInputVat").blank()){
				customShowMessageBox(message, imgMessage.ERROR , "selItemNoInputVat");
				exists = true;
			}else if ($F("selVatSlCdInputVat").blank() && $("selVatSlCdInputVat").hasClassName("required")){ //added condition by robert 12.17.14 //added by steven 09.23.2014
				customShowMessageBox(message, imgMessage.ERROR , "selVatSlCdInputVat");
				exists = true;
			}else if ($("selItemNoInputVat").options[$("selItemNoInputVat").selectedIndex].getAttribute("gsltSlTypeCd") != "" && $F("hidVatSlCd").blank()){//$F("selVatSlCdInputVat").blank()){  commented out and changed by reymon 10292013
				customShowMessageBox(message, imgMessage.ERROR , "selVatSlCdInputVat");
				exists = true; 
			}else if ($F("txtDisbAmtInputVat").blank()){
				customShowMessageBox(message, imgMessage.ERROR , "txtDisbAmtInputVat");
				exists = true;
			}else if ($F("txtBaseAmtInputVat").blank()){
				customShowMessageBox(message, imgMessage.ERROR , "txtBaseAmtInputVat");
				exists = true;
			}else if (!$F("txtGlAcctCategoryInputVat").blank() && !$F("txtGlControlAcctInputVat").blank() 
					&& !$F("txtGlSubAcct1InputVat").blank() && !$F("txtGlSubAcct1InputVat").blank() 
					&& !$F("txtGlSubAcct2InputVat").blank() && !$F("txtGlSubAcct3InputVat").blank() 
					&& !$F("txtGlSubAcct4InputVat").blank() && !$F("txtGlSubAcct5InputVat").blank()
					&& !$F("txtGlSubAcct6InputVat").blank() && !$F("txtGlSubAcct7InputVat").blank()){
				exists = !validateAcctCodeInputVat() ? true :false;
			}else if ($F("hidGlAcctIdInputVat").blank()){
				customShowMessageBox(message, imgMessage.ERROR , "txtGlAcctCategoryInputVat");
				exists = true;	
			}
			
			if (!$F("hidGsltSlTypeCdInputVat").blank() && !$F("hidGlAcctIdInputVat").blank() && $F("txtSlNameInputVat").blank()){
				customShowMessageBox(message, imgMessage.ERROR , "txtSlNameInputVat");
				exists = true;
			}

			if (!exists){
				var newObj  = setInputVatObject();
				if ($F("btnAddInputVat") == "Update"){
					for(var i = 0; i<objInputVatRows.length; i++){
						if ((objInputVatRows[i].gaccTranId == newObj.gaccTranId && objInputVatRows[i].referenceNo == newObj.referenceNo && objInputVatRows[i].transactionType == newObj.transactionType && objInputVatRows[i].payeeNo == newObj.payeeNo && objInputVatRows[i].payeeClassCd == newObj.payeeClassCd)&& (objInputVatRows[i].recordStatus != -1)){
								newObj.recordStatus = 1;
								objInputVatRows.splice(i, 1, newObj);
								objInputVatTableGrid.updateVisibleRowOnly(newObj, objInputVatTableGrid.getCurrentPosition()[1]);
						} 
					}
				} else{
					newObj.recordStatus = 0;
					objInputVatRows.push(newObj);
					objInputVatTableGrid.addBottomRow(newObj);
				}
				
				clearForm();
				changeTag = 1;
				if($("btnSaveDirectTransInputVat").disabled = "disabled"){
					enableButton("btnSaveDirectTransInputVat");
				}
				enableGlstSLName(false);
			}
		}catch(e){
			showErrorMessage("addInputVat", e);
			//showMessageBox("Error adding input vat, "+e.message, imgMessage.ERROR);
		}		
	}	

	//when DELETE button click
	$("btnDeleteInputVat").observe("click",function(){
		deleteInputVat(); 
	});

	//function delete record
	function deleteInputVat(){
		var delObj  = setInputVatObject();
		if (delObj.orPrintTag == "Y"){
				showMessageBox("Delete not allowed. This record was created before the OR was printed.", imgMessage.ERROR);
				return false;
		} else{
			showConfirmBox(
					"Delete Input Vat Record",
					"Are you sure you want to delete input VAT record for "
							+ delObj.dspPayeeName + "?",
					"OK",
					"Cancel",
					function() {
						for(var i = 0; i<objInputVatRows.length; i++){
							if ((objInputVatRows[i].gaccTranId == delObj.gaccTranId
									&& objInputVatRows[i].referenceNo == delObj.referenceNo 
									&& objInputVatRows[i].transactionType == delObj.transactionType 
									&& objInputVatRows[i].payeeNo == delObj.payeeNo 
									&& objInputVatRows[i].payeeClassCd == delObj.payeeClassCd)
									&& (objInputVatRows[i].recordStatus != -1)){
								delObj.recordStatus = -1;
								objInputVatRows.splice(i, 1, delObj);
								objInputVatTableGrid.deleteVisibleRowOnly(objInputVatTableGrid.getCurrentPosition()[1]);
							}
						}
						changeTag = 1;
						clearForm();
						if($("btnSaveDirectTransInputVat").disabled = "disabled"){
							enableButton("btnSaveDirectTransInputVat");
						}
			});
		}
	}

	//when SAVE button click
	$("btnSaveDirectTransInputVat").observe("click", function() {
		if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
		} else {
			pAction = pageActions.save;
			saveInputVat();
		}
	});
	
	function saveInputVat(){
		if(!checkAcctRecordStatus(objACGlobal.gaccTranId, "GIACS039")){ //marco - SR-5725 - 02.20.2017
			return;
		}
		
		try{
			var setRows 	 =  getAddedAndModifiedJSONObjects(objInputVatRows);
			var delRows 	 =  getDeletedJSONObjects(objInputVatRows);
			new Ajax.Request(contextPath+"/GIACInputVatController?action=saveInputVat",{
				method: "POST",
				parameters:{
					globalGaccTranId: 	objACGlobal.gaccTranId,
					globalGaccBranchCd: objACGlobal.branchCd,
					globalGaccFundCd: 	objACGlobal.fundCd,
					globalTranSource: 	objACGlobal.tranSource,
					globalOrFlag: 		objACGlobal.orFlag,
					setRows: prepareJsonAsParameter(setRows),
				 	delRows: prepareJsonAsParameter(delRows)
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice("Saving Input Vat, please wait...");
				},
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response)) {
						if (response.responseText == "SUCCESS"){
							changeTag = 0;
							showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
				 			lastAction;
				 			lastAction = "";
				 			clearForm();
							clearObjectRecordStatus(objInputVatRows); //to clear the record status on JSON Array
						}else{
							showMessageBox(response.responseText, imgMessage.ERROR);
						}		
					}	
				}	 
			});	
		}catch (e) {
			showErrorMessage("inputVat.jsp - saveInputVat", e);
			//showMessageBox("Error while saving, "+e.message ,imgMessage.ERROR);
		}	
	}
	
	//when CANCEL button is clicked
	$("btnCancelDirectTransInputVat").observe("click", function() {
		if(changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function(){
				saveAndCancel();
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
			}, function(){
				changeTag = 0;
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
			}, "");
		} else {
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
		}
	});
	
	function saveAndCancel(){
		pAction = pageActions.cancel;
		saveInputVat();
	}

	//function that will validate if reference no. already exist
	function validateReferenceNo(){
		try{
			var ok = true;
			if (!$F("txtReferenceNoInputVat").blank()
					&& !$F("selTransactionTypeInputVat").blank() 
					&& !$F("selPayeeClassCdInputVat").blank()
					&& !$F("hidPayeeNoInputVat").blank()){
				for(var a=0; a<objInputVatRows.length; a++){
					if ($F("btnAddInputVat") == "Update"){
						//if records is for update only
						var curRefNo = objInputVatTableGrid.geniisysRows[(objInputVatTableGrid.getCurrentPosition()[1])].referenceNo;
						if (objInputVatRows[a].transactionType == $F("selTransactionTypeInputVat") 
								&& objInputVatRows[a].payeeClassCd == $F("selPayeeClassCdInputVat") 
								&& objInputVatRows[a].payeeNo == $F("hidPayeeNoInputVat") 
								&& (objInputVatRows[a].referenceNo == $F("txtReferenceNoInputVat")
								&& objInputVatRows[a].referenceNo != curRefNo)
								&& objInputVatRows[a].recordStatus != -1){
							ok = false;
							$("txtReferenceNoInputVat").clear();
							customShowMessageBox("Reference No. must be unique for every transaction type and payee.", imgMessage.ERROR, "txtReferenceNoInputVat");
							$break;
						}
					} else{
						//if adding new record
						if (objInputVatRows[a].referenceNo == $F("txtReferenceNoInputVat")
								&& objInputVatRows[a].recordStatus != -1){
							ok = false;
							$("txtReferenceNoInputVat").clear();
							customShowMessageBox("Reference No. must be unique for every transaction type and payee.", imgMessage.ERROR, "txtReferenceNoInputVat");
							$break;
						}
					}	
 				}	
			}
			return ok;
		}catch (e) {
			showErrorMessage("validateReferenceNo", e);
			//showMessageBox("Error validating reference no., "+e.message, imgMessage.ERROR);
		}
	}

	//compute the total amount in table
	function computeTotalAmountInTable(){
		try{
			var total = 0;
			var total2 = 0;
			var total3 = 0;
			for(var a=0; a<objInputVatRows.length; a++){
				if (objInputVatRows[a].recordStatus != -1){
					var baseAmt = objInputVatRows[a].baseAmt.replace(/,/g, "");	
					var inputVatAmt = objInputVatRows[a].inputVatAmt.replace(/,/g, "");
					var disbursementAmt = parseFloat((baseAmt == "" || baseAmt == null ? 0 :baseAmt)) + parseFloat((inputVatAmt == "" || inputVatAmt == null ? 0 :inputVatAmt));
					total = parseFloat(total) + parseFloat((disbursementAmt == "" || disbursementAmt == null ? 0 :disbursementAmt));
					total2 = parseFloat(total2) + parseFloat((baseAmt == "" || baseAmt == null ? 0 :baseAmt));
					total3 = parseFloat(total3) + parseFloat((inputVatAmt == "" || inputVatAmt == null ? 0 :inputVatAmt));
				}
			}	
			
			$("txtTotalDisbAmt").value = (formatCurrency(total).truncate(13, "..."));
			$("txtTotalBaseAmt").value = (formatCurrency(total2).truncate(13, "..."));
			$("txtTotalInputVatAmt").value = (formatCurrency(total3).truncate(13, "..."));
		} catch(e){
			showErrorMessage("computeTotalAmountInTable", e);
			//showMessageBox("Error in Input VAT page, "+e.message, imgMessage.ERROR);
		}	
	}	
	
	//action for HOME
	$("home").observe("click", function(){
		if(changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function(){
	   		lastAction = function(){
  				goToModule("/GIISUserController?action=goToHome", "Home");
  			};
  			saveInputVat();
			}, function(){
				changeTag = 0;
				goToModule("/GIISUserController?action=goToHome", "Home");;
			}, "");
		} else {
			goToModule("/GIISUserController?action=goToHome", "Home");
		}
	});

	clearForm();
	observeAcctCodeInputVat();
	
	window.scrollTo(0,0); 	
	hideNotice("");
	
	initializeChangeTagBehavior(saveInputVat); 
	
	observeAccessibleModule(accessType.BUTTON, "GICLS150", "btnPayeeMaintenanceInputVat", function(){
		objCLMGlobal.callingForm = "GIACS039"; 
		$("mainNav").hide();
		$("outerDiv").hide();
		$("directTransMainDiv").hide();
		$("dummyClaimPayeeDiv").show();
		showMenuClaimPayeeClass(null, null);
	});//added by steven 09.22.2014
	
	// andrew - 08.15.2012 SR 0010292
	function disableGIACS039(){
		try {
			$("selTransactionTypeInputVat").disable();
			$("selPayeeClassCdInputVat").disable();
			$("selItemNoInputVat").disable();
			$("selTransactionTypeInputVat").removeClassName("required");
			$("selPayeeClassCdInputVat").removeClassName("required");
			$("selItemNoInputVat").removeClassName("required");
			$("txtPayeeNameInputVat").removeClassName("required");
			$("payeeNameDiv").removeClassName("required");
			disableSearch("payeeInputVatDate");			
			$("txtReferenceNoInputVat").removeClassName("required");
			$("txtReferenceNoInputVat").readOnly = true;
			$("txtDisbAmtInputVat").removeClassName("required");
			$("txtDisbAmtInputVat").readOnly = true;
			$("txtBaseAmtInputVat").removeClassName("required");
			$("txtBaseAmtInputVat").readOnly = true;
			
			$("txtGlAcctCategoryInputVat").removeClassName("required");
			$("txtGlAcctCategoryInputVat").readOnly = true;
			$("txtGlControlAcctInputVat").removeClassName("required");
			$("txtGlControlAcctInputVat").readOnly = true;
			$("txtGlSubAcct1InputVat").removeClassName("required");
			$("txtGlSubAcct1InputVat").readOnly = true;
			$("txtGlSubAcct2InputVat").removeClassName("required");
			$("txtGlSubAcct2InputVat").readOnly = true;
			$("txtGlSubAcct3InputVat").removeClassName("required");
			$("txtGlSubAcct3InputVat").readOnly = true;
			$("txtGlSubAcct4InputVat").removeClassName("required");
			$("txtGlSubAcct4InputVat").readOnly = true;
			$("txtGlSubAcct5InputVat").removeClassName("required");
			$("txtGlSubAcct5InputVat").readOnly = true;
			$("txtGlSubAcct6InputVat").removeClassName("required");
			$("txtGlSubAcct6InputVat").readOnly = true;
			$("txtGlSubAcct7InputVat").removeClassName("required");
			$("txtGlSubAcct7InputVat").readOnly = true;
			$("txtRemarksInputVat").readOnly = true;	
			$("readOnlyTransactionTypeInputVat").removeClassName("required");
			$("readOnlyPayeeClassCdInputVat").removeClassName("required");
			$("readOnlyItemNoDescInputVat").removeClassName("required");
			$("readOnlyVatSlCdDescInputVat").removeClassName("required");
			disableSearch("acctCodeInputVatDate");
			disableSearch("slCdInputVatDate");
			disableButton("btnAddInputVat");
			disableButton("btnPayeeMaintenanceInputVat"); //added by Robert SR 5189 12.22.15
		} catch(e){
			showErrorMessage("disableGIACS039", e);
		}
	}
	//added cancelOtherOR by robert 10302013
	if(objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y"){
		disableGIACS039();
	}
	
	$("acExit").stopObserving("click"); 
	$("acExit").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveOutFaculPremPayts();
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
					}, function(){
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
		}
	});
	
	function enableGlstSLName(param){
		if (param){
			$("txtSlNameInputVat").addClassName("required");	
			$("txtSlNameInputVatDiv").addClassName("required");
			$("txtSlNameInputVat").setStyle({backgroundColor: '#FFFACD'});
			$("txtSlNameInputVatDiv").setStyle({backgroundColor: '#FFFACD'});
			enableSearch("slCdInputVatDate");
		}else{
			$("txtSlNameInputVat").removeClassName("required");
			$("txtSlNameInputVatDiv").removeClassName("required");
			$("txtSlNameInputVat").setStyle({backgroundColor: 'white'});
			$("txtSlNameInputVatDiv").setStyle({backgroundColor: 'white'});
			disableSearch("slCdInputVatDate");
		}		
	}	
	
	enableGlstSLName(false);
</script>