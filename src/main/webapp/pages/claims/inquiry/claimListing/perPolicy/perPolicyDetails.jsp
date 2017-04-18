<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>    
<div id="clmPerPolicyDetailsGrid" style="height: 306px; width: 887px; margin: 10px 0 30px 12px; "></div>
<div>
	<table cellpadding="0" align="center" style="width: 887px; margin-bottom: 2px;">
		<tr id="trOne">
			<td style="width: 140px;"><input type="button" class="disabledButton" id="btnRecDtl" name="btnRecDtl" value="Recovery Details" style="width: 140px;" /></td>
			<td class="rightAligned" style="width: 133px;"> Totals :&nbsp;</td>
			<td style="width: 115px;"><input style="width: 137px;" id="txtTotLossResAmt" name="txtTotLossResAmt" type="text" readOnly="readonly" class="money" tabindex="201" /></td>
			<td style="width: 135px;"><input style="width: 137px;" id="txtTotExpResAmt" name="txtTotExpResAmt" type="text" readOnly="readonly" class="money" tabindex="202" /></td>
			<td style="width: 135px;"><input style="width: 137px;" id="txtTotLossPdAmt" name="txtTotLossPdAmt" type="text" readOnly="readonly" class="money" tabindex="203" /></td>
			<td><input style="width: 137px;" id="txtTotExpPdAmt" name="txtTotExpPdAmt" type="text" readOnly="readonly" class="money" tabindex="204" /></td>
		</tr>
		<tr id="trTwo">
			<td style="width: 140px;"><input type="button" class="disabledButton" id="btnRecDtl" name="btnRecDtl" value="Recovery Details" style="width: 140px;" /></td>
			<td class="rightAligned" style="width: 235px;"> Totals :&nbsp;</td>
			<td style="width: 85px;"><input style="width: 111px;" id="txtTotLossResAmt" name="txtTotLossResAmt" type="text" readOnly="readonly" class="money" tabindex="201"/></td>
			<td style="width: 105px;"><input style="width: 111px;" id="txtTotExpResAmt" name="txtTotExpResAmt" type="text" readOnly="readonly" class="money" tabindex="202"/></td>
			<td style="width: 105px;"><input style="width: 111px;" id="txtTotLossPdAmt" name="txtTotLossPdAmt" type="text" readOnly="readonly" class="money" tabindex="203"/></td>
			<td><input style="width: 111px;" id="txtTotExpPdAmt" name="txtTotExpPdAmt" type="text" readOnly="readonly" class="money" tabindex="204"/></td>
		</tr>
		<tr>
			<td colspan="6">
				<div id="clmPerPolicyDetails" class="sectionDiv" style="margin-top: 10px;">
					<table align="center" style="margin: 5px auto 5px auto;">
						<tr>
							<td class="leftAligned" style="width: 105px;">Entry Date</td>
							<td class="rightAligned"><input style="width: 180px;" id="txtNbtEntryDate" name="txtNbtEntryDate" type="text" readOnly="readonly" tabindex="301"/></td>
							<td style="width: 100px;"></td>
							<td class="leftAligned" style="width: 105px;">Loss Date</td>
							<td class="rightAligned"><input style="width: 180px;" id="txtNbtDsplossDate" name="txtNbtDsplossDate" type="text" readOnly="readonly" tabindex="303"/></td>
						</tr>
						<tr>
							<td class="leftAligned">Claim Status</td>
							<td class="rightAligned"><input style="width: 180px;" id="txtNbtDspClamStat" name="txtNbtDspClamStat" type="text" readOnly="readonly" tabindex="302"/></td>
							<td></td>
							<td class="leftAligned">Claim File Date</td>
							<td class="rightAligned"><input style="width: 180px;" id="txtNbtClmFileDate" name="txtNbtClmFileDate" type="text" readOnly="readonly" tabindex="304"/></td>
						</tr>
					</table>
				</div>
				<div style="float: left; width: 100%; margin: 8px 0 6px 0;" align="center">
					<input type="button" class="disabledButton" id="btnPrintClmPerpolicy" value="Print Report" tabindex="501"/>
				</div>
			</td>
		</tr>	
	</table>
