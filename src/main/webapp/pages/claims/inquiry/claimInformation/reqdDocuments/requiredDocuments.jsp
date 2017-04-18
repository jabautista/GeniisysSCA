<div id="reqDocumentsMainDiv" name="reqDocumentsMainDiv" class="sectionDiv" style="border: 0;">
	<div id="reqDocumentsTableGridDiv" style="padding: 0px 25px;">
		<div id="reqDocumentsGridDiv" style="height: 330px; margin-top: 10px;">
			<div id="reqDocumentsTableGrid" style="height: 325px; width: 870px;"></div>
		</div>
	</div>
	<div style="margin: 0px 30px;" align="center">
		<table border="0" style="margin-top: 10px; margin-bottom: 10px; margin-left: 8px; width: 100%;">
			<tr>
				<td class="rightAligned" style="width: 130px;">Remarks</td>
				<td class="leftAligned" colspan="3">
					<div style="float:left; width: 635px;" class="withIconDiv">
						<textarea class="withIcon" id="txtRDRemarks" name="txtRDRemarks" style="width: 605px; resize:none;" readonly="readonly"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editTxtRDRemarks" />
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 130px;">Last Update</td>
				<td class="leftAligned">
					<input id="txtRDLastUpdate" name="txtRDLastUpdate" type="text" style="width: 150px;" value="" readonly="readonly"/>
				</td>
				<td class="rightAligned" style="width: 200px;">User Id</td>
				<td class="leftAligned">
					<input id="txtRDUserId" name="txtRDUserId" type="text" style="width: 200px;" value="" readonly="readonly"/>
				</td>
			</tr>
		</table>
	</div>
</div>

<script type="text/javascript">
try{
	objReqDocuments = JSON.parse('${jsonReqDocuments}'.replace(/\\/g, '\\\\'));
	objReqDocuments.reqdDocumentsList = objReqDocuments.rows || [];
	
	var reqDocsTableModel = {
			id:'RDocs', //added by steven 6/3/2013
			url: contextPath+ "/GICLReqdDocsController?action=showGICLS260ReqDocumentsListing&refresh=1&claimId="+ objCLMGlobal.claimId,
			options:{
				hideColumnChildTitle: true,
				pager: {},
				toolbar : {
					elements : [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onRefresh : function() {
						populateReqdDocsFields(null);
						reqDocsTableGrid.keys.removeFocus(reqDocsTableGrid.keys._nCurrentFocus, true);
						reqDocsTableGrid.keys.releaseKeys();
					}
				},
				onCellFocus: function(element, value, x, y, id){
					var obj = reqDocsTableGrid.geniisysRows[y]; 
					populateReqdDocsFields(obj);
					reqDocsTableGrid.keys.removeFocus(reqDocsTableGrid.keys._nCurrentFocus, true);
					reqDocsTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus: function ( x, y, element) {
					populateReqdDocsFields(null);
					reqDocsTableGrid.keys.removeFocus(reqDocsTableGrid.keys._nCurrentFocus, true);
					reqDocsTableGrid.keys.releaseKeys();
				},
				onSort: function ( x, y, element) {
					populateReqdDocsFields(null);
					reqDocsTableGrid.keys.removeFocus(reqDocsTableGrid.keys._nCurrentFocus, true);
					reqDocsTableGrid.keys.releaseKeys();
				}
			},
			columnModel : [
		   			{ 							
		   				id: 'recordStatus',
		   			  	width: '0',
		   			  	visible: false
		   			},
		   			{
		   				id: 'divCtrId',
		   			  	width: '0',
		   			  	visible: false 
		   		 	}, 
		   		 	{
						id: 'clmDocCd clmDocDesc',
						title: 'Claim Documents',
						titleAlign : 'center',
						sortable : false,
						width: 300,
						align : 'center',
						children: [
							{
								id : 'clmDocCd',
								title : 'Claim Document Code',
				                width : 50,
				                editable: false,
				                filterOption: true
							},{
								id : 'clmDocDesc',
								title : 'Claim Document Desc',
				                width : 300,
				                editable: false,
				                filterOption: true
							}          
						]
					},
					{
						title: 'Date Submitted',
						id: 'docSbmttdDt',
						titleAlign : 'center',
						width : 100,
						align : 'center',
		                editable: false,
		                filterOption: true
					},
					{
						title: 'Date Completed',
						id: 'docCmpltdDt',
						titleAlign : 'center',
						width : 100,
						align : 'center',
		                editable: false,
		                filterOption: true
					},
					{
						title: 'Received By',
						id: 'rcvdBy',
						titleAlign : 'center',
						width : 100,
						align : 'center',
						filterOption: true
					},
					{
						id: 'frwdFr frwdBy',
						title: 'Forwarded From',
						titleAlign : 'center',
						sortable : false,
						width: 200,
						align : 'center',
						children: [
							{
								id : 'frwdFr',
								title : 'Forwarded From',
				                width : 80,
				                editable: false,
				                filterOption: true
							},{
								id : 'frwdBy',
								title : 'Forwarded By',
				                width : 125,
				                editable: false,
				                filterOption: true
							}          
						]
					}
				],
			rows : objReqDocuments.reqdDocumentsList,
		};  
	
	reqDocsTableGrid = new MyTableGrid(reqDocsTableModel);
	reqDocsTableGrid.pager = objReqDocuments;
	reqDocsTableGrid.render('reqDocumentsTableGrid');
	
	function populateReqdDocsFields(obj){
		$("txtRDRemarks").value = obj == null ? "" : unescapeHTML2(obj.remarks); //added by steven 6/3/2013
		$("txtRDLastUpdate").value = obj == null ? "" : obj.lastupdate;
		$("txtRDUserId").value = obj == null ? "" : obj.userId;
	}
	
	$("editTxtRDRemarks").observe("click", function(){showEditor("txtRDRemarks", 4000, 'true');});
	
	hideNotice("");
}catch(e){
	showErrorMessage("Claim Information - Required Documents", e);
}	
</script>