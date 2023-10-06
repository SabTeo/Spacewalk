function timer_update(){
	for(i=0; i<5; i++){
		t0 = new Date( parseInt($('#'+i).text()) * 1000)
		tnow = new Date()
		tleft = t0-tnow
		var d = Math.floor(tleft / (1000 * 60 * 60 * 24));
		var h= Math.floor((tleft % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
		var m = Math.floor((tleft % (1000 * 60 * 60)) / (1000 * 60));
		var s = Math.floor((tleft % (1000 * 60)) / 1000);
		$('#t'+i).text(d+':'+h+':'+m+':'+s);
	}
}

window.timer = function(){
	timer_update()
	setInterval(function() {
		timer_update();
	}, 1000)
}
