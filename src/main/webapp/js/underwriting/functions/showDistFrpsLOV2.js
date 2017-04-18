/*
 * Created by : Robert Virrey 08.10.2011 Description : LOV for GIUTS004
 * Modified by : andrew 12.5.2012, added parameters lineCd, frpsYy, frpsSeqNo
 * Modified by : Nica 12.10.2012 replaced the action to consider user access 
 */
function showDistFrpsLOV2(lineCd, frpsYy, frpsSeqNo) {
	LOV.show({
		controller: "UnderwritingLOVController",
		urlParameters: {action : "getGIRIDistFrpsLOV3", //"getGIRIDistFrpsLOV2", replaced by: Nica 12.10.2012
						moduleId: "GIUTS004",
						lineCd : lineCd,
						frpsYy : frpsYy,
						frpsSeqNo : frpsSeqNo,
						page : 1},
		title: "List of FRPS",
		width: 750,
		height: 386,
		filterVersion : 2,
		columnModel: [ 
							{
								id: 'frpsNo',
								title: 'FRPS No.',
								width: '110px',
								filterOption: true
							},
							{
								id: 'policyNo',
								title: 'Policy No.',
								width: '180px',
								filterOption: true
							},
							{	id: 'assdName',
								title: 'Assured Name',
								width: '320px',
								filterOption: true
							},
							{	id: 'endtNo',
								title: 'Endorsement No.',
								width: '110px',
								filterOption: true
							}
		              ],
		draggable: true,
  		onSelect: function(row){
			 if(row != undefined) {
				 objRiFrps.lineCd = row.lineCd;
				 objRiFrps.frpsYy = row.frpsYy;
				 objRiFrps.frpsSeqNo = row.frpsSeqNo;
				 objRiFrps.frpsNo = row.frpsNo;
				 objRiFrps.endtNo = row.endtNo;
				 objRiFrps.policyNo = row.policyNo;
				 objRiFrps.assdName = row.assdName;
				 objRiFrps.distNo = row.distNo;
				 objRiFrps.riFlag = row.riFlag;
				 showReverseBinderPage("Y");
			 }
  		}
	});
}