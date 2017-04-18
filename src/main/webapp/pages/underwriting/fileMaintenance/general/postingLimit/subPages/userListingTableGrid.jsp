<!-- 
Date       : 11.14.2012
Modified by: Gzelle 
-->
<script type="text/javascript">
	try{
		var row = 0;
		var objUserListMain = [];
		var objUserList = new Object();
		objUserList.objUserListing = JSON.parse('${userListingObj}'.replace(/\\/g, '\\\\'));
		objUserList.objUserListingRows = objUserList.objUserListing.rows || [];
		
		var userListingTable = {
				id: 1,
				url: contextPath + "/GIISPostingLimitController?action=showUserListing",
				options: {
					height: '175px',
					width: '450px',
					onCellFocus: function(element, value, x, y, id){
						if (changeTag == 1){
		            	 	showConfirmBox4("Save", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",objGiiss207.savePostingLimits, function() {
								changeTag = 0;
								refreshTbg();
								resetForm();
								objGiiss207.displayValue();
							},"");
							return false;
	                	} else {
	                		userListingRowValue = userListingTableGrid.geniisysRows[y];
							issueSourceListingTableGrid.url = contextPath + "/GIISPostingLimitController?action=getIssueSourceListing&userId=" + userListingRowValue.userId;
							issueSourceListingTableGrid._refreshList();
							userListingTableGrid.keys.releaseKeys();
							objGiiss207.displayValue();
	                	}
					},
				 	onRemoveRowFocus: function(){
				 		userListingTableGrid.keys.removeFocus(userListingTableGrid.keys._nCurrentFocus, true);
		            	if (changeTag == 1){
		            		showConfirmBox4("Save", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", objGiiss207.savePostingLimits, function() {
								changeTag = 0;
								refreshTbg();
								resetForm();
								objGiiss207.displayValue();
							},"");
							return false;
	                	} else {
	                		refreshTbg();
	                		objGiiss207.displayValue();
	                		resetForm();
					 		userListingRowValue = null;
	                	}
	            	},
	            	beforeSort: function(){
		            	if (changeTag == 1){
		            		showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
							return false;
	                	}
	            	},
	            	onSort: function(){
	            		refreshTbg();
	            		objGiiss207.displayValue();
	            		resetForm();
	            	},
	                prePager: function(){
		            	if (changeTag == 1){
		            		showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
							return false;
	                	} else {
	                		refreshTbg();
	                		resetForm();
	                		objGiiss207.displayValue();
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
	                		resetForm();
	                		objGiiss207.displayValue();
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
		                		resetForm();
		                		objGiiss207.displayValue();
		                	}
						},
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
						id: 'userId',
						title: 'User ID',
						width: '150px',
						visible: true,
						filterOption: true
					},
					{	
						id: 'username',
						title: 'User Name',
						width: '272px',
						visible: true,
						filterOption: true
					}
				],
			  	rows: objUserList.objUserListingRows
		};
		userListingTableGrid = new MyTableGrid(userListingTable);
		userListingTableGrid.pager = objUserList.objUserListing;
		userListingTableGrid.render('userListingTableGridDiv');
		userListingTableGrid.afterRender = function(){
			objUserListingMain = userListingTableGrid.geniisysRows;
		};
	
	}catch (e) {
		showErrorMessage("User Listing Table Grid", e);
	}
	
 	function refreshTbg() {
 		userListingTableGrid.keys.releaseKeys();
 		issueSourceListingTableGrid.url = contextPath + "/GIISPostingLimitController?action=getIssueSourceListing";
 		issueSourceListingTableGrid._refreshList();
 		postingLimitTableGrid.url = contextPath + "/GIISPostingLimitController?action=getPostingLimits";
 		postingLimitTableGrid._refreshList();
	} 
 	
 	function resetForm() {
 		disableInputField("txtPostingLimit");
 		disableInputField("txtEndtPostingLimit");
 		disableSearch("btnSearchLine");
 		disableButton("btnCopyToAnotherUserPostingLimit");
 		disableButton("btnAddPostingLimit");
 		disableButton("btnDeletePostingLimit");
 		$("chkAllAmount").disabled = true;
 		$("chkEndtAllAmount").disabled = true;
 		$("txtLineName").value = "";
 		$("txtPostingLimit").value = "";
 		$("txtEndtPostingLimit").value = "";
 		$("chkAllAmount").checked = false;
 		$("chkEndtAllAmount").checked = false; 
	}
 	
 	objGiiss207.resetForm = resetForm;
 	userListingRowValue = null;
 	
</script>