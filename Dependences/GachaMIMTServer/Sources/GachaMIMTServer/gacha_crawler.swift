import RustXcframework
@_cdecl("__swift_bridge__$gotURL")
public func __swift_bridge__gotURL (_ url: RustStr) {
    gotURL(url: url)
}

public func no_used<GenericIntoRustString: IntoRustString>(_ _str: GenericIntoRustString) {
    __swift_bridge__$no_used({ let rustString = _str.intoRustString(); rustString.isOwned = false; return rustString.ptr }())
}

public class ProxyServer: ProxyServerRefMut {
    var isOwned: Bool = true

    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }

    deinit {
        if isOwned {
            __swift_bridge__$ProxyServer$_free(ptr)
        }
    }
}
extension ProxyServer {
    public convenience init() {
        self.init(ptr: __swift_bridge__$ProxyServer$new())
    }
}
public class ProxyServerRefMut: ProxyServerRef {
    public override init(ptr: UnsafeMutableRawPointer) {
        super.init(ptr: ptr)
    }
}
public class ProxyServerRef {
    var ptr: UnsafeMutableRawPointer

    public init(ptr: UnsafeMutableRawPointer) {
        self.ptr = ptr
    }
}
@available(iOS 13.0.0, *)
extension ProxyServerRef {
    public func start() async {
        func onComplete(cbWrapperPtr: UnsafeMutableRawPointer?) {
            let wrapper = Unmanaged<CbWrapper$ProxyServer$start>.fromOpaque(cbWrapperPtr!).takeRetainedValue()
            wrapper.cb(.success(()))
        }

        return await withCheckedContinuation({ (continuation: CheckedContinuation<(), Never>) in
            let callback = { rustFnRetVal in
                continuation.resume(with: rustFnRetVal)
            }

            let wrapper = CbWrapper$ProxyServer$start(cb: callback)
            let wrapperPtr = Unmanaged.passRetained(wrapper).toOpaque()

            __swift_bridge__$ProxyServer$start(wrapperPtr, onComplete, ptr)
        })
    }
    class CbWrapper$ProxyServer$start {
        var cb: (Result<(), Never>) -> Void

        public init(cb: @escaping (Result<(), Never>) -> Void) {
            self.cb = cb
        }
    }

    public func stop() async {
        func onComplete(cbWrapperPtr: UnsafeMutableRawPointer?) {
            let wrapper = Unmanaged<CbWrapper$ProxyServer$stop>.fromOpaque(cbWrapperPtr!).takeRetainedValue()
            wrapper.cb(.success(()))
        }

        return await withCheckedContinuation({ (continuation: CheckedContinuation<(), Never>) in
            let callback = { rustFnRetVal in
                continuation.resume(with: rustFnRetVal)
            }

            let wrapper = CbWrapper$ProxyServer$stop(cb: callback)
            let wrapperPtr = Unmanaged.passRetained(wrapper).toOpaque()

            __swift_bridge__$ProxyServer$stop(wrapperPtr, onComplete, ptr)
        })
    }
    class CbWrapper$ProxyServer$stop {
        var cb: (Result<(), Never>) -> Void

        public init(cb: @escaping (Result<(), Never>) -> Void) {
            self.cb = cb
        }
    }

    public func is_running() -> Bool {
        __swift_bridge__$ProxyServer$is_running(ptr)
    }

    public func get_uris() -> RustVec<RustString> {
        RustVec(ptr: __swift_bridge__$ProxyServer$get_uris(ptr))
    }
}
extension ProxyServer: Vectorizable {
    public static func vecOfSelfNew() -> UnsafeMutableRawPointer {
        __swift_bridge__$Vec_ProxyServer$new()
    }

    public static func vecOfSelfFree(vecPtr: UnsafeMutableRawPointer) {
        __swift_bridge__$Vec_ProxyServer$drop(vecPtr)
    }

    public static func vecOfSelfPush(vecPtr: UnsafeMutableRawPointer, value: ProxyServer) {
        __swift_bridge__$Vec_ProxyServer$push(vecPtr, {value.isOwned = false; return value.ptr;}())
    }

    public static func vecOfSelfPop(vecPtr: UnsafeMutableRawPointer) -> Self? {
        let pointer = __swift_bridge__$Vec_ProxyServer$pop(vecPtr)
        if pointer == nil {
            return nil
        } else {
            return (ProxyServer(ptr: pointer!) as! Self)
        }
    }

    public static func vecOfSelfGet(vecPtr: UnsafeMutableRawPointer, index: UInt) -> ProxyServerRef? {
        let pointer = __swift_bridge__$Vec_ProxyServer$get(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return ProxyServerRef(ptr: pointer!)
        }
    }

    public static func vecOfSelfGetMut(vecPtr: UnsafeMutableRawPointer, index: UInt) -> ProxyServerRefMut? {
        let pointer = __swift_bridge__$Vec_ProxyServer$get_mut(vecPtr, index)
        if pointer == nil {
            return nil
        } else {
            return ProxyServerRefMut(ptr: pointer!)
        }
    }

    public static func vecOfSelfLen(vecPtr: UnsafeMutableRawPointer) -> UInt {
        __swift_bridge__$Vec_ProxyServer$len(vecPtr)
    }
}