</div>
<script type="text/javascript">
try{
	//Initialize
	initializeAll();
	
	var c003Grid = JSON.parse('${perPolicyDetailsTG}'.replace(/\\/g, '\\\\'));
	var c003 = c003Grid.rows || [];
	var currXX = null;
	var currYY = null;
	var currRow = null;
	
	var perPolicyDetailsTM = {
			url: contextPath+"/GICLClaimsController?action=getClaimsPerPolicyDetails"+
					"&lineCd=" + $F("txtNbtLineCd")+
					"&sublineCd=" + $F("txtNbtSublineCd")+
					"&polIssCd=" + $F("txtNbtPolIssCd")+
					"&issueYy=" + $F("txtNbtIssueYy")+
					"&polSeqNo=" + $F("txtNbtPolSeqNo")+
					"&renewNo=" + $F("txtNbtRenewNo")+
					"&module=GICLS250"+
					"&refresh=1",
			options:{
				hideColumnChildTitle: true,
				title: '',
				newRowPosition: 'bottom',
				onCellFocus: function(element, value, x, y, id){
					currXX = Number(x);
					currYY = Number(y);
					populatePerPolicyDetails(perPolicyDetailsTG.getRow(currYY));
				},
				onRemoveRowFocus: function ( x, y, element) {
					currXX = null;
					currYY = null;
					populatePerPolicyDetails(null);
				},
				toolbar:{
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN]
				}	
			},
			columnModel: [
				{
				    id: 'recordStatus',
				    title : '',
		            width: '0',
		            visible: false,
		            editor: "checkbox"
				},
				{
					id: 'divCtrId',
					width: '0',
					visible: false
				},
				{
					id: 'giclClmReserveExist',
              		title : '&nbsp;R',
              		altTitle: 'With Recovery',
	              	width: '25',
	              	editable: false,
	              	sortable: false,
	              	visible: true,
	              	defaultValue: false,
					otherValue:	false,
					filterOption: true,
					filterOptionType: 'checkbox',
					editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}else{
								return "N";	
		            		}	
		            	} 
		            })
              	}, 
				{
				    /* id: 'lineCode sublineCd policyIssueCode claimYy claimSequenceNo', */
				    id: 'lineCode sublineCd issueCode claimYy claimSequenceNo',
				    title: 'Claim Number',
				    width : '256px',
				    children : [
			            {
			                id : 'lineCode',
			                title: 'Line Code',
			                width: 38/* ,
			                filterOption: true */
			            },
			            {
			                id : 'sublineCd', 
			                title: 'Subline Code',
			                width: 68/* ,
			                filterOption: true */
			            },
			            {
			                /* id : 'policyIssueCode', */
			                id : 'issueCode',
			                title: 'Issue Code',
			                width: 38,
			                filterOption: true
			            },
			            {
			                id : 'claimYy',
			                title: 'Claim Year',
			                type: "number",
			                align: "right",
			                width: 38,
			                filterOption: true,
				            filterOptionType: 'number', 
			                renderer: function (value){
								return nvl(value,'') == '' ? '' :formatNumberDigits(value,2);
							}
			            },
			            {
			                id : 'claimSequenceNo',
			                title: 'Claim Sequence No.',
			                type: "number",
			                align: "right",
			                width: 76,
			                filterOption: true,
				            filterOptionType: 'number', 
			                renderer: function (value){
								return nvl(value,'') == '' ? '' :formatNumberDigits(value,7);
							}
			            }
					]
				},
				{
					id: 'plateNumber',
					title: 'Plate No.',
					width: '0', 
					visible: false
				},
				{
					id: 'serialNumber',
					title: 'Serial No.',
					width: '0', 
					visible: false
				},
				{
					id: 'claimFileDate',
					title: 'Claim File Date',
					width: '0',
					type: 'date',
					format: "mm-dd-yyyy",
					visible: false
				},
				{
					id: 'entryDate',
					title: 'Entry Date',
					width: '0',
					type: 'date',
					format: "mm-dd-yyyy",
					filterOption: true,
		            filterOptionType: 'date',
					visible: false
				},
				{
					id: 'dspLossDate',
					title: 'Loss Date',
					width: '0',
					type: 'date',
					format: "mm-dd-yyyy",
					visible: false
				},
				{
					id: 'clmStatDesc',
					title: 'Claim Status',
					width: '0',
					filterOption: true,
					visible: false
				},
				{
				    id: 'claimId',
				    title: '',
				    width: '0',
				    visible: false
				},
				{
					id: 'lossResAmount',
					title : 'Loss Reserve',
					width: '140',
					type: "number",
					geniisysClass: "money",
					filterOption: true,
		            filterOptionType: 'number',
					visible: true
				},
				{
					id: 'expenseResAmount',
					title : 'Expense Reserve',
					width: '140',
					type: "number",
					geniisysClass: "money",
					filterOption: true,
		            filterOptionType: 'number',
					visible: true
				},
				{
					id: 'lossPaidAmount',
					title : 'Losses Paid',
					width: '140',
					type: "number",
					geniisysClass: "money",
					filterOption: true,
		            filterOptionType: 'number',
					visible: true
				},
				{
					id: 'expPaidAmount',
					title : 'Expenses Paid',
					width: '140',
					type: "number",
					geniisysClass: "money",
					filterOption: true,
		            filterOptionType: 'number',
					visible: true
				},
				{
					id: 'totLossResAmount',
					title : 'Total Loss Reserve',
					width: '0',
					type: "number",
					geniisysClass: "money",
					visible: false
				},
				{
					id: 'totExpenseResAmount',
					title : 'Total Expense Reserve',
					width: '0',
					type: "number",
					geniisysClass: "money",
					visible: false
				},
				{
					id: 'totLossPaidAmount',
					title : 'Total Losses Paid',
					width: '0',
					type: "number",
					geniisysClass: "money",
					visible: false
				},
				{
					id: 'totExpPaidAmount',
					title : 'Total Expenses Paid',
					width: '0',
					type: "number",
					geniisysClass: "money",
					visible: false
				}
			],
			resetChangeTag: true,
			rows: c003,
			id: 1
	};

	
	
	if ($F("txtNbtLineCd") == objLineCds.MC){ 
		//will display plate no. and serial no. if line code = MC
		perPolicyDetailsTM.columnModel[3].width = '216px';
		perPolicyDetailsTM.columnModel[3].children[1].width = 40;
		perPolicyDetailsTM.columnModel[3].children[4].width = 50;
		perPolicyDetailsTM.columnModel[4].width = '70';
		perPolicyDetailsTM.columnModel[4].visible = true;
		perPolicyDetailsTM.columnModel[5].width = '120';
		perPolicyDetailsTM.columnModel[5].visible = true;
		perPolicyDetailsTM.columnModel[11].width = '105';
		perPolicyDetailsTM.columnModel[12].width = '105';
		perPolicyDetailsTM.columnModel[13].width = '105';
		perPolicyDetailsTM.columnModel[14].width = '105';
		$("trOne").remove();
	}else{
		$("trTwo").remove();
	}	
	
	perPolicyDetailsTG = new MyTableGrid(perPolicyDetailsTM);
	perPolicyDetailsTG.pager = c003Grid;
	perPolicyDetailsTG._mtgId = 1;
	perPolicyDetailsTG.afterRender = function(){
		populatePerPolicyDetails(null);
		if (perPolicyDetailsTG.rows.length > 0){
			currYY = Number(0);
			var obj = perPolicyDetailsTG.getRow(currYY);
			$("txtTotLossResAmt").value 	= nvl(obj,null) != null ? nvl(obj.totLossResAmount,null) != null ? formatCurrency(obj.totLossResAmount) :null :null;
			$("txtTotExpResAmt").value 		= nvl(obj,null) != null ? nvl(obj.totExpenseResAmount,null) != null ? formatCurrency(obj.totExpenseResAmount) :null :null;
			$("txtTotLossPdAmt").value 		= nvl(obj,null) != null ? nvl(obj.totLossPaidAmount,null) != null ? formatCurrency(obj.totLossPaidAmount) :null :null;
			$("txtTotExpPdAmt").value 		= nvl(obj,null) != null ? nvl(obj.totExpPaidAmount,null) != null ? formatCurrency(obj.totExpPaidAmount) :null :null;
			enableButton("btnPrintClmPerpolicy");
			enableToolbarButton("btnToolbarPrint");
			setFieldsToReadOnly(true);
			disableToolbarButton("btnToolbarExecuteQuery");
			disableSearchIcons(true);
			disableDate("hrefNbtAsOfDate");
			disableDate("hrefNbtFromDate");
			disableDate("hrefNbtToDate");
			$("rdoDateBtn1").disable();
			$("rdoDateBtn2").disable();
			objCLM.giclClmReserveExist = obj.giclClmReserveExist;
		} else {
			if($("txtNbtAssuredName").value != ""){
				customShowMessageBox("Query caused no records to be retrieved. Re-enter.", imgMessage.INFO, "txtNbtLineCd");
				setFieldsToReadOnly(true);
				disableSearchIcons(true);
				disableButton("btnPrintClmPerpolicy");
				disableToolbarButton("btnToolbarPrint");
				disableToolbarButton("btnToolbarExecuteQuery");
			}
		}
			
	};	
	perPolicyDetailsTG.render('clmPerPolicyDetailsGrid');

	function populatePerPolicyDetails(obj){
		currRow = obj;
		$("txtNbtEntryDate").value 		= nvl(obj,null) != null ? nvl(obj.entryDate,null) != null ? dateFormat(obj.entryDate, "mm-dd-yyyy") :null :null;
		$("txtNbtDsplossDate").value 	= nvl(obj,null) != null ? nvl(obj.dspLossDate,null) != null ? dateFormat(obj.dspLossDate, "mm-dd-yyyy") :null :null;
		$("txtNbtDspClamStat").value 	= nvl(obj,null) != null ? nvl(obj.clmStatDesc,null) :null;
		$("txtNbtClmFileDate").value 	= nvl(obj,null) != null ? nvl(obj.claimFileDate,null) != null ? dateFormat(obj.claimFileDate, "mm-dd-yyyy") :null :null;
		
		if (nvl(obj,null) != null){
			if (nvl(obj.giclClmReserveExist,"N") == "Y"){
				enableButton("btnRecDtl");
			}else{
				disableButton("btnRecDtl");
			}	
		}else{
			disableButton("btnRecDtl");
		}	
		perPolicyDetailsTG.keys.releaseKeys();
	}
	
	function showRecoveryDetails() {
		try {
		overlayRecoveryDetails = 
			Overlay.show(contextPath+"/GICLClaimListingInquiryController", {
				urlContent: true,
				urlParameters: {action : "showRecoveryDetails",																
								ajax : "1",
								claimId : objRecovery.claimId
				},
			    title: "Recovery Details",
			    height: 500,
			    width: 820,
			    draggable: true
			});
		} catch (e) {
			showErrorMessage("overlay error: " , e);
		}
	}
	
	/* function showClmRecoveryDetails(claimId){
		overlayClmRecoveryDetails = Overlay.show(contextPath+"/GICLClmRecoveryController", {
			urlContent: true,
			urlParameters: {action : "showClmRecoveryDetails", 
							claimId: claimId
							},
			title: "Recovery Details",	
			id: "clm_recovery_details_view",
			width: 830,
			height: 445,
		    draggable: false,
		    closable: true
		});
	}  */
	
	$("btnPrintClmPerpolicy").observe("click", function(){
		showGenericPrintDialog("Print Claim Listing / Recovery Listing  per Policy", objCLM.checkReport, objCLM.addCheckbox, true);
	});
	
	$("btnRecDtl").observe("click", function(){
		if (nvl(currRow,null) == null) return;
		showNotice("Loading, please wait...");
		objRecovery = new Object();
		objRecovery.claimId = currRow.claimId;
		showRecoveryDetails();
	});

	hideNotice("");
}catch(e){
	showErrorMessage("Per Policy Details page", e);	
}	
</script>	