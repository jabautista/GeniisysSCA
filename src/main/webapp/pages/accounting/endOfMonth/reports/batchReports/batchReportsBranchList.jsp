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

		monthDesc = $("dDnMonth").options[$("dDnMonth").selectedIndex].text;
		var count = 0;
		var jsonBranchList = JSON.parse('${batchBranchList}');	
		
		branchListTableModel = {
				url : contextPath+"/GIACEndOfMonthReportsController?action=getBatchBranchList&refresh=1&batchYear=" + $F("txtYear") + "&batchMonth=" + $F("dDnMonth"),
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
						width: '90px'
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
				showMessageBox("There is no branch with valid transactions for "+ monthDesc + " " + $F("txtYear") + ".");
				overlayBranchList.close();
			}
		};
		
		function tagAll() {
    		if ($("chkTagAll").checked) {
    			for ( var i = 0; i < branchListTableGrid.rows.length; i++) {
    				$("mtgInput"+branchListTableGrid._mtgId+"_2,"+i).checked = true; 
				}$("chkUntagAll").checked = false;
			}
		}
		
		function untagAll() {
			if ($("chkUntagAll").checked) {
    			for ( var i = 0; i < branchListTableGrid.rows.length; i++) {
    				$("mtgInput"+branchListTableGrid._mtgId+"_2,"+i).checked = false; 
				}$("chkTagAll").checked = false; 
			}
		}
		
		function getBranches() {
			for ( var i = 0; i < branchListTableGrid.rows.length; i++) {
				if ($("mtgInput"+branchListTableGrid._mtgId+"_2,"+i).checked == true) {
					objGiarpr001.selectedBranches.push(branchListTableGrid.geniisysRows[i]);
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
			objGiarpr001.selectedBranches = [];
			overlayBranchList.close();
		});
		
		$("btnOk").observe("click", function() {
			getBranches();
			overlayBranchList.close();
		});
		
</script>