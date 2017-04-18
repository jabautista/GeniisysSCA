<div id="cargoClassMainDiv" name="cargoClassMainDiv">
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Cargo Class</label>
			<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label>
			</span>
		</div>
	</div>

	<div id="cargoClassDiv" name="cargoClassDiv" class="sectionDiv" style="height: 270px;">
		<div id="cargoClassTGDiv" name="cargoClassTGDiv" style="float: left; width: 100%; height: 185px; padding: 10px 0 0 100px;">
		
		</div>
		<div id="cargoClassInfoDiv" name="cargoClassInfoDiv" style="float: left; padding-left: 200px;">
			<label style="padding: 6px 5px 0 0;">Cargo Class</label>
			<span class="lovSpan" style="width: 500px; margin-top: 4px;">
				<input id="cargoClass" name="cargoClass" type="text" style="border: none; float: left; width: 470px; height: 13px; margin: 0px;" readonly="readonly" tabindex="301"/>
				<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchCargoClass" name="searchCargoClass" alt="Go" style="float: right;" tabindex="302"/>
			</span>
		</div>
		<div id="cargoClassButtonsDiv" name="cargoClassButtonsDiv" class="buttonsDiv" style="float: left; width: 100%;">
			<input id="btnAddCargoClass" name="btnAddCargoClass" type="button" class="button" value="Add" tabindex="303">
			<input id="btnDeleteCargoClass" name="btnDeleteCargoClass" type="button" class="disabledButton" value="Delete" tabindex="304">
		</div>
		<div id="hiddenCargoClassDiv" name="hiddenCargoClassDiv" style="display: none;">
			<input id="cargoClassCdHid" name="cargoClassCdHid" type="hidden" value="">
		</div>
	</div>
</div>

