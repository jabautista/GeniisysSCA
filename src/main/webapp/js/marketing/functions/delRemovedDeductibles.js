// created by d.alcantara 01/06/2011
function delRemovedDeductibles() {
	$$("div#deductiblesPerItem div[name='dRow']").each(function (ded) {
		var dItem	= ded.down("input", 0).value;
		var dPeril	= ded.down("input", 1).value;
		$$("div#removedDedDiv div[name='delDeduct']").each(function (rem) {
			if(dItem == rem.down("input", 1).value && dPeril == rem.down("input", 2).value) {
				ded.remove();
			}
		});
	});
}