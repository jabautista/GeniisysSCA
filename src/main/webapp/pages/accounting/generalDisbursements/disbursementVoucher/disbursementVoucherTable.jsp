<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>

<div id="memoListMainDiv" name="memoListMainDiv">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Disbursement Voucher Listing</label>
			<!-- <input type="hidden" id="hidFundCd" name="hidFundCd"  />
			<input type="hidden" id="hidBranchCd" name="hidBranchCd"  /> -->
		</div>
	</div>
	
	<div id="dvListTableGridSectionDiv" class="sectionDiv" style="height: 420px;">	
		<div style="height: 30px; padding: 10px 5px 0px 5px;">
			<table align="center"">
				<tr>
					<c:forEach items="${dvFlagList}" var="dvFlag">
						<td>
							<c:if test="${dvFlag.rvLowValue eq 'N'}">
								<input type="radio" name="dvFlagRG" id="dvFlag${dvFlag.rvLowValue}" value="${dvFlag.rvLowValue}" style="margin: 0 0 0 5px; float: left;" checked="checked"/>
							</c:if>
							<c:if test="${dvFlag.rvLowValue ne 'N'}">
								<input type="radio" name="dvFlagRG" id="dvFlag${dvFlag.rvLowValue}" value="${dvFlag.rvLowValue}" style="margin: 0 0 0 5px; float: left;"/>
							</c:if>
							<label style="margin: 0 25px 0 5px;" for="dvFlag${dvFlag.rvLowValue}">${dvFlag.rvMeaning}</label>
						</td>
					</c:forEach>
				</tr>
			</table>
		</div>
		<div id="dvListTableGridDiv" style="padding: 10px;">
			<div id="dvListTableGrid" style="height: 310px; width: 900px;"></div>
		</div>
	</div>
</div>

