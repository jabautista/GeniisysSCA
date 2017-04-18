<script type="text/javascript">

	issueSourceListingRowValue = null;
	try{
		var row = 0;
		var objIssueSourceListMain = [];
		var objIssueSourceList = new Object();
		objIssueSourceList.objIssueSourceListing = [];
		objIssueSourceList.objIssueSourceListingRows = objIssueSourceList.objIssueSourceListing.rows || [];
		
		var issueSourceListingTable = {
				id: 2,
				url: contextPath + "/GIISPostingLimitController?action=getIssueSourceListing",
				options: {
					height: '175px',
					width: '450px',
					onCellFocus: function(element, value, x, y, id){
						if (changeTag == 1){
		            	 	showConfirmBox4("Save", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",objGiiss207.savePostingLimits, function() {
								changeTag = 0;
								refreshTbg();
								objGiiss207.displayValue();
							},"");
							return false;
	                	} else {
							issueSourceListingRowValue = issueSourceListingTableGrid.geniisysRows[y]; 
							postingLimitTableGrid.url = contextPath + "/GIISPostingLimitController?action=getPostingLimits&userId=" + userListingRowValue.userId + "&issCd=" + issueSourceListingRowValue.issCd;
							postingLimitTableGrid._refreshList();
			 				enableForm();
	                	}
					},
				 	onRemoveRowFocus: function(){
				 		issueSourceListingTableGrid.keys.removeFocus(issueSourceListingTableGrid.keys._nCurrentFocus, true);
				 		if (changeTag == 1){
		            	 	showConfirmBox4("Save", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",objGiiss207.savePostingLimits, function() {
								changeTag = 0;
								refreshTbg();
								objGiiss207.displayValue();
							},"");
							return false;
	                	} else {
	                		refreshTbg();
	                		objGiiss207.displayValue();
	                		objGiiss207.resetForm();
						}
					},
	            	beforeSort: function(){
		            	if (changeTag == 1){
		            		showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
							return false;
	                	}
	            	},
	            	onSort: function(){
		            	if (changeTag == 1){
		            		showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
							return false;
	                	} else {
	                		refreshTbg();
	                		objGiiss207.displayValue();
	                		objGiiss207.resetForm();
	                	}
	            	},
	            	prePager: function(){
		            	if (changeTag == 1){
		            		showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
							return false;
	                	} else {
	                		refreshTbg();
	                		objGiiss207.displayValue();
	                		objGiiss207.resetForm();
	                	}
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
					masterDetailNoFunc: function(){
						return (changeTag == 1 ? true : false);
					},
					onRefresh: function(){
		            	if (changeTag == 1){
		            		showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
							return false;
	                	} else {
	                		refreshTbg();
	                		objGiiss207.displayValue();
	                		objGiiss207.resetForm();
	                		issueSourceListingRowValue = null;
	                	}
					},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
						onFilter: function(){
			            	if (changeTag == 1){
			            		showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
								return false;
		                	} else {
		                		refreshTbg();
		                		objGiiss207.displayValue();
		                		objGiiss207.resetForm();
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
						width: '150px',
						visible: true,
						filterOption: true
					},
					{	
						id: 'issName',
						title: 'Issue Name',
						width: '270px',
						visible: true,
						filterOption: true
					}
				],
				rows: objIssueSourceList.objIssueSourceListingRows
		};
		issueSourceListingTableGrid = new MyTableGrid(issueSourceListingTable);
		issueSourceListingTableGrid.pager = objIssueSourceList.objIssueSourceListing;
		issueSourceListingTableGrid.render('issuingSourceTableGridDiv');
		issueSourceListingTableGrid.afterRender = function(){
			objIssueSourceListingMain = issueSourceListingTableGrid.geniisysRows;
		};
		
 		function refreshTbg() {
 			issueSourceListingTableGrid.keys.releaseKeys();
    		postingLimitTableGrid.url = contextPath + "/GIISPostingLimitController?action=getPostingLimits";
    		postingLimitTableGrid._refreshList();
		} 
		
  		function enableForm() {
			issueSourceListingTableGrid.keys.releaseKeys();
			enableInputField("txtLineName");
			enableInputField("txtPostingLimit");
			enableInputField("txtEndtPostingLimit");
			enableSearch("btnSearchLine");
			disableButton("btnDeletePostingLimit");
			enableButton("btnAddPostingLimit");
			enableButton("btnCopyToAnotherUserPostingLimit");
			$("chkAllAmount").disabled = false;
			$("chkEndtAllAmount").disabled = false;
			//$("txtLineName").focus();   Gzelle 03212014
			objGiiss207.displayValue();
		}
  		
	}catch (e) {
		showErrorMessage("Issue Source Listing Table Grid", e);
	}
</script>