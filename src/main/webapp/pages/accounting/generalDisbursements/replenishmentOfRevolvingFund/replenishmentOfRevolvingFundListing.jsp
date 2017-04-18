<!--Gzelle 04172013-->
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>
<div id="replenishmentListingMainDiv" name="replenishmentListingMainDiv">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
		   	<label>Group DV Records for Replenishment Listing</label>
		 </div>
	</div>
	
	<div class="sectionDiv" id="replenishmentListingSectionDiv" style="height: 355px;">
		<div id="replenishmentListingTableGridDiv" name="replenishmentListingTableGridDiv" style="padding: 10px;">	
			<div id="replenishmentListingTable" name="replenishmentListingTable" style="height: 310px; width: 900px;"></div>
		</div>
	</div>
</div>

<script type="text/javascript">
setModuleId("GIACS081");
setDocumentTitle("Group DV Records for Replenishment");
subPage = false;
addStatus = false;
modifyRec = null;						// N - get existing records
										// Y - get records for existing batch
										// X - get records for newly added batch
search = false;
exitTag = 0; //lara 11/20/2013
objReplenish = new Object();
objReplenish.replenishId = null;
objReplenish.branchCd = null;
selectedReplenishRow = null;

$("acExit").show();

try{
	var jsonReplenishmentListing = JSON.parse('${jsonReplenishmentListing}');
	replenishmentListingTableModel = {
			url : contextPath+"/GIACReplenishDvController?action=showReplenishmentOfRevolvingFundListing&refresh=1",
			options: {
				width: '900px',
				height: '310px',
				onCellFocus : function(element, value, x, y, id) {	
					var mtgId = tbgRepRevOfFundListing._mtgId;
					selectedReplenishRow = null;
					if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
						// set variables and selected replenish row
						selectedReplenishRow = y;
						objReplenish.replenishId = tbgRepRevOfFundListing.geniisysRows[y].replenishId;
						objReplenish.branchCd = tbgRepRevOfFundListing.geniisysRows[y].branchCd;
					}
					tbgRepRevOfFundListing.keys.removeFocus(tbgRepRevOfFundListing.keys._nCurrentFocus, true);
					tbgRepRevOfFundListing.keys.releaseKeys();
				},
				onRowDoubleClick: function(y){
					objReplenish.replenishId = tbgRepRevOfFundListing.geniisysRows[y].replenishId;
					objReplenish.branchCd = tbgRepRevOfFundListing.geniisysRows[y].branchCd;
					selectedReplenishRow = y;
					viewReplenishmentDetails(true);
				},
				onRemoveRowFocus: function() {
					viewReplenishmentDetails(false);
				},
				onSort: function() {
					viewReplenishmentDetails(false);
				},
				prePager: function() {
					viewReplenishmentDetails(false);
				},
				onRefresh: function() {
					viewReplenishmentDetails(false);
				},
				toolbar: {
					elements: [MyTableGrid.ADD_BTN, MyTableGrid.EDIT_BTN, MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function() {
						viewReplenishmentDetails(false);
					},
					onAdd: function(){
						addStatus = true;
						objReplenish.replenishId = "";
						objReplenish.branchCd = "";
						showReplenishmentDetails("/GIACReplenishDvController?action=showReplenishmentOfRevolvingFund");
					},
					onEdit: function(){
						viewReplenishmentDetails(true);
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
					id : "branch",
					title : "Branch",
					width : '370px',
					filterOption : true
				},
// 				{	comment out by: Gzelle 11.20.2013 not a database object 
// 					id : "checkDateFrom",
// 					title : "Check Date From",
// 					width : '150px',
// 					align : 'center',
// 					titleAlign : 'center',
// 					filterOption : true,
// 					type: 'date',
// 					format: 'mm-dd-yyyy',
// 					titleAlign: 'center',
// 					filterOptionType : 'formattedDate'
// 				},
// 				{
// 					id : "checkDateTo",
// 					title : "Check Date To",
// 					width : '150px',
// 					align : 'center',
// 					titleAlign : 'center',
// 					filterOption : true,
// 					type: 'date',
// 					format: 'mm-dd-yyyy',
// 					titleAlign: 'center',
// 					filterOptionType : 'formattedDate'
// 				},
				{
					id : "replenishmentNo",
					title : "Replenishment No.",
					width : '280px',
					filterOption : true
				},
				{
					id : "revolvingFundAmt",
					title : "Revolving Fund",
					width : '235px',
					filterOption : true,
					align : 'right',
					titleAlign : 'right',
					filterOptionType: 'number',
					geniisysClass: 'money'
				}
			],
			rows: jsonReplenishmentListing.rows
		};
	
	tbgRepRevOfFundListing = new MyTableGrid(replenishmentListingTableModel);
	tbgRepRevOfFundListing.pager = jsonReplenishmentListing;
	tbgRepRevOfFundListing.render('replenishmentListingTable');
	
	function setReplenishmentDetails(row) {
		$("txtRepBranch").value 		= row == null ? "" : row.branch;
		$("txtFromCheckDate").value 	= row == null ? "" : row.checkDateFrom;
		$("txtToCheckDate").value 		= row == null ? "" : row.checkDateTo;
		$("txtReplenishmentYear").value = row == null ? "" : row.replenishYear;
		$("txtReplenishmentNo").value 	= row == null ? "" : row.replenishSeqNo;
		$("txtRevolvingFund").value 	= row == null ? "" : formatCurrency(row.revolvingFundAmt);
		$("hidLastValidRevFund").value  = row == null ? "" : formatCurrency(row.revolvingFundAmt);
		$("txtTotalTagged").value 		= row == null ? "" : formatCurrency(row.replenishmentAmt);
	}
	
	function enableReplenishmentDetails(Y) {
		if (nvl(Y,false) == true) {
			enableSearch("imgSearchRepBranch");
			enableInputField("txtRepBranch");
			enableDate("hrefFromCheckDate");
			enableDate("hrefToCheckDate");
			disableButton("btnAcctEntriesRep");
			disableButton("btnSummarizedEntriesRep");
			disableButton("btnPrintRep");
			disableButton("btnSearchRep");	
			disableButton("btnSaveRepOfRevolvingFund");
		}else {
			disableSearch("imgSearchRepBranch");
			disableInputField("txtRepBranch");
			disableDate("hrefFromCheckDate");
			disableDate("hrefToCheckDate");
			disableButton("btnAcctEntriesRep");
			enableButton("btnSummarizedEntriesRep");
			enableButton("btnPrintRep");
			enableButton("btnSearchRep");
			disableButton("btnSaveRepOfRevolvingFund");
		}
	}
	
	function viewReplenishmentDetails(set) {
		if (nvl(set,false) == true){
			if (objReplenish.replenishId == null || selectedReplenishRow == null) {
				showMessageBox("Please select a record first.", imgMessage.INFO);
				return false;
			}else {
				modifyRec = "N";
				showReplenishmentDetails("/GIACReplenishDvController?action=showReplenishmentOfRevolvingFund"
											+"&replenishId=" + objReplenish.replenishId
											+"&branchCd="	 + objReplenish.branchCd
											+"&modifyRec=" 	 + modifyRec);
			}tbgRepRevOfFundListing.keys.releaseKeys(); 
		}else {
			selectedReplenishRow = null;
			objReplenish.replenishId == null;
			objReplenish.branchCd == null;
			tbgRepRevOfFundListing.keys.releaseKeys();
		}
	}

	function showReplenishmentDetails(url){
		new Ajax.Request(contextPath + url, {
			onCreate: showNotice("Loading, please wait..."),
			onComplete : function(response){
				hideNotice();
				try { 
					if(checkErrorOnResponse(response)){
						$("mainContents").update(response.responseText);
						if (addStatus != true) {
							setReplenishmentDetails(tbgRepRevOfFundListing.geniisysRows[selectedReplenishRow]);
							enableReplenishmentDetails(false);
						}else{
							setReplenishmentDetails(null);
							enableReplenishmentDetails(true);
						}
					}
				} catch(e){
						showErrorMessage("showReplenishmentDetails - onComplete : ", e);
				}								
			} 
		});			
	}
	
	function showReplenishmentFundListing() {
		new Ajax.Request(contextPath + "/GIACReplenishDvController", {
		    parameters : {action : "showReplenishmentOfRevolvingFundListing"},
			onComplete : function(response){
				try {
					if(checkErrorOnResponse(response)){
						$("mainContents").update(response.responseText);
					}
				} catch(e){
					showErrorMessage("showReplenishmentOfRevolvingFundListing - onComplete : ", e);
				}								
			} 
		});	
	}
	
	$("acExit").stopObserving();
	
	$("acExit").observe("click", function() {
		if (subPage) {
			if (changeTag == 1) {
				exitTag = 1;
				showConfirmBox4("Group DV Records for Replenishment", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
						objReplenish.onYesFunc, showReplenishmentFundListing, "");
			}else {
				showReplenishmentFundListing();
			}
		}else {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");			
		}
	});

}catch(e){
	showMessageBox("Error in Replenishment of Revolving Fund Listing: " + e, imgMessage.ERROR);		
}

objReplenish.showReplenishmentFundListing = showReplenishmentFundListing;
objReplenish.viewReplenishmentDetails = viewReplenishmentDetails;
</script>