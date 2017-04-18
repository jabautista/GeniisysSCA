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
			<label>Certificate of No Claim Multi Year Listing Block</label>
			<input type="hidden" id="lineCd" name="lineCd" value="${lineCd}">
		</div>
	</div>
	
	<div id="noClaimMultiYyListTableGridSectionDiv" class="sectionDiv" style="height: 370px;">
		<div id="noClaimMultiYyListTableGridDiv" style="padding: 10px;">
			<div id="noClaimMultiYyListTableGrid" style="height: 325px; width: 900px;"></div>
		</div>
	</div>
</div>
<script>
	try{
		var objCLMItem = new Object();
		objCLMItem.objectItemTableGrid = JSON.parse('${noClaimMultiYyList}'.replace(/\\/g,'\\\\'));
		objCLMItem.objGiclNoClaimMultiYyList = objCLMItem.objectItemTableGrid.rows;
		objCLMItem.ora2010Sw = ('${ora2010Sw}');	
		objCLMItem.vLocLoss = ('${vLocLoss}');
		var tableModel = {
				url: contextPath+"/GICLNoClaimMultiYyController?action=showNoClaimMutiYyList&refresh=1",
				options: {newRowPosition: 'bottom',
					pager: { 
					},
					onCellFocus: function(element, value, x, y, id){
						noClaimGrid.keys.removeFocus(noClaimGrid.keys._nCurrentFocus, true);
						noClaimGrid.keys.releaseKeys();
						row = noClaimGrid.geniisysRows[y];
						objCLMItem.noClaimId = row.noClaimId;
					},
					onCellBlur : function(element, value, x, y, id) {
					},
					onRowDoubleClick: function(param){
												
						noClaimGrid.keys.removeFocus(noClaimGrid.keys._nCurrentFocus, true);
						noClaimGrid.keys.releaseKeys();
						row = noClaimGrid.geniisysRows[param];
						objCLMItem.noClaimId = row.noClaimId;

						
						viewNoClaimMultiYyPolicyListing(objCLMItem.noClaimId);
						
						//$("txtRemarks").setAttribute("readonly","readonly"); comment out to allow updating of Remarks field regardless of its status by MAC 11/20/2013.
						//disableButton("noClaimMultiSave"); comment out to allow saving of any changes in No Claim Multi Year by MAC 11/20/2013.
						
						$("itemAssdNo").hide();
						//$("itemPlateNo").hide(); comment out to allow updating of Plate Number by MAC 11/20/2013.
					},
			
					
					onRemoveRowFocus: function(element, value, x, y, id) {
						objCLMItem.noClaimId = null;	//added to prevent Edit if the record was deselected : shan 10.14.2013
					},
					toolbar: {
						elements: [MyTableGrid.ADD_BTN, MyTableGrid.EDIT_BTN, MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
						onAdd: function(){
							noClaimGrid.keys.releaseKeys();
							addNoClaimMultiYy();							
						},
						onEdit: function(){
							if(objCLMItem.noClaimId == null){
								showMessageBox("Please select a record first.", "E");
							}else{
								viewNoClaimMultiYyPolicyListing(objCLMItem.noClaimId);
								$("itemAssdNo").hide();
								$("noClaimMultiSave").value = "Update";
							}
						} 
					},
					onComplete: function(response){
						obj = JSON.parse(response.responseText.replace(/\\/g,'\\\\'));
						supplyNoClaimMultiYyDetails(obj);
					}
				},
				columnModel:[
								{ 								
									id: 'recordStatus', 		
									title: '&#160;D',
								 	altTitle: 'Delete?',
								 	titleAlign: 'center',
										width: 19,
										sortable: false,
								 	editable: true, 	
										editor: 'checkbox',
								 	hideSelectAllBox: true,
								 	visible: false 
								},
								{   id: 'recordStatus',							    
								    width: '0',
								    visible: false,
								    editor: 'checkbox' 	
								    
								},
								{	id: 'divCtrId',
									width: '0',
									visible: false
								},
								{
									id: 'noClaimNo',
									title: 'No Claim No.',
									width: '200px',
									titleAlign: 'left',
									align: 'left',
									filterOption: true
								    //filterOptionType: 'integer'
								},
								{
									id: 'assdName',
									title: 'Assured Name',
									width: '150px',
									titleAlign: 'left',
									align: 'left',
									filterOption: true,
								    filterOptionType: 'string'
								},
								{
									id: 'plateNo',
									title: 'Plate No.',
									width: '100px',
									titleAlign: 'left',
									align: 'left',
									filterOption: true
								},
								{
									id: 'carCompany',
									title: 'Car Company',
									width: '100px',
									titleAlign: 'left',
									align: 'left'
								},
								{
									id: 'make',
									title: 'Make',
									width: '100px',
									titleAlign: 'left',
									align: 'left'
								},
								{
									id: 'serialNo',
									title: 'Serial No.',
									width: '100px',
									titleAlign: 'left',
									align: 'left',
									filterOption: true
								},
								{
									id: 'motorNo',
									title: 'Motor No.',
									width: '100px',
									titleAlign: 'left',
									align: 'left',
									filterOption: true
								},
								{
									id: 'ncIssCd',
									width: '0',
									title: 'Issue Cd',
									visible: false,	
									filterOption: true,
								    filterOptionType: 'string'
								},
								{
									id: 'ncIssueYy',
									width: '0',
									title: 'Issue Year',
									visible: false,
									filterOption: true,
								    filterOptionType: 'integer'
									
								},
								{
									id: 'ncSeqNo',
									width: '0',
									title: 'Seq. No.',
									visible: false,
									filterOption: true,
								    filterOptionType: 'integer'
								}
				             ],
				             resetChangeTag: true,
				     		 requiredColumns: '',
				     		 rows: objCLMItem.objGiclNoClaimMultiYyList
		};
		noClaimGrid = new MyTableGrid(tableModel);
		noClaimGrid.pager = objCLMItem.objectItemTableGrid;
		noClaimGrid.afterRender = function(){
			//changeTag = 0;
			//initializeChangeTagBehavior(function(){saveClaimsItemGrid(false);});
		}; 
		
		
		noClaimGrid._mtgId = 1;
		noClaimGrid.render('noClaimMultiYyListTableGrid');
		
		window.scrollTo(0,0); 	
		hideNotice("");
		setModuleId("GICLS062");
		setDocumentTitle("Certificate of No Claim Multi Year Listing");
		
		
		
		$("claimListingExit").observe("click", function (){
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
		});
	}catch(e){
		showErrorMessage("noClaimMultiYyListing.jsp",e);
	}
</script>