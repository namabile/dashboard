(function($) {
	/*

	You can now create a spinner using any of the variants below:

	$("#el").spin(); // Produces default Spinner using the text color of #el.
	$("#el").spin("small"); // Produces a 'small' Spinner using the text color of #el.
	$("#el").spin("large", "white"); // Produces a 'large' Spinner in white (or any valid CSS color).
	$("#el").spin({ ... }); // Produces a Spinner using your custom settings.

	$("#el").spin(false); // Kills the spinner.

	*/

	$.fn.spin = function(opts, color) {
		var presets = {
			"tiny": { lines: 8, length: 2, width: 2, radius: 3 },
			"small": { lines: 8, length: 4, width: 3, radius: 5 },
			"large": { lines: 10, length: 8, width: 4, radius: 8 }
		};
		if (Spinner) {
			return this.each(function() {
				var $this = $(this),
					data = $this.data();

				if (data.spinner) {
					data.spinner.stop();
					delete data.spinner;
				}
				if (opts !== false) {
					if (typeof opts === "string") {
						if (opts in presets) {
							opts = presets[opts];
						} else {
							opts = {};
						}
						if (color) {
							opts.color = color;
						}
					}
					if(this.nodeName.toLowerCase() == 'input') {
						var pos = $this.position();
						data.spinner = new Spinner($.extend({color: $this.css('color')}, opts)).spin();
						$(data.spinner.el).css({
							position: 'absolute',
							top: pos.top+4+'px',
							left: pos.left+$this.width()-4+'px'
						}).insertAfter($this);
					} else {
						data.spinner = new Spinner($.extend({color: $this.css('color')}, opts)).spin(this);
					}
				}
			});
		} else {
			throw "Spinner class not available.";
		}
	};

})(jQuery);