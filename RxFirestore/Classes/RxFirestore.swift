import Foundation
import Firebase
import RxSwift

struct FirestoreError {
    // Note: Error codes upto 16 are default error codes
    static let batchSizeExceded = NSError(domain: FirestoreErrorDomain, code: 17, userInfo: [NSLocalizedDescriptionKey: "Batch size should be less than 500"])
}

extension Reactive where Base: DocumentReference {
    func getDocument() -> Single<DocumentSnapshot> {
        return Single.create { observer in
            self.base.getDocument(completion: { (snapshot, error) in
                if let `snapshot` = snapshot {
                    observer(.success(snapshot))
                } else if let `error` = error {
                    observer(.error(error))
                }
            })
            return Disposables.create()
        }
    }
    
    func set(_ documentData: [String: Any]) -> Single<Void> {
        return Single.create { observer in
            self.base.setData(documentData) { error in
                if let `error` = error {
                    observer(.error(error))
                    return
                }
                observer(.success(()))
            }
            return Disposables.create()
        }
    }
    
    func set(_ documentData: [String: Any], options: SetOptions) -> Single<Void> {
        return Single.create { observer in
            self.base.setData(documentData, options: options) { error in
                if let `error` = error {
                    observer(.error(error))
                    return
                }
                observer(.success(()))
            }
            return Disposables.create()
        }
    }
    
    func update(_ data: [String: Any]) -> Single<Void> {
        return Single.create { observer in
            self.base.updateData(data, completion: { (error) in
                if let `error` = error {
                    observer(.error(error))
                    return
                }
                observer(.success(()))
            })
            return Disposables.create()
        }
    }
    
    func delete() -> Single<Void> {
        return Single.create { observer in
            self.base.delete { error in
                if let `error` = error {
                    observer(.error(error))
                    return
                }
                observer(.success(()))
            }
            return Disposables.create()
        }
    }
    
    func listen(with options: DocumentListenOptions? = nil) -> Observable<DocumentSnapshot> {
        return Observable.create { observer in
            let listener = self.base.addSnapshotListener(options: options, listener: { (snapshot, error) in
                if let `snapshot` = snapshot {
                    observer.onNext(snapshot)
                } else if let `error` = error {
                    observer.onError(error)
                }
            })
            return Disposables.create { listener.remove() }
        }
    }
}

extension Reactive where Base: CollectionReference {
    func getDocuments() -> Single<QuerySnapshot> {
        return Single.create { observer in
            self.base.getDocuments(completion: { (snapshot, error) in
                if let `snapshot` = snapshot {
                    observer(.success(snapshot))
                } else if let `error` = error {
                    observer(.error(error))
                }
            })
            return Disposables.create()
        }
    }
    
    func add(_ document: [String: Any]) -> Single<DocumentReference> {
        return Single.create { observer in
            var ref: DocumentReference? = nil
            ref = self.base.addDocument(data: document) { error in
                if let `error` = error {
                    observer(.error(error))
                    return
                } else if let `ref` = ref {
                    observer(.success(ref))
                    return
                }
            }
            return Disposables.create()
        }
    }
    
    func deleteAll(_ batchLimit: Int = 100) -> Single<Void> {
        return Single.create { observer in
            if batchLimit > 500 { observer(.error(FirestoreError.batchSizeExceded)) }
            self.base.limit(to: batchLimit).getDocuments(completion: { (snapshot, error) in
                if let `error` = error {
                    observer(.error(error))
                    return
                }
                guard let `snapshot` = snapshot, !snapshot.isEmpty else {
                    observer(.success(()))
                    return
                }
                let batch = self.base.firestore.batch()
                snapshot.documents.forEach { batch.deleteDocument($0.reference) }
                batch.commit(completion: { error in
                    if let `error` = error {
                        observer(.error(error))
                        return
                    }
                    observer(.success(()))
                })
            })
            return Disposables.create()
        }
    }
}

extension Reactive where Base: Query {
    func getDocuments() -> Single<QuerySnapshot> {
        return Single.create { observer in
            self.base.getDocuments(completion: { (snapshot, error) in
                if let `snapshot` = snapshot {
                    observer(.success(snapshot))
                } else if let `error` = error {
                    observer(.error(error))
                }
            })
            return Disposables.create()
        }
    }
    
    func listen(with options: QueryListenOptions? = nil) -> Observable<QuerySnapshot> {
        return Observable.create { observer in
            let listener = self.base.addSnapshotListener(options: options, listener: { (snapshot, error) in
                if let `snapshot` = snapshot {
                    observer.onNext(snapshot)
                } else if let `error` = error {
                    observer.onError(error)
                }
            })
            return Disposables.create { listener.remove() }
        }
    }
}

extension Reactive where Base: WriteBatch {
    func commit() -> Single<Void> {
        return Single.create { observer in
            self.base.commit(completion: { error in
                if let `error` = error {
                    observer(.error(error))
                    return
                }
                observer(.success(()))
            })
            return Disposables.create()
        }
    }
}

extension Reactive where Base: Firestore {
    func runTransaction(_ updateBlock: @escaping (Transaction, NSErrorPointer) -> Any?) -> Single<Any> {
        return Single.create { observer in
            self.base.runTransaction(updateBlock, completion: { (object, error) in
                if let object = object {
                    observer(.success(object))
                } else if let `error` = error {
                    observer(.error(error))
                }
            })
            return Disposables.create()
        }
    }
}
