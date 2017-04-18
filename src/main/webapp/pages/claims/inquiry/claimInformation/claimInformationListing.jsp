<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>
<div id="claimPaymentMainDiv">
</div>
<div id="claimInfoListingMainDiv" name="claimInfoListingMainDiv" module="claimInfoListing">
	<div id="claimInfoListingMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="claimInfoListingExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Claim Information for ${lineName}</label>
			<input type="hidden" id="lineCd" name="lineCd" value="${lineCd}">
			<input type="hidden" id="menuLineCd" name="menuLineCd" value="${menuLineCd}">
			<input type="hidden" id="ora2010Sw" name="ora2010Sw" value="${ora2010Sw}">
		</div>
	</div>
	
	<div id="claimInfoTableGridSectionDiv" class="sectionDiv">
		<div id="claimInfoTableGridDiv" style="padding: 10px;">
			<div id="claimInfoTableGrid" style="height: 310px; width: 900px;"></div>
		</div>
		<div style="margin: 30px; margin-bottom: 15px;">
			<table cellspacing="2" border="0">
	 			<tr>
	 				<td class="rightAligned" style="width: 100px;">Assured Name </td>
					<td class="leftAligned">
						<input id="txtAssuredName" name="txtAssuredName" type="text" style="width: 330px;" value="" readonly="readonly" />
					</td>
					<td id="lblPackPolicy" class="rightAligned" style="width: 180px;">Package Policy Number</td>
					<td class="leftAligned" style="width: 230px;">
						<input id="txtPackagePolicyNo" style="width: 230px;" type="text" value="" readonly="readonly" />
					</td>
				</tr>
				<tr id="rowAssignee" style="display: none;">
	 				<td id="lblAssignee" class="rightAligned" style="width: 100px;">Assignee </td>
					<td class="leftAligned">
						<input id="txtAssignee" name="txtAssignee" type="text" style="width: 330px;" value="" readonly="readonly" />
					</td>
				</tr>
			</table>
		</div>
		<div>
			<table align="center" style="margin-bottom: 20px;">
				<tr>
					<td><input type="button" class="button" id="btnClaimDetails" name="btnClaimDetails" value="Claim Details" style="width: 125px;" /></td>
					<td><input type="button" class="button" id="btnClaimPayment" name="btnClaimPayment" value="Claim Payment" style="width: 125px;" /></td>
					<!-- SR-19555 : shan 07.07.2015 -->
					<td><input type="button" class="button" id="btnClaimNotes" name="btnClaimNotes" value="Notes" style="width: 100px;" /></td><td>
				</tr>
			</table>
		</div>
	</div>
