<div id="perilClassMaintenanceDiv">
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Peril Class</label> <span class="refreshers"
				style="margin-top: 0;"> <label id="gro" name="gro"
				style="margin-left: 5px;">Hide</label> 
				<label id="perilClassReloadForm" name="perilClassReloadForm">Reload Form</label>
			</span>
		</div>
	</div>	
	<div class="sectionDiv" id="perilClassTableSectionDiv" name="perilClassTableSectionDiv" style="height:300px;">
		<div id="perilClassTableGridSubDiv" name="perilClassTableGridSubDiv" changeTagAttr="true" class="subSectionDiv">
			<input type="hidden" id="hidClassCd" name="hidClassCd">
			<div id="perilClassTableGrid" style="height: 245px;left:265px;top:15px;border-bottom: 0px; position:relative;"></div>
		</div>
	</div>
</div>
<script>
var objPerilClassCd = new Object();
	$("signatoryExit").stopObserving("click"); 
	$("signatoryExit").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No","Cancel", 
					function(){
						objUWGlobal.giiss062Obj.savePerilClass();
						goToModule("/GIISUserController?action=goToUnderwriting","Underwriting Main", null);
					}, function(){
						goToModule("/GIISUserController?action=goToUnderwriting","Underwriting Main", null);
						changeTag = 0;
					}, "");
		}else{
			goToModule("/GIISUserController?action=goToUnderwriting","Underwriting Main", null);
		}
	});
	
	$("btnCancelPerilClass").observe("click", function(){
		$("signatoryExit").click();
	});
	

	try {
		var objPerilClassCd = null;
		var objPerilClass = new Object();
		objPerilClass.objPerilClassTableGrid = JSON.parse('${jsonPerilClass}');
		objPerilClass.objPerilClassList = objPerilClass.objPerilClassTableGrid.rows
				|| [];
		
		var perilClassModel = {
			url : contextPath
					+ "/GIISPerilsPerPerilClassController?action=getPerilsPerClass&moduleId=GIIS062",
			options : {
				title : '',
				width : '420px',
				checkChanges : false,
				beforeClick : function(element, value, x, y, id) {
					return objUWGlobal.giiss062Obj.validateChanges(perilClassTableGrid);
					perilClassTableGrid.keys.removeFocus(perilClassTableGrid.keys._nCurrentFocus, true);
					perilClassTableGrid.keys.releaseKeys();
				},
				beforeSort: function(){
					return objUWGlobal.giiss062Obj.validateChanges(perilClassTableGrid);
					perilClassTableGrid.keys.removeFocus(perilClassTableGrid.keys._nCurrentFocus, true);
					perilClassTableGrid.keys.releaseKeys();
				},
				onSort: function(){
					resetFields();
                },
				postPager: function () {
					resetFields();
				},
				onCellFocus : function(element, value, x, y, id) {
					row = y;
					objPerilClassCd = perilClassTableGrid.geniisysRows[y];
					objPerilClassCd.rowIndex = row;
					 $("hidClassCd").value = objPerilClassCd == null ? "" : unescapeHTML2(objPerilClassCd.classCd);
					perilClassDetailGrid.url = contextPath+"/GIISPerilsPerPerilClassController?action=getPerilsPerClassDetails"+"&classCd="+objPerilClassCd.classCd;
					perilClassDetailGrid._refreshList();
					objUWGlobal.giiss062Obj.populatePerilDetails(null);
					perilClassDetailGrid.keys.releaseKeys();
					perilClassTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
// 					showPerilsPerClass(ajax=2);
					objPerilClassCd = null;
					perilClassCd= null;
					resetFields();
				},
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN,MyTableGrid.REFRESH_BTN ],
					onRefresh: function(){
						if (changeTag == 1) {
							showConfirmBox("Confirmation", "Refreshing list will discard changes. Do you want to continue?", "Yes", "No", function(){
								resetFields();
								return true;
                			}, function () {
                				return false;
							});
						} else {
							resetFields();
							return true;
						}
					},
					onFilter: function(){
						resetFields();
					}
				}
			},
			columnModel : [{
				id: 'recordStatus',
			    width: '0',
			    visible: false,
			    editor: 'checkbox'
			 },{
				id: 'divCtrId',
			    width: '0',
			    visible: false
			 },{
				id : 'classCd',
				title : 'Peril Class Code',
				width : '100px',
				filterOption : true
			}, {
				id : 'classDesc',
				title : 'Peril Class Description',
				width : '300px',
				filterOption : true
			}, {
				id : 'userId',
				title : '',
				width : '0',
				visible : false
			}, {
				id : 'lastUpdate',
				title : '',
				width : '0',
				visible : false
			}, {
				id : 'remarks',
				title : '',
				width : '0',
				visible : false
			}, {
				id : 'cpiRecNo',
				title : '',
				width : '0',
				visible : false
			}, {
				id : 'cpiBranchCd',
				title : '',
				width : '0',
				visible : false
			}, ],
			rows : objPerilClass.objPerilClassList
		};

		perilClassTableGrid = new MyTableGrid(perilClassModel);
		perilClassTableGrid.pager = objPerilClass.objPerilClassTableGrid;
		perilClassTableGrid.render('perilClassTableGrid');
	} catch (e) {
		showErrorMessage("perilsPerPerilClass.jsp", e);
	}

		
	setDocumentTitle("Perils per Peril Class Maintenance");
	setModuleId("GIISS062");
	initializeAccordion();
	initializeAll();
	observeReloadForm("perilClassReloadForm", showPerilsPerClass);
	
	function resetFields() {
		perilClassDetailGrid.url = contextPath+ "/GIISPerilsPerPerilClassController?action=getPerilsPerClassDetails";
		perilClassDetailGrid._refreshList();
		perilClassDetailGrid.keys.releaseKeys();
		perilClassTableGrid.keys.releaseKeys();
		objUWGlobal.giiss062Obj.populatePerilDetails(null);
		$("hidClassCd").clear();
		changeTag = 0;
	}
</script>