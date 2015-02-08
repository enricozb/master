import Foundation

class File {
 
	class func exists (path: String) -> Bool {
		return NSFileManager().fileExistsAtPath(path)
	}
	
	class func read() -> String {
		let bundle = NSBundle.mainBundle()
		let path = bundle.pathForResource("temp", ofType: "txt")
		return String(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: nil)!
	}
	
	class func write(content: String){
		
		let bundle = NSBundle.mainBundle()
		let path = bundle.pathForResource("temp", ofType: "txt")
		
		content.writeToFile(path!, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
		//println(path)
		/*
		let dirs : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String]
		if ((dirs) != nil) {
			let dir = dirs![0]; //documents directory
			let path = dir.stringByAppendingPathComponent("temp.txt");
			let text = "some text"
			
			//writing
			text.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding, error: nil);
		}
		*/
	}
}