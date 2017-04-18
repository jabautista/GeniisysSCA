<div class="sectionDiv" id="expensePayeesTableGridSectionDiv" style="border: 0px;">
	<div id="expensePayeesDiv" name="expensePayeesDiv" style="width: 100%;">
		<div id="expensePayeesTableGridDiv" style="padding: 10px 37px;">
				<div id="expensePayeesGrid" style="height: 210px; margin: 10px; margin-bottom: 5px; width: 830px;"></div>					
		</div>
	</div>
</div>
<div  id="expensePayeesSectionDiv" class="sectionDiv" style="border: 0px;">
	<div style="margin-top: 10px; margin-bottom: 20px; margin-left:45px; float: left; width: 830px;  ">
		<table border="0">
			<tr>
				<td class="rightAligned"  width="180px">Phone No.</td>
				<td class="leftAligned"><input type="text" style="width: 250px;" id="txtEPPhoneNo" name="txtEPPhoneNo" readonly="readonly" value=""/></td>
				<td class="rightAligned" width="250px">Mailing Adress</td>
				<td class="leftAligned"><input type="text" style="width: 300px;" id="txtEPMailAddress1" name="txtEPMailAddress1" readonly="readonly"/></td>					
			</tr>
			<tr>
				<td class="rightAligned">Adjuster</td>
				<td class="leftAligned">
					<div style="width:260px; border: none;">
						<input type="text" style="width: 72px;" id="txtEPPrivAdjCd" name="txtEPPrivAdjCd" value="" readonly="readonly"/>
						<input type="text" style="width: 165px;" id="txtEPAdjName" name="txtEPAdjName" value="" readonly="readonly"/>
					</div>
				</td>
				<td class="rightAligned"></td>
				<td class="leftAligned"><input type="text" style="width: 300px;" id="txtEPMailAddress2" name="txtEPMailAddress2" readonly="readonly" value=""/></td>
			</tr>
			<tr>
				<td class="rightAligned">Assign Date</td>
				<td class="leftAligned"><input type="text" style="width: 250px;" id="txtEPAssignDate" name="txtEPAssignDate" readonly="readonly" value=""/></td>
				<td class="rightAligned"></td>
				<td class="leftAligned" style="width: 450px;"><input type="text" style="width: 300px;" id="txtEPMailAddress3" name="txtEPMailAddress2" readonly="readonly" value=""/></td>
			</tr>
			<tr>
				<td colspan="6"><div style="border-top: 1.25px solid #c0c0c0; margin: 10px 0;"></div></td>
			</tr>
		</table>
		<table border="0">	
			<tr>
				<td class="rightAligned" width="90px">Remarks</td>
				<td class="leftAligned" colspan="3"  width="380px">
					<div style="border: 1px solid gray; height: 20px;">
						<textarea id="txtEPRemarks" name="txtEPRemarks" style="width: 340px; border: none; height: 13px; resize:none;" readonly="readonly"></textarea>
						<img class="hover" src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editEPRemarks" />
					</div>
				</td>
				<td rowspan="2" style="padding-left: 15px;">
					<input id="btnLossPayees" 	  name="btnLossPayees"   type="button"  class="button" value="Loss Payees" style="width: 120px;">
				</td>
			</tr>
			<tr>
				<td class="rightAligned">User Id</td>
				<td class="leftAligned"><input type="text" style="width: 120px;" id="txtEPUserId" name="txtEPUserId" readonly="readonly" value=""/></td>
				<td class="rightAligned" width="235px">Last Update</td>
				<td class="leftAligned" width="150px"><input type="text" style="width: 160px;" id="txtEPLastUpdate" name="txtEPLastUpdate" readonly="readonly" value=""/></td>					
			</tr>
			<tr></tr>
			<tr></tr>
		</table>
	</div>
</div>

