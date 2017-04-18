<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="ajax" uri="http://ajaxtags.org/tags/ajax" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="lossRecoveryListingMainDiv" name="lossRecoveryListingMainDiv">
	<div id="lossRecoveryMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="recoveryInformation">Recovery Information</a></li>
					<li><a id="recoveryDistribution">Recovery Distribution</a></li>
					<li><a id="generateRecoveryAcctEnt">Generate Recovery Acct. Entries</a></li>
					<li><a id="lossRecoveryExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="lossRecoveryListingDiv" name="lossRecoveryListingDiv"> <!-- inserted for ajax update-->
	
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label>Loss Recovery Listing</label>
			</div>
		</div>
		
		<div id="lossRecoveryTableGridSectionDiv" class="sectionDiv" style="height: 470px;"> <!-- 370 -->
			<div id="lossRecoveryTableGridDiv" style="padding: 10px;">
				<div id="lossRecoveryTableGrid" style="height: 324px; width: 900px;"></div> <!-- 250 -->
			</div>
			<div id="lossRecoveryAddtlInformationDiv" style="padding: 10px; margin-top: 10px;">
				<table cellspacing="2" border="0" style="margin-left: 90px; margin-top: 15px;">				
		 			<tr>
						<td class="rightAligned" style="width: 100px;">Loss Date</td>
						<td class="leftAligned">
							<input id="txtLossDate" name="txtLossDate" type="text" style="width: 210px;" value="" readonly="readonly" />
						</td>
						<td class="rightAligned" style="width: 100px;">Loss Category</td>
						<td class="leftAligned">
							<input id="txtLossCatDesc" name="txtLossCatDesc" type="text" style="width: 210px;" value="" readonly="readonly" />
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 100px;">File Date</td>
						<td class="leftAligned">
							<input id="txtFileDate" name="txtFileDate" type="text" style="width: 210px;" value="" readonly="readonly" />
						</td>
						<td class="rightAligned" style="width: 100px;">Claim Status</td>
						<td class="leftAligned">
							<input id="txtClaimStatus" name="txtClaimStatus" type="text" style="width: 210px;" value="" readonly="readonly" />
						</td>
					</tr>
				</table>	
			</div>
		</div>
	</div>
</div>
<div id="recoveryInfoDiv" style="display: none;">
</div>
<script>
setModuleId("GICLS052");
setDocumentTitle("Loss Recovery Listing");

var selectedObjRow = null; // variable that points to the currently selected row of table grid

