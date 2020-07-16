import Cocoa

class Singer {
    func playSong() {
        print("Shake it off!")
    }
}

func sing() -> () -> Void {
    let taylor = Singer()

    let singing = { [unowned taylor] in
        taylor.playSong()
        return
    }

    return singing
}

let a = sing()
a()