<script type="text/javascript">
	objEndtLol.selectedCargoIndex = -1;
	objEndtLol.selectedCargoRow = "";
	objEndtLol.cargoClass = [];
	
	objEndtLol.objCargoClassTableGrid = JSON.parse('${cargoClassTableGrid}');
	objEndtLol.objCargoClassRows = objEndtLol.objCargoClassTableGrid.rows || []; 
	try{
		var cargoClassTableModel = {
			url: contextPath+"/GIPIWOpenCargoController?action=getEndtWOpenCargo&refresh=1&globalParId="+$F("globalParId")+"&geogCd="+$F("geogCd"),
			options: {
	          	height: '156px',
	          	width: '700px',
	          	onCellFocus: function(element, value, x, y, id){
	          		objEndtLol.selectedCargoIndex = y;
	          		objEndtLol.selectedCargoRow = cargoClassTableGrid.geniisysRows[y];
	          		populateCargoClassFields(true);
	          		cargoClassTableGrid.keys.releaseKeys();
	            },
	            onRemoveRowFocus: function(){
	            	objEndtLol.selectedCargoIndex = -1;
	          		objEndtLol.selectedCargoRow = "";
	          		populateCargoClassFields(false);
	          		cargoClassTableGrid.keys.releaseKeys();
	            },
	            beforeSort: function(){
	            	if(changeTagCargo == 1){
	            		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
	            		return false;
	            	}
	            },
	            onSort: function(){
	            	cargoClassTableGrid.onRemoveRowFocus();
	            },
	            toolbar: {
	            	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
	            	onRefresh: function(){
	            		cargoClassTableGrid.onRemoveRowFocus();
	            	},
	            	onFilter: function(){
	            		cargoClassTableGrid.onRemoveRowFocus();
	            	}
	            },
	            prePager: function(){
					if(changeTagCargo == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}
				},
                checkChanges: function(){
					return (changeTagCargo == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
				    return (changeTagCargo == 1 ? true : false);
				},
				masterDetailValidation: function(){
				    return (changeTagCargo == 1 ? true : false);
				},
				masterDetail: function(){
				    return (changeTagCargo == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
				    return (changeTagCargo == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
				    return (changeTagCargo == 1 ? true : false);
				}
			},
			columnModel:[
							{   id: 'recordStatus',
							    width: '0px',
							    visible: false,
							    editor: 'checkbox'
							},
							{	id: 'divCtrId',
								width: '0px',
								visible: false
							},
							{	id: 'cargoClassCd',
								title: 'Class',
								width: '71px',
								visible: true,
								filterOption: true,
								filterOptionType: 'integerNoNegative'
							},
							{	id: 'cargoClassDesc',
								title: 'Description',
								width: '600px',
								visible: true,
								filterOption: true
							}
						],  				
					rows: objEndtLol.objCargoClassRows
		};
		cargoClassTableGrid = new MyTableGrid(cargoClassTableModel);
		cargoClassTableGrid.pager = objEndtLol.objCargoClassTableGrid;
		cargoClassTableGrid.render('cargoClassTGDiv');
		cargoClassTableGrid.afterRender = function(){
			objEndtLol.cargoClass = cargoClassTableGrid.geniisysRows;
		};
	}catch(e){
		showMessageBox("Error in Cargo Class TableGrid: " + e, imgMessage.ERROR);
	}
	
	function populateCargoClassFields(populate){
		$("cargoClass").value = populate ? unescapeHTML2(objEndtLol.selectedCargoRow.cargoClassDesc) : "";
		$("cargoClassCdHid").value = populate ? objEndtLol.selectedCargoRow.cargoClassCd : "";
		if(populate){
			disableSearch("searchCargoClass");
			disableButton($("btnAddCargoClass"));
			enableButton($("btnDeleteCargoClass"));
		}else{
			enableSearch("searchCargoClass");
			enableButton($("btnAddCargoClass"));
			disableButton($("btnDeleteCargoClass"));
		}
	}
	
	function showCargoClassLOV(){
		try{
			var notIn = "";
			var withPrevious = false;
			var rows = (objEndtLol.cargoClass).filter(function(o){return nvl(o.recordStatus, 0) != -1;});
			
			for(var i = 0; i < rows.length; i++){
				notIn += withPrevious ? "," : "";
				notIn = notIn + rows[i].cargoClassCd;
				withPrevious = true;
			}
			
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {action : "getCargoClassLOV2",
								notIn  : notIn != "" ? "("+notIn+")" : "0"},
				title: "List of Cargo Classes",
				width: 421,
				height: 386,
				columnModel:[
				             	{	id : "cargoClassCd",
									title: "Class",
									width: '50px'
								},
								{	id : "cargoClassDesc",
									title: "Description",
									width: '355px'
								}
							],
				draggable: true,
				onSelect : function(row){
					if(row != undefined) {
						$("cargoClass").value = unescapeHTML2(row.cargoClassDesc);
						$("cargoClassCdHid").value = row.cargoClassCd;
					}
				}
			});
		}catch(e){
			showErrorMessage("showCargoClassLOV",e);
		}
	}
	
	function addCargoClass(){
		var rowObj = setObjCargoClass();
		objEndtLol.cargoClass.push(rowObj);
		cargoClassTableGrid.addBottomRow(rowObj);
		cargoClassTableGrid.onRemoveRowFocus();
		changeTag = 1;
		changeTagCargo = 1;
	}
	
	function deleteCargoClass(){
		var delObj = objEndtLol.selectedCargoRow;
		delObj.recordStatus = -1;
		objEndtLol.cargoClass.splice(objEndtLol.selectedCargoIndex, 1, delObj);
		cargoClassTableGrid.deleteVisibleRowOnly(objEndtLol.selectedCargoIndex);
		cargoClassTableGrid.onRemoveRowFocus();
		changeTag = 1;
		changeTagCargo = 1;
	}
	
	function setObjCargoClass(){
		var rowObjCargo = new Object();
		rowObjCargo.parId = $F("globalParId");
		rowObjCargo.geogCd = $F("geogCd");
		rowObjCargo.cargoClassCd = $F("cargoClassCdHid");
		rowObjCargo.cargoClassDesc = $F("cargoClass");
		rowObjCargo.recFlag = "A";
		rowObjCargo.recordStatus = 0;
		return rowObjCargo;
	}
	
	$("searchCargoClass").observe("click", function(){
		if($F("inputGeography") == ""){
			showMessageBox("Please select Geography first.", "I");
		}else{
			showCargoClassLOV();
		}
	});
	
	$("btnAddCargoClass").observe("click", function(){
		if($F("cargoClass") == ""){
			showMessageBox("Please select a Cargo Class.", "I");
		}else{
			addCargoClass();
		}
	});
	
	$("btnDeleteCargoClass").observe("click", function(){
		deleteCargoClass();
	});
</script>