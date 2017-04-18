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

<div id="claimListingMainDiv" name="claimListingMainDiv">
	<div id="claimListingMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="claimListingExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>List of Claims for ${lineName}</label>
			<input type="hidden" id="lineCd" name="lineCd" value="${lineCd}">
			<input type="hidden" id="menuLineCd" name="menuLineCd" value=""> <!-- nica 10.01.2013 -->
		</div>
	</div>
	
	<div id="claimListTableGridSectionDiv" class="sectionDiv" style="height: 450px;"> 
		<div id="claimListTableGridDiv" style="padding: 10px;">
			<div id="claimListTableGrid" style="height: 325px; width: 900px;"></div>
		</div>
		<div id="claimListAddtlInformationDiv" style="padding: 10px; margin-top: 10px;"> <!-- added div for additional textfields - christian 04.25.2012 -->
			<table cellspacing="0" border="0" style="margin: 10px 0 10px 70px;"> 		
	 			<tr>
					<td class="rightAligned" style="width: 100px;" id="lblAssigneeEnrolee">
					</td>
					<td class="leftAligned">
						<input id="txtAssigneeEnrolee" name="txtAssigneeEnrolee" type="text" style="width: 210px; display: none;" value="" readonly="readonly" />
					</td>
					
				</tr>
	 			<tr>
	 				<td class="rightAligned" style="width: 100px;" id="lblPackagePolicy">
	 				</td>
					<td class="leftAligned">
						<input id="txtPackagePolicy" name="txtPackagePolicy" type="text" style="width: 210px; display: none;" value="" readonly="readonly" />
					</td>
				</tr>
				
			</table>
		</div>
	</div>
