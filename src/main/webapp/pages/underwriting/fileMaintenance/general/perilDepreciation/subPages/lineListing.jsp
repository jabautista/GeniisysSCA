<div id="perilDepreciationMaintenanceDiv">
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Line Listing</label>
			<span class="refreshers" style="margin-top: 0;">
				<label name="gro" name="gro" style="margin-left: 5px;">Hide</label> 
		 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	<div id="tableGridSectionDiv" name="tableGridSectionDiv" class="sectionDiv" style="height: 225px;">
		<div id="lineListTableGridDiv"  style="height: 245px;margin: 10px 0 0 270px;" ></div>
	</div>
</div>
	
<script type="text/javascript">

	try {	
			var row = 0;
			var objLineTable = [];
	        var objLineCd = null;
	        var objLine = new Object();
	        objLine.objLineListTG = JSON.parse('${jsonLineList}'.replace(/\\/g, '\\\\'));
	        objLine.objLineList = objLine.objLineListTG.rows || [];
	
	        var lineListModelTG = {
	            url : contextPath + "/GIEXPerilDepreciationController?action=showPerilDepreciationMaintenance",
	            options : {
	            	id    : 'table1',
	                title : '',
	                width : '399px',
	                height: '180px',
	                checkChanges : false,
	                onCellFocus : function(element, value, x, y, id) {
	                    row = y;
	                    objLineCd = lineListTableGrid.geniisysRows[y];  
	                    perilListTableGrid.url = contextPath+"/GIEXPerilDepreciationController?action=getGiiss208PerilDepreciationList"
															+"&lineCd="+objLineCd.lineCd;
	                    lineListTableGrid.keys.releaseKeys();
	        			$("txtPerilCd").focus();
	                    perilListTableGrid.refreshURL(perilListTableGrid);
	                    perilListTableGrid.refresh();
	                    $("txtLineCd").value =  objLineCd.lineCd;
	                    clearFields();
	                    clearLastValidValues();
	                    enableFields();
	                    enableLov();
	                },
	                onRemoveRowFocus : function(element, value, x, y, id) {
	                    if (changeTag == 1){
							showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
							return false;
	                	} else {
	                		lineListTableGrid.keys.releaseKeys(); 
		                    refreshPerilDepreciation();
		                   	clearFields();
		                   	clearLastValidValues();
		                   	disableFields();
		                    $("txtLineCd").value =  "";
		                    disableLov();
	                	}
	                },
	                beforeSort: function(){
		            	if (changeTag == 1){
							showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
							return false;
	                	} else {
	                		clearFields();	
	                		clearLastValidValues();
	                	}
	                },
	                onSort: function(){
	                	clearFields();
	                	clearLastValidValues();
	                	refreshPerilDepreciation();
	                	disableFields();
	                	disableLov();
	                },
	                prePager: function(){
		            	if (changeTag == 1){
							showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
							return false;
	                	} else {	            		
	                		clearFields();
	                		clearLastValidValues();
		                	refreshPerilDepreciation();
		                	disableFields();
		                	disableLov();
	                	}
	                },
	                onRefresh: function(){
	                		clearFields();
	                		clearLastValidValues();
		                	refreshPerilDepreciation();
		                	disableFields();
		                	disableLov();
					},
					beforeClick : function(element, value, x, y, id){				
						if(changeTag == 1){
							showMessageBox("Please save changes first.", imgMessage.INFO);
							return false;						
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
					masterDetailSaveFunc: function() {
						return (changeTag == 1 ? true : false);
					},
					masterDetailNoFunc: function(){
						return (changeTag == 1 ? true : false);
					},
	                toolbar : {
	                    elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
	                    		onFilter: function(){
	        	                		clearFields();
	        	                		clearLastValidValues();
	        		                	refreshPerilDepreciation();
	        		                	disableFields();
	        		                	disableLov();
	        					}
	                }               
	            },
	            columnModel : [ 
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
	                id : 'lineCd',
	                title : 'Line Code',
	                titleAlign: 'left',
	                width : '100px',
	                filterOption : true
	           		},
	           		{
	                id : 'lineName',
	                title : 'Line Name',
	                titleAlign: 'left',
	                width : '271px',
	                filterOption : true
	            	},],
	            		rows : objLine.objLineList
	        		};
	        lineListTableGrid = new MyTableGrid(lineListModelTG);
	        lineListTableGrid.pager = objLine.objLineListTG;
	        lineListTableGrid.render('lineListTableGridDiv');
	        lineListTableGrid.afterRender = function() {
	        	objLineTable = lineListTableGrid.geniisysRows;
				changeTag = 0;
	        };
	    } catch (e) {
	        showErrorMessage("Line Maintenance Table Grid", e);
	   }
	    
		function clearFields() {
			$("txtPerilCd").value = "";
			$("txtPerilName").value = "";
			$("txtDistributionRate").value = "";
			$("txtUserId").value = "";
			$("txtLastUpdate").value = "";
			$("btnAddPerilDepreciation").value = "Add";
		}

		function clearLastValidValues(){
			$("txtLastValidPerilCd").value = "";
			$("txtLastValidPerilName").value = "";
			$("txtLastValidDistributionRate").value = "";
		}
		
		function enableFields() {
			enableInputField("txtRemarks");	
			enableInputField("txtDistributionRate");		
		   	enableButton("btnAddPerilDepreciation");
		}
		
		function disableFields() {
			disableInputField("txtPerilCd");
			disableInputField("txtRemarks");
			disableInputField("txtDistributionRate");
			disableButton("btnAddPerilDepreciation");
			disableButton("btnDeletePerilDepreciation");
		}
		
		function refreshPerilDepreciation(){
			perilListTableGrid.url = contextPath+"/GIEXPerilDepreciationController?action=getGiiss208PerilDepreciationList";
            perilListTableGrid._refreshList();
		}
		
		function disableLov(){
			disableSearch("btnSearchPeril");
			//disableSearch("btnSearchPerilCode");
		}
		
		function enableLov(){
			enableSearch("btnSearchPeril");
			//enableSearch("btnSearchPerilCode");
		}
		
		disableFields();
		disableLov();
		
		observeReloadForm("reloadForm", showPerilDepreciationMaintenance);
</script>