</div>
<div id="claimInfoMainDiv"></div>
<div id="mcEvaluationReportInquiryDiv"></div>
<script type="text/javascript">
	setModuleId("GICLS260");
	setDocumentTitle("Claim Information");
	var selectedRecord = null;
	$("claimPaymentMainDiv").hide();
	
	try{
		var objClaimInfo = new Object();
		objClaimInfo.objClaimInfoTableGrid = JSON.parse('${jsonClaimInfoTableGrid}');
		objClaimInfo.objClaimInfoList = objClaimInfo.objClaimInfoTableGrid.rows || [];

		var claimInfoTableModel = {
			url: contextPath+"/GICLClaimsController?action=getClaimInformationTableGrid&lineCd="+encodeURIComponent($F("lineCd"))+"&claimId="+ nvl(objCLMGlobal.claimId,""), //added by gab 04.16.2016 SR 21964
			options:{
				title: '',
				width: '900px',
				onCellFocus: function(element, value, x, y, id){
					var obj = claimInfoTableGrid.geniisysRows[y];
					populateClaimInfoFields(obj);
					claimInfoTableGrid.keys.releaseKeys();
					selectedRecord = obj;
				},
				onRemoveRowFocus: function(){
					populateClaimInfoFields(null);
					claimInfoTableGrid.keys.releaseKeys();
					selectedRecord = null;
				},
				onRowDoubleClick: function(y){
					var obj = claimInfoTableGrid.geniisysRows[y];
					viewClaimInformation(obj);
				},
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onRefresh: function(){
						claimInfoTableGrid.keys.releaseKeys();
					},
					onFilter: function(){
						claimInfoTableGrid.keys.releaseKeys();
					}
				}
			},
			columnModel: [
				{   id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	id: 'divCtrId',
					width: '0',
					visible: false
				},
				{
					id: 'claimId',
					title: 'claimId',
					width: '0px',
					sortable: false,
					visible: false
				},

				{
					id: 'lineCode',
					title: 'Line Code',
					width: '0px',
					sortable: false,
					visible: false,
					filterOption: false
				},
				
				{
					id: 'sublineCd',
					title: 'Subline Cd',
					width: '0px',
					sortable: false,
					visible: false,
					filterOption: true
				},

				{
					id: 'issueCode',
					title: 'Issue Code',
					width: '0px',
					sortable: false,
					visible: false,
					filterOption: true
				},

				{
					id: 'claimYy',
					title: 'Claim Year',
					width: '0px',
					sortable: false,
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},

				{
					id: 'claimSequenceNo',
					title: 'Claim Sequence No.',
					width: '0px',
					sortable: false,
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},

				{
					id: 'policyIssueCode',
					title: 'Policy Issue Code',
					width: '0px',
					sortable: false,
					visible: false,
					filterOption: true
				},
				{
					id: 'issueYy',
					title: 'Policy Issue Year',
					width: '0px',
					sortable: false,
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{
					id: 'policySequenceNo',
					title: 'Policy Sequence No.',
					width: '0px',
					sortable: false,
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},

				{
					id: 'renewNo',
					title: 'Renew No.',
					width: '0px',
					sortable: false,
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{
					id: 'dspLossDate',
					width: '0px',
					sortable: false,
					visible: false,
					filterOption: false 
				},
				{
					id: 'lossCatDes',
					width: '0px',
					sortable: false,
					visible: false,
					filterOption: false
				},
				{
					id: 'claimNo',
					title: 'Claim Number',
					width: $F("lineCd")== "MC" || $F("menuLineCd")== "MC"? '173px' : '213px',
					sortable: true,
					align: 'left'
				},
				{
					id: 'policyNo',
					title: 'Policy Number',
					width: $F("lineCd")== "MC" || $F("menuLineCd")== "MC"? '173px' : '213px',
					sortable: true,
					align: 'left'
				},
				{
					id: 'plateNumber',
					title: 'Plate Number',
					width: $F("lineCd")== "MC" || $F("menuLineCd")== "MC"? '110px' : '0px',
					sortable: true,
					align: 'left',
					filterOption: $F("lineCd")== "MC" || $F("menuLineCd")== "MC"? true : false,
					visible: $F("lineCd")== "MC" || $F("menuLineCd")== "MC"? true : false
				},
				{
					id: 'clmStatDesc',
					title: 'Status',
					width: $F("lineCd")== "MC" || $F("menuLineCd")== "MC"? '200px' : '230px',
					filterOption: true,
					sortable: true,
					align: 'left'
				},
				{
					id: 'claimFileDate',
					title: 'Claim File Date',
					width: '0px',
					filterOption: true,
					filterOptionType: 'formattedDate',
					type: 'date',
					visible: false
				},
				{
					id: 'lossDate',
					title: 'Loss Date',
					width: '0px',
					filterOption: true,
					filterOptionType: 'formattedDate',
					type: 'date',
					visible: false
				},
				//added by steven 06/03/2013;to handle the issue on formatting date.
				{
					id: 'sdfClaimFileDate',
					title: 'Claim File Date',
					width: '100px',
					sortable: true,
					align: 'center',
					titleAlign: 'center'
				},
				{
					id: 'sdfLossDate',
					title: 'Loss Date',
					width: '100px',
					sortable: true,
					align: 'center',
					titleAlign: 'center'
				},
				{//added by kenneth 12022014
					id: 'assuredName',
					title: 'Assured Name',
					filterOption: true,
					visible: false,
					width: '0px'
				},
			],
			requiredColumns: 'claimId claimNo policyNo',
			rows: objClaimInfo.objClaimInfoList	
		};
	
		claimInfoTableGrid = new MyTableGrid(claimInfoTableModel);
		claimInfoTableGrid.pager = objClaimInfo.objClaimInfoTableGrid;
		claimInfoTableGrid.render('claimInfoTableGrid');
		claimInfoTableGrid.afterRender = function(){
			selectedRecord = null;
			populateClaimInfoFields(null);
			claimInfoTableGrid.keys.releaseKeys();

		};
		
		$("claimInfoListingExit").observe("click", function (){
			if(objCLMGlobal.callingForm == "GIPIS100"){ //considered callingForm by gab SR 21694 05.24.16
				showPolicyMainInfoPage(objGIPIS100.policyId);
				setModuleId("GIPIS100");
				setDocumentTitle("View Policy Information");
				objCLMGlobal.callingForm = "GICLS260";
			}else if(objCLMGlobal.callingForm2 == "GIPIS110"){ //nieko kb 894 12152016
				$("blockAccumulationDiv").show();
				$("claimInfoDummyMainDiv").update("");
				setModuleId("GIPIS110");
				setDocumentTitle("Block Accumulation");
				objCLMGlobal.callingForm = "GICLS260";
			}else{
				objCLMGlobal.claimId = null;	// SR-19547 : shan 07.10.2015
				goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
			}
		});
		
		function populateClaimInfoFields(obj){
			$("txtAssuredName").value = obj == null ? "" : unescapeHTML2(obj.assuredName);
			$("txtAssignee").value 	  = obj == null ? "" : unescapeHTML2(obj.assignee);
			$("txtPackagePolicyNo").value = obj == null ? "" : unescapeHTML2(obj.packPolNo);
			
			if(obj == null || nvl(obj.packPolNo, null) == null){
				$("lblPackPolicy").innerHTML = "";
				$("txtPackagePolicyNo").hide();
			}else{
				$("lblPackPolicy").innerHTML = "Package Policy Number";
				$("txtPackagePolicyNo").show();
			}
			
			obj == null ? disableButton("btnClaimNotes") : enableButton("btnClaimNotes");	// SR-19555 : shan 07.07.2015
		}
		
		function viewClaimInformation(obj){
			objCLMGlobal.claimId = obj.claimId;
			if (objCLMGlobal.callingForm == "GIPIS100"){ //considered callingForm by robert SR 21694 03.28.16
				showClaimInformationMain("polMainInfoDiv");
			}else if (objCLMGlobal.callingForm == "GIPIS110"){
				objCLMGlobal.callingForm = "GICLS260";
				objCLMGlobal.callingForm2 = "GIPIS110";
				showClaimInformationMain("claimInfoMainDiv");
			}else{
				objCLMGlobal.callingForm = "GICLS260";
				showClaimInformationMain("claimInfoMainDiv");
			}
			claimInfoTableGrid.keys.releaseKeys();
		}
		
		$("btnClaimDetails").observe("click", function(){
			if(selectedRecord == null){
				showMessageBox("Please select a record first.", "I");
				return false;
			}else{
				viewClaimInformation(selectedRecord);
			}
		});
		
		function viewClaimPayment(obj){
			objCLMGlobal.claimId = obj.claimId;
			//objCLMGlobal.callingForm = "GICLS260"; removed by robert SR 21694 03.28.16 
			showClaimPayment();
		}
		
		$("btnClaimPayment").observe("click",function(){
			if(selectedRecord == null){
				showMessageBox("Please select a record first.", "I");
				return false;
			}else{
				viewClaimPayment(selectedRecord);
			}
		});
		
		populateClaimInfoFields(null);
		
		if($F("lineCd")== "MC" || $F("menuLineCd")== "MC"){
			$("rowAssignee").show();
			$("lblAssignee").innerHTML = "Assignee";
		}else if($F("lineCd")== "AC" || $F("menuLineCd")== "AC"){
			$("rowAssignee").show();
			$("lblAssignee").innerHTML = "Enrollee";
		}else{
			$("rowAssignee").hide();
			$("lblAssignee").innerHTML = "";
		}
		
		// SR-19555 : shan 07.07.2015
		$("btnClaimNotes").observe("click", function(){
			objCLMGlobal.claimId = selectedRecord.claimId;
			objCLMGlobal.callingForm = "GICLS260";
			showMiniReminder();
		});
		// end SR-19555
	}catch(e){
		showErrorMessage("claimInformationListing.jsp", e);
	}

</script>