<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>
<div id="noClaimListingMainDiv" name="noClaimListingMainDiv">
	<div id="noClaimListingMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="btnExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<!-- <form id="noClaimListingForm" name="noClaimListingForm"> -->
		<div id="noClaimListingFormDiv">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
					<label>Certificate of No Claim Listing</label>
					<input type="hidden" id="lineCd" name="lineCd" value="${lineCd}">
				</div>
			</div>
			<div id="noClaimListBLock" class="sectionDiv" style=" margin-bottom:30px; ">
				<div id="noClaimListMainDIv" style="padding: 10px;"  >
					<div id="noClaimListTableGridSectionDiv" style="height: 330px; ">
						<div id="noClaimListTableGridDiv">
							<div id="noClaimListTableGrid"></div>
						</div>			
					</div>
				</div>
			</div>
		</div>
	<!-- </form> -->
</div>

<script>
try{
	
	var objNoClm = new Object(); 
	var selectedNoClaim = null;
	var selectedNoClaimRow = new Object();
	var mtgId = null;
	objNoClm.noClaimListTableGrid = JSON.parse('${noClaimGrid}'.replace(/\\/g, '\\\\'));
	objNoClm.noClaim= objNoClm.noClaimListTableGrid.rows || [];
	var lineCd = objCLMGlobal.lineCd;
	
	try {
		var noClaimListingTable = {
			url: contextPath+"/GICLNoClaimController?action=getNoClaimList&lineCd="+lineCd+"&refresh=1",
			options: {
				title: '',
				width: '900px',
				height: '306px',
				onCellFocus: function(element, value, x, y, id) {
					mtgId = noClaimGrid._mtgId;
					if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")) {
						selectedNoClaimRow = noClaimGrid.geniisysRows[y];
						objCLMGlobal.noClaimId = selectedNoClaimRow.noClaimId;
					}
				},
				onRemoveRowFocus : function(){
					objCLMGlobal.noClaimId = null;
			  	},
				onRowDoubleClick: function(y){
					objCLMGlobal.noClaimId = selectedNoClaimRow.noClaimId;
					showNoClaimCertificate();
				},
				toolbar: {
					elements: [MyTableGrid.ADD_BTN , MyTableGrid.EDIT_BTN, MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onAdd: function(){
						objCLMGlobal = new Object();
						objCLMGlobal.lineCd = lineCd;
						showNoClaimCertificate();
					} ,
					onEdit: function(){
						if(objCLMGlobal.noClaimId == null){
							showMessageBox("Please select a record first.", "E");
						}else{
							showNoClaimCertificate();
						}
					}
					
				}
			},
			columnModel: [
				{   
					id: 'recordStatus',
				    width: '0',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	
					id: 'divCtrId',
					width: '0',
					visible: false
				},
				{	
					id: 'noClaimId',
					width: '0',
					visible: false
				},
				{	
					id: 'ncIssCd',
					width: '0',
					title: 'No Claim Issue Code',
					visible: false,
					filterOption: true
				},
				{	
					id: 'ncIssueYy',
					width: '0',
					title: 'No Claim Issue Year',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{	
					id: 'ncSeqNo',
					width: '0',
					title: 'No Claim Sequence No',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{	
					id: 'lineCd',
					width: '0',
					title: 'Line Code',
					visible: false
				},
				{	
					id: 'sublineCd',
					width: '0',
					title: 'Subline Code',
					visible: false,
					filterOption: true
				},
				{	
					id: 'issCd',
					width: '0',
					title: 'Issue Code',
					visible: false,
					filterOption: true
				},
				{	
					id: 'issueYy',
					width: '0',
					title: 'Issue Year',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{	
					id: 'polSeqNo',
					width: '0',
					title: 'Policy Sequence No',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{	
					id: 'renewNo',
					width: '0',
					title: 'Renew No',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{
					id: 'noClaimNo',
					title: 'No Claim No.',
					width: '157',
					titleAlign: 'left',
					align: 'left',
					editable: false
				},
				{
					id: 'policyNo',
					title: 'Policy No.',
					width: '215',
					titleAlign: 'left',
					align: 'left',
					editable: false
				},
				{
					id: 'assdName',
					title: 'Assured Name',
					width: '200',
					titleAlign: 'left',
					align: 'left',
					editable: false,
					filterOption: true
				},
				{
					id: 'strEffDate',
					title: 'Incept Date',
					width: '146',
					titleAlign: 'left',
					align: 'left',
					editable: false,
					renderer : function(value){
						return dateFormat(value, "mm-dd-yyyy hh:MM TT");
					}
				},
				{
					id: 'strExpiryDate',
					title: 'Expiry Date',
					width: '146',
					titleAlign: 'left',
					align: 'left',
					editable: false,
					renderer : function(value){
						return dateFormat(value, "mm-dd-yyyy hh:MM TT");
					}
				}
			],
			resetChangeTag: true,
			rows: objNoClm.noClaim
		};
		noClaimGrid = new MyTableGrid(noClaimListingTable);
		noClaimGrid.pager = objNoClm.noClaimListTableGrid;
		noClaimGrid.render('noClaimListTableGrid');
	}catch(e) {
		showErrorMessage("noClaimGrid", e);
	}
	
	$("btnExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
	});
	
	objCLMGlobal.noClaimId = null;
	setModuleId("GICLS026");
	
}catch(e){
	showErrorMessage("GICLS026 page", e);
}
</script>