try {
	var objOR = new Object();
	objCLM.objLossRecoveryListTableGrid = JSON.parse('${lossRecoveryListTableGrid}'.replace(/\\/g, '\\\\'));
	objCLM.objLossRecoveryList = objCLM.objLossRecoveryListTableGrid.rows || [];

	var lineCd = objCLMGlobal.lineCd;
		
	var lossRecoveryTableModel = {
			url: contextPath+"/GICLClaimsController?action=showLossRecoveryListing&refresh=1&lineCd="+lineCd ,
			options:{
				title: '',
				width: '900px',
				onRemoveRowFocus: function ( x, y, element) {
					populateLossRecov(null);
					lossRecoveryListTableGrid.keys.releaseKeys();					
					objCLMGlobal.claimId = ""; 				//marco - 05.17.2013
					//disableMenu("recoveryDistribution");	//
					//disableMenu("generateRecoveryAcctEnt");	// replaced by: Nica 05.28.2013
					//objCLMGlobal = {}
					enableDisableMenu(new Object());
				},
				onRowDoubleClick: function(y){
					var row = lossRecoveryListTableGrid.geniisysRows[y];
					populateGlobalObj(lossRecoveryListTableGrid.getRow(y));
					//showClaimBasicInformation();
					lossRecoveryListTableGrid.keys.releaseKeys();
					if (objCLMGlobal.callingForm == "GICLS125"){
						showReOpenRecovery();
					} else {
						showRecoveryInformation();
						populateLossRecov(null);
						enableDisableMenu(lossRecoveryListTableGrid.getRow(y));
					}
				},
				onCellFocus: function(element, value, x, y, id){
					lossRecoveryListTableGrid.keys.releaseKeys();
					var mtgId = lossRecoveryListTableGrid._mtgId;
					populateLossRecov(lossRecoveryListTableGrid.getRow(y));
					populateGlobalObj(lossRecoveryListTableGrid.getRow(y));
					enableDisableMenu(lossRecoveryListTableGrid.getRow(y));
				},
				onSort: function(){
					lossRecoveryListTableGrid.keys.releaseKeys();
					populateLossRecov(null);
					objCLMGlobal = {};
				},
				postPager: function () {
					lossRecoveryListTableGrid.keys.releaseKeys();
					populateLossRecov(null);
					objCLMGlobal = {};
				},
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onRefresh: function(){
						lossRecoveryListTableGrid.keys.releaseKeys();
						populateLossRecov(null);
						objCLMGlobal = {};
					}, 
					onFilter: function(){
						lossRecoveryListTableGrid.keys.releaseKeys();
						populateLossRecov(null);
						objCLMGlobal = {};
					}
				}
			},
			columnModel: [
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
					id: 'claimId',
					title: 'claimId',
					width: '0px',
					sortable: false,
					align: 'center',
					visible: false
				},
				{	id: 'wra',
					sortable: false,
					align: 'center',
					title: 'WRA',
					tooltip: 'With Recovery Amount',
					altTitle: 'With Recovery Amount',
					titleAlign: 'center',
					width: '30px',
					editable: false,
					defaultValue:false,
					otherValue:false,
					editor:'checkbox'					
              	},
				{
					id: 'recoveryNo',
					title: 'Recovery Number',
					width: '130px',
					sortable: true,
					align: 'left',
					visible: true,
					filterOption: true,
					renderer: function(value){
						return value == '---' ? '' :value;
					}
				},
				{
					id: 'claimNo',
					title: 'Claim Number',
					width: '140px',
					sortable: true,
					align: 'left',
					visible: true,
					filterOption: true
				},
				{
					id: 'policyNo',
					title: 'Policy Number',
					width: '150px',
					sortable: true,
					align: 'left',
					visible: true,
					filterOption: true
				},
				{
					id: 'assuredName',
					title: 'Assured Name',
					width: '210px',
					sortable: true,
					align: 'left',
					visible: true,
					filterOption: true
				},

				{
					id: 'recStatDesc',
					title: 'Recovery Status',
					width: '130px',
					sortable: true,
					align: 'left',
					visible: true,
					filterOption: true
				},

				{
					id: 'lossDate',
					title: 'Loss Date',
					width: '0px',
					sortable: false,
					align: 'left',
					visible: false,
					filterOptionType : 'formattedDate',
					filterOption: true
				},

				{
					id: 'lossCatDes',
					title: 'Loss Cat Des',
					width: '0px',
					sortable: false,
					align: 'left',
					visible: false
				},

				{
					id: 'dist',
					title: 'dist',
					width: '30px',
					sortable: false,
					align: 'left',
					visible: false
				},

				{
					id: 'entry',
					title: 'entry',
					width: '30px',
					sortable: false,
					align: 'left',
					visible: false
				},
				
				{
				    id: 'clmFileDate',
				    title: 'File Date',
				    width: '0',
				    visible: false,
				    filterOptionType : 'formattedDate',
				    filterOption: true
				},
				
				{
				    id: 'clmStatDesc',
				    title: '',
				    width: '0',
				    visible: false
				},
				
				{
				    id: 'dspLossDate',
				    title: '',
				    width: '0',
				    visible: false
				},
				
				{
				    id: 'lossCatCd',
				    title: '',
				    width: '0',
				    visible: false
				},
				
				{
				    id: 'recoveryId',
				    title: '',
				    width: '0',
				    visible: false
				},
				
				{
				    id: 'issueCd',
				    title: '',
				    width: '0',
				    visible: false
				},
				
				{
				    id: 'lineCd',
				    title: '',
				    width: '0',
				    visible: false
				},
				{
				    id: 'issCd',
				    title: '',
				    width: '0',
				    visible: false
				},
				{
				    id: 'subLineCd',
				    title: '',
				    width: '0',
				    visible: false
				},
				
				{
				    id: 'recoveryAcctId',
				    title: '',
				    width: '0',
				    visible: false
				}

				

			],
			resetChangeTag: true,
			rows: objCLM.objLossRecoveryList
	};

	lossRecoveryListTableGrid = new MyTableGrid(lossRecoveryTableModel);
	lossRecoveryListTableGrid.pager = objCLM.objLossRecoveryListTableGrid;
	lossRecoveryListTableGrid.render('lossRecoveryTableGrid');
} catch(e){
	showErrorMessage("lossRecoveryListing.jsp", e);
}

