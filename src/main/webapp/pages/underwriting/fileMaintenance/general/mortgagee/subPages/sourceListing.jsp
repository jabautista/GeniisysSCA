<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>	

<div  id="sourceListingSubSectionDiv" class= "subSectionDiv" style="height: 245px; top: 10px; bottom: 10px;" >
	<div id="sourceListingTable" style="position:relative; left:240px; top:10px; bottom: 10px;" ></div>
	<input type="hidden" id="issCd" name="issCd"/>
</div>

<script type="text/javascript">
 
	setDocumentTitle("Mortgagee Maintenance");
	setModuleId("GIISS105");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	objSourceMaintain = null;

	try{
	
		var row = 0;
		var objMortgageeMain = [];
		var objSource = new Object();
		objSource.objSourceListing = JSON.parse('${sourceListing}'.replace(/\\/g, '\\\\'));
		objSource.objSourceMaintenance = objSource.objSourceListing.rows || [];
	
		var sourceListTG = {
				url: contextPath+"/GIISMortgageeController?action=showSourceMortgageeMaintenance",
				options: {
					width: '410px',
					height: '200px',
				onCellFocus: function(element, value, x, y, id){
					row = y;
					objSourceMaintain = sourceListTableGrid.geniisysRows[y];
					mortgageeListTableGrid.url = contextPath+"/GIISMortgageeController?action=showMortgageeMaintenance"
			    										+"&issCd="+objSourceMaintain.issCd;
					clearForm();
					displayValue();
					enableForm();
				},
				onRemoveRowFocus: function(){
 	            	if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
                	} else {
    					clearForm();
    					refreshMortgagee();
    					displayValue();
    					disableForm();		
                	}
            	},
           		beforeSort: function(){
 	            	if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
                	} else {
                		clearForm();
                		displayValue();		
                	}
           	 	},
            	onSort: function(){
					clearForm();
					refreshMortgagee();
					displayValue();
					disableForm();					
            	},
                checkChanges: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetail: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTag == 1 ? true : false);
				},
				onRefresh: function(){
 	            	if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
                	} else {
    					clearForm();
    					refreshMortgagee();
    					displayValue();
    					disableForm();		
                	}
				},
			toolbar: {
				elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onFilter: function(){
	 	            	if (changeTag == 1){
							showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
							return false;
            	    	} else {
    						clearForm();
    						refreshMortgagee();
    						displayValue();
	    					disableForm();		
    	            	}
					}
				}
			},
			columnModel: [
				{   
					id: 'recordStatus',
				    title: '',
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
					id: 'issCd',
			    	title: 'Issue Code',
				    width: '96px',
				    visible: true,
				    filterOption: true,
			    	sortable:true
				},
				{	
					id: 'issName',
					title: 'Issue Name',
					width: '286px',
					visible: true,
					filterOption: true,
					sortable:true
				}
			],
			rows: objSource.objSourceMaintenance
		};
		sourceListTableGrid = new MyTableGrid(sourceListTG);
		sourceListTableGrid.pager = objSource.objSourceListing;
		sourceListTableGrid.render('sourceListingTable');
		sourceListTableGrid.afterRender = function(){
			objMortgageeMain = sourceListTableGrid.geniisysRows;
			changeTag = 0;
		};
	
		function clearForm() {
			$("issCd").value = null;
		 	$("txtMortgCd").value = null;
     		$("txtMortgName").value = null;
		 	$("txtMailAddr1").value = null;
		 	$("txtMailAddr2").value = null;
	 		$("txtMailAddr3").value = null;
		 	$("txtTIN").value = null;
		 	$("txtDesignation").value = null;
	 		$("txtContactPers").value = null;
		 	$("txtRemarks").value = null;
			mortgageeListTableGrid.refresh();
			sourceListTableGrid.keys.releaseKeys();
		}
	
		function enableForm() {
			enableInputField("txtMortgCd");
			enableInputField("txtMortgName");
			enableInputField("txtMailAddr1");
			enableInputField("txtMailAddr2");
			enableInputField("txtMailAddr3");
			enableInputField("txtTIN");
			enableInputField("txtDesignation");
			enableInputField("txtContactPers");
			enableInputField("txtRemarks"); 
	   		enableButton("btnAddMortgagee");
	   		$("txtMortgCd").focus();
		}
	
		function disableForm() {
			disableInputField("txtMortgCd");
			disableInputField("txtMortgName");
			disableInputField("txtMailAddr1");
			disableInputField("txtMailAddr2");
			disableInputField("txtMailAddr3");
			disableInputField("txtTIN");
			disableInputField("txtDesignation");
			disableInputField("txtContactPers");
			disableInputField("txtRemarks"); 
	   		disableButton("btnAddMortgagee");		
		}
	
		function displayValue() {
			$("txtLastUpdate").value = dateFormat(new Date(),'mm-dd-yyyy hh:MM:ss TT');
			$("txtUserId").value = "${PARAMETERS['USER'].userId}";
		}	
	
		function refreshMortgagee() {
			mortgageeListTableGrid.url = contextPath+"/GIISMortgageeController?action=showMortgageeMaintenance";
			mortgageeListTableGrid._refreshList();
		}
		
		$("editRemarksText").observe("click", function () {
			showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"), function() {
				limitText($("txtRemarks"),4000);
			});
		});
		
		$("txtRemarks").observe("keyup", function(){		
			limitText(this,4000);
		});	
		
		$("txtRemarks").observe("keydown", function(){	
			limitText(this,4000);
		});

	}catch (e) {
		 showErrorMessage("Source Table Grid", e); 
	}
	
</script>