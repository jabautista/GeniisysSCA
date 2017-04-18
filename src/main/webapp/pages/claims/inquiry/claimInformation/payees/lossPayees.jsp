<div class="sectionDiv" id="lossPayeesTableGridSectionDiv" style="border: 0px;">
	<div id="lossPayeesDiv" name="lossPayeesDiv" style="width: 100%;">
		<div id="lossPayeesTableGridDiv" style="padding: 10px 37px;">
				<div id="lossPayeesGrid" style="height: 210px; margin: 10px; margin-bottom: 5px; width: 830px;"></div>					
		</div>
	</div>
</div>
<div  id="lossPayeesSectionDiv" class="sectionDiv" style="border: 0px;">
	<div style="margin-top: 10px; margin-bottom: 20px; margin-left:50px; float: left; width: 830px;  ">
		<table border="0">
			<tr>
				<td class="rightAligned"  width="120px">Phone No.</td>
				<td class="leftAligned"><input type="text" style="width: 250px;" id="txtLPPhoneNo" name="txtLPPhoneNo" readonly="readonly" value=""/></td>
				<td class="rightAligned" width="250px">Mailing Adress</td>
				<td class="leftAligned"><input type="text" style="width: 300px;" id="txtLPMailAddress1" name="txtLPMailAddress1" readonly="readonly"/></td>					
			</tr>
			<tr>
				<td class="rightAligned">Fax No.</td>
				<td class="leftAligned"><input type="text" style="width: 250px;" id="txtLPFaxNo" name="txtLPFaxNo" readonly="readonly" value=""/></td>
				<td class="rightAligned"></td>
				<td class="leftAligned"><input type="text" style="width: 300px;" id="txtLPMailAddress2" name="txtLPMailAddress2" readonly="readonly" value=""/></td>
			</tr>
			<tr>
				<td class="rightAligned">Motorshop</td>
				<td class="leftAligned">
					<div style="width:260px; border: none;">
						<input type="text" style="width: 72px;" id="txtLPMcPayeeCd" name="txtLPMcPayeeCd" value="" readonly="readonly"/>
						<input type="text" style="width: 165px;" id="txtLPMcPayeeName" name="txtLPMcPayeeName" value="" readonly="readonly"/>
					</div>
				</td>
				<td class="rightAligned"></td>
				<td class="leftAligned" style="width: 450px;"><input type="text" style="width: 300px;" id="txtLPMailAddress3" name="txtLPMailAddress2" readonly="readonly" value=""/></td>
			</tr>
			<tr>
				<td colspan="6"><div style="border-top: 1.25px solid #c0c0c0; margin: 10px 0;"></div></td>
			</tr>
		</table>
		<table border="0">	
			<tr>
				<td class="rightAligned" width="80px">Remarks</td>
				<td class="leftAligned" colspan="3"  width="380px">
					<div style="border: 1px solid gray; height: 20px;">
						<textarea id="txtLPRemarks" name="txtLPRemarks" style="width: 340px; border: none; height: 13px; resize:none;" readonly="readonly"></textarea>
						<img class="hover" src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editLPRemarks" />
					</div>
				</td>
				<td rowspan="2" style="padding-left: 15px;">
					<input id="btnExpensePayees" 	  name="btnExpensePayees"   type="button"  class="button" value="Expense Payees" style="width: 120px;">
				</td>
			</tr>
			<tr>
				<td class="rightAligned">User Id</td>
				<td class="leftAligned"><input type="text" style="width: 120px;" id="txtLPUserId" name="txtLPUserId" readonly="readonly" value=""/></td>
				<td class="rightAligned" width="240px">Last Update</td>
				<td class="leftAligned" width="150px"><input type="text" style="width: 160px;" id="txtLPLastUpdate" name="txtLPLastUpdate" readonly="readonly" value=""/></td>					
			</tr>
			<tr></tr>
			<tr></tr>
		</table>
	</div>
</div>

