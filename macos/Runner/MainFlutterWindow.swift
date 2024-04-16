import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
    override func awakeFromNib() {
        let flutterViewController = FlutterViewController()
        let windowFrame = self.frame
        self.contentViewController = flutterViewController
        self.setFrame(windowFrame, display: true)
        
        self.minSize = NSSize(width: 300, height: 500)
        RegisterGeneratedPlugins(registry: flutterViewController)
        super.awakeFromNib()
    }
}