</div>
<!-- added by andrew - 02.24.2012 - hide the listing to retain filtered records -->
<div id="claimInfoDiv" style="display: none;">
</div>
<div id="claimViewPolicyInformationDiv" style="display:none;"> <!-- andrew 04.23.2012 -->
</div>
<script>
	var selectedObjRow = null; // variable that points to the currently selected row of table grid
	var currUser = '${user}';
	var inHouseAdjustment; // christian 04.24.2012
	$("menuLineCd").value =  objCLMGlobal.menuLineCd; //nica 10.01.2013
	
	try {
		showAddtnlFields();
		var objOR = new Object();
		objCLM.objClaimListTableGrid = JSON.parse('${claimsListTableGrid}'.replace(/\\/g, '\\\\'));
		objCLM.objClaimList = objCLM.objClaimListTableGrid.rows || [];

		var claimsTableModel = {
				id : 100, // andrew - 02.24.2012 - to avoid conflict with other tablegrids
				url: contextPath+"/GICLClaimsController?action=getClaimTableGridListing&lineCd="+objCLMGlobal.lineCd+"&refresh=1",
				options:{
					title: '',
					width: '900px',
					onRemoveRowFocus: function ( x, y, element){
						populateClaimsDetail(null);
					},
					onRowDoubleClick: function(y){
						var row = claimsListTableGrid.geniisysRows[y];
						var menuLineCd = $("menuLineCd").value; //objCLMGlobal.menuLineCd;  nica 10.01.2013
						objCLMGlobal = claimsListTableGrid.geniisysRows[y];						
						populateGlobalObj(claimsListTableGrid.getRow(y));
						populateClaimsDetail(claimsListTableGrid.getRow(y)); // christian - 04.25.2012
						objCLMGlobal.menuLineCd = menuLineCd; // andrew - 01.11.2012
						objCLM.dcOverrideFlag = "N"; //marco - 07.23.2014
						if (currUser == claimsListTableGrid.getRow(y).inHouseAdjustment){
							claimsListTableGrid.keys.releaseKeys();
							showClaimBasicInformation();
						}else{
							showMessageBox("You are not allowed to access this claim record.", imgMessage.INFO);
						}	
					},
					onCellFocus: function(element, value, x, y, id){
						var mtgId = claimsListTableGrid._mtgId;
						var menuLineCd = objCLMGlobal.menuLineCd;
						objCLMGlobal = claimsListTableGrid.geniisysRows[y];
						populateGlobalObj(claimsListTableGrid.getRow(y));
						objCLMGlobal.menuLineCd = menuLineCd; // andrew - 01.11.2012
						populateClaimsDetail(claimsListTableGrid.getRow(y)); // christian - 04.25.2012
						claimsListTableGrid.keys.releaseKeys();
						if (claimsListTableGrid.getRow(y).packPolicy != null){
							$("lblPackagePolicy").innerHTML = "Package Policy";
							$("txtPackagePolicy").show();
							$("txtPackagePolicy").value = claimsListTableGrid.getRow(y).packagePolicy;
						}else{
							$("lblPackagePolicy").innerHTML = "";
							$("txtPackagePolicy").hide();
							$("txtPackagePolicy").value = null;
						}
					},
					onSort: function(){
						claimsListTableGrid.keys.releaseKeys();
						populateClaimsDetail(null);
					},
					postPager: function () {
						claimsListTableGrid.keys.releaseKeys();
						populateClaimsDetail(null);
					},
					toolbar: {
						elements: [MyTableGrid.ADD_BTN, MyTableGrid.EDIT_BTN, MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
						onRefresh: function(){
							claimsListTableGrid.keys.releaseKeys();
							populateClaimsDetail(null);
						},
						onFilter: function(){
							claimsListTableGrid.keys.releaseKeys();
							populateClaimsDetail(null);
						},
						onAdd: function(){
							claimsListTableGrid.keys.releaseKeys();
							var lineCd = objCLMGlobal.lineCd;
							objCLMGlobal = new Object();
							objCLMGlobal.callingForm = "GICLS001";
							objCLMGlobal.lineCd = lineCd;
							objCLMGlobal.menuLineCd = objCLMGlobal.menuLineCd; // andrew - 01.11.2012
							objCLM.dcOverrideFlag = "N"; //marco - 07.23.2014
							showClaimBasicInformation();
						},
						onEdit: function(){
							if(objCLMGlobal.claimId == undefined || objCLMGlobal.claimId == null){
								showMessageBox("Please select a claim record first.", imgMessage.INFO);
								return false;
							}else{
								claimsListTableGrid.keys.releaseKeys();
								if (currUser == inHouseAdjustment){ 
									objCLMGlobal.menuLineCd = $("menuLineCd").value; //nica 10.01.2013
									showClaimBasicInformation();
								}else{
									showMessageBox("You are not allowed to access this claim record.", imgMessage.INFO);
								}
							}
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
						id: 'lossCatCd',
						//title: 'Renew No.',
						width: '0px',
						sortable: false,
						visible: false,
						filterOption: false
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
					{	id:			'packPolicy',
						sortable:	false,
						align:		'center',
						title:		'&#160;&#160;P',
						tooltip:	'Package Policy',
						altTitle:   'Package Policy',
						titleAlign:	'center',
						width:		'23px',
						editable:	false,
						defaultValue:	false,
						otherValue:	false,
						//validValue:	'Y',
						editor:		'checkbox'
	              	},
					{
						id: 'claimNo',
						title: 'Claim Number',
						width: '150px',
						sortable: true,
						align: 'left'
					},
					{
						id: 'policyNo',
						title: 'Policy Number',
						width: '175px',
						sortable: true,
						align: 'left'
					},
					{
						id: 'assuredName',
						title: 'Assured Name',
						width: '250px',
						sortable: true,
						align: 'left',
						filterOption: true
					},
					{
						id: 'plateNumber',
						title: 'Plate No.',
						//width: '70px',
						width: (objCLMGlobal.lineCd == objLineCds.MC || objCLMGlobal.menuLineCd == objLineCds.MC ? '70px' : '0px'), // andrew - 01.02.2012
						visible : (objCLMGlobal.lineCd == objLineCds.MC || objCLMGlobal.menuLineCd == objLineCds.MC ? true : false), // andrew - 01.02.2012
						sortable: true,
						align: 'center',
						//filterOption: true 
						filterOption: (objCLMGlobal.lineCd == objLineCds.MC || objCLMGlobal.menuLineCd == objLineCds.MC ? true : false) // andrew - 01.02.2012
					},
					{
						id: 'claimStatDesc',
						title: 'Claim Status',
						width: '117px',
						sortable: true,
						align: 'left',
						filterOption: true
					},
					{
						id: 'inHouseAdjustment',
						title: 'Claim Processor',
						width: '100px',
						sortable: true,
						align: 'left',
						filterOption: true
					},
					{
						id: 'packagePolicy',
						title: '',
					    width: '0',
					    visible: false
					},
					{
						id: 'groupedItemTitle',
						title: '',
					    width: '0',
					    visible: false
					},
					{
						id: 'assignee',
						title: '',
					    width: '0',
					    visible: false
					}
					
					

				],
				resetChangeTag: true,
				rows: objCLM.objClaimList
		};

		claimsListTableGrid = new MyTableGrid(claimsTableModel);
		claimsListTableGrid.pager = objCLM.objClaimListTableGrid;
		claimsListTableGrid.render('claimListTableGrid');
			
	} catch(e){
		showErrorMessage("claimListing.jsp", e);
	}

	$("claimListingExit").observe("click", function (){
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
	});

	function populateGlobalObj(param){
		//Dagdagan na lang d2 kung anong global ang kailangan Global values here
		objCLMGlobal.claimId = param.claimId;
		objCLMGlobal.claimNo = param.claimNo; // added more global values. irwin. aug.5.11
		objCLMGlobal.policyNo = param.policyNo;
		objCLMGlobal.assuredName = param.assuredName;
		objCLMGlobal.lossCatCd = param.lossCatCd;
		objCLMGlobal.lossCatDes = param.lossCatDes;
		objCLMGlobal.lossCategory = param.lossCatCd+'-'+param.lossCatDes;
		objCLMGlobal.lineCd = param.lineCode;
		objCLMGlobal.lineName = param.lineName;
		objCLMGlobal.sublineCd = param.sublineCd;
		objCLMGlobal.issCd = param.issueCode;
		objCLMGlobal.strDspLossDate = param.dspLossDate;
		
		objCLMGlobal.callingForm = "GICLS002";
	}
	
	function populateClaimsDetail(obj){
		try{	
			if ('${lineCd}' == 'MC'){
				$("txtAssigneeEnrolee").value       = (obj) == null ? "" : (nvl(unescapeHTML2(obj.assignee),""));
			}else if ('${lineCd}' == 'PA'){
				$("txtAssigneeEnrolee").value       = (obj) == null ? "" : (nvl(unescapeHTML2(obj.groupedItemTitle),""));
			}
			inHouseAdjustment = (obj) == null ? "" : (nvl(obj.inHouseAdjustment,""));
			
			if(obj == null){
				$("txtPackagePolicy").value = null;
				$("txtPackagePolicy").hide();
				$("lblPackagePolicy").innerHTML = "";
			}
		}catch (e) {
			showErrorMessage("populateClaimsDetail", e);
		}
	}
	
	function showAddtnlFields(){
		try{
			if('${ora2010SW}' == 'Y'){
				if ('${lineCodeMC}' == '${lineCd}' || '${lineCd}' == 'MC'){
					$("txtAssigneeEnrolee").show();
					$("lblAssigneeEnrolee").innerHTML = "Assignee";
				}else if ('${lineCodeAC}' == '${lineCd}' || '${lineCd}' == 'PA'){
					$("txtAssigneeEnrolee").show();
					$("lblAssigneeEnrolee").innerHTML = "Enrolee";
				}
			}
		}catch (e) {
			showErrorMessage("showAddtnlFields", e);
		}
	}
	
	window.scrollTo(0,0); 	
	hideNotice("");
	setModuleId("GICLS002");
	setDocumentTitle("Claim Listing");
</script>	