<script>
	try{
		var expPayeesExist = '${expPayeesExist}';
		var objLossPayees = JSON.parse('${jsonGiclClmClaimant}'.replace(/\\/g, '\\\\'));
		objLossPayees.lossPayeesList = objLossPayees.rows || [];
		
		var lossPayeesTableModel = {
			id: 'LP',
			url : contextPath+ "/GICLClmClaimantController?action=showGICLS260LossPayees&claimId="+ objCLMGlobal.claimId,
			options : {
				title : '',
				width : '830px',
				pager: {}, 
				hideColumnChildTitle: true,
				toolbar : {
					elements : [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onRefresh : function() {
						populateLossPayeesField(null);
						lossPayeesTableGrid.keys.removeFocus(lossPayeesTableGrid.keys._nCurrentFocus, true);
						lossPayeesTableGrid.keys.releaseKeys();
					}
				},
				onCellFocus : function(element, value, x, y, id) {
					var obj = lossPayeesTableGrid.geniisysRows[y];
					populateLossPayeesField(obj);
					lossPayeesTableGrid.keys.removeFocus(lossPayeesTableGrid.keys._nCurrentFocus, true);
					lossPayeesTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus : function() {
					populateLossPayeesField(null);
					lossPayeesTableGrid.keys.removeFocus(lossPayeesTableGrid.keys._nCurrentFocus, true);
					lossPayeesTableGrid.keys.releaseKeys();
				},
				onSort : function() {
					populateLossPayeesField(null);
					lossPayeesTableGrid.keys.removeFocus(lossPayeesTableGrid.keys._nCurrentFocus, true);
					lossPayeesTableGrid.keys.releaseKeys();
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
					width : '285px',
					sortable : false,					
					children : [
						{
							id : 'payeeClassCd',
							title : 'Payee Class Code',
							width : 85,							
							sortable : false,
							editable : false,	
							align: 'right',
							filterOption: true
						},
						{
							id : 'payeeClassDesc',
							title : 'Payee Class Desc',
							width : 200,
							sortable : false,
							editable : false,
							filterOption: true
						}
				   ]					
				},	
				{
					id : 'clmntNo',
					title : 'Payee Code',
					width : '100',
					editable : false,
					filterOption : true,	
					align: 'right'
				}, 
				{
					id : 'payee',
					title : 'Payee Name',
					width : '430',
					editable : false,
					filterOption : true
				}
			],
			rows : objLossPayees.lossPayeesList
		};
			
		lossPayeesTableGrid = new MyTableGrid(lossPayeesTableModel);
		lossPayeesTableGrid.pager = objLossPayees;
		lossPayeesTableGrid.render('lossPayeesGrid');
		
		function populateLossPayeesField(obj){
			$("txtLPPhoneNo").value 	= obj == null ? "" : unescapeHTML2(obj.phoneNo);
			$("txtLPFaxNo").value 		= obj == null ? "" : unescapeHTML2(obj.faxNo);
			$("txtLPMcPayeeCd").value 	= obj == null ? "" : obj.mcPayeeCd;
			$("txtLPMcPayeeName").value = obj == null ? "" : unescapeHTML2(obj.mcPayeeName);
			$("txtLPMailAddress1").value = obj == null ? "" : unescapeHTML2(obj.mailAddr1);
			$("txtLPMailAddress2").value = obj == null ? "" : unescapeHTML2(obj.mailAddr2);
			$("txtLPMailAddress3").value = obj == null ? "" : unescapeHTML2(obj.mailAddr3);
			$("txtLPRemarks").value 	 = obj == null ? "" : unescapeHTML2(obj.remarks);	
			$("txtLPUserId").value 		 = obj == null ? "" : unescapeHTML2(obj.userId);
// 			$("txtLPLastUpdate").value 	 = obj == null ? "" : (nvl(obj.lastUpdate, null) != null ? dateFormat(obj.lastUpdate, "mm-dd-yyyy hh:MM:ss TT") : "");
			$("txtLPLastUpdate").value 	 = obj == null ? "" : (nvl(obj.lastUpdate, null) != null ? obj.sdfLastUpdate: "");//added by steven 06/03/2013;to handle the issue on formatting date.
		}
		
		$("editLPRemarks").observe("click", function(){showEditor("txtLPRemarks", 4000, 'true');});
		
		$("btnExpensePayees").observe("click", function(){
			new Ajax.Request( contextPath + "/GICLExpPayeesController?action=showGICLS260ExpensePayees", {
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
		
		if(nvl(expPayeesExist, "N") == "Y"){
			enableButton("btnExpensePayees");
		}else{
			disableButton("btnExpensePayees");
		}
		
	}catch(e){
		showErrorMessage("Claim Information - Loss Payees", e);
	}
	
</script>