function populateLossRecov(obj){
	try{
		$("txtLossDate").value  	= (obj) == null ? "" : (nvl(obj.lossDate,""));
		$("txtLossCatDesc").value   = (obj) == null ? "" : unescapeHTML2((nvl(obj.lossCatDes,""))); 
		$("txtFileDate").value 		= (obj) == null ? "" : (nvl(dateFormat(obj.clmFileDate,'mm-dd-yyyy'),"")); 
		$("txtClaimStatus").value 	= (obj) == null ? "" : unescapeHTML2((nvl(obj.clmStatDesc,"")));	
	}catch (e) {
		showErrorMessage("populateLossRecov", e);
	}
}

function populateGlobalObj(param){
	//Dagdagan na lang d2 kung anong global ang kailangan Global values here
	objCLMGlobal.claimId    = param.claimId;
	objCLMGlobal.recoveryId = param.recoveryId;
	
	objCLMGlobal.issueCode = nvl(param.issueCode, param.issueCd);
	objCLMGlobal.lineCd = param.lineCd;
	objCLMGlobal.claimNo = param.claimNo;
	objCLMGlobal.lossCatCd = param.lossCatCd;
	objCLMGlobal.lossCatDes = param.lossCatDes;
	objCLMGlobal.policyNo   = param.policyNo;
	objCLMGlobal.assuredName = param.assuredName;
	objCLMGlobal.claimStatDesc = param.clmStatDesc;
	objCLMGlobal.sublineCd = param.sublineCd;
	objCLMGlobal.strDspLossDate2 = dateFormat(param.dspLossDate, 'mm-dd-yyyy');
	objCLMGlobal.recoveryAcctId = param.recoveryAcctId;

	if(objCLMGlobal.callingForm != "GICLS125"){
		objCLMGlobal.callingForm = "GICLS052";
	}
}

function enableDisableMenu(param){
	if (nvl(param.dist, null) != null){
		enableMenu("recoveryDistribution");
	     if (nvl(param.entry, null) != null) {
	    	 enableMenu("generateRecoveryAcctEnt");
	     }else{
	         disableMenu("generateRecoveryAcctEnt");    
	     }
	  
	}else{
		disableMenu("recoveryDistribution");
		disableMenu("generateRecoveryAcctEnt");
	}
}

observeAccessibleModule(accessType.MENU, "GICLS025", "recoveryInformation", function(){
	populateLossRecov(null);
	showRecoveryInformation();
});
observeAccessibleModule(accessType.MENU, "GICLS054", "recoveryDistribution", function(){
	populateLossRecov(null);
	showRecoveryDistribution();
});
observeAccessibleModule(accessType.MENU, "GICLS055", "generateRecoveryAcctEnt", function(){
	objCLMGlobal.callingForm = $("lblModuleId").readAttribute("moduleid");
	populateLossRecov(null);
	showGenerateRecoveryAcctEntries(objCLMGlobal.claimId, objCLMGlobal.recoveryAcctId);
});

$("lossRecoveryExit").observe("click", function (){
	lossRecoveryListTableGrid.keys.releaseKeys();
	if($("recoveryInfoDiv").innerHTML.trim() == ""){
		objCLMGlobal = {};
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
	} else {
		$("recoveryInfoDiv").innerHTML = "";
		$("recoveryInfoDiv").hide();
		$("lossRecoveryListingDiv").show();
		lossRecoveryListTableGrid._refreshList();
		disableMenu("recoveryDistribution");
		disableMenu("generateRecoveryAcctEnt");
		setModuleId("GICLS052");
	}
});

disableMenu("recoveryDistribution");
disableMenu("generateRecoveryAcctEnt");
</script>