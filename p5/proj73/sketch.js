
function PVector (x, y) {
	this.x = x
	this.y = y
}

var sparks = []
var beam = new Beam(new PVector(0, 0), new PVector(700,700), 10, .1)
function setup() {
	createCanvas(windowWidth,windowHeight)
	stroke(255)
	strokeWeight(4)
}

function draw() {
	background(35)
	beam.draw()
	/*
	var length = array.length

	for (var i = 0 i < length i++) {
		sparks[i].draw
	}
	*/
}

var beamId = 0

function Beam (loc, dest, duration, rate) {

	this.elapsed = 0
	this.loc = loc
	this.init_loc = new PVector(loc.x, loc.y)
	this.dest = dest
	this.duration = duration
	this.rate = rate
	this.NOISE_OFF = 0

	this.draw = function() {
		if(this.elapsed > this.duration)
			return false
		var x = loc.x
		var y = loc.y

		var x_off = 200 * (noise(this.elapsed + this.NOISE_OFF) - noise(this.NOISE_OFF))
		var y_off = 200 * (noise(this.elapsed + 100 + this.NOISE_OFF) - noise(100 + this.NOISE_OFF))

		this.loc.x = lerp(this.init_loc.x, this.dest.x, this.elapsed/this.duration) + x_off
		this.loc.y = lerp(this.init_loc.y, this.dest.y, this.elapsed/this.duration) + y_off

		if(this.elapsed > 0) {
			push()
			line(x, y, this.loc.x, this.loc.y)
			pop()
		}
		this.elapsed += this.rate
		return true
	}
}

function Spark (x, y, n) {
	
}