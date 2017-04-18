<input id="notIn"  type="hidden" value="${notIn }"/>
<input id="findText" type="hidden" />

<div id="docsListTableGrid" style="width: 550px; padding: 10px; height: 305px; margin-top : 30px;"></div>

<script>
	try{
		var objDocsList = JSON.parse('${objDocsList}');
		var docsindex; 
		
		var docsListTable = {
			url:  contextPath+"/GICLReqdDocsController?action=getDocsList&refresh=1&notIn="+$F("notIn")+"&lineCd="+objCLMGlobal.lineCd
			+"&sublineCd="+objCLMGlobal.sublineCd+"&findText="+escapeHTML2($F("findTextInput"))+"&claimId="+objCLMGlobal.claimId,
			options:{
				title: '',
				//querySort: false,
				height:'305px',
				beforeSort: function(){
					if(changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
						return false;
					} else {
						return true;
					}
				},
		      	onCellFocus: function(element, value, x, y, id){
					var mtgId = docsListTableGrid._mtgId;
					docsindex = -1;
					if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
						docsindex = y;
					}
				},onCellBlur: function(){
				}
			},
			columnModel :[
				{
					id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
				    title: '',
				    altTitle: 'Select?',
				    width: 23,
				    sortable: false,
				    editable: true, 			// if 'editable: false,' and 'sortable: false,' and editor is checkbox or instanceof CellCheckbox then hide the 'Select all' checkbox button in header
				    editor: 'checkbox',
				    hideSelectAllBox: true	
				},{
					id: 'divCtrId',
					width: '0',
					visible: false
				},
				{
					title: 'Code',
					id: 'clmDocCd',
					titleAlign : 'left',
					width : 70,
					align : 'left',
	                editable: false
				},
				{
					title: 'Claim Document',
					id: 'clmDocDesc',
					titleAlign : 'left',
					width : 420,
					align : 'left',
	                editable: false
				}
			],
			rows: objDocsList.rows
		};
		docsListTableGrid = new MyTableGrid(docsListTable);
		docsListTableGrid.render('docsListTableGrid');
	}catch(e){
		showErrorMessage("Docs List tablegrid creation",e);
	}
</script>