/**
 * Shows LOV for Marine Hull
 * @author robert
 * @date 12.14.2011
 */
function getMarineHullLOV() {
	LOV.show({
		controller: "MarketingLOVController",
		urlParameters: {action : "getMarineHullLOV",
									  page : 1},
		title: "Vessel Name",
		width: 500,
		height: 403,
		columnModel: [ {   id: 'recordStatus',
							    title: '',
							    width: '0',
							    visible: false,
							    editor: 'checkbox' 			
							},
							{	id: 'divCtrId',
								width: '0',
								visible: false
							},
							{
								id: 'vesselName',
								title: 'Vessel Name',
								sortable: false,
								width: '300px'
							},
							{
								id: 'vesselOldName',
								title: 'Vessel Old Name',
								sortable: false,
								width: '300px'
							},
							{
								id: 'vestypeDesc',
								title: 'Description',
								sortable: false,
								width: '300px'
							},
							{
								id: 'propelSw',
								title: 'Propel Sw',
								sortable: false,
								width: '150px'
							},
							{
								id: 'hullTypeDesc',
								title: 'Hull Description',
								sortable: false,
								width: '250px'
							},
							{
								id: 'grossTon',
								title: 'Gross Ton',
								sortable: false,
								titleAlign: 'right',
								align: 'right',
								width: '140px'
							},
							{
								id: 'yearBuilt',
								title: 'Year Built',
								sortable: false,
								titleAlign: 'right',
								align: 'right',
								width: '80px'
							},
							{
								id: 'vessClassDesc',
								title: 'Vessel Class Description',
								sortable: false,
								width: '250px'
							},
							{
								id: 'regOwner',
								title: 'Owner',
								sortable: false,
								width: '500px'
							},
							{
								id: 'regPlace',
								title: 'Place',
								sortable: false,
								width: '300px'
							},
							{
								id: 'noCrew',
								title: 'No Crew',
								sortable: false,
								titleAlign: 'right',
								align: 'right',
								width: '100px'
							},
							{
								id: 'netTon',
								title: 'Net Ton',
								sortable: false,
								titleAlign: 'right',
								align: 'right',
								width: '150px'
							},
							{
								id: 'deadweight',
								title: 'Dead Ton',
								sortable: false,
								titleAlign: 'right',
								align: 'right',
								width: '120px'
							},
							{
								id: 'crewNat',
								title: 'Nationality',
								sortable: false,
								width: '250px'
							},
							{
								id: 'dryPlace',
								title: 'Dry Place',
								sortable: false,
								width: '250px'
							},
							{
								id: 'dryDate',
								title: 'Dry Date',
								sortable: false,
								width: '160px',
								renderer : function(value){
									return value == "" ? "" : dateFormat(value, "mm-dd-yyyy");
								}
							},
							{
								id: 'vesselLength',
								title: 'Vessel Length',
								sortable: false,
								titleAlign: 'right',
								align: 'right',
								width: '150px'
							},
							{
								id: 'vesselBreadth',
								title: 'Vessel Breadth',
								sortable: false,
								titleAlign: 'right',
								align: 'right',
								width: '150px'
							},
							{
								id: 'vesselDepth',
								title: 'Vessel Depth',
								sortable: false,
								titleAlign: 'right',
								align: 'right',
								width: '150px'
							}
		              ],
		draggable: true,
  		onSelect: function(row){
  				$("txtVesselCd").value = unescapeHTML2(row.vesselCd);
				$("txtVesselName").value = unescapeHTML2(row.vesselName);
				$("txtVesselOldName").value = unescapeHTML2(row.vesselOldName);
				$("txtVestypeDesc").value = unescapeHTML2(row.vestypeDesc);
				$("txtPropelSw").value = unescapeHTML2(row.propelSw);
				$("txtHullDesc").value = unescapeHTML2(row.hullTypeDesc);
				$("txtGrossTon").value =row.grossTon;
				$("txtYearBuilt").value = row.yearBuilt;
				$("txtVessClassDesc").value = unescapeHTML2(row.vessClassDesc);
				$("txtRegOwner").value = unescapeHTML2(row.regOwner);
				$("txtRegPlace").value = unescapeHTML2(row.regPlace);
				$("txtNoCrew").value = row.noCrew;
				$("txtNetTon").value = row.netTon;
				$("txtDeadweight").value = row.deadweight;
				$("txtCrewNat").value = unescapeHTML2(row.crewNat);
				$("txtDryPlace").value = unescapeHTML2(row.dryPlace);
				$("txtDryDate").value = row.dryDate == null ? "" : dateFormat(row.dryDate, "mm-dd-yyyy");
				$("txtVesselLength").value = row.vesselLength;
				$("txtVesselBreadth").value = row.vesselBreadth;
				$("txtVesselDepth").value = row.vesselDepth;
				$("txtVesselName").focus();
  		},
  		onCancel: function(){
  				$("txtVesselName").focus();
  		}
	});
}