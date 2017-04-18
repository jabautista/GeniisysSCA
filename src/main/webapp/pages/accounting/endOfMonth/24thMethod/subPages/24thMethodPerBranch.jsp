<div class="sectionDiv" style="width: 380px; margin-top:5px; margin-bottom:10px; height:227px;">
	<div id="branchTableGrid" style="height: 210px; margin-bottom:10px; margin-top:10px; margin-left:10px;"></div>
		<div style="margin-top: 10px; margin-bottom: 10px;">
			<table align="center" style="margin-top: 20px;">
				<tr>
					<td><input type="checkbox" id="chkTagAll" name="chkTagAll" tabindex="101"/></td>
					<td style="width: 100px;"><label for="chkTagAll">Tag All</label></td>
					<td><input type="checkbox" id="chkUntagAll" name="chkUntagAll" tabindex="102"/></td>
					<td><label for="chkUntagAll">Untag All</label></td>
				</tr>
			</table>
		</div>
		<div style="margin-top: 10px;">
			<table align="center">
				<td align="center"><input type="button" class="button" id="btnOk" name="btnOk" value="Ok" style="width:120px;" tabindex="201"/></td>
				<td align="center"><input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel" style="width:120px;" tabindex="202"/></td>
			</table>
		</div>
</div>

<script type="text/JavaScript">
		var count = 0;
		var jsonBranchList = JSON.parse('${branchList}');	
		branchListTableModel = {
				url : contextPath+"/GIACDeferredController?action=getBranchList&refresh=1&year="+objGiacs044.printYear+"&mM="+$F("selPeriodMmPrint"),
				options: {
					width: '360px',
					height: '210px',
					pager: {
					},
					onCellFocus : function(element, value, x, y, id) {
						row = branchListTableGrid.geniisysRows[y];
					},
					prePager: function(){
						branchListTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus : function(element, value, x, y, id){	
						branchListTableGrid.keys.releaseKeys();
					},
					onSort : function(){
						branchListTableGrid.keys.releaseKeys();
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
					   	id: 'I',
					   	title: "I",
				    	width: '50px',
		            	altTitle: "Include?",
						align : 'center',
						titleAlign : 'center',
						sortable : false,
				    	defaultValue: true,
						otherValue: true,
						editable: true,
				    	editor: new MyTableGrid.CellCheckbox({
			            	onClick: function(value, checked) {
			            		if (value == true) {
									count = count + 1;
									objGiacs044.selectedBranches.push(row);
								}
			    				if (count != jsonBranchList.total) {
			    					$("chkTagAll").checked = false;
			    					$("chkUntagAll").checked = false;
			    				}
			            	}		            	
					    })
					},
					{
						id : "branchCd",
						title: "Code",
						width: '100px'
					},		
					{
						id : "branchName",
						title: "Branch Name",
						width: '190px'
					}
					
				],
				rows: jsonBranchList.rows
			};
		
		branchListTableGrid = new MyTableGrid(branchListTableModel);
		branchListTableGrid.pager = jsonBranchList;
		branchListTableGrid.render('branchTableGrid');
		branchListTableGrid.afterRender = function() {
			untagAll();
			if (branchListTableGrid.rows.length == 0) {
				showMessageBox("There is no branch with valid transactions for "+ objGiacs044.printMm + " " + objGiacs044.printYear + ".");
			}
		};
		
		function tagAll() {		//tags all untagged records
    		if ($("chkTagAll").checked) {
    			for ( var i = 0; i < branchListTableGrid.rows.length; i++) {
    				$("mtgInput"+branchListTableGrid._mtgId+"_2,"+i).checked = true; 
    				objGiacs044.selectedBranches.push(branchListTableGrid.geniisysRows[i]);
				}$("chkUntagAll").checked = false;
			}
		}
		
		function untagAll() {	//untags all tagged records
			if ($("chkUntagAll").checked) {
    			for ( var i = 0; i < branchListTableGrid.rows.length; i++) {
    				$("mtgInput"+branchListTableGrid._mtgId+"_2,"+i).checked = false; 
				}$("chkTagAll").checked = false; 
			}
		}
		
		function getBranches() {
			for ( var i = 0; i < branchListTableGrid.rows.length; i++) {
				if ($("mtgInput"+branchListTableGrid._mtgId+"_2,"+i).checked == true) {
					objGiacs044.rowCount = objGiacs044.rowCount + 1;
				}
			}
		}
		
		$("chkTagAll").observe("click", function() {
			tagAll();
		});
	
		$("chkUntagAll").observe("click", function() {
			untagAll();
		});
		
		$("btnCancel").observe("click", function() {
			if (branchListTableGrid.rows.length == 0) {
				$("chkPerBranch").checked = false;
			}else {
				$("chkPerBranch").checked = true;
				fireEvent($("chkPerBranch"), "click");
				objGiacs044.selectedBranches.splice(row);
			}
			overlayBranchList.close();
		});
		
		$("btnOk").observe("click", function() {
			if (branchListTableGrid.rows.length == 0) {
				$("chkPerBranch").checked = false;
				overlayBranchList.close();
			}else {
				$("chkPerBranch").checked = true;
				fireEvent($("chkPerBranch"), "click");
				getBranches();
				overlayBranchList.close();
			}
		});
		
		//disableButton("btnOk");
</script>