<script type="text/javascript">

	//setModuleId("GIACS002"); - andrew, this listing has no moduleId
	setModuleId(null);
	setDocumentTitle("Disbursement Voucher Listing");
	clearObjectValues(objACGlobal);
	
	var dvFlagRB = "N";
	var selectedIndex = null;
	var selectedRow = null;
	objGIACS002.dvTag = null;
	try {
		//var cancelFlag = '${cancelFlag}';
		objGIACS002.branchCd = (objGIACS002.branchCd == "" || objGIACS002.branchCd == null) ? '${defaultBranchCd}' : objGIACS002.branchCd;
		objGIACS002.fundCd = (objGIACS002.fundCd == "" || objGIACS002.fundCd == null) ? '${defaultFundCd}' : objGIACS002.fundCd;
		objACGlobal.branchCd = objGIACS002.branchCd;
		objACGlobal.fundCd = objGIACS002.fundCd;
		
		var objDVArray = [];
		var objDV = new Object();
		objDV.objDVListTableGrid = JSON.parse('${disbVoucherList}'.replace(/\\/g, '\\\\'));
		objDV.objDVList = objDV.objDVListTableGrid.rows || [];
		
		var buttons1 = [MyTableGrid.ADD_BTN, MyTableGrid.EDIT_BTN, MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN];
		var buttons2 = [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN];
		var buttons = objGIACS002.cancelDV == "Y" ? buttons2 : buttons1;
		
		var disbVoucherTableModel = {
				url : contextPath + "/GIACDisbVouchersController?action=getGIACS002DisbVoucherList&refresh=1&fundCd="+encodeURIComponent(objACGlobal.fundCd)
								  + "&branchCd=" + encodeURIComponent(objACGlobal.branchCd)
								  + "&cancelFlag=" + encodeURIComponent(objGIACS002.cancelDV)
								  + "&dvFlagParam=" + dvFlagRB,
				options : {
					title :'',
					width : '900px',
					hideColumnChildTitle: true,
					onCellFocus: function(elemet, value, x, y, id){
						var mtgId = dvListTableGrid._mtgId;
						
						if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
							var row = dvListTableGrid.geniisysRows[y];
							setGlobalDVDetails(row);							
						}						
					},
					onRowDoubleClick : function(y){
						var row = dvListTableGrid.geniisysRows[y];
						objACGlobal.gaccTranId = row.gaccTranId;
						if (objACGlobal.gaccTranId == null) {
							showMessageBox("Please select a disbursement voucher first.", imgMessage.ERROR);
							return false;
						} else {
							setGlobalDVDetails(row);
							showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
						}
					},
					toolbar : {
						elements : buttons,
						onAdd : function(){
							showDisbursementVoucherPage(objGIACS002.cancelDV, "showGenerateDisbursementVoucher");
						},
						onEdit : function(){
							if(objACGlobal.gaccTranId != null){
								showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
							} else {
								showMessageBox("Please select a disbursement voucher first.", "I");
							}
						}
					}
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
								    id: 'gaccTranId',
								    width: '0',
									visible: false
								},
								{
								    id: 'gibrGfunFundCd',
								    width: '0',
								    visible: false
								},
								{
									id: 'gibrBranchCd',
									width: '0',
									visible: false
								},
								{
									id: 'dvTag',
									align: 'center',
									width: 25,
									sortable: true,
									altTitle: 'DV Tag' //added by robert SR 5190 12.02.15
								},
								{
									id: 'dvDate',
									title: 'DV Date',
									width: 80,
									align : 'center',
									titleAlign: 'center',
									filterOption: true,
									filterOptionType: 'formattedDate',
									sortable: true,
									geniisysClass: 'date',
									renderer: function(value){
										return dateFormat(value, 'mm-dd-yyyy');
									}
								},
								/* {
									id: 'dvPrefSuf',
									title: 'DV Status',
									width: '100px',
									filterOption: true,
									sortable: true
								}, */
								{
									id: 'dvPref dvNo',
									title: 'DV No.',
									//width: 100, //removed by robert SR 5190 01.04.2016
									sortable: true,
									children: [
											{
												id: 'dvPref',
												title: 'DV Pref Suf',
												width: 50,
												filterOption: true
											},
											{
												id: 'dvNo',
												title: 'DV No',
												align: 'right',
												width: 54,
												filterOption: true
											}
									]
								},
								{
									id: 'dvFlag',
									title: 'DV Status',
									align: 'center',
									width: 60,
									filterOption: true,
									sortable: true
								},
   							    { //added by robert SR 5190 12.02.15
									id: 'paytReqNo',
									title: 'Request No.',
									width: 175,
									filterOption: true,
									sortable: true,
									renderer : function(value){
										return escapeHTML2(value);
									}
								},
								{
								    id: 'payee',
								    title: 'Payee',
								    width: 300,
									filterOption: true,
									sortable: true,
									renderer : function(value){
										return escapeHTML2(value);
									}
								},
								{
								    id: 'particulars',
								    title: 'Particulars',
								    width: 300,
									filterOption: true,
									sortable: true,
									renderer : function(value){
										return escapeHTML2(value); //return unescapeHTML2(value);
									}
								},
								{
									id: 'dvAmt', //Added by Jerome Bautista 09.09.2015 SR 17733
									title: 'DV Amount',
									width: 90,
									geniisysClass: 'money',
									align: 'right',
									filterOption: true,
									filterOptionType: 'number',
									sortable: true
								}
					],
				resetChangeTag : true,
				rows : objDV.objDVList
		};
		dvListTableGrid = new MyTableGrid(disbVoucherTableModel);
		dvListTableGrid.pager = objDV.objDVListTableGrid;
		dvListTableGrid.render('dvListTableGrid');
		
	}catch(e){
		showErrorMessage("disbursementVoucherTable.jsp", e);
	}
	
	function setGlobalDVDetails(dvRow) {
		objACGlobal.gaccTranId 		= dvRow.gaccTranId;
		objACGlobal.branchCd		= dvRow.gibrBranchCd;
		objACGlobal.fundCd			= dvRow.gibrGfunFundCd;
		objACGlobal.callingForm		= "dvListing";
		objACGlobal.dvTag			= dvRow.dvTag == "*" ? "M" : dvRow.dvTag;
	}

	function resetUsedGlobalValues(){
		objACGlobal.gaccTranId 		= null;
		objACGlobal.branchCd		= null;
		objACGlobal.fundCd			= null;
		objACGlobal.callingForm		= "dvListing";
	}
	
	function executeQuery(){
		dvListTableGrid.url = contextPath + "/GIACDisbVouchersController?action=getGIACS002DisbVoucherList&refresh=1&fundCd="+encodeURIComponent(objACGlobal.fundCd)
							  + "&branchCd=" + encodeURIComponent(objACGlobal.branchCd)
							  + "&cancelFlag=" + encodeURIComponent(objGIACS002.cancelDV)
							  + "&dvFlagParam=" + dvFlagRB;
		dvListTableGrid._refreshList();
	}
	
	$$("input[name='dvFlagRG']").each(function(rb){
		rb.observe("click", function(){
			dvFlagRB = rb.value;
			executeQuery();
		});
	});
	
	$("acExit").stopObserving();
	$("acExit").observe("click", function(){
		objACGlobal.branchCd = ""; 	// shan 10.04.2014
		objGIACS002.branchCd = "";	// shan 10.04.2014
		if(objAC.fromMenu == "menuOtherBranchCancelDV" || objAC.fromMenu == "menuOtherBranchDVListing") {
			showOtherBranchRequests();
		} else {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	});
</script>