<script>
	try{
		var objExpPayees = JSON.parse('${jsonGiclExpPayees}'.replace(/\\/g, '\\\\'));
		objExpPayees.expPayeesList = objExpPayees.rows || [];
		
		var expPayeesTableModel = {
			id: 'EP',
			url : contextPath+ "/GICLExpPayeesController?action=showGICLS260ExpensePayees&claimId="+ objCLMGlobal.claimId,
			options : {
				title : '',
				width : '830px',
				pager: {},
				hideColumnChildTitle: true,
				toolbar : {
					elements : [ MyTableGrid.REFRESH_BTN],
					onRefresh : function() {
						populateExpPayeesFields(null);
						expPayeesTableGrid.keys.removeFocus(expPayeesTableGrid.keys._nCurrentFocus, true);
						expPayeesTableGrid.keys.releaseKeys();
					}
				},
				onCellFocus : function(element, value, x, y, id) {
					var obj = expPayeesTableGrid.geniisysRows[y];
					populateExpPayeesFields(obj);
					expPayeesTableGrid.keys.removeFocus(expPayeesTableGrid.keys._nCurrentFocus, true);
					expPayeesTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus : function() {
					populateExpPayeesFields(null);
					expPayeesTableGrid.keys.removeFocus(expPayeesTableGrid.keys._nCurrentFocus, true);
					expPayeesTableGrid.keys.releaseKeys();
				},
				onSort : function() {
					populateExpPayeesFields(null);
					expPayeesTableGrid.keys.removeFocus(expPayeesTableGrid.keys._nCurrentFocus, true);
					expPayeesTableGrid.keys.releaseKeys();
				}
			},
			columnModel:[
			    {
					id : 'recordStatus',
					title : '',
					width : '0',
					visible : false,
					editor : 'checkbox'
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},
				{
					id : 'payeeClassCd payeeClassDesc',
					title : 'Payee Class',
					width : '280px',
					sortable : false,					
					children : [
						{
							id : 'payeeClassCd',							
							width : 80,							
							sortable : false,
							editable : false,	
							align: 'right'
						},
						{
							id : 'payeeClassDesc',							
							width : 200,
							sortable : false,
							editable : false
						}
					]					
				},	
				{
					id : 'adjCompanyCd adjCompanyName',
					title : 'Expense Payee',
					width : '535px',
					sortable : false,					
					children : [
						{
							id : 'adjCompanyCd',							
							width : 85,							
							sortable : false,
							editable : false,	
							align: 'right'
						},
						{
							id : 'adjCompanyName',							
							width : 450,
							sortable : false,
							editable : false
						}
				   ]					
				}
			],
			rows : objExpPayees.expPayeesList
		};
			
		expPayeesTableGrid = new MyTableGrid(expPayeesTableModel);
		expPayeesTableGrid.pager = objExpPayees;
		expPayeesTableGrid.render('expensePayeesGrid');
		
		function populateExpPayeesFields(obj){
			$("txtEPPhoneNo").value 	 = obj == null ? "" : unescapeHTML2(obj.phoneNo);
			$("txtEPPrivAdjCd").value 	 = obj == null ? "" : obj.privAdjCd;
			$("txtEPAdjName").value 	 = obj == null ? "" : unescapeHTML2(obj.adjName);
			$("txtEPAssignDate").value 	 = obj == null ? "" : unescapeHTML2(obj.strAssignDate);
			$("txtEPMailAddress1").value = obj == null ? "" : unescapeHTML2(obj.mailAddr1);
			$("txtEPMailAddress2").value = obj == null ? "" : unescapeHTML2(obj.mailAddr2);
			$("txtEPMailAddress3").value = obj == null ? "" : unescapeHTML2(obj.mailAddr3);
			$("txtEPRemarks").value 	 = obj == null ? "" : unescapeHTML2(obj.remarks);	
			$("txtEPUserId").value 		 = obj == null ? "" : unescapeHTML2(obj.userId);
			//$("txtEPLastUpdate").value 	 = obj == null ? "" : (nvl(obj.lastUpdate, null) != null ? dateFormat(obj.lastUpdate, "mm-dd-yyyy hh:MM:ss TT") : "");
			$("txtEPLastUpdate").value 	 = obj == null ? "" : (nvl(obj.lastUpdate, null) != null ? obj.strLastUpdate + dateFormat(obj.lastUpdate, " hh:MM:ss TT") : ""); //jeffdojello 12.06.2013 workaround to handle date format issue
		}
		
		$("editEPRemarks").observe("click", function(){showEditor("txtEPRemarks", 4000, 'true');});
		
		$("btnLossPayees").observe("click", function(){
			new Ajax.Request( contextPath + "/GICLClmClaimantController?action=showGICLS260LossPayees", {
				method: "GET",
				parameters: {
					claimId: objCLMGlobal.claimId,
					ajax: 1
				},
				asynchrous: true,
				evalScripts: true,
				onCreate : function() {
					showNotice("Loading, please wait...");
				},
				onComplete: function (response){
					hideNotice("");
					if(checkErrorOnResponse(response)){
						$("tabPayeesContents").update(response.responseText);
					}else{
						showMessageBox(response.responseText, "E");
					}
				}
			});
		});
		
	}catch(e){
		showErrorMessage("Claim Information - Expense Payees", e);
	}
	